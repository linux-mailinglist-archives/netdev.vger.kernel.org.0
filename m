Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9653A1641
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbhFIN7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:59830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236957AbhFIN7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 09:59:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B032A61246;
        Wed,  9 Jun 2021 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623247044;
        bh=h6g0gYfjXeaCXXJ7vgG0rGy7l3BHXfQOCyFfliJl32I=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=tmtk8KXnN5AhZzrC8ww4TjwEzMWEcTZWQd6TPHhHz0B1zAV7hsOg/Cy3WPa92O3fj
         m7+EuJBy1l3hJ1DaYec5iiNt+u1QZXokMltMehUd3E/b5X5OSxziTwKFtdY6HGI8wE
         ybFEXWD7xB43fhOKfff4kFJeGfgbf49O7uxDm4/5l1EXgmaldWnQL4Pr5UfpbhM3nG
         lrX7v/b0UNWm4xcYUzi8KlJnm/6ZjZT0m1ZwTQsfGhSEXaf4TW81wCKcTlko5bm488
         fLC5RpX+S26wAPgqf1ZTF1t5qP1tHVeUR5Tm9w/fphmnH+suo3TuVWWZlGqt/ieZA2
         +jvwPWFYSJ2wA==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 81E985C039E; Wed,  9 Jun 2021 06:57:24 -0700 (PDT)
Date:   Wed, 9 Jun 2021 06:57:24 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>
Subject: Re: [PATCH bpf-next 05/17] ena: remove rcu_read_lock() around XDP
 program invocation
Message-ID: <20210609135724.GB4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-6-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-6-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:33:14PM +0200, Toke Høiland-Jørgensen wrote:
> The ena driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
> program invocations. However, the actual lifetime of the objects referred
> by the XDP program invocation is longer, all the way through to the call to
> xdp_do_flush(), making the scope of the rcu_read_lock() too small. This
> turns out to be harmless because it all happens in a single NAPI poll
> cycle (and thus under local_bh_disable()), but it makes the rcu_read_lock()
> misleading.
> 
> Rather than extend the scope of the rcu_read_lock(), just get rid of it
> entirely. With the addition of RCU annotations to the XDP_REDIRECT map
> types that take bh execution into account, lockdep even understands this to
> be safe, so there's really no reason to keep it around.

It might be worth adding a comment, perhaps where the rcu_read_lock()
used to be, stating what the protection is.  Maybe something like this?

	/*
	 * This code is invoked within a single NAPI poll cycle
	 * and thus under local_bh_disable(), which provides the
	 * needed RCU protection.
	 */

							Thanx, Paul

> Cc: Guy Tzalik <gtzalik@amazon.com>
> Cc: Saeed Bishara <saeedb@amazon.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 881f88754bf6..a4378b14af4c 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> @@ -385,7 +385,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  	u64 *xdp_stat;
>  	int qid;
>  
> -	rcu_read_lock();
>  	xdp_prog = READ_ONCE(rx_ring->xdp_bpf_prog);
>  
>  	if (!xdp_prog)
> @@ -443,8 +442,6 @@ static int ena_xdp_execute(struct ena_ring *rx_ring, struct xdp_buff *xdp)
>  
>  	ena_increase_stat(xdp_stat, 1, &rx_ring->syncp);
>  out:
> -	rcu_read_unlock();
> -
>  	return verdict;
>  }
>  
> -- 
> 2.31.1
> 

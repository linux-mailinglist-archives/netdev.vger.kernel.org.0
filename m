Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B473A1648
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237030AbhFIOA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 10:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:60408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236026AbhFIOA2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 10:00:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E77F6136D;
        Wed,  9 Jun 2021 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623247114;
        bh=Iej/SS6ZZXR0kLw4k+nvK51OFxHWK3hZtbvkG8dG6aI=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=iMLdS/3Em4spe5wvRHMiol3SxWgZxowVFR/m+7XgEt3cbH9UkdFnyKnSNXOnFLuA6
         DRsdQaczmESMXx0Mj+6F3rTZPw8K7/+7uOlXEnct1UFtMDN3ohcZ5j3cjgbsIQrCb1
         z/REDv/vvSRqg3ud9bQdGJ4KlrSCxaobHHtdfN5m9I5RK1wSRIeShR44dhAM+8KI65
         B/yUAgz6F/QbcbGOXWKJIC/tfTRxjgJnjGrfEWUqwLh0qJ4R19HkRXGyJTPEI7X9pU
         A4SCL0Mg3NSrskjnoLzLfcXEBZiJTeqUtjP8yHoKWAOQE6vuFxWerniXLuFperTLbU
         dvo5KiKp+1A5A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
        id 36A265C039E; Wed,  9 Jun 2021 06:58:34 -0700 (PDT)
Date:   Wed, 9 Jun 2021 06:58:34 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH bpf-next 06/17] bnxt: remove rcu_read_lock() around XDP
 program invocation
Message-ID: <20210609135834.GC4397@paulmck-ThinkPad-P17-Gen-1>
Reply-To: paulmck@kernel.org
References: <20210609103326.278782-1-toke@redhat.com>
 <20210609103326.278782-7-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609103326.278782-7-toke@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 09, 2021 at 12:33:15PM +0200, Toke Høiland-Jørgensen wrote:
> The bnxt driver has rcu_read_lock()/rcu_read_unlock() pairs around XDP
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

And same for the rest of these removals.  Someone might be very happy
to have that comment at some later date, and that someone just might
be you.  ;-)

							Thanx, Paul

> Cc: Michael Chan <michael.chan@broadcom.com>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index ec9564e584e0..bee6e091a997 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -138,9 +138,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
>  	xdp_prepare_buff(&xdp, *data_ptr - offset, offset, *len, false);
>  	orig_data = xdp.data;
>  
> -	rcu_read_lock();
>  	act = bpf_prog_run_xdp(xdp_prog, &xdp);
> -	rcu_read_unlock();
>  
>  	tx_avail = bnxt_tx_avail(bp, txr);
>  	/* If the tx ring is not full, we must not update the rx producer yet
> -- 
> 2.31.1
> 

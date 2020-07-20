Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359E4226DB5
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389200AbgGTR5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:57:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726699AbgGTR5Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:57:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 88ADD20709;
        Mon, 20 Jul 2020 17:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595267843;
        bh=/+152r+vFQYjCDZQB91lYNs2XjJh/Kx+vnJJBrGipGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WHUdfTkAij7EYyXMkDPiaNiupEdjYwwkOaiF3Mc5qMf96y+wHtqRr1EMflVmOYQm0
         LOysUiwwUhMPq6D4q2G8AKTqCZwP9/FdvdAJcW1wlXkJUFuGQrhR+n80HZnI4NEmbl
         RDmg6Z1lbsC9tVojDR2vqVm2ZqhEdKXfgMw2TzPY=
Date:   Mon, 20 Jul 2020 10:57:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@mellanox.com
Subject: Re: [PATCH net] netdevsim: fix unbalaced locking in nsim_create()
Message-ID: <20200720105721.4e034f53@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200718064921.9280-1-ap420073@gmail.com>
References: <20200718064921.9280-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Jul 2020 06:49:21 +0000 Taehee Yoo wrote:
> In the nsim_create(), rtnl_lock() is called before nsim_bpf_init().
> If nsim_bpf_init() is failed, rtnl_unlock() should be called,
> but it isn't called.
> So, unbalanced locking would occur.
> 
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/netdevsim/netdev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 2908e0a0d6e1..b2a67a88b6ee 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -316,8 +316,8 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
>  err_ipsec_teardown:
>  	nsim_ipsec_teardown(ns);
>  	nsim_bpf_uninit(ns);
> -	rtnl_unlock();
>  err_free_netdev:

Could you rename this label err_unlock, since it's not pointing to
free_netdev any more?

> +	rtnl_unlock();
>  	free_netdev(dev);
>  	return ERR_PTR(err);
>  }


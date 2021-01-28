Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CFAB308005
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231330AbhA1U4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:56:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229684AbhA1U4L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 15:56:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C12964DE5;
        Thu, 28 Jan 2021 20:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611867330;
        bh=N16a4iHiS4Uv9rxsOfL4YYZFZvWmoTWwhmJha52tq+o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=brGdo4CccwoLfC9lFFEJ3hkJkMRQqTCWKdwW7oH3AR+aq/f/nh0IPptDAzSVC+7wJ
         eYRQ2GiiSobptm5dIOSgbI2H4eWU0tTXWGiNyf+epDEvFfi3I11OnrSV3Thy7sb9MQ
         bIPHaLZOcZ+bqLNV9WVX9qKaRSnxlwH9/ti0s8oXOcBPCSHJQ2ZhrJXEy4c1pyi6hp
         IZHRAO1pjC6GfyXWlsQqEukm+gL/1tsvJstjRdSd/g/MWlzWuoMxFZFmQ8uHBN87uF
         ETM6LQy5l25j3M55PURDThXgMcQ5Usj4JXW5L6cK+3O9r/ktR1SQ5lpQ1Dg+twKLkg
         /IggE44xKE0sg==
Date:   Thu, 28 Jan 2021 12:55:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [Patch net] net: fix dev_ifsioc_locked() race condition
Message-ID: <20210128125529.5f902a5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
References: <20210124013049.132571-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jan 2021 17:30:49 -0800 Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> dev_ifsioc_locked() is called with only RCU read lock, so when
> there is a parallel writer changing the mac address, it could
> get a partially updated mac address, as shown below:
> 
> Thread 1			Thread 2
> // eth_commit_mac_addr_change()
> memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> 				// dev_ifsioc_locked()
> 				memcpy(ifr->ifr_hwaddr.sa_data,
> 					dev->dev_addr,...);
> 
> Close this race condition by guarding them with a RW semaphore,
> like netdev_get_name(). The writers take RTNL anyway, so this
> will not affect the slow path.
> 
> Fixes: 3710becf8a58 ("net: RCU locking for simple ioctl()")
> Reported-by: "Gong, Sishuai" <sishuai@purdue.edu>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

The addition of the write lock scares me a little for a fix, there's a
lot of code which can potentially run under the callbacks and notifiers
there.

What about using a seqlock?

> +static DECLARE_RWSEM(dev_addr_sem);
> +
>  /**
>   *	dev_set_mac_address - Change Media Access Control Address
>   *	@dev: device
> @@ -8729,19 +8731,50 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>  		return -EINVAL;
>  	if (!netif_device_present(dev))
>  		return -ENODEV;
> +
> +	down_write(&dev_addr_sem);
>  	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
>  	if (err)
> -		return err;
> +		goto out;
>  	err = ops->ndo_set_mac_address(dev, sa);
>  	if (err)
> -		return err;
> +		goto out;
>  	dev->addr_assign_type = NET_ADDR_SET;
>  	call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
>  	add_device_randomness(dev->dev_addr, dev->addr_len);
> -	return 0;
> +out:
> +	up_write(&dev_addr_sem);
> +	return err;
>  }

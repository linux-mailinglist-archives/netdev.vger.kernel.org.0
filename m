Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488A725EBBB
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 01:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728785AbgIEX1P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 19:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728103AbgIEX1P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 19:27:15 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 28E9A20760;
        Sat,  5 Sep 2020 23:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599348434;
        bh=A7EvWwYyZIg7QaFOdO9o87JScI5m8RkQBYiqzNGzEvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KITCRHBKnJrF02EID/fEfEJJHzcNhXJNfg4nlPbAzsMVxUDaKH5HD32plB5WvUD7Z
         hX9EVWnEpQ6buLJHZate6UPxCIe0g2QH/pOZZeaBGtE2P2zzLUZvwhRt8XZOhF+NaT
         KYASqugwvRhykwwJvBhofx9gVY+rNhRedN0Pf/+c=
Date:   Sat, 5 Sep 2020 16:27:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     wei.liu@kernel.org, kys@microsoft.com, haiyangz@microsoft.com,
        sthemmin@microsoft.com, davem@davemloft.net,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com
Subject: Re: [PATCH net] hv_netvsc: Fix hibernation for mlx5 VF driver
Message-ID: <20200905162712.65b886a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200905025218.45268-1-decui@microsoft.com>
References: <20200905025218.45268-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 19:52:18 -0700 Dexuan Cui wrote:
> mlx5_suspend()/resume() keep the network interface, so during hibernation
> netvsc_unregister_vf() and netvsc_register_vf() are not called, and hence
> netvsc_resume() should call netvsc_vf_changed() to switch the data path
> back to the VF after hibernation.

Does suspending the system automatically switch back to the synthetic
datapath? Please clarify this in the commit message and/or add a code
comment.

> Similarly, netvsc_suspend() should not call netvsc_unregister_vf().
> 
> BTW, mlx4_suspend()/resume() are differnt in that they destroy and
> re-create the network device, so netvsc_register_vf() and
> netvsc_unregister_vf() are automatically called. Note: mlx4 can also work
> with the changes here because in netvsc_suspend()/resume()
> ndev_ctx->vf_netdev is NULL for mlx4.
> 
> Fixes: 0efeea5fb153 ("hv_netvsc: Add the support of hibernation")
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index 64b0a74c1523..f896059a9588 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2587,7 +2587,7 @@ static int netvsc_remove(struct hv_device *dev)
>  static int netvsc_suspend(struct hv_device *dev)
>  {
>  	struct net_device_context *ndev_ctx;
> -	struct net_device *vf_netdev, *net;
> +	struct net_device *net;
>  	struct netvsc_device *nvdev;
>  	int ret;

Please keep reverse xmas tree variable ordering.

> @@ -2604,10 +2604,6 @@ static int netvsc_suspend(struct hv_device *dev)
>  		goto out;
>  	}
>  
> -	vf_netdev = rtnl_dereference(ndev_ctx->vf_netdev);
> -	if (vf_netdev)
> -		netvsc_unregister_vf(vf_netdev);
> -
>  	/* Save the current config info */
>  	ndev_ctx->saved_netvsc_dev_info = netvsc_devinfo_get(nvdev);
>  
> @@ -2623,6 +2619,7 @@ static int netvsc_resume(struct hv_device *dev)
>  	struct net_device *net = hv_get_drvdata(dev);
>  	struct net_device_context *net_device_ctx;
>  	struct netvsc_device_info *device_info;
> +	struct net_device *vf_netdev;
>  	int ret;
>  
>  	rtnl_lock();
> @@ -2635,6 +2632,10 @@ static int netvsc_resume(struct hv_device *dev)
>  	netvsc_devinfo_put(device_info);
>  	net_device_ctx->saved_netvsc_dev_info = NULL;
>  
> +	vf_netdev = rtnl_dereference(net_device_ctx->vf_netdev);
> +	if (vf_netdev && netvsc_vf_changed(vf_netdev) != NOTIFY_OK)
> +		ret = -EINVAL;

Should you perhaps remove the VF in case of the failure?

>  	rtnl_unlock();
>  
>  	return ret;


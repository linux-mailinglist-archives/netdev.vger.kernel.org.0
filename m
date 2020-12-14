Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03BDF2DA418
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 00:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgLNXWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 18:22:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388082AbgLNXWs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 18:22:48 -0500
Date:   Mon, 14 Dec 2020 15:22:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607988127;
        bh=IBjvHwlMhYOmFlIx61ksuuKjPB1fz/lCfhsZ1JLJfWE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=KfpKeKWJofviHUV7K9cobCQm0QlBbIBVF35a22Eu+Y0Q5VU604PAFR+TdaAGzb//O
         6ImUehuRR+kf/YxZXAAf4HqSRnfXi9nD+xcECS/Dtq1ASpd6XjP8XO/DPiz4SiTIHa
         B+OdcajAWLRPXBcf73fX4l50rb94DTnLrWX+51nS+lclrmvvJwFmaB3IydCphV7BUY
         z/SNlp9HJCQUtIXxp1GFgb5QEdHaII3Rk+9TO08IYYrJGCT9B19Ve/HWK8IKgDyuoL
         duClU4kLHBkFtwj38eAXRqGDSjAwMSNBlikiliQpmvMW2yqErzgVNyaAtwMVJGJgti
         jp2gtSOUcC9eg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>
Cc:     Lijun Pan <ljp@linux.ibm.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] use __netdev_notify_peers in hyperv
Message-ID: <20201214152206.6398dae1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214211930.80778-4-ljp@linux.ibm.com>
References: <20201214211930.80778-1-ljp@linux.ibm.com>
        <20201214211930.80778-4-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Dec 2020 15:19:30 -0600 Lijun Pan wrote:
> Start to use the lockless version of netdev_notify_peers.
> Call the helper where notify variable used to be set true.
> Remove the notify bool variable and sort the variables
> in reverse Christmas tree order.
> 
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
> v2: call the helper where notify variable used to be set true
>     according to Jakub's review suggestion.

Can we get an ack for merging via net-next?

> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index d17bbc75f5e7..f32f28311d57 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2050,11 +2050,11 @@ static void netvsc_link_change(struct work_struct *w)
>  		container_of(w, struct net_device_context, dwork.work);
>  	struct hv_device *device_obj = ndev_ctx->device_ctx;
>  	struct net_device *net = hv_get_drvdata(device_obj);
> +	unsigned long flags, next_reconfig, delay;
> +	struct netvsc_reconfig *event = NULL;
>  	struct netvsc_device *net_device;
>  	struct rndis_device *rdev;
> -	struct netvsc_reconfig *event = NULL;
> -	bool notify = false, reschedule = false;
> -	unsigned long flags, next_reconfig, delay;
> +	bool reschedule = false;
>  
>  	/* if changes are happening, comeback later */
>  	if (!rtnl_trylock()) {
> @@ -2103,7 +2103,7 @@ static void netvsc_link_change(struct work_struct *w)
>  			netif_carrier_on(net);
>  			netvsc_tx_enable(net_device, net);
>  		} else {
> -			notify = true;
> +			__netdev_notify_peers(net);
>  		}
>  		kfree(event);
>  		break;
> @@ -2132,9 +2132,6 @@ static void netvsc_link_change(struct work_struct *w)
>  
>  	rtnl_unlock();
>  
> -	if (notify)
> -		netdev_notify_peers(net);
> -
>  	/* link_watch only sends one notification with current state per
>  	 * second, handle next reconfig event in 2 seconds.
>  	 */


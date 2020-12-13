Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672F42D8ACF
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 02:22:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439975AbgLMBVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 20:21:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:56216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439967AbgLMBU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 20:20:59 -0500
Date:   Sat, 12 Dec 2020 17:20:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607822418;
        bh=r6+6Heo1vK+tQBnMtvCVcRGtyA29zDniv6CTS2cIYMs=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=YWNivtfDrw82ow74kyl2xwuwR9YGaN2uYW8GpY5vIkXwc5ujinpO4Wj3xRyC3o4YN
         sfFw4C0JwQk+NcGyspBvrgd3HxcWns4gBgEjVlQS9tgh0b4cvCZ0vOGO0pwYi6SEBD
         zG0A2KBf9neQSB9pnyXM+aF2CRsXTo4WOBvpqX1LOO09u1G7HSn5vxusSuzQ+w3EJx
         Ec/5y4HSv5HvEdevyqdNxnhDKEC7sfEWcvNvCgSXkYQebHwVoH4q/p1kdixiwqj4gI
         sGcquPFrxyJbpLKFtzlDuCJ/jQOqwy25UfqCBo2Zh7sEGb6MLG1ysQ/4wWo0Sv47R8
         AbVL5F8jvL3NQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH net-next 3/3] use __netdev_notify_peers in hyperv
Message-ID: <20201212172017.14b2cca6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201209061811.48524-4-ljp@linux.ibm.com>
References: <20201209061811.48524-1-ljp@linux.ibm.com>
        <20201209061811.48524-4-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Dec 2020 00:18:11 -0600 Lijun Pan wrote:
> Start to use the lockless version of netdev_notify_peers.
> 
> Cc: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index d17bbc75f5e7..4e3dac7bb944 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2130,10 +2130,10 @@ static void netvsc_link_change(struct work_struct *w)
>  		break;
>  	}
>  
> -	rtnl_unlock();
> -
>  	if (notify)
> -		netdev_notify_peers(net);
> +		__netdev_notify_peers(net);
> +
> +	rtnl_unlock();

Looks like this code is only using this "notify" variable because it
wanted to wait until unlock to call the function. I think you can now
just call the helper where notify used to be set to true.

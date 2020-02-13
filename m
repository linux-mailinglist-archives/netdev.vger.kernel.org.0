Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7012815CA67
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 19:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgBMSca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 13:32:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725781AbgBMSca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 13:32:30 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [199.201.64.135])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE4F222C2;
        Thu, 13 Feb 2020 18:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581618750;
        bh=Rwjgf/5L2jRWf6y1Nw0KE57Nl41sV5Slxmaal99CMPM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kZWNjC2xPi8k8/Pc5e2Tkiin7Sa/2ekIrh8Tmi0jdKv7iKYCnLihY8MXWsmtM8ONt
         Clf90QG0U75nwTYpcVFZNEzelJgporHf3r/VUMte7w6dKaha4aXQ96AMTP21tg3or7
         Jye56qWPD/HghGAOwot0XGy8daT5jtWl8XAaQMrg=
Date:   Thu, 13 Feb 2020 10:32:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Or Gerlitz <ogerlitz@mellanox.com>
Cc:     Tariq Toukan <tariqt@mellanox.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/tls: Act on going down event
Message-ID: <20200213103228.2123025f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200213165407.60140-1-ogerlitz@mellanox.com>
References: <20200213165407.60140-1-ogerlitz@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Feb 2020 16:54:07 +0000 Or Gerlitz wrote:
> By the time of the down event, the netdevice stop ndo was
> already called and the nic driver is likely to destroy the HW
> objects/constructs which are used for the tls_dev_resync op.
> 
> Instead, act on the going down event which is triggered before
> the stop ndo.
>
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> 
> compile tested only.

For a fix that you have hardware to test that is a little 
disappointing :(

> # vim net/core/dev.c +1555
>  *	This function moves an active device into down state. A
>  *	%NETDEV_GOING_DOWN is sent to the netdev notifier chain. The device
>  *	is then deactivated and finally a %NETDEV_DOWN is sent to the notifier chain.
> [..]
> void dev_close(struct net_device *dev)

As is quoting a comment rather than justifying changes based on the
code.

> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index 1ba5a92832bb..457c4b8352d8 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -1246,7 +1246,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
>  			return NOTIFY_DONE;
>  		else
>  			return NOTIFY_BAD;
> -	case NETDEV_DOWN:
> +	case NETDEV_GOING_DOWN:

Now we'll have two race conditions. 1. Traffic is still running while
we remove the connection state. 2. We clean out the state and then
close the device. Between the two new connections may be installed.

I think it's an inherently racy to only be able to perform clean up 
while the device is still up.

>  		return tls_device_down(dev);
>  	}
>  	return NOTIFY_DONE;

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4B73EBE64
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235335AbhHMWw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMWwz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:52:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB8E460F13;
        Fri, 13 Aug 2021 22:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628895148;
        bh=W/HryaeCif0NxndYVYWuG7EKalOs8HPuUDAwHgZGsvQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SH7UJxZVqITE1ctiveJoNXNxmJNXx3dT3PixxD4go8rGy8imxcL6uuOApLy6PH3b2
         AMDTWg5xgH019dl81pNvgFKnpRJ1jOugTqlQo7PojxvYa9DnT+1Mz+zAt+BOh03DiU
         NF6AIZpYgLWYDYLwNPrphys5KMFLNAt+cqfr78+Kf/qbH4dAYXQvWE0Km3qPrfVr4Z
         FDCxwZXyclgu47+3DUF3zPD47Dpm7NesSc7vrMXIq37Lk15Uoeq1MBwIJVdgBTohfw
         vHhDnoOpFpVIlBXkQbb0L0Pb6pDyMnIHoYbqjHpZxuiOGRsJr9syNnOtbGCbVqNBmX
         PcQzUwdH6OEcw==
Date:   Fri, 13 Aug 2021 15:52:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, linux@rempel-privat.de,
        himadrispandya@gmail.com, andrew@lunn.ch,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com,
        Robert Foss <robert.foss@collabora.com>,
        Vincent Palatin <vpalatin@chromium.org>
Subject: Re: [PATCH v2] net: asix: fix uninit value in asix_mdio_read
Message-ID: <20210813155226.651c74f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210813224219.11359-1-paskripkin@gmail.com>
References: <YRbw1psAc8jQu4ob@lunn.ch>
        <20210813224219.11359-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Aug 2021 01:42:19 +0300 Pavel Skripkin wrote:
> Syzbot reported uninit-value in asix_mdio_read(). The problem was in
> missing error handling. asix_read_cmd() should initialize passed stack
> variable smsr, but it can fail in some cases. Then while condidition
> checks possibly uninit smsr variable.
> 
> Since smsr is uninitialized stack variable, driver can misbehave,
> because smsr will be random in case of asix_read_cmd() failure.
> Fix it by adding error cheking and just continue the loop instead of
> checking uninit value.
> 
> Fixes: 8a46f665833a ("net: asix: Avoid looping when the device is disconnected")

This is not the right tag, the Fixes tag should point to the commit
where the problem is introduced. Robert/Vincent only added some error
checking, the issue was there before, right?

Once you locate the right starting point for the fix please make sure
to add the author to CC.

Thanks!

> Reported-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

>  drivers/net/usb/asix_common.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index ac92bc52a85e..7019c25e591c 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -468,18 +468,25 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
>  	struct usbnet *dev = netdev_priv(netdev);
>  	__le16 res;
>  	u8 smsr;
> -	int i = 0;
> +	int i;
>  	int ret;

nit: move i after ret, reverse xmas tree style

>  	mutex_lock(&dev->phy_mutex);
> -	do {
> +	for (i = 0; i < 30; ++i) {
>  		ret = asix_set_sw_mii(dev, 0);
>  		if (ret == -ENODEV || ret == -ETIMEDOUT)
>  			break;
>  		usleep_range(1000, 1100);
>  		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
>  				    0, 0, 1, &smsr, 0);
> -	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
> +		if (ret == -ENODEV)
> +			break;
> +		else if (ret < 0)
> +			continue;
> +		else if (smsr & AX_HOST_EN)
> +			break;
> +	}
> +
>  	if (ret == -ENODEV || ret == -ETIMEDOUT) {
>  		mutex_unlock(&dev->phy_mutex);
>  		return ret;

Code LGTM, do other functions which Robert/Vincent touched not need the
same treatment tho?

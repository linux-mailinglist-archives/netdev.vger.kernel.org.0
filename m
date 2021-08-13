Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290D3EBE40
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 00:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235218AbhHMWX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 18:23:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49342 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235029AbhHMWXz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 18:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=i5EM6xjmmLHbCrinG5m/aYEhgq7R3jsqXMJV7UntAEc=; b=R8PaH/Cl6PyLfSeXD0TV+UV5eF
        zXfiU9l4R3iCyiq13BXUVfymU6YUmhHIrS/83xu7ht6hvlge6NdCmj+aMfaxJgZVx9oU1U/uxIgKZ
        f4dOj5qoF6cbkuGuyu90GnWzeLOX79MjGTKMQwsJhH+uI/n1iPPj1445cnbapjmWgRVo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mEfaA-00HZUt-45; Sat, 14 Aug 2021 00:23:18 +0200
Date:   Sat, 14 Aug 2021 00:23:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        himadrispandya@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
Subject: Re: [PATCH] net: asix: fix uninit value in asix_mdio_read
Message-ID: <YRbw1psAc8jQu4ob@lunn.ch>
References: <20210813160108.17534-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813160108.17534-1-paskripkin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 07:01:08PM +0300, Pavel Skripkin wrote:
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
> Reported-and-tested-by: syzbot+a631ec9e717fb0423053@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> ---
>  drivers/net/usb/asix_common.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/usb/asix_common.c b/drivers/net/usb/asix_common.c
> index ac92bc52a85e..572ca3077f8f 100644
> --- a/drivers/net/usb/asix_common.c
> +++ b/drivers/net/usb/asix_common.c
> @@ -479,7 +479,13 @@ int asix_mdio_read(struct net_device *netdev, int phy_id, int loc)
>  		usleep_range(1000, 1100);
>  		ret = asix_read_cmd(dev, AX_CMD_STATMNGSTS_REG,
>  				    0, 0, 1, &smsr, 0);
> -	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
> +		if (ret == -ENODEV) {
> +			break;
> +		} else if (ret < 0) {
> +			++i;
> +			continue;
> +		}
> +	} while (!(smsr & AX_HOST_EN) && (i++ < 30));

No ret < 0, don't you end up with a double increment of i? So it will
only retry 15 times, not 30?

Humm.

If ret < 0 is true, smsr is uninitialized? The continue statement
causes a jump into the condition expression, where we evaluate smsr &
AX_HOST_EN. Isn't this just as broken as the original version?

      Andrew

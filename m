Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3BB1D24B1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:31:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbgENBbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:31:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59362 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENBbF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:31:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BjLQ49QKum4+vSDHMFusHjxHjeRJ8/csaPYATyH0Yv4=; b=6AH71IZbv54jY0S2UI6aTDlnm6
        jwVqEKqt+JdmJ55cM/53y4zmD7G5wcBJ+014SLmu3sXkZJZwOeGPfIrmDLWgrc7K5joN67LpRp3rm
        nHalb2J7CU2QdZ0ToLJyRv0xHVycMEk1sd8G0LnuXJ3hM30xIy5/8vgmT2NxTat4nIFQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ2iF-002EpV-Kv; Thu, 14 May 2020 03:31:03 +0200
Date:   Thu, 14 May 2020 03:31:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 13/19] net: ks8851: Split out SPI specific code from
 probe() and remove()
Message-ID: <20200514013103.GH527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-14-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-14-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 02:07:41AM +0200, Marek Vasut wrote:
> Factor out common code into ks8851_probe_common() and
> ks8851_remove_common() to permit both SPI and parallel
> bus driver variants to use the common code path for
> both probing and removal.
> 
> There should be no functional change.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Lukas Wunner <lukas@wunner.de>
> Cc: Petr Stetiar <ynezz@true.cz>
> Cc: YueHaibing <yuehaibing@huawei.com>
> ---
> V2: - Add RB from Andrew
>     - Rework on top of locking patches, drop RB
> V3: No change
> V4: No change
> V5: Pass message enable as parameter to common probe function,
>     so the MODULE_* bits can be per-driver
> ---
>  drivers/net/ethernet/micrel/ks8851.c | 86 ++++++++++++++++------------
>  1 file changed, 48 insertions(+), 38 deletions(-)
> 
> diff --git a/drivers/net/ethernet/micrel/ks8851.c b/drivers/net/ethernet/micrel/ks8851.c
> index 440ddd5cafbd..791b2f14dd9d 100644
> --- a/drivers/net/ethernet/micrel/ks8851.c
> +++ b/drivers/net/ethernet/micrel/ks8851.c
> @@ -1431,27 +1431,15 @@ static int ks8851_resume(struct device *dev)
>  
>  static SIMPLE_DEV_PM_OPS(ks8851_pm_ops, ks8851_suspend, ks8851_resume);
>  
> -static int ks8851_probe(struct spi_device *spi)
> +static int ks8851_probe_common(struct net_device *netdev, struct device *dev,
> +			       int msg_en)
>  {

>  
> -	dev_info(dev, "message enable is %d\n", msg_enable);
> +	dev_info(dev, "message enable is %d\n", msg_en);
>  
>  	/* set the default message enable */
> -	ks->msg_enable = netif_msg_init(msg_enable, (NETIF_MSG_DRV |
> -						     NETIF_MSG_PROBE |
> -						     NETIF_MSG_LINK));
> +	ks->msg_enable = netif_msg_init(msg_en, NETIF_MSG_DRV |
> +						NETIF_MSG_PROBE |
> +						NETIF_MSG_LINK);

It would of been nice to keep the name msg_en, then these changes
would not be needed. Or is there something not visible in this patch
which means the variable name it not usable?

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew

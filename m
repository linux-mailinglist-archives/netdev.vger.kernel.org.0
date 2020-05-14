Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE0341D24FD
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 03:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbgENB57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 21:57:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgENB57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 21:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sb4AffmucukD8Q3+CVXjaoZ/8MGF8I4u6TeJouD82hI=; b=CpesrAAMQM+E6i7xdrJwUR+HC1
        zFh5MOFFUOnyW5PRpeAYJm56808FPzcKNAy5k6ukmywTAfvU9o/89u6hCbIkhlizcH6vc1dEypW7c
        FYwBu6uPOTwZQo/h2jSlmvnTkzTdwbD0aCqXV70kgOcR+P0ql8XhLfZhfpaZX8ys9JvA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZ38D-002F0Z-VK; Thu, 14 May 2020 03:57:53 +0200
Date:   Thu, 14 May 2020 03:57:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Lukas Wunner <lukas@wunner.de>, Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V5 18/19] net: ks8851: Implement Parallel bus operations
Message-ID: <20200514015753.GL527401@lunn.ch>
References: <20200514000747.159320-1-marex@denx.de>
 <20200514000747.159320-19-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514000747.159320-19-marex@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/ethernet/micrel/ks8851_par.c b/drivers/net/ethernet/micrel/ks8851_par.c
> new file mode 100644
> index 000000000000..90fffacb1695
> --- /dev/null
> +++ b/drivers/net/ethernet/micrel/ks8851_par.c
> @@ -0,0 +1,348 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* drivers/net/ethernet/micrel/ks8851.c
> + *
> + * Copyright 2009 Simtec Electronics
> + *	http://www.simtec.co.uk/
> + *	Ben Dooks <ben@simtec.co.uk>
> + */
> +
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +
> +#define DEBUG

I don't think you wanted that left in.

> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/cache.h>
> +#include <linux/crc32.h>
> +#include <linux/mii.h>
> +#include <linux/regulator/consumer.h>
> +
> +#include <linux/platform_device.h>
> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>
> +#include <linux/of_net.h>

I think some of these includes can be removed. There is no regular, or
gpio code in this file, etc.

> +
> +#include "ks8851.h"
> +
> +static int msg_enable;
> +
> +#define BE3             0x8000      /* Byte Enable 3 */
> +#define BE2             0x4000      /* Byte Enable 2 */
> +#define BE1             0x2000      /* Byte Enable 1 */
> +#define BE0             0x1000      /* Byte Enable 0 */
> +
> +/**
> + * struct ks8851_net_par - KS8851 Parallel driver private data
> + * @ks8851: KS8851 driver common private data
> + * @lock: Lock to ensure that the device is not accessed when busy.
> + * @hw_addr	: start address of data register.
> + * @hw_addr_cmd	: start address of command register.
> + * @cmd_reg_cache	: command register cached.
> + *
> + * The @lock ensures that the chip is protected when certain operations are
> + * in progress. When the read or write packet transfer is in progress, most
> + * of the chip registers are not ccessible until the transfer is finished and

accessible 

> + * We do this to firstly avoid sleeping with the network device locked,
> + * and secondly so we can round up more than one packet to transmit which
> + * means we can try and avoid generating too many transmit done interrupts.
> + */
> +static netdev_tx_t ks8851_start_xmit_par(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	struct ks8851_net *ks = netdev_priv(dev);
> +	netdev_tx_t ret = NETDEV_TX_OK;
> +	unsigned long flags;
> +	u16 txmir;
> +
> +	netif_dbg(ks, tx_queued, ks->netdev,
> +		  "%s: skb %p, %d@%p\n", __func__, skb, skb->len, skb->data);
> +
> +	ks8851_lock_par(ks, &flags);
> +
> +	txmir = ks8851_rdreg16_par(ks, KS_TXMIR) & 0x1fff;
> +
> +	if (likely(txmir >= skb->len + 12)) {
> +		ks8851_wrreg16_par(ks, KS_RXQCR, ks->rc_rxqcr | RXQCR_SDA);
> +		ks8851_wrfifo_par(ks, skb, false);
> +		ks8851_wrreg16_par(ks, KS_RXQCR, ks->rc_rxqcr);
> +		ks8851_wrreg16_par(ks, KS_TXQCR, TXQCR_METFE);
> +		while (ks8851_rdreg16_par(ks, KS_TXQCR) & TXQCR_METFE)
> +			;

You should have a timeout/retry limit here, just in case.


> +		ks8851_done_tx(ks, skb);
> +	} else {
> +		ret = NETDEV_TX_BUSY;
> +	}
> +
> +	ks8851_unlock_par(ks, &flags);
> +
> +	return ret;
> +}

> +module_param_named(message, msg_enable, int, 0);
> +MODULE_PARM_DESC(message, "Message verbosity level (0=none, 31=all)");

Module parameters are bad. A new driver should not have one, if
possible. Please implement the ethtool .get_msglevel and .set_msglevel
instead.

	Andrew
 

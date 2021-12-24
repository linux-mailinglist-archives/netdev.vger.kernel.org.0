Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C588D47F098
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 19:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353444AbhLXShM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 13:37:12 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhLXShM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Dec 2021 13:37:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xku1QHcxVPF7fQRxfZSG+DY/O5O411+eXbfwYd9KIRw=; b=UVdIp3lrIqAmRHd29SdhaNPIM7
        YyqmsMahTjUGQkcr7FeY+gEl/TggTEQ4CNQWFfMNSkGiolHWOdbcOk7r0VyUSAUVGxPvCnebvoP0p
        61pV/RXF0lFht/LIs83jB4qqCrKffIlri9dUfGFwecpFV3zreQXJ75l7Zg9CTiTXz3vM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n0pR5-00HOWu-F8; Fri, 24 Dec 2021 19:36:59 +0100
Date:   Fri, 24 Dec 2021 19:36:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH v8, 2/2] net: Add dm9051 driver
Message-ID: <YcYTS2Mv6NufN9iL@lunn.ch>
References: <20211224101606.10125-1-josright123@gmail.com>
 <20211224101606.10125-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211224101606.10125-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +config DM9051
> +	tristate "DM9051 SPI support"
> +	select PHYLIB
> +	depends on SPI
> +	select CRC32
> +	select MII

Since you are using PHYLIB, you should not require MII.

> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/interrupt.h>
> +#include <linux/phy.h>
> +#include <linux/skbuff.h>
> +#include <linux/spinlock.h>
> +#include <linux/cache.h>
> +#include <linux/crc32.h>
> +#include <linux/mii.h>
> +#include <linux/ethtool.h>
> +#include <linux/delay.h>
> +#include <linux/irq.h>
> +#include <linux/slab.h>
> +#include <linux/gpio.h>
> +#include <linux/iopoll.h>
> +#include <linux/of_gpio.h>
> +#include <linux/spi/spi.h>
> +
> +#include "dm9051.h"
> +
> +static int msg_enable = NETIF_MSG_PROBE |
> +			NETIF_MSG_LINK |
> +			NETIF_MSG_IFDOWN |
> +			NETIF_MSG_IFUP |
> +			NETIF_MSG_RX_ERR |
> +			NETIF_MSG_TX_ERR;
> +
> +module_param(msg_enable, int, 0);
> +MODULE_PARM_DESC(msg_enable, "Message mask bitmapped");

No module parameters please. You have the need ethtool ops to control
this.

> +
> +/* spi low level code */
> +static inline int dm9051_xfer(struct board_info *db, u8 cmd, u8 *txb, u8 *rxb, unsigned int len)

No inline functions in C code, let the compiler decide.

> +{
> +	struct device *dev = &db->spidev->dev;
> +	int ret;
> +
> +	db->cmd[0] = cmd;
> +	db->spi_xfer2[0].tx_buf = &db->cmd[0];
> +	db->spi_xfer2[0].rx_buf = NULL;
> +	db->spi_xfer2[0].len = 1;
> +	if (!rxb) {
> +		db->spi_xfer2[1].tx_buf = txb;
> +		db->spi_xfer2[1].rx_buf = NULL;
> +		db->spi_xfer2[1].len = len;
> +	} else {
> +		db->spi_xfer2[1].tx_buf = txb;
> +		db->spi_xfer2[1].rx_buf = rxb;
> +		db->spi_xfer2[1].len = len;
> +	}

Nit pick, but i would invert the logic here, to make it more natural.

> +	ret = spi_sync(db->spidev, &db->spi_msg);
> +	if (ret < 0)
> +		dev_err(dev, "spi burst cmd 0x%02x, ret=%d\n", cmd, ret);
> +	return ret;
> +}
> +
> +static u8 dm9051_ior(struct board_info *db, unsigned int reg)
> +{
> +	int ret;
> +	u8 rxb[1];
> +
> +	ret = dm9051_xfer(db, DM_SPI_RD | reg, NULL, rxb, 1);
> +	if (ret < 0)
> +		return 0xff;

No, return the error code which dm9051_xfer() returns.

> +	return rxb[0];
> +}
> +
> +static void dm9051_iow(struct board_info *db, unsigned int reg, unsigned int val)
> +{
> +	u8 txb[1];
> +
> +	txb[0] = val;
> +	dm9051_xfer(db, DM_SPI_WR | reg, txb, NULL, 1);

This should be an int function, which returns 0, or the error code
which dm9051_xfer() returns.

> +}
> +
> +static int dm9051_inblk(struct board_info *db, u8 *buff, unsigned int len)
> +{
> +	int ret;
> +	u8 txb[1];
> +
> +	ret = dm9051_xfer(db, DM_SPI_RD | DM_SPI_MRCMD, txb, buff, len);
> +	return ret;
> +}
> +
> +static void dm9051_dumpblk(struct board_info *db, unsigned int len)
> +{
> +	while (len--)
> +		dm9051_ior(db, DM_SPI_MRCMD);

and here you need to look for an error from dm9051_ior() and return it
to the caller etc.

> +static int dm9051_phy_read(struct board_info *db, int reg, int *pvalue)
> +{
> +	int ret;
> +	u8 check_val;
> +
> +	dm9051_iow(db, DM9051_EPAR, DM9051_PHY | reg);
> +	dm9051_iow(db, DM9051_EPCR, EPCR_ERPRR | EPCR_EPOS);
> +	ret = read_poll_timeout(dm9051_ior, check_val, !(check_val & EPCR_ERRE), 100, 10000,
> +				true, db, DM9051_EPCR);
> +	dm9051_iow(db, DM9051_EPCR, 0x0);

> +	if (ret) {
> +		netdev_err(db->ndev, "timeout read phy register\n");
> +		return -ETIMEDOUT;
> +	}

You should check for an error before doing the dm9051_iow(). And don't
return -ETIMEDOUT, return whatever read_poll_timeout() returns as an
error code.

Your error handling in this driver needs a lot of work. Please improve
it for the next submission. Error codes need returning as far as
possible up the call stack.

	 Andrew

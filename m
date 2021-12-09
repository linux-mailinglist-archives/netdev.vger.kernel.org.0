Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EA346E972
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238206AbhLIN5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238204AbhLIN5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:57:13 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D9C0617A1;
        Thu,  9 Dec 2021 05:53:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 070FFCE25DC;
        Thu,  9 Dec 2021 13:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E0FC004DD;
        Thu,  9 Dec 2021 13:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639058015;
        bh=IkoYjFYwSgIGb1h6PAXZF+r0CsqV1xIDg7gWCjBL3Bo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ffRH7NrQlR5/gDfJjqiahs00/kO+nhPTdtlebmcUCJRyKfJm6q9r1n/5xVYkdydIy
         X6F9QX7MCncn5deMXHABA0H8TPnEiTxDN8tHlQvL8ul2pjaMc+gsDcjzJxKsLMCY4J
         2OaBSNdNVmQBv/YcExewg+IeC9w1azpwu1b6GBk7cZOQk5hbvCOERS6mLqfS95QYct
         Lrtlp6nnMdZvSeDGOVhSgBhNoogFsTe4J3SC+d9+CpoUfrWYCzGWbEigMFQ6w6j//q
         BTkr5UwhE1HKk8F7gs2GRZzM12hJUdpOEylanUczGaEQAqnVjVx60rF7RxF4NzHv7u
         FNpEpoeFeXfKQ==
Date:   Thu, 9 Dec 2021 15:53:31 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, joseph_chang@davicom.com.tw,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2, 2/2] net: Add DM9051 driver
Message-ID: <YbIKW9R5iyK7sQqg@unreal>
References: <20211209100702.5609-1-josright123@gmail.com>
 <20211209100702.5609-3-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211209100702.5609-3-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 09, 2021 at 06:07:02PM +0800, JosephCHANG wrote:
> Add davicom dm9051 SPI ethernet driver. The driver work with dts
> for:
> 
>      - spi bus number
>      - spi chip select
>      - spi clock frequency
>      - interrupt gpio pin
>      - interrupt polarity fixed as low
> 
>     Test OK with Rpi 2 and Rpi 4. Max spi speed is 31200000.

Please don't do this type of formatting, where you added extra
indentations without reason.

> 
> Signed-off-by: JosephCHANG <josright123@gmail.com>
> [Submit v1 has Reported-by: kernel test robot <lkp@intel.com>]
> ---
>  drivers/net/ethernet/davicom/Kconfig  |  30 +
>  drivers/net/ethernet/davicom/Makefile |   1 +
>  drivers/net/ethernet/davicom/dm9051.c | 967 ++++++++++++++++++++++++++
>  drivers/net/ethernet/davicom/dm9051.h | 248 +++++++
>  4 files changed, 1246 insertions(+)
>  create mode 100644 drivers/net/ethernet/davicom/dm9051.c
>  create mode 100644 drivers/net/ethernet/davicom/dm9051.h
> 
> diff --git a/drivers/net/ethernet/davicom/Kconfig b/drivers/net/ethernet/davicom/Kconfig
> index 7af86b6d4150..9c00328f6e05 100644
> --- a/drivers/net/ethernet/davicom/Kconfig
> +++ b/drivers/net/ethernet/davicom/Kconfig
> @@ -3,6 +3,20 @@
>  # Davicom device configuration
>  #
>  
> +config NET_VENDOR_DAVICOM
> +	bool "Davicom devices"
> +	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST || SPI
> +	default y
> +	help
> +	  If you have a network (Ethernet) card belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about Davicom devices. If you say Y, you will be asked
> +	  for your specific card in the following selections.
> +
> +if NET_VENDOR_DAVICOM
> +
>  config DM9000
>  	tristate "DM9000 support"
>  	depends on ARM || MIPS || COLDFIRE || NIOS2 || COMPILE_TEST
> @@ -22,3 +36,19 @@ config DM9000_FORCE_SIMPLE_PHY_POLL
>  	  bit to determine if the link is up or down instead of the more
>  	  costly MII PHY reads. Note, this will not work if the chip is
>  	  operating with an external PHY.
> +
> +config DM9051
> +	tristate "DM9051 SPI support"
> +	depends on SPI
> +	select CRC32
> +	select MII
> +	help
> +	  Support for DM9051 SPI chipset.
> +
> +	  To compile this driver as a module, choose M here.  The module
> +	  will be called dm9051.
> +
> +	  The SPI mode for the host's SPI master to access DM9051 is mode
> +	  0 on the SPI bus.
> +
> +endif # NET_VENDOR_DAVICOM
> diff --git a/drivers/net/ethernet/davicom/Makefile b/drivers/net/ethernet/davicom/Makefile
> index 173c87d21076..225f85bc1f53 100644
> --- a/drivers/net/ethernet/davicom/Makefile
> +++ b/drivers/net/ethernet/davicom/Makefile
> @@ -4,3 +4,4 @@
>  #
>  
>  obj-$(CONFIG_DM9000) += dm9000.o
> +obj-$(CONFIG_DM9051) += dm9051.o
> diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
> new file mode 100644
> index 000000000000..cdcf9d37ed7f
> --- /dev/null
> +++ b/drivers/net/ethernet/davicom/dm9051.c
> @@ -0,0 +1,967 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + *	Ethernet driver for the Davicom DM9051 chip.
> + *
> + *	This program is free software; you can redistribute it and/or
> + *	modify it under the terms of the GNU General Public License
> + *	as published by the Free Software Foundation; either version 2
> + *	of the License, or (at your option) any later version.
> + *
> + *	This program is distributed in the hope that it will be useful,
> + *	but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *	GNU General Public License for more details.

Please don't add license text. The SPDX line is more than enough.

> + *
> + *	Copyright 2021 Davicom Semiconductor,Inc.
> + *	http://www.davicom.com.tw/
> + *	Joseph CHANG <joseph_chang@davicom.com.tw>
> + *	20211110b, Total 933 lines
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/interrupt.h>
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
> +#define	DRV_PRODUCT_NAME	"dm9051"
> +#define	DRV_VERSION_CODE	DM_VERSION(5, 0, 5)			//(VER5.0.0= 0x050000)
> +#define	DRV_VERSION_DATE	"20211209"				//(update)"

Two points.
1. Try to avoid vertical alignment. It adds churn when backporting.
2. Don't add DRV_VERSION_CODE and DRV_VERSION_DATE. It is useless in
upstream kernel.

> +
> +/* spi-spi_sync, low level code */
> +static int burst_xfer(struct board_info *db, u8 cmdphase, u8 *txb, u8 *rxb, unsigned int len)
> +{
> +	struct device *dev = &db->spidev->dev;
> +	int ret = 0;
> +
> +	db->cmd[0] = cmdphase;
> +	db->spi_xfer2[0].tx_buf = &db->cmd[0];
> +	db->spi_xfer2[0].rx_buf = NULL;
> +	db->spi_xfer2[0].len = 1;
> +	if (!rxb) { //write

"//"is C++ coding style, which is also in C99 standard.
Is it ok to use such comment style in netdev?

<...>

> +	//rcr_reg_start(db, db->rcr_all); //rx enable later

I spotted many commented functions. They shouldn't be part of
submission.

<...>

> +static void dm_msg_open(struct net_device *ndev)
> +{
> +	struct board_info *db = netdev_priv(ndev);
> +	struct device *dev = &db->spidev->dev;
> +
> +	snprintf(db->DRV_VERSION, sizeof(db->DRV_VERSION), "%s_V%d.%d.%d_date_%s",
> +		 DRV_PRODUCT_NAME, (DRV_VERSION_CODE >> 16 & 0xff),
> +		 (DRV_VERSION_CODE >> 8 & 0xff),
> +		 (DRV_VERSION_CODE & 0xff),
> +		 DRV_VERSION_DATE);
> +	dev_info(dev, "version: %s\n", db->DRV_VERSION);
> +}

This should go.

<...>

> +++ b/drivers/net/ethernet/davicom/dm9051.h
> @@ -0,0 +1,248 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Copyright 2021 Davicom Semiconductor,Inc.
> + *	http://www.davicom.com.tw
> + *	2014/03/11  Joseph CHANG  v1.0  Create
> + *	2021/10/26  Joseph CHANG  v5.0.1  Update
> + *	2021/12/09  Joseph CHANG  v5.0.5  Update

It is new file, there is no value in off-tree history.

> + *
> + * DM9051 register definitions
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.

No need.

<...>

> +#define DM9051_PIDL		0x2A
> +#define DM9051_PIDH		0x2B
> +#define DM9051_SMCR		0x2F
> +#define	DM9051_ATCR		0x30
> +#define	DM9051_SPIBCR		0x38

Please be consistent.

Thanks

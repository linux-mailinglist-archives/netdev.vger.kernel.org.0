Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8E651AB463
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 01:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389030AbgDOXs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 19:48:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733274AbgDOXs4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 19:48:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xNSi6HaGmscxmARt5mgNwzUpQcF/jonukO+FRnCwvvs=; b=6awfTXYL7Q73QbBZWCu8TLLwdj
        odPxj6TI1yu/dT28BW340Acs8rG0u+HHboan/FDBlg2TH1RBzjer3dkrw5ckXCGh/kGlzKkMzs0ss
        ukBZAC/xlNhAHW4ham4rWvQqg8ig64WGQlrKmbdUF4HMZOsLA6u6KrXS5k+S4q/mBKhA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jOrls-002yQt-F4; Thu, 16 Apr 2020 01:48:44 +0200
Date:   Thu, 16 Apr 2020 01:48:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v3 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200415234844.GH611399@lunn.ch>
References: <20200415150244.2737206-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415150244.2737206-1-robert.marko@sartura.hr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Robert

I should of said this earlier. With a patch set, you should include a
cover note, patch 0 of X, explaining the big picture of what the
patches do.

Also, for network patches, the subject line should indicate which tree
these patches are for. So

[PATCH net-next v3 0/3] 

On Wed, Apr 15, 2020 at 05:02:43PM +0200, Robert Marko wrote:
> This patch adds the driver for the MDIO interface
> inside of Qualcomm IPQ40xx series SoC-s.
> 
> Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Cc: Luka Perkov <luka.perkov@sartura.hr>
> ---
> Changes from v2 to v3:
> * Rename registers
> * Remove unnecessary variable initialisations
> * Switch to readl_poll_timeout() instead of custom solution
> * Drop unused header
> 
> Changes from v1 to v2:
> * Remove magic default value
> * Remove lockdep_assert_held
> * Add C45 check
> * Simplify the driver
> * Drop device and mii_bus structs from private struct
> * Use devm_mdiobus_alloc_size()
> 
>  drivers/net/phy/Kconfig        |   7 ++
>  drivers/net/phy/Makefile       |   1 +
>  drivers/net/phy/mdio-ipq40xx.c | 160 +++++++++++++++++++++++++++++++++
>  3 files changed, 168 insertions(+)
>  create mode 100644 drivers/net/phy/mdio-ipq40xx.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index 3fa33d27eeba..23bb5db033e3 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -157,6 +157,13 @@ config MDIO_I2C
>  
>  	  This is library mode.
>  
> +config MDIO_IPQ40XX
> +	tristate "Qualcomm IPQ40xx MDIO interface"
> +	depends on HAS_IOMEM && OF_MDIO
> +	help
> +	  This driver supports the MDIO interface found in Qualcomm
> +	  IPQ40xx series Soc-s.
> +
>  config MDIO_IPQ8064
>  	tristate "Qualcomm IPQ8064 MDIO interface support"
>  	depends on HAS_IOMEM && OF_MDIO
> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 2f5c7093a65b..36aafc6128c4 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -37,6 +37,7 @@ obj-$(CONFIG_MDIO_CAVIUM)	+= mdio-cavium.o
>  obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
>  obj-$(CONFIG_MDIO_HISI_FEMAC)	+= mdio-hisi-femac.o
>  obj-$(CONFIG_MDIO_I2C)		+= mdio-i2c.o
> +obj-$(CONFIG_MDIO_IPQ40XX)	+= mdio-ipq40xx.o
>  obj-$(CONFIG_MDIO_IPQ8064)	+= mdio-ipq8064.o
>  obj-$(CONFIG_MDIO_MOXART)	+= mdio-moxart.o
>  obj-$(CONFIG_MDIO_MSCC_MIIM)	+= mdio-mscc-miim.o
> diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> new file mode 100644
> index 000000000000..acf1230341bd
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq40xx.c
> @@ -0,0 +1,160 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> +/* Copyright (c) 2020 Sartura Ltd. */
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/io.h>
> +#include <linux/iopoll.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +
> +#define MDIO_ADDR_REG				0x44
> +#define MDIO_DATA_WRITE_REG			0x48
> +#define MDIO_DATA_READ_REG			0x4c
> +#define MDIO_CMD_REG				0x50
> +#define MDIO_CMD_ACCESS_BUSY		BIT(16)
> +#define MDIO_CMD_ACCESS_START		BIT(8)
> +#define MDIO_CMD_ACCESS_CODE_READ	0
> +#define MDIO_CMD_ACCESS_CODE_WRITE	1
> +
> +#define IPQ40XX_MDIO_TIMEOUT	10000
> +#define IPQ40XX_MDIO_SLEEP		10
> +
> +struct ipq40xx_mdio_data {
> +	void __iomem	*membase;
> +};
> +
> +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	unsigned int busy;
> +
> +	return readl_poll_timeout(priv->membase + MDIO_CMD_REG, busy,
> +				  (busy & MDIO_CMD_ACCESS_BUSY) == 0, 
> +				  IPQ40XX_MDIO_SLEEP, IPQ40XX_MDIO_TIMEOUT);

Do you have any documentation about _START and _BUSY? You are making
the assumption that the next read after writing the START bit will
have the BUSY bit set. That the hardware reacts that fast. It is not
an unreasonable assumption, but i've seen more designed where the
START bit is also the BUSY bit, so the write implicitly sets the busy
bit, and the hardware needs to clear it when it is done.

As i said, this is not unreasonable, so:

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew


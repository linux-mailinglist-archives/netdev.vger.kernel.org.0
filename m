Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 804BB1A9906
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 11:34:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2895604AbgDOJdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 05:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2895596AbgDOJdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 05:33:52 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D494C061A0C;
        Wed, 15 Apr 2020 02:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CB95q0U4UuPiM6nQZ5HbjcNj7VGPk6sg9SK/YZr2Y2A=; b=RT3bIBBAPMnHkIktW9eMa8cCC
        uqGjonEHM4JQhPX8TijjW5fTPAiQE/gKV+86By4YCpaLk4Pn8RlfkMW+TJYSSS0dCh2cQyjp3AVlI
        j+82uCSHhgMXY9esoIyugbb0rhbz+am8ST9FTMSADQCaYq8v8QrXyRTk78QVaSd8OSz8baHju7z27
        SQDQzGOhUfWqO9s8mWGnidG/0ltIGk7ZlP2/PmUs3rp3NpWYTz/KOOEgHPIunESnM9olMoPK92TOW
        VDOEYWKU53tLn7YkQg11KOZ1LnHU5EmvOHlnC+JHUh/VPtW12LUhnqdyQoXMESG87YF8WlHXh1iIn
        hWWAbwcCg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:50358)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jOeQP-0005Sy-Kx; Wed, 15 Apr 2020 10:33:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jOeQI-0000nm-SM; Wed, 15 Apr 2020 10:33:34 +0100
Date:   Wed, 15 Apr 2020 10:33:34 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Marko <robert.marko@sartura.hr>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        agross@kernel.org, bjorn.andersson@linaro.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Christian Lamparter <chunkeey@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>
Subject: Re: [PATCH v2 1/3] net: phy: mdio: add IPQ40xx MDIO driver
Message-ID: <20200415093334.GC25745@shell.armlinux.org.uk>
References: <20200414181012.114905-1-robert.marko@sartura.hr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414181012.114905-1-robert.marko@sartura.hr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:10:11PM +0200, Robert Marko wrote:
> diff --git a/drivers/net/phy/mdio-ipq40xx.c b/drivers/net/phy/mdio-ipq40xx.c
> new file mode 100644
> index 000000000000..d8c11c621f20
> --- /dev/null
> +++ b/drivers/net/phy/mdio-ipq40xx.c
> @@ -0,0 +1,176 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +/* Copyright (c) 2015, The Linux Foundation. All rights reserved. */
> +/* Copyright (c) 2020 Sartura Ltd. */
> +
> +#include <linux/delay.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/io.h>
> +#include <linux/of_address.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +

Looking at how these registers are used, they could be renamed:

> +#define MDIO_CTRL_0_REG		0x40

This seems to be unused.

> +#define MDIO_CTRL_1_REG		0x44

MDIO_ADDR_REG

> +#define MDIO_CTRL_2_REG		0x48

MDIO_DATA_WRITE_REG

> +#define MDIO_CTRL_3_REG		0x4c

MDIO_DATA_READ_REG

> +#define MDIO_CTRL_4_REG		0x50
> +#define MDIO_CTRL_4_ACCESS_BUSY		BIT(16)
> +#define MDIO_CTRL_4_ACCESS_START		BIT(8)
> +#define MDIO_CTRL_4_ACCESS_CODE_READ		0
> +#define MDIO_CTRL_4_ACCESS_CODE_WRITE	1

MDIO_CMD_* ?

> +
> +#define IPQ40XX_MDIO_RETRY	1000
> +#define IPQ40XX_MDIO_DELAY	10
> +
> +struct ipq40xx_mdio_data {
> +	void __iomem	*membase;
> +};
> +
> +static int ipq40xx_mdio_wait_busy(struct mii_bus *bus)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	int i;
> +
> +	for (i = 0; i < IPQ40XX_MDIO_RETRY; i++) {
> +		unsigned int busy;
> +
> +		busy = readl(priv->membase + MDIO_CTRL_4_REG) &
> +			MDIO_CTRL_4_ACCESS_BUSY;
> +		if (!busy)
> +			return 0;
> +
> +		/* BUSY might take to be cleard by 15~20 times of loop */
> +		udelay(IPQ40XX_MDIO_DELAY);
> +	}
> +
> +	dev_err(bus->parent, "MDIO operation timed out\n");
> +
> +	return -ETIMEDOUT;
> +}
> +
> +static int ipq40xx_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	int value = 0;
> +	unsigned int cmd = 0;

No need to initialise either of these, and you can eliminate "value"
which will then satisfy davem's requirement for reverse-christmas-tree
ordering of variable declarations.

> +
> +	/* Reject clause 45 */
> +	if (regnum & MII_ADDR_C45)
> +		return -EOPNOTSUPP;
> +
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, priv->membase + MDIO_CTRL_1_REG);
> +
> +	cmd = MDIO_CTRL_4_ACCESS_START | MDIO_CTRL_4_ACCESS_CODE_READ;
> +
> +	/* issue read command */
> +	writel(cmd, priv->membase + MDIO_CTRL_4_REG);
> +
> +	/* Wait read complete */
> +	if (ipq40xx_mdio_wait_busy(bus))
> +		return -ETIMEDOUT;
> +
> +	/* Read data */
> +	value = readl(priv->membase + MDIO_CTRL_3_REG);
> +
> +	return value;
> +}
> +
> +static int ipq40xx_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> +							 u16 value)
> +{
> +	struct ipq40xx_mdio_data *priv = bus->priv;
> +	unsigned int cmd = 0;

No need to initialise cmd.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

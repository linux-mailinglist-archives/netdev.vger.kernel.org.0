Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1C73164B
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbfEaUwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:52:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46384 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfEaUwt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 16:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I47j1eCYvTfkVcXPfW71a2rg7gaYeCh9T96YCdR/qnA=; b=0YnOA4dXpgyvzLT+2Kyo+ReqSY
        35ctlyUTATLrABzBs8VFBrp8dq/CU3ki3Exvf78/2L12/6zwNkpR0DNUUs07BYxFBN9u3Q3UWVX0v
        sVfCjc2Beat3arwlR2XS/5mvwQan3KHUxcwnrs/H+qLxpXaeT+75rE7opyYFbPyCwOa4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hWoW6-00019E-LS; Fri, 31 May 2019 22:52:46 +0200
Date:   Fri, 31 May 2019 22:52:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: xilinx: add Xilinx PHY driver
Message-ID: <20190531205246.GB3154@lunn.ch>
References: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330150-30099-1-git-send-email-hancock@sedsystems.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 01:15:49PM -0600, Robert Hancock wrote:
> This adds a driver for the PHY device implemented in the Xilinx PCS/PMA
> Core logic. Aside from being a generic gigabit PHY, it includes an
> important register setting to disable the PHY isolation bit, which is
> required for the PHY to operate in 1000BaseX mode.
> 
> This version is a simplified version of the GPL 2+ version from the
> Xilinx kernel tree.
> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/Kconfig      |  6 +++++
>  drivers/net/phy/Makefile     |  1 +
>  drivers/net/phy/xilinx_phy.c | 60 ++++++++++++++++++++++++++++++++++++++++++++

Hi Robert

Please drop the _phy . No other driver does that.

>  3 files changed, 67 insertions(+)
>  create mode 100644 drivers/net/phy/xilinx_phy.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index db5645b..101c794 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -462,6 +462,12 @@ config VITESSE_PHY
>  	---help---
>  	  Currently supports the vsc8244
>  
> +config XILINX_PHY
> +	tristate "Drivers for Xilinx PHYs"
> +	help
> +	  This module provides a driver for the PHY implemented in the
> +	  Xilinx PCS/PMA Core.
> +
>  config XILINX_GMII2RGMII
>  	tristate "Xilinx GMII2RGMII converter driver"
>  	---help---

> index bac339e..f71359d 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -92,3 +92,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
>  obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
>  obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
>  obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
> +obj-$(CONFIG_XILINX_PHY)	+= xilinx_phy.o

In kconfig you added it before CONFIG_XILINX_GMII2RGMII. Here you have
it afterwards. Please be consistent.

> diff --git a/drivers/net/phy/xilinx_phy.c b/drivers/net/phy/xilinx_phy.c
> new file mode 100644
> index 0000000..2d468c7
> --- /dev/null
> +++ b/drivers/net/phy/xilinx_phy.c
> @@ -0,0 +1,60 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +/* Xilinx PCS/PMA Core phy driver
> + *
> + * Copyright (C) 2019 SED Systems, a division of Calian Ltd.
> + *
> + * Based upon Xilinx version of this driver:
> + * Copyright (C) 2015 Xilinx, Inc.
> + *
> + * Description:
> + * This driver is developed for PCS/PMA Core.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mii.h>
> +#include <linux/phy.h>
> +
> +/* Mask used for ID comparisons */
> +#define XILINX_PHY_ID_MASK		0xfffffff0
> +
> +/* Known PHY IDs */
> +#define XILINX_PHY_ID			0x01740c00
> +
> +#define XPCSPMA_PHY_CTRL_ISOLATE_DISABLE 0xFBFF

> +static int xilinxphy_config_init(struct phy_device *phydev)

Please drop the phy here as well.

> +{
> +	int temp;
> +
> +	temp = phy_read(phydev, MII_BMCR);
> +	temp &= XPCSPMA_PHY_CTRL_ISOLATE_DISABLE;
> +	phy_write(phydev, MII_BMCR, temp);

    phy_modify(phydev, MII_BMCR, BMCR_ISOLATE);

> +
> +	return 0;
> +}
> +
> +static struct phy_driver xilinx_drivers[] = {
> +{
> +	.phy_id		= XILINX_PHY_ID,
> +	.phy_id_mask	= XILINX_PHY_ID_MASK,
> +	.name		= "Xilinx PCS/PMA PHY",
> +	.features	= PHY_GBIT_FEATURES,

Assuming the PHY follows C22 standards, that is not needed. The PHY
itself tells you what it is capable of.

       Andrew

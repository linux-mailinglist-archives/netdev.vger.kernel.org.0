Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E403ED803
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhHPN5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 09:57:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51986 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231142AbhHPN5H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 09:57:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=9DiDydqTOPPS0FSwIW26JQmOS6UG6Q0l2zcE2t6QNNs=; b=Xk
        2akKzRa4a3DHKt1sKHTwCKf2lye6qWjB4aFu+MoYbE8gBAfEmW+iSgk7dkzpDAUX5zu1i0O1+2vkj
        AMmfKJON6HsnwFFFAQH/HTFI1E2TO+py0xetN2wBc1g/IpEwXnNyozT18PdbUu2WpezEA00j0w8ht
        32rQl/vKmndPigU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mFd6C-000Oly-Rn; Mon, 16 Aug 2021 15:56:20 +0200
Date:   Mon, 16 Aug 2021 15:56:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH] net: phy: add qca8081 ethernet phy driver
Message-ID: <YRpuhIcwN2IsaHzy@lunn.ch>
References: <20210816113440.22290-1-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210816113440.22290-1-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 07:34:40PM +0800, Luo Jie wrote:
> qca8081 is industry’s lowest cost and power 1-port 2.5G/1G Ethernet PHY
> chip, which implements SGMII/SGMII+ for interface to SoC.

Hi Luo

No Marketing claims in the commit message please. Even if it is
correct now, it will soon be wrong with newer generations of
devices.

And what is SGMII+? Please reference a document. Is it actually
2500BaseX?

> Signed-off-by: Luo Jie <luoj@codeaurora.org>
> ---
>  drivers/net/phy/Kconfig   |   6 +
>  drivers/net/phy/Makefile  |   1 +
>  drivers/net/phy/qca808x.c | 573 ++++++++++++++++++++++++++++++++++++++
>  3 files changed, 580 insertions(+)
>  create mode 100644 drivers/net/phy/qca808x.c
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index c56f703ae998..26cb1c2ffd17 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -343,3 +343,9 @@ endif # PHYLIB
>  config MICREL_KS8995MA
>  	tristate "Micrel KS8995MA 5-ports 10/100 managed Ethernet switch"
>  	depends on SPI
> +
> +config QCA808X_PHY
> +	tristate "Qualcomm Atheros QCA808X PHYs"
> +	depends on REGULATOR
> +	help
> +	  Currently supports the QCA8081 model

This file is sorted on the tristate text. So it should appear directly
after AT803X_PHY.

> diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> index 172bb193ae6a..9ef477d79588 100644
> --- a/drivers/net/phy/Makefile
> +++ b/drivers/net/phy/Makefile
> @@ -84,3 +84,4 @@ obj-$(CONFIG_STE10XP)		+= ste10Xp.o
>  obj-$(CONFIG_TERANETICS_PHY)	+= teranetics.o
>  obj-$(CONFIG_VITESSE_PHY)	+= vitesse.o
>  obj-$(CONFIG_XILINX_GMII2RGMII) += xilinx_gmii2rgmii.o
> +obj-$(CONFIG_QCA808X_PHY)	+= qca808x.o

And this file is sorted by CONFIG_ so should be after
CONFIG_NXP_TJA11XX_PHY.

Keeping things sorted reduces the likelyhood of a merge conflict.

> +#include <linux/module.h>
> +#include <linux/etherdevice.h>
> +#include <linux/phy.h>
> +#include <linux/bitfield.h>
> +
> +#define QCA8081_PHY_ID					0x004DD101
> +
> +/* MII special status */
> +#define QCA808X_PHY_SPEC_STATUS				0x11
> +#define QCA808X_STATUS_FULL_DUPLEX			BIT(13)
> +#define QCA808X_STATUS_LINK_PASS			BIT(10)
> +#define QCA808X_STATUS_SPEED_MASK			GENMASK(9, 7)
> +#define QCA808X_STATUS_SPEED_100MBS			1
> +#define QCA808X_STATUS_SPEED_1000MBS			2
> +#define QCA808X_STATUS_SPEED_2500MBS			4
> +
> +/* MII interrupt enable & status */
> +#define QCA808X_PHY_INTR_MASK				0x12
> +#define QCA808X_PHY_INTR_STATUS				0x13
> +#define QCA808X_INTR_ENABLE_FAST_RETRAIN_FAIL		BIT(15)
> +#define QCA808X_INTR_ENABLE_SPEED_CHANGED		BIT(14)
> +#define QCA808X_INTR_ENABLE_DUPLEX_CHANGED		BIT(13)
> +#define QCA808X_INTR_ENABLE_PAGE_RECEIVED		BIT(12)
> +#define QCA808X_INTR_ENABLE_LINK_FAIL			BIT(11)
> +#define QCA808X_INTR_ENABLE_LINK_SUCCESS		BIT(10)
> +#define QCA808X_INTR_ENABLE_POE				BIT(1)
> +#define QCA808X_INTR_ENABLE_WOL				BIT(0)
> +
> +/* MII DBG address & data */
> +#define QCA808X_PHY_DEBUG_ADDR				0x1d
> +#define QCA808X_PHY_DEBUG_DATA				0x1e
> +

A lot of these registers look the same as the at803x. So i'm thinking
you should merge these two drivers. There is a lot of code which is
identical, or very similar, which you can share.

> +static int qca808x_get_2500caps(struct phy_device *phydev)
> +{
> +	int phy_data;
> +
> +	phy_data = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, QCA808X_PHY_MMD1_PMA_CAP_REG);
> +
> +	return (phy_data & QCA808X_STATUS_2500T_FD_CAPS) ? 1 : 0;

So the PHY ignores the standard and does not set bit
MDIO_PMA_NG_EXTABLE_2_5GBT in MDIO_MMD_PMAPMD, MDIO_PMA_NG_EXTABLE ?
Please compare the registers against the standards. If they are
actually being followed, please you the linux names for these
registers, and try to use the generic code.

> +static int qca808x_phy_ms_random_seed_set(struct phy_device *phydev)
> +{
> +	u16 seed_value = (prandom_u32() % QCA808X_MASTER_SLAVE_SEED_RANGE) << 2;
> +
> +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
> +			QCA808X_MASTER_SLAVE_SEED_CFG, seed_value);
> +}
> +
> +static int qca808x_phy_ms_seed_enable(struct phy_device *phydev, bool enable)
> +{
> +	u16 seed_enable = 0;
> +
> +	if (enable)
> +		seed_enable = QCA808X_MASTER_SLAVE_SEED_ENABLE;
> +
> +	return qca808x_debug_reg_modify(phydev, QCA808X_PHY_DEBUG_LOCAL_SEED,
> +			QCA808X_MASTER_SLAVE_SEED_ENABLE, seed_enable);
> +}

This is interesting. I've not seen any other PHY does this. is there
documentation? Is the datasheet available?

> +static int qca808x_soft_reset(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = genphy_soft_reset(phydev);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (phydev->autoneg == AUTONEG_DISABLE) {
> +		ret = qca808x_speed_forced(phydev);
> +		if (ret)
> +			return ret;

That is unusual. After a reset, you would expect the config_aneg()
function to be called, and it should set things like this. Why is it
needed?

I don't see anything handling the host side. Generally, devices like
this use SGMII for 10/100/1G. When 2.5G is in use they swap their host
interface to 2500BaseX. See mv3310_update_interface() as an example.

	  Andrew

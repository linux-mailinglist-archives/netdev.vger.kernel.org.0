Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50650652258
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232371AbiLTOVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233892AbiLTOVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:21:21 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91DEB1C13A;
        Tue, 20 Dec 2022 06:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Ed6VG1SUV9HFxf34JgZ6AH3VGOZoZxogcfSaZTFZm9I=; b=zAdj56n/Xxduddp9qDLpkEzYSc
        GnDJte7DR8iWrFBthqvUh9jK2fKMPqeibjs/Ziu0nfsyDa/X/gKY3QQ8E82ryLF/ubmXUzxSLCv8l
        awdDAhSCnEKeP472VhCIcVoS/RJA89fzgYItFYUi6TAVto2IF1J7F+pHorubC+Y0Jc9A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p7dTg-0005wx-3p; Tue, 20 Dec 2022 15:20:20 +0100
Date:   Tue, 20 Dec 2022 15:20:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Subject: Re: [PATCH v2 6/9] net: phy: motorcomm: Add YT8531 phy support
Message-ID: <Y6HEpHBpK83f8UCw@lunn.ch>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-7-yanhong.wang@starfivetech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221216070632.11444-7-yanhong.wang@starfivetech.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  drivers/net/phy/Kconfig     |   3 +-
>  drivers/net/phy/motorcomm.c | 202 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 204 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
> index c57a0262fb64..86399254d9ff 100644
> --- a/drivers/net/phy/Kconfig
> +++ b/drivers/net/phy/Kconfig
> @@ -258,9 +258,10 @@ config MICROSEMI_PHY
>  
>  config MOTORCOMM_PHY
>  	tristate "Motorcomm PHYs"
> +	default SOC_STARFIVE

Please don't do this. Look at the other PHY drivers. How many have a
default like this?

Generally, if you are doing something which no other driver does, you
are doing something wrong.

> --- a/drivers/net/phy/motorcomm.c
> +++ b/drivers/net/phy/motorcomm.c
> @@ -3,13 +3,17 @@
>   * Driver for Motorcomm PHYs
>   *
>   * Author: Peter Geis <pgwipeout@gmail.com>
> + *
>   */

Please avoid changes like this. It distracts from the real code
changes.

>  
> +#include <linux/bitops.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
>  #include <linux/phy.h>
>  
>  #define PHY_ID_YT8511		0x0000010a
> +#define PHY_ID_YT8531		0x4f51e91b
>  
>  #define YT8511_PAGE_SELECT	0x1e
>  #define YT8511_PAGE		0x1f
> @@ -17,6 +21,10 @@
>  #define YT8511_EXT_DELAY_DRIVE	0x0d
>  #define YT8511_EXT_SLEEP_CTRL	0x27
>  
> +#define YTPHY_EXT_SMI_SDS_PHY		0xa000
> +#define YTPHY_EXT_CHIP_CONFIG		0xa001
> +#define YTPHY_EXT_RGMII_CONFIG1	0xa003
> +
>  /* 2b00 25m from pll
>   * 2b01 25m from xtl *default*
>   * 2b10 62.m from pll
> @@ -38,6 +46,51 @@
>  #define YT8511_DELAY_FE_TX_EN	(0xf << 12)
>  #define YT8511_DELAY_FE_TX_DIS	(0x2 << 12)
>  
> +struct ytphy_reg_field {
> +	char *name;
> +	u32 mask;
> +	u8	dflt;	/* Default value */
> +};

This should be next to where it is used. But once you have delay in
ps, i suspect you will throw this away.

>  
> +static int ytphy_config_init(struct phy_device *phydev)

Is this specific to the 8531? If so, put 8531 in the function name?

Do any of these delay configurations also apply to the 8511?

> +{
> +	struct device_node *of_node;
> +	u32 val;
> +	u32 mask;
> +	u32 cfg;
> +	int ret;
> +	int i = 0;

Reverse Christmas tree. i needs to be earlier, val needs to be later.

> +	of_node = phydev->mdio.dev.of_node;
> +	if (of_node) {
> +		ret = of_property_read_u32(of_node, ytphy_rxden_grp[0].name, &cfg);
> +		if (!ret) {
> +			mask = ytphy_rxden_grp[0].mask;
> +			val = ytphy_read_ext(phydev, YTPHY_EXT_CHIP_CONFIG);
> +
> +			/* check the cfg overflow or not */
> +			cfg = cfg > mask >> (ffs(mask) - 1) ? mask : cfg;
> +
> +			val &= ~mask;
> +			val |= FIELD_PREP(mask, cfg);
> +			ytphy_write_ext(phydev, YTPHY_EXT_CHIP_CONFIG, val);
> +		}
> +
> +		val = ytphy_read_ext(phydev, YTPHY_EXT_RGMII_CONFIG1);
> +		for (i = 0; i < ARRAY_SIZE(ytphy_rxtxd_grp); i++) {
> +			ret = of_property_read_u32(of_node, ytphy_rxtxd_grp[i].name, &cfg);
> +			if (!ret) {
> +				mask = ytphy_rxtxd_grp[i].mask;
> +
> +				/* check the cfg overflow or not */
> +				cfg = cfg > mask >> (ffs(mask) - 1) ? mask : cfg;
> +
> +				val &= ~mask;
> +				val |= cfg << (ffs(mask) - 1);
> +			}
> +		}
> +		return ytphy_write_ext(phydev, YTPHY_EXT_RGMII_CONFIG1, val);
> +	}
> +
> +	phydev_err(phydev, "Get of node fail\n");

What about the case of the PHY is used on a board without device tree?
ACPI could be used, or there could be nothing because it is on a USB
dongle etc.

You should of defined in your device tree binding what the defaults
are when properties are missing. So apply them when there is no DT
available. Then we at least have the PHY in a known state.

       Andrew

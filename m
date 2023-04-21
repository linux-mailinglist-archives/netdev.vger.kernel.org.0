Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8E6EADF1
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbjDUPWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 11:22:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232810AbjDUPWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 11:22:47 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A088CBBB8;
        Fri, 21 Apr 2023 08:22:44 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.96)
        (envelope-from <daniel@makrotopia.org>)
        id 1ppsaS-0001Qt-1f;
        Fri, 21 Apr 2023 17:22:12 +0200
Date:   Fri, 21 Apr 2023 16:22:07 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     arinc9.unal@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [RFC PATCH net-next 03/22] net: dsa: mt7530: properly support
 MT7531AE and MT7531BE
Message-ID: <ZEKqH2oELsJKANkh@makrotopia.org>
References: <20230421143648.87889-1-arinc.unal@arinc9.com>
 <20230421143648.87889-4-arinc.unal@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230421143648.87889-4-arinc.unal@arinc9.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:36:29PM +0300, arinc9.unal@gmail.com wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> Introduce the p5_sgmii pointer to store the information for whether port 5
> has got SGMII or not. Print "found MT7531AE" if it's got it, print "found
> MT7531BE" if it hasn't.
> 
> Move the comment about MT7531AE and MT7531BE to mt7531_setup(), where the
> switch is identified.
> 
> Get rid of mt7531_dual_sgmii_supported() now that priv->p5_sgmii stores the
> information. Address the code where mt7531_dual_sgmii_supported() is used.
> 
> Get rid of mt7531_is_rgmii_port() which just prints the opposite of
> priv->p5_sgmii.
> 
> Remove P5_INTF_SEL_GMAC5_SGMII. The p5_interface_select enum is supposed to
> represent the mode that port 5 is used in, not the hardware information of
> port 5. Set p5_intf_sel to P5_INTF_SEL_GMAC5 instead, if port 5 is not
> dsa_is_unused_port().
> 
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> ---
>  drivers/net/dsa/mt7530-mdio.c |  7 ++---
>  drivers/net/dsa/mt7530.c      | 49 +++++++++++++++--------------------
>  drivers/net/dsa/mt7530.h      |  6 +++--
>  3 files changed, 27 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
> index 088533663b83..fa3ee85a99c1 100644
> --- a/drivers/net/dsa/mt7530-mdio.c
> +++ b/drivers/net/dsa/mt7530-mdio.c
> @@ -81,17 +81,14 @@ static const struct regmap_bus mt7530_regmap_bus = {
>  };
>  
>  static int
> -mt7531_create_sgmii(struct mt7530_priv *priv, bool dual_sgmii)
> +mt7531_create_sgmii(struct mt7530_priv *priv)
>  {
>  	struct regmap_config *mt7531_pcs_config[2] = {};
>  	struct phylink_pcs *pcs;
>  	struct regmap *regmap;
>  	int i, ret = 0;
>  
> -	/* MT7531AE has two SGMII units for port 5 and port 6
> -	 * MT7531BE has only one SGMII unit for port 6
> -	 */
> -	for (i = dual_sgmii ? 0 : 1; i < 2; i++) {
> +	for (i = priv->p5_sgmii ? 0 : 1; i < 2; i++) {
>  		mt7531_pcs_config[i] = devm_kzalloc(priv->dev,
>  						    sizeof(struct regmap_config),
>  						    GFP_KERNEL);
> diff --git a/drivers/net/dsa/mt7530.c b/drivers/net/dsa/mt7530.c
> index c680873819b0..edc34be745b2 100644
> --- a/drivers/net/dsa/mt7530.c
> +++ b/drivers/net/dsa/mt7530.c
> @@ -473,15 +473,6 @@ mt7530_pad_clk_setup(struct dsa_switch *ds, phy_interface_t interface)
>  	return 0;
>  }
>  
> -static bool mt7531_dual_sgmii_supported(struct mt7530_priv *priv)
> -{
> -	u32 val;
> -
> -	val = mt7530_read(priv, MT7531_TOP_SIG_SR);
> -
> -	return (val & PAD_DUAL_SGMII_EN) != 0;
> -}
> -
>  static int
>  mt7531_pad_setup(struct dsa_switch *ds, phy_interface_t interface)
>  {
> @@ -496,7 +487,7 @@ mt7531_pll_setup(struct mt7530_priv *priv)
>  	u32 xtal;
>  	u32 val;
>  
> -	if (mt7531_dual_sgmii_supported(priv))
> +	if (priv->p5_sgmii)
>  		return;
>  
>  	val = mt7530_read(priv, MT7531_CREV);
> @@ -907,8 +898,6 @@ static const char *p5_intf_modes(unsigned int p5_interface)
>  		return "PHY P4";
>  	case P5_INTF_SEL_GMAC5:
>  		return "GMAC5";
> -	case P5_INTF_SEL_GMAC5_SGMII:
> -		return "GMAC5_SGMII";
>  	default:
>  		return "unknown";
>  	}
> @@ -2440,6 +2429,18 @@ mt7531_setup(struct dsa_switch *ds)
>  		return -ENODEV;
>  	}
>  
> +	/* MT7531AE has got two SGMII units. One for port 5, one for port 6.
> +	 * MT7531BE has got only one SGMII unit which is for port 6.
> +	 */
> +	val = mt7530_read(priv, MT7531_TOP_SIG_SR);
> +
> +	if ((val & PAD_DUAL_SGMII_EN) != 0) {
> +		priv->p5_sgmii = true;
> +		dev_info(priv->dev, "found MT7531AE\n");
> +	} else {
> +		dev_info(priv->dev, "found MT7531BE\n");

I don't think dev_info is useful here for regular users.
If you really want this output, use dev_dbg to reduce log pollution.
Imho completely removing the else branch and only silently
setting priv->p5_sgmii is sufficient, as users can also turn on
dyndbg for drivers/net/pcs/pcs-mtk-lynxi.c and will then be informed
about the created SGMII/1000Base-X/2500Base-X PCS instances.


> +	}
> +
>  	/* all MACs must be forced link-down before sw reset */
>  	for (i = 0; i < MT7530_NUM_PORTS; i++)
>  		mt7530_write(priv, MT7530_PMCR_P(i), MT7531_FORCE_LNK);
> @@ -2451,19 +2452,16 @@ mt7531_setup(struct dsa_switch *ds)
>  
>  	mt7531_pll_setup(priv);
>  
> -	if (mt7531_dual_sgmii_supported(priv)) {
> -		priv->p5_intf_sel = P5_INTF_SEL_GMAC5_SGMII;
> -
> +	if (priv->p5_sgmii) {
>  		/* Let ds->slave_mii_bus be able to access external phy. */
>  		mt7530_rmw(priv, MT7531_GPIO_MODE1, MT7531_GPIO11_RG_RXD2_MASK,
>  			   MT7531_EXT_P_MDC_11);
>  		mt7530_rmw(priv, MT7531_GPIO_MODE1, MT7531_GPIO12_RG_RXD3_MASK,
>  			   MT7531_EXT_P_MDIO_12);
> -	} else {
> -		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
>  	}
> -	dev_dbg(ds->dev, "P5 support %s interface\n",
> -		p5_intf_modes(priv->p5_intf_sel));
> +
> +	if (!dsa_is_unused_port(ds, 5))
> +		priv->p5_intf_sel = P5_INTF_SEL_GMAC5;
>  
>  	mt7530_rmw(priv, MT7531_GPIO_MODE0, MT7531_GPIO0_MASK,
>  		   MT7531_GPIO0_INTERRUPT);
> @@ -2523,11 +2521,6 @@ static void mt7530_mac_port_get_caps(struct dsa_switch *ds, int port,
>  	}
>  }
>  
> -static bool mt7531_is_rgmii_port(struct mt7530_priv *priv, u32 port)
> -{
> -	return (port == 5) && (priv->p5_intf_sel != P5_INTF_SEL_GMAC5_SGMII);
> -}
> -
>  static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  				     struct phylink_config *config)
>  {
> @@ -2540,7 +2533,7 @@ static void mt7531_mac_port_get_caps(struct dsa_switch *ds, int port,
>  		break;
>  
>  	case 5: /* 2nd cpu port supports either rgmii or sgmii/8023z */
> -		if (mt7531_is_rgmii_port(priv, port)) {
> +		if (!priv->p5_sgmii) {
>  			phy_interface_set_rgmii(config->supported_interfaces);
>  			break;
>  		}
> @@ -2607,7 +2600,7 @@ static int mt7531_rgmii_setup(struct mt7530_priv *priv, u32 port,
>  {
>  	u32 val;
>  
> -	if (!mt7531_is_rgmii_port(priv, port)) {
> +	if (priv->p5_sgmii) {
>  		dev_err(priv->dev, "RGMII mode is not available for port %d\n",
>  			port);
>  		return -EINVAL;
> @@ -2860,7 +2853,7 @@ mt7531_cpu_port_config(struct dsa_switch *ds, int port)
>  
>  	switch (port) {
>  	case 5:
> -		if (mt7531_is_rgmii_port(priv, port))
> +		if (!priv->p5_sgmii)
>  			interface = PHY_INTERFACE_MODE_RGMII;
>  		else
>  			interface = PHY_INTERFACE_MODE_2500BASEX;
> @@ -3019,7 +3012,7 @@ mt753x_setup(struct dsa_switch *ds)
>  		mt7530_free_irq_common(priv);
>  
>  	if (priv->create_sgmii) {
> -		ret = priv->create_sgmii(priv, mt7531_dual_sgmii_supported(priv));
> +		ret = priv->create_sgmii(priv);
>  		if (ret && priv->irq)
>  			mt7530_free_irq(priv);
>  	}
> diff --git a/drivers/net/dsa/mt7530.h b/drivers/net/dsa/mt7530.h
> index 703f8a528317..f58828577520 100644
> --- a/drivers/net/dsa/mt7530.h
> +++ b/drivers/net/dsa/mt7530.h
> @@ -679,7 +679,6 @@ typedef enum {
>  	P5_INTF_SEL_PHY_P0,
>  	P5_INTF_SEL_PHY_P4,
>  	P5_INTF_SEL_GMAC5,
> -	P5_INTF_SEL_GMAC5_SGMII,
>  } p5_interface_select;
>  
>  struct mt7530_priv;
> @@ -749,6 +748,8 @@ struct mt753x_info {
>   * @p6_interface:	Holding the current port 6 interface
>   * @p5_interface:	Holding the current port 5 interface
>   * @p5_intf_sel:	Holding the current port 5 interface select
> + * @p5_sgmii:		Flag for distinguishing if port 5 of the MT7531 switch
> + *			has got SGMII
>   * @irq:		IRQ number of the switch
>   * @irq_domain:		IRQ domain of the switch irq_chip
>   * @irq_enable:		IRQ enable bits, synced to SYS_INT_EN
> @@ -769,6 +770,7 @@ struct mt7530_priv {
>  	phy_interface_t		p6_interface;
>  	phy_interface_t		p5_interface;
>  	p5_interface_select	p5_intf_sel;
> +	bool			p5_sgmii;
>  	u8			mirror_rx;
>  	u8			mirror_tx;
>  	struct mt7530_port	ports[MT7530_NUM_PORTS];
> @@ -778,7 +780,7 @@ struct mt7530_priv {
>  	int irq;
>  	struct irq_domain *irq_domain;
>  	u32 irq_enable;
> -	int (*create_sgmii)(struct mt7530_priv *priv, bool dual_sgmii);
> +	int (*create_sgmii)(struct mt7530_priv *priv);
>  };
>  
>  struct mt7530_hw_vlan_entry {
> -- 
> 2.37.2
> 

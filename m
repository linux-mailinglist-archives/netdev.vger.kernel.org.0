Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638636CCDA5
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 00:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbjC1Wpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 18:45:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjC1Wpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 18:45:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EEA2134;
        Tue, 28 Mar 2023 15:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RgD/ufxA0OWHGZK8NkDuEsFaxyb1XYawl1WoKjQnHRo=; b=i8TMlqpBKcT9vIgXXw2JGneG9G
        UmOwisrNIngGN5lBzlm+cJ3vFb52AwULmppIId/BvU5oyBFalDL0dHyN36RagWzDg00ur0Sj3GoxI
        5cufnH8OwWSKv4wQx6qD5Dkp1UIemZaW1ZkZCAu9cJsU455GGyFYMsU13mZWq7/XD1vQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phI4P-008hNJ-U2; Wed, 29 Mar 2023 00:45:37 +0200
Date:   Wed, 29 Mar 2023 00:45:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v2 2/2] net: dsa: mt7530: introduce MMIO
 driver for MT7988 SoC
Message-ID: <8494e02c-6c04-46c9-af86-a414f27fcf23@lunn.ch>
References: <cover.1680041193.git.daniel@makrotopia.org>
 <6f628e3a56ad8390b1f5a00b86b61c54d66d3106.1680041193.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f628e3a56ad8390b1f5a00b86b61c54d66d3106.1680041193.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -146,11 +149,13 @@ core_write(struct mt7530_priv *priv, u32 reg, u32 val)
>  {
>  	struct mii_bus *bus = priv->bus;
>  
> -	mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +	if (bus)
> +		mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
>  
>  	core_write_mmd_indirect(priv, reg, MDIO_MMD_VEND2, val);
>  
> -	mutex_unlock(&bus->mdio_lock);
> +	if (bus)
> +		mutex_unlock(&bus->mdio_lock);
>  }

All this if (bus) is pretty ugly.

First off, what is this mutex actually protecting? And why is the same
protection not required for MMIO?

If you have a convincing argument the mutex is not needed, please add
two helpers:

mt7530_mutex_lock(struct mt7530_priv *priv)
mt7530_mutex_unlock(struct mt7530_priv *priv)

and hide the if inside that. As part of the commit message, explain
why the mutex is not needed for MDIO.

Adding these helpers and changing all calls can be a preparation
patch. It is the sort of patch which should be obviously correct.

> @@ -2588,6 +2664,8 @@ mt7531_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  	case PHY_INTERFACE_MODE_NA:
>  	case PHY_INTERFACE_MODE_1000BASEX:
>  	case PHY_INTERFACE_MODE_2500BASEX:
> +	case PHY_INTERFACE_MODE_USXGMII:
> +	case PHY_INTERFACE_MODE_10GKR:
>  		/* handled in SGMII PCS driver */
>  		return 0;
>  	default:
> @@ -2712,7 +2790,9 @@ static void mt753x_phylink_mac_link_up(struct dsa_switch *ds, int port,
>  	 * variants.
>  	 */
>  	if (interface == PHY_INTERFACE_MODE_TRGMII ||
> -	    (phy_interface_mode_is_8023z(interface))) {
> +	    interface == PHY_INTERFACE_MODE_USXGMII ||
> +	    interface == PHY_INTERFACE_MODE_10GKR ||
> +	    phy_interface_mode_is_8023z(interface)) {
>  		speed = SPEED_1000;
>  		duplex = DUPLEX_FULL;
>  	}

This looks like something which should be in a separate patch.

> +static int mt7988_setup(struct dsa_switch *ds)
> +{
> +	struct mt7530_priv *priv = ds->priv;
> +	u32 unused_pm = 0;
> +	int i;
> +
> +	/* Reset the switch */
> +	reset_control_assert(priv->rstc);
> +	udelay(20);
> +	reset_control_deassert(priv->rstc);
> +	udelay(20);
> +
> +	/* Reset the switch PHYs */
> +	mt7530_write(priv, MT7530_SYS_CTRL, SYS_CTRL_PHY_RST);
> +
> +	/* BPDU to CPU port */
> +	mt7530_rmw(priv, MT7531_CFC, MT7531_CPU_PMAP_MASK,
> +		   BIT(MT7988_CPU_PORT));
> +	mt7530_rmw(priv, MT753X_BPC, MT753X_BPDU_PORT_FW_MASK,
> +		   MT753X_BPDU_CPU_ONLY);
> +
> +	/* Enable and reset MIB counters */
> +	mt7530_mib_reset(ds);
> +
> +	for (i = 0; i < MT7530_NUM_PORTS; i++) {
> +		/* Disable forwarding by default on all ports */
> +		mt7530_rmw(priv, MT7530_PCR_P(i), PCR_MATRIX_MASK,
> +			   PCR_MATRIX_CLR);
> +
> +		mt7530_set(priv, MT7531_DBG_CNT(i), MT7531_DIS_CLR);
> +
> +		if (dsa_is_unused_port(ds, i))
> +			unused_pm |= BIT(i);
> +		else if (dsa_is_cpu_port(ds, i))
> +			mt753x_cpu_port_enable(ds, i);
> +		else
> +			mt7530_port_disable(ds, i);
> +
> +		/* Enable consistent egress tag */
> +		mt7530_rmw(priv, MT7530_PVC_P(i), PVC_EG_TAG_MASK,
> +			   PVC_EG_TAG(MT7530_VLAN_EG_CONSISTENT));
> +	}
> +
> +	ds->configure_vlan_while_not_filtering = true;
> +
> +	/* Flush the FDB table */
> +	return mt7530_fdb_cmd(priv, MT7530_FDB_FLUSH, NULL);

Is this really specific to the mt7988? 

   Andrew

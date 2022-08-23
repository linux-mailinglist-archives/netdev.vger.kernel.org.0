Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC06859EC18
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiHWTU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:20:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiHWTUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:20:33 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35621CD784;
        Tue, 23 Aug 2022 10:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IU6VaLqWRQa8AsfWC7mdNjG+QFTd5ie930XuTDlDza0=; b=GHpdEGELeLBX4zYUJzZm1W+kmn
        vJJvoEm6YqLYeAV9CmEShp9eLqTlA3c5/98R81ZMfPwKsYfksAQQE/2+g8HZZCjPUmbuplSOusXX6
        5kuMbZBTBCglAqbnd1uxEAZpvGhSY8ivckFwS/OpAA1RJUurVjZTK6jULtXzLMQbKTQSF+Ght8ten
        nvINrmbzZlE8lE1mIGuFx0YaZEOpFop6GyTTWYrYXOQbVZtL4tO3c1jZLZNVoqGgg+4dLBtwJ/3B/
        OHPgz+Vklh6rVJm8VHrnu+iYHQwk6dPzyj+yi/yfr3A2TvUi4Ti/ZqPOLo0k77NXnnGf4qVI7L7F9
        ofRchHkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33898)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1oQYBA-0003Sa-56; Tue, 23 Aug 2022 18:59:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1oQYB7-0003Km-Oh; Tue, 23 Aug 2022 18:59:05 +0100
Date:   Tue, 23 Aug 2022 18:59:05 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 2/2] net: altera: tse: convert to phylink
Message-ID: <YwUVabmOJNDgf/JK@shell.armlinux.org.uk>
References: <20220823140517.3091239-1-maxime.chevallier@bootlin.com>
 <20220823140517.3091239-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823140517.3091239-3-maxime.chevallier@bootlin.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 23, 2022 at 04:05:17PM +0200, Maxime Chevallier wrote:
> This commit converts the Altera Triple Speed Ethernet Controller to
> phylink. This controller supports MII, GMII and RGMII with its MAC, and
> SGMII + 1000BaseX through a small embedded PCS.
> 
> The PCS itself has a register set very similar to what is found in a
> typical 802.3 ethernet PHY, but this register set memory-mapped instead
> of lying on an mdio bus.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>

This needs some work.

> +static void alt_tse_mac_link_state(struct phylink_config *config,
> +				   struct phylink_link_state *state)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct altera_tse_private *priv = netdev_priv(ndev);
> +
> +	u16 bmsr, lpa;
> +
> +	bmsr = sgmii_pcs_read(priv, MII_BMSR);
> +	lpa = sgmii_pcs_read(priv, MII_LPA);
> +
> +	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
> +}
> +
> +static void alt_tse_mac_an_restart(struct phylink_config *config)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct altera_tse_private *priv = netdev_priv(ndev);
> +	u16 bmcr;
> +
> +	bmcr = sgmii_pcs_read(priv, MII_BMCR);
> +	bmcr |= BMCR_ANRESTART;
> +	sgmii_pcs_write(priv, MII_BMCR, bmcr);
> +}
> +
> +static void alt_tse_pcs_config(struct net_device *ndev,
> +			       const struct phylink_link_state *state)
> +{
> +	struct altera_tse_private *priv = netdev_priv(ndev);
> +	u32 ctrl, if_mode;
> +
> +	if (state->interface != PHY_INTERFACE_MODE_SGMII &&
> +	    state->interface != PHY_INTERFACE_MODE_1000BASEX)
> +		return;
> +
> +	ctrl = sgmii_pcs_read(priv, MII_BMCR);
> +	if_mode = sgmii_pcs_read(priv, SGMII_PCS_IF_MODE);
> +
> +	/* Set link timer to 1.6ms, as per the MegaCore Function User Guide */
> +	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_0, 0x0D40);
> +	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_1, 0x03);
> +
> +	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> +		if_mode |= PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA;
> +	} else if (state->interface == PHY_INTERFACE_MODE_1000BASEX) {
> +		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN | PCS_IF_MODE_SGMII_ENA);
> +		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;
> +	}
> +
> +	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
> +
> +	sgmii_pcs_write(priv, MII_BMCR, ctrl);
> +	sgmii_pcs_write(priv, SGMII_PCS_IF_MODE, if_mode);
> +
> +	sgmii_pcs_reset(priv);
> +}

These look like they can be plugged directly into the phylink_pcs
support - please use that in preference to bolting it ino the MAC
ops - as every other ethernet driver (with the exception of
mtk_eth_soc) does today.

> +
> +static void alt_tse_mac_config(struct phylink_config *config, unsigned int mode,
> +			       const struct phylink_link_state *state)
> +{
> +	struct net_device *ndev = to_net_dev(config->dev);
> +	struct altera_tse_private *priv = netdev_priv(ndev);
> +	u32 ctrl;
> +
> +	ctrl = csrrd32(priv->mac_dev, tse_csroffs(command_config));
> +	ctrl &= ~(MAC_CMDCFG_ENA_10 | MAC_CMDCFG_ETH_SPEED | MAC_CMDCFG_HD_ENA);
> +
> +	if (state->duplex == DUPLEX_HALF)
> +		ctrl |= MAC_CMDCFG_HD_ENA;

Using state->duplex in mac_config has always been a problem, it's not
well defined, and there are paths through phylink where state->duplex
does not reflect the state of the link when this function is called.
This is why it's always been clearly documented that this shall not be
used in mac_config.

> +
> +	if (state->speed == SPEED_1000)
> +		ctrl |= MAC_CMDCFG_ETH_SPEED;
> +	else if (state->speed == SPEED_10)
> +		ctrl |= MAC_CMDCFG_ENA_10;

Using state->speed brings with it the same problems as state->duplex.

Please instead use mac_link_up() (and pcs_link_up()) - which are the
only callbacks from phylink that you can be sure give you the
speed, duplex and pause settings for the link.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

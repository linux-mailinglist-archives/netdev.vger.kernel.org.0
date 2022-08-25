Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BDB5A109A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbiHYMeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241753AbiHYMeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:34:08 -0400
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::223])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21F7AED89;
        Thu, 25 Aug 2022 05:34:05 -0700 (PDT)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2F66B60009;
        Thu, 25 Aug 2022 12:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1661430841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a0zpixNx2moc4UmuE0XK44Om71XCEqAKsnZH44MUnsU=;
        b=OhIh7lw6Td3ts9utYrzkiL4bYZjhRvcOeJNk3S8Ki5tQ2/rZBcpIJU3eoxfOS5RnmbGddn
        M1XDe2idXfywORCA8CCQN7rIG2SDALhpxa9xrxBva0YU9KrIYhsrLJSLBWWjgSkEQB4H+h
        zOBROxxttSprCA1bwoHDIz9tLf0tkxvlrRumjWZbthHVzRG7HhvVJqp3WQBP4q4EkMaxVu
        /7X7od38ylOeBVapY9PrrCyJMPhMulMnVxIYJEhLLXd5gIHpQoCfqPHQwrO3AAIHYvi4CO
        8zc/ie+9owpRn4Xf1FmifUV8Lx7NmF6H3FbauxTmZWa14csHmoeG7JgnjhVamg==
Date:   Thu, 25 Aug 2022 14:33:48 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next 2/2] net: altera: tse: convert to phylink
Message-ID: <20220825143348.662279d6@pc-10.home>
In-Reply-To: <YwUVabmOJNDgf/JK@shell.armlinux.org.uk>
References: <20220823140517.3091239-1-maxime.chevallier@bootlin.com>
        <20220823140517.3091239-3-maxime.chevallier@bootlin.com>
        <YwUVabmOJNDgf/JK@shell.armlinux.org.uk>
Organization: Bootlin
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Russell,

On Tue, 23 Aug 2022 18:59:05 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Tue, Aug 23, 2022 at 04:05:17PM +0200, Maxime Chevallier wrote:
> > This commit converts the Altera Triple Speed Ethernet Controller to
> > phylink. This controller supports MII, GMII and RGMII with its MAC,
> > and SGMII + 1000BaseX through a small embedded PCS.
> > 
> > The PCS itself has a register set very similar to what is found in a
> > typical 802.3 ethernet PHY, but this register set memory-mapped
> > instead of lying on an mdio bus.
> > 
> > Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>  
> 
> This needs some work.

Looks like it, thanks for the review. From what you said, and after
some more testing and digging, it looks like the TSE PCS can be used
as a standalone IP that can be plugged to other macs by putting it in
the PL part of some socfpga platforms.

Given this and your review, I think I'll resubmit this with a proper PCS
driver for the TSE PCS, if that makes sense.

Thanks for the pointers,

Maxime

> > +static void alt_tse_mac_link_state(struct phylink_config *config,
> > +				   struct phylink_link_state
> > *state) +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct altera_tse_private *priv = netdev_priv(ndev);
> > +
> > +	u16 bmsr, lpa;
> > +
> > +	bmsr = sgmii_pcs_read(priv, MII_BMSR);
> > +	lpa = sgmii_pcs_read(priv, MII_LPA);
> > +
> > +	phylink_mii_c22_pcs_decode_state(state, bmsr, lpa);
> > +}
> > +
> > +static void alt_tse_mac_an_restart(struct phylink_config *config)
> > +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct altera_tse_private *priv = netdev_priv(ndev);
> > +	u16 bmcr;
> > +
> > +	bmcr = sgmii_pcs_read(priv, MII_BMCR);
> > +	bmcr |= BMCR_ANRESTART;
> > +	sgmii_pcs_write(priv, MII_BMCR, bmcr);
> > +}
> > +
> > +static void alt_tse_pcs_config(struct net_device *ndev,
> > +			       const struct phylink_link_state
> > *state) +{
> > +	struct altera_tse_private *priv = netdev_priv(ndev);
> > +	u32 ctrl, if_mode;
> > +
> > +	if (state->interface != PHY_INTERFACE_MODE_SGMII &&
> > +	    state->interface != PHY_INTERFACE_MODE_1000BASEX)
> > +		return;
> > +
> > +	ctrl = sgmii_pcs_read(priv, MII_BMCR);
> > +	if_mode = sgmii_pcs_read(priv, SGMII_PCS_IF_MODE);
> > +
> > +	/* Set link timer to 1.6ms, as per the MegaCore Function
> > User Guide */
> > +	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_0, 0x0D40);
> > +	sgmii_pcs_write(priv, SGMII_PCS_LINK_TIMER_1, 0x03);
> > +
> > +	if (state->interface == PHY_INTERFACE_MODE_SGMII) {
> > +		if_mode |= PCS_IF_MODE_USE_SGMII_AN |
> > PCS_IF_MODE_SGMII_ENA;
> > +	} else if (state->interface ==
> > PHY_INTERFACE_MODE_1000BASEX) {
> > +		if_mode &= ~(PCS_IF_MODE_USE_SGMII_AN |
> > PCS_IF_MODE_SGMII_ENA);
> > +		if_mode |= PCS_IF_MODE_SGMI_SPEED_1000;
> > +	}
> > +
> > +	ctrl |= (BMCR_SPEED1000 | BMCR_FULLDPLX | BMCR_ANENABLE);
> > +
> > +	sgmii_pcs_write(priv, MII_BMCR, ctrl);
> > +	sgmii_pcs_write(priv, SGMII_PCS_IF_MODE, if_mode);
> > +
> > +	sgmii_pcs_reset(priv);
> > +}  
> 
> These look like they can be plugged directly into the phylink_pcs
> support - please use that in preference to bolting it ino the MAC
> ops - as every other ethernet driver (with the exception of
> mtk_eth_soc) does today.
> 
> > +
> > +static void alt_tse_mac_config(struct phylink_config *config,
> > unsigned int mode,
> > +			       const struct phylink_link_state
> > *state) +{
> > +	struct net_device *ndev = to_net_dev(config->dev);
> > +	struct altera_tse_private *priv = netdev_priv(ndev);
> > +	u32 ctrl;
> > +
> > +	ctrl = csrrd32(priv->mac_dev, tse_csroffs(command_config));
> > +	ctrl &= ~(MAC_CMDCFG_ENA_10 | MAC_CMDCFG_ETH_SPEED |
> > MAC_CMDCFG_HD_ENA); +
> > +	if (state->duplex == DUPLEX_HALF)
> > +		ctrl |= MAC_CMDCFG_HD_ENA;  
> 
> Using state->duplex in mac_config has always been a problem, it's not
> well defined, and there are paths through phylink where state->duplex
> does not reflect the state of the link when this function is called.
> This is why it's always been clearly documented that this shall not be
> used in mac_config.
> 
> > +
> > +	if (state->speed == SPEED_1000)
> > +		ctrl |= MAC_CMDCFG_ETH_SPEED;
> > +	else if (state->speed == SPEED_10)
> > +		ctrl |= MAC_CMDCFG_ENA_10;  
> 
> Using state->speed brings with it the same problems as state->duplex.
> 
> Please instead use mac_link_up() (and pcs_link_up()) - which are the
> only callbacks from phylink that you can be sure give you the
> speed, duplex and pause settings for the link.
> 
> Thanks.
> 


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8829C1F6411
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 10:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgFKIzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 04:55:44 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59030 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgFKIzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 04:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KwDb/sopd5jsmmkWcfSHgFPCKOuRbiGST7C13mfN9cs=; b=shpts0uRr9dtUYuwTg489FmeO
        VMnZw3UoMltWUBvE+BpbrPtg2VGNrfOlJPi+aaB8IcywCN2Uy4SaB17+yoJ16P4ZwIywbGKV3LKG8
        gUVLd9DyPLgY+EXsnOMA2l8tKkQnqqLoXfH6JTjM5lnEWkMgxssujncEbnVWAjuEdRXXkvktxS9Kb
        4QVSLXuMFlSQ8GG4NwWgehEgxA1oqTlKG6FppOfEZDW7ed002OZU0uNcRH902mP/YXfuOhj+NlAq9
        CyhXPJI8Obgnv6oPRjMhfqq9TfOYJUNNp2b0ZsdCfXXHjfqXfclfj/77rlHaqE1cTNvpK9ceg3DLL
        /WUShol2g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44110)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jjIzg-0008CK-Dj; Thu, 11 Jun 2020 09:55:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jjIzb-00052L-GW; Thu, 11 Jun 2020 09:55:23 +0100
Date:   Thu, 11 Jun 2020 09:55:23 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jonathan McDowell <noodles@earth.li>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
Message-ID: <20200611085523.GV1551@shell.armlinux.org.uk>
References: <cover.1591816172.git.noodles@earth.li>
 <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 10, 2020 at 08:14:03PM +0100, Jonathan McDowell wrote:
> Update the driver to use the new PHYLINK callbacks, removing the
> legacy adjust_link callback.

Looks good, there's a couple of issues / questions

>  static void
> +qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
> +			 const struct phylink_link_state *state)
>  {
>  	struct qca8k_priv *priv = ds->priv;
>  	u32 reg;
>  
> +	switch (port) {
...
> +	case 6: /* 2nd CPU port / external PHY */
> +		if (state->interface != PHY_INTERFACE_MODE_RGMII &&
> +		    state->interface != PHY_INTERFACE_MODE_RGMII_ID &&
> +		    state->interface != PHY_INTERFACE_MODE_SGMII &&
> +		    state->interface != PHY_INTERFACE_MODE_1000BASEX)
> +			return;
> +
> +		reg = QCA8K_REG_PORT6_PAD_CTRL;
> +		break;
...
> +	}
> +
> +	if (port != 6 && phylink_autoneg_inband(mode)) {
> +		dev_err(ds->dev, "%s: in-band negotiation unsupported\n",
> +			__func__);
> +		return;
> +	}
> +
> +	switch (state->interface) {
...
> +	case PHY_INTERFACE_MODE_SGMII:
> +	case PHY_INTERFACE_MODE_1000BASEX:
> +		/* Enable SGMII on the port */
> +		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
> +		break;

Is inband mode configurable?  What if the link partner does/doesn't
send the configuration word?  How is the link state communicated to
the MAC?

> +static int
> +qca8k_phylink_mac_link_state(struct dsa_switch *ds, int port,
> +			     struct phylink_link_state *state)
> +{
> +	struct qca8k_priv *priv = ds->priv;
> +	u32 reg;
>  
> +	reg = qca8k_read(priv, QCA8K_REG_PORT_STATUS(port));
> +
> +	state->link = !!(reg & QCA8K_PORT_STATUS_LINK_UP);
> +	state->an_complete = state->link;
> +	state->an_enabled = !!(reg & QCA8K_PORT_STATUS_LINK_AUTO);
> +	state->duplex = (reg & QCA8K_PORT_STATUS_DUPLEX) ? DUPLEX_FULL :
> +							   DUPLEX_HALF;
> +
> +	switch (reg & QCA8K_PORT_STATUS_SPEED) {
> +	case QCA8K_PORT_STATUS_SPEED_10:
> +		state->speed = SPEED_10;
> +		break;
> +	case QCA8K_PORT_STATUS_SPEED_100:
> +		state->speed = SPEED_100;
> +		break;
> +	case QCA8K_PORT_STATUS_SPEED_1000:
> +		state->speed = SPEED_1000;
> +		break;
> +	default:
> +		state->speed = SPEED_UNKNOWN;

Maybe also force the link down in this case, since the state is invalid?

Do you have access to the link partner's configuration word?  If you do,
you should use that to fill in state->lp_advertising.

> +		break;
> +	}
> +
> +	state->pause = MLO_PAUSE_NONE;
> +	if (reg & QCA8K_PORT_STATUS_RXFLOW)
> +		state->pause |= MLO_PAUSE_RX;
> +	if (reg & QCA8K_PORT_STATUS_TXFLOW)
> +		state->pause |= MLO_PAUSE_TX;
> +
> +	return 1;
> +}
> +
> +static void
> +qca8k_phylink_mac_link_down(struct dsa_switch *ds, int port, unsigned int mode,
> +			    phy_interface_t interface)
> +{
> +	struct qca8k_priv *priv = ds->priv;
>  
>  	qca8k_port_set_status(priv, port, 0);

If operating in in-band mode, forcing the link down unconditionally
will prevent the link coming up if the SGMII/1000base-X block
automatically updates the MAC, and if this takes precedence.

When using in-band mode, you need to call dsa_port_phylink_mac_change()
to keep phylink updated with the link status.

Alternatively, phylink supports polling mode, but due to the layered
way DSA is written, DSA drivers don't have access to that as that is
in the DSA upper levels in net/dsa/slave.c (dsa_slave_phy_setup(),
it would be dp->pl_config.pcs_poll).

Apart from those points, I think it looks fine, thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC for 0.8m (est. 1762m) line in suburbia: sync at 13.1Mbps down 503kbps up

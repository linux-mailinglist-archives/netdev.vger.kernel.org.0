Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FC7454448
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 10:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235671AbhKQJ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 04:57:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235406AbhKQJ5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 04:57:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BCCC061570;
        Wed, 17 Nov 2021 01:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KKEPu6U94eVbW3jO3UesjtSKWbKMRGkqj/maNUDU0Mw=; b=J5N7oc6qjLyBYHjc48vSdssX+d
        U0YdvQ/4giJLjbzXcBfREoz+8/+udYnznfQNrysh7YarT808+VH1JocHUNBecXRustjzyqRM1Gswy
        xhkCCVH0gUn3er8yOSkLAcT6Wpvq2h8gXNlkeS8eQPQiw9nQOtbNuONRrExHmo/ruwnr+Mhb+hdzq
        v6V/M8y70gUGPb6StcCYz7CeK09HJ1zh86kM4M/zGjrqZ305cPweokiZ+mf/oCcrbMeNU/xD3eNNC
        /gOVqBTaOTD02faJygZwdCPanZHCYv0rXNPDexOSwqzYkR3qItvuHxM+BGtT2bu9XfmnkWhJ2mpDc
        3jK1M/6g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:55676)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mnHe6-0001en-9n; Wed, 17 Nov 2021 09:54:26 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mnHe5-0002qJ-1w; Wed, 17 Nov 2021 09:54:25 +0000
Date:   Wed, 17 Nov 2021 09:54:25 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        p.zabel@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] net: lan966x: add port module support
Message-ID: <YZTRUfvPPu5qf7mE@shell.armlinux.org.uk>
References: <20211117091858.1971414-1-horatiu.vultur@microchip.com>
 <20211117091858.1971414-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117091858.1971414-4-horatiu.vultur@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 17, 2021 at 10:18:56AM +0100, Horatiu Vultur wrote:
> +static void lan966x_phylink_mac_link_state(struct phylink_config *config,
> +					   struct phylink_link_state *state)
> +{
> +}
> +
> +static void lan966x_phylink_mac_aneg_restart(struct phylink_config *config)
> +{
> +}

Since you always attach a PCS, it is not necessary to provide stubs
for these functions.

> +static int lan966x_pcs_config(struct phylink_pcs *pcs,
> +			      unsigned int mode,
> +			      phy_interface_t interface,
> +			      const unsigned long *advertising,
> +			      bool permit_pause_to_mac)
> +{
> +	struct lan966x_port *port = lan966x_pcs_to_port(pcs);
> +	struct lan966x_port_config config;
> +	int ret;
> +
> +	memset(&config, 0, sizeof(config));
> +
> +	config = port->config;
> +	config.portmode = interface;
> +	config.inband = phylink_autoneg_inband(mode);
> +	config.autoneg = phylink_test(advertising, Autoneg);
> +	if (phylink_test(advertising, Pause))
> +		config.pause_adv |= ADVERTISE_1000XPAUSE;
> +	if (phylink_test(advertising, Asym_Pause))
> +		config.pause_adv |= ADVERTISE_1000XPSE_ASYM;

There are patches around that add
phylink_mii_c22_pcs_encode_advertisement() which will create the C22
advertisement for you. It would be good to get that patch merged so
people can use it. That should also eliminate lan966x_get_aneg_word(),
although I notice you need to set ADVERTISE_LPACK as well (can you
check that please? Hardware should be managing that bit as it should
only be set once the hardware has received the link partner's
advertisement.)

> +static void decode_cl37_word(u16 lp_abil, uint16_t ld_abil,
> +			     struct lan966x_port_status *status)
> +{
> +	status->link = !(lp_abil & ADVERTISE_RFAULT) && status->link;
> +	status->an_complete = true;
> +	status->duplex = (ADVERTISE_1000XFULL & lp_abil) ?
> +		DUPLEX_FULL : DUPLEX_UNKNOWN;
> +
> +	if ((ld_abil & ADVERTISE_1000XPAUSE) &&
> +	    (lp_abil & ADVERTISE_1000XPAUSE)) {
> +		status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
> +	} else if ((ld_abil & ADVERTISE_1000XPSE_ASYM) &&
> +		   (lp_abil & ADVERTISE_1000XPSE_ASYM)) {
> +		status->pause |= (lp_abil & ADVERTISE_1000XPAUSE) ?
> +			MLO_PAUSE_TX : 0;
> +		status->pause |= (ld_abil & ADVERTISE_1000XPAUSE) ?
> +			MLO_PAUSE_RX : 0;
> +	} else {
> +		status->pause = MLO_PAUSE_NONE;
> +	}
> +}

We already have phylink_decode_c37_word() which will decode this for
you, although it would need to be exported. Please re-use this code.

> +
> +static void decode_sgmii_word(u16 lp_abil, struct lan966x_port_status *status)
> +{
> +	status->an_complete = true;
> +	if (!(lp_abil & LPA_SGMII_LINK)) {
> +		status->link = false;
> +		return;
> +	}
> +
> +	switch (lp_abil & LPA_SGMII_SPD_MASK) {
> +	case LPA_SGMII_10:
> +		status->speed = SPEED_10;
> +		break;
> +	case LPA_SGMII_100:
> +		status->speed = SPEED_100;
> +		break;
> +	case LPA_SGMII_1000:
> +		status->speed = SPEED_1000;
> +		break;
> +	default:
> +		status->link = false;
> +		return;
> +	}
> +	if (lp_abil & LPA_SGMII_FULL_DUPLEX)
> +		status->duplex = DUPLEX_FULL;
> +	else
> +		status->duplex = DUPLEX_HALF;
> +}

The above mentioned function will also handle SGMII as well.

> +int lan966x_port_pcs_set(struct lan966x_port *port,
> +			 struct lan966x_port_config *config)
> +{
> +	struct lan966x *lan966x = port->lan966x;
> +	bool sgmii = false, inband_aneg = false;
> +	int err;
> +
> +	lan966x_port_link_down(port);
> +
> +	if (config->inband) {
> +		if (config->portmode == PHY_INTERFACE_MODE_SGMII ||
> +		    config->portmode == PHY_INTERFACE_MODE_QSGMII)
> +			inband_aneg = true; /* Cisco-SGMII in-band-aneg */
> +		else if (config->portmode == PHY_INTERFACE_MODE_1000BASEX &&
> +			 config->autoneg)
> +			inband_aneg = true; /* Clause-37 in-band-aneg */
> +
> +		if (config->speed > 0) {
> +			err = phy_set_speed(port->serdes, config->speed);
> +			if (err)
> +				return err;
> +		}
> +
> +	} else {
> +		sgmii = true; /* Phy is connnected to the MAC */

This looks weird. SGMII can be in-band as well (and technically is
in-band in its as-specified form.)

> +	}
> +
> +	/* Choose SGMII or 1000BaseX/2500BaseX PCS mode */
> +	lan_rmw(DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA_SET(sgmii),
> +		DEV_PCS1G_MODE_CFG_SGMII_MODE_ENA,
> +		lan966x, DEV_PCS1G_MODE_CFG(port->chip_port));

With the code as you have it, what this means is if we specify
SGMII + in-band, we end up configuring the port to be in 1000BaseX
mode, so it's incapable of 10 and 100M speeds. This seems incorrect.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

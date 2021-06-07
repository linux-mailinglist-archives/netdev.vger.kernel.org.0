Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0538339D868
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbhFGJRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhFGJRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 05:17:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0824C061766;
        Mon,  7 Jun 2021 02:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=blk+qU+EJ0CgsqjQySGfwxy4jy/uyc+QZgfdiP07n5w=; b=z5rOxv6VLUUTMbVY/QR4MTe54
        dhIBdr4OqxrL2O6WFOJYHeOMbFtrGJRphUaJqVqMcBpVB88eUxv9VHA1yHGjpkNO+veXHN0AF/toR
        2euxnacI62zMLLfQi5iaRwMnzIBoTQzcCFtM9y23DNdIpUBSD3HcINYjIXQO2PEds9qy/qaxBTaw4
        6cj6Y+IxJearwrConHAeqKHgrXz6QhukJ73kzVn/9z3w2DDBAHfCsN5gxQ1n8GM+ipQRzSdxiVz9o
        tg/9Jnzwk3GPEDKZF1G6K6xtl7KLFdb/krvaY4MY/vUhm1DtGkYulO7xPFV4xbHsz1IKDParoIq3Q
        xtFpsTfsA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44776)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lqBMB-0000CM-KI; Mon, 07 Jun 2021 10:15:39 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lqBM8-0005mm-VG; Mon, 07 Jun 2021 10:15:36 +0100
Date:   Mon, 7 Jun 2021 10:15:36 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next v3 03/10] net: sparx5: add hostmode with phylink
 support
Message-ID: <20210607091536.GA30436@shell.armlinux.org.uk>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
 <20210604085600.3014532-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604085600.3014532-4-steen.hegelund@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 10:55:53AM +0200, Steen Hegelund wrote:
> +static void sparx5_phylink_mac_config(struct phylink_config *config,
> +				      unsigned int mode,
> +				      const struct phylink_link_state *state)
> +{
> +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> +	struct sparx5_port_config conf;
> +
> +	conf = port->conf;
> +	conf.power_down = false;
> +	conf.portmode = state->interface;
> +	conf.speed = state->speed;
> +	conf.autoneg = state->an_enabled;
> +	conf.pause = state->pause;
> +
> +	if (state->interface == PHY_INTERFACE_MODE_10GBASER) {
> +		if (state->speed == SPEED_UNKNOWN) {
> +			/* When a SFP is plugged in we use capabilities to
> +			 * default to the highest supported speed
> +			 */
> +			if (phylink_test(state->advertising, 25000baseSR_Full) ||
> +			    phylink_test(state->advertising, 25000baseCR_Full))
> +				conf.speed = SPEED_25000;
> +			else if (state->interface == PHY_INTERFACE_MODE_10GBASER)
> +				conf.speed = SPEED_10000;
> +		} else if (state->speed == SPEED_2500) {
> +			conf.portmode = PHY_INTERFACE_MODE_2500BASEX;
> +		} else if (state->speed == SPEED_1000) {
> +			conf.portmode = PHY_INTERFACE_MODE_1000BASEX;
> +		}

1) As detailed in the documentation for phylink, state->speed is not
   guaranteed to be valid in the mac_config method.

2) We clearly need PHY_INTERFACE_MODE_25GBASER rather than working
   around this by testing bits in the advertising bitmap.

3) I really don't get what's going on with setting the port mode to
   2500base-X and 1000base-X here when state->interface is 10GBASER.

> +		if (phylink_test(state->advertising, FIBRE))
> +			conf.media = PHY_MEDIA_SR;
> +		else
> +			conf.media = PHY_MEDIA_DAC;
> +	}
> +
> +	if (!port_conf_has_changed(&port->conf, &conf))
> +		return;
> +}
> +
> +static void sparx5_phylink_mac_link_up(struct phylink_config *config,
> +				       struct phy_device *phy,
> +				       unsigned int mode,
> +				       phy_interface_t interface,
> +				       int speed, int duplex,
> +				       bool tx_pause, bool rx_pause)
> +{

This is the only place that the MAC is guaranteed to know the
negotiated speed.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

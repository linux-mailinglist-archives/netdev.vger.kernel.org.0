Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C222C7618
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388372AbgK1W3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 17:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387738AbgK1W3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 17:29:21 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1EC4C0613D1;
        Sat, 28 Nov 2020 14:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+IyqJ+rUt/FX0E5HF4XeeBNYiCT69b6WTf3nWSBnQxg=; b=oL5z9vjqnGGTy3UY+SKiwsW7j
        uFxkbQtjUxKKB4Sm+bZ5QAu7JJRSLD6aojSaiB6PU+j5kVL251KKyMQoOfGzEcghgX57Sm5Qv6qMt
        UTACGGCch2N2yT2weCF7g5EhcrGnabj86V+kpg1fzG6P8LkIsqdwTOeKJ0PgfCunw2O6pHuNdbyOl
        7JGVh3dCwmTYQDn0pwoxZanQ4rwqmVLIKoYSKUArNfTEPra+lr+fdos3Cd9rXDHiQkTpS64BJoDeq
        mMyXbRpjgRbKgPML91NpCdpFYYbT8p3MApDoGIOT9gnwQxP8jejHoWt0fknF9oPJiTW6Y+NWv7QVh
        Lk3k0jaMw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37322)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kj8hj-00054L-A3; Sat, 28 Nov 2020 22:28:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kj8hg-0003Lj-VS; Sat, 28 Nov 2020 22:28:28 +0000
Date:   Sat, 28 Nov 2020 22:28:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201128222828.GQ1551@shell.armlinux.org.uk>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128190616.GF2191767@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
> > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > +				      unsigned int mode,
> > +				      const struct phylink_link_state *state)
> > +{
> > +	struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > +	struct sparx5_port_config conf;
> > +	int err = 0;
> > +
> > +	conf = port->conf;
> > +	conf.autoneg = state->an_enabled;
> > +	conf.pause = state->pause;
> > +	conf.duplex = state->duplex;
> > +	conf.power_down = false;
> > +	conf.portmode = state->interface;
> > +
> > +	if (state->speed == SPEED_UNKNOWN) {
> > +		/* When a SFP is plugged in we use capabilities to
> > +		 * default to the highest supported speed
> > +		 */
> 
> This looks suspicious.

Yes, it looks highly suspicious. The fact that
sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
does all the work suggests that this was developed before the phylink
re-organisation, and this code hasn't been updated for it.

Any new code for the kernel really ought to be updated for the new
phylink methodology before it is accepted.

Looking at sparx5_port_config(), it also seems to use
PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
very well for the driver to do that internally, but it's confusing
when it comes to reviewing this stuff, especially when people outside
of the driver (such as myself) reviewing it need to understand what's
going on with the configuration.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5512C72FF
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 23:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389355AbgK1Vt6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Nov 2020 16:49:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387569AbgK1TiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Nov 2020 14:38:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CD3C0613D2;
        Sat, 28 Nov 2020 11:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wczN6AriNJ48tQCol4hNOpUdpRZo/jTKX5QpnKikbMM=; b=fzrIFQEgpsI4IkWcnrednf//C
        U1nzyLcWD9ZNOKkXYoAgj+MoJ53wfhfrjVqrIQdwNj6H6UbE0IX/Ah/k/GoYr7Ide01g9xMbX4bi1
        VoYP1856qOKgotp/7iUVrKYmfspgtF6T3H6TmGsRZwKlUbeW6IODzaz1GFa6b7KlQKgme5FTv2DPM
        IOXR639W0GO24JtUBpncCl8B+MQ8m4kUf3w2OgGdqaf6Apm9tgbIf+oLom3adOD3UMgT2uQjCM30h
        RbjRUlN758qzJ3G6OEBi9Osr+fLAMtuOhl41ShLq8nogxJKiLdf+hUxa3whuR1YkBZumVk6yFRXE9
        bQELxf3hA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:37272)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kj61t-0004vk-EC; Sat, 28 Nov 2020 19:37:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kj61r-0003EP-Mv; Sat, 28 Nov 2020 19:37:07 +0000
Date:   Sat, 28 Nov 2020 19:37:07 +0000
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
Message-ID: <20201128193707.GP1551@shell.armlinux.org.uk>
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
> 
> Russell, please could you look through this?

Maybe if I was copied on the patch submission... I don't have the
patches, and searching google for them is a faff, especially
when

site:kernel.org 20201127133307.2969817-1-steen.hegelund@microchip.com

gives:

   Your search - site:kernel.org
   20201127133307.2969817-1-steen.hegelund@microchip.com - did not
   match any documents. Suggestions: Make sure that all words are
   spelled correctly. Try different keywords. Try more general
   keywords.

It seems that the modified MAINTAINERS entry is now annoyingly
missing stuff. I don't know what the solution is - either I get
irrelevant stuff or I don't get stuff I should.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

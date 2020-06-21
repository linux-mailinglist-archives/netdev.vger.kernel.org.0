Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27FFB202B0E
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 16:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730180AbgFUOeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 10:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730154AbgFUOeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 10:34:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1137FC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 07:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pQtXzETU1YwmVj5NU6qACTNM3M71jhfUCcHxVg41puE=; b=KgxTXfkUlEQA+n+74qgl/KjgI
        RcQzi4+7SAwdiuiJanKanKeRZcb+fLQkPEqiAkOATTfDbQX41Qdy353POEypkVtciSYutauaVKqra
        B7jfxNcIBALILMHQbFYSLEQeOSG53F0HYt4/kAB44uq+iE8Au+4UlTmCpsu6rqXtdOKC8k+md1xwn
        icsZktolqPCDO3psMcmNC0kbCPkzuN9AH6Twb4KkQu0cVKYtxwjt4i9ePR2FMsTlq+YjRQ1x0dx5i
        +aRkqAVT4nER4zgkH671IoTmxI6DZ3Z2JZSUYjmdT2kgKXN3DXwAGdzgcx4oPpXrEnJ7aJAlyLMrB
        QpAc5P8Vw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58898)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jn12g-0007y9-SO; Sun, 21 Jun 2020 15:33:59 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jn12S-0007aL-Il; Sun, 21 Jun 2020 15:33:40 +0100
Date:   Sun, 21 Jun 2020 15:33:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [CFT 0/8] rework phylink interface for split MAC/PCS support
Message-ID: <20200621143340.GI1605@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200217172242.GZ25745@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All,

This is now almost four months old, but I see that I didn't copy the
message to everyone who should've been, especially for the five
remaining drivers.

I had asked for input from maintainers to help me convert their
phylink-using drivers to the new style where mac_link_up() performs
the speed, duplex and pause setup rather than mac_config(). So far,
I have had very little assistance with this, and it is now standing
in the way of further changes to phylink, particularly with proper
PCS support. You are effectively blocking this work; I can't break
your code as that will cause a kernel regression.

This is one of the reasons why there were not many phylink patches
merged for the last merge window.

The following drivers in current net-next remain unconverted:

drivers/net/ethernet/mediatek/mtk_eth_soc.c
drivers/net/dsa/ocelot/felix.c
drivers/net/dsa/qca/ar9331.c
drivers/net/dsa/bcm_sf2.c
drivers/net/dsa/b53/b53_common.c

These can be easily identified by grepping for conditionals where the
expression matches the "MLO_PAUSE_.X" regexp.

I have an untested patch that I will be sending out today for
mtk_eth_soc.c, but the four DSA ones definitely require their authors
or maintainers to either make the changes, or assist with that since
their code is not straight forward.

Essentially, if you are listed in this email's To: header, then you
are listed as a maintainer for one of the affected drivers, and I am
requesting assistance from you for this task please.

Thanks.

Russell.

On Mon, Feb 17, 2020 at 05:22:43PM +0000, Russell King - ARM Linux admin wrote:
> Hi,
> 
> The following series changes the phylink interface to allow us to
> better support split MAC / MAC PCS setups.  The fundamental change
> required for this turns out to be quite simple.
> 
> Today, mac_config() is used for everything to do with setting the
> parameters for the MAC, and mac_link_up() is used to inform the
> MAC driver that the link is now up (and so to allow packet flow.)
> mac_config() also has had a few implementation issues, with folk
> who believe that members such as "speed" and "duplex" are always
> valid, where "link" gets used inappropriately, etc.
> 
> With the proposed patches, all this changes subtly - but in a
> backwards compatible way at this stage.
> 
> We pass the the full resolved link state (speed, duplex, pause) to
> mac_link_up(), and it is now guaranteed that these parameters to
> this function will always be valid (no more SPEED_UNKNOWN or
> DUPLEX_UNKNOWN here - unless phylink is fed with such things.)
> 
> Drivers should convert over to using the state in mac_link_up()
> rather than configuring the speed, duplex and pause in the
> mac_config() method. The patch series includes a number of MAC
> drivers which I've thought have been easy targets - I've left the
> remainder as I think they need maintainer input. However, *all*
> drivers will need conversion for future phylink development.
> 
>  Documentation/networking/sfp-phylink.rst          |  17 +++-
>  drivers/net/dsa/b53/b53_common.c                  |   4 +-
>  drivers/net/dsa/b53/b53_priv.h                    |   4 +-
>  drivers/net/dsa/bcm_sf2.c                         |   4 +-
>  drivers/net/dsa/lantiq_gswip.c                    |   4 +-
>  drivers/net/dsa/mt7530.c                          |   4 +-
>  drivers/net/dsa/mv88e6xxx/chip.c                  |  79 +++++++++++++----
>  drivers/net/dsa/sja1105/sja1105_main.c            |   4 +-
>  drivers/net/ethernet/cadence/macb.h               |   1 -
>  drivers/net/ethernet/cadence/macb_main.c          |  53 ++++++-----
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c  |  61 ++++++++-----
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.h  |   1 +
>  drivers/net/ethernet/marvell/mvneta.c             |  63 ++++++++-----
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c   | 102 +++++++++++++---------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c       |   7 +-
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   4 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c |  37 ++++----
>  drivers/net/phy/phylink.c                         |   9 +-
>  include/linux/phylink.h                           |  57 ++++++++----
>  include/net/dsa.h                                 |   4 +-
>  net/dsa/port.c                                    |   7 +-
>  21 files changed, 350 insertions(+), 176 deletions(-)
> 
> -- 
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
> According to speedtest.net: 11.9Mbps down 500kbps up
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDFF06CB5CF
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 07:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjC1FNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 01:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjC1FNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 01:13:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCA910DE
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 22:13:39 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph1eM-0007br-2H; Tue, 28 Mar 2023 07:13:38 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ph1eL-0001Xs-FU; Tue, 28 Mar 2023 07:13:37 +0200
Date:   Tue, 28 Mar 2023 07:13:37 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: Re: [RFC/RFT 03/23] net: phy: Add helper to set EEE Clock stop
 enable bit
Message-ID: <20230328051337.GC15196@pengutronix.de>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-4-andrew@lunn.ch>
 <20230328050327.GB15196@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230328050327.GB15196@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 07:03:27AM +0200, Oleksij Rempel wrote:
> On Mon, Mar 27, 2023 at 07:01:41PM +0200, Andrew Lunn wrote:
> > The MAC driver can request that the PHY stops the clock during EEE
> > LPI. This has normally been does as part of phy_init_eee(), however
> > that function is overly complex and often wrongly used. Add a
> > standalone helper, to aid removing phy_init_eee().
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> > v2: Add missing EXPORT_SYMBOL_GPL
> > ---
> >  drivers/net/phy/phy.c | 20 ++++++++++++++++++++
> >  include/linux/phy.h   |  1 +
> >  2 files changed, 21 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
> > index 68e1ce942dd6..d3d6ff4ed488 100644
> > --- a/drivers/net/phy/phy.c
> > +++ b/drivers/net/phy/phy.c
> > @@ -1503,6 +1503,26 @@ void phy_mac_interrupt(struct phy_device *phydev)
> >  }
> >  EXPORT_SYMBOL(phy_mac_interrupt);
> >  
> > +/**
> > + * phy_eee_clk_stop_enable - Clock should stop during LIP
> > + * @phydev: target phy_device struct
> > + *
> > + * Description: Program the MMD register 3.0 setting the "Clock stop enable"
> > + * bit.
> 
> 
> > + */
> > +int phy_eee_clk_stop_enable(struct phy_device *phydev)
> 
> this function should go to drivers/net/phy/phy-c45.c
> and renamed to genphy_c45_eee_clk_stop_enable()
> > +{
> > +	int ret;
> > +
> > +	mutex_lock(&phydev->lock);
> 
> 	/* IEEE 802.3-2018 45.2.3.1.4 Clock stop enable (3.0.10) */
> 
> > +	ret = phy_set_bits_mmd(phydev, MDIO_MMD_PCS, MDIO_CTRL1,
> > +			       MDIO_PCS_CTRL1_CLKSTOP_EN);
> 
> It would be better to write it conditionally. Only if EEE is supported
> and only if this bit is supported as well. Support is indicated by the
> IEEE 802.3:2018 - 45.2.3.2.6 Clock stop capable (3.1.6)
> 
> It looks like there are other registers for same functionality too but
> other types of PHYs:
> 45.2.4.1.4 Clock stop enable (4.0.10)
> 45.2.4.2.6 Clock stop capable (4.1.6)
> 45.2.5.1.4 Clock stop enable (5.0.10)
> 45.2.5.2.6 Clock stop capable (5.1.6)
> 
> If I see it correctly, Clock-stop is possible only for GMII/RGMII.
> Integrated PHYs or EEE capable PHYs with RMII do not support it.
> For example KSZ8091RNA with RMII:
> https://ww1.microchip.com/downloads/en/DeviceDoc/KSZ8091RNA-RND-10BASE-T-100BASE-TX-PHY-with-RMII-and-EEE-Support-DS00002298B.pdf
> KSZ9477 switch with integrated PHYs:
> https://ww1.microchip.com/downloads/aemDocuments/documents/OTH/ProductDocuments/DataSheets/KSZ9477S-Data-Sheet-DS00002392C.pdf

One more PHY, with RGMII support, but without clock-stop, which is
probably indicated by 3.1.6 bit.
https://ww1.microchip.com/downloads/aemDocuments/documents/AERO/ProductDocuments/DataSheets/VSC8540ET_Extended_Temperature_Single_Port_Fast_Ethernet_Copper_PHY_DS60001648.pdf

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

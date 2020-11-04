Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4AF92A64DE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgKDNLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:11:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34618 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbgKDNLN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 08:11:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaIZ6-005CpL-Au; Wed, 04 Nov 2020 14:11:04 +0100
Date:   Wed, 4 Nov 2020 14:11:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     Marco Felsch <m.felsch@pengutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "Quette, Arnaud" <ArnaudQuette@Eaton.com>
Subject: Re: [EXTERNAL]  Re: [PATCH net 0/4] Restore and fix PHY reset for
 SMSC LAN8720
Message-ID: <20201104131104.GV933237@lunn.ch>
References: <CY4PR1701MB1878B85B9E1C5B4FDCBA2860DF160@CY4PR1701MB1878.namprd17.prod.outlook.com>
 <20201029081626.wtnhctobwvlhmfan@pengutronix.de>
 <CY4PR1701MB187881808BA7836EE5EDFE06DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR1701MB187881808BA7836EE5EDFE06DFEF0@CY4PR1701MB1878.namprd17.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > (ii) This defeats the purpose of a previous commit [2] that disabled
> > > the ref clock for power saving reasons. If a ref clock for the PHY is
> > > specified in DT, the SMSC driver will keep it always on (confirmed
> > > with scope).
> > 
> > NACK, the clock provider can be any clock. This has nothing to do with the
> > FEC clocks. The FEC _can_ be used as clock provider.
> 
> I'm sure you understand this much better than I do. What I can say is that I 
> directly measured the ref clk and found that when I add the clock to the DT
> the clock stays on forever. Basically it seems like the FEC calls to 
> clk_disable_unprepare() don't work in this case, though I'm not sure about the
> reason behind this.

The reason is easy to explain. The clock API is reference counted. It
counts how many times a clock is turned on and off. A clock has to be
turned off as many times as it was turned on before the hardware
actually turns off. So you have the FEC turning the clock on during
probe, followed by the phy turning the clock on. Some time later the
FEC turns the clock off for run time power saving, but there is still
one reference to the clock held by the PHY, so the hardware is left
ticking.

	Andrew

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD0A199C72
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 19:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731371AbgCaRDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 13:03:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:44200 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730216AbgCaRDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 13:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yp40Y2DCbP2hyounIEGsR0vBBWXR1/GHlHEP6SbSYmE=; b=19zHJfz5KTn93xMOlPsGUqQu4
        J6Rlikkne2Fsa5AGx8zzagOGReqTe4MMgVdtOoKx0NzNhZlr1gGekDzd81bNA9cFZ4m6J33kTXWJB
        EzNgBv8GMf8H1vjkcda0doXk9Ds62AtLm5AiffIHUixwo+00mo8Ryzdx/kbGczoQYxe6q2nRQ6a43
        fRlIcSe44KYHRjrLtRyV4nL58tOV2y5G+lvHubJqRxGU3eqvTjdkhZwHdexjFrGLCbV+uiYEAZqSI
        8VnktUYN8PGdWZaHz3mt5DKem82F/Q2Hy75KonmSgbDiM03jrqVcMsuYidqoZk44OcLkVnYR414ze
        cgV7HqW5Q==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60452)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJKI2-00013O-RU; Tue, 31 Mar 2020 18:03:03 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJKI0-0008HE-Il; Tue, 31 Mar 2020 18:03:00 +0100
Date:   Tue, 31 Mar 2020 18:03:00 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     David Jander <david@protonic.nl>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-imx@nxp.com, kernel@pengutronix.de,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331170300.GQ25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <20200331104459.6857474e@erd988>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331104459.6857474e@erd988>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 10:44:59AM +0200, David Jander wrote:
> I have checked with the datasheet of the AR8035, and AFAICS, what the code
> does is this:
> 
>  - Disable the SmartEEE feature of the phy. The comment in the code implies
>    that for some reason it doesn't work, but the reason itself is not given.
>    Anyway, disabling SmartEEE should IMHO opinion be controlled by a DT
>    setting. There is no reason to believe this problem is specific to the
>    i.MX6. Besides, it is a feature of the phy, so it seems logical to expose
>    that via the DT. Once that is done, it has no place here.
> 
>  - Set the external clock output to 125MHz. This is needed because the i.MX6
>    needs a 125MHz reference clock input. But it is not a requirement to use
>    this output. It is perfectly fine and possible to design a board that uses
>    an external oscillator for this. It is also possible that an i.MX6 design
>    has such a phy connected to a MAC behind a switch or some other interface.
>    Independent of i.MX6 this setting can also be necessary for other hardware
>    designs, based on different SoC's. In summary, this is a feature of the
>    specific hardware design at hand, and has nothing to do with the i.MX6
>    specifically. This should definitely be exposed through the DT and not be
>    here.
> 
>  - Enable TXC delay. To clarify, the RGMII specification version 1 specified
>    that the RXC and TXC traces should be routed long enough to introduce a
>    certain delay to the clock signal, or the delay should be introduced via
>    other means. In a later version of the spec, a provision was given for MAC
>    or PHY devices to generate this delay internally. The i.MX6 MAC interface
>    is unable to generate the required delay internally, so it has to be taken
>    care of either by the board layout, or by the PHY device. This is the
>    crucial point: The amount of delay set by the PHY delay register depends on
>    the board layout. It should NEVER be hard-coded in SoC setup code. The
>    correct way is to specify it in the DT. Needless to say that this too,
>    isn't i.MX6-specific.

Let's say this is simple to do, shall we?

So, if I disable the call to ar8031_phy_fixup() from ar8035_phy_fixup(),
and add the following to the imx6qdl-sr-som.dtsi fragment:

&fec {
...
        phy-handle = <&phy>;

        mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                phy: ethernet-phy@0 {
                        reg = <0>;
                        qca,clk-out-frequency = <125000000>;
                };
        };
};

Note that phy-mode is already RGMII-ID.  This should work, right?

The link still comes up, which is good, but the PHY registers for
the clock output are wrong.

MMD 3 register 0x8016 contains 0xb282, not 0xb29a which it has
_with_ the quirk - and thus the above clock frequency stated in
DT is not being selected.  Forcing this register to the right
value restores networking.

Yes, the PHY driver is being used:

Qualcomm Atheros AR8035 2188000.ethernet-1:00: attached PHY driver [Qualcomm Atheros AR8035] (mii_bus:phy_addr=2188000.ethernet-1:00, irq=POLL)

So that's not the problem.

Adding some debug shows that the phy_device that is being used is
the correct one:

Qualcomm Atheros AR8035 2188000.ethernet-1:00: node=/soc/aips-bus@2100000/ethernet@2188000/mdio/ethernet-phy@0

and it is correctly parsing the clk-out-frequency property:

Qualcomm Atheros AR8035 2188000.ethernet-1:00: cof=0 125000000

When we get to attaching the PHY however:

Qualcomm Atheros AR8035 2188000.ethernet-1:00: clk_25m_mask=0004 clk_25m_reg=0000

which is just wrong.  That's because:

                if (at803x_match_phy_id(phydev, ATH8030_PHY_ID) ||
                    at803x_match_phy_id(phydev, ATH8035_PHY_ID)) {
                        priv->clk_25m_reg &= ~AT8035_CLK_OUT_MASK;
                        priv->clk_25m_mask &= ~AT8035_CLK_OUT_MASK;
                }

is patently untested - those "~" should not be there.  These masks
are one-bits-set for the values that comprise the fields, not
zero-bits-set.

So, I see a patch series is going to be necessary to fix the cockup(s)
in the PHY driver before we can do anything with DT files.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

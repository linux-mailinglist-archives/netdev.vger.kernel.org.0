Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F9165BE06
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 11:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbjACK1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 05:27:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233310AbjACK13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 05:27:29 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A951510AA;
        Tue,  3 Jan 2023 02:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=5kukGlDFMSVA3hFPcBY5jEpdLjtGj3Dwb3Kj2ab+XKA=; b=ie5QquIbDqicHFURbmXb6WUsmw
        NZvGSKX0/By0EFHDK5VxPEqe3mzTrHLKxLfdSrh5PF1oLA7jBHlrSySJW/gIm650pUZr7VjWueQpm
        /sExjorFqiPboDwQOB9tZ+O52KwBTgR4BLg5t8AmwFOG3SL6ydWkEJgf51xA2Mc4gCF+hJ4fKNsT7
        sgDcHaOyg9KJmG5O4J1TzcT+kHnZ5uP//nt712trd5IM1DtmYisnkPaH20knWxZ9+UGjI/cHVel0S
        /CRU305Sbox5JIxnw/Qq+5PQ2vHoG46wGZXDYqZGhKsnUq0PzUsdmMtJ6zNdlIE9vy4TxehQJWVnF
        NUzaLjlg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35914)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pCeVu-0005DT-GP; Tue, 03 Jan 2023 10:27:22 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pCeVs-0001z2-QU; Tue, 03 Jan 2023 10:27:20 +0000
Date:   Tue, 3 Jan 2023 10:27:20 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Michael Walle <michael@walle.cc>, Xu Liang <lxu@maxlinear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next v2 1/2] net: phy: allow a phy to opt-out of
 interrupt handling
Message-ID: <Y7QDCJyyJQBoaGl4@shell.armlinux.org.uk>
References: <20221228164008.1653348-1-michael@walle.cc>
 <20221228164008.1653348-2-michael@walle.cc>
 <f547b3b9-4c8f-b370-471a-0a7b5f025e50@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f547b3b9-4c8f-b370-471a-0a7b5f025e50@gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 28, 2022 at 08:49:35AM -0800, Florian Fainelli wrote:
> 
> 
> On 12/28/2022 8:40 AM, Michael Walle wrote:
> > Until now, it is not possible for a PHY driver to disable interrupts
> > during runtime. If a driver offers the .config_intr() as well as the
> > .handle_interrupt() ops, it is eligible for interrupt handling.
> > Introduce a new flag for the dev_flags property of struct phy_device, which
> > can be set by PHY driver to skip interrupt setup and fall back to polling
> > mode.
> > 
> > At the moment, this is used for the MaxLinear PHY which has broken
> > interrupt handling and there is a need to disable interrupts in some
> > cases.
> > 
> > Signed-off-by: Michael Walle <michael@walle.cc>
> > ---
> >   drivers/net/phy/phy_device.c | 7 +++++++
> >   include/linux/phy.h          | 2 ++
> >   2 files changed, 9 insertions(+)
> > 
> > diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> > index 716870a4499c..e4562859ac00 100644
> > --- a/drivers/net/phy/phy_device.c
> > +++ b/drivers/net/phy/phy_device.c
> > @@ -1487,6 +1487,13 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
> >   	phydev->interrupts = PHY_INTERRUPT_DISABLED;
> > +	/* PHYs can request to use poll mode even though they have an
> > +	 * associated interrupt line. This could be the case if they
> > +	 * detect a broken interrupt handling.
> > +	 */
> > +	if (phydev->dev_flags & PHY_F_NO_IRQ)
> > +		phydev->irq = PHY_POLL;
> 
> Cannot you achieve the same thing with the PHY driver mangling phydev->irq
> to a negative value, or is that too later already by the time your phy
> driver's probe function is running?
> 
> > +
> >   	/* Port is set to PORT_TP by default and the actual PHY driver will set
> >   	 * it to different value depending on the PHY configuration. If we have
> >   	 * the generic PHY driver we can't figure it out, thus set the old
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 71eeb4e3b1fd..f1566c7e47a8 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -82,6 +82,8 @@ extern const int phy_10gbit_features_array[1];
> >   #define PHY_POLL_CABLE_TEST	0x00000004
> >   #define MDIO_DEVICE_IS_PHY	0x80000000
> > +#define PHY_F_NO_IRQ		0x80000000
> 
> Kudos for using the appropriate namespace for dev_flags :)

But eww for placement.

PHY_IS_INTERNAL, PHY_RST_AFTER_CLK_EN, PHY_POLL_CABLE_TEST and
MDIO_DEVICE_IS_PHY are all used for the MDIO driver's flags
member.

This new flag is used for the .dev_flags of phy_device - I feel
that it should be separated from the above definitions. I also
think it could do with a comment, because it's not obvious for
future changes that PHY_F_NO_IRQ is used with .dev_flags.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

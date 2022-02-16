Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D42344B826D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 09:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbiBPH6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:58:36 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbiBPH6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:58:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2DED5DD9;
        Tue, 15 Feb 2022 23:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YXSZvLdp2WpAvYAgpt65RWGqBzfUFzNyTw8axHgAK10=; b=o3pYssSMY/qnKmyqV5QbRt0DFQ
        yb5+W59T5AHuXcl8hFjcKbcyFo8ZpPWILUCZWYzfgeRtNGYrMZ04btWArup73rBlL4neEiZJTRjPA
        XKJ8KvPEt5Fz8U6l4/WAq1zjzAxzU+Vd5XPWtmzDw8Q2S3hhcd08aVvXaw9S/4tapcMk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKEuC-006BMz-7p; Wed, 16 Feb 2022 08:39:16 +0100
Date:   Wed, 16 Feb 2022 08:39:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YgyqJAokWhXvDPik@lunn.ch>
References: <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch>
 <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch>
 <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
 <Yex0rZ0wRWQH/L4n@lunn.ch>
 <CAAd53p6pfuYDor3vgm_bHFe_o7urNhv7W6=QGxVz6c=htt7wLg@mail.gmail.com>
 <YgwMslde2OxOOp9d@lunn.ch>
 <CAAd53p4QXHe7XTv5ntsdnC1Z9EpDfXQECKHDEsRA++SEQSdbYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p4QXHe7XTv5ntsdnC1Z9EpDfXQECKHDEsRA++SEQSdbYQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > This is an ACPI based platform and we are working on new firmware
> > > property "use-firmware-led" to give driver a hint:
> > > ...
> > >     Scope (_SB.PC00.OTN0)
> > >     {
> > >         Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
> > >         {
> > >             ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device
> > > Properties for _DSD */,
> > >             Package (0x01)
> > >             {
> > >                 Package (0x02)
> > >                 {
> > >                     "use-firmware-led",
> > >                     One
> > >                 }
> > >             }
> > >         })
> > >     }
> > > ...
> > >
> > > Because the property is under PCI device namespace, I am not sure how
> > > to (cleanly) bring the property from the phylink side to phydev side.
> > > Do you have any suggestion?
> >
> > I'm no ACPI expert, but i think
> > Documentation/firmware-guide/acpi/dsd/phy.rst gives you the basis:
> >
> >     During the MDIO bus driver initialization, PHYs on this bus are probed
> >     using the _ADR object as shown below and are registered on the MDIO bus.
> >
> >       Scope(\_SB.MDI0)
> >       {
> >         Device(PHY1) {
> >           Name (_ADR, 0x1)
> >         } // end of PHY1
> >
> >         Device(PHY2) {
> >           Name (_ADR, 0x2)
> >         } // end of PHY2
> >       }
> >
> > These are the PHYs on the MDIO bus. I _think_ that next to the Name,
> > you can add additional properties, like your "use-firmware-led". This
> > would then be very similar to DT, which is in effect what ACPI is
> > copying. So you need to update this document with your new property,
> > making it clear that this property only applies to boot, not
> > suspend/resume. And fwnode_mdiobus_register_phy() can look for the
> > property and set a flag in the phydev structure indicating that ACPI
> > is totally responsible for LEDs at boot time.
> 
> The problem here is there's no MDIO bus in ACPI namespace, namely no
> "Scope(\_SB.MDI0)" on this platform.

So add it. Basically, copy what DT does. I assume there is a node for
the Ethernet device? And is the MDIO bus driver instantiated by the
Ethernet device? So you can add the MDIO node as a sub node of the
Ethernet device. When you register the MDIO bus using
acpi_mdiobus_register() pass a pointer to this MDIO sub node.

     Andrew

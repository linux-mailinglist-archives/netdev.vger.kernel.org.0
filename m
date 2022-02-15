Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58024B77F9
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244095AbiBOU1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 15:27:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiBOU1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 15:27:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B853DD64C8;
        Tue, 15 Feb 2022 12:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tHIft0PB9IBMUeFCVlzMfMkNH3wZx4NH0qtRo0FhLkQ=; b=mOAvMZ8f26XVlvdZT1HPyp6GZQ
        kmq/YroWuTVaxmFq45YGf3KfswnY73ycZtMZbTIDhtelf/cSFKy/u9nD/poiQAkyKgHLfNItSDi1T
        Rr3gkk1FvwVntIYLnV//jLD3f2hrWamqichc8Y89q67Af5/cpaakwSvvrPHUaOjIcvzI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nK4Q6-0067PD-PM; Tue, 15 Feb 2022 21:27:30 +0100
Date:   Tue, 15 Feb 2022 21:27:30 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, linux@armlinux.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <YgwMslde2OxOOp9d@lunn.ch>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
 <YelxMFOiqnfIVmyy@lunn.ch>
 <CAAd53p7NjvzsBs2aWTP-3GMjoyefMmLB3ou+7fDcrNVfKwALHw@mail.gmail.com>
 <Yeqzhx3GbMzaIbj6@lunn.ch>
 <CAAd53p5pF+SRfwGfJaBTPkH7+9Z6vhPHcuk-c=w8aPTzMBxPcg@mail.gmail.com>
 <YerOIXi7afbH/3QJ@lunn.ch>
 <3d7b1ff0-6776-6480-ed20-c9ad61b400f7@gmail.com>
 <Yex0rZ0wRWQH/L4n@lunn.ch>
 <CAAd53p6pfuYDor3vgm_bHFe_o7urNhv7W6=QGxVz6c=htt7wLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p6pfuYDor3vgm_bHFe_o7urNhv7W6=QGxVz6c=htt7wLg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 14, 2022 at 01:40:43PM +0800, Kai-Heng Feng wrote:
> On Sun, Jan 23, 2022 at 5:18 AM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > > One more idea:
> > > The hw reset default for register 16 is 0x101e. If the current value
> > > is different when entering config_init then we could preserve it
> > > because intentionally a specific value has been set.
> > > Only if we find the hw reset default we'd set the values according
> > > to the current code.
> >
> > We can split the problem into two.
> >
> > 1) I think saving LED configuration over suspend/resume is not an
> > issue. It is probably something we will be needed if we ever get PHY
> > LED configuration via sys/class/leds.
> >
> > 2) Knowing something else has configured the LEDs and the Linux driver
> > should not touch it. In general, Linux tries not to trust the
> > bootloader, because experience has shown bad things can happen when
> > you do. We cannot tell if the LED configuration is different to
> > defaults because something has deliberately set it, or it is just
> > messed up, maybe from the previous boot/kexec, maybe by the
> > bootloader. Even this Dell system BIOS gets it wrong, it configures
> > the LED on power on, but not resume !?!?!. And what about reboot?
> 
> The LED will be reconfigured correctly after each reboot.
> The platform firmware folks doesn't want to restore the value on
> resume because the Windows driver already does that. They are afraid
> it may cause regression if firmware does the same thing.

How can it cause regressions? Why would the Windows driver decide that
if the PHY already has the correct configuration is should mess it all
up? Have you looked at the sources and check what it does?

Anyway, we said that we need to save and restore the LED configuration
over suspend/resume because at some point in the maybe distant future,
we are going to support user configuration of the LEDs via
/sys/class/leds. So you can add the needed support to the PHY driver.

> This is an ACPI based platform and we are working on new firmware
> property "use-firmware-led" to give driver a hint:
> ...
>     Scope (_SB.PC00.OTN0)
>     {
>         Name (_DSD, Package (0x02)  // _DSD: Device-Specific Data
>         {
>             ToUUID ("daffd814-6eba-4d8c-8a91-bc9bbf4aa301") /* Device
> Properties for _DSD */,
>             Package (0x01)
>             {
>                 Package (0x02)
>                 {
>                     "use-firmware-led",
>                     One
>                 }
>             }
>         })
>     }
> ...
> 
> Because the property is under PCI device namespace, I am not sure how
> to (cleanly) bring the property from the phylink side to phydev side.
> Do you have any suggestion?

I'm no ACPI expert, but i think
Documentation/firmware-guide/acpi/dsd/phy.rst gives you the basis:

    During the MDIO bus driver initialization, PHYs on this bus are probed
    using the _ADR object as shown below and are registered on the MDIO bus.

      Scope(\_SB.MDI0)
      {
        Device(PHY1) {
          Name (_ADR, 0x1)
        } // end of PHY1

        Device(PHY2) {
          Name (_ADR, 0x2)
        } // end of PHY2
      }

These are the PHYs on the MDIO bus. I _think_ that next to the Name,
you can add additional properties, like your "use-firmware-led". This
would then be very similar to DT, which is in effect what ACPI is
copying. So you need to update this document with your new property,
making it clear that this property only applies to boot, not
suspend/resume. And fwnode_mdiobus_register_phy() can look for the
property and set a flag in the phydev structure indicating that ACPI
is totally responsible for LEDs at boot time.

	Andrew

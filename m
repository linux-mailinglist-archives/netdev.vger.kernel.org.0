Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9963F0E55
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 00:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234838AbhHRWlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 18:41:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57370 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234624AbhHRWlC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 18:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BHFLjbPCLCF1K1tPIACjXdBhCncOYyQo371Fy8IXvtg=; b=Fbn0t2acIk7bR7DR7/L5OCuExR
        OCdkGwfBUkianTpnsEMDrU69r24nZ84+Q4Xy5xFve1y5ME+ZAzwU1K7NHoXSS85pseA7kFCCbt4rG
        ar8lgBDGuFuO0TiEJ1ir4lN4/0Q4R2kYIlZtKNQtb/FPWnSumNa04mKkZ5F7l6xzSPsw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mGUER-000rcy-DR; Thu, 19 Aug 2021 00:40:23 +0200
Date:   Thu, 19 Aug 2021 00:40:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Asmaa Mnebhi <asmaa@nvidia.com>,
        David Thompson <davthompson@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Liming Sun <limings@nvidia.com>
Subject: Re: [PATCH v1 5/6] TODO: gpio: mlxbf2: Introduce IRQ support
Message-ID: <YR2MV6+uQjjhueoS@lunn.ch>
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-6-andriy.shevchenko@linux.intel.com>
 <CH2PR12MB3895ACF821C8242AA55A1DCDD7FD9@CH2PR12MB3895.namprd12.prod.outlook.com>
 <YR0UPG2451aGt9Xg@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YR0UPG2451aGt9Xg@smile.fi.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Asmaa

> > And I will need to add GpioInt to the GPI0 ACPI table as follows:
> 
> But you told me that it's already on the market, how are you suppose to change
> existing tables?

BIOSes have as many bugs a the kernel. So your product should be
designed so you can upgrade the kernel and upgrade the BIOS.

phylib itself does not care if there is an interrupt or not. It will
fall back to polling. So if your driver finds itself running with old
tables, it does not matter. Just print a warning to the kernel logs
suggesting the user upgrades their BIOS firmware.

> > // GPIO Controller
> >       Device(GPI0) {
> >        Name(_HID, "MLNXBF22")
> >         Name(_UID, Zero)
> >         Name(_CCA, 1)
> >         Name(_CRS, ResourceTemplate() {
> >           // for gpio[0] yu block
> >          Memory32Fixed(ReadWrite, 0x0280c000, 0x00000100)
> >          GpioInt (Level, ActiveLow, Exclusive, PullDefault, , " \\_SB.GPI0") {9}
> >         })
> >         Name(_DSD, Package() {
> >           ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
> >           Package() {
> >             Package () { "phy-gpios", Package() {^GPI0, 0, 0, 0 }},
> >             Package () { "rst-pin", 32 }, // GPIO pin triggering soft reset on BlueSphere and PRIS
> >           }
> >         })
> >       }
> 
> No, it's completely wrong. The resources are provided by GPIO controller and
> consumed by devices.

In the device tree world, you list the interrupt in the PHY node.
Documentation/devicetree/bindings/net/ethernet-phy.yaml gives an
example:

    ethernet {
        #address-cells = <1>;
        #size-cells = <0>;

        ethernet-phy@0 {
            compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c45";
            interrupt-parent = <&PIC>;
            interrupts = <35 1>;
            reg = <0>;

            resets = <&rst 8>;
            reset-names = "phy";
            reset-gpios = <&gpio1 4 1>;
            reset-assert-us = <1000>;
            reset-deassert-us = <2000>;
        };
    };

You need to do something similar in the ACPI world. There was a very
long discussion in this area recently, and some patches merged. You
probably need to build on that. See:

firmware-guide/acpi/dsd/phy.rst

	Andrew

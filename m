Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8B34C2E96
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 15:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiBXOmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 09:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbiBXOmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 09:42:40 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224BE3B28A;
        Thu, 24 Feb 2022 06:42:06 -0800 (PST)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2183010000B;
        Thu, 24 Feb 2022 14:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645713722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sNoHiIq/LUmsFS78HSg7zcwPRlYAqtoPyM+2X+83TE4=;
        b=kulEb06OhHb7WlgmmbMxnFynO6AQWPrh5d5U5TT4gfR8tp2Nx/nYXhBHFouR+pboJL83wc
        DqLug2hMzkDnFmgztq0c2b27OKD0tiKf3Q/mExOtpC4ud5k7N35A67Tz86965BoFuajbOB
        JV/ZKg2+RICEd8X1ydrqYQQ6lw9g+3rvJvnniUDsrGnO/Ex4hJBWfBPyCeWcM8ufphCHZp
        5GvfwGpBW8FPtrgdhuiQQyoFnABnw98ZH4g24jNSK6xWWko9HQ3Lu048v3Mgr7npquq/0H
        ePG9j91ahLsi3wdtuzFu0spX5fA3hxFA1pdTWaXvs47N8upSYF+/QlWF91fk2g==
Date:   Thu, 24 Feb 2022 15:40:40 +0100
From:   =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Wolfram Sang <wsa@kernel.org>, Peter Rosin <peda@axentia.se>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Message-ID: <20220224154040.2633a4e4@fixe.home>
In-Reply-To: <20220221162652.103834-1-clement.leger@bootlin.com>
References: <20220221162652.103834-1-clement.leger@bootlin.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

As stated at the beginning of the cover letter, the PCIe card I'm
working on uses a lan9662 SoC. This card is meant to be used an
ethernet switch with 2 x RJ45 ports and 2 x 10G SFPs. The lan966x SoCs
can be used in two different ways:

 - It can run Linux by itself, on ARM64 cores included in the SoC. This
   use-case of the lan966x is currently being upstreamed, using a
   traditional Device Tree representation of the lan996x HW blocks [1]
   A number of drivers for the different IPs of the SoC have already
   been merged in upstream Linux.

 - It can be used as a PCIe endpoint, connected to a separate platform
   that acts as the PCIe root complex. In this case, all the devices
   that are embedded on this SoC are exposed through PCIe BARs and the
   ARM64 cores of the SoC are not used. Since this is a PCIe card, it
   can be plugged on any platform, of any architecture supporting PCIe.

The goal of this effort is to enable this second use-case, while
allowing the re-use of the existing drivers for the different devices
part of the SoC.

Following a first round of discussion, here are some clarifications on
what problem this series is trying to solve and what are the possible
choices to support this use-case.

Here is the list of devices that are exposed and needed to make this
card work as an ethernet switch:
 - lan966x-switch
 - reset-microchip-sparx5
 - lan966x_serdes
 - reset-microchip-lan966x-phy
 - mdio-mscc-miim
 - pinctrl-lan966x
 - atmel-flexcom
 - i2c-at91
 - i2c-mux
 - i2c-mux-pinctrl
 - sfp
 - clk-lan966x

All the devices on this card are "self-contained" and do not require
cross-links with devices that are on the host (except to demux IRQ but
this is something easy to do). These drivers already exists and are
using of_* API to register controllers, get properties and so on.

The challenge we're trying to solve is how can the PCI driver for this
card re-use the existing drivers, and using which hardware
representation to instantiate all those drivers.

Although this series only contained the modifications for the I2C
subsystem all the subsystems that are used or needed by the previously
listed driver have also been modified to have support for fwnode. This
includes the following subsystems:
- reset
- clk
- pinctrl
- syscon
- gpio
- pinctrl
- phy
- mdio
- i2c

The first feedback on this series does not seems to reach a consensus
(to say the least) on how to do it cleanly so here is a recap of the
possible solutions, either brought by this series or mentioned by
contributors:

1) Describe the card statically using swnode

This is the approach that was taken by this series. The devices are
described using the MFD subsystem with mfd_cells. These cells are
attached with a swnode which will be used as a primary node in place of
ACPI or OF description. This means that the device description
(properties and references) is conveyed entirely in the swnode. In order
to make these swnode usable with existing OF based subsystems, the
fwnode API can be used in needed subsystems.

Pros:
 - Self-contained in the driver.
 - Will work on all platforms no matter the firmware description.
 - Makes the subsystems less OF-centric.

Cons:
 - Modifications are required in subsystems to support fwnode
   (mitigated by the fact it makes to subsystems less OF-centric).
 - swnode are not meant to be used entirely as primary nodes.
 - Specifications for both ACPI and OF must be handled if using fwnode
   API.

2) Use SSDT overlays

Andy mentioned that SSDT overlays could be used. This overlay should
match the exact configuration that is used (ie correct PCIe bus/port
etc). It requires the user to write/modify/compile a .asl file and load
it using either EFI vars, custom initrd or via configfs. The existing
drivers would also need more modifications to work with ACPI. Some of
them might even be harder (if not possible) to use since there is no
ACPI support for the subsystems they are using .

Pros:
 - Can't really find any for this one

Cons:
 - Not all needed subsystems have appropriate ACPI bindings/support
   (reset, clk, pinctrl, syscon).
 - Difficult to setup for the user (modify/compile/load .aml file).
 - Not portable between machines, as the SSDT overlay need to be
   different depending on how the PCI device is connected to the
   platform.

3) Use device-tree overlays

This solution was proposed by Andrew and could potentially allows to
keep all the existing device-tree infrastructure and helpers. A
device-tree overlay could be loaded by the driver and applied using
of_overlay_fdt_apply(). There is some glue to make this work but it
could potentially be possible. Mark have raised some warnings about
using such device-tree overlays on an ACPI enabled platform.

Pros:
 - Reuse all the existing OF infrastructure, no modifications at all on
   drivers and subsystems.
 - Could potentially lead to designing a generic driver for PCI devices
   that uses a composition of other drivers.

Cons:
 - Might not the best idea to mix it with ACPI.
 - Needs CONFIG_OF, which typically isn't enabled today on most x86
   platforms.
 - Loading DT overlays on non-DT platforms is not currently working. It
   can be addressed, but it's not necessarily immediate.

My preferred solutions would be swnode or device-tree overlays but
since there to is no consensus on how to add this support, how
can we go on with this series ?

Thanks,

[1]
https://lore.kernel.org/linux-arm-kernel/20220210123704.477826-1-michael@wa=
lle.cc/

--=20
Cl=C3=A9ment L=C3=A9ger,
Embedded Linux and Kernel engineer at Bootlin
https://bootlin.com

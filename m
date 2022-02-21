Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 707C04BE7DF
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380845AbiBUQjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 11:39:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380777AbiBUQjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 11:39:09 -0500
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19E31220EB;
        Mon, 21 Feb 2022 08:38:35 -0800 (PST)
Received: from relay9-d.mail.gandi.net (unknown [IPv6:2001:4b98:dc4:8::229])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id 8FF28D22C7;
        Mon, 21 Feb 2022 16:29:12 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id B5A9EFF810;
        Mon, 21 Feb 2022 16:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1645460948;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jJIjX5kyEXdZneeW1iQPYNI42BljbOS0DFhi+yxomik=;
        b=e7Zz/d7hE6pk2zoFlLt7/7CuzBYoP3scaT5vrEia0Xsdrk1dv4KzrT9W77+NqfOuvRw38c
        2QDIN+f7ZFCLVQD1kZEHU5bbRJcJcY8xbvIJaMT3ZhMrASoKaBfxpw6IgOTOovkI4kDinb
        hA8w0GaeRZjpO3obEVtzzZdaz0Zb28anlFeMczIZECUShgcwgKq70HwtQNzp/hhgAPpQbe
        y6quOmYO4tR+fpdYZXgN2oZFMyB6lguQ214RCBre46U41d80ZPkKxY1DMUFgqMP9WeRqwO
        mJ/+tk3LzyCpEDofqvon0oKg94UBFWvnnrgj5uVWnhWK4eF/QFKWiEHeyzhUrQ==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
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
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC 00/10] add support for fwnode in i2c mux system and sfp
Date:   Mon, 21 Feb 2022 17:26:42 +0100
Message-Id: <20220221162652.103834-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The purpose of this work is to allow i2c muxes and adapters to be
usable with devices that are described with software_node. A solution
for this is to use the fwnode API which works with both device-tree,
ACPI and software node. In this series, functions are added to retrieve
i2c_adapter from fwnode and to create new mux adapters from fwnode.

This series is part of a larger changeset that touches multiple
subsystems. series will be sent separately for each subsystems since
the amount of modified file is quite large. The following cover letter
gives an overview of this work:

---

The LAN966X SoC can either run it's own Linux system or be plugged in
a PCIe slot as a PCIe switch. When running with a Linux system, a
device-tree description is used to describe the system. However, when
plugged in a PCIe slot (on a x86), there is no device-tree support and
the peripherals that are present must be described in some other way.

Reusing the existing drivers is of course mandatory and they should
also be able to work without device-tree description. We decided to
describe this card using software nodes and a MFD device. Indeed, the
MFD subsystem allows to describe such systems using struct mfd_cells
and mfd_add_devices(). This support also allows to attach a
software_node description which might be used by fwnode API in drivers
and subsystems.

We thought about adding CONFIG_OF to x86 and potentially describe this
card using device-tree overlays but it introduce other problems that
also seems difficult to solve (overlay loading without base
device-tree, fixup of IRQs, adresses, and so on) and CONFIG_OF is not
often enabled on x86 to say the least.

TLDR: I know the series touches a lot of different files and has big
implications, but it turns out software_nodes looks the "best" way of
achieving this goal and has the advantage of converting some subsystems
to be node agnostics, also allowing some ACPI factorization. Criticism
is of course welcome as I might have overlooked something way simpler !

---

This series introduce a number of changes in multiple subsystems to
allow registering and using devices that are described with a
software_node description attached to a mfd_cell, making them usable
with the fwnode API. It was needed to modify many subsystem where
CONFIG_OF was tightly integrated through the use of of_xlate()
functions and other of_* calls. New calls have been added to use fwnode
API and thus be usable with a wider range of nodes. Functions that are
used to get the devices (pinctrl_get, clk_get and so on) also needed
to be changed to use the fwnode API internally.

For instance, the clk framework has been modified to add a
fwnode_xlate() callback and a new named fwnode_clk_add_hw_provider()
has been added. This function will register a clock using
fwnode_xlate() callback. Note that since the fwnode API is compatible
with devices that have a of_node member set, it will still be possible
to use the driver and get the clocks with CONFIG_OF enabled
configurations.

In some subsystems, it was possible to keep OF related function by
wrapping the fwnode ones. It is not yet sure if both support
(device-tree and fwnode) should still continue to coexists. For instance
if fwnode_xlate() and of_xlate() should remain since the fwnode version
also supports device-tree. Removing of_xlate() would of course require
to modify all drivers that uses it.

Here is an excerpt of the lan966x description when used as a PCIe card.
The complete description is visible at [2]. This part only describe the
flexcom controller and the fixed-clock that is used as an input clock.

static const struct property_entry ddr_clk_props[] = {
        PROPERTY_ENTRY_U32("clock-frequency", 30000000),
        PROPERTY_ENTRY_U32("#clock-cells", 0),
        {}
};

static const struct software_node ddr_clk_node = {
        .name = "ddr_clk",
        .properties = ddr_clk_props,
};

static const struct property_entry lan966x_flexcom_props[] = {
        PROPERTY_ENTRY_U32("atmel,flexcom-mode", ATMEL_FLEXCOM_MODE_TWI),
        PROPERTY_ENTRY_REF("clocks", &ddr_clk_node),
        {}
};

static const struct software_node lan966x_flexcom_node = {
        .name = "lan966x-flexcom",
        .properties = lan966x_flexcom_props,
};

...

static struct resource lan966x_flexcom_res[] = {
        [0] = {
                .flags = IORESOURCE_MEM,
                .start = LAN966X_DEV_ADDR(FLEXCOM_0_FLEXCOM_REG),
                .end = LAN966X_DEV_ADDR(FLEXCOM_0_FLEXCOM_REG),
        },
};

...

static struct mfd_cell lan966x_pci_mfd_cells[] = {
        ...
        [LAN966X_DEV_DDR_CLK] = {
                .name = "of_fixed_clk",
                .swnode = &ddr_clk_node,
        },
        [LAN966X_DEV_FLEXCOM] = {
                .name = "atmel_flexcom",
                .num_resources = ARRAY_SIZE(lan966x_flexcom_res),
                .resources = lan966x_flexcom_res,
                .swnode = &lan966x_flexcom_node,
        },
        ...
},

And finally registered using:

ret = devm_mfd_add_devices(dev, PLATFORM_DEVID_AUTO,
                           lan966x_pci_mfd_cells,
                           ARRAY_SIZE(lan966x_pci_mfd_cells), pci_base, irq_base,
                           irq_domain);

With the modifications that have been made on this tree, it is now
possible to probe such description using existing platform drivers,
providing that they have been modified a bit to retrieve properties
using fwnode API and using the fwnode_xlate() callback instead of
of_xlate().

This series has been tested on a x86 kernel build without CONFIG_OF.
Another kernel was also built with COMPILE_TEST and CONFIG_OF support
to build as most drivers as possible. It was also tested on a sparx5
arm64 with CONFIG_OF. However, it was not tested with an ACPI
description evolved enough to validate all the changes.

A branch containing all theses modifications can be seen at [1] along
with a PCIe driver [2] which describes the card using software nodes.
Modifications that are on this branch are not completely finished (ie,
subsystems modifications for fwnode have not been factorized with OF
for all of them) in absence of feedback on the beginning of this work
from the community.

[1] https://github.com/clementleger/linux/tree/fwnode_support
[2] https://github.com/clementleger/linux/blob/fwnode_support/drivers/mfd/lan966x_pci_mfd.c

Clément Léger (10):
  property: add fwnode_match_node()
  property: add fwnode_get_match_data()
  base: swnode: use fwnode_get_match_data()
  property: add a callback parameter to fwnode_property_match_string()
  property: add fwnode_property_read_string_index()
  i2c: fwnode: add fwnode_find_i2c_adapter_by_node()
  i2c: of: use fwnode_get_i2c_adapter_by_node()
  i2c: mux: pinctrl: remove CONFIG_OF dependency and use fwnode API
  i2c: mux: add support for fwnode
  net: sfp: add support for fwnode

 drivers/base/property.c             | 133 ++++++++++++++++++++++++++--
 drivers/base/swnode.c               |   1 +
 drivers/i2c/Makefile                |   1 +
 drivers/i2c/i2c-core-fwnode.c       |  40 +++++++++
 drivers/i2c/i2c-core-of.c           |  30 -------
 drivers/i2c/i2c-mux.c               |  39 ++++----
 drivers/i2c/muxes/Kconfig           |   1 -
 drivers/i2c/muxes/i2c-mux-pinctrl.c |  21 ++---
 drivers/net/phy/sfp.c               |  44 +++------
 include/linux/i2c.h                 |   7 +-
 include/linux/property.h            |   9 ++
 11 files changed, 225 insertions(+), 101 deletions(-)
 create mode 100644 drivers/i2c/i2c-core-fwnode.c

-- 
2.34.1


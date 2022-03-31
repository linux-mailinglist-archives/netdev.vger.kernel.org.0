Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34F1C4ED6C7
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiCaJ24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233875AbiCaJ2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:28:52 -0400
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47CA81FD2DB;
        Thu, 31 Mar 2022 02:27:03 -0700 (PDT)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 73BDAE000C;
        Thu, 31 Mar 2022 09:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648718820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JPFMHm+ZBOSm/fAX3EE1F6G0rslnhJUgGBWnwLqpeX0=;
        b=KCqHNRicjeZ2NlZgMKTmuLvwh0jQrJPxDiK3BUuWWy73As0xw/jQdRtI39me3D+674t+S/
        LqYDrEzwYHlM0UCIXps7k3dsxfYLhZJjRJk3E7v27A0XoKWxw7d/2BRry413WELeENaodC
        2YQZi2mhFqPf/JAJIGGsqecWe55syxDJ0tlcwr7IvcpgbLEX94eJ0LrrRGRI/n6lT5XqZO
        LwPPrlWzfYxspwykHG4oVL+WP1diOY85HfusUo2/jrKlenTwVMcrsl3+mugcCF9IOaSjgk
        W+0rCeK0NIjyoVO1uKL6KPhX5YsrfnMquT7Smm6s7tMuKWJ11E+Cf7JHmdIB/w==
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
Subject: [RFC PATCH net-next v2 00/11] add fwnode based mdiobus registration
Date:   Thu, 31 Mar 2022 11:25:22 +0200
Message-Id: <20220331092533.348626-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to allow the mdiobus to be used completely with fwnode and
continue to add fwnode support. This series adds
fwnode_mdiobus_register() which allows to register a MDIO bus with a
fwnode_handle. This support also works with device-tree and thus allows
to integrate of_mdobus_register on top of fwnode support.

ACPI acpi_mdiobus_register() function seems similar enough with
fwnode_mdiobus_register() to be integrated into that later one and thus
remove ACPI specific registration, keeping only the fwnode one for all
types of node. I'm not able to test that specific part so I did not do
it in this series.

This series is a subset of the one that was first submitted as a larger
series to add swnode support [1]. In this one, it will be focused on
fwnode support only since it seems to have reach a consensus that
adding fwnode to subsystems makes sense.

Additional information:

The device I'm trying to support is a PCIe card that uses a lan9662
SoC. This card is meant to be used an ethernet switch with 2 x RJ45
ports and 2 x 10G SFPs. The lan966x SoCs can be used in two different
ways:

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

The goal if this work is to allow OF based drivers to be reused with
software nodes by supporting fwnode in multiple subsystems.

[1] https://lore.kernel.org/netdev/YhPSkz8+BIcdb72R@smile.fi.intel.com/T/

---

Changes in V2:
- Split legacy phy compatible checking in of as preliminary work
- Fix missing static inline in fwnode_mdio.h file
- Split fwnode conversion into multiple patches
- Split OF conversion in multiple patches
- Remove legacy OF handling from fwnode_mdiobus_* variants
- Switch to RFC since net-next is closed

Clément Léger (11):
  net: mdio: fwnode: import of_mdiobus_register() and needed functions
  net: mdio: fwnode: remove legacy compatible checking for phy child
  net: mdio: fwnode: remove legacy phy scanning
  net: mdio: fwnode: convert fwnode_mdiobus_register() for fwnode
  net: mdio: fwnode: add fwnode_mdiobus_register()
  net: mdio: of: wrap fwnode_mdio_parse_addr() in of_mdio_parse_addr()
  net: mdio: fwnode: avoid calling of_* functions with non OF nodes
  net: mdio: fwnode: allow phy device registration with non OF nodes
  net: mdio: of: use fwnode_mdiobus_child_is_phy()
  net: mdio: of: use fwnode_mdiobus_register() in of_mdiobus_register()
  net: mdio: mscc-miim: use fwnode_mdiobus_register()

 drivers/net/mdio/fwnode_mdio.c    | 157 +++++++++++++++++++++++++++++-
 drivers/net/mdio/mdio-mscc-miim.c |   4 +-
 drivers/net/mdio/of_mdio.c        | 100 +------------------
 include/linux/fwnode_mdio.h       |  28 +++++-
 include/linux/of_mdio.h           |  23 +----
 5 files changed, 188 insertions(+), 124 deletions(-)

-- 
2.34.1


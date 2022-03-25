Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20FF34E7CDF
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232024AbiCYUAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231982AbiCYUAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:00:36 -0400
Received: from mslow1.mail.gandi.net (mslow1.mail.gandi.net [217.70.178.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 966671D12CC;
        Fri, 25 Mar 2022 12:50:09 -0700 (PDT)
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id A6C1BC40FF;
        Fri, 25 Mar 2022 17:25:18 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E3243C000B;
        Fri, 25 Mar 2022 17:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1648229038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nl8WMSvcwN7OCquYKapv0FX+joP41LnWWci1eueukjc=;
        b=TZ5NDpZCO6Q2m1d2604X4LIfhH3+aDXJrcg35i09OMJgV8obMHwZ83RNnIFPW69xwO3xo6
        2vKEzdkcmYO8+Yd+0TY/EUFqii2DlpA+AxzoIC/r7K5sZMZFVVL6ddneZKxOlhQCNV6hSI
        dOTzy8iZAf4j3kAQsBd9wcLs+ziutM5GA98xJ8VjRhL0dU1ZoByzS4yIPN6qaopcEk7WXQ
        4bG/E1MTzQlM7DBUnzhw7NW6OQKBhatka6Bl8hces0INoUxLdpWgHR0crbRyezglOMCpOb
        ByPKV6WcOQExB4jLgbobIqruo07fUyYtnjxm1T3q6Tas5YdC/a3jgKbwM1w96w==
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
Subject: [net-next 0/5] add fwnode based mdiobus registration
Date:   Fri, 25 Mar 2022 18:22:29 +0100
Message-Id: <20220325172234.1259667-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

fwnode_i2c_only

Clément Léger (5):
  net: mdio: fwnode: add fwnode_mdiobus_register()
  net: mdio: of: use fwnode_mdiobus_* functions
  net: mdiobus: fwnode: avoid calling of_* functions with non OF nodes
  net: mdiobus: fwnode: allow phy device registration with non OF nodes
  net: mdio: mscc-miim: use fwnode_mdiobus_register()

 drivers/net/mdio/fwnode_mdio.c    | 214 +++++++++++++++++++++++++++++-
 drivers/net/mdio/mdio-mscc-miim.c |   4 +-
 drivers/net/mdio/of_mdio.c        | 187 +-------------------------
 include/linux/fwnode_mdio.h       |  13 ++
 4 files changed, 229 insertions(+), 189 deletions(-)

-- 
2.34.1


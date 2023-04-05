Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7566D7848
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237621AbjDEJaH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237620AbjDEJ3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:29:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642575BB7
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:29:14 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzPy-0004pA-Rh; Wed, 05 Apr 2023 11:27:02 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:52 +0200
Subject: [PATCH 01/12] net: phy: refactor phy_device_create function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-1-7e5329f08002@pengutronix.de>
References: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
In-Reply-To: <20230405-net-next-topic-net-phy-reset-v1-0-7e5329f08002@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
X-Mailer: b4 0.12.1
X-SA-Exim-Connect-IP: 2a0a:edc0:0:1101:1d::28
X-SA-Exim-Mail-From: m.felsch@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split phy_device_create() into local helper functions. This commit is in
preparation of fixing the phy reset handling. No functional changes for
the public API users.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/phy_device.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 917ba84105fc..dd0aaa866d17 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -629,13 +629,10 @@ static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 	return 0;
 }
 
-struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
-				     bool is_c45,
-				     struct phy_c45_device_ids *c45_ids)
+static struct phy_device *phy_device_alloc(struct mii_bus *bus, int addr)
 {
 	struct phy_device *dev;
 	struct mdio_device *mdiodev;
-	int ret = 0;
 
 	/* We allocate the device, and initialize the default values */
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
@@ -653,6 +650,15 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	mdiodev->device_free = phy_mdio_device_free;
 	mdiodev->device_remove = phy_mdio_device_remove;
 
+	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
+	device_initialize(&mdiodev->dev);
+
+	return dev;
+}
+
+static int phy_device_init(struct phy_device *dev, u32 phy_id, bool is_c45,
+			   struct phy_c45_device_ids *c45_ids)
+{
 	dev->speed = SPEED_UNKNOWN;
 	dev->duplex = DUPLEX_UNKNOWN;
 	dev->pause = 0;
@@ -670,9 +676,6 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 		dev->c45_ids = *c45_ids;
 	dev->irq = bus->irq[addr];
 
-	dev_set_name(&mdiodev->dev, PHY_ID_FMT, bus->id, addr);
-	device_initialize(&mdiodev->dev);
-
 	dev->state = PHY_DOWN;
 
 	mutex_init(&dev->lock);
@@ -690,7 +693,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	 */
 	if (is_c45 && c45_ids) {
 		const int num_ids = ARRAY_SIZE(c45_ids->device_ids);
-		int i;
+		int ret, i;
 
 		for (i = 1; i < num_ids; i++) {
 			if (c45_ids->device_ids[i] == 0xffffffff)
@@ -699,14 +702,29 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 			ret = phy_request_driver_module(dev,
 						c45_ids->device_ids[i]);
 			if (ret)
-				break;
+				return ret;
 		}
-	} else {
-		ret = phy_request_driver_module(dev, phy_id);
+
+		return 0;
 	}
 
+	return phy_request_driver_module(dev, phy_id);
+}
+
+struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
+				     bool is_c45,
+				     struct phy_c45_device_ids *c45_ids)
+{
+	struct phy_device *dev;
+	int ret;
+
+	dev = phy_device_alloc(bus, addr);
+	if (IS_ERR(dev))
+		return dev;
+
+	ret = phy_device_init(dev, phy_id, is_c45, c45_ids);
 	if (ret) {
-		put_device(&mdiodev->dev);
+		put_device(&dev->mdio.dev);
 		dev = ERR_PTR(ret);
 	}
 

-- 
2.39.2


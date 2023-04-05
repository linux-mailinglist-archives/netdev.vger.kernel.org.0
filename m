Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4438D6D7824
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 11:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237384AbjDEJ1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 05:27:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237415AbjDEJ1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 05:27:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C46E64C27
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 02:27:36 -0700 (PDT)
Received: from dude02.red.stw.pengutronix.de ([2a0a:edc0:0:1101:1d::28])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <m.felsch@pengutronix.de>)
        id 1pjzQ6-0004pA-Oy; Wed, 05 Apr 2023 11:27:10 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
Date:   Wed, 05 Apr 2023 11:26:59 +0200
Subject: [PATCH 08/12] net: phy: add possibility to specify mdio device
 parent
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-net-next-topic-net-phy-reset-v1-8-7e5329f08002@pengutronix.de>
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

Add the possibility to override the mdiodev parent device. This is
required for the TJA1102 dual-port phy where the 2nd port uses the first
port device.

Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
---
 drivers/net/phy/phy_device.c | 2 +-
 include/linux/phy.h          | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index a784ac06e6a9..30b3ac9818b1 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -642,7 +642,7 @@ static struct phy_device *phy_device_alloc(struct phy_device_config *config)
 		return ERR_PTR(-ENOMEM);
 
 	mdiodev = &dev->mdio;
-	mdiodev->dev.parent = &bus->dev;
+	mdiodev->dev.parent = config->parent_mdiodev ? : &bus->dev;
 	mdiodev->dev.bus = &mdio_bus_type;
 	mdiodev->dev.type = &mdio_bus_phy_type;
 	mdiodev->bus = bus;
diff --git a/include/linux/phy.h b/include/linux/phy.h
index bdf6d27faefb..d7aea8622a95 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -760,6 +760,8 @@ static inline struct phy_device *to_phy_device(const struct device *dev)
  * struct phy_device_config - Configuration of a PHY
  *
  * @mii_bus: The target MII bus the PHY is connected to
+ * @parent_mdiodev: Set the MDIO device parent if specified else mii_bus->dev is
+ *                  used as parent.
  * @phy_addr: PHY address on the MII bus
  * @fwnode: The PHY firmware handle
  * @phy_id: UID for this device found during discovery
@@ -774,6 +776,7 @@ static inline struct phy_device *to_phy_device(const struct device *dev)
 
 struct phy_device_config {
 	struct mii_bus *mii_bus;
+	struct device *parent_mdiodev;
 	int phy_addr;
 	struct fwnode_handle *fwnode;
 	u32 phy_id;

-- 
2.39.2


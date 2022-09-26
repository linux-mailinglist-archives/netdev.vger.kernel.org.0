Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB3E5EA75D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 15:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiIZNeX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 09:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235290AbiIZNd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 09:33:28 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FFD5851D
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:55:52 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ocmET-0007Wq-FU; Mon, 26 Sep 2022 13:25:05 +0200
Received: from [2a0a:edc0:0:1101:1d::ac] (helo=dude04.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ocmES-0031Gq-Ot; Mon, 26 Sep 2022 13:25:03 +0200
Received: from ore by dude04.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <ore@pengutronix.de>)
        id 1ocmEP-0049kg-Mo; Mon, 26 Sep 2022 13:25:01 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: [PATCH net-next v7 4/7] net: mdiobus: search for PSE nodes by parsing PHY nodes.
Date:   Mon, 26 Sep 2022 13:24:57 +0200
Message-Id: <20220926112500.990705-5-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220926112500.990705-1-o.rempel@pengutronix.de>
References: <20220926112500.990705-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some PHYs can be linked with PSE (Power Sourcing Equipment), so search
for related nodes and attach it to the phydev.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
changes v4:
- add Reviewed-by: Andrew Lunn
- put pse_control_put() after unregister_mii_timestamper()
changes v3:
- remove is_acpi_node() check
- rework fwnode_find_pse_control() error handling
---
 drivers/net/mdio/fwnode_mdio.c | 34 ++++++++++++++++++++++++++++++++--
 drivers/net/phy/phy_device.c   |  2 ++
 include/linux/phy.h            |  2 ++
 3 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 7ff7349a27a2..e2c97e207bbd 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -10,10 +10,28 @@
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
 #include <linux/phy.h>
+#include <linux/pse-pd/pse.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
 MODULE_LICENSE("GPL");
 
+static struct pse_control *
+fwnode_find_pse_control(struct fwnode_handle *fwnode)
+{
+	struct pse_control *psec;
+	struct device_node *np;
+
+	np = to_of_node(fwnode);
+	if (!np)
+		return NULL;
+
+	psec = of_pse_control_get(np);
+	if (PTR_ERR(psec) == -ENOENT)
+		return NULL;
+
+	return psec;
+}
+
 static struct mii_timestamper *
 fwnode_find_mii_timestamper(struct fwnode_handle *fwnode)
 {
@@ -91,14 +109,21 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr)
 {
 	struct mii_timestamper *mii_ts = NULL;
+	struct pse_control *psec = NULL;
 	struct phy_device *phy;
 	bool is_c45 = false;
 	u32 phy_id;
 	int rc;
 
+	psec = fwnode_find_pse_control(child);
+	if (IS_ERR(psec))
+		return PTR_ERR(psec);
+
 	mii_ts = fwnode_find_mii_timestamper(child);
-	if (IS_ERR(mii_ts))
-		return PTR_ERR(mii_ts);
+	if (IS_ERR(mii_ts)) {
+		rc = PTR_ERR(mii_ts);
+		goto clean_pse;
+	}
 
 	rc = fwnode_property_match_string(child, "compatible",
 					  "ethernet-phy-ieee802.3-c45");
@@ -134,18 +159,23 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 			goto clean_phy;
 	}
 
+	phy->psec = psec;
+
 	/* phy->mii_ts may already be defined by the PHY driver. A
 	 * mii_timestamper probed via the device tree will still have
 	 * precedence.
 	 */
 	if (mii_ts)
 		phy->mii_ts = mii_ts;
+
 	return 0;
 
 clean_phy:
 	phy_device_free(phy);
 clean_mii_ts:
 	unregister_mii_timestamper(mii_ts);
+clean_pse:
+	pse_control_put(psec);
 
 	return rc;
 }
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 2198f1302642..2e65a36b4384 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -26,6 +26,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/phy_led_triggers.h>
+#include <linux/pse-pd/pse.h>
 #include <linux/property.h>
 #include <linux/sfp.h>
 #include <linux/skbuff.h>
@@ -989,6 +990,7 @@ EXPORT_SYMBOL(phy_device_register);
 void phy_device_remove(struct phy_device *phydev)
 {
 	unregister_mii_timestamper(phydev->mii_ts);
+	pse_control_put(phydev->psec);
 
 	device_del(&phydev->mdio.dev);
 
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 9c66f357f489..3ee44599ec0e 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -596,6 +596,7 @@ struct macsec_ops;
  * @master_slave_get: Current master/slave advertisement
  * @master_slave_state: Current master/slave configuration
  * @mii_ts: Pointer to time stamper callbacks
+ * @psec: Pointer to Power Sourcing Equipment control struct
  * @lock:  Mutex for serialization access to PHY
  * @state_queue: Work queue for state machine
  * @shared: Pointer to private data shared by phys in one package
@@ -711,6 +712,7 @@ struct phy_device {
 	struct phylink *phylink;
 	struct net_device *attached_dev;
 	struct mii_timestamper *mii_ts;
+	struct pse_control *psec;
 
 	u8 mdix;
 	u8 mdix_ctrl;
-- 
2.30.2


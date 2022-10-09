Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69BC5F8C44
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbiJIQWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiJIQWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:22:14 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56EA2717D;
        Sun,  9 Oct 2022 09:22:09 -0700 (PDT)
X-QQ-mid: bizesmtp62t1665332493t5gjuh9h
Received: from localhost.localdomain ( [58.247.70.42])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Mon, 10 Oct 2022 00:20:36 +0800 (CST)
X-QQ-SSF: 01100000002000G0Z000B00A0000000
X-QQ-FEAT: xnbq7qFd8vqZdqkibScLhfQ/E6NQoDNYE6JBi1e5CRjyesSFeDluUoRL8yAoN
        sn5YLZEiEkl2FtEwRxFGzn8PnZBEAzGIf0EdCR9jLuYQsy/hwPXqcSfvkDAmOmmeaJxotsI
        I4W/JGhjXwxicfZPluWIEp4hbAuvsCE996mcoBj7hnJFnTgWBcwrtHvUzmYb2NkCSNSC5Vz
        MnG/4Ped2nfSaXYfQrrJ65iG5oa/O0FxHULT3ehzHyg41JE3CEFmktGTOSKJh76g9+M06KW
        1fjLIvvx1Aga1Jp4XSIwq5scsjtSfLefyLsn0QQ4d4RvF0YzQAY4d4HBt+2KyybPKN0SVs9
        +tL6oeG7dBfGyTb7mEvqTCyao/tsw==
X-QQ-GoodBg: 0
From:   Soha Jin <soha@lohu.info>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Soha Jin <soha@lohu.info>
Subject: [PATCH] net: mdiobus: add fwnode_phy_is_fixed_link()
Date:   Mon, 10 Oct 2022 00:20:06 +0800
Message-Id: <20221009162006.1289-1-soha@lohu.info>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:lohu.info:qybglogicsvr:qybglogicsvr3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A helper function to check if PHY is fixed link with fwnode properties.
This is similar to of_phy_is_fixed_link.

Signed-off-by: Soha Jin <soha@lohu.info>
---
 drivers/net/mdio/fwnode_mdio.c | 30 +++++++++++++++++++++++++++++-
 include/linux/fwnode_mdio.h    |  2 ++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 689e728345ce..8e1773e4d304 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -6,8 +6,9 @@
  * out of the fwnode and using it to populate an mii_bus.
  */
 
-#include <linux/acpi.h>
 #include <linux/fwnode_mdio.h>
+#include <linux/property.h>
+#include <linux/acpi.h>
 #include <linux/of.h>
 #include <linux/phy.h>
 #include <linux/pse-pd/pse.h>
@@ -183,3 +184,30 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return rc;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
+bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode)
+{
+	struct fwnode_handle *dn;
+	int err;
+	const char *managed;
+
+	/* New binding: 'fixed-link' is a sub-node of the Ethernet device. */
+	dn = fwnode_get_named_child_node(fwnode, "fixed-link");
+	if (dn) {
+		fwnode_handle_put(dn);
+		return true;
+	}
+
+	err = fwnode_property_read_string(fwnode, "managed", &managed);
+	if (err == 0 && strcmp(managed, "auto") != 0)
+		return true;
+
+	/* Old binding: 'fixed-link' was a property with 5 cells encoding
+	 * various information about the fixed PHY.
+	 */
+	if (fwnode_property_count_u32(fwnode, "fixed-link") == 5)
+		return true;
+
+	return false;
+}
+EXPORT_SYMBOL(fwnode_phy_is_fixed_link);
diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index faf603c48c86..f35e447e524a 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -32,4 +32,6 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 }
 #endif
 
+bool fwnode_phy_is_fixed_link(struct fwnode_handle *fwnode);
+
 #endif /* __LINUX_FWNODE_MDIO_H */
-- 
2.30.2


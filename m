Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8974B929B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 21:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiBPUsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 15:48:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiBPUsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 15:48:39 -0500
X-Greylist: delayed 107328 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Feb 2022 12:48:22 PST
Received: from unicorn.mansr.com (unicorn.mansr.com [81.2.72.234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F0DC3303;
        Wed, 16 Feb 2022 12:48:22 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [81.2.72.235])
        by unicorn.mansr.com (Postfix) with ESMTPS id 4B99415360;
        Wed, 16 Feb 2022 20:48:20 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 13FBE219C0A; Wed, 16 Feb 2022 20:48:20 +0000 (GMT)
From:   Mans Rullgard <mans@mansr.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: dsa: lan9303: add VLAN IDs to master device
Date:   Wed, 16 Feb 2022 20:48:18 +0000
Message-Id: <20220216204818.28746-1-mans@mansr.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the master device does VLAN filtering, the IDs used by the switch
must be added for any frames to be received.  Do this in the
port_enable() function, and remove them in port_disable().

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
Changes:
- Fix dependency on VLAN_8021Q
- Add missing #include
---
 drivers/net/dsa/Kconfig        |  1 +
 drivers/net/dsa/lan9303-core.c | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/Kconfig b/drivers/net/dsa/Kconfig
index 8d51c1019dcd..37a3dabdce31 100644
--- a/drivers/net/dsa/Kconfig
+++ b/drivers/net/dsa/Kconfig
@@ -72,6 +72,7 @@ source "drivers/net/dsa/realtek/Kconfig"
 
 config NET_DSA_SMSC_LAN9303
 	tristate
+	depends on VLAN_8021Q || VLAN_8021Q=n
 	select NET_DSA_TAG_LAN9303
 	select REGMAP
 	help
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 873a5588171b..3969d89fa4db 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -10,6 +10,7 @@
 #include <linux/mii.h>
 #include <linux/phy.h>
 #include <linux/if_bridge.h>
+#include <linux/if_vlan.h>
 #include <linux/etherdevice.h>
 
 #include "lan9303.h"
@@ -1083,21 +1084,27 @@ static void lan9303_adjust_link(struct dsa_switch *ds, int port,
 static int lan9303_port_enable(struct dsa_switch *ds, int port,
 			       struct phy_device *phy)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return 0;
 
+	vlan_vid_add(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	return lan9303_enable_processing_port(chip, port);
 }
 
 static void lan9303_port_disable(struct dsa_switch *ds, int port)
 {
+	struct dsa_port *dp = dsa_to_port(ds, port);
 	struct lan9303 *chip = ds->priv;
 
-	if (!dsa_is_user_port(ds, port))
+	if (!dsa_port_is_user(dp))
 		return;
 
+	vlan_vid_del(dp->cpu_dp->master, htons(ETH_P_8021Q), port);
+
 	lan9303_disable_processing_port(chip, port);
 	lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
 }
-- 
2.35.1


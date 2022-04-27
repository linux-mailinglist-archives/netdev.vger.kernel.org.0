Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94004511D90
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 20:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242794AbiD0Qap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 12:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243839AbiD0Q3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 12:29:13 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F8040A06;
        Wed, 27 Apr 2022 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651076698; x=1682612698;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rorp3JLF+Ms4Vu/B7Z8P2oQsOtG0/dL6kRZVglyDxEo=;
  b=JFo6E5c6kNR3UbSTeNfXf5w9yH9n6skVCd4du8IEMbKnaCWj/uahzRA7
   PgOX6S3DlgHQnnzihNixjV8PJtvoSVFNGxHoFncj7HmcXfqxlCDOHXtJU
   +8K1xKLWZKCGMp0l0OLlFKQ1vLXiTcFqoKuB3mtdWujpJxHmkaRLO04YG
   Xo3XzGPhlPQiuqRb9XsriSn0GpSG90r0Tr+p57MF4wT0JqWn8igWa3GRZ
   rjLaPS9otHKYZ7gitEyGd2FVGqr+KVkM8jdxS4r5QRPiJ4ThOtvP7gNZS
   GkHPVwdp/a+/oExoKbyzaxSbNDf8U4ALTNdsqP/Q3oHK4roXiYqZRD+Kl
   g==;
X-IronPort-AV: E=Sophos;i="5.90,293,1643698800"; 
   d="scan'208";a="161536403"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 27 Apr 2022 09:24:57 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 27 Apr 2022 09:24:55 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 27 Apr 2022 09:24:45 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port mirror to ksz_common.c
Date:   Wed, 27 Apr 2022 21:53:43 +0530
Message-ID: <20220427162343.18092-4-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220427162343.18092-1-arun.ramadoss@microchip.com>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Moved the port_mirror_add and port_mirror_del function from ksz9477 to
ksz_common, to make it generic function which can be used by KSZ9477
based switch.

Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
---
 drivers/net/dsa/microchip/ksz9477.c     | 74 +------------------------
 drivers/net/dsa/microchip/ksz9477_reg.h | 15 -----
 drivers/net/dsa/microchip/ksz_common.c  | 72 ++++++++++++++++++++++++
 drivers/net/dsa/microchip/ksz_common.h  |  5 ++
 drivers/net/dsa/microchip/ksz_reg.h     | 29 ++++++++++
 5 files changed, 108 insertions(+), 87 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz_reg.h

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f762120ce3fd..d568ebfaf8c1 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -973,76 +973,6 @@ static int ksz9477_port_mdb_del(struct dsa_switch *ds, int port,
 	return ret;
 }
 
-static int ksz9477_port_mirror_add(struct dsa_switch *ds, int port,
-				   struct dsa_mall_mirror_tc_entry *mirror,
-				   bool ingress, struct netlink_ext_ack *extack)
-{
-	struct ksz_device *dev = ds->priv;
-	u8 data;
-	int p;
-
-	/* Limit to one sniffer port
-	 * Check if any of the port is already set for sniffing
-	 * If yes, instruct the user to remove the previous entry & exit
-	 */
-	for (p = 0; p < dev->port_cnt; p++) {
-		/* Skip the current sniffing port */
-		if (p == mirror->to_local_port)
-			continue;
-
-		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
-
-		if (data & PORT_MIRROR_SNIFFER) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Sniffer port is already configured, delete existing rules & retry");
-			return -EBUSY;
-		}
-	}
-
-	if (ingress)
-		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
-	else
-		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
-
-	/* configure mirror port */
-	ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
-		     PORT_MIRROR_SNIFFER, true);
-
-	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
-
-	return 0;
-}
-
-static void ksz9477_port_mirror_del(struct dsa_switch *ds, int port,
-				    struct dsa_mall_mirror_tc_entry *mirror)
-{
-	struct ksz_device *dev = ds->priv;
-	bool in_use = false;
-	u8 data;
-	int p;
-
-	if (mirror->ingress)
-		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
-	else
-		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
-
-
-	/* Check if any of the port is still referring to sniffer port */
-	for (p = 0; p < dev->port_cnt; p++) {
-		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
-
-		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
-			in_use = true;
-			break;
-		}
-	}
-
-	/* delete sniffing if there are no other mirroring rule exist */
-	if (!in_use)
-		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
-			     PORT_MIRROR_SNIFFER, false);
-}
-
 static bool ksz9477_get_gbit(struct ksz_device *dev, u8 data)
 {
 	bool gbit;
@@ -1478,8 +1408,8 @@ static const struct dsa_switch_ops ksz9477_switch_ops = {
 	.port_fdb_del		= ksz9477_port_fdb_del,
 	.port_mdb_add           = ksz9477_port_mdb_add,
 	.port_mdb_del           = ksz9477_port_mdb_del,
-	.port_mirror_add	= ksz9477_port_mirror_add,
-	.port_mirror_del	= ksz9477_port_mirror_del,
+	.port_mirror_add	= ksz_port_mirror_add,
+	.port_mirror_del	= ksz_port_mirror_del,
 	.get_stats64		= ksz9477_get_stats64,
 	.port_change_mtu	= ksz9477_change_mtu,
 	.port_max_mtu		= ksz9477_max_mtu,
diff --git a/drivers/net/dsa/microchip/ksz9477_reg.h b/drivers/net/dsa/microchip/ksz9477_reg.h
index 7a2c8d4767af..abdd653a2f39 100644
--- a/drivers/net/dsa/microchip/ksz9477_reg.h
+++ b/drivers/net/dsa/microchip/ksz9477_reg.h
@@ -345,13 +345,6 @@
 #define REG_SW_MAC_TOS_PRIO_30		0x035E
 #define REG_SW_MAC_TOS_PRIO_31		0x035F
 
-#define REG_SW_MRI_CTRL_0		0x0370
-
-#define SW_IGMP_SNOOP			BIT(6)
-#define SW_IPV6_MLD_OPTION		BIT(3)
-#define SW_IPV6_MLD_SNOOP		BIT(2)
-#define SW_MIRROR_RX_TX			BIT(0)
-
 #define REG_SW_CLASS_D_IP_CTRL__4	0x0374
 
 #define SW_CLASS_D_IP_ENABLE		BIT(31)
@@ -1406,12 +1399,6 @@
 #define REG_PORT_ACL_CTRL_1		0x0613
 
 /* 8 - Classification and Policing */
-#define REG_PORT_MRI_MIRROR_CTRL	0x0800
-
-#define PORT_MIRROR_RX			BIT(6)
-#define PORT_MIRROR_TX			BIT(5)
-#define PORT_MIRROR_SNIFFER		BIT(1)
-
 #define REG_PORT_MRI_PRIO_CTRL		0x0801
 
 #define PORT_HIGHEST_PRIO		BIT(7)
@@ -1628,7 +1615,6 @@
 
 #define P_BCAST_STORM_CTRL		REG_PORT_MAC_CTRL_0
 #define P_PRIO_CTRL			REG_PORT_MRI_PRIO_CTRL
-#define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
 #define P_STP_CTRL			REG_PORT_LUE_MSTP_STATE
 #define P_PHY_CTRL			REG_PORT_PHY_CTRL
 #define P_NEG_RESTART_CTRL		REG_PORT_PHY_CTRL
@@ -1637,7 +1623,6 @@
 #define P_RATE_LIMIT_CTRL		REG_PORT_MAC_IN_RATE_LIMIT
 
 #define S_LINK_AGING_CTRL		REG_SW_LUE_CTRL_1
-#define S_MIRROR_CTRL			REG_SW_MRI_CTRL_0
 #define S_REPLACE_VID_CTRL		REG_SW_MAC_CTRL_2
 #define S_802_1P_PRIO_CTRL		REG_SW_MAC_802_1P_MAP_0
 #define S_TOS_PRIO_CTRL			REG_SW_MAC_TOS_PRIO_0
diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index 9b9f570ebb0b..ec5759b017d9 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -19,6 +19,78 @@
 #include <net/switchdev.h>
 
 #include "ksz_common.h"
+#include "ksz_reg.h"
+
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack)
+{
+	struct ksz_device *dev = ds->priv;
+	u8 data;
+	int p;
+
+	/* Limit to one sniffer port
+	 * Check if any of the port is already set for sniffing
+	 * If yes, instruct the user to remove the previous entry & exit
+	 */
+	for (p = 0; p < dev->port_cnt; p++) {
+		/* Skip the current sniffing port */
+		if (p == mirror->to_local_port)
+			continue;
+
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if (data & PORT_MIRROR_SNIFFER) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Sniffer port is already configured, delete existing rules & retry");
+			return -EBUSY;
+		}
+	}
+
+	if (ingress)
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, true);
+	else
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, true);
+
+	/* configure mirror port */
+	ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+		     PORT_MIRROR_SNIFFER, true);
+
+	ksz_cfg(dev, S_MIRROR_CTRL, SW_MIRROR_RX_TX, false);
+
+	return 0;
+}
+EXPORT_SYMBOL(ksz_port_mirror_add);
+
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror)
+{
+	struct ksz_device *dev = ds->priv;
+	bool in_use = false;
+	u8 data;
+	int p;
+
+	if (mirror->ingress)
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_RX, false);
+	else
+		ksz_port_cfg(dev, port, P_MIRROR_CTRL, PORT_MIRROR_TX, false);
+
+	/* Check if any of the port is still referring to sniffer port */
+	for (p = 0; p < dev->port_cnt; p++) {
+		ksz_pread8(dev, p, P_MIRROR_CTRL, &data);
+
+		if ((data & (PORT_MIRROR_RX | PORT_MIRROR_TX))) {
+			in_use = true;
+			break;
+		}
+	}
+
+	/* delete sniffing if there are no other mirroring rule exist */
+	if (!in_use)
+		ksz_port_cfg(dev, mirror->to_local_port, P_MIRROR_CTRL,
+			     PORT_MIRROR_SNIFFER, false);
+}
+EXPORT_SYMBOL(ksz_port_mirror_del);
 
 void ksz_update_port_member(struct ksz_device *dev, int port)
 {
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 4f049e9d8952..e8eeafc03bf7 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -177,6 +177,11 @@ int ksz_port_mdb_del(struct dsa_switch *ds, int port,
 		     const struct switchdev_obj_port_mdb *mdb,
 		     struct dsa_db db);
 int ksz_enable_port(struct dsa_switch *ds, int port, struct phy_device *phy);
+int ksz_port_mirror_add(struct dsa_switch *ds, int port,
+			struct dsa_mall_mirror_tc_entry *mirror,
+			bool ingress, struct netlink_ext_ack *extack);
+void ksz_port_mirror_del(struct dsa_switch *ds, int port,
+			 struct dsa_mall_mirror_tc_entry *mirror);
 
 /* Common register access functions */
 
diff --git a/drivers/net/dsa/microchip/ksz_reg.h b/drivers/net/dsa/microchip/ksz_reg.h
new file mode 100644
index 000000000000..ccd4a6568e34
--- /dev/null
+++ b/drivers/net/dsa/microchip/ksz_reg.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Microchip KSZ Switch register definitions
+ *
+ * Copyright (C) 2017-2022 Microchip Technology Inc.
+ */
+
+#ifndef __KSZ_REGS_H
+#define __KSZ_REGS_H
+
+#define REG_SW_MRI_CTRL_0		0x0370
+
+#define SW_IGMP_SNOOP			BIT(6)
+#define SW_IPV6_MLD_OPTION		BIT(3)
+#define SW_IPV6_MLD_SNOOP		BIT(2)
+#define SW_MIRROR_RX_TX			BIT(0)
+
+/* 8 - Classification and Policing */
+#define REG_PORT_MRI_MIRROR_CTRL	0x0800
+
+#define PORT_MIRROR_RX			BIT(6)
+#define PORT_MIRROR_TX			BIT(5)
+#define PORT_MIRROR_SNIFFER		BIT(1)
+
+#define P_MIRROR_CTRL			REG_PORT_MRI_MIRROR_CTRL
+
+#define S_MIRROR_CTRL			REG_SW_MRI_CTRL_0
+
+#endif
-- 
2.33.0


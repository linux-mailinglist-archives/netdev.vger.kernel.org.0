Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4A66880C8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 15:55:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjBBOzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 09:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBBOzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 09:55:12 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3423C8EB7A;
        Thu,  2 Feb 2023 06:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675349679; x=1706885679;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WQPqZeEgHew7DI+Sw5/4a6SauH8Kbcj0BNboC7sKPMs=;
  b=A5qjFogJbr43mqZtrPk0oCrYkLicUtr387AbcskG1Bks8Bliv/+poa6H
   lhBzIBRxGFFLBoC+ED6ci/H+HihliWKLNieXxKhFtykQkv4xkqzZsMq4d
   JFxsR2NJKk6d5jzrV0akV7DTvJlLRpzp6Jf9bDDmUQKxqubx8T6Ew2eu7
   aLW4WSxkmVWIjmQ6VA1lNUWKmtfEnrIb3Uwu2hb4N62oQsM2oHqRurgLu
   Gpp7zR3iSIxZB4/HfHlFnmKFnMqNLp302zlKa75SszWuwFnlkupMBHEn6
   5lQrrW2oLSHfbRUJbEcJlrxJP8dQwtXOkCtofbhXfZCeFXDSvV7h1Q589
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="195083421"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 07:53:50 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 07:53:44 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 07:53:42 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Add VCAP debugFS support
Date:   Thu, 2 Feb 2023 15:53:37 +0100
Message-ID: <20230202145337.234086-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable debugfs for vcap for lan966x. This will allow to print all the
entries in the VCAP and also the port information regarding which keys
are configured.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../net/ethernet/microchip/lan966x/Makefile   |  2 +
 .../ethernet/microchip/lan966x/lan966x_main.c |  4 +
 .../ethernet/microchip/lan966x/lan966x_main.h | 26 +++++
 .../microchip/lan966x/lan966x_vcap_debugfs.c  | 94 +++++++++++++++++++
 .../microchip/lan966x/lan966x_vcap_impl.c     | 26 ++---
 5 files changed, 136 insertions(+), 16 deletions(-)
 create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c

diff --git a/drivers/net/ethernet/microchip/lan966x/Makefile b/drivers/net/ethernet/microchip/lan966x/Makefile
index 56afd694f3c78..7b0cda4ffa6b5 100644
--- a/drivers/net/ethernet/microchip/lan966x/Makefile
+++ b/drivers/net/ethernet/microchip/lan966x/Makefile
@@ -15,5 +15,7 @@ lan966x-switch-objs  := lan966x_main.o lan966x_phylink.o lan966x_port.o \
 			lan966x_xdp.o lan966x_vcap_impl.o lan966x_vcap_ag_api.o \
 			lan966x_tc_flower.o lan966x_goto.o
 
+lan966x-switch-$(CONFIG_DEBUG_FS) += lan966x_vcap_debugfs.o
+
 # Provide include files
 ccflags-y += -I$(srctree)/drivers/net/ethernet/microchip/vcap
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 580c91d24a528..47b37ab9d7d5e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -1035,6 +1035,8 @@ static int lan966x_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, lan966x);
 	lan966x->dev = &pdev->dev;
 
+	lan966x->debugfs_root = debugfs_create_dir("lan966x", NULL);
+
 	if (!device_get_mac_address(&pdev->dev, mac_addr)) {
 		ether_addr_copy(lan966x->base_mac, mac_addr);
 	} else {
@@ -1223,6 +1225,8 @@ static int lan966x_remove(struct platform_device *pdev)
 	lan966x_fdb_deinit(lan966x);
 	lan966x_ptp_deinit(lan966x);
 
+	debugfs_remove_recursive(lan966x->debugfs_root);
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 26646ca5929d1..49f5159afbf30 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -3,6 +3,7 @@
 #ifndef __LAN966X_MAIN_H__
 #define __LAN966X_MAIN_H__
 
+#include <linux/debugfs.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include <linux/jiffies.h>
@@ -14,6 +15,9 @@
 #include <net/pkt_sched.h>
 #include <net/switchdev.h>
 
+#include <vcap_api.h>
+#include <vcap_api_client.h>
+
 #include "lan966x_regs.h"
 #include "lan966x_ifh.h"
 
@@ -128,6 +132,13 @@ enum LAN966X_PORT_MASK_MODE {
 	LAN966X_PMM_REDIRECT,
 };
 
+enum vcap_is2_port_sel_ipv6 {
+	VCAP_IS2_PS_IPV6_TCPUDP_OTHER,
+	VCAP_IS2_PS_IPV6_STD,
+	VCAP_IS2_PS_IPV6_IP4_TCPUDP_IP4_OTHER,
+	VCAP_IS2_PS_IPV6_MAC_ETYPE,
+};
+
 struct lan966x_port;
 
 struct lan966x_db {
@@ -315,6 +326,9 @@ struct lan966x {
 
 	/* vcap */
 	struct vcap_control *vcap_ctrl;
+
+	/* debugfs */
+	struct dentry *debugfs_root;
 };
 
 struct lan966x_port_config {
@@ -601,6 +615,18 @@ static inline bool lan966x_xdp_port_present(struct lan966x_port *port)
 
 int lan966x_vcap_init(struct lan966x *lan966x);
 void lan966x_vcap_deinit(struct lan966x *lan966x);
+#if defined(CONFIG_DEBUG_FS)
+int lan966x_vcap_port_info(struct net_device *dev,
+			   struct vcap_admin *admin,
+			   struct vcap_output_print *out);
+#else
+static inline int lan966x_vcap_port_info(struct net_device *dev,
+					 struct vcap_admin *admin,
+					 struct vcap_output_print *out)
+{
+	return 0;
+}
+#endif
 
 int lan966x_tc_flower(struct lan966x_port *port,
 		      struct flow_cls_offload *f,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
new file mode 100644
index 0000000000000..7a0db58f55136
--- /dev/null
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_debugfs.c
@@ -0,0 +1,94 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+#include "lan966x_main.h"
+#include "lan966x_vcap_ag_api.h"
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+
+static void lan966x_vcap_port_keys(struct lan966x_port *port,
+				   struct vcap_admin *admin,
+				   struct vcap_output_print *out)
+{
+	struct lan966x *lan966x = port->lan966x;
+	u32 val;
+
+	out->prf(out->dst, "  port[%d] (%s): ", port->chip_port,
+		 netdev_name(port->dev));
+
+	val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
+	out->prf(out->dst, "\n    state: ");
+	if (ANA_VCAP_S2_CFG_ENA_GET(val))
+		out->prf(out->dst, "on");
+	else
+		out->prf(out->dst, "off");
+
+	for (int l = 0; l < admin->lookups; ++l) {
+		out->prf(out->dst, "\n    Lookup %d: ", l);
+
+		out->prf(out->dst, "\n      snap: ");
+		if (ANA_VCAP_S2_CFG_SNAP_DIS_GET(val) & (BIT(0) << l))
+			out->prf(out->dst, "mac_llc");
+		else
+			out->prf(out->dst, "mac_snap");
+
+		out->prf(out->dst, "\n      oam: ");
+		if (ANA_VCAP_S2_CFG_OAM_DIS_GET(val) & (BIT(0) << l))
+			out->prf(out->dst, "mac_etype");
+		else
+			out->prf(out->dst, "mac_oam");
+
+		out->prf(out->dst, "\n      arp: ");
+		if (ANA_VCAP_S2_CFG_ARP_DIS_GET(val) & (BIT(0) << l))
+			out->prf(out->dst, "mac_etype");
+		else
+			out->prf(out->dst, "mac_arp");
+
+		out->prf(out->dst, "\n      ipv4_other: ");
+		if (ANA_VCAP_S2_CFG_IP_OTHER_DIS_GET(val) & (BIT(0) << l))
+			out->prf(out->dst, "mac_etype");
+		else
+			out->prf(out->dst, "ip4_other");
+
+		out->prf(out->dst, "\n      ipv4_tcp_udp: ");
+		if (ANA_VCAP_S2_CFG_IP_TCPUDP_DIS_GET(val) & (BIT(0) << l))
+			out->prf(out->dst, "mac_etype");
+		else
+			out->prf(out->dst, "ipv4_tcp_udp");
+
+		out->prf(out->dst, "\n      ipv6: ");
+		switch (ANA_VCAP_S2_CFG_IP6_CFG_GET(val) & (0x3 << l)) {
+		case VCAP_IS2_PS_IPV6_TCPUDP_OTHER:
+			out->prf(out->dst, "ipv6_tcp_udp ipv6_tcp_udp");
+			break;
+		case VCAP_IS2_PS_IPV6_STD:
+			out->prf(out->dst, "ipv6_std");
+			break;
+		case VCAP_IS2_PS_IPV6_IP4_TCPUDP_IP4_OTHER:
+			out->prf(out->dst, "ipv4_tcp_udp ipv4_tcp_udp");
+			break;
+		case VCAP_IS2_PS_IPV6_MAC_ETYPE:
+			out->prf(out->dst, "mac_etype");
+			break;
+		}
+	}
+
+	out->prf(out->dst, "\n");
+}
+
+int lan966x_vcap_port_info(struct net_device *dev,
+			   struct vcap_admin *admin,
+			   struct vcap_output_print *out)
+{
+	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
+	const struct vcap_info *vcap;
+	struct vcap_control *vctrl;
+
+	vctrl = lan966x->vcap_ctrl;
+	vcap = &vctrl->vcaps[admin->vtype];
+
+	out->prf(out->dst, "%s:\n", vcap->name);
+	lan966x_vcap_port_keys(port, admin, out);
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 72fbbf49a4a74..68f9d69fd37b6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -4,18 +4,12 @@
 #include "lan966x_vcap_ag_api.h"
 #include "vcap_api.h"
 #include "vcap_api_client.h"
+#include "vcap_api_debugfs.h"
 
 #define STREAMSIZE (64 * 4)
 
 #define LAN966X_IS2_LOOKUPS 2
 
-enum vcap_is2_port_sel_ipv6 {
-	VCAP_IS2_PS_IPV6_TCPUDP_OTHER,
-	VCAP_IS2_PS_IPV6_STD,
-	VCAP_IS2_PS_IPV6_IP4_TCPUDP_IP4_OTHER,
-	VCAP_IS2_PS_IPV6_MAC_ETYPE,
-};
-
 static struct lan966x_vcap_inst {
 	enum vcap_type vtype; /* type of vcap */
 	int tgt_inst; /* hardware instance number */
@@ -385,13 +379,6 @@ static void lan966x_vcap_move(struct net_device *dev,
 	lan966x_vcap_wait_update(lan966x, admin->tgt_inst);
 }
 
-static int lan966x_vcap_port_info(struct net_device *dev,
-				  struct vcap_admin *admin,
-				  struct vcap_output_print *out)
-{
-	return 0;
-}
-
 static struct vcap_operations lan966x_vcap_ops = {
 	.validate_keyset = lan966x_vcap_validate_keyset,
 	.add_default_fields = lan966x_vcap_add_default_fields,
@@ -486,6 +473,7 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 	struct lan966x_vcap_inst *cfg;
 	struct vcap_control *ctrl;
 	struct vcap_admin *admin;
+	struct dentry *dir;
 
 	ctrl = kzalloc(sizeof(*ctrl), GFP_KERNEL);
 	if (!ctrl)
@@ -509,11 +497,17 @@ int lan966x_vcap_init(struct lan966x *lan966x)
 		list_add_tail(&admin->list, &ctrl->list);
 	}
 
-	for (int p = 0; p < lan966x->num_phys_ports; ++p)
-		if (lan966x->ports[p])
+	dir = vcap_debugfs(lan966x->dev, lan966x->debugfs_root, ctrl);
+	for (int p = 0; p < lan966x->num_phys_ports; ++p) {
+		if (lan966x->ports[p]) {
+			vcap_port_debugfs(lan966x->dev, dir, ctrl,
+					  lan966x->ports[p]->dev);
+
 			lan_rmw(ANA_VCAP_S2_CFG_ENA_SET(true),
 				ANA_VCAP_S2_CFG_ENA, lan966x,
 				ANA_VCAP_S2_CFG(lan966x->ports[p]->chip_port));
+		}
+	}
 
 	lan966x->vcap_ctrl = ctrl;
 
-- 
2.38.0


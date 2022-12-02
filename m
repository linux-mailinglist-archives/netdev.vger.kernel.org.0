Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87998640153
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 08:52:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232504AbiLBHwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 02:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232508AbiLBHvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 02:51:42 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFF9A51AD;
        Thu,  1 Dec 2022 23:51:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669967499; x=1701503499;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PIDEzCeuHt+Tr/PwR0B5y/Li0Iiqt8bAb/sGIBuyj9Q=;
  b=lAaB1K/tdj1jTdnBhH3PUhAb/00LiCgM8JgWuCkK1FMJDhDeo1t+cnz7
   WjXEwIKHKD/vT8wMxSS/uXz8j2m3LzJyrrLhTxYTHm9nrCT/bg9E6QK17
   SXqoMW07tpuY4/Ux+ysHtG/7PEQ4MhmzjdbS9UW1TxwHjbi+hFeSjTPBu
   DIxy+ik55nzruqzrIk38Bh0oouQCDp0ENlotiTa4d4AUoeRgeeInUrCBZ
   BPJGzZz1G0rEBPcwfsadUlSvKFLOCo9G9Ar9DKZke9u1COyucHtenoEA9
   lUdxuZNQSOYx58Jx2jYJYwUkWSGqTmFsQUYyKY7vHK6dJqQaJBvW62O4m
   A==;
X-IronPort-AV: E=Sophos;i="5.96,210,1665471600"; 
   d="scan'208";a="126141919"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Dec 2022 00:51:39 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Dec 2022 00:51:36 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 2 Dec 2022 00:51:33 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <Steen.Hegelund@microchip.com>,
        <lars.povlsen@microchip.com>, <daniel.machon@microchip.com>,
        <richardcochran@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <olteanv@gmail.com>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next v2 4/4] net: lan966x: Add ptp trap rules
Date:   Fri, 2 Dec 2022 08:56:21 +0100
Message-ID: <20221202075621.1504908-5-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
References: <20221202075621.1504908-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently lan966x, doesn't allow to run PTP over interfaces that are
part of the bridge. The reason is when the lan966x was receiving a
PTP frame (regardless if L2/IPv4/IPv6) the HW it would flood this
frame.
Now that it is possible to add VCAP rules to the HW, such to trap these
frames to the CPU, it is possible to run PTP also over interfaces that
are part of the bridge.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  19 +-
 .../ethernet/microchip/lan966x/lan966x_main.h |  14 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 236 +++++++++++++++++-
 .../microchip/lan966x/lan966x_tc_flower.c     |   8 -
 .../microchip/lan966x/lan966x_vcap_impl.c     |  11 +-
 5 files changed, 265 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index f6092983d0281..cadde20505ba0 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -443,11 +443,22 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
 			      int cmd)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	int err;
+
+	if (cmd == SIOCSHWTSTAMP) {
+		err = lan966x_ptp_setup_traps(port, ifr);
+		if (err)
+			return err;
+	}
 
 	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
 		switch (cmd) {
 		case SIOCSHWTSTAMP:
-			return lan966x_ptp_hwtstamp_set(port, ifr);
+			err = lan966x_ptp_hwtstamp_set(port, ifr);
+			if (err)
+				lan966x_ptp_del_traps(port);
+
+			return err;
 		case SIOCGHWTSTAMP:
 			return lan966x_ptp_hwtstamp_get(port, ifr);
 		}
@@ -456,7 +467,11 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
 	if (!dev->phydev)
 		return -ENODEV;
 
-	return phy_mii_ioctl(dev->phydev, ifr, cmd);
+	err = phy_mii_ioctl(dev->phydev, ifr, cmd);
+	if (err && cmd == SIOCSHWTSTAMP)
+		lan966x_ptp_del_traps(port);
+
+	return err;
 }
 
 static const struct net_device_ops lan966x_port_netdev_ops = {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index f2e45da7ffd4f..3491f19618358 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -88,6 +88,10 @@
 #define SE_IDX_QUEUE			0  /* 0-79 : Queue scheduler elements */
 #define SE_IDX_PORT			80 /* 80-89 : Port schedular elements */
 
+#define LAN966X_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
+#define LAN966X_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
+#define LAN966X_VCAP_CID_IS2_MAX (VCAP_CID_INGRESS_STAGE2_L2 - 1) /* IS2 Max */
+
 /* MAC table entry types.
  * ENTRYTYPE_NORMAL is subject to aging.
  * ENTRYTYPE_LOCKED is not subject to aging.
@@ -116,6 +120,14 @@ enum lan966x_fdma_action {
 	FDMA_REDIRECT,
 };
 
+/* Controls how PORT_MASK is applied */
+enum LAN966X_PORT_MASK_MODE {
+	LAN966X_PMM_NO_ACTION,
+	LAN966X_PMM_REPLACE,
+	LAN966X_PMM_FORWARDING,
+	LAN966X_PMM_REDIRECT,
+};
+
 struct lan966x_port;
 
 struct lan966x_db {
@@ -473,6 +485,8 @@ irqreturn_t lan966x_ptp_irq_handler(int irq, void *args);
 irqreturn_t lan966x_ptp_ext_irq_handler(int irq, void *args);
 u32 lan966x_ptp_get_period_ps(void);
 int lan966x_ptp_gettime64(struct ptp_clock_info *ptp, struct timespec64 *ts);
+int lan966x_ptp_setup_traps(struct lan966x_port *port, struct ifreq *ifr);
+int lan966x_ptp_del_traps(struct lan966x_port *port);
 
 int lan966x_fdma_xmit(struct sk_buff *skb, __be32 *ifh, struct net_device *dev);
 int lan966x_fdma_xmit_xdpf(struct lan966x_port *port,
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index e5a2bbe064f8f..300fe40059191 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -3,6 +3,8 @@
 #include <linux/ptp_classify.h>
 
 #include "lan966x_main.h"
+#include "vcap_api.h"
+#include "vcap_api_client.h"
 
 #define LAN966X_MAX_PTP_ID	512
 
@@ -18,6 +20,17 @@
 
 #define TOD_ACC_PIN		0x7
 
+/* This represents the base rule ID for the PTP rules that are added in the
+ * VCAP to trap frames to CPU. This number needs to be bigger than the maximum
+ * number of entries that can exist in the VCAP.
+ */
+#define LAN966X_VCAP_PTP_RULE_ID	1000000
+#define LAN966X_VCAP_L2_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 0)
+#define LAN966X_VCAP_IPV4_EV_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 1)
+#define LAN966X_VCAP_IPV4_GEN_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 2)
+#define LAN966X_VCAP_IPV6_EV_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 3)
+#define LAN966X_VCAP_IPV6_GEN_PTP_TRAP	(LAN966X_VCAP_PTP_RULE_ID + 4)
+
 enum {
 	PTP_PIN_ACTION_IDLE = 0,
 	PTP_PIN_ACTION_LOAD,
@@ -35,19 +48,228 @@ static u64 lan966x_ptp_get_nominal_value(void)
 	return 0x304d4873ecade305;
 }
 
+static int lan966x_ptp_add_trap(struct lan966x_port *port,
+				int (*add_ptp_key)(struct vcap_rule *vrule,
+						   struct lan966x_port*),
+				u32 rule_id,
+				u16 proto)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct vcap_rule *vrule;
+	int err;
+
+	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
+	if (vrule) {
+		u32 value, mask;
+
+		/* Just modify the ingress port mask and exit */
+		vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
+				      &value, &mask);
+		mask &= ~BIT(port->chip_port);
+		vcap_rule_mod_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK,
+				      value, mask);
+
+		err = vcap_mod_rule(vrule);
+		goto free_rule;
+	}
+
+	vrule = vcap_alloc_rule(lan966x->vcap_ctrl, port->dev,
+				LAN966X_VCAP_CID_IS2_L0,
+				VCAP_USER_PTP, 0, rule_id);
+	if (!vrule)
+		return -ENOMEM;
+	if (IS_ERR(vrule))
+		return PTR_ERR(vrule);
+
+	err = add_ptp_key(vrule, port);
+	if (err)
+		goto free_rule;
+
+	err = vcap_set_rule_set_actionset(vrule, VCAP_AFS_BASE_TYPE);
+	err |= vcap_rule_add_action_bit(vrule, VCAP_AF_CPU_COPY_ENA, VCAP_BIT_1);
+	err |= vcap_rule_add_action_u32(vrule, VCAP_AF_MASK_MODE, LAN966X_PMM_REPLACE);
+	err |= vcap_val_rule(vrule, proto);
+	if (err)
+		goto free_rule;
+
+	err = vcap_add_rule(vrule);
+
+free_rule:
+	/* Free the local copy of the rule */
+	vcap_free_rule(vrule);
+	return err;
+}
+
+static int lan966x_ptp_del_trap(struct lan966x_port *port,
+				u32 rule_id)
+{
+	struct lan966x *lan966x = port->lan966x;
+	struct vcap_rule *vrule;
+	u32 value, mask;
+	int err;
+
+	vrule = vcap_get_rule(lan966x->vcap_ctrl, rule_id);
+	if (!vrule)
+		return -EEXIST;
+
+	vcap_rule_get_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, &value, &mask);
+	mask |= BIT(port->chip_port);
+
+	/* No other port requires this trap, so it is safe to remove it */
+	if (mask == GENMASK(lan966x->num_phys_ports, 0)) {
+		err = vcap_del_rule(lan966x->vcap_ctrl, port->dev, rule_id);
+		goto free_rule;
+	}
+
+	vcap_rule_mod_key_u32(vrule, VCAP_KF_IF_IGR_PORT_MASK, value, mask);
+	err = vcap_mod_rule(vrule);
+
+free_rule:
+	vcap_free_rule(vrule);
+	return err;
+}
+
+static int lan966x_ptp_add_l2_key(struct vcap_rule *vrule,
+				  struct lan966x_port *port)
+{
+	return vcap_rule_add_key_u32(vrule, VCAP_KF_ETYPE, ETH_P_1588, ~0);
+}
+
+static int lan966x_ptp_add_ip_event_key(struct vcap_rule *vrule,
+					struct lan966x_port *port)
+{
+	return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, PTP_EV_PORT, ~0) ||
+	       vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
+}
+
+static int lan966x_ptp_add_ip_general_key(struct vcap_rule *vrule,
+					  struct lan966x_port *port)
+{
+	return vcap_rule_add_key_u32(vrule, VCAP_KF_L4_DPORT, PTP_GEN_PORT, ~0) ||
+	       vcap_rule_add_key_bit(vrule, VCAP_KF_TCP_IS, VCAP_BIT_0);
+}
+
+static int lan966x_ptp_add_l2_rule(struct lan966x_port *port)
+{
+	return lan966x_ptp_add_trap(port, lan966x_ptp_add_l2_key,
+				    LAN966X_VCAP_L2_PTP_TRAP, ETH_P_ALL);
+}
+
+static int lan966x_ptp_add_ipv4_rules(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_event_key,
+				   LAN966X_VCAP_IPV4_EV_PTP_TRAP, ETH_P_IP);
+	if (err)
+		return err;
+
+	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_general_key,
+				   LAN966X_VCAP_IPV4_GEN_PTP_TRAP, ETH_P_IP);
+	if (err)
+		lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV4_EV_PTP_TRAP);
+
+	return err;
+}
+
+static int lan966x_ptp_add_ipv6_rules(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_event_key,
+				   LAN966X_VCAP_IPV6_EV_PTP_TRAP, ETH_P_IPV6);
+	if (err)
+		return err;
+
+	err = lan966x_ptp_add_trap(port, lan966x_ptp_add_ip_general_key,
+				   LAN966X_VCAP_IPV6_GEN_PTP_TRAP, ETH_P_IPV6);
+	if (err)
+		lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV6_EV_PTP_TRAP);
+
+	return err;
+}
+
+static int lan966x_ptp_del_l2_rule(struct lan966x_port *port)
+{
+	return lan966x_ptp_del_trap(port, LAN966X_VCAP_L2_PTP_TRAP);
+}
+
+static int lan966x_ptp_del_ipv4_rules(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV4_EV_PTP_TRAP);
+	err |= lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV4_GEN_PTP_TRAP);
+
+	return err;
+}
+
+static int lan966x_ptp_del_ipv6_rules(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV6_EV_PTP_TRAP);
+	err |= lan966x_ptp_del_trap(port, LAN966X_VCAP_IPV6_GEN_PTP_TRAP);
+
+	return err;
+}
+
+static int lan966x_ptp_add_traps(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_add_l2_rule(port);
+	if (err)
+		goto err_l2;
+
+	err = lan966x_ptp_add_ipv4_rules(port);
+	if (err)
+		goto err_ipv4;
+
+	err = lan966x_ptp_add_ipv6_rules(port);
+	if (err)
+		goto err_ipv6;
+
+	return err;
+
+err_ipv6:
+	lan966x_ptp_del_ipv4_rules(port);
+err_ipv4:
+	lan966x_ptp_del_l2_rule(port);
+err_l2:
+	return err;
+}
+
+int lan966x_ptp_del_traps(struct lan966x_port *port)
+{
+	int err;
+
+	err = lan966x_ptp_del_l2_rule(port);
+	err |= lan966x_ptp_del_ipv4_rules(port);
+	err |= lan966x_ptp_del_ipv6_rules(port);
+
+	return err;
+}
+
+int lan966x_ptp_setup_traps(struct lan966x_port *port, struct ifreq *ifr)
+{
+	struct hwtstamp_config cfg;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.rx_filter == HWTSTAMP_FILTER_NONE)
+		return lan966x_ptp_del_traps(port);
+	else
+		return lan966x_ptp_add_traps(port);
+}
+
 int lan966x_ptp_hwtstamp_set(struct lan966x_port *port, struct ifreq *ifr)
 {
 	struct lan966x *lan966x = port->lan966x;
 	struct hwtstamp_config cfg;
 	struct lan966x_phc *phc;
 
-	/* For now don't allow to run ptp on ports that are part of a bridge,
-	 * because in case of transparent clock the HW will still forward the
-	 * frames, so there would be duplicate frames
-	 */
-	if (lan966x->bridge_mask & BIT(port->chip_port))
-		return -EINVAL;
-
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
index 04a2afd683cca..ba3fa917d6b78 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_tc_flower.c
@@ -4,14 +4,6 @@
 #include "vcap_api.h"
 #include "vcap_api_client.h"
 
-/* Controls how PORT_MASK is applied */
-enum LAN966X_PORT_MASK_MODE {
-	LAN966X_PMM_NO_ACTION,
-	LAN966X_PMM_REPLACE,
-	LAN966X_PMM_FORWARDING,
-	LAN966X_PMM_REDIRECT,
-};
-
 struct lan966x_tc_flower_parse_usage {
 	struct flow_cls_offload *f;
 	struct flow_rule *frule;
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 44f40d9149470..d8dc9fbb81e1a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -5,10 +5,6 @@
 #include "vcap_api.h"
 #include "vcap_api_client.h"
 
-#define LAN966X_VCAP_CID_IS2_L0 VCAP_CID_INGRESS_STAGE2_L0 /* IS2 lookup 0 */
-#define LAN966X_VCAP_CID_IS2_L1 VCAP_CID_INGRESS_STAGE2_L1 /* IS2 lookup 1 */
-#define LAN966X_VCAP_CID_IS2_MAX (VCAP_CID_INGRESS_STAGE2_L2 - 1) /* IS2 Max */
-
 #define STREAMSIZE (64 * 4)
 
 #define LAN966X_IS2_LOOKUPS 2
@@ -219,9 +215,12 @@ static void lan966x_vcap_add_default_fields(struct net_device *dev,
 					    struct vcap_rule *rule)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	u32 value, mask;
 
-	vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0,
-			      ~BIT(port->chip_port));
+	if (vcap_rule_get_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK,
+				  &value, &mask))
+		vcap_rule_add_key_u32(rule, VCAP_KF_IF_IGR_PORT_MASK, 0,
+				      ~BIT(port->chip_port));
 
 	if (lan966x_vcap_is_first_chain(rule))
 		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS,
-- 
2.38.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C0655ECD7D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiI0T70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232425AbiI0T65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:58:57 -0400
Received: from mx08lb.world4you.com (mx08lb.world4you.com [81.19.149.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1DE71CD134;
        Tue, 27 Sep 2022 12:58:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pdv64lbOXgiLrGKDi4zmXfWkT0tm4AeV7RFBw61vbEA=; b=iGVrli2cy++TG+v5i9GX8AOmoI
        qgSXnurxJm+fbS/Fa6vnYa18iD0PIBOQ23YxzsSEPLIWBOIxdZlqm04b5jBVEJh9sUrX7Bu0BByci
        bVgidz2K3UmoNXowM+Se5Q/IeCgjL++0tjeQq4FhK6sW9dBizvjrHZoCsqU2BMz1P88c=;
Received: from 88-117-54-199.adsl.highway.telekom.at ([88.117.54.199] helo=hornet.engleder.at)
        by mx08lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1odGjA-0005u7-LJ; Tue, 27 Sep 2022 21:58:48 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 5/6] tsnep: Add EtherType RX flow classification support
Date:   Tue, 27 Sep 2022 21:58:41 +0200
Message-Id: <20220927195842.44641-6-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220927195842.44641-1-gerhard@engleder-embedded.com>
References: <20220927195842.44641-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Received Ethernet frames are assigned to first RX queue per default.
Based on EtherType Ethernet frames can be assigned to other RX queues.
This enables processing of real-time Ethernet protocols on dedicated
RX queues.

Add RX flow classification interface for EtherType based RX queue
assignment.

Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/Makefile        |   2 +-
 drivers/net/ethernet/engleder/tsnep.h         |  36 ++
 drivers/net/ethernet/engleder/tsnep_ethtool.c |  40 +++
 drivers/net/ethernet/engleder/tsnep_hw.h      |  12 +-
 drivers/net/ethernet/engleder/tsnep_main.c    |  11 +
 drivers/net/ethernet/engleder/tsnep_rxnfc.c   | 307 ++++++++++++++++++
 6 files changed, 403 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/ethernet/engleder/tsnep_rxnfc.c

diff --git a/drivers/net/ethernet/engleder/Makefile b/drivers/net/ethernet/engleder/Makefile
index cce2191cb889..b6e3b16623de 100644
--- a/drivers/net/ethernet/engleder/Makefile
+++ b/drivers/net/ethernet/engleder/Makefile
@@ -6,5 +6,5 @@
 obj-$(CONFIG_TSNEP) += tsnep.o
 
 tsnep-objs := tsnep_main.o tsnep_ethtool.o tsnep_ptp.o tsnep_tc.o \
-	      $(tsnep-y)
+	      tsnep_rxnfc.o $(tsnep-y)
 tsnep-$(CONFIG_TSNEP_SELFTESTS) += tsnep_selftests.o
diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
index 62a279bcb011..2ca34ae9b55a 100644
--- a/drivers/net/ethernet/engleder/tsnep.h
+++ b/drivers/net/ethernet/engleder/tsnep.h
@@ -37,6 +37,24 @@ struct tsnep_gcl {
 	bool change;
 };
 
+enum tsnep_rxnfc_filter_type {
+	TSNEP_RXNFC_ETHER_TYPE,
+};
+
+struct tsnep_rxnfc_filter {
+	enum tsnep_rxnfc_filter_type type;
+	union {
+		u16 ether_type;
+	};
+};
+
+struct tsnep_rxnfc_rule {
+	struct list_head list;
+	struct tsnep_rxnfc_filter filter;
+	int queue_index;
+	int location;
+};
+
 struct tsnep_tx_entry {
 	struct tsnep_tx_desc *desc;
 	struct tsnep_tx_desc_wb *desc_wb;
@@ -141,6 +159,12 @@ struct tsnep_adapter {
 	/* ptp clock lock */
 	spinlock_t ptp_lock;
 
+	/* RX flow classification rules lock */
+	struct mutex rxnfc_lock;
+	struct list_head rxnfc_rules;
+	int rxnfc_count;
+	int rxnfc_max;
+
 	int num_tx_queues;
 	struct tsnep_tx tx[TSNEP_MAX_QUEUES];
 	int num_rx_queues;
@@ -161,6 +185,18 @@ void tsnep_tc_cleanup(struct tsnep_adapter *adapter);
 int tsnep_tc_setup(struct net_device *netdev, enum tc_setup_type type,
 		   void *type_data);
 
+int tsnep_rxnfc_init(struct tsnep_adapter *adapter);
+void tsnep_rxnfc_cleanup(struct tsnep_adapter *adapter);
+int tsnep_rxnfc_get_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd);
+int tsnep_rxnfc_get_all(struct tsnep_adapter *adapter,
+			struct ethtool_rxnfc *cmd,
+			u32 *rule_locs);
+int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd);
+int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd);
+
 #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
 int tsnep_ethtool_get_test_count(void);
 void tsnep_ethtool_get_test_strings(u8 *data);
diff --git a/drivers/net/ethernet/engleder/tsnep_ethtool.c b/drivers/net/ethernet/engleder/tsnep_ethtool.c
index e6760dc68ddd..a713a126b227 100644
--- a/drivers/net/ethernet/engleder/tsnep_ethtool.c
+++ b/drivers/net/ethernet/engleder/tsnep_ethtool.c
@@ -250,6 +250,44 @@ static int tsnep_ethtool_get_sset_count(struct net_device *netdev, int sset)
 	}
 }
 
+static int tsnep_ethtool_get_rxnfc(struct net_device *dev,
+				   struct ethtool_rxnfc *cmd, u32 *rule_locs)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+
+	switch (cmd->cmd) {
+	case ETHTOOL_GRXRINGS:
+		cmd->data = adapter->num_rx_queues;
+		return 0;
+	case ETHTOOL_GRXCLSRLCNT:
+		cmd->rule_cnt = adapter->rxnfc_count;
+		cmd->data = adapter->rxnfc_max;
+		cmd->data |= RX_CLS_LOC_SPECIAL;
+		return 0;
+	case ETHTOOL_GRXCLSRULE:
+		return tsnep_rxnfc_get_rule(adapter, cmd);
+	case ETHTOOL_GRXCLSRLALL:
+		return tsnep_rxnfc_get_all(adapter, cmd, rule_locs);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static int tsnep_ethtool_set_rxnfc(struct net_device *dev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct tsnep_adapter *adapter = netdev_priv(dev);
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		return tsnep_rxnfc_add_rule(adapter, cmd);
+	case ETHTOOL_SRXCLSRLDEL:
+		return tsnep_rxnfc_del_rule(adapter, cmd);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int tsnep_ethtool_get_ts_info(struct net_device *dev,
 				     struct ethtool_ts_info *info)
 {
@@ -287,6 +325,8 @@ const struct ethtool_ops tsnep_ethtool_ops = {
 	.get_strings = tsnep_ethtool_get_strings,
 	.get_ethtool_stats = tsnep_ethtool_get_ethtool_stats,
 	.get_sset_count = tsnep_ethtool_get_sset_count,
+	.get_rxnfc = tsnep_ethtool_get_rxnfc,
+	.set_rxnfc = tsnep_ethtool_set_rxnfc,
 	.get_ts_info = tsnep_ethtool_get_ts_info,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index e6cc6fbaf0d7..315dada75323 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -122,10 +122,6 @@
 #define TSNEP_RX_STATISTIC_BUFFER_TOO_SMALL 0x0191
 #define TSNEP_RX_STATISTIC_FIFO_OVERFLOW 0x0192
 #define TSNEP_RX_STATISTIC_INVALID_FRAME 0x0193
-#define TSNEP_RX_ASSIGN 0x01A0
-#define TSNEP_RX_ASSIGN_ETHER_TYPE_ACTIVE 0x00000001
-#define TSNEP_RX_ASSIGN_ETHER_TYPE_MASK 0xFFFF0000
-#define TSNEP_RX_ASSIGN_ETHER_TYPE_SHIFT 16
 #define TSNEP_MAC_ADDRESS_LOW 0x0800
 #define TSNEP_MAC_ADDRESS_HIGH 0x0804
 #define TSNEP_RX_FILTER 0x0806
@@ -152,6 +148,14 @@
 #define TSNEP_GCL_A 0x2000
 #define TSNEP_GCL_B 0x2800
 #define TSNEP_GCL_SIZE SZ_2K
+#define TSNEP_RX_ASSIGN 0x0840
+#define TSNEP_RX_ASSIGN_ACTIVE 0x00000001
+#define TSNEP_RX_ASSIGN_QUEUE_MASK 0x00000006
+#define TSNEP_RX_ASSIGN_QUEUE_SHIFT 1
+#define TSNEP_RX_ASSIGN_OFFSET 1
+#define TSNEP_RX_ASSIGN_ETHER_TYPE 0x0880
+#define TSNEP_RX_ASSIGN_ETHER_TYPE_OFFSET 2
+#define TSNEP_RX_ASSIGN_ETHER_TYPE_COUNT 2
 
 /* tsnep gate control list operation */
 struct tsnep_gcl_operation {
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index bf088b91efb7..a6b81f32d76b 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1341,6 +1341,8 @@ static int tsnep_probe(struct platform_device *pdev)
 	netdev->max_mtu = TSNEP_MAX_FRAME_SIZE;
 
 	mutex_init(&adapter->gate_control_lock);
+	mutex_init(&adapter->rxnfc_lock);
+	INIT_LIST_HEAD(&adapter->rxnfc_rules);
 
 	io = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	adapter->addr = devm_ioremap_resource(&pdev->dev, io);
@@ -1354,6 +1356,7 @@ static int tsnep_probe(struct platform_device *pdev)
 	version = (type & ECM_VERSION_MASK) >> ECM_VERSION_SHIFT;
 	queue_count = (type & ECM_QUEUE_COUNT_MASK) >> ECM_QUEUE_COUNT_SHIFT;
 	adapter->gate_control = type & ECM_GATE_CONTROL;
+	adapter->rxnfc_max = TSNEP_RX_ASSIGN_ETHER_TYPE_COUNT;
 
 	tsnep_disable_irq(adapter, ECM_INT_ALL);
 
@@ -1388,6 +1391,10 @@ static int tsnep_probe(struct platform_device *pdev)
 	if (retval)
 		goto tc_init_failed;
 
+	retval = tsnep_rxnfc_init(adapter);
+	if (retval)
+		goto rxnfc_init_failed;
+
 	netdev->netdev_ops = &tsnep_netdev_ops;
 	netdev->ethtool_ops = &tsnep_ethtool_ops;
 	netdev->features = NETIF_F_SG;
@@ -1408,6 +1415,8 @@ static int tsnep_probe(struct platform_device *pdev)
 	return 0;
 
 register_failed:
+	tsnep_rxnfc_cleanup(adapter);
+rxnfc_init_failed:
 	tsnep_tc_cleanup(adapter);
 tc_init_failed:
 	tsnep_ptp_cleanup(adapter);
@@ -1425,6 +1434,8 @@ static int tsnep_remove(struct platform_device *pdev)
 
 	unregister_netdev(adapter->netdev);
 
+	tsnep_rxnfc_cleanup(adapter);
+
 	tsnep_tc_cleanup(adapter);
 
 	tsnep_ptp_cleanup(adapter);
diff --git a/drivers/net/ethernet/engleder/tsnep_rxnfc.c b/drivers/net/ethernet/engleder/tsnep_rxnfc.c
new file mode 100644
index 000000000000..9ac2a0cf3833
--- /dev/null
+++ b/drivers/net/ethernet/engleder/tsnep_rxnfc.c
@@ -0,0 +1,307 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2022 Gerhard Engleder <gerhard@engleder-embedded.com> */
+
+#include "tsnep.h"
+
+#define ETHER_TYPE_FULL_MASK ((__force __be16)~0)
+
+static void tsnep_enable_rule(struct tsnep_adapter *adapter,
+			      struct tsnep_rxnfc_rule *rule)
+{
+	u8 rx_assign;
+	void __iomem *addr;
+
+	rx_assign = TSNEP_RX_ASSIGN_ACTIVE;
+	rx_assign |= (rule->queue_index << TSNEP_RX_ASSIGN_QUEUE_SHIFT) &
+		     TSNEP_RX_ASSIGN_QUEUE_MASK;
+
+	addr = adapter->addr + TSNEP_RX_ASSIGN_ETHER_TYPE +
+	       TSNEP_RX_ASSIGN_ETHER_TYPE_OFFSET * rule->location;
+	iowrite16(rule->filter.ether_type, addr);
+
+	/* enable rule after all settings are done */
+	addr = adapter->addr + TSNEP_RX_ASSIGN +
+	       TSNEP_RX_ASSIGN_OFFSET * rule->location;
+	iowrite8(rx_assign, addr);
+}
+
+static void tsnep_disable_rule(struct tsnep_adapter *adapter,
+			       struct tsnep_rxnfc_rule *rule)
+{
+	void __iomem *addr;
+
+	addr = adapter->addr + TSNEP_RX_ASSIGN +
+	       TSNEP_RX_ASSIGN_OFFSET * rule->location;
+	iowrite8(0, addr);
+}
+
+static struct tsnep_rxnfc_rule *tsnep_get_rule(struct tsnep_adapter *adapter,
+					       int location)
+{
+	struct tsnep_rxnfc_rule *rule;
+
+	list_for_each_entry(rule, &adapter->rxnfc_rules, list) {
+		if (rule->location == location)
+			return rule;
+		if (rule->location > location)
+			break;
+	}
+
+	return NULL;
+}
+
+static void tsnep_add_rule(struct tsnep_adapter *adapter,
+			   struct tsnep_rxnfc_rule *rule)
+{
+	struct tsnep_rxnfc_rule *pred, *cur;
+
+	tsnep_enable_rule(adapter, rule);
+
+	pred = NULL;
+	list_for_each_entry(cur, &adapter->rxnfc_rules, list) {
+		if (cur->location >= rule->location)
+			break;
+		pred = cur;
+	}
+
+	list_add(&rule->list, pred ? &pred->list : &adapter->rxnfc_rules);
+	adapter->rxnfc_count++;
+}
+
+static void tsnep_delete_rule(struct tsnep_adapter *adapter,
+			      struct tsnep_rxnfc_rule *rule)
+{
+	tsnep_disable_rule(adapter, rule);
+
+	list_del(&rule->list);
+	adapter->rxnfc_count--;
+
+	kfree(rule);
+}
+
+static void tsnep_flush_rules(struct tsnep_adapter *adapter)
+{
+	struct tsnep_rxnfc_rule *rule, *tmp;
+
+	mutex_lock(&adapter->rxnfc_lock);
+
+	list_for_each_entry_safe(rule, tmp, &adapter->rxnfc_rules, list)
+		tsnep_delete_rule(adapter, rule);
+
+	mutex_unlock(&adapter->rxnfc_lock);
+}
+
+int tsnep_rxnfc_get_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp = &cmd->fs;
+	struct tsnep_rxnfc_rule *rule = NULL;
+
+	cmd->data = adapter->rxnfc_max;
+
+	mutex_lock(&adapter->rxnfc_lock);
+
+	rule = tsnep_get_rule(adapter, fsp->location);
+	if (!rule) {
+		mutex_unlock(&adapter->rxnfc_lock);
+
+		return -ENOENT;
+	}
+
+	fsp->flow_type = ETHER_FLOW;
+	fsp->ring_cookie = rule->queue_index;
+
+	if (rule->filter.type == TSNEP_RXNFC_ETHER_TYPE) {
+		fsp->h_u.ether_spec.h_proto = htons(rule->filter.ether_type);
+		fsp->m_u.ether_spec.h_proto = ETHER_TYPE_FULL_MASK;
+	}
+
+	mutex_unlock(&adapter->rxnfc_lock);
+
+	return 0;
+}
+
+int tsnep_rxnfc_get_all(struct tsnep_adapter *adapter,
+			struct ethtool_rxnfc *cmd,
+			u32 *rule_locs)
+{
+	struct tsnep_rxnfc_rule *rule;
+	int count = 0;
+
+	cmd->data = adapter->rxnfc_max;
+
+	mutex_lock(&adapter->rxnfc_lock);
+
+	list_for_each_entry(rule, &adapter->rxnfc_rules, list) {
+		if (count == cmd->rule_cnt) {
+			mutex_unlock(&adapter->rxnfc_lock);
+
+			return -EMSGSIZE;
+		}
+
+		rule_locs[count] = rule->location;
+		count++;
+	}
+
+	mutex_unlock(&adapter->rxnfc_lock);
+
+	cmd->rule_cnt = count;
+
+	return 0;
+}
+
+static int tsnep_rxnfc_find_location(struct tsnep_adapter *adapter)
+{
+	struct tsnep_rxnfc_rule *tmp;
+	int location = 0;
+
+	list_for_each_entry(tmp, &adapter->rxnfc_rules, list) {
+		if (tmp->location == location)
+			location++;
+		else
+			return location;
+	}
+
+	if (location >= adapter->rxnfc_max)
+		return -ENOSPC;
+
+	return location;
+}
+
+static void tsnep_rxnfc_init_rule(struct tsnep_rxnfc_rule *rule,
+				  const struct ethtool_rx_flow_spec *fsp)
+{
+	INIT_LIST_HEAD(&rule->list);
+
+	rule->queue_index = fsp->ring_cookie;
+	rule->location = fsp->location;
+
+	rule->filter.type = TSNEP_RXNFC_ETHER_TYPE;
+	rule->filter.ether_type = ntohs(fsp->h_u.ether_spec.h_proto);
+}
+
+static int tsnep_rxnfc_check_rule(struct tsnep_adapter *adapter,
+				  struct tsnep_rxnfc_rule *rule)
+{
+	struct net_device *dev = adapter->netdev;
+	struct tsnep_rxnfc_rule *tmp;
+
+	list_for_each_entry(tmp, &adapter->rxnfc_rules, list) {
+		if (!memcmp(&rule->filter, &tmp->filter, sizeof(rule->filter)) &&
+		    tmp->location != rule->location) {
+			netdev_dbg(dev, "rule already exists\n");
+
+			return -EEXIST;
+		}
+	}
+
+	return 0;
+}
+
+int tsnep_rxnfc_add_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd)
+{
+	struct net_device *netdev = adapter->netdev;
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct tsnep_rxnfc_rule *rule, *old_rule;
+	int retval;
+
+	/* only EtherType is supported */
+	if (fsp->flow_type != ETHER_FLOW ||
+	    !is_zero_ether_addr(fsp->m_u.ether_spec.h_dest) ||
+	    !is_zero_ether_addr(fsp->m_u.ether_spec.h_source) ||
+	    fsp->m_u.ether_spec.h_proto != ETHER_TYPE_FULL_MASK) {
+		netdev_dbg(netdev, "only ethernet protocol is supported\n");
+
+		return -EOPNOTSUPP;
+	}
+
+	if (fsp->ring_cookie >
+	    (TSNEP_RX_ASSIGN_QUEUE_MASK >> TSNEP_RX_ASSIGN_QUEUE_SHIFT)) {
+		netdev_dbg(netdev, "invalid action\n");
+
+		return -EINVAL;
+	}
+
+	if (fsp->location != RX_CLS_LOC_ANY &&
+	    fsp->location >= adapter->rxnfc_max) {
+		netdev_dbg(netdev, "invalid location\n");
+
+		return -EINVAL;
+	}
+
+	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
+	if (!rule)
+		return -ENOMEM;
+
+	mutex_lock(&adapter->rxnfc_lock);
+
+	if (fsp->location == RX_CLS_LOC_ANY) {
+		retval = tsnep_rxnfc_find_location(adapter);
+		if (retval < 0)
+			goto failed;
+		fsp->location = retval;
+	}
+
+	tsnep_rxnfc_init_rule(rule, fsp);
+
+	retval = tsnep_rxnfc_check_rule(adapter, rule);
+	if (retval)
+		goto failed;
+
+	old_rule = tsnep_get_rule(adapter, fsp->location);
+	if (old_rule)
+		tsnep_delete_rule(adapter, old_rule);
+
+	tsnep_add_rule(adapter, rule);
+
+	mutex_unlock(&adapter->rxnfc_lock);
+
+	return 0;
+
+failed:
+	mutex_unlock(&adapter->rxnfc_lock);
+	kfree(rule);
+	return retval;
+}
+
+int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
+			 struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec *fsp =
+		(struct ethtool_rx_flow_spec *)&cmd->fs;
+	struct tsnep_rxnfc_rule *rule;
+
+	mutex_lock(&adapter->rxnfc_lock);
+
+	rule = tsnep_get_rule(adapter, fsp->location);
+	if (!rule) {
+		mutex_unlock(&adapter->rxnfc_lock);
+
+		return -ENOENT;
+	}
+
+	tsnep_delete_rule(adapter, rule);
+
+	mutex_unlock(&adapter->rxnfc_lock);
+
+	return 0;
+}
+
+int tsnep_rxnfc_init(struct tsnep_adapter *adapter)
+{
+	int i;
+
+	/* disable all rules */
+	for (i = 0; i < adapter->rxnfc_max;
+	     i += sizeof(u32) / TSNEP_RX_ASSIGN_OFFSET)
+		iowrite32(0, adapter->addr + TSNEP_RX_ASSIGN + i);
+
+	return 0;
+}
+
+void tsnep_rxnfc_cleanup(struct tsnep_adapter *adapter)
+{
+	tsnep_flush_rules(adapter);
+}
-- 
2.30.2


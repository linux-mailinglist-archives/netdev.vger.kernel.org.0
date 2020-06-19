Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A51E200B4F
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 16:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgFSOWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 10:22:15 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:10459 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgFSOWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 10:22:13 -0400
Received: from vishal.asicdesigners.com (chethan-pc.asicdesigners.com [10.193.177.170] (may be forged))
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05JELtbd002529;
        Fri, 19 Jun 2020 07:22:06 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, rahul.lakkireddy@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next 2/5] cxgb4: add ethtool n-tuple filter insertion
Date:   Fri, 19 Jun 2020 19:51:36 +0530
Message-Id: <20200619142139.27982-3-vishal@chelsio.com>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200619142139.27982-1-vishal@chelsio.com>
References: <20200619142139.27982-1-vishal@chelsio.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to parse and insert ethtool n-tuple filters.
Translate n-tuple spec to flow spec and use the existing tc-flower
offload infra to insert ethtool n-tuple filters.

Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 .../ethernet/chelsio/cxgb4/cxgb4_ethtool.c    | 75 ++++++++++++++
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c |  5 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  | 97 ++++++++++---------
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |  3 +
 5 files changed, 135 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
index 51f1d5f87bc3..82fc09b6dc8e 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ethtool.c
@@ -11,6 +11,7 @@
 #include "t4fw_api.h"
 #include "cxgb4_cudbg.h"
 #include "cxgb4_filter.h"
+#include "cxgb4_tc_flower.h"
 
 #define EEPROM_MAGIC 0x38E2F10C
 
@@ -1635,6 +1636,79 @@ static int get_rxnfc(struct net_device *dev, struct ethtool_rxnfc *info,
 	return -EOPNOTSUPP;
 }
 
+/* Add Ethtool n-tuple filters. */
+static int cxgb4_ntuple_set_filter(struct net_device *netdev,
+				   struct ethtool_rxnfc *cmd)
+{
+	struct ethtool_rx_flow_spec_input input = {};
+	struct cxgb4_ethtool_filter_info *filter_info;
+	struct adapter *adapter = netdev2adap(netdev);
+	struct port_info *pi = netdev_priv(netdev);
+	struct ch_filter_specification fs;
+	struct ethtool_rx_flow_rule *flow;
+	u32 tid;
+	int ret;
+
+	if (!(adapter->flags & CXGB4_FULL_INIT_DONE))
+		return -EAGAIN;  /* can still change nfilters */
+
+	if (!adapter->ethtool_filters)
+		return -EOPNOTSUPP;
+
+	if (cmd->fs.location >= adapter->ethtool_filters->nentries) {
+		dev_err(adapter->pdev_dev,
+			"Location must be < %u",
+			adapter->ethtool_filters->nentries);
+		return -ERANGE;
+	}
+
+	if (test_bit(cmd->fs.location,
+		     adapter->ethtool_filters->port[pi->port_id].bmap))
+		return -EEXIST;
+
+	memset(&fs, 0, sizeof(fs));
+
+	input.fs = &cmd->fs;
+	flow = ethtool_rx_flow_rule_create(&input);
+	if (IS_ERR(flow)) {
+		ret = PTR_ERR(flow);
+		goto exit;
+	}
+
+	fs.hitcnts = 1;
+
+	ret = cxgb4_flow_rule_replace(netdev, flow->rule, cmd->fs.location,
+				      NULL, &fs, &tid);
+	if (ret)
+		goto free;
+
+	filter_info = &adapter->ethtool_filters->port[pi->port_id];
+
+	filter_info->loc_array[cmd->fs.location] = tid;
+	set_bit(cmd->fs.location, filter_info->bmap);
+	filter_info->in_use++;
+
+free:
+	ethtool_rx_flow_rule_destroy(flow);
+exit:
+	return ret;
+}
+
+static int set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
+{
+	int ret = -EOPNOTSUPP;
+
+	switch (cmd->cmd) {
+	case ETHTOOL_SRXCLSRLINS:
+		ret = cxgb4_ntuple_set_filter(dev, cmd);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
 static int set_dump(struct net_device *dev, struct ethtool_dump *eth_dump)
 {
 	struct adapter *adapter = netdev2adap(dev);
@@ -1840,6 +1914,7 @@ static const struct ethtool_ops cxgb_ethtool_ops = {
 	.get_regs_len      = get_regs_len,
 	.get_regs          = get_regs,
 	.get_rxnfc         = get_rxnfc,
+	.set_rxnfc         = set_rxnfc,
 	.get_rxfh_indir_size = get_rss_table_size,
 	.get_rxfh	   = get_rss_table,
 	.set_rxfh	   = set_rss_table,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index 796555255207..a12df792d832 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1152,6 +1152,11 @@ bool is_filter_exact_match(struct adapter *adap,
 	if (!is_hashfilter(adap))
 		return false;
 
+	if ((atomic_read(&adap->tids.hash_tids_in_use) +
+	     atomic_read(&adap->tids.tids_in_use)) >=
+	    (adap->tids.nhash + (adap->tids.stid_base - adap->tids.tid_base)))
+		return false;
+
 	 /* Keep tunnel VNI match disabled for hash-filters for now */
 	if (fs->mask.encap_vld)
 		return false;
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 501917751b7f..7423980bc49a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6371,7 +6371,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 			NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			NETIF_F_RXCSUM | NETIF_F_RXHASH | NETIF_F_GRO |
 			NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-			NETIF_F_HW_TC;
+			NETIF_F_HW_TC | NETIF_F_NTUPLE;
 
 		if (chip_ver > CHELSIO_T5) {
 			netdev->hw_enc_features |= NETIF_F_IP_CSUM |
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
index 4a5fa9eba0b6..222f4bc19908 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
@@ -81,19 +81,9 @@ static struct ch_tc_flower_entry *ch_flower_lookup(struct adapter *adap,
 }
 
 static void cxgb4_process_flow_match(struct net_device *dev,
-				     struct flow_cls_offload *cls,
+				     struct flow_rule *rule,
 				     struct ch_filter_specification *fs)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
-	u16 addr_type = 0;
-
-	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
-		struct flow_match_control match;
-
-		flow_rule_match_control(rule, &match);
-		addr_type = match.key->addr_type;
-	}
-
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_BASIC)) {
 		struct flow_match_basic match;
 		u16 ethtype_key, ethtype_mask;
@@ -116,7 +106,7 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		fs->mask.proto = match.mask->ip_proto;
 	}
 
-	if (addr_type == FLOW_DISSECTOR_KEY_IPV4_ADDRS) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV4_ADDRS)) {
 		struct flow_match_ipv4_addrs match;
 
 		flow_rule_match_ipv4_addrs(rule, &match);
@@ -131,7 +121,7 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 		memcpy(&fs->nat_fip[0], &match.key->src, sizeof(match.key->src));
 	}
 
-	if (addr_type == FLOW_DISSECTOR_KEY_IPV6_ADDRS) {
+	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_IPV6_ADDRS)) {
 		struct flow_match_ipv6_addrs match;
 
 		flow_rule_match_ipv6_addrs(rule, &match);
@@ -224,9 +214,8 @@ static void cxgb4_process_flow_match(struct net_device *dev,
 }
 
 static int cxgb4_validate_flow_match(struct net_device *dev,
-				     struct flow_cls_offload *cls)
+				     struct flow_rule *rule)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	u16 ethtype_mask = 0;
 	u16 ethtype_key = 0;
@@ -693,14 +682,11 @@ static void cxgb4_tc_flower_hash_prio_del(struct adapter *adap, u32 tc_prio)
 	spin_unlock_bh(&t->ftid_lock);
 }
 
-int cxgb4_tc_flower_replace(struct net_device *dev,
-			    struct flow_cls_offload *cls)
+int cxgb4_flow_rule_replace(struct net_device *dev, struct flow_rule *rule,
+			    u32 tc_prio, struct netlink_ext_ack *extack,
+			    struct ch_filter_specification *fs, u32 *tid)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
-	struct netlink_ext_ack *extack = cls->common.extack;
 	struct adapter *adap = netdev2adap(dev);
-	struct ch_tc_flower_entry *ch_flower;
-	struct ch_filter_specification *fs;
 	struct filter_ctx ctx;
 	u8 inet_family;
 	int fidx, ret;
@@ -708,18 +694,10 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	if (cxgb4_validate_flow_actions(dev, &rule->action, extack))
 		return -EOPNOTSUPP;
 
-	if (cxgb4_validate_flow_match(dev, cls))
+	if (cxgb4_validate_flow_match(dev, rule))
 		return -EOPNOTSUPP;
 
-	ch_flower = allocate_flower_entry();
-	if (!ch_flower) {
-		netdev_err(dev, "%s: ch_flower alloc failed.\n", __func__);
-		return -ENOMEM;
-	}
-
-	fs = &ch_flower->fs;
-	fs->hitcnts = 1;
-	cxgb4_process_flow_match(dev, cls, fs);
+	cxgb4_process_flow_match(dev, rule, fs);
 	cxgb4_process_flow_actions(dev, &rule->action, fs);
 
 	fs->hash = is_filter_exact_match(adap, fs);
@@ -730,12 +708,11 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	 * existing rules.
 	 */
 	fidx = cxgb4_get_free_ftid(dev, inet_family, fs->hash,
-				   cls->common.prio);
+				   tc_prio);
 	if (fidx < 0) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "No free LETCAM index available");
-		ret = -ENOMEM;
-		goto free_entry;
+		return -ENOMEM;
 	}
 
 	if (fidx < adap->tids.nhpftids) {
@@ -749,42 +726,70 @@ int cxgb4_tc_flower_replace(struct net_device *dev,
 	if (fs->hash)
 		fidx = 0;
 
-	fs->tc_prio = cls->common.prio;
-	fs->tc_cookie = cls->cookie;
+	fs->tc_prio = tc_prio;
 
 	init_completion(&ctx.completion);
 	ret = __cxgb4_set_filter(dev, fidx, fs, &ctx);
 	if (ret) {
 		netdev_err(dev, "%s: filter creation err %d\n",
 			   __func__, ret);
-		goto free_entry;
+		return ret;
 	}
 
 	/* Wait for reply */
 	ret = wait_for_completion_timeout(&ctx.completion, 10 * HZ);
-	if (!ret) {
-		ret = -ETIMEDOUT;
-		goto free_entry;
-	}
+	if (!ret)
+		return -ETIMEDOUT;
 
-	ret = ctx.result;
 	/* Check if hw returned error for filter creation */
+	if (ctx.result)
+		return ctx.result;
+
+	*tid = ctx.tid;
+
+	if (fs->hash)
+		cxgb4_tc_flower_hash_prio_add(adap, tc_prio);
+
+	return 0;
+}
+
+int cxgb4_tc_flower_replace(struct net_device *dev,
+			    struct flow_cls_offload *cls)
+{
+	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
+	struct netlink_ext_ack *extack = cls->common.extack;
+	struct adapter *adap = netdev2adap(dev);
+	struct ch_tc_flower_entry *ch_flower;
+	struct ch_filter_specification *fs;
+	int ret;
+
+	ch_flower = allocate_flower_entry();
+	if (!ch_flower) {
+		netdev_err(dev, "%s: ch_flower alloc failed.\n", __func__);
+		return -ENOMEM;
+	}
+
+	fs = &ch_flower->fs;
+	fs->hitcnts = 1;
+	fs->tc_cookie = cls->cookie;
+
+	ret = cxgb4_flow_rule_replace(dev, rule, cls->common.prio, extack, fs,
+				      &ch_flower->filter_id);
 	if (ret)
 		goto free_entry;
 
 	ch_flower->tc_flower_cookie = cls->cookie;
-	ch_flower->filter_id = ctx.tid;
 	ret = rhashtable_insert_fast(&adap->flower_tbl, &ch_flower->node,
 				     adap->flower_ht_params);
 	if (ret)
 		goto del_filter;
 
-	if (fs->hash)
-		cxgb4_tc_flower_hash_prio_add(adap, cls->common.prio);
-
 	return 0;
 
 del_filter:
+	if (fs->hash)
+		cxgb4_tc_flower_hash_prio_del(adap, cls->common.prio);
+
 	cxgb4_del_filter(dev, ch_flower->filter_id, &ch_flower->fs);
 
 free_entry:
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
index 0a30c96b81ff..7fa379749500 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.h
@@ -121,6 +121,9 @@ int cxgb4_tc_flower_destroy(struct net_device *dev,
 			    struct flow_cls_offload *cls);
 int cxgb4_tc_flower_stats(struct net_device *dev,
 			  struct flow_cls_offload *cls);
+int cxgb4_flow_rule_replace(struct net_device *dev, struct flow_rule *rule,
+			    u32 tc_prio, struct netlink_ext_ack *extack,
+			    struct ch_filter_specification *fs, u32 *tid);
 
 int cxgb4_init_tc_flower(struct adapter *adap);
 void cxgb4_cleanup_tc_flower(struct adapter *adap);
-- 
2.21.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1A547144E
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 15:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbhLKOyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 09:54:49 -0500
Received: from mga18.intel.com ([134.134.136.126]:8123 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229804AbhLKOys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Dec 2021 09:54:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639234488; x=1670770488;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=UOLKBoHSgO+0GowgGZAGTm6qW/9LK+in/UDqb9zQlK8=;
  b=ZbCrIgQckzL6RqCvvr4taDCYDYQgQOwv/ylOzvfQrtUTpeNbCmB0hKJN
   LiqoIEFYzDJMoyBjqfGb272HHETyTE/rkZObTw/PJaZoGt85MJ7oGEUBQ
   OGWU3ql+vpia9oAvZO4xujgbJ61WYryJtMDyXESKXVsxtbjcTi+ZfVtpk
   9NVYREGVih9iqLFjg6qCShnK+7SwtNxmM8Yb5VLXGfMxdQKyKbKP2isUH
   uwMcKuzjwKru0Z9OJQg+x87f2Dwgg5/oF2gZ+Z5Ef4ZQBiEDHDTkrvtgb
   nnCrSsfMEZHpID2FlN9lv7v+aD0ZdB/l6XdZf5sGysKMSV2AonNiOzK06
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10194"; a="225401487"
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="225401487"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2021 06:54:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,198,1635231600"; 
   d="scan'208";a="481046501"
Received: from p12hl98bong5.png.intel.com ([10.158.65.178])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2021 06:54:44 -0800
From:   Ong Boon Leong <boon.leong.ong@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com, Kurt Kanzenbach <kurt@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Yannick Vignon <yannick.vignon@oss.nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH net v2 1/1] net: stmmac: fix tc flower deletion for VLAN priority Rx steering
Date:   Sat, 11 Dec 2021 22:51:34 +0800
Message-Id: <20211211145134.630258-1-boon.leong.ong@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To replicate the issue:-

1) Add 1 flower filter for VLAN Priority based frame steering:-
$ IFDEVNAME=eth0
$ tc qdisc add dev $IFDEVNAME ingress
$ tc qdisc add dev $IFDEVNAME root mqprio num_tc 8 \
   map 0 1 2 3 4 5 6 7 0 0 0 0 0 0 0 0 \
   queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 hw 0
$ tc filter add dev $IFDEVNAME parent ffff: protocol 802.1Q \
   flower vlan_prio 0 hw_tc 0

2) Get the 'pref' id
$ tc filter show dev $IFDEVNAME ingress

3) Delete a specific tc flower record (say pref 49151)
$ tc filter del dev $IFDEVNAME parent ffff: pref 49151

From dmesg, we will observe kernel NULL pointer ooops

[  197.170464] BUG: kernel NULL pointer dereference, address: 0000000000000000
[  197.171367] #PF: supervisor read access in kernel mode
[  197.171367] #PF: error_code(0x0000) - not-present page
[  197.171367] PGD 0 P4D 0
[  197.171367] Oops: 0000 [#1] PREEMPT SMP NOPTI

<snip>

[  197.171367] RIP: 0010:tc_setup_cls+0x20b/0x4a0 [stmmac]

<snip>

[  197.171367] Call Trace:
[  197.171367]  <TASK>
[  197.171367]  ? __stmmac_disable_all_queues+0xa8/0xe0 [stmmac]
[  197.171367]  stmmac_setup_tc_block_cb+0x70/0x110 [stmmac]
[  197.171367]  tc_setup_cb_destroy+0xb3/0x180
[  197.171367]  fl_hw_destroy_filter+0x94/0xc0 [cls_flower]

The above issue is due to previous incorrect implementation of
tc_del_vlan_flow(), shown below, that uses flow_cls_offload_flow_rule()
to get struct flow_rule *rule which is no longer valid for tc filter
delete operation.

  struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
  struct flow_dissector *dissector = rule->match.dissector;

So, to ensure tc_del_vlan_flow() deletes the right VLAN cls record for
earlier configured RX queue (configured by hw_tc) in tc_add_vlan_flow(),
this patch introduces stmmac_rfs_entry as driver-side flow_cls_offload
record for 'RX frame steering' tc flower, currently used for VLAN
priority. The implementation has taken consideration for future extension
to include other type RX frame steering such as EtherType based.

v2:
 - Clean up overly extensive backtrace and rewrite git message to better
   explain the kernel NULL pointer issue.

Fixes: 0e039f5cf86c ("net: stmmac: add RX frame steering based on VLAN priority in tc flower")
Tested-by: Kurt Kanzenbach <kurt@linutronix.de>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  | 17 ++++
 .../net/ethernet/stmicro/stmmac/stmmac_tc.c   | 86 ++++++++++++++++---
 2 files changed, 90 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index 4f5292cadf5..18a262ef17f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -171,6 +171,19 @@ struct stmmac_flow_entry {
 	int is_l4;
 };
 
+/* Rx Frame Steering */
+enum stmmac_rfs_type {
+	STMMAC_RFS_T_VLAN,
+	STMMAC_RFS_T_MAX,
+};
+
+struct stmmac_rfs_entry {
+	unsigned long cookie;
+	int in_use;
+	int type;
+	int tc;
+};
+
 struct stmmac_priv {
 	/* Frequently used values are kept adjacent for cache effect */
 	u32 tx_coal_frames[MTL_MAX_TX_QUEUES];
@@ -288,6 +301,10 @@ struct stmmac_priv {
 	struct stmmac_tc_entry *tc_entries;
 	unsigned int flow_entries_max;
 	struct stmmac_flow_entry *flow_entries;
+	unsigned int rfs_entries_max[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_cnt[STMMAC_RFS_T_MAX];
+	unsigned int rfs_entries_total;
+	struct stmmac_rfs_entry *rfs_entries;
 
 	/* Pulse Per Second output */
 	struct stmmac_pps_cfg pps[STMMAC_PPS_MAX];
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
index 1c4ea0b1b84..d0a2b289f46 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_tc.c
@@ -232,11 +232,33 @@ static int tc_setup_cls_u32(struct stmmac_priv *priv,
 	}
 }
 
+static int tc_rfs_init(struct stmmac_priv *priv)
+{
+	int i;
+
+	priv->rfs_entries_max[STMMAC_RFS_T_VLAN] = 8;
+
+	for (i = 0; i < STMMAC_RFS_T_MAX; i++)
+		priv->rfs_entries_total += priv->rfs_entries_max[i];
+
+	priv->rfs_entries = devm_kcalloc(priv->device,
+					 priv->rfs_entries_total,
+					 sizeof(*priv->rfs_entries),
+					 GFP_KERNEL);
+	if (!priv->rfs_entries)
+		return -ENOMEM;
+
+	dev_info(priv->device, "Enabled RFS Flow TC (entries=%d)\n",
+		 priv->rfs_entries_total);
+
+	return 0;
+}
+
 static int tc_init(struct stmmac_priv *priv)
 {
 	struct dma_features *dma_cap = &priv->dma_cap;
 	unsigned int count;
-	int i;
+	int ret, i;
 
 	if (dma_cap->l3l4fnum) {
 		priv->flow_entries_max = dma_cap->l3l4fnum;
@@ -250,10 +272,14 @@ static int tc_init(struct stmmac_priv *priv)
 		for (i = 0; i < priv->flow_entries_max; i++)
 			priv->flow_entries[i].idx = i;
 
-		dev_info(priv->device, "Enabled Flow TC (entries=%d)\n",
+		dev_info(priv->device, "Enabled L3L4 Flow TC (entries=%d)\n",
 			 priv->flow_entries_max);
 	}
 
+	ret = tc_rfs_init(priv);
+	if (ret)
+		return -ENOMEM;
+
 	if (!priv->plat->fpe_cfg) {
 		priv->plat->fpe_cfg = devm_kzalloc(priv->device,
 						   sizeof(*priv->plat->fpe_cfg),
@@ -607,16 +633,45 @@ static int tc_del_flow(struct stmmac_priv *priv,
 	return ret;
 }
 
+static struct stmmac_rfs_entry *tc_find_rfs(struct stmmac_priv *priv,
+					    struct flow_cls_offload *cls,
+					    bool get_free)
+{
+	int i;
+
+	for (i = 0; i < priv->rfs_entries_total; i++) {
+		struct stmmac_rfs_entry *entry = &priv->rfs_entries[i];
+
+		if (entry->cookie == cls->cookie)
+			return entry;
+		if (get_free && entry->in_use == false)
+			return entry;
+	}
+
+	return NULL;
+}
+
 #define VLAN_PRIO_FULL_MASK (0x07)
 
 static int tc_add_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
 	struct flow_dissector *dissector = rule->match.dissector;
 	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
 	struct flow_match_vlan match;
 
+	if (!entry) {
+		entry = tc_find_rfs(priv, cls, true);
+		if (!entry)
+			return -ENOENT;
+	}
+
+	if (priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN] >=
+	    priv->rfs_entries_max[STMMAC_RFS_T_VLAN])
+		return -ENOENT;
+
 	/* Nothing to do here */
 	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
 		return -EINVAL;
@@ -638,6 +693,12 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 
 		prio = BIT(match.key->vlan_priority);
 		stmmac_rx_queue_prio(priv, priv->hw, prio, tc);
+
+		entry->in_use = true;
+		entry->cookie = cls->cookie;
+		entry->tc = tc;
+		entry->type = STMMAC_RFS_T_VLAN;
+		priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]++;
 	}
 
 	return 0;
@@ -646,20 +707,19 @@ static int tc_add_vlan_flow(struct stmmac_priv *priv,
 static int tc_del_vlan_flow(struct stmmac_priv *priv,
 			    struct flow_cls_offload *cls)
 {
-	struct flow_rule *rule = flow_cls_offload_flow_rule(cls);
-	struct flow_dissector *dissector = rule->match.dissector;
-	int tc = tc_classid_to_hwtc(priv->dev, cls->classid);
+	struct stmmac_rfs_entry *entry = tc_find_rfs(priv, cls, false);
 
-	/* Nothing to do here */
-	if (!dissector_uses_key(dissector, FLOW_DISSECTOR_KEY_VLAN))
-		return -EINVAL;
+	if (!entry || !entry->in_use || entry->type != STMMAC_RFS_T_VLAN)
+		return -ENOENT;
 
-	if (tc < 0) {
-		netdev_err(priv->dev, "Invalid traffic class\n");
-		return -EINVAL;
-	}
+	stmmac_rx_queue_prio(priv, priv->hw, 0, entry->tc);
+
+	entry->in_use = false;
+	entry->cookie = 0;
+	entry->tc = 0;
+	entry->type = 0;
 
-	stmmac_rx_queue_prio(priv, priv->hw, 0, tc);
+	priv->rfs_entries_cnt[STMMAC_RFS_T_VLAN]--;
 
 	return 0;
 }
-- 
2.25.1


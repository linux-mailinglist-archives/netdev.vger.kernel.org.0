Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADFF1DF443
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbgEWCvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:37985 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387492AbgEWCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:14 -0400
IronPort-SDR: lI9PvtebdyMZAWN6amNieM2XloX7LsDWT772LsARoBWRZuZeT/CWm78hwTwEgEtkW6xAs1J74u
 bBmCaF8deTpQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:12 -0700
IronPort-SDR: ukR+xLaTGeifE4PQHPmHX4TBMq9WwEwZyav1zKwFey/3h0EU84L+aB3rmbo7glz9JcpO70LrlP
 GvZ7PCxuKA/A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291084"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 06/17] igc: Fix NFC rules restoration
Date:   Fri, 22 May 2020 19:50:58 -0700
Message-Id: <20200523025109.3313635-7-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
References: <20200523025109.3313635-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

When network interface is brought up, the driver re-enables the NFC
rules previously configured. However, this is done in reverse order
the rules were added and hardware filters are configured differently.

For example, consider the following rules:

$ ethtool -N eth0 flow-type ether dst 00:00:00:00:00:AA queue 0
$ ethtool -N eth0 flow-type ether dst 00:00:00:00:00:BB queue 1
$ ethtool -N eth0 flow-type ether dst 00:00:00:00:00:CC queue 2
$ ethtool -N eth0 flow-type ether dst 00:00:00:00:00:DD queue 3

RAL/RAH registers are configure so filter index 1 has address ending
with AA, filter index 2 has address ending in BB, and so on.

If we bring the interface down and up again, RAL/RAH registers are
configured so filter index 1 has address ending in DD, filter index 2
has CC, and so on. IOW, in reverse order we had before bringing the
interface down.

This issue can be fixed by traversing adapter->nfc_rule_list in
backwards when restoring the rules. Since hlist doesn't support
backwards traversal, this patch replaces it by list_head and fixes
igc_restore_nfc_rules() accordingly.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  4 ++--
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 19 ++++++++-----------
 drivers/net/ethernet/intel/igc/igc_main.c    | 16 +++++++++-------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index ae7d48070ee2..76bc3a51ad70 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -191,7 +191,7 @@ struct igc_adapter {
 	 * nfc_rule_lock.
 	 */
 	spinlock_t nfc_rule_lock;
-	struct hlist_head nfc_rule_list;
+	struct list_head nfc_rule_list;
 	unsigned int nfc_rule_count;
 
 	u8 rss_indir_tbl[IGC_RETA_SIZE];
@@ -461,7 +461,7 @@ struct igc_nfc_filter {
 };
 
 struct igc_nfc_rule {
-	struct hlist_node nfc_node;
+	struct list_head list;
 	struct igc_nfc_filter filter;
 	u32 location;
 	u16 action;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index f01a7ec0c1c2..a90493fee0d2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -941,7 +941,7 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 
 	spin_lock(&adapter->nfc_rule_lock);
 
-	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
+	list_for_each_entry(rule, &adapter->nfc_rule_list, list) {
 		if (fsp->location <= rule->location)
 			break;
 	}
@@ -997,7 +997,7 @@ static int igc_ethtool_get_nfc_rules(struct igc_adapter *adapter,
 
 	spin_lock(&adapter->nfc_rule_lock);
 
-	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
+	list_for_each_entry(rule, &adapter->nfc_rule_list, list) {
 		if (cnt == cmd->rule_cnt) {
 			spin_unlock(&adapter->nfc_rule_lock);
 			return -EMSGSIZE;
@@ -1261,7 +1261,7 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 	parent = NULL;
 	rule = NULL;
 
-	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
+	list_for_each_entry(rule, &adapter->nfc_rule_list, list) {
 		/* hash found, or no matching entry */
 		if (rule->location >= location)
 			break;
@@ -1272,7 +1272,7 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 	if (rule && rule->location == location) {
 		err = igc_disable_nfc_rule(adapter, rule);
 
-		hlist_del(&rule->nfc_node);
+		list_del(&rule->list);
 		kfree(rule);
 		adapter->nfc_rule_count--;
 	}
@@ -1283,11 +1283,8 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 	if (!input)
 		return err;
 
-	/* add filter to the list */
-	if (parent)
-		hlist_add_behind(&input->nfc_node, &parent->nfc_node);
-	else
-		hlist_add_head(&input->nfc_node, &adapter->nfc_rule_list);
+	list_add(&input->list, parent ? &parent->list :
+					&adapter->nfc_rule_list);
 
 	/* update counts */
 	adapter->nfc_rule_count++;
@@ -1298,7 +1295,7 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
 				      const struct ethtool_rx_flow_spec *fsp)
 {
-	INIT_HLIST_NODE(&rule->nfc_node);
+	INIT_LIST_HEAD(&rule->list);
 
 	rule->action = fsp->ring_cookie;
 	rule->location = fsp->location;
@@ -1362,7 +1359,7 @@ static int igc_ethtool_check_nfc_rule(struct igc_adapter *adapter,
 		return -EOPNOTSUPP;
 	}
 
-	hlist_for_each_entry(tmp, &adapter->nfc_rule_list, nfc_node) {
+	list_for_each_entry(tmp, &adapter->nfc_rule_list, list) {
 		if (!memcmp(&rule->filter, &tmp->filter,
 			    sizeof(rule->filter))) {
 			netdev_dbg(dev, "Rule already exists\n");
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index acb8dfdf275f..cf76e2c1f9b1 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2180,7 +2180,7 @@ static void igc_restore_nfc_rules(struct igc_adapter *adapter)
 
 	spin_lock(&adapter->nfc_rule_lock);
 
-	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node)
+	list_for_each_entry_reverse(rule, &adapter->nfc_rule_list, list)
 		igc_enable_nfc_rule(adapter, rule);
 
 	spin_unlock(&adapter->nfc_rule_lock);
@@ -3419,6 +3419,9 @@ static int igc_sw_init(struct igc_adapter *adapter)
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
 	spin_lock_init(&adapter->nfc_rule_lock);
+	INIT_LIST_HEAD(&adapter->nfc_rule_list);
+	adapter->nfc_rule_count = 0;
+
 	spin_lock_init(&adapter->stats64_lock);
 	/* Assume MSI-X interrupts, will be checked during IRQ allocation */
 	adapter->flags |= IGC_FLAG_HAS_MSIX;
@@ -3651,7 +3654,7 @@ static void igc_nfc_rule_exit(struct igc_adapter *adapter)
 
 	spin_lock(&adapter->nfc_rule_lock);
 
-	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node)
+	list_for_each_entry(rule, &adapter->nfc_rule_list, list)
 		igc_disable_nfc_rule(adapter, rule);
 
 	spin_unlock(&adapter->nfc_rule_lock);
@@ -3826,14 +3829,13 @@ static int igc_set_features(struct net_device *netdev,
 		return 0;
 
 	if (!(features & NETIF_F_NTUPLE)) {
-		struct hlist_node *node2;
-		struct igc_nfc_rule *rule;
+		struct igc_nfc_rule *rule, *tmp;
 
 		spin_lock(&adapter->nfc_rule_lock);
-		hlist_for_each_entry_safe(rule, node2,
-					  &adapter->nfc_rule_list, nfc_node) {
+		list_for_each_entry_safe(rule, tmp,
+					 &adapter->nfc_rule_list, list) {
 			igc_disable_nfc_rule(adapter, rule);
-			hlist_del(&rule->nfc_node);
+			list_del(&rule->list);
 			kfree(rule);
 		}
 		spin_unlock(&adapter->nfc_rule_lock);
-- 
2.26.2


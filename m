Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0661DF439
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbgEWCvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:19 -0400
Received: from mga17.intel.com ([192.55.52.151]:37985 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387573AbgEWCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:17 -0400
IronPort-SDR: gKs5DJf7KI2N6R2lFsWG2XnFsQ4iwtPcHAeEyOehzJcBCUjoqKHKRjD9QzG+jDggAvuBfT0P3F
 IZILYz16BCeA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:13 -0700
IronPort-SDR: /TETNjL1bcwDQmHgfbC6JSzVnLu+oVOkeljlJ8YLq3HWnAo9vxoWgZNsMrjYG32TNBwcYAXOpe
 XYCBD6WP6q5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291118"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 11/17] igc: Change adapter->nfc_rule_lock to mutex
Date:   Fri, 22 May 2020 19:51:03 -0700
Message-Id: <20200523025109.3313635-12-jeffrey.t.kirsher@intel.com>
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

This patch changes adapter->nfc_rule_lock type from spin_lock to mutex
so we avoid unnecessary busy waiting on lock contention.

A closer look at the execution context of NFC rule API users shows that
all of them run in process context. The API users are: ethtool ops,
igc_configure(), called when interface is brought up by user or reset
workequeue thread, igc_down(), called when interface is brought down,
and igc_remove(), called when driver is unloaded.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 24 ++++++++++----------
 drivers/net/ethernet/intel/igc/igc_main.c    | 14 ++++++------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index a484b328268b..14f9edaaaf83 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -190,7 +190,7 @@ struct igc_adapter {
 	/* Any access to elements in nfc_rule_list is protected by the
 	 * nfc_rule_lock.
 	 */
-	spinlock_t nfc_rule_lock;
+	struct mutex nfc_rule_lock;
 	struct list_head nfc_rule_list;
 	unsigned int nfc_rule_count;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index d14c46dce053..946e775e34ae 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -939,7 +939,7 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 
 	cmd->data = IGC_MAX_RXNFC_RULES;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	rule = igc_get_nfc_rule(adapter, fsp->location);
 	if (!rule)
@@ -971,11 +971,11 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 		eth_broadcast_addr(fsp->m_u.ether_spec.h_source);
 	}
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 	return 0;
 
 out:
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 	return -EINVAL;
 }
 
@@ -988,18 +988,18 @@ static int igc_ethtool_get_nfc_rules(struct igc_adapter *adapter,
 
 	cmd->data = IGC_MAX_RXNFC_RULES;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	list_for_each_entry(rule, &adapter->nfc_rule_list, list) {
 		if (cnt == cmd->rule_cnt) {
-			spin_unlock(&adapter->nfc_rule_lock);
+			mutex_unlock(&adapter->nfc_rule_lock);
 			return -EMSGSIZE;
 		}
 		rule_locs[cnt] = rule->location;
 		cnt++;
 	}
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 
 	cmd->rule_cnt = cnt;
 
@@ -1303,7 +1303,7 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 
 	igc_ethtool_init_nfc_rule(rule, fsp);
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	err = igc_ethtool_check_nfc_rule(adapter, rule);
 	if (err)
@@ -1317,11 +1317,11 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 	if (err)
 		goto err;
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 	return 0;
 
 err:
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 	kfree(rule);
 	return err;
 }
@@ -1333,17 +1333,17 @@ static int igc_ethtool_del_nfc_rule(struct igc_adapter *adapter,
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
 	struct igc_nfc_rule *rule;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	rule = igc_get_nfc_rule(adapter, fsp->location);
 	if (!rule) {
-		spin_unlock(&adapter->nfc_rule_lock);
+		mutex_unlock(&adapter->nfc_rule_lock);
 		return -EINVAL;
 	}
 
 	igc_del_nfc_rule(adapter, rule);
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9338209cedf2..165263ae8add 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2539,12 +2539,12 @@ static void igc_flush_nfc_rules(struct igc_adapter *adapter)
 {
 	struct igc_nfc_rule *rule, *tmp;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	list_for_each_entry_safe(rule, tmp, &adapter->nfc_rule_list, list)
 		igc_del_nfc_rule(adapter, rule);
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 }
 
 /**
@@ -2583,24 +2583,24 @@ static void igc_restore_nfc_rules(struct igc_adapter *adapter)
 {
 	struct igc_nfc_rule *rule;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	list_for_each_entry_reverse(rule, &adapter->nfc_rule_list, list)
 		igc_enable_nfc_rule(adapter, rule);
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 }
 
 static void igc_nfc_rule_exit(struct igc_adapter *adapter)
 {
 	struct igc_nfc_rule *rule;
 
-	spin_lock(&adapter->nfc_rule_lock);
+	mutex_lock(&adapter->nfc_rule_lock);
 
 	list_for_each_entry(rule, &adapter->nfc_rule_list, list)
 		igc_disable_nfc_rule(adapter, rule);
 
-	spin_unlock(&adapter->nfc_rule_lock);
+	mutex_unlock(&adapter->nfc_rule_lock);
 }
 
 static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
@@ -3573,7 +3573,7 @@ static int igc_sw_init(struct igc_adapter *adapter)
 				VLAN_HLEN;
 	adapter->min_frame_size = ETH_ZLEN + ETH_FCS_LEN;
 
-	spin_lock_init(&adapter->nfc_rule_lock);
+	mutex_init(&adapter->nfc_rule_lock);
 	INIT_LIST_HEAD(&adapter->nfc_rule_list);
 	adapter->nfc_rule_count = 0;
 
-- 
2.26.2


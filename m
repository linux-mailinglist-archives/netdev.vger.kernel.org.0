Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D02291DF449
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbgEWCvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:49 -0400
Received: from mga17.intel.com ([192.55.52.151]:37984 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387481AbgEWCvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:13 -0400
IronPort-SDR: WocNqjvJgfa2x4K3+qF7rwr7qZwUqnvOj/Rmxk35T8UgZ5aK8ljOoYeUbtSzC+rfqRLQz6bGIo
 0G3yh4N3R2pw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:11 -0700
IronPort-SDR: i9siY/e2h+GTLmHTz5NDjV1BeFFGfItJrTC7xiNcgTYJ+W1JQL8mBjL4gHD+itpsps4EAJQ9U8
 arLqFDHHXL9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291063"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 02/17] igc: Fix 'sw_idx' type in struct igc_nfc_rule
Date:   Fri, 22 May 2020 19:50:54 -0700
Message-Id: <20200523025109.3313635-3-jeffrey.t.kirsher@intel.com>
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

The 'sw_idx' field from 'struct igc_nfc_rule' is u16 type but it is
assigned an u32 value in igc_ethtool_init_nfc_rule(). This patch changes
'sw_idx' type to u32 so they match. Also, it makes more sense to call
this field 'location' since it holds the NFC rule location.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  2 +-
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 16 ++++++++--------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index fcc6261d7f67..ae7d48070ee2 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -463,7 +463,7 @@ struct igc_nfc_filter {
 struct igc_nfc_rule {
 	struct hlist_node nfc_node;
 	struct igc_nfc_filter filter;
-	u16 sw_idx;
+	u32 location;
 	u16 action;
 };
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 1145c88a8e44..24aa321f64b5 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -940,11 +940,11 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 	cmd->data = IGC_MAX_RXNFC_RULES;
 
 	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
-		if (fsp->location <= rule->sw_idx)
+		if (fsp->location <= rule->location)
 			break;
 	}
 
-	if (!rule || fsp->location != rule->sw_idx)
+	if (!rule || fsp->location != rule->location)
 		return -EINVAL;
 
 	if (!rule->filter.match_flags)
@@ -991,7 +991,7 @@ static int igc_ethtool_get_nfc_rules(struct igc_adapter *adapter,
 	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
 		if (cnt == cmd->rule_cnt)
 			return -EMSGSIZE;
-		rule_locs[cnt] = rule->sw_idx;
+		rule_locs[cnt] = rule->location;
 		cnt++;
 	}
 
@@ -1240,7 +1240,7 @@ int igc_disable_nfc_rule(struct igc_adapter *adapter,
 
 static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 				       struct igc_nfc_rule *input,
-				       u16 sw_idx)
+				       u32 location)
 {
 	struct igc_nfc_rule *rule, *parent;
 	int err = -EINVAL;
@@ -1250,13 +1250,13 @@ static int igc_ethtool_update_nfc_rule(struct igc_adapter *adapter,
 
 	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
 		/* hash found, or no matching entry */
-		if (rule->sw_idx >= sw_idx)
+		if (rule->location >= location)
 			break;
 		parent = rule;
 	}
 
 	/* if there is an old rule occupying our place remove it */
-	if (rule && rule->sw_idx == sw_idx) {
+	if (rule && rule->location == location) {
 		if (!input)
 			err = igc_disable_nfc_rule(adapter, rule);
 
@@ -1289,7 +1289,7 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
 	INIT_HLIST_NODE(&rule->nfc_node);
 
 	rule->action = fsp->ring_cookie;
-	rule->sw_idx = fsp->location;
+	rule->location = fsp->location;
 
 	if ((fsp->flow_type & FLOW_EXT) && fsp->m_ext.vlan_tci) {
 		rule->filter.vlan_tci = ntohs(fsp->h_ext.vlan_tci);
@@ -1412,7 +1412,7 @@ static int igc_ethtool_add_nfc_rule(struct igc_adapter *adapter,
 	if (err)
 		goto err;
 
-	igc_ethtool_update_nfc_rule(adapter, rule, rule->sw_idx);
+	igc_ethtool_update_nfc_rule(adapter, rule, rule->location);
 
 	spin_unlock(&adapter->nfc_rule_lock);
 	return 0;
-- 
2.26.2


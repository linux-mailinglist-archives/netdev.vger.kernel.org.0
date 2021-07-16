Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896CA3CBE63
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 23:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbhGPVY3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 17:24:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:9331 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235209AbhGPVYU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 17:24:20 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10047"; a="197980603"
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="197980603"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2021 14:21:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,246,1620716400"; 
   d="scan'208";a="574434576"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga001.fm.intel.com with ESMTP; 16 Jul 2021 14:21:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Kurt Kanzenbach <kurt@linutronix.de>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: [PATCH net-next 4/5] igc: Make flex filter more flexible
Date:   Fri, 16 Jul 2021 14:24:26 -0700
Message-Id: <20210716212427.821834-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kurt Kanzenbach <kurt@linutronix.de>

Currently flex filters are only used for filters containing user data.
However, it makes sense to utilize them also for filters having
multiple conditions, because that's not supported by the driver at the
moment. Add it.

Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 27 ++++++++++++--------
 drivers/net/ethernet/intel/igc/igc_main.c    | 14 ++++------
 3 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index c21441c8908e..a0ecfe5a4078 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -507,6 +507,7 @@ struct igc_nfc_rule {
 	struct igc_nfc_filter filter;
 	u32 location;
 	u16 action;
+	bool flex;
 };
 
 /* IGC supports a total of 32 NFC rules: 16 MAC address based, 8 VLAN priority
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 5a7b27b2a95c..d3e84416248e 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1222,19 +1222,29 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
 				fsp->h_u.ether_spec.h_dest);
 	}
 
+	/* VLAN etype matching */
+	if ((fsp->flow_type & FLOW_EXT) && fsp->h_ext.vlan_etype) {
+		rule->filter.vlan_etype = fsp->h_ext.vlan_etype;
+		rule->filter.match_flags |= IGC_FILTER_FLAG_VLAN_ETYPE;
+	}
+
 	/* Check for user defined data */
 	if ((fsp->flow_type & FLOW_EXT) &&
 	    (fsp->h_ext.data[0] || fsp->h_ext.data[1])) {
 		rule->filter.match_flags |= IGC_FILTER_FLAG_USER_DATA;
 		memcpy(rule->filter.user_data, fsp->h_ext.data, sizeof(fsp->h_ext.data));
 		memcpy(rule->filter.user_mask, fsp->m_ext.data, sizeof(fsp->m_ext.data));
-
-		/* VLAN etype matching is only valid using flex filter */
-		if ((fsp->flow_type & FLOW_EXT) && fsp->h_ext.vlan_etype) {
-			rule->filter.vlan_etype = fsp->h_ext.vlan_etype;
-			rule->filter.match_flags |= IGC_FILTER_FLAG_VLAN_ETYPE;
-		}
 	}
+
+	/* When multiple filter options or user data or vlan etype is set, use a
+	 * flex filter.
+	 */
+	if ((rule->filter.match_flags & IGC_FILTER_FLAG_USER_DATA) ||
+	    (rule->filter.match_flags & IGC_FILTER_FLAG_VLAN_ETYPE) ||
+	    (rule->filter.match_flags & (rule->filter.match_flags - 1)))
+		rule->flex = true;
+	else
+		rule->flex = false;
 }
 
 /**
@@ -1264,11 +1274,6 @@ static int igc_ethtool_check_nfc_rule(struct igc_adapter *adapter,
 		return -EINVAL;
 	}
 
-	if (flags & (flags - 1)) {
-		netdev_dbg(dev, "Rule with multiple matches not supported\n");
-		return -EOPNOTSUPP;
-	}
-
 	list_for_each_entry(tmp, &adapter->nfc_rule_list, list) {
 		if (!memcmp(&rule->filter, &tmp->filter,
 			    sizeof(rule->filter)) &&
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 9999d8fc640b..11385c380947 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3385,14 +3385,8 @@ static int igc_enable_nfc_rule(struct igc_adapter *adapter,
 {
 	int err;
 
-	/* Check for user data first: When user data is set, the only option is
-	 * to use a flex filter. When more options are set (ethertype, vlan tci,
-	 * ...) construct a flex filter matching all of that.
-	 */
-	if (rule->filter.match_flags & IGC_FILTER_FLAG_USER_DATA) {
-		err = igc_add_flex_filter(adapter, rule);
-		if (err)
-			return err;
+	if (rule->flex) {
+		return igc_add_flex_filter(adapter, rule);
 	}
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE) {
@@ -3431,8 +3425,10 @@ static int igc_enable_nfc_rule(struct igc_adapter *adapter,
 static void igc_disable_nfc_rule(struct igc_adapter *adapter,
 				 const struct igc_nfc_rule *rule)
 {
-	if (rule->filter.match_flags & IGC_FILTER_FLAG_USER_DATA)
+	if (rule->flex) {
 		igc_del_flex_filter(adapter, rule->filter.flex_index);
+		return;
+	}
 
 	if (rule->filter.match_flags & IGC_FILTER_FLAG_ETHER_TYPE)
 		igc_del_etype_filter(adapter, rule->filter.etype);
-- 
2.26.2


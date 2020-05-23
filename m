Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7AF1DF448
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387642AbgEWCvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387525AbgEWCvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:13 -0400
IronPort-SDR: wqfZVDMsP+y/Mik4I9ZbrJPsMoCMQVIhG3QE2clkLyHTwOJ0gv6Waf6SN3+dur1v2BeEO2AbrL
 +GjQ8v5V0bwg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:11 -0700
IronPort-SDR: 4FL7jEgFlTjDY9HgtzXSIMDjgW0Ck0hq4CQtifBvKsi2YnhCV1BNvKiSh8eP4fh21LV1mpKZUj
 6UrOrDXkb/Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291066"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 03/17] igc: Fix locking issue when retrieving NFC rules
Date:   Fri, 22 May 2020 19:50:55 -0700
Message-Id: <20200523025109.3313635-4-jeffrey.t.kirsher@intel.com>
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

Access to NFC rules stored in adapter->nfc_rule_list is protect by
adapter->nfc_rule_lock. The functions igc_ethtool_get_nfc_rule()
and igc_ethtool_get_nfc_rules() are missing to hold the lock while
accessing rule objects.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 24aa321f64b5..decd29fbfbe2 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -939,16 +939,18 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 
 	cmd->data = IGC_MAX_RXNFC_RULES;
 
+	spin_lock(&adapter->nfc_rule_lock);
+
 	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
 		if (fsp->location <= rule->location)
 			break;
 	}
 
 	if (!rule || fsp->location != rule->location)
-		return -EINVAL;
+		goto out;
 
 	if (!rule->filter.match_flags)
-		return -EINVAL;
+		goto out;
 
 	fsp->flow_type = ETHER_FLOW;
 	fsp->ring_cookie = rule->action;
@@ -976,7 +978,12 @@ static int igc_ethtool_get_nfc_rule(struct igc_adapter *adapter,
 		eth_broadcast_addr(fsp->m_u.ether_spec.h_source);
 	}
 
+	spin_unlock(&adapter->nfc_rule_lock);
 	return 0;
+
+out:
+	spin_unlock(&adapter->nfc_rule_lock);
+	return -EINVAL;
 }
 
 static int igc_ethtool_get_nfc_rules(struct igc_adapter *adapter,
@@ -988,13 +995,19 @@ static int igc_ethtool_get_nfc_rules(struct igc_adapter *adapter,
 
 	cmd->data = IGC_MAX_RXNFC_RULES;
 
+	spin_lock(&adapter->nfc_rule_lock);
+
 	hlist_for_each_entry(rule, &adapter->nfc_rule_list, nfc_node) {
-		if (cnt == cmd->rule_cnt)
+		if (cnt == cmd->rule_cnt) {
+			spin_unlock(&adapter->nfc_rule_lock);
 			return -EMSGSIZE;
+		}
 		rule_locs[cnt] = rule->location;
 		cnt++;
 	}
 
+	spin_unlock(&adapter->nfc_rule_lock);
+
 	cmd->rule_cnt = cnt;
 
 	return 0;
-- 
2.26.2


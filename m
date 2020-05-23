Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98A41DF447
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387637AbgEWCvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:45 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387490AbgEWCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:14 -0400
IronPort-SDR: r9DxzVrFBwLCYFHnJnxp35TSNGwGw5EAi8feoqX0d7EqgDhZq4obgt1J9Lesq3AXvi8ISqOPF/
 yncft7W43Ggg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:12 -0700
IronPort-SDR: l8QoEPzfML69VlYRmqMIKi7s1ycfj8QFyeQ9p7Sw8eBM1jWVuTbCVpohCil/VhiqAtvliPk+Aa
 B+PQ+STr2eHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291096"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 08/17] igc: Fix NFC rules leak when driver is unloaded
Date:   Fri, 22 May 2020 19:51:00 -0700
Message-Id: <20200523025109.3313635-9-jeffrey.t.kirsher@intel.com>
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

If we have RFC rules in adapter->nfc_rule_list when the IGC driver
is unloaded, all rules are leaked. This patch fixes the issue by
introducing the helper igc_flush_nfc_rules() and calling it in
igc_remove(). It also updates igc_set_features() so is reuses the
new helper instead of re-implementing it.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 29 +++++++++++++----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index ad9217335a64..0a6f880e3538 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2544,6 +2544,18 @@ void igc_del_nfc_rule(struct igc_adapter *adapter, struct igc_nfc_rule *rule)
 	kfree(rule);
 }
 
+static void igc_flush_nfc_rules(struct igc_adapter *adapter)
+{
+	struct igc_nfc_rule *rule, *tmp;
+
+	spin_lock(&adapter->nfc_rule_lock);
+
+	list_for_each_entry_safe(rule, tmp, &adapter->nfc_rule_list, list)
+		igc_del_nfc_rule(adapter, rule);
+
+	spin_unlock(&adapter->nfc_rule_lock);
+}
+
 /**
  * igc_add_nfc_rule() - Add NFC rule
  * @adapter: Pointer to adapter
@@ -3967,19 +3979,8 @@ static int igc_set_features(struct net_device *netdev,
 	if (!(changed & (NETIF_F_RXALL | NETIF_F_NTUPLE)))
 		return 0;
 
-	if (!(features & NETIF_F_NTUPLE)) {
-		struct igc_nfc_rule *rule, *tmp;
-
-		spin_lock(&adapter->nfc_rule_lock);
-		list_for_each_entry_safe(rule, tmp,
-					 &adapter->nfc_rule_list, list) {
-			igc_disable_nfc_rule(adapter, rule);
-			list_del(&rule->list);
-			kfree(rule);
-		}
-		spin_unlock(&adapter->nfc_rule_lock);
-		adapter->nfc_rule_count = 0;
-	}
+	if (!(features & NETIF_F_NTUPLE))
+		igc_flush_nfc_rules(adapter);
 
 	netdev->features = features;
 
@@ -5246,6 +5247,8 @@ static void igc_remove(struct pci_dev *pdev)
 
 	pm_runtime_get_noresume(&pdev->dev);
 
+	igc_flush_nfc_rules(adapter);
+
 	igc_ptp_stop(adapter);
 
 	set_bit(__IGC_DOWN, &adapter->state);
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA551DF43A
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387595AbgEWCvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:22 -0400
Received: from mga17.intel.com ([192.55.52.151]:37983 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387544AbgEWCvR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:17 -0400
IronPort-SDR: 6x+L3jADYNMlZRLvj2pnscSmJhvBqCSnMKkfIWqhpcDMRctfYD4JmGIcqpYJ/DZjWC+51XeS+Q
 kwt3X7xIqglQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:13 -0700
IronPort-SDR: o1+xT7DtGiKzkImfKn8R/J5W1RPQjobrX/aK423fyg1VwSIrUPaaG5ZvW3aAfhXtSASOVY6YyP
 pVqNdtw3CO+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291122"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:13 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/17] igc: Remove igc_nfc_rule_exit()
Date:   Fri, 22 May 2020 19:51:04 -0700
Message-Id: <20200523025109.3313635-13-jeffrey.t.kirsher@intel.com>
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

During igc_down(), we call igc_nfc_rule_exit() which traverse the NFC
rule list disabling filters one by one. Later on in igc_down() flow
we issue an hardware reset which also clear all filters.  Since we
already reset the hardware, we don't actually need to disable each
filter manually. In order to simplify the code, this patch removes
igc_nfc_rule() altogether.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 165263ae8add..97d26991c87e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2591,18 +2591,6 @@ static void igc_restore_nfc_rules(struct igc_adapter *adapter)
 	mutex_unlock(&adapter->nfc_rule_lock);
 }
 
-static void igc_nfc_rule_exit(struct igc_adapter *adapter)
-{
-	struct igc_nfc_rule *rule;
-
-	mutex_lock(&adapter->nfc_rule_lock);
-
-	list_for_each_entry(rule, &adapter->nfc_rule_list, list)
-		igc_disable_nfc_rule(adapter, rule);
-
-	mutex_unlock(&adapter->nfc_rule_lock);
-}
-
 static int igc_uc_sync(struct net_device *netdev, const unsigned char *addr)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
@@ -3821,8 +3809,6 @@ void igc_down(struct igc_adapter *adapter)
 	wr32(IGC_RCTL, rctl & ~IGC_RCTL_EN);
 	/* flush and sleep below */
 
-	igc_nfc_rule_exit(adapter);
-
 	/* set trans_start so we don't get spurious watchdogs during reset */
 	netif_trans_update(netdev);
 
-- 
2.26.2


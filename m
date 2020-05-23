Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6486A1DF446
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 04:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387631AbgEWCvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 22:51:44 -0400
Received: from mga17.intel.com ([192.55.52.151]:37985 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387555AbgEWCvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 22:51:14 -0400
IronPort-SDR: ohTauWA9DMJ/hYiUgcgPjeV0FKr2+3HGk5SERxFqjCtGj3clQ3DHTqMZm6cVlAEiS5NCA05R4j
 0JM3AU9h0C+w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2020 19:51:13 -0700
IronPort-SDR: YZtwN5C05KHHWRJVBbKQBSRN9hkR6/73letrP1P07Tmv+ve6IppnAsg54/Qk8osekG6LG4droi
 3hiXUOKXRrdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,424,1583222400"; 
   d="scan'208";a="290291103"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 22 May 2020 19:51:12 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/17] igc: Fix NFC rule validation
Date:   Fri, 22 May 2020 19:51:01 -0700
Message-Id: <20200523025109.3313635-10-jeffrey.t.kirsher@intel.com>
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

If we try to overwrite an existing rule with the same filter but
different action, we get EEXIST error as shown below.

$ ethtool -N eth0 flow-type ether dst <MACADDR> action 1 loc 10
$ ethtool -N eth0 flow-type ether dst <MACADDR> action 2 loc 10
rmgr: Cannot insert RX class rule: File exists

The second command is expected to overwrite the previous rule in location
10 and succeed.

This patch fixes igc_ethtool_check_nfc_rule() so it also checks the
rules location. In case they match, the rule under evaluation should not
be considered invalid.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 43dff09a8f86..d14c46dce053 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1225,8 +1225,8 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
  * Rules with both destination and source MAC addresses are considered invalid
  * since the driver doesn't support them.
  *
- * Also, if there is already another rule with the same filter, @rule is
- * considered invalid.
+ * Also, if there is already another rule with the same filter in a different
+ * location, @rule is considered invalid.
  *
  * Context: Expects adapter->nfc_rule_lock to be held by caller.
  *
@@ -1252,7 +1252,8 @@ static int igc_ethtool_check_nfc_rule(struct igc_adapter *adapter,
 
 	list_for_each_entry(tmp, &adapter->nfc_rule_list, list) {
 		if (!memcmp(&rule->filter, &tmp->filter,
-			    sizeof(rule->filter))) {
+			    sizeof(rule->filter)) &&
+		    tmp->location != rule->location) {
 			netdev_dbg(dev, "Rule already exists\n");
 			return -EEXIST;
 		}
-- 
2.26.2


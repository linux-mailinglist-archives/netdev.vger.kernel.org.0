Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 156FE1E7508
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgE2EkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:40:21 -0400
Received: from mga03.intel.com ([134.134.136.65]:40329 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbgE2EkR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 00:40:17 -0400
IronPort-SDR: MJxOc0gfUWIx+xM46UMi6thrwMvmRmal9szBWETVAJ+azEaDgnTitccVF/VaNcag6mG1I0MFKs
 21tREQ+Ktyzg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2020 21:40:05 -0700
IronPort-SDR: dkP6eSfNXB5xWB+whpz/3AN4ci32kujoAomxplMclTqlA+ScNEuxUv85IUmRxcemq855LOZUhK
 Sl/b5s/YDsew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,447,1583222400"; 
   d="scan'208";a="414850921"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by orsmga004.jf.intel.com with ESMTP; 28 May 2020 21:40:05 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Andre Guedes <andre.guedes@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 09/17] igc: Reject NFC rules with multiple matches
Date:   Thu, 28 May 2020 21:39:56 -0700
Message-Id: <20200529044004.3725307-10-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
References: <20200529044004.3725307-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@intel.com>

The way Rx queue assignment based on mac address, Ethertype and VLAN
priority filtering operates in I225 doesn't allow us to properly support
NFC rules with multiple matches.

Consider the following example which assigns to queue 2 frames matching
the address MACADDR *and* Ethertype ETYPE.

$ ethtool -N eth0 flow-type ether dst <MACADDR> proto <ETYPE> queue 2

When such rule is applied, we have 2 unwanted behaviors:

    1) Any frame matching MACADDR will be assigned to queue 2. It
       doesn't matter the ETYPE value.

    2) Any accepted frame that has Ethertype equals to ETYPE, no matter
       the mac address, will be assigned to queue 2 as well.

In current code, multiple-match filters are accepted by the driver, even
though it doesn't support them properly. This patch adds a check for
multiple-match rules in igc_ethtool_is_nfc_rule_valid() so they are
rejected.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ethtool.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 946e775e34ae..a938ec8db681 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -1222,8 +1222,8 @@ static void igc_ethtool_init_nfc_rule(struct igc_nfc_rule *rule,
  * @adapter: Pointer to adapter
  * @rule: Rule under evaluation
  *
- * Rules with both destination and source MAC addresses are considered invalid
- * since the driver doesn't support them.
+ * The driver doesn't support rules with multiple matches so if more than
+ * one bit in filter flags is set, @rule is considered invalid.
  *
  * Also, if there is already another rule with the same filter in a different
  * location, @rule is considered invalid.
@@ -1244,9 +1244,8 @@ static int igc_ethtool_check_nfc_rule(struct igc_adapter *adapter,
 		return -EINVAL;
 	}
 
-	if (flags & IGC_FILTER_FLAG_DST_MAC_ADDR &&
-	    flags & IGC_FILTER_FLAG_SRC_MAC_ADDR) {
-		netdev_dbg(dev, "Filters with both dst and src are not supported\n");
+	if (flags & (flags - 1)) {
+		netdev_dbg(dev, "Rule with multiple matches not supported\n");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.26.2


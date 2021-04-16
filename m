Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3DD362990
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239949AbhDPUnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:43:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:45469 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236027AbhDPUni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:43:38 -0400
IronPort-SDR: VuLyVT2N+eYS/xlVSsIH1EAtzrR7KEh0uCeKW8tcg+6qYcIxzGWeUCmemgOG5q9GJCZM/jj1GD
 J5S+9nDBbiQw==
X-IronPort-AV: E=McAfee;i="6200,9189,9956"; a="182234178"
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="182234178"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 13:43:12 -0700
IronPort-SDR: RzmeKdvPJo0UosHKCQC8l52pxWZn/FtSIz9261vlF4kbg4kvnCzpLW/Jmyroi3pZRHVpciNawx
 WOcMeWDZRS3Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,228,1613462400"; 
   d="scan'208";a="384425605"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 16 Apr 2021 13:43:12 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Dave Switzer <david.switzer@intel.com>
Subject: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210 and i211
Date:   Fri, 16 Apr 2021 13:44:56 -0700
Message-Id: <20210416204500.2012073-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

Add new function which checks MTA_REGISTER if its filled correctly.
If not then writes again to same register.
There is possibility that i210 and i211 could not accept
MTA_REGISTER settings, specially when you add and remove
many of multicast addresses in short time.
Without this patch there is possibility that multicast settings will be
not always set correctly in hardware.

Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Dave Switzer <david.switzer@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_mac.c | 27 ++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index fd8eb2f9ab9d..e63ee3cca5ea 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -483,6 +483,31 @@ static u32 igb_hash_mc_addr(struct e1000_hw *hw, u8 *mc_addr)
 	return hash_value;
 }
 
+/**
+ * igb_i21x_hw_doublecheck - double checks potential HW issue in i21X
+ * @hw: pointer to the HW structure
+ *
+ * Checks if multicast array is wrote correctly
+ * If not then rewrites again to register
+ **/
+static void igb_i21x_hw_doublecheck(struct e1000_hw *hw)
+{
+	bool is_failed;
+	int i;
+
+	do {
+		is_failed = false;
+		for (i = hw->mac.mta_reg_count - 1; i >= 0; i--) {
+			if (array_rd32(E1000_MTA, i) != hw->mac.mta_shadow[i]) {
+				is_failed = true;
+				array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
+				wrfl();
+				break;
+			}
+		}
+	} while (is_failed);
+}
+
 /**
  *  igb_update_mc_addr_list - Update Multicast addresses
  *  @hw: pointer to the HW structure
@@ -516,6 +541,8 @@ void igb_update_mc_addr_list(struct e1000_hw *hw,
 	for (i = hw->mac.mta_reg_count - 1; i >= 0; i--)
 		array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
 	wrfl();
+	if (hw->mac.type == e1000_i210 || hw->mac.type == e1000_i211)
+		igb_i21x_hw_doublecheck(hw);
 }
 
 /**
-- 
2.26.2


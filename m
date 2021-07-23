Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BBF3D3E21
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbhGWQZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:25:25 -0400
Received: from mga12.intel.com ([192.55.52.136]:34405 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229510AbhGWQZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Jul 2021 12:25:24 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10054"; a="191508233"
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="191508233"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2021 10:05:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="663350248"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 23 Jul 2021 10:05:57 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Grzegorz Siwik <grzegorz.siwik@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 1/3] igb: Add counter to i21x doublecheck
Date:   Fri, 23 Jul 2021 10:09:08 -0700
Message-Id: <20210723170910.296843-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
References: <20210723170910.296843-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Grzegorz Siwik <grzegorz.siwik@intel.com>

Add failed_counter to i21x_doublecheck(). There is possibility that
loop will never end.
With this patch the loop will stop after maximum 3 retries
to write to MTA_REGISTER

Signed-off-by: Grzegorz Siwik <grzegorz.siwik@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_mac.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/e1000_mac.c b/drivers/net/ethernet/intel/igb/e1000_mac.c
index e63ee3cca5ea..1277c5c7d099 100644
--- a/drivers/net/ethernet/intel/igb/e1000_mac.c
+++ b/drivers/net/ethernet/intel/igb/e1000_mac.c
@@ -492,6 +492,7 @@ static u32 igb_hash_mc_addr(struct e1000_hw *hw, u8 *mc_addr)
  **/
 static void igb_i21x_hw_doublecheck(struct e1000_hw *hw)
 {
+	int failed_cnt = 3;
 	bool is_failed;
 	int i;
 
@@ -502,9 +503,12 @@ static void igb_i21x_hw_doublecheck(struct e1000_hw *hw)
 				is_failed = true;
 				array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
 				wrfl();
-				break;
 			}
 		}
+		if (is_failed && --failed_cnt <= 0) {
+			hw_dbg("Failed to update MTA_REGISTER, too many retries");
+			break;
+		}
 	} while (is_failed);
 }
 
-- 
2.26.2


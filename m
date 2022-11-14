Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A54B628DA5
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237024AbiKNXnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237392AbiKNXm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:42:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C1114012
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:42:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668469376; x=1700005376;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otvdgslNcp3H45sRkC49R/+S/2/G9vlB0UH8YNFJQOU=;
  b=L5czm32GJm1Jc/0LnfdL5N+mSVyuTOxKH8kPRDGlqvNXNRD2DFdHTzz9
   1JQj5XZbaXOKhhRuRxR42jUmhRcetxH3+JeNMpJ/RJjEp4s0pxBTMNP2d
   81BlQ7HUlDkauVs6ow90UPzRqZQJBaI+NL6zt3D2BdoiphDT0u0g7nfVu
   RfaBbAmbFIO8N3mbDGqVG4/UlFB/cMtvhOcqWNtXKgIdPWydrQC4UJS5E
   f4PSGz4zXRfeWmdoNmzYHZmhvxr6cMWNOk4x636TwOTBxoHrwbFF8INqQ
   WzxCG1O+3uFf0+qiAE/vXmMta7DmiiWl2NcnhEkX6oghymn7axOp4EJ70
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="310821179"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="310821179"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2022 15:42:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10531"; a="702208663"
X-IronPort-AV: E=Sophos;i="5.96,164,1665471600"; 
   d="scan'208";a="702208663"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 14 Nov 2022 15:42:56 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 1/7] ice: Check for PTP HW lock more frequently
Date:   Mon, 14 Nov 2022 15:42:44 -0800
Message-Id: <20221114234250.3039889-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
References: <20221114234250.3039889-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Karol Kolacinski <karol.kolacinski@intel.com>

It was observed that PTP HW semaphore can be held for ~50 ms in worst
case.
SW should wait longer and check more frequently if the HW lock is held.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp_hw.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
index 772b1f566d6e..1f8dd50db524 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp_hw.c
@@ -2963,16 +2963,18 @@ bool ice_ptp_lock(struct ice_hw *hw)
 	u32 hw_lock;
 	int i;
 
-#define MAX_TRIES 5
+#define MAX_TRIES 15
 
 	for (i = 0; i < MAX_TRIES; i++) {
 		hw_lock = rd32(hw, PFTSYN_SEM + (PFTSYN_SEM_BYTES * hw->pf_id));
 		hw_lock = hw_lock & PFTSYN_SEM_BUSY_M;
-		if (!hw_lock)
-			break;
+		if (hw_lock) {
+			/* Somebody is holding the lock */
+			usleep_range(5000, 6000);
+			continue;
+		}
 
-		/* Somebody is holding the lock */
-		usleep_range(10000, 20000);
+		break;
 	}
 
 	return !hw_lock;
-- 
2.35.1


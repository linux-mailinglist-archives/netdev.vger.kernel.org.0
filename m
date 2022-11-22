Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEDB86349D3
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 23:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbiKVWK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 17:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234518AbiKVWK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 17:10:56 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB2127DC5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 14:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669155055; x=1700691055;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otvdgslNcp3H45sRkC49R/+S/2/G9vlB0UH8YNFJQOU=;
  b=cpy9q0ucnsItPjOKoeSb9H+PkGTT0RPcghH8P3bTKcYHs/GfeSwhUf3T
   uJ6z0/wRkv3QTShu9fSREMs6T0O5TMisJamoOH6gQ6rzWOByCIEwovbl7
   IjrNInCRZiqco/qUfyXameeyXuKcR6VIlKglpWPQ7IB/t32Sl2lVt774t
   K7o/NBxfSh5kf1f3UQKWLAVU3Gijb9JTwuf98h7qg0hnKDWedJFIUh11Q
   0Fl2fMNNLGN8vvQpkCO7xxzDP96mBhhbufrs6g4FhPJM7yjo9maE51+Sc
   GS8+lQ+YuuN0sGr5ca7HU7uycMyn1MEzEflnQwcjjiGHDod8++AWO2gSU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="378182924"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="378182924"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 14:10:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="705127003"
X-IronPort-AV: E=Sophos;i="5.96,185,1665471600"; 
   d="scan'208";a="705127003"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 22 Nov 2022 14:10:53 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v2 1/7] ice: Check for PTP HW lock more frequently
Date:   Tue, 22 Nov 2022 14:10:41 -0800
Message-Id: <20221122221047.3095231-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
References: <20221122221047.3095231-1-anthony.l.nguyen@intel.com>
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


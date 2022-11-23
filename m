Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29334636E12
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiKWXGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiKWXGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:06:35 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BEAE14E6F0
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669244791; x=1700780791;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=otvdgslNcp3H45sRkC49R/+S/2/G9vlB0UH8YNFJQOU=;
  b=EliME/eoZnOdiExqu+0DclcxK/wXPC9H7UEHVC9lEXZGCucDmaqkA5AW
   QPFV6HOGzO+OyzyC1QYbezA02seTeea65NfKkERJO0EkVtc212D9G1MdS
   InryOBB0wGjBqWy+xnbgy/AUCrd6e9Zw8IS+ChvvpydBDLcDD9X5AqZSb
   cv41HESvEFtIMsfbq+ijDimi2qOt9F2tDzvg8qNSVpxuah++RnA9EkkrD
   jHczXk8GYLCLKbKMcTMgiiNN548sU/U8hLEeVB3jDJggXNmPBIyWu5opy
   JYFXPtEtmhkBaay1mZ+wgCuzQIGE+8NO8yPAqfHK65JtD/1800le6jH+i
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="376318624"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="376318624"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Nov 2022 15:06:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="705531259"
X-IronPort-AV: E=Sophos;i="5.96,187,1665471600"; 
   d="scan'208";a="705531259"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga008.fm.intel.com with ESMTP; 23 Nov 2022 15:06:29 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Karol Kolacinski <karol.kolacinski@intel.com>,
        netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        richardcochran@gmail.com, Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 1/6] ice: Check for PTP HW lock more frequently
Date:   Wed, 23 Nov 2022 15:06:16 -0800
Message-Id: <20221123230621.3562805-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
References: <20221123230621.3562805-1-anthony.l.nguyen@intel.com>
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


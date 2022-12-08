Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1B8647823
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:40:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbiLHVj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:39:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiLHVjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:39:44 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A61927DD8
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670535583; x=1702071583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qlLDKdOCLcr1mX1/A0xuX+8KEDInNbOgpzLWPckeXio=;
  b=Q0YWLZjtSwMYd6ftbLC4IyoT+FHXH6P+hlWpXSHxsDUE5aXHl19GixVF
   qevdYFVjxmCizhdLE6xTVvR6zpeVrjh8j1z6G4h9DNIKDjTW0qSxmA9WN
   GNeoKY46kBRLWjBe1QDha0ZnMnGejJb+zSKNaI0wWdXbuewhREDOrhyD1
   hSExl6r8V64dqv1Jz3+iOUbE9pxSxT/T1JpDuM50wMxRC3MNvS33P7QvN
   8rCKGvQ4uKtD+eZqemXHmqKyUtmWeGB2/meuBumqCFePd0G+24A1x4oVq
   LNgJM5F6OWUl+G0aMzFHX8TthSS7RBvNTVyRM4Ih8SqkPRY4oDNQavs6H
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="317328213"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="317328213"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:39:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="624873997"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="624873997"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga006.jf.intel.com with ESMTP; 08 Dec 2022 13:39:39 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        leon@kernel.org, saeed@kernel.org,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next v3 10/14] ice: cleanup allocations in ice_ptp_alloc_tx_tracker
Date:   Thu,  8 Dec 2022 13:39:28 -0800
Message-Id: <20221208213932.1274143-11-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
References: <20221208213932.1274143-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The ice_ptp_alloc_tx_tracker function must allocate the timestamp array and
the bitmap for tracking the currently in use indexes. A future change is
going to add yet another allocation to this function.

If these allocations fail we need to ensure that we properly cleanup and
ensure that the pointers in the ice_ptp_tx structure are NULL.

Simplify this logic by allocating to local variables first. If any
allocation fails, then free everything and exit. Only update the ice_ptp_tx
structure if all allocations succeed.

This ensures that we have no side effects on the Tx structure unless all
allocations have succeeded. Thus, no code will see an invalid pointer and
we don't need to re-assign NULL on cleanup.

This is safe because kernel "free" functions are designed to be NULL safe
and perform no action if passed a NULL pointer. Thus its safe to simply
always call kfree or bitmap_free even if one of those pointers was NULL.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 481492d84e0e..6b49d9a5f538 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -794,17 +794,21 @@ static bool ice_ptp_tx_tstamp(struct ice_ptp_tx *tx)
 static int
 ice_ptp_alloc_tx_tracker(struct ice_ptp_tx *tx)
 {
-	tx->tstamps = kcalloc(tx->len, sizeof(*tx->tstamps), GFP_KERNEL);
-	if (!tx->tstamps)
-		return -ENOMEM;
+	struct ice_tx_tstamp *tstamps;
+	unsigned long *in_use;
+
+	tstamps = kcalloc(tx->len, sizeof(*tstamps), GFP_KERNEL);
+	in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
+
+	if (!tstamps || !in_use) {
+		kfree(tstamps);
+		bitmap_free(in_use);
 
-	tx->in_use = bitmap_zalloc(tx->len, GFP_KERNEL);
-	if (!tx->in_use) {
-		kfree(tx->tstamps);
-		tx->tstamps = NULL;
 		return -ENOMEM;
 	}
 
+	tx->tstamps = tstamps;
+	tx->in_use = in_use;
 	tx->init = 1;
 
 	spin_lock_init(&tx->lock);
-- 
2.35.1


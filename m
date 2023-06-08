Return-Path: <netdev+bounces-9353-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B0E82728959
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:26:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 122F61C2105D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:26:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B32D231EF3;
	Thu,  8 Jun 2023 20:25:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A459631EEE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:50 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676402D6B
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255949; x=1717791949;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ou3DjUkzfAY2ibFz5zp5TGlBS5rbc3hE0enIjiRO9jA=;
  b=kFmirSzovuJKb+9Nr6/YHYX8wtKw65ED4kAFzgJKZCafxZjjScaqQaul
   Lxr/3+WLi8BI2KXTaYv2OtjZ3YA6DLnsKisvaPzyASNlxsGJfFwKn4DnA
   0/iU+6IeX9+rEV9qQevi+i4D9j1GnQKcdjax9JiEEClic6NQi1F98PB9U
   rOzxvdwNxW538CbW317ZpiAfvb6QdoOdTlrvkGj5TE/wC6kBbAqPmdorX
   agg7bdvJ+9IWuOmm0G2xDQ8B11E2tfp851/AvTEr46z7TrudoHMec8KjY
   sZubGK9ZNPo/Uq8viR57YY30X6BcVLAZsHcsSj+jdwDY8z0hJS+jETFEh
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776288"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776288"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767848"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767848"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 13:25:47 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Karol Kolacinski <karol.kolacinski@intel.com>,
	anthony.l.nguyen@intel.com,
	richardcochran@gmail.com,
	Jacob Keller <jacob.e.keller@intel.com>,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 2/5] ice: always return IRQ_WAKE_THREAD in ice_misc_intr()
Date: Thu,  8 Jun 2023 13:21:12 -0700
Message-Id: <20230608202115.453965-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
References: <20230608202115.453965-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Karol Kolacinski <karol.kolacinski@intel.com>

Refactor the ice_misc_intr() function to always return IRQ_WAKE_THREAD, and
schedule the service task during the soft IRQ thread function instead of at
the end of the hard IRQ handler.

Remove the duplicate call to ice_service_task_schedule() that happened when
we got a PCI exception.

Signed-off-by: Karol Kolacinski <karol.kolacinski@intel.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 314a42808e39..45dab7f62198 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3058,7 +3058,6 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 {
 	struct ice_pf *pf = (struct ice_pf *)data;
 	struct ice_hw *hw = &pf->hw;
-	irqreturn_t ret = IRQ_NONE;
 	struct device *dev;
 	u32 oicr, ena_mask;
 
@@ -3139,10 +3138,8 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 
 	if (oicr & PFINT_OICR_TSYN_TX_M) {
 		ena_mask &= ~PFINT_OICR_TSYN_TX_M;
-		if (!hw->reset_ongoing) {
+		if (!hw->reset_ongoing)
 			set_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread);
-			ret = IRQ_WAKE_THREAD;
-		}
 	}
 
 	if (oicr & PFINT_OICR_TSYN_EVNT_M) {
@@ -3159,7 +3156,6 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 					       GLTSYN_STAT_EVENT2_M);
 
 			set_bit(ICE_MISC_THREAD_EXTTS_EVENT, pf->misc_thread);
-			ret = IRQ_WAKE_THREAD;
 		}
 	}
 
@@ -3180,16 +3176,12 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		if (oicr & (PFINT_OICR_PCI_EXCEPTION_M |
 			    PFINT_OICR_ECC_ERR_M)) {
 			set_bit(ICE_PFR_REQ, pf->state);
-			ice_service_task_schedule(pf);
 		}
 	}
-	if (!ret)
-		ret = IRQ_HANDLED;
 
-	ice_service_task_schedule(pf);
 	ice_irq_dynamic_ena(hw, NULL, NULL);
 
-	return ret;
+	return IRQ_WAKE_THREAD;
 }
 
 /**
@@ -3204,6 +3196,8 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 	if (ice_is_reset_in_progress(pf->state))
 		return IRQ_HANDLED;
 
+	ice_service_task_schedule(pf);
+
 	if (test_and_clear_bit(ICE_MISC_THREAD_EXTTS_EVENT, pf->misc_thread))
 		ice_ptp_extts_event(pf);
 
-- 
2.38.1



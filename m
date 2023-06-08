Return-Path: <netdev+bounces-9354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 798FC72895D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:26:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F4B8281741
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:26:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F19031F10;
	Thu,  8 Jun 2023 20:25:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F7E31EEE
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:51 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 650252D70
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255950; x=1717791950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uUPYsjz46iVr2kVuF9DxYlr07KgG4CN8tiihVHjTLeM=;
  b=NXCAlB9eWoQ/zGfic+3Ur09DnWeaMHOxDoAl0JnWOYY4iCrLVo3dZzTD
   H+NMIllwS+h8hOiwlWPzHb6ePNpjX4n1RL5oZmeKXLO2UnVEe3nvyELoZ
   9NCGFxQ4k2cSOaRwMcczE93A8IEnhuLpoDO984VbY7/b+jttJjiEw8eub
   lYs6L86ADoBITmBtTG7++vgKD40cRjCUCiryW3XZ2owZb14N9Kk7pI1RJ
   M9MtgDp4wUy6/qSfzrHidN07Nz3B3e/UaXd/WsV25ET53Q4Vw/eugESfr
   SicRctjYNqM2uoca9upr+JBidrHUJa5Ijt6cO7qxPBWp1cE+zrsIo1TqJ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776303"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776303"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767860"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767860"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 08 Jun 2023 13:25:48 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Jacob Keller <jacob.e.keller@intel.com>,
	anthony.l.nguyen@intel.com,
	richardcochran@gmail.com,
	Arpana Arland <arpanax.arland@intel.com>
Subject: [PATCH net-next 4/5] ice: trigger PFINT_OICR_TSYN_TX interrupt instead of polling
Date: Thu,  8 Jun 2023 13:21:14 -0700
Message-Id: <20230608202115.453965-5-anthony.l.nguyen@intel.com>
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

From: Jacob Keller <jacob.e.keller@intel.com>

In ice_misc_intr_thread_fn(), if we do not complete all Tx timestamp work,
the thread function will poll continuously forever.

For E822 hardware, this wastes time as the return value from
ice_ptp_process_ts() is accurate and always reports correctly that the PHY
actually has new timestamp data.

In addition, if we receive enough timestamps with the right pacing, we may
never exit this polling. Should this occur, other tasks handled by the
ice_misc_intr_thread_fn() will never be processed.

Fix this by instead writing to PFINT_OICR, causing an emulated interrupt to
be triggered immediately. This does take slightly more processing than just
re-checking the timestamps. However, it allows all of the other interrupt
causes a chance to be processed first in the hard IRQ function.

Note that the OICR interrupt is configured to be throttled  to no more than
once every 124 microseconds. This gives an effective interrupt rate of
~8000 interrupts per second. This should thus not cause a significant
increase in overall CPU usage when compared to sleeping.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6811e2a3c154..2665f72b5461 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3202,8 +3202,15 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 		ice_ptp_extts_event(pf);
 
 	if (test_and_clear_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread)) {
-		while (ice_ptp_process_ts(pf) == ICE_TX_TSTAMP_WORK_PENDING)
-			usleep_range(50, 100);
+		struct ice_hw *hw = &pf->hw;
+
+		/* Process outstanding Tx timestamps. If there is more work,
+		 * re-arm the interrupt to trigger again.
+		 */
+		if (ice_ptp_process_ts(pf) == ICE_TX_TSTAMP_WORK_PENDING) {
+			wr32(hw, PFINT_OICR, PFINT_OICR_TSYN_TX_M);
+			ice_flush(hw);
+		}
 	}
 
 	return IRQ_HANDLED;
-- 
2.38.1



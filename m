Return-Path: <netdev+bounces-9355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A157728962
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 22:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 321182817A1
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2288C33CAF;
	Thu,  8 Jun 2023 20:25:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183F931F1E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 20:25:52 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F11D2D71
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 13:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686255950; x=1717791950;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6hE6JUiF1mNFsJ9oesrLcaYObZJOk+FOSmUHnb0wy9k=;
  b=c+ttlwA3Q6XdfwJ8AZsINdOMP2jyg///oO64pBwVNyAJucXPQcTO7Vh+
   SUG+VhA9jd9s8QhIAFz/cdHF07OEbz6bGBHFkpMwi5gvWBD/Y0SKdhp6d
   uamkHb/kURYcGxFCuUTq+8po+YwOLIUm/xPApOQPoI9kepoTVtIhhyi+0
   va1trjVd7ncuDKbmbtcGrych2kHv3rUJfGoFN/dEktxxq8il89bbW0K8b
   WwVP1jSH8d0q3hDoUt4zVdm0zN/lQchbDWwYBVOEIDwOtWBuz+wKoXn9e
   4V+HeLJnzl+Uc5MUv7y5MK6g+HSniaFlRndLYHLKoxo93fKdn0Vbh/Ed5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="385776310"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="385776310"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 13:25:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10735"; a="822767864"
X-IronPort-AV: E=Sophos;i="6.00,227,1681196400"; 
   d="scan'208";a="822767864"
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
Subject: [PATCH net-next 5/5] ice: do not re-enable miscellaneous interrupt until thread_fn completes
Date: Thu,  8 Jun 2023 13:21:15 -0700
Message-Id: <20230608202115.453965-6-anthony.l.nguyen@intel.com>
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

The ice driver uses threaded IRQ for managing Tx timestamps via the
devm_request_threaded_irq() interface. The ice_misc_intr() handler function
is responsible for processing the hard interrupt context, and can wake the
ice_misc_intr_thread_fn() by returning IRQ_WAKE_THREAD.

The request_threaded_irq() function comment says:

  @handler is still called in hard interrupt context and has to check
  whether the interrupt originates from the device. If yes, it needs to
  disable the interrupt on the device and return IRQ_WAKE_THREAD which will
  wake up the handler thread and run the @thread_fn.

We currently re-enable the Other Interrupt Cause Register (OCIR) at the end of
ice_misc_intr(). In practice, this seems to be ok, but it can make
communicating between the handler function and the thread function
difficult. This is because the interrupt can trigger again while the thread
function is still processing.

Move the OICR update to the end of the thread function, leaving the other
interrupt cause disabled in hardware until we complete one pass of the
thread function. This prevents the miscellaneous interrupt from firing
until after we finish the thread function.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 2665f72b5461..aa57d26a0ac7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3179,8 +3179,6 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 		}
 	}
 
-	ice_irq_dynamic_ena(hw, NULL, NULL);
-
 	return IRQ_WAKE_THREAD;
 }
 
@@ -3192,6 +3190,9 @@ static irqreturn_t ice_misc_intr(int __always_unused irq, void *data)
 static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 {
 	struct ice_pf *pf = data;
+	struct ice_hw *hw;
+
+	hw = &pf->hw;
 
 	if (ice_is_reset_in_progress(pf->state))
 		return IRQ_HANDLED;
@@ -3202,8 +3203,6 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 		ice_ptp_extts_event(pf);
 
 	if (test_and_clear_bit(ICE_MISC_THREAD_TX_TSTAMP, pf->misc_thread)) {
-		struct ice_hw *hw = &pf->hw;
-
 		/* Process outstanding Tx timestamps. If there is more work,
 		 * re-arm the interrupt to trigger again.
 		 */
@@ -3213,6 +3212,8 @@ static irqreturn_t ice_misc_intr_thread_fn(int __always_unused irq, void *data)
 		}
 	}
 
+	ice_irq_dynamic_ena(hw, NULL, NULL);
+
 	return IRQ_HANDLED;
 }
 
-- 
2.38.1



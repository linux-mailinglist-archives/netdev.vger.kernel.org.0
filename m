Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B076C69501D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjBMS7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbjBMS7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:59:33 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D2D1F4A9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676314750; x=1707850750;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Me/rSl5xF8zr4i3/+hNzfCRdvsEKnK9/+OYGdseKFVk=;
  b=lRZ5Rf8e+az4wcaWf8R1611pwllfjP58PAUZ+F6z2IiS9aCuhmSAyng5
   WJq9DCkPTweBs9Zi71tNUWRKU3CXfzcBbmJwSkPRZF0XTuA7bUb4k226g
   uiKYSuwBdqKMbBrnF40UnhFGaeU3NCMPiE8e51GfV47sKmAjZ9VdoiaME
   wimVRKpqQJgY9NWRZefvXzLQ2/QwR0FBEf3iEsZRrBIuCv1OPAPI0xaYo
   7sCaaeh74jZ8Ytt7AkZpZ0Pw4dHfnWg4pEPUyhQTtrvnI1IXam6+MFG6+
   uphmgB9f/eHeYWUSQBqI8XASK3LTysKzYlOewQPJBdlD+YUQ+bFQivzpi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="310602893"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="310602893"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2023 10:58:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10620"; a="732590881"
X-IronPort-AV: E=Sophos;i="5.97,294,1669104000"; 
   d="scan'208";a="732590881"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga008.fm.intel.com with ESMTP; 13 Feb 2023 10:58:57 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Cc:     Miroslav Lichvar <mlichvar@redhat.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, kernel.hbk@gmail.com,
        richardcochran@gmail.com, Matt Corallo <ntp-lists@mattcorallo.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net 1/1] igb: Fix PPS input and output using 3rd and 4th SDP
Date:   Mon, 13 Feb 2023 10:58:22 -0800
Message-Id: <20230213185822.3960072-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miroslav Lichvar <mlichvar@redhat.com>

Fix handling of the tsync interrupt to compare the pin number with
IGB_N_SDP instead of IGB_N_EXTTS/IGB_N_PEROUT and fix the indexing to
the perout array.

Fixes: cf99c1dd7b77 ("igb: move PEROUT and EXTTS isr logic to separate functions")
Reported-by: Matt Corallo <ntp-lists@mattcorallo.com>
Cc: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Miroslav Lichvar <mlichvar@redhat.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 3c0c35ecea10..d8e3048b93dd 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6794,7 +6794,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	struct timespec64 ts;
 	u32 tsauxc;
 
-	if (pin < 0 || pin >= IGB_N_PEROUT)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	spin_lock(&adapter->tmreg_lock);
@@ -6802,7 +6802,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = timespec64_to_ns(&adapter->perout[pin].period);
+		s64 ns = timespec64_to_ns(&adapter->perout[tsintr_tt].period);
 		u32 systiml, systimh, level_mask, level, rem;
 		u64 systim, now;
 
@@ -6850,8 +6850,8 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 		ts.tv_nsec = (u32)systim;
 		ts.tv_sec  = ((u32)(systim >> 32)) & 0xFF;
 	} else {
-		ts = timespec64_add(adapter->perout[pin].start,
-				    adapter->perout[pin].period);
+		ts = timespec64_add(adapter->perout[tsintr_tt].start,
+				    adapter->perout[tsintr_tt].period);
 	}
 
 	/* u32 conversion of tv_sec is safe until y2106 */
@@ -6860,7 +6860,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	tsauxc = rd32(E1000_TSAUXC);
 	tsauxc |= TSAUXC_EN_TT0;
 	wr32(E1000_TSAUXC, tsauxc);
-	adapter->perout[pin].start = ts;
+	adapter->perout[tsintr_tt].start = ts;
 
 	spin_unlock(&adapter->tmreg_lock);
 }
@@ -6874,7 +6874,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	struct ptp_clock_event event;
 	struct timespec64 ts;
 
-	if (pin < 0 || pin >= IGB_N_EXTTS)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	if (hw->mac.type == e1000_82580 ||
-- 
2.38.1


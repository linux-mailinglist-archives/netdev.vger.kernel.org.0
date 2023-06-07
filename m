Return-Path: <netdev+bounces-8951-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBB2F72663F
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:45:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68AD02813CF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:45:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A580171C7;
	Wed,  7 Jun 2023 16:45:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF0463B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:45:47 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED4719D
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686156345; x=1717692345;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cPpeoRFRoU7iDP+9aDnELS98Kl4WIN2rrwvuL79oPkw=;
  b=nWtx8ijo2xMk2z6J1VRKsPNTaVpdDIr5Bs+RdAgZvXl1mSJ6a8WorPLZ
   4YFV62fCpq75q0gdxWS0S9RQkT8bM4da5zwJRZM0yo4lHwEsqH5dqZ3hs
   pOrC361dCsaV+3NLSugYwb30zJfzYD+uYpR4ppk2t3vECnXPNdAvx4Nqz
   LHOJnn6sTAX7gEGayPxlrZNx63rYP8GKMM7FDOT1LZn4Xz5qQUaqnTaTS
   0mAAeo5N7dCcF/NEEAUFPawJrq09ayR5SjfulCmr0583yKdf0RZ7uX8gK
   0EyLdP86J7z5X0f+zNrRAKQXYisYu6NCZshdzh5e034mUYYv6maR4lC7a
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="420602777"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="420602777"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2023 09:45:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="822239636"
X-IronPort-AV: E=Sophos;i="6.00,224,1681196400"; 
   d="scan'208";a="822239636"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by fmsmga002.fm.intel.com with ESMTP; 07 Jun 2023 09:45:44 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Yuezhen Luan <eggcar.luan@gmail.com>,
	anthony.l.nguyen@intel.com,
	kernel.hbk@gmail.com,
	richardcochran@gmail.com,
	Jacob Keller <jacob.e.keller@intel.com>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH net] igb: Fix extts capture value format for 82580/i354/i350
Date: Wed,  7 Jun 2023 09:41:16 -0700
Message-Id: <20230607164116.3768175-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yuezhen Luan <eggcar.luan@gmail.com>

82580/i354/i350 features circle-counter-like timestamp registers
that are different with newer i210. The EXTTS capture value in
AUXTSMPx should be converted from raw circle counter value to
timestamp value in resolution of 1 nanosec by the driver.

This issue can be reproduced on i350 nics, connecting an 1PPS
signal to a SDP pin, and run 'ts2phc' command to read external
1PPS timestamp value. On i210 this works fine, but on i350 the
extts is not correctly converted.

The i350/i354/82580's SYSTIM and other timestamp registers are
40bit counters, presenting time range of 2^40 ns, that means these
registers overflows every about 1099s. This causes all these regs
can't be used directly in contrast to the newer i210/i211s.

The igb driver needs to convert these raw register values to
valid time stamp format by using kernel timecounter apis for i350s
families. Here the igb_extts() just forgot to do the convert.

Fixes: 38970eac41db ("igb: support EXTTS on 82580/i354/i350")
Signed-off-by: Yuezhen Luan <eggcar.luan@gmail.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 58872a4c2540..bb3db387d49c 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -6947,6 +6947,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	struct e1000_hw *hw = &adapter->hw;
 	struct ptp_clock_event event;
 	struct timespec64 ts;
+	unsigned long flags;
 
 	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
@@ -6954,9 +6955,12 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = rd32(auxstmpl);
+		u64 ns = rd32(auxstmpl);
 
-		ns += ((s64)(rd32(auxstmph) & 0xFF)) << 32;
+		ns += ((u64)(rd32(auxstmph) & 0xFF)) << 32;
+		spin_lock_irqsave(&adapter->tmreg_lock, flags);
+		ns = timecounter_cyc2time(&adapter->tc, ns);
+		spin_unlock_irqrestore(&adapter->tmreg_lock, flags);
 		ts = ns_to_timespec64(ns);
 	} else {
 		ts.tv_nsec = rd32(auxstmpl);
-- 
2.38.1



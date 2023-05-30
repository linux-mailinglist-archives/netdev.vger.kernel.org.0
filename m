Return-Path: <netdev+bounces-6509-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD3B9716BA1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:54:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 878F42812B8
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E222D247;
	Tue, 30 May 2023 17:53:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E7C1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:53:44 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AABE1E5
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685469222; x=1717005222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JtLALKCr6ZaRXzpKx4t4bLMrENNsh9XxZP0LT/WN9+c=;
  b=iT/632beZSvifevwxnNA8ryut6sJWaogJVsYBMag+cug0+DkomE8+o+t
   uXWD0RUHbt3KTBasMtj+e2JyKcZCgGRbqVKVx5yCe7F7u6ev7LtYgodNY
   +s/mcEEsUh0F9km1OgtjQNtiIMoqYvYJR9nJmWBm201uZ6qCG5qaKRMMf
   0bPCl3aGw/mmh5VTe5e3uOQp++lItoNA9GRCW4jCvoZijhxlDPiRW53zV
   s2BNhNsT1qLUCaKvipH8jHQSA5BfczPwR0TIx0oyitHPMz/6kIUfQSCl0
   J9N1bto4SvjgZI9Emv0WgIQ7LIfvTr4zdiIHuUlExcgq2dJllr6PILscr
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418488185"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="418488185"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 10:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="706525020"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="706525020"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga002.jf.intel.com with ESMTP; 30 May 2023 10:53:39 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	anthony.l.nguyen@intel.com,
	sasha.neftin@intel.com,
	richardcochran@gmail.com,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 4/4] igc: Add workaround for missing timestamps
Date: Tue, 30 May 2023 10:49:28 -0700
Message-Id: <20230530174928.2516291-5-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
References: <20230530174928.2516291-1-anthony.l.nguyen@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Vinicius Costa Gomes <vinicius.gomes@intel.com>

There's an hardware issue that can cause missing timestamps. The bug
is that the interrupt is only cleared if the IGC_TXSTMPH_0 register is
read.

The bug can cause a race condition if a timestamp is captured at the
wrong time, and we will miss that timestamp. To reduce the time window
that the problem is able to happen, in case no timestamp was ready, we
read the "previous" value of the timestamp registers, and we compare
with the "current" one, if it didn't change we can reasonably sure
that no timestamp was captured. If they are different, we use the new
value as the captured timestamp.

This workaround has more impact when multiple timestamp registers are
used, and the IGC_TXSTMPH_0 register always need to be read, so the
interrupt is cleared.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 48 ++++++++++++++++++------
 1 file changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 17e8970bd761..47a2140f9144 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -666,14 +666,49 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
 	struct sk_buff *skb = adapter->ptp_tx_skb;
 	struct skb_shared_hwtstamps shhwtstamps;
 	struct igc_hw *hw = &adapter->hw;
+	u32 tsynctxctl;
 	int adjust = 0;
 	u64 regval;
 
 	if (WARN_ON_ONCE(!skb))
 		return;
 
-	regval = rd32(IGC_TXSTMPL);
-	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
+	tsynctxctl = rd32(IGC_TSYNCTXCTL);
+	tsynctxctl &= IGC_TSYNCTXCTL_TXTT_0;
+	if (tsynctxctl) {
+		regval = rd32(IGC_TXSTMPL);
+		regval |= (u64)rd32(IGC_TXSTMPH) << 32;
+	} else {
+		/* There's a bug in the hardware that could cause
+		 * missing interrupts for TX timestamping. The issue
+		 * is that for new interrupts to be triggered, the
+		 * IGC_TXSTMPH_0 register must be read.
+		 *
+		 * To avoid discarding a valid timestamp that just
+		 * happened at the "wrong" time, we need to confirm
+		 * that there was no timestamp captured, we do that by
+		 * assuming that no two timestamps in sequence have
+		 * the same nanosecond value.
+		 *
+		 * So, we read the "low" register, read the "high"
+		 * register (to latch a new timestamp) and read the
+		 * "low" register again, if "old" and "new" versions
+		 * of the "low" register are different, a valid
+		 * timestamp was captured, we can read the "high"
+		 * register again.
+		 */
+		u32 txstmpl_old, txstmpl_new;
+
+		txstmpl_old = rd32(IGC_TXSTMPL);
+		rd32(IGC_TXSTMPH);
+		txstmpl_new = rd32(IGC_TXSTMPL);
+
+		if (txstmpl_old == txstmpl_new)
+			return;
+
+		regval = txstmpl_new;
+		regval |= (u64)rd32(IGC_TXSTMPH) << 32;
+	}
 	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))
 		return;
 
@@ -711,22 +746,13 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
  */
 void igc_ptp_tx_work(struct igc_adapter *adapter)
 {
-	struct igc_hw *hw = &adapter->hw;
 	unsigned long flags;
-	u32 tsynctxctl;
 
 	spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
 
 	if (!adapter->ptp_tx_skb)
 		goto unlock;
 
-	tsynctxctl = rd32(IGC_TSYNCTXCTL);
-	tsynctxctl &= IGC_TSYNCTXCTL_TXTT_0;
-	if (!tsynctxctl) {
-		WARN_ONCE(1, "Received a TSTAMP interrupt but no TSTAMP is ready.\n");
-		goto unlock;
-	}
-
 	igc_ptp_tx_hwtstamp(adapter);
 
 unlock:
-- 
2.38.1



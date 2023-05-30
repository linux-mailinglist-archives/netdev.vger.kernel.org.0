Return-Path: <netdev+bounces-6507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F485716B9C
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3439028112B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4D32A9E6;
	Tue, 30 May 2023 17:53:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 699411EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 17:53:43 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 232EEBE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685469221; x=1717005221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bkp0c3/fMBWtTSPQQeRbOWToKVRJ9G6f8zzqrL62nQ8=;
  b=RdkjcFeXW32z0WGwWY4Q/FCLktzNV5voBzuinE3ZrXWcsBBO9N+P82Mm
   YtaBhuytJtHPiMgWj+dLZT8irR8u880ODqzq8Xg21dToytd3xCa6/WrQ+
   Qwl5mBJAVHYFOAhtju410S1sha8visWFvW0bE/bo+WTiEDpy4BjndXQW6
   Ya0huCpskMGk8kYC4YMPamLTwQAsyh7yjT3aUtHlAi/I9VJGAqhK85IeG
   8F/e2UOthUq4purmB9I60SRh6HLdqp48qg9d8M/xMQ6riYo4S2GibsJAY
   JZxjWPZgq7UUazKAkpKIWELavOOwmuhoWc3up14X8EzoYNvH1qC6WFHuh
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="418488167"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="418488167"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 10:53:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="706525013"
X-IronPort-AV: E=Sophos;i="6.00,204,1681196400"; 
   d="scan'208";a="706525013"
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
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net 2/4] igc: Check if hardware TX timestamping is enabled earlier
Date: Tue, 30 May 2023 10:49:26 -0700
Message-Id: <20230530174928.2516291-3-anthony.l.nguyen@intel.com>
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

Before requesting a packet transmission to be hardware timestamped,
check if the user has TX timestamping enabled. Fixes an issue that if
a packet was internally forwarded to the NIC, and it had the
SKBTX_HW_TSTAMP flag set, the driver would mark that timestamp as
skipped.

In reality, that timestamp was "not for us", as TX timestamp could
never be enabled in the NIC.

Checking if the TX timestamping is enabled earlier has a secondary
effect that when TX timestamping is disabled, there's no need to check
for timestamp timeouts.

We should only take care to free any pending timestamp when TX
timestamping is disabled, as that skb would never be released
otherwise.

Fixes: 2c344ae24501 ("igc: Add support for TX timestamping")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_main.c |  5 +++--
 drivers/net/ethernet/intel/igc/igc_ptp.c  | 23 ++++++++++++++++++++---
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index a61afa69975e..b383352651a5 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1578,7 +1578,8 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		}
 	}
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
+	if (unlikely(adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON &&
+		     skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		/* FIXME: add support for retrieving timestamps from
 		 * the other timer registers before skipping the
 		 * timestamping request.
@@ -1586,7 +1587,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		unsigned long flags;
 
 		spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
-		if (adapter->tstamp_config.tx_type == HWTSTAMP_TX_ON && !adapter->ptp_tx_skb) {
+		if (!adapter->ptp_tx_skb) {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 			tx_flags |= IGC_TX_FLAGS_TSTAMP;
 
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 56128e55f5c0..4dd0eec5a246 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -536,11 +536,27 @@ static void igc_ptp_enable_rx_timestamp(struct igc_adapter *adapter)
 	wr32(IGC_TSYNCRXCTL, val);
 }
 
+static void igc_ptp_clear_tx_tstamp(struct igc_adapter *adapter)
+{
+	unsigned long flags;
+
+	cancel_work_sync(&adapter->ptp_tx_work);
+
+	spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
+
+	dev_kfree_skb_any(adapter->ptp_tx_skb);
+	adapter->ptp_tx_skb = NULL;
+
+	spin_unlock_irqrestore(&adapter->ptp_tx_lock, flags);
+}
+
 static void igc_ptp_disable_tx_timestamp(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
 
 	wr32(IGC_TSYNCTXCTL, 0);
+
+	igc_ptp_clear_tx_tstamp(adapter);
 }
 
 static void igc_ptp_enable_tx_timestamp(struct igc_adapter *adapter)
@@ -620,6 +636,9 @@ void igc_ptp_tx_hang(struct igc_adapter *adapter)
 {
 	unsigned long flags;
 
+	if (adapter->tstamp_config.tx_type != HWTSTAMP_TX_ON)
+		return;
+
 	spin_lock_irqsave(&adapter->ptp_tx_lock, flags);
 
 	if (!adapter->ptp_tx_skb)
@@ -1026,9 +1045,7 @@ void igc_ptp_suspend(struct igc_adapter *adapter)
 	if (!(adapter->ptp_flags & IGC_PTP_ENABLED))
 		return;
 
-	cancel_work_sync(&adapter->ptp_tx_work);
-	dev_kfree_skb_any(adapter->ptp_tx_skb);
-	adapter->ptp_tx_skb = NULL;
+	igc_ptp_clear_tx_tstamp(adapter);
 
 	if (pci_device_is_present(adapter->pdev)) {
 		igc_ptp_time_save(adapter);
-- 
2.38.1



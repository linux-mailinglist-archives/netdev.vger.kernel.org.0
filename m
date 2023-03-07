Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9666AF85A
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbjCGWPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:15:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCGWO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:14:59 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2EB73888
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678227297; x=1709763297;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6g17DrKm7GWFWV4n0tdmlvwn1wsCGbrXp0GdUJXlkvM=;
  b=J9ACZXkzh7ZOMpV8gnrQymTjrmIrd+xDCCD1yAozL3HuRq7wpbXvezG6
   0upsknQPukqUm0lGJ63OEMYj4X2kw/j3hLnY42c9mlvI90qTqcys1dqcA
   150YKzA2ZOA/TdRpURX0aKJeQZDqPoCXzppjvJcNzXFS+qSIQlTJOUJn5
   DmXYsd795ckrNQrnwcgPBwPtI2Be06/b1WSQUtlrHYpqu7unYvW0XbluS
   ygN4/ifBbDsCjkSpc03qUs2MO71bKJwAgEVe2h1AQQTsUvZT8HeO6ZdPE
   9vQmd1nSoFfkQUfRg0lF8xJT9UuMJE+kEGamohYzw+uDihcBTia4fJGSJ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338310801"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="338310801"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:14:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626701512"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="626701512"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 14:14:56 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Tan Tee Min <tee.min.tan@linux.intel.com>,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next v2 2/3] igc: offload queue max SDU from tc-taprio
Date:   Tue,  7 Mar 2023 14:13:31 -0800
Message-Id: <20230307221332.3997881-3-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
References: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Add support for configuring the max SDU for each Tx queue.
If not specified, keep the default.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_hw.h   |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 33 ++++++++++++++++++++---
 3 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 79cc99af4317..c0c00b8bd8d8 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -99,6 +99,7 @@ struct igc_ring {
 
 	u32 start_time;
 	u32 end_time;
+	u32 max_sdu;
 
 	/* CBS parameters */
 	bool cbs_enable;                /* indicates if CBS is enabled */
diff --git a/drivers/net/ethernet/intel/igc/igc_hw.h b/drivers/net/ethernet/intel/igc/igc_hw.h
index 88680e3d613d..e1c572e0d4ef 100644
--- a/drivers/net/ethernet/intel/igc/igc_hw.h
+++ b/drivers/net/ethernet/intel/igc/igc_hw.h
@@ -273,6 +273,7 @@ struct igc_hw_stats {
 	u64 o2bspc;
 	u64 b2ospc;
 	u64 b2ogprc;
+	u64 txdrop;
 };
 
 struct net_device *igc_get_hw_dev(struct igc_hw *hw);
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 4992cca4029d..1e1245085a36 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1501,6 +1501,7 @@ static int igc_tso(struct igc_ring *tx_ring,
 static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 				       struct igc_ring *tx_ring)
 {
+	struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
 	bool first_flag = false, insert_empty = false;
 	u16 count = TXD_USE_COUNT(skb_headlen(skb));
 	__be16 protocol = vlan_get_protocol(skb);
@@ -1563,9 +1564,19 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	first->bytecount = skb->len;
 	first->gso_segs = 1;
 
-	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
-		struct igc_adapter *adapter = netdev_priv(tx_ring->netdev);
+	if (tx_ring->max_sdu > 0) {
+		u32 max_sdu = 0;
+
+		max_sdu = tx_ring->max_sdu +
+			  (skb_vlan_tagged(first->skb) ? VLAN_HLEN : 0);
 
+		if (first->bytecount > max_sdu) {
+			adapter->stats.txdrop++;
+			goto out_drop;
+		}
+	}
+
+	if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		/* FIXME: add support for retrieving timestamps from
 		 * the other timer registers before skipping the
 		 * timestamping request.
@@ -4920,7 +4931,8 @@ void igc_update_stats(struct igc_adapter *adapter)
 	net_stats->tx_window_errors = adapter->stats.latecol;
 	net_stats->tx_carrier_errors = adapter->stats.tncrs;
 
-	/* Tx Dropped needs to be maintained elsewhere */
+	/* Tx Dropped */
+	net_stats->tx_dropped = adapter->stats.txdrop;
 
 	/* Management Stats */
 	adapter->stats.mgptc += rd32(IGC_MGTPTC);
@@ -6056,6 +6068,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
+		ring->max_sdu = 0;
 	}
 
 	return 0;
@@ -6139,6 +6152,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		}
 	}
 
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+		struct net_device *dev = adapter->netdev;
+
+		if (qopt->max_sdu[i])
+			ring->max_sdu = qopt->max_sdu[i] + dev->hard_header_len;
+		else
+			ring->max_sdu = 0;
+	}
+
 	return 0;
 }
 
@@ -6237,8 +6260,10 @@ static int igc_tc_query_caps(struct igc_adapter *adapter,
 
 		caps->broken_mqprio = true;
 
-		if (hw->mac.type == igc_i225)
+		if (hw->mac.type == igc_i225) {
+			caps->supports_queue_max_sdu = true;
 			caps->gate_mask_per_txq = true;
+		}
 
 		return 0;
 	}
-- 
2.38.1


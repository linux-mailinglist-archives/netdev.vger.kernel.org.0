Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A7A68E505
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjBHAhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBHAhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:18 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D352514EA7
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675816636; x=1707352636;
  h=from:to:cc:subject:date:message-id;
  bh=UiGGeG09/xWgsrDmkR1WSlAI1WubWg9eUFL6lyR5URQ=;
  b=jVFg/5+NBApWFQHQ6e5O4CJUgF6AYKAguWEDEFbisYCSXEQEPTqu3nN6
   By1YouyYmSB+IdEqv0F9aRTY3YNg+aJwwo0JtM/5q57c3Aa0TPU8j2o68
   HHwgij0r2Qg/NZTQHdyxBehU3/IjucWo957Q4kLBg1n32CN5spcETTY6a
   1ehcrBzrVK1lRYAubGP+0p5fawoMX0AwcjlAYV1m5v0PfSHjBxmSoe16W
   2VzblyRVftV186vcv3BF7fA8QqSBRZ/YqKR5p3MZrYXwo9Wd8uTEuG+kO
   6BbND5jBe+GBwrk2liW5HJ1Q/bF8NZWw1f025R2blEW1J2j4ylhDyhud9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="330959562"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="330959562"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 16:37:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="912531757"
X-IronPort-AV: E=Sophos;i="5.97,279,1669104000"; 
   d="scan'208";a="912531757"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2023 16:37:12 -0800
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     vinicius.gomes@intel.com, muhammad.husaini.zulkifli@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com,
        leon@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        tee.min.tan@linux.intel.com, netdev@vger.kernel.org,
        sasha.neftin@intel.com
Subject: [PATCH net-next v3] igc: offload queue max SDU from tc-taprio
Date:   Wed,  8 Feb 2023 08:33:27 +0800
Message-Id: <20230208003327.29538-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 26 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 9db93c1f97679..34aebf00a5123 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -99,6 +99,7 @@ struct igc_ring {
 
 	u32 start_time;
 	u32 end_time;
+	u32 max_sdu;
 
 	/* CBS parameters */
 	bool cbs_enable;                /* indicates if CBS is enabled */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 0cc327294dfb5..38ad437957ada 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1508,6 +1508,7 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	__le32 launch_time = 0;
 	u32 tx_flags = 0;
 	unsigned short f;
+	u32 max_sdu = 0;
 	ktime_t txtime;
 	u8 hdr_len = 0;
 	int tso = 0;
@@ -1527,6 +1528,14 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (tx_ring->max_sdu > 0) {
+		max_sdu = tx_ring->max_sdu +
+			  (skb_vlan_tagged(skb) ? VLAN_HLEN : 0);
+
+		if (skb->len > max_sdu)
+			goto skb_drop;
+	}
+
 	if (!tx_ring->launchtime_enable)
 		goto done;
 
@@ -1606,6 +1615,11 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	dev_kfree_skb_any(first->skb);
 	first->skb = NULL;
 
+	return NETDEV_TX_OK;
+
+skb_drop:
+	dev_kfree_skb_any(skb);
+
 	return NETDEV_TX_OK;
 }
 
@@ -6039,6 +6053,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
+		ring->max_sdu = 0;
 	}
 
 	return 0;
@@ -6122,6 +6137,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
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
 
@@ -6221,6 +6246,7 @@ static int igc_tc_query_caps(struct igc_adapter *adapter,
 		if (hw->mac.type != igc_i225)
 			return -EOPNOTSUPP;
 
+		caps->supports_queue_max_sdu = true;
 		caps->gate_mask_per_txq = true;
 
 		return 0;
-- 
2.17.1


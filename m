Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9809264ED76
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 16:07:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbiLPPHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 10:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiLPPGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 10:06:51 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EFEF64D0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 07:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671203209; x=1702739209;
  h=from:to:cc:subject:date:message-id;
  bh=OeXMTLxw0wWGtT6lAWeksKRNAiSkK/9syol4Gnzq8G8=;
  b=Vi/NYMMPXvzLOhsNohTxCkn7dFceU3dTY1B+8CzTB3OSWvcTHzT1JMSD
   8Grr+fpkl3irStRmr52ostDbeg3dOxiF/PaeT/WpHCPKio+0S/AFPcfAF
   yO1D2BJ/767fAAqxP/LhQE9XF1OGGuO5U9iOlZq/1manFsxzL+XrvO78R
   u5p+J1ukFHJSu8oM4TRDDp9qWZWtXPTmFoh2J/6UbX4TKKagRP56rmo9R
   /CcEgNBjyU7QRr7dWa7bNysRmUqoCgVwMjDRsnvtemUTSLmC4HxZoZKia
   yo3QfdCt8qBdrWPZHelI2+i/EvD+5Qj26E3c1x9FRZQ3rleROfarjFZoz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="405241079"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="405241079"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 07:06:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="599979417"
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="599979417"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga003.jf.intel.com with ESMTP; 16 Dec 2022 07:06:45 -0800
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org, vinicius.gomes@intel.com
Cc:     tee.min.tan@linux.intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, muhammad.husaini.zulkifli@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v2] igc: offload queue max SDU from tc-taprio
Date:   Fri, 16 Dec 2022 23:03:57 +0800
Message-Id: <20221216150357.12721-1-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tan Tee Min <tee.min.tan@linux.intel.com>

Add support for configuring the max SDU for each Tx queue.
If not specified, keep the default.

All link speeds have been tested with this implementation.
No performance issue observed.

How to test:

1) Configure the tc with max-sdu

tc qdisc replace dev $IFACE parent root handle 100 taprio \
    num_tc 4 \
    map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
    queues 1@0 1@1 1@2 1@3 \
    base-time $BASE \
    sched-entry S 0xF 1000000 \
    max-sdu 1500 1498 0 0 0 0 0 0 0 0 0 0 0 0 0 0 \
    flags 0x2 \
    txtime-delay 0

2) Use network statistic to watch the tx queue packet to see if
packet able to go out or drop.

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

---
V1 -> V2: Rework based on Vinicius's comment.
---
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 44 +++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index 5da8d162cd38..ce9e88687d8c 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -99,6 +99,7 @@ struct igc_ring {
 
 	u32 start_time;
 	u32 end_time;
+	u32 max_sdu;
 
 	/* CBS parameters */
 	bool cbs_enable;                /* indicates if CBS is enabled */
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index fdb7f0b26ed0..741c938313cf 100644
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
 
@@ -1606,6 +1615,12 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 	dev_kfree_skb_any(first->skb);
 	first->skb = NULL;
 
+	return NETDEV_TX_OK;
+
+skb_drop:
+	dev_kfree_skb_any(skb);
+	skb = NULL;
+
 	return NETDEV_TX_OK;
 }
 
@@ -6018,6 +6033,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
+		ring->max_sdu = 0;
 	}
 
 	return 0;
@@ -6101,6 +6117,16 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
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
 
@@ -6188,12 +6214,30 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
 	return igc_tsn_offload_apply(adapter);
 }
 
+static int igc_tsn_query_caps(struct tc_query_caps_base *base)
+{
+	switch (base->type) {
+	case TC_SETUP_QDISC_TAPRIO: {
+		struct tc_taprio_caps *caps = base->caps;
+
+		caps->supports_queue_max_sdu = true;
+
+		return 0;
+	}
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
 static int igc_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			void *type_data)
 {
 	struct igc_adapter *adapter = netdev_priv(dev);
 
 	switch (type) {
+	case TC_QUERY_CAPS:
+		return igc_tsn_query_caps(type_data);
+
 	case TC_SETUP_QDISC_TAPRIO:
 		return igc_tsn_enable_qbv_scheduling(adapter, type_data);
 
-- 
2.17.1


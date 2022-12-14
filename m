Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894D164CCA3
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 15:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238693AbiLNOsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 09:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238363AbiLNOsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 09:48:04 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D8F25E9A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 06:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671029283; x=1702565283;
  h=from:to:cc:subject:date:message-id;
  bh=hE+duJjVL/XZ+Hrat12cRrAn1SphY0J+zWacymV85VI=;
  b=dQWwyvXnLSxOYDlGoDxAKB658cCqumVlHybv7rRYctV3u85yWD4s/TjA
   Y/sNGZwVmDR2UQSKX5UlvVH0Xpipf0kJDX3IUqhN6F7pznCea8wCIQS4W
   IPreaC5FFRmx2Cl2GVDz7u3UD4POTeK9MyTO8L3mmRyS8Hu3ZoKxkB8LK
   sk5b9qPauN1/briWyDhO54YmB86t8qXEssVnKEKvhBP3eItvjq4gmOsRQ
   Asy8I2wlulfWx2HGJcUYVxxNKQIZAu8GQ4CbJLMpt4SP40ubUceJbJZQY
   2iuI0ILwLTMEAwEnqV8zqt8nYYyfPGVMrw0gvW2XE3qlvSbzCVdVbWA+m
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="298767290"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="298767290"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 06:48:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="649053426"
X-IronPort-AV: E=Sophos;i="5.96,244,1665471600"; 
   d="scan'208";a="649053426"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by orsmga002.jf.intel.com with ESMTP; 14 Dec 2022 06:48:00 -0800
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org, vinicius.gomes@intel.com
Cc:     tee.min.tan@linux.intel.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, muhammad.husaini.zulkifli@intel.com,
        naamax.meir@linux.intel.com, anthony.l.nguyen@intel.com
Subject: [PATCH net-next v1] igc: offload queue max SDU from tc-taprio
Date:   Wed, 14 Dec 2022 22:45:14 +0800
Message-Id: <20221214144514.15931-1-muhammad.husaini.zulkifli@intel.com>
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

Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h      |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c | 45 +++++++++++++++++++++++
 include/net/pkt_sched.h                   |  1 +
 net/sched/sch_taprio.c                    |  4 +-
 4 files changed, 50 insertions(+), 1 deletion(-)

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
index e07287e05862..7ce05c31e371 100644
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
@@ -1527,6 +1528,16 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
+	if (tx_ring->max_sdu > 0) {
+		if (skb_vlan_tagged(skb))
+			max_sdu = tx_ring->max_sdu + VLAN_HLEN;
+		else
+			max_sdu = tx_ring->max_sdu;
+
+		if (skb->len > max_sdu)
+			goto skb_drop;
+	}
+
 	if (!tx_ring->launchtime_enable)
 		goto done;
 
@@ -1606,6 +1617,12 @@ static netdev_tx_t igc_xmit_frame_ring(struct sk_buff *skb,
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
 
@@ -6015,6 +6032,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 		ring->start_time = 0;
 		ring->end_time = NSEC_PER_SEC;
+		ring->max_sdu = 0;
 	}
 
 	return 0;
@@ -6097,6 +6115,15 @@ static int igc_save_qbv_schedule(struct igc_adapter *adapter,
 		}
 	}
 
+	for (i = 0; i < adapter->num_tx_queues; i++) {
+		struct igc_ring *ring = adapter->tx_ring[i];
+
+		if (qopt->max_frm_len[i] == U32_MAX)
+			ring->max_sdu = 0;
+		else
+			ring->max_sdu = qopt->max_frm_len[i];
+	}
+
 	return 0;
 }
 
@@ -6184,12 +6211,30 @@ static int igc_tsn_enable_cbs(struct igc_adapter *adapter,
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
 
diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 38207873eda6..d2539b1f6529 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -178,6 +178,7 @@ struct tc_taprio_qopt_offload {
 	u64 cycle_time;
 	u64 cycle_time_extension;
 	u32 max_sdu[TC_MAX_QUEUE];
+	u32 max_frm_len[TC_MAX_QUEUE];
 
 	size_t num_entries;
 	struct tc_taprio_sched_entry entries[];
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 570389f6cdd7..d39164074756 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1263,8 +1263,10 @@ static int taprio_enable_offload(struct net_device *dev,
 	offload->enable = 1;
 	taprio_sched_to_offload(dev, sched, offload);
 
-	for (tc = 0; tc < TC_MAX_QUEUE; tc++)
+	for (tc = 0; tc < TC_MAX_QUEUE; tc++) {
 		offload->max_sdu[tc] = q->max_sdu[tc];
+		offload->max_frm_len[tc] = q->max_frm_len[tc];
+	}
 
 	err = ops->ndo_setup_tc(dev, TC_SETUP_QDISC_TAPRIO, offload);
 	if (err < 0) {
-- 
2.17.1


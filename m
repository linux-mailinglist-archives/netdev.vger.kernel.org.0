Return-Path: <netdev+bounces-7200-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4C8B71F0C0
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:29:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3964328186F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:29:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 244DA47001;
	Thu,  1 Jun 2023 17:28:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A0C42501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:28:38 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BBA1A5
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685640514; x=1717176514;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=E/0xGHZW5oru8YpOpFgUxsFVfiXRc5zOq+Ho+HLO5Gc=;
  b=mBYwA7MOimMchdkLi7etRhqEG/L6tB09vS79zHBSD59hy0ftRvex9xFl
   99ifQ7i5h2/VNp6+XMqBLI3CDAk/oPSSQNRcqynMVuAqBKgThTXCy6K6b
   +qL/0OGpJ1TxrkcTar+qqTc/fkCa8yYj/4EWVMEESKIhfwJ30zCC+S1ks
   JGW05RfPYoWEveCxx9QVZkzPerZW2gkx9nzMA0/B/3YE7HdxGMLPFaozT
   DJdVHEvR0Qsti0Qf03exmh7qOMpPULMEerVR7ghO1naRE4KFM7nd31Yoo
   MZAEVdNLboMKzwFqHG8cfYJYQZ+CVfbF/xhAjw+Se4pBz5HLdnm+FeW3M
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="355647485"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="355647485"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Jun 2023 10:28:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10728"; a="701638199"
X-IronPort-AV: E=Sophos;i="6.00,210,1681196400"; 
   d="scan'208";a="701638199"
Received: from anambiarhost.jf.intel.com ([10.166.29.163])
  by orsmga007.jf.intel.com with ESMTP; 01 Jun 2023 10:28:34 -0700
Subject: [net-next/RFC PATCH v1 2/4] net: Add support for associating napi
 with queue[s]
From: Amritha Nambiar <amritha.nambiar@intel.com>
To: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net
Cc: sridhar.samudrala@intel.com, amritha.nambiar@intel.com
Date: Thu, 01 Jun 2023 10:42:30 -0700
Message-ID: <168564135094.7284.9691772825401908320.stgit@anambiarhost.jf.intel.com>
In-Reply-To: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
References: <168564116688.7284.6877238631049679250.stgit@anambiarhost.jf.intel.com>
User-Agent: StGit/unknown-version
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

After the napi context is initialized, map the napi instance
with the queue/queue-set on the corresponding irq line.

Signed-off-by: Amritha Nambiar <amritha.nambiar@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_lib.c  |   57 +++++++++++++++++++++++++++++
 drivers/net/ethernet/intel/ice/ice_lib.h  |    4 ++
 drivers/net/ethernet/intel/ice/ice_main.c |    4 ++
 include/linux/netdevice.h                 |   11 ++++++
 net/core/dev.c                            |   34 +++++++++++++++++
 5 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 5ddb95d1073a..58f68363119f 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2478,6 +2478,12 @@ ice_vsi_cfg_def(struct ice_vsi *vsi, struct ice_vsi_cfg_params *params)
 			goto unroll_vector_base;
 
 		ice_vsi_map_rings_to_vectors(vsi);
+
+		/* Associate q_vector rings to napi */
+		ret = ice_vsi_add_napi_queues(vsi);
+		if (ret)
+			goto unroll_vector_base;
+
 		vsi->stat_offsets_loaded = false;
 
 		if (ice_is_xdp_ena_vsi(vsi)) {
@@ -2957,6 +2963,57 @@ void ice_vsi_dis_irq(struct ice_vsi *vsi)
 		synchronize_irq(vsi->q_vectors[i]->irq.virq);
 }
 
+/**
+ * ice_q_vector_add_napi_queues - Add queue[s] associated with the napi
+ * @q_vector: q_vector pointer
+ *
+ * Associate the q_vector napi with all the queue[s] on the vector
+ * Returns 0 on success or < 0 on error
+ */
+int ice_q_vector_add_napi_queues(struct ice_q_vector *q_vector)
+{
+	struct ice_rx_ring *rx_ring;
+	struct ice_tx_ring *tx_ring;
+	int ret;
+
+	ice_for_each_rx_ring(rx_ring, q_vector->rx) {
+		ret = netif_napi_add_queue(&q_vector->napi, rx_ring->q_index,
+					   NAPI_RX_CONTAINER);
+		if (ret)
+			return ret;
+	}
+	ice_for_each_tx_ring(tx_ring, q_vector->tx) {
+		ret = netif_napi_add_queue(&q_vector->napi, tx_ring->q_index,
+					   NAPI_TX_CONTAINER);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+/**
+ * ice_vsi_add_napi_queues
+ * @vsi: VSI pointer
+ *
+ * Associate queue[s] with napi for all vectors
+ * Returns 0 on success or < 0 on error
+ */
+int ice_vsi_add_napi_queues(struct ice_vsi *vsi)
+{
+	int i, ret = 0;
+
+	if (!vsi->netdev)
+		return ret;
+
+	ice_for_each_q_vector(vsi, i) {
+		ret = ice_q_vector_add_napi_queues(vsi->q_vectors[i]);
+		if (ret)
+			return ret;
+	}
+	return ret;
+}
+
 /**
  * ice_napi_del - Remove NAPI handler for the VSI
  * @vsi: VSI for which NAPI handler is to be removed
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.h b/drivers/net/ethernet/intel/ice/ice_lib.h
index e985766e6bb5..623b5f738a5c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.h
+++ b/drivers/net/ethernet/intel/ice/ice_lib.h
@@ -93,6 +93,10 @@ void ice_vsi_cfg_netdev_tc(struct ice_vsi *vsi, u8 ena_tc);
 struct ice_vsi *
 ice_vsi_setup(struct ice_pf *pf, struct ice_vsi_cfg_params *params);
 
+int ice_q_vector_add_napi_queues(struct ice_q_vector *q_vector);
+
+int ice_vsi_add_napi_queues(struct ice_vsi *vsi);
+
 void ice_napi_del(struct ice_vsi *vsi);
 
 int ice_vsi_release(struct ice_vsi *vsi);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 62e91512aeab..c66ff1473aeb 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3348,9 +3348,11 @@ static void ice_napi_add(struct ice_vsi *vsi)
 	if (!vsi->netdev)
 		return;
 
-	ice_for_each_q_vector(vsi, v_idx)
+	ice_for_each_q_vector(vsi, v_idx) {
 		netif_napi_add(vsi->netdev, &vsi->q_vectors[v_idx]->napi,
 			       ice_napi_poll);
+		ice_q_vector_add_napi_queues(vsi->q_vectors[v_idx]);
+	}
 }
 
 /**
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 49f64401af7c..a562db712c6e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -342,6 +342,14 @@ struct gro_list {
  */
 #define GRO_HASH_BUCKETS	8
 
+/*
+ * napi queue container type
+ */
+enum napi_container_type {
+	NAPI_RX_CONTAINER,
+	NAPI_TX_CONTAINER,
+};
+
 struct napi_queue {
 	struct list_head	q_list;
 	u16			queue_index;
@@ -2622,6 +2630,9 @@ static inline void *netdev_priv(const struct net_device *dev)
  */
 #define SET_NETDEV_DEVTYPE(net, devtype)	((net)->dev.type = (devtype))
 
+int netif_napi_add_queue(struct napi_struct *napi, u16 queue_index,
+			 enum napi_container_type);
+
 /* Default NAPI poll() weight
  * Device drivers are strongly advised to not use bigger value
  */
diff --git a/net/core/dev.c b/net/core/dev.c
index 9ee8eb3ef223..ba712119ec85 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6366,6 +6366,40 @@ int dev_set_threaded(struct net_device *dev, bool threaded)
 }
 EXPORT_SYMBOL(dev_set_threaded);
 
+/**
+ * netif_napi_add_queue - Associate queue with the napi
+ * @napi: NAPI context
+ * @queue_index: Index of queue
+ * @napi_container_type: queue type as RX or TX
+ *
+ * Add queue with its corresponding napi context
+ */
+int netif_napi_add_queue(struct napi_struct *napi, u16 queue_index,
+			 enum napi_container_type type)
+{
+	struct napi_queue *napi_queue;
+
+	napi_queue = kzalloc(sizeof(*napi_queue), GFP_KERNEL);
+	if (!napi_queue)
+		return -ENOMEM;
+
+	napi_queue->queue_index = queue_index;
+
+	switch (type) {
+	case NAPI_RX_CONTAINER:
+		list_add_rcu(&napi_queue->q_list, &napi->napi_rxq_list);
+		break;
+	case NAPI_TX_CONTAINER:
+		list_add_rcu(&napi_queue->q_list, &napi->napi_txq_list);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(netif_napi_add_queue);
+
 void netif_napi_add_weight(struct net_device *dev, struct napi_struct *napi,
 			   int (*poll)(struct napi_struct *, int), int weight)
 {



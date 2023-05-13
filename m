Return-Path: <netdev+bounces-2393-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8482701AB9
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 01:00:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59B22280C5A
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 23:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 317EBC137;
	Sat, 13 May 2023 22:57:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A16C131
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 22:57:36 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B6D826BC
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 15:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684018652; x=1715554652;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=PttRQ068HoYJt0aJbzRSaGdNr2p9O82UIOx3LQWa/nI=;
  b=Cp8TTKBBWBrz9ynpPqSwe7R3ZuLKV4G7THDm3ZCKgOa8SoOzizj7Q3hx
   d20gEGy3/gridN5i8djwfdg7SD+xAO/O9mq3hixkQ1Ls4BhHDtQGmYoKu
   lL8lu9IPeuI5cHEhHmUNvoZz1QUOSzNJOhV4INS9CzKxzH8PUjjIx+0tu
   rgPS6t1W9PYVjGhWBcwbP2Gsw8SP5JNUxm82oMVqFKoo1HlG3yizkxBY6
   Mn5HBOz9PviwL3HatiAPvNz4HMgyG4JlLWV+MNe4rs/sYwTwJCmR7I3Ti
   HsywrPH9NzgNa/CiG4e0tpmR/kE5QBMZIH3wXSxExtzvPkhTmpulEnbcj
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="348487576"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="348487576"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 15:57:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10709"; a="770171492"
X-IronPort-AV: E=Sophos;i="5.99,273,1677571200"; 
   d="scan'208";a="770171492"
Received: from estantil-desk.jf.intel.com ([10.166.241.20])
  by fmsmga004.fm.intel.com with ESMTP; 13 May 2023 15:57:25 -0700
From: Emil Tantilov <emil.s.tantilov@intel.com>
To: intel-wired-lan@lists.osuosl.org
Cc: shannon.nelson@amd.com,
	simon.horman@corigine.com,
	leon@kernel.org,
	decot@google.com,
	willemb@google.com,
	Alan Brady <alan.brady@intel.com>,
	jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	Alice Michael <alice.michael@intel.com>,
	Joshua Hay <joshua.a.hay@intel.com>,
	Madhu Chittim <madhu.chittim@intel.com>,
	Phani Burra <phani.r.burra@intel.com>,
	Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Subject: [PATCH iwl-next v5 08/15] idpf: configure resources for RX queues
Date: Sat, 13 May 2023 15:57:03 -0700
Message-Id: <20230513225710.3898-9-emil.s.tantilov@intel.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20230513225710.3898-1-emil.s.tantilov@intel.com>
References: <20230513225710.3898-1-emil.s.tantilov@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Alan Brady <alan.brady@intel.com>

Similar to the TX, RX also supports both single and split queue models.
In single queue model, the same descriptor queue is used by SW to post
buffer descriptors to HW and by HW to post completed descriptors
to SW. In split queue model, "RX buffer queues" are used to pass
descriptor buffers from SW to HW whereas "RX queues" are used to
post the descriptor completions i.e. descriptors that point to
completed buffers, from HW to SW. "RX queue group" is a set of
RX queues grouped together and will be serviced by a "RX buffer queue
group". IDPF supports 2 buffer queues i.e. large buffer (4KB) queue
and small buffer (2KB) queue per buffer queue group. HW uses large
buffers for 'hardware gro' feature and also if the packet size is
more than 2KB, if not 2KB buffers are used.

Add all the resources required for the RX queues initialization.
Allocate memory for the RX queue and RX buffer queue groups. Initialize
the software maintained refill queues for buffer management algorithm.

Same like the TX queues, initialize the queue parameters for the RX
queues and send the config RX queue virtchnl message to the device
Control Plane.

Signed-off-by: Alan Brady <alan.brady@intel.com>
Co-developed-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alice Michael <alice.michael@intel.com>
Co-developed-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Co-developed-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Co-developed-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Co-developed-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 drivers/net/ethernet/intel/idpf/Makefile      |   1 +
 drivers/net/ethernet/intel/idpf/idpf.h        |  37 +-
 .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  54 +-
 drivers/net/ethernet/intel/idpf/idpf_lib.c    |  35 +-
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   |  60 ++
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 920 +++++++++++++++++-
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   | 148 ++-
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 495 +++++++++-
 8 files changed, 1735 insertions(+), 15 deletions(-)
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c

diff --git a/drivers/net/ethernet/intel/idpf/Makefile b/drivers/net/ethernet/intel/idpf/Makefile
index 536381e57ab6..c5584eb27742 100644
--- a/drivers/net/ethernet/intel/idpf/Makefile
+++ b/drivers/net/ethernet/intel/idpf/Makefile
@@ -11,6 +11,7 @@ idpf-y := \
 	idpf_dev.o		\
 	idpf_lib.o		\
 	idpf_main.o		\
+	idpf_singleq_txrx.o	\
 	idpf_txrx.o		\
 	idpf_virtchnl.o 	\
 	idpf_vf_dev.o
diff --git a/drivers/net/ethernet/intel/idpf/idpf.h b/drivers/net/ethernet/intel/idpf/idpf.h
index 22fcc68226f2..ea90e147516b 100644
--- a/drivers/net/ethernet/intel/idpf/idpf.h
+++ b/drivers/net/ethernet/intel/idpf/idpf.h
@@ -154,10 +154,20 @@ struct idpf_dev_ops {
 	STATE(IDPF_VC_DESTROY_VPORT_ERR)	\
 	STATE(IDPF_VC_CONFIG_TXQ)		\
 	STATE(IDPF_VC_CONFIG_TXQ_ERR)		\
+	STATE(IDPF_VC_CONFIG_RXQ)		\
+	STATE(IDPF_VC_CONFIG_RXQ_ERR)		\
 	STATE(IDPF_VC_ALLOC_VECTORS)		\
 	STATE(IDPF_VC_ALLOC_VECTORS_ERR)	\
 	STATE(IDPF_VC_DEALLOC_VECTORS)		\
 	STATE(IDPF_VC_DEALLOC_VECTORS_ERR)	\
+	STATE(IDPF_VC_GET_RSS_LUT)		\
+	STATE(IDPF_VC_GET_RSS_LUT_ERR)		\
+	STATE(IDPF_VC_SET_RSS_LUT)		\
+	STATE(IDPF_VC_SET_RSS_LUT_ERR)		\
+	STATE(IDPF_VC_GET_RSS_KEY)		\
+	STATE(IDPF_VC_GET_RSS_KEY_ERR)		\
+	STATE(IDPF_VC_SET_RSS_KEY)		\
+	STATE(IDPF_VC_SET_RSS_KEY_ERR)		\
 	STATE(IDPF_VC_ADD_MAC_ADDR)		\
 	STATE(IDPF_VC_ADD_MAC_ADDR_ERR)		\
 	STATE(IDPF_VC_DEL_MAC_ADDR)		\
@@ -222,6 +232,7 @@ struct idpf_vport {
 	int bufq_desc_count[IDPF_MAX_BUFQS_PER_RXQ_GRP];
 	u32 bufq_size[IDPF_MAX_BUFQS_PER_RXQ_GRP];
 	int num_rxq_grp;
+	struct idpf_rxq_group *rxq_grps;
 	u32 rxq_model;
 	struct idpf_rx_ptype_decoded rx_ptype_lkup[IDPF_RX_MAX_PTYPE];
 
@@ -254,8 +265,17 @@ struct idpf_vport {
 	spinlock_t mac_filter_list_lock;
 };
 
+struct idpf_rss_data {
+	u16 rss_key_size;
+	u8 *rss_key;
+	u16 rss_lut_size;
+	u32 *rss_lut;
+	u32 *cached_lut;
+};
+
 /* User defined configuration values for each vport */
 struct idpf_vport_user_config_data {
+	struct idpf_rss_data rss_data;
 	u32 num_req_tx_qs; /* user requested TX queues through ethtool */
 	u32 num_req_rx_qs; /* user requested RX queues through ethtool */
 	u32 num_req_txq_desc; /* user requested TX queue descriptors through ethtool */
@@ -539,6 +559,19 @@ static inline struct idpf_vport *idpf_netdev_to_vport(struct net_device *netdev)
 	return np->vport;
 }
 
+/**
+ * idpf_is_feature_ena - Determine if a particular feature is enabled
+ * @vport: vport to check
+ * @feature: netdev flag to check
+ *
+ * Returns true or false if a particular feature is enabled.
+ */
+static inline bool idpf_is_feature_ena(struct idpf_vport *vport,
+				       netdev_features_t feature)
+{
+	return vport->netdev->features & feature;
+}
+
 void idpf_init_task(struct work_struct *work);
 void idpf_service_task(struct work_struct *work);
 void idpf_vc_event_task(struct work_struct *work);
@@ -552,6 +585,8 @@ int idpf_intr_req(struct idpf_adapter *adapter);
 void idpf_intr_rel(struct idpf_adapter *adapter);
 int idpf_send_destroy_vport_msg(struct idpf_vport *vport);
 int idpf_send_get_rx_ptype_msg(struct idpf_vport *vport);
+int idpf_send_get_set_rss_key_msg(struct idpf_vport *vport, bool get);
+int idpf_send_get_set_rss_lut_msg(struct idpf_vport *vport, bool get);
 int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter);
 int idpf_send_alloc_vectors_msg(struct idpf_adapter *adapter, u16 num_vectors);
 void idpf_deinit_task(struct idpf_adapter *adapter);
@@ -571,7 +606,7 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q);
 u32 idpf_get_vport_id(struct idpf_vport *vport);
 int idpf_vport_queue_ids_init(struct idpf_vport *vport);
 int idpf_queue_reg_init(struct idpf_vport *vport);
-int idpf_send_config_tx_queues_msg(struct idpf_vport *vport);
+int idpf_send_config_queues_msg(struct idpf_vport *vport);
 int idpf_send_create_vport_msg(struct idpf_adapter *adapter,
 			       struct idpf_vport_max_q *max_q);
 int idpf_check_supported_desc_ids(struct idpf_vport *vport);
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
index e02b7f7ae5ce..aac1e7c1a301 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
@@ -1,9 +1,61 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
-/* Copyright (C) 2022 Intel Corporation */
+/* Copyright (C) 2023 Intel Corporation */
 
 #ifndef _IDPF_LAN_TXRX_H_
 #define _IDPF_LAN_TXRX_H_
 
+enum idpf_rss_hash {
+	IDPF_HASH_INVALID			= 0,
+	/* Values 1 - 28 are reserved for future use */
+	IDPF_HASH_NONF_UNICAST_IPV4_UDP		= 29,
+	IDPF_HASH_NONF_MULTICAST_IPV4_UDP,
+	IDPF_HASH_NONF_IPV4_UDP,
+	IDPF_HASH_NONF_IPV4_TCP_SYN_NO_ACK,
+	IDPF_HASH_NONF_IPV4_TCP,
+	IDPF_HASH_NONF_IPV4_SCTP,
+	IDPF_HASH_NONF_IPV4_OTHER,
+	IDPF_HASH_FRAG_IPV4,
+	/* Values 37-38 are reserved */
+	IDPF_HASH_NONF_UNICAST_IPV6_UDP		= 39,
+	IDPF_HASH_NONF_MULTICAST_IPV6_UDP,
+	IDPF_HASH_NONF_IPV6_UDP,
+	IDPF_HASH_NONF_IPV6_TCP_SYN_NO_ACK,
+	IDPF_HASH_NONF_IPV6_TCP,
+	IDPF_HASH_NONF_IPV6_SCTP,
+	IDPF_HASH_NONF_IPV6_OTHER,
+	IDPF_HASH_FRAG_IPV6,
+	IDPF_HASH_NONF_RSVD47,
+	IDPF_HASH_NONF_FCOE_OX,
+	IDPF_HASH_NONF_FCOE_RX,
+	IDPF_HASH_NONF_FCOE_OTHER,
+	/* Values 51-62 are reserved */
+	IDPF_HASH_L2_PAYLOAD			= 63,
+
+	IDPF_HASH_MAX
+};
+
+/* Supported RSS offloads */
+#define IDPF_DEFAULT_RSS_HASH			\
+	(BIT_ULL(IDPF_HASH_NONF_IPV4_UDP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV4_SCTP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV4_TCP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV4_OTHER) |	\
+	BIT_ULL(IDPF_HASH_FRAG_IPV4) |		\
+	BIT_ULL(IDPF_HASH_NONF_IPV6_UDP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV6_TCP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV6_SCTP) |	\
+	BIT_ULL(IDPF_HASH_NONF_IPV6_OTHER) |	\
+	BIT_ULL(IDPF_HASH_FRAG_IPV6) |		\
+	BIT_ULL(IDPF_HASH_L2_PAYLOAD))
+
+#define IDPF_DEFAULT_RSS_HASH_EXPANDED (IDPF_DEFAULT_RSS_HASH | \
+	BIT_ULL(IDPF_HASH_NONF_IPV4_TCP_SYN_NO_ACK) |		\
+	BIT_ULL(IDPF_HASH_NONF_UNICAST_IPV4_UDP) |		\
+	BIT_ULL(IDPF_HASH_NONF_MULTICAST_IPV4_UDP) |		\
+	BIT_ULL(IDPF_HASH_NONF_IPV6_TCP_SYN_NO_ACK) |		\
+	BIT_ULL(IDPF_HASH_NONF_UNICAST_IPV6_UDP) |		\
+	BIT_ULL(IDPF_HASH_NONF_MULTICAST_IPV6_UDP))
+
 /* Transmit descriptors  */
 /* splitq tx buf, singleq tx buf and singleq compl desc */
 struct idpf_base_tx_desc {
diff --git a/drivers/net/ethernet/intel/idpf/idpf_lib.c b/drivers/net/ethernet/intel/idpf/idpf_lib.c
index 368d8f3bdd89..322b3a032bbd 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_lib.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_lib.c
@@ -658,11 +658,16 @@ static void idpf_vport_rel(struct idpf_vport *vport)
 {
 	struct idpf_adapter *adapter = vport->adapter;
 	struct idpf_vport_config *vport_config;
+	struct idpf_rss_data *rss_data;
 	struct idpf_vport_max_q max_q;
 	u16 idx = vport->idx;
 	int i;
 
 	vport_config = adapter->vport_config[vport->idx];
+	idpf_deinit_rss(vport);
+	rss_data = &vport_config->user_config.rss_data;
+	kfree(rss_data->rss_key);
+	rss_data->rss_key = NULL;
 
 	idpf_send_destroy_vport_msg(vport);
 
@@ -731,6 +736,7 @@ static void idpf_vport_dealloc(struct idpf_vport *vport)
 static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 					   struct idpf_vport_max_q *max_q)
 {
+	struct idpf_rss_data *rss_data;
 	u16 idx = adapter->next_vport;
 	struct idpf_vport *vport;
 
@@ -761,6 +767,21 @@ static struct idpf_vport *idpf_vport_alloc(struct idpf_adapter *adapter,
 
 	idpf_vport_init(vport, max_q);
 
+	/* This alloc is done separate from the LUT because it's not strictly
+	 * dependent on how many queues we have. If we change number of queues
+	 * and soft reset we'll need a new LUT but the key can remain the same
+	 * for as long as the vport exists.
+	 */
+	rss_data = &adapter->vport_config[idx]->user_config.rss_data;
+	rss_data->rss_key = kzalloc(rss_data->rss_key_size, GFP_KERNEL);
+	if (!rss_data->rss_key) {
+		kfree(vport);
+
+		return NULL;
+	}
+	/* Initialize default rss key */
+	netdev_rss_key_fill((void *)rss_data->rss_key, rss_data->rss_key_size);
+
 	/* fill vport slot in the adapter struct */
 	adapter->vports[idx] = vport;
 	adapter->vport_ids[idx] = idpf_get_vport_id(vport);
@@ -817,6 +838,7 @@ void idpf_service_task(struct work_struct *work)
 static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
 {
 	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_vport_config *vport_config;
 	int err;
 
 	if (vport->state != __IDPF_VPORT_DOWN)
@@ -852,13 +874,24 @@ static int idpf_vport_open(struct idpf_vport *vport, bool alloc_res)
 		goto intr_rel;
 	}
 
-	err = idpf_send_config_tx_queues_msg(vport);
+	err = idpf_send_config_queues_msg(vport);
 	if (err) {
 		dev_err(&adapter->pdev->dev, "Failed to configure queues for vport %u, %d\n",
 			vport->vport_id, err);
 		goto intr_rel;
 	}
 
+	vport_config = adapter->vport_config[vport->idx];
+	if (vport_config->user_config.rss_data.rss_lut)
+		err = idpf_config_rss(vport);
+	else
+		err = idpf_init_rss(vport);
+	if (err) {
+		dev_err(&adapter->pdev->dev, "Failed to initialize RSS for vport %u: %d\n",
+			vport->vport_id, err);
+		goto intr_rel;
+	}
+
 	return 0;
 
 intr_rel:
diff --git a/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
new file mode 100644
index 000000000000..2968ca874bdb
--- /dev/null
+++ b/drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright (C) 2023 Intel Corporation */
+
+#include "idpf.h"
+
+/**
+ * idpf_rx_singleq_buf_hw_alloc_all - Replace used receive buffers
+ * @rx_q: queue for which the hw buffers are allocated
+ * @cleaned_count: number of buffers to replace
+ *
+ * Returns false if all allocations were successful, true if any fail
+ */
+bool idpf_rx_singleq_buf_hw_alloc_all(struct idpf_queue *rx_q,
+				      u16 cleaned_count)
+{
+	struct virtchnl2_singleq_rx_buf_desc *desc;
+	u16 nta = rx_q->next_to_alloc;
+	struct idpf_page_info *pinfo;
+	struct idpf_rx_buf *buf;
+
+	if (!cleaned_count)
+		return false;
+
+	desc = IDPF_SINGLEQ_RX_BUF_DESC(rx_q, nta);
+	buf = &rx_q->rx_buf.buf[nta];
+	pinfo = &buf->page_info[buf->page_indx];
+
+	do {
+		if (unlikely(!pinfo->page)) {
+			if (!idpf_init_rx_buf_hw_alloc(rx_q, buf))
+				break;
+		}
+
+		/* Refresh the desc even if buffer_addrs didn't change
+		 * because each write-back erases this info.
+		 */
+		desc->pkt_addr = cpu_to_le64(pinfo->dma + pinfo->page_offset);
+		desc->hdr_addr = 0;
+		desc++;
+
+		buf++;
+		nta++;
+		if (unlikely(nta == rx_q->desc_count)) {
+			desc = IDPF_SINGLEQ_RX_BUF_DESC(rx_q, 0);
+			buf = rx_q->rx_buf.buf;
+			nta = 0;
+		}
+
+		pinfo = &buf->page_info[buf->page_indx];
+
+		cleaned_count--;
+	} while (cleaned_count);
+
+	if (rx_q->next_to_alloc != nta) {
+		idpf_rx_buf_hw_update(rx_q, nta);
+		rx_q->next_to_alloc = nta;
+	}
+
+	return !!cleaned_count;
+}
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 140e75b63b4a..774b63579559 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -262,6 +262,553 @@ static int idpf_tx_desc_alloc_all(struct idpf_vport *vport)
 	return err;
 }
 
+/**
+ * idpf_rx_page_rel - Release an rx buffer page
+ * @rxq: the queue that owns the buffer
+ * @pinfo: pointer to page metadata of page to be freed
+ */
+static void idpf_rx_page_rel(struct idpf_queue *rxq,
+			     struct idpf_page_info *pinfo)
+{
+	if (unlikely(!pinfo->page))
+		return;
+
+	dma_unmap_page_attrs(rxq->dev, pinfo->dma, PAGE_SIZE,
+			     DMA_FROM_DEVICE, IDPF_RX_DMA_ATTR);
+	__page_frag_cache_drain(pinfo->page, pinfo->pagecnt_bias);
+
+	pinfo->page = NULL;
+	pinfo->page_offset = 0;
+}
+
+/**
+ * idpf_rx_buf_rel - Release a rx buffer
+ * @rxq: the queue that owns the buffer
+ * @rx_buf: the buffer to free
+ */
+static void idpf_rx_buf_rel(struct idpf_queue *rxq,
+			    struct idpf_rx_buf *rx_buf)
+{
+	idpf_rx_page_rel(rxq, &rx_buf->page_info[0]);
+	if (PAGE_SIZE < 8192 && rx_buf->buf_size > IDPF_RX_BUF_2048)
+		idpf_rx_page_rel(rxq, &rx_buf->page_info[1]);
+}
+
+/**
+ * idpf_rx_hdr_buf_rel_all - Release header buffer memory
+ * @rxq: queue to use
+ */
+static void idpf_rx_hdr_buf_rel_all(struct idpf_queue *rxq)
+{
+	int i;
+
+	if (!rxq)
+		return;
+
+	if (!rxq->rx_buf.hdr_buf)
+		goto rel_pages;
+
+	for (i = 0; i < rxq->desc_count; i++) {
+		kfree(rxq->rx_buf.hdr_buf[i]);
+		rxq->rx_buf.hdr_buf[i] = NULL;
+	}
+	kfree(rxq->rx_buf.hdr_buf);
+	rxq->rx_buf.hdr_buf = NULL;
+
+rel_pages:
+	for (i = 0; i < rxq->hbuf_pages.nr_pages; i++)
+		idpf_rx_page_rel(rxq, &rxq->hbuf_pages.pages[i]);
+
+	kfree(rxq->hbuf_pages.pages);
+}
+
+/**
+ * idpf_rx_buf_rel_all - Free all Rx buffer resources for a queue
+ * @rxq: queue to be cleaned
+ */
+static void idpf_rx_buf_rel_all(struct idpf_queue *rxq)
+{
+	u16 i;
+
+	/* queue already cleared, nothing to do */
+	if (!rxq->rx_buf.buf)
+		return;
+
+	/* Free all the bufs allocated and given to hw on Rx queue */
+	for (i = 0; i < rxq->desc_count; i++)
+		idpf_rx_buf_rel(rxq, &rxq->rx_buf.buf[i]);
+
+	if (rxq->rx_hsplit_en)
+		idpf_rx_hdr_buf_rel_all(rxq);
+
+	kfree(rxq->rx_buf.buf);
+	rxq->rx_buf.buf = NULL;
+	kfree(rxq->rx_buf.hdr_buf);
+	rxq->rx_buf.hdr_buf = NULL;
+}
+
+/**
+ * idpf_rx_desc_rel - Free a specific Rx q resources
+ * @rxq: queue to clean the resources from
+ * @bufq: buffer q or completion q
+ * @q_model: single or split q model
+ *
+ * Free a specific rx queue resources
+ */
+static void idpf_rx_desc_rel(struct idpf_queue *rxq, bool bufq, s32 q_model)
+{
+	if (!rxq)
+		return;
+
+	if (!bufq && idpf_is_queue_model_split(q_model) && rxq->skb) {
+		dev_kfree_skb_any(rxq->skb);
+		rxq->skb = NULL;
+	}
+
+	if (bufq || !idpf_is_queue_model_split(q_model))
+		idpf_rx_buf_rel_all(rxq);
+
+	rxq->next_to_alloc = 0;
+	rxq->next_to_clean = 0;
+	rxq->next_to_use = 0;
+	if (!rxq->desc_ring)
+		return;
+
+	dmam_free_coherent(rxq->dev, rxq->size, rxq->desc_ring, rxq->dma);
+	rxq->desc_ring = NULL;
+}
+
+/**
+ * idpf_rx_desc_rel_all - Free Rx Resources for All Queues
+ * @vport: virtual port structure
+ *
+ * Free all rx queues resources
+ */
+static void idpf_rx_desc_rel_all(struct idpf_vport *vport)
+{
+	struct idpf_rxq_group *rx_qgrp;
+	int i, j, num_rxq;
+
+	if (!vport->rxq_grps)
+		return;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		rx_qgrp = &vport->rxq_grps[i];
+
+		if (!idpf_is_queue_model_split(vport->rxq_model)) {
+			for (j = 0; j < rx_qgrp->singleq.num_rxq; j++)
+				idpf_rx_desc_rel(rx_qgrp->singleq.rxqs[j],
+						 false, vport->rxq_model);
+			continue;
+		}
+
+		num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		for (j = 0; j < num_rxq; j++)
+			idpf_rx_desc_rel(&rx_qgrp->splitq.rxq_sets[j]->rxq,
+					 false, vport->rxq_model);
+
+		if (!rx_qgrp->splitq.bufq_sets)
+			continue;
+
+		for (j = 0; j < vport->num_bufqs_per_qgrp; j++) {
+			struct idpf_bufq_set *bufq_set =
+				&rx_qgrp->splitq.bufq_sets[j];
+
+			idpf_rx_desc_rel(&bufq_set->bufq, true,
+					 vport->rxq_model);
+		}
+	}
+}
+
+/**
+ * idpf_rx_buf_hw_update - Store the new tail and head values
+ * @rxq: queue to bump
+ * @val: new head index
+ */
+void idpf_rx_buf_hw_update(struct idpf_queue *rxq, u32 val)
+{
+	rxq->next_to_use = val;
+
+	if (unlikely(!rxq->tail))
+		return;
+
+	/* writel has an implicit memory barrier */
+	writel(val, rxq->tail);
+}
+
+/**
+ * idpf_alloc_page - allocate page to back RX buffer
+ * @rxbufq: pointer to queue to struct; equivalent to rxq when operating
+ * in singleq mode
+ * @pinfo: pointer to page metadata struct
+ */
+static int idpf_alloc_page(struct idpf_queue *rxbufq,
+			   struct idpf_page_info *pinfo)
+{
+	pinfo->page = alloc_page(GFP_ATOMIC | __GFP_NOWARN);
+	if (unlikely(!pinfo->page))
+		return -ENOMEM;
+
+	pinfo->dma = dma_map_page_attrs(rxbufq->dev, pinfo->page,
+					0, PAGE_SIZE, DMA_FROM_DEVICE,
+					IDPF_RX_DMA_ATTR);
+	/* if mapping failed free memory back to system since
+	 * there isn't much point in holding memory we can't use
+	 */
+	if (dma_mapping_error(rxbufq->dev, pinfo->dma)) {
+		__free_pages(pinfo->page, 0);
+
+		return -ENOMEM;
+	}
+
+	pinfo->page_offset = 0;
+
+	/* initialize pagecnt_bias to claim we fully own page */
+	page_ref_add(pinfo->page, USHRT_MAX - 1);
+	pinfo->pagecnt_bias = USHRT_MAX;
+
+	return 0;
+}
+
+/**
+ * idpf_init_rx_buf_hw_alloc - allocate initial RX buffer pages
+ * @rxbufq: ring to use; equivalent to rxq when operating in singleq mode
+ * @buf: rx_buffer struct to modify
+ *
+ * Returns true if the page was successfully allocated or
+ * reused.
+ */
+bool idpf_init_rx_buf_hw_alloc(struct idpf_queue *rxbufq, struct idpf_rx_buf *buf)
+{
+	if (idpf_alloc_page(rxbufq, &buf->page_info[0]))
+		return false;
+
+	if (PAGE_SIZE < 8192)  {
+		if (rxbufq->rx_buf_size > IDPF_RX_BUF_2048) {
+			/* For 4K buffers, we can reuse the page if there are
+			 * no other owners, i.e. reuse_bias = 0. Since the
+			 * memory is initialized to 0, both page_info's
+			 * reuse_bias is already set appropriately.
+			 */
+			if (idpf_alloc_page(rxbufq, &buf->page_info[1]))
+				return false;
+		} else {
+			/* For 2K buffers, we can reuse the page if we are the
+			 * only owner, i.e. reuse_bias = 1.
+			 */
+			buf->page_info[0].reuse_bias = 1;
+		}
+	}
+
+	buf->page_indx = 0;
+	buf->buf_size = rxbufq->rx_buf_size;
+
+	return true;
+}
+
+/**
+ * idpf_rx_hdr_buf_alloc_all - Allocate memory for header buffers
+ * @rxq: ring to use
+ *
+ * Returns 0 on success, negative on failure.
+ */
+static int idpf_rx_hdr_buf_alloc_all(struct idpf_queue *rxq)
+{
+	struct idpf_page_info *pinfo;
+	int nr_pages, offset;
+	int i, j = 0;
+
+	rxq->rx_buf.hdr_buf = kcalloc(rxq->desc_count,
+				      sizeof(struct idpf_dma_mem *),
+				      GFP_KERNEL);
+	if (!rxq->rx_buf.hdr_buf)
+		return -ENOMEM;
+
+	for (i = 0; i < rxq->desc_count; i++) {
+		rxq->rx_buf.hdr_buf[i] = kcalloc(1,
+						 sizeof(struct idpf_dma_mem),
+						 GFP_KERNEL);
+		if (!rxq->rx_buf.hdr_buf[i])
+			goto unroll_buf_alloc;
+	}
+
+	/* Determine the number of pages necessary to back the total number of
+	 * header buffers.
+	 */
+	nr_pages = (rxq->desc_count * rxq->rx_hbuf_size) / PAGE_SIZE;
+	rxq->hbuf_pages.pages = kcalloc(nr_pages,
+					sizeof(struct idpf_page_info),
+					GFP_KERNEL);
+	if (!rxq->hbuf_pages.pages)
+		goto unroll_buf_alloc;
+
+	rxq->hbuf_pages.nr_pages = nr_pages;
+	for (i = 0; i < nr_pages; i++) {
+		if (idpf_alloc_page(rxq, &rxq->hbuf_pages.pages[i]))
+			goto unroll_buf_alloc;
+	}
+
+	pinfo = &rxq->hbuf_pages.pages[0];
+	for (i = 0, offset = 0; i < rxq->desc_count;
+	     i++, offset += rxq->rx_hbuf_size) {
+		struct idpf_dma_mem *hbuf = rxq->rx_buf.hdr_buf[i];
+
+		/* Move to next page */
+		if (offset >= PAGE_SIZE) {
+			offset = 0;
+			pinfo = &rxq->hbuf_pages.pages[++j];
+		}
+
+		hbuf->va = page_address(pinfo->page) + offset;
+		hbuf->pa = pinfo->dma + offset;
+		hbuf->size = rxq->rx_hbuf_size;
+	}
+
+	return 0;
+
+unroll_buf_alloc:
+	idpf_rx_hdr_buf_rel_all(rxq);
+
+	return -ENOMEM;
+}
+
+/**
+ * idpf_rx_buf_hw_alloc_all - Allocate receive buffers
+ * @rxbufq: queue for which the hw buffers are allocated; equivalent to rxq
+ * when operating in singleq mode
+ * @alloc_count: number of buffers to allocate
+ *
+ * Returns false if all allocations were successful, true if any fail
+ */
+static bool idpf_rx_buf_hw_alloc_all(struct idpf_queue *rxbufq, u16 alloc_count)
+{
+	u16 nta = rxbufq->next_to_alloc;
+	struct idpf_rx_buf *buf;
+
+	if (!alloc_count)
+		return false;
+
+	buf = &rxbufq->rx_buf.buf[nta];
+
+	do {
+		if (!idpf_init_rx_buf_hw_alloc(rxbufq, buf))
+			break;
+
+		buf++;
+		nta++;
+		if (unlikely(nta == rxbufq->desc_count)) {
+			buf = rxbufq->rx_buf.buf;
+			nta = 0;
+		}
+
+		alloc_count--;
+	} while (alloc_count);
+
+	return !!alloc_count;
+}
+
+/**
+ * idpf_rx_post_buf_desc - Post buffer to bufq descriptor ring
+ * @bufq: buffer queue to post to
+ * @buf_id: buffer id to post
+ */
+static void idpf_rx_post_buf_desc(struct idpf_queue *bufq, u16 buf_id)
+{
+	struct virtchnl2_splitq_rx_buf_desc *splitq_rx_desc = NULL;
+	u16 nta = bufq->next_to_alloc;
+	struct idpf_page_info *pinfo;
+	struct idpf_rx_buf *buf;
+
+	splitq_rx_desc = IDPF_SPLITQ_RX_BUF_DESC(bufq, nta);
+	buf = &bufq->rx_buf.buf[buf_id];
+	pinfo = &buf->page_info[buf->page_indx];
+
+	if (bufq->rx_hsplit_en) {
+		struct idpf_dma_mem *hdr_buf;
+
+		hdr_buf = bufq->rx_buf.hdr_buf[buf_id];
+		splitq_rx_desc->hdr_addr =
+			cpu_to_le64(hdr_buf->pa);
+	}
+
+	dma_sync_single_range_for_device(bufq->dev, pinfo->dma,
+					 pinfo->page_offset,
+					 bufq->rx_buf_size,
+					 DMA_FROM_DEVICE);
+	splitq_rx_desc->pkt_addr = cpu_to_le64(pinfo->dma +
+					       pinfo->page_offset);
+	splitq_rx_desc->qword0.buf_id = cpu_to_le16(buf_id);
+
+	nta++;
+	if (unlikely(nta == bufq->desc_count))
+		nta = 0;
+	bufq->next_to_alloc = nta;
+}
+
+/**
+ * idpf_rx_post_init_bufs - Post initial buffers to bufq
+ * @bufq: buffer queue to post working set to
+ * @working_set: number of buffers to put in working set
+ */
+static void idpf_rx_post_init_bufs(struct idpf_queue *bufq, u16 working_set)
+{
+	int i;
+
+	for (i = 0; i < working_set; i++)
+		idpf_rx_post_buf_desc(bufq, i);
+
+	idpf_rx_buf_hw_update(bufq, bufq->next_to_alloc & ~(bufq->rx_buf_stride - 1));
+}
+
+/**
+ * idpf_rx_buf_alloc_all - Allocate memory for all buffer resources
+ * @rxbufq: queue for which the buffers are allocated; equivalent to
+ * rxq when operating in singleq mode
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int idpf_rx_buf_alloc_all(struct idpf_queue *rxbufq)
+{
+	int err = 0;
+
+	/* Allocate book keeping buffers */
+	rxbufq->rx_buf.buf = kcalloc(rxbufq->desc_count,
+				     sizeof(struct idpf_rx_buf), GFP_KERNEL);
+	if (!rxbufq->rx_buf.buf) {
+		err = -ENOMEM;
+		goto rx_buf_alloc_all_out;
+	}
+
+	if (rxbufq->rx_hsplit_en) {
+		err = idpf_rx_hdr_buf_alloc_all(rxbufq);
+		if (err)
+			goto rx_buf_alloc_all_out;
+	}
+
+	/* Allocate buffers to be given to HW.	 */
+	if (idpf_is_queue_model_split(rxbufq->vport->rxq_model)) {
+		if (idpf_rx_buf_hw_alloc_all(rxbufq, rxbufq->desc_count - 1))
+			err = -ENOMEM;
+	} else {
+		if (idpf_rx_singleq_buf_hw_alloc_all(rxbufq, rxbufq->desc_count - 1))
+			err = -ENOMEM;
+	}
+
+rx_buf_alloc_all_out:
+	if (err)
+		idpf_rx_buf_rel_all(rxbufq);
+
+	return err;
+}
+
+/**
+ * idpf_rx_desc_alloc - Allocate queue Rx resources
+ * @rxq: Rx queue for which the resources are setup
+ * @bufq: buffer or completion queue
+ * @q_model: single or split queue model
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int idpf_rx_desc_alloc(struct idpf_queue *rxq, bool bufq, s32 q_model)
+{
+	struct device *dev = rxq->dev;
+	int err;
+
+	if (bufq)
+		rxq->size = rxq->desc_count *
+			sizeof(struct virtchnl2_splitq_rx_buf_desc);
+	else
+		rxq->size = rxq->desc_count *
+			sizeof(union virtchnl2_rx_desc);
+
+	/* Allocate descriptors and also round up to nearest 4K */
+	rxq->size = ALIGN(rxq->size, 4096);
+	rxq->desc_ring = dmam_alloc_coherent(dev, rxq->size,
+					     &rxq->dma, GFP_KERNEL);
+	if (!rxq->desc_ring) {
+		dev_err(dev, "Unable to allocate memory for the Rx descriptor ring, size=%d\n",
+			rxq->size);
+		return -ENOMEM;
+	}
+
+	rxq->next_to_alloc = 0;
+	rxq->next_to_clean = 0;
+	rxq->next_to_use = 0;
+	set_bit(__IDPF_Q_GEN_CHK, rxq->flags);
+
+	if (!bufq && idpf_is_queue_model_split(q_model))
+		return 0;
+
+	/* Allocate buffers for a rx queue if the q_model is single OR if it
+	 * is a buffer queue in split queue model
+	 */
+	err = idpf_rx_buf_alloc_all(rxq);
+	if (err) {
+		idpf_rx_desc_rel(rxq, bufq, q_model);
+
+		return err;
+	}
+
+	return 0;
+}
+
+/**
+ * idpf_rx_desc_alloc_all - allocate all RX queues resources
+ * @vport: virtual port structure
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int idpf_rx_desc_alloc_all(struct idpf_vport *vport)
+{
+	struct device *dev = &vport->adapter->pdev->dev;
+	struct idpf_rxq_group *rx_qgrp;
+	int i, j, num_rxq, err;
+	struct idpf_queue *q;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		rx_qgrp = &vport->rxq_grps[i];
+		if (idpf_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				q = &rx_qgrp->splitq.rxq_sets[j]->rxq;
+			else
+				q = rx_qgrp->singleq.rxqs[j];
+			err = idpf_rx_desc_alloc(q, false, vport->rxq_model);
+			if (err) {
+				dev_err(dev, "Memory allocation for Rx Queue %u failed\n",
+					i);
+				goto err_out;
+			}
+		}
+
+		if (!idpf_is_queue_model_split(vport->rxq_model))
+			continue;
+
+		for (j = 0; j < vport->num_bufqs_per_qgrp; j++) {
+			q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+			err = idpf_rx_desc_alloc(q, true, vport->rxq_model);
+			if (err) {
+				dev_err(dev, "Memory allocation for Rx Buffer Queue %u failed\n",
+					i);
+				goto err_out;
+			}
+
+			idpf_rx_post_init_bufs(q, IDPF_RX_BUFQ_WORKING_SET(q));
+		}
+	}
+
+	return 0;
+
+err_out:
+	idpf_rx_desc_rel_all(vport);
+
+	return err;
+}
+
 /**
  * idpf_txq_group_rel - Release all resources for txq groups
  * @vport: vport to release txq groups on
@@ -287,6 +834,76 @@ static void idpf_txq_group_rel(struct idpf_vport *vport)
 	vport->txq_grps = NULL;
 }
 
+/**
+ * idpf_rxq_sw_queue_rel - Release software queue resources
+ * @rx_qgrp: rx queue group with software queues
+ */
+static void idpf_rxq_sw_queue_rel(struct idpf_rxq_group *rx_qgrp)
+{
+	int i, j;
+
+	if (!rx_qgrp->splitq.bufq_sets)
+		return;
+
+	for (i = 0; i < rx_qgrp->vport->num_bufqs_per_qgrp; i++) {
+		struct idpf_bufq_set *bufq_set = &rx_qgrp->splitq.bufq_sets[i];
+
+		for (j = 0; j < bufq_set->num_refillqs; j++) {
+			kfree(bufq_set->refillqs[j].ring);
+			bufq_set->refillqs[j].ring = NULL;
+		}
+		kfree(bufq_set->refillqs);
+		bufq_set->refillqs = NULL;
+	}
+}
+
+/**
+ * idpf_rxq_group_rel - Release all resources for rxq groups
+ * @vport: vport to release rxq groups on
+ */
+static void idpf_rxq_group_rel(struct idpf_vport *vport)
+{
+	int i;
+
+	if (!vport->rxq_grps)
+		return;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int j, num_rxq;
+
+		if (idpf_is_queue_model_split(vport->rxq_model)) {
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+			for (j = 0; j < num_rxq; j++) {
+				kfree(rx_qgrp->splitq.rxq_sets[j]);
+				rx_qgrp->splitq.rxq_sets[j] = NULL;
+			}
+
+			idpf_rxq_sw_queue_rel(rx_qgrp);
+			kfree(rx_qgrp->splitq.bufq_sets);
+			rx_qgrp->splitq.bufq_sets = NULL;
+		} else {
+			num_rxq = rx_qgrp->singleq.num_rxq;
+			for (j = 0; j < num_rxq; j++) {
+				kfree(rx_qgrp->singleq.rxqs[j]);
+				rx_qgrp->singleq.rxqs[j] = NULL;
+			}
+		}
+	}
+	kfree(vport->rxq_grps);
+	vport->rxq_grps = NULL;
+}
+
+/**
+ * idpf_vport_queue_grp_rel_all - Release all queue groups
+ * @vport: vport to release queue groups for
+ */
+static void idpf_vport_queue_grp_rel_all(struct idpf_vport *vport)
+{
+	idpf_txq_group_rel(vport);
+	idpf_rxq_group_rel(vport);
+}
+
 /**
  * idpf_vport_queues_rel - Free memory for all queues
  * @vport: virtual port
@@ -296,7 +913,8 @@ static void idpf_txq_group_rel(struct idpf_vport *vport)
 void idpf_vport_queues_rel(struct idpf_vport *vport)
 {
 	idpf_tx_desc_rel_all(vport);
-	idpf_txq_group_rel(vport);
+	idpf_rx_desc_rel_all(vport);
+	idpf_vport_queue_grp_rel_all(vport);
 
 	kfree(vport->txqs);
 	vport->txqs = NULL;
@@ -525,6 +1143,29 @@ static void idpf_vport_calc_numq_per_grp(struct idpf_vport *vport,
 		*num_txq = IDPF_DFLT_SPLITQ_TXQ_PER_GROUP;
 	else
 		*num_txq = vport->num_txq;
+
+	if (idpf_is_queue_model_split(vport->rxq_model))
+		*num_rxq = IDPF_DFLT_SPLITQ_RXQ_PER_GROUP;
+	else
+		*num_rxq = vport->num_rxq;
+}
+
+/**
+ * idpf_rxq_set_descids - set the descids supported by this queue
+ * @vport: virtual port data structure
+ * @q: rx queue for which descids are set
+ *
+ */
+static void idpf_rxq_set_descids(struct idpf_vport *vport, struct idpf_queue *q)
+{
+	if (vport->rxq_model == VIRTCHNL2_QUEUE_MODEL_SPLIT) {
+		q->rxdids = VIRTCHNL2_RXDID_2_FLEX_SPLITQ_M;
+	} else {
+		if (vport->base_rxd)
+			q->rxdids = VIRTCHNL2_RXDID_1_32B_BASE_M;
+		else
+			q->rxdids = VIRTCHNL2_RXDID_2_FLEX_SQ_NIC_M;
+	}
 }
 
 /**
@@ -609,6 +1250,155 @@ static int idpf_txq_group_alloc(struct idpf_vport *vport, int num_txq)
 	return err;
 }
 
+/**
+ * idpf_rxq_group_alloc - Allocate all rxq group resources
+ * @vport: vport to allocate rxq groups for
+ * @num_rxq: number of rxqs to allocate for each group
+ *
+ * Returns 0 on success, negative on failure
+ */
+static int idpf_rxq_group_alloc(struct idpf_vport *vport, int num_rxq)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_queue *q;
+	int i, k, err = 0;
+
+	vport->rxq_grps = kcalloc(vport->num_rxq_grp,
+				  sizeof(struct idpf_rxq_group), GFP_KERNEL);
+	if (!vport->rxq_grps)
+		return -ENOMEM;
+
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int j;
+
+		rx_qgrp->vport = vport;
+		if (!idpf_is_queue_model_split(vport->rxq_model)) {
+			rx_qgrp->singleq.num_rxq = num_rxq;
+			for (j = 0; j < num_rxq; j++) {
+				rx_qgrp->singleq.rxqs[j] =
+						kzalloc(sizeof(*rx_qgrp->singleq.rxqs[j]),
+							GFP_KERNEL);
+				if (!rx_qgrp->singleq.rxqs[j]) {
+					err = -ENOMEM;
+					goto err_alloc;
+				}
+			}
+			goto skip_splitq_rx_init;
+		}
+		rx_qgrp->splitq.num_rxq_sets = num_rxq;
+
+		for (j = 0; j < num_rxq; j++) {
+			rx_qgrp->splitq.rxq_sets[j] =
+				kzalloc(sizeof(struct idpf_rxq_set),
+					GFP_KERNEL);
+			if (!rx_qgrp->splitq.rxq_sets[j]) {
+				err = -ENOMEM;
+				goto err_alloc;
+			}
+		}
+
+		rx_qgrp->splitq.bufq_sets = kcalloc(vport->num_bufqs_per_qgrp,
+						    sizeof(struct idpf_bufq_set),
+						    GFP_KERNEL);
+		if (!rx_qgrp->splitq.bufq_sets) {
+			err = -ENOMEM;
+			goto err_alloc;
+		}
+
+		for (j = 0; j < vport->num_bufqs_per_qgrp; j++) {
+			struct idpf_bufq_set *bufq_set =
+				&rx_qgrp->splitq.bufq_sets[j];
+			int swq_size = sizeof(struct idpf_sw_queue);
+
+			q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+			q->dev = &adapter->pdev->dev;
+			q->desc_count = vport->bufq_desc_count[j];
+			q->vport = vport;
+			q->rxq_grp = rx_qgrp;
+			q->idx = j;
+			q->rx_buf_size = vport->bufq_size[j];
+			q->rx_buffer_low_watermark = IDPF_LOW_WATERMARK;
+			q->rx_buf_stride = IDPF_RX_BUF_STRIDE;
+			if (idpf_is_cap_ena_all(adapter, IDPF_HSPLIT_CAPS,
+						IDPF_CAP_HSPLIT) &&
+			    idpf_is_queue_model_split(vport->rxq_model)) {
+				q->rx_hsplit_en = true;
+				q->rx_hbuf_size = IDPF_HDR_BUF_SIZE;
+			}
+
+			bufq_set->num_refillqs = num_rxq;
+			bufq_set->refillqs = kcalloc(num_rxq, swq_size,
+						     GFP_KERNEL);
+			if (!bufq_set->refillqs) {
+				err = -ENOMEM;
+				goto err_alloc;
+			}
+			for (k = 0; k < bufq_set->num_refillqs; k++) {
+				struct idpf_sw_queue *refillq =
+					&bufq_set->refillqs[k];
+
+				refillq->dev = &vport->adapter->pdev->dev;
+				refillq->buf_size = q->rx_buf_size;
+				refillq->desc_count =
+					vport->bufq_desc_count[j];
+				set_bit(__IDPF_Q_GEN_CHK, refillq->flags);
+				set_bit(__IDPF_RFLQ_GEN_CHK, refillq->flags);
+				refillq->ring = kcalloc(refillq->desc_count,
+							sizeof(u16),
+							GFP_KERNEL);
+				if (!refillq->ring) {
+					err = -ENOMEM;
+					goto err_alloc;
+				}
+			}
+		}
+
+skip_splitq_rx_init:
+		for (j = 0; j < num_rxq; j++) {
+			if (!idpf_is_queue_model_split(vport->rxq_model)) {
+				q = rx_qgrp->singleq.rxqs[j];
+				goto setup_rxq;
+			}
+			q = &rx_qgrp->splitq.rxq_sets[j]->rxq;
+			rx_qgrp->splitq.rxq_sets[j]->refillq0 =
+			      &rx_qgrp->splitq.bufq_sets[0].refillqs[j];
+			if (vport->num_bufqs_per_qgrp > IDPF_SINGLE_BUFQ_PER_RXQ_GRP)
+				rx_qgrp->splitq.rxq_sets[j]->refillq1 =
+				      &rx_qgrp->splitq.bufq_sets[1].refillqs[j];
+
+			if (idpf_is_cap_ena_all(adapter, IDPF_HSPLIT_CAPS,
+						IDPF_CAP_HSPLIT) &&
+			    idpf_is_queue_model_split(vport->rxq_model)) {
+				q->rx_hsplit_en = true;
+				q->rx_hbuf_size = IDPF_HDR_BUF_SIZE;
+			}
+
+setup_rxq:
+			q->dev = &adapter->pdev->dev;
+			q->desc_count = vport->rxq_desc_count;
+			q->vport = vport;
+			q->rxq_grp = rx_qgrp;
+			q->idx = (i * num_rxq) + j;
+			/* In splitq mode, RXQ buffer size should be
+			 * set to that of the first buffer queue
+			 * associated with this RXQ
+			 */
+			q->rx_buf_size = vport->bufq_size[0];
+			q->rx_buffer_low_watermark = IDPF_LOW_WATERMARK;
+			q->rx_max_pkt_size = vport->netdev->mtu +
+							IDPF_PACKET_HDR_PAD;
+			idpf_rxq_set_descids(vport, q);
+		}
+	}
+
+err_alloc:
+	if (err)
+		idpf_rxq_group_rel(vport);
+
+	return err;
+}
+
 /**
  * idpf_vport_queue_grp_alloc_all - Allocate all queue groups/resources
  * @vport: vport with qgrps to allocate
@@ -626,10 +1416,14 @@ static int idpf_vport_queue_grp_alloc_all(struct idpf_vport *vport)
 	if (err)
 		goto err_out;
 
+	err = idpf_rxq_group_alloc(vport, num_rxq);
+	if (err)
+		goto err_out;
+
 	return 0;
 
 err_out:
-	idpf_txq_group_rel(vport);
+	idpf_vport_queue_grp_rel_all(vport);
 
 	return err;
 }
@@ -653,6 +1447,10 @@ int idpf_vport_queues_alloc(struct idpf_vport *vport)
 	if (err)
 		goto err_out;
 
+	err = idpf_rx_desc_alloc_all(vport);
+	if (err)
+		goto err_out;
+
 	err = idpf_vport_init_fast_path_txqs(vport);
 	if (err)
 		goto err_out;
@@ -681,8 +1479,12 @@ void idpf_vport_intr_rel(struct idpf_vport *vport)
 	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
 		struct idpf_q_vector *q_vector = &vport->q_vectors[v_idx];
 
+		kfree(q_vector->bufq);
+		q_vector->bufq = NULL;
 		kfree(q_vector->tx);
 		q_vector->tx = NULL;
+		kfree(q_vector->rx);
+		q_vector->rx = NULL;
 	}
 
 	kfree(vport->q_vectors);
@@ -698,8 +1500,8 @@ void idpf_vport_intr_rel(struct idpf_vport *vport)
  */
 int idpf_vport_intr_alloc(struct idpf_vport *vport)
 {
+	int txqs_per_vector, rxqs_per_vector, bufqs_per_vector;
 	struct idpf_q_vector *q_vector;
-	int txqs_per_vector;
 	int v_idx, err;
 
 	vport->q_vectors = kcalloc(vport->num_q_vectors,
@@ -708,6 +1510,9 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport)
 		return -ENOMEM;
 
 	txqs_per_vector = DIV_ROUND_UP(vport->num_txq, vport->num_q_vectors);
+	rxqs_per_vector = DIV_ROUND_UP(vport->num_rxq, vport->num_q_vectors);
+	bufqs_per_vector = vport->num_bufqs_per_qgrp *
+			   DIV_ROUND_UP(vport->num_rxq_grp, vport->num_q_vectors);
 
 	for (v_idx = 0; v_idx < vport->num_q_vectors; v_idx++) {
 		q_vector = &vport->q_vectors[v_idx];
@@ -717,6 +1522,10 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport)
 		q_vector->tx_intr_mode = IDPF_ITR_DYNAMIC;
 		q_vector->tx_itr_idx = VIRTCHNL2_ITR_IDX_1;
 
+		q_vector->rx_itr_value = IDPF_ITR_RX_DEF;
+		q_vector->rx_intr_mode = IDPF_ITR_DYNAMIC;
+		q_vector->rx_itr_idx = VIRTCHNL2_ITR_IDX_0;
+
 		q_vector->tx = kcalloc(txqs_per_vector,
 				       sizeof(struct idpf_queue *),
 				       GFP_KERNEL);
@@ -724,6 +1533,25 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport)
 			err = -ENOMEM;
 			goto error;
 		}
+
+		q_vector->rx = kcalloc(rxqs_per_vector,
+				       sizeof(struct idpf_queue *),
+				       GFP_KERNEL);
+		if (!q_vector->rx) {
+			err = -ENOMEM;
+			goto error;
+		}
+
+		if (!idpf_is_queue_model_split(vport->rxq_model))
+			continue;
+
+		q_vector->bufq = kcalloc(bufqs_per_vector,
+					 sizeof(struct idpf_queue *),
+					 GFP_KERNEL);
+		if (!q_vector->bufq) {
+			err = -ENOMEM;
+			goto error;
+		}
 	}
 
 	return 0;
@@ -733,3 +1561,89 @@ int idpf_vport_intr_alloc(struct idpf_vport *vport)
 
 	return err;
 }
+
+/**
+ * idpf_config_rss - Send virtchnl messages to configure RSS
+ * @vport: virtual port
+ *
+ * Return 0 on success, negative on failure
+ */
+int idpf_config_rss(struct idpf_vport *vport)
+{
+	int err;
+
+	err = idpf_send_get_set_rss_key_msg(vport, false);
+	if (err)
+		return err;
+
+	return idpf_send_get_set_rss_lut_msg(vport, false);
+}
+
+/**
+ * idpf_fill_dflt_rss_lut - Fill the indirection table with the default values
+ * @vport: virtual port structure
+ */
+static void idpf_fill_dflt_rss_lut(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	u16 num_active_rxq = vport->num_rxq;
+	struct idpf_rss_data *rss_data;
+	int i;
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+
+	for (i = 0; i < rss_data->rss_lut_size; i++) {
+		rss_data->rss_lut[i] = i % num_active_rxq;
+		rss_data->cached_lut[i] = rss_data->rss_lut[i];
+	}
+}
+
+/**
+ * idpf_init_rss - Allocate and initialize RSS resources
+ * @vport: virtual port
+ *
+ * Return 0 on success, negative on failure
+ */
+int idpf_init_rss(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_rss_data *rss_data;
+	u32 lut_size;
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+
+	lut_size = rss_data->rss_lut_size * sizeof(u32);
+	rss_data->rss_lut = kzalloc(lut_size, GFP_KERNEL);
+	if (!rss_data->rss_lut)
+		return -ENOMEM;
+
+	rss_data->cached_lut = kzalloc(lut_size, GFP_KERNEL);
+	if (!rss_data->cached_lut) {
+		kfree(rss_data->rss_lut);
+		rss_data->rss_lut = NULL;
+
+		return -ENOMEM;
+	}
+
+	/* Fill the default RSS lut values */
+	idpf_fill_dflt_rss_lut(vport);
+
+	return idpf_config_rss(vport);
+}
+
+/**
+ * idpf_deinit_rss - Release RSS resources
+ * @vport: virtual port
+ *
+ */
+void idpf_deinit_rss(struct idpf_vport *vport)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_rss_data *rss_data;
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+	kfree(rss_data->cached_lut);
+	rss_data->cached_lut = NULL;
+	kfree(rss_data->rss_lut);
+	rss_data->rss_lut = NULL;
+}
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 7bf5f674c477..404fbff76471 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -21,7 +21,9 @@
 #define IDPF_DFLT_SINGLEQ_RXQ_PER_GROUP		4
 
 #define IDPF_COMPLQ_PER_GROUP			1
+#define IDPF_SINGLE_BUFQ_PER_RXQ_GRP		1
 #define IDPF_MAX_BUFQS_PER_RXQ_GRP		2
+#define IDPF_BUFQ2_ENA				1
 
 #define IDPF_DFLT_SPLITQ_TXQ_PER_GROUP		1
 #define IDPF_DFLT_SPLITQ_RXQ_PER_GROUP		1
@@ -52,11 +54,21 @@
  */
 #define IDPF_RX_BUFQ_DESC_COUNT(RXD, NUM_BUFQ)	((RXD) / (NUM_BUFQ))
 
+#define IDPF_RX_BUFQ_WORKING_SET(R)		((R)->desc_count - 1)
+
 #define IDPF_RX_BUF_2048			2048
 #define IDPF_RX_BUF_4096			4096
+#define IDPF_RX_BUF_STRIDE			32
+#define IDPF_LOW_WATERMARK			64
+#define IDPF_HDR_BUF_SIZE			256
 #define IDPF_PACKET_HDR_PAD	\
 	(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN * 2)
 
+#define IDPF_SINGLEQ_RX_BUF_DESC(R, i)	\
+	(&(((struct virtchnl2_singleq_rx_buf_desc *)((R)->desc_ring))[i]))
+#define IDPF_SPLITQ_RX_BUF_DESC(R, i)	\
+	(&(((struct virtchnl2_splitq_rx_buf_desc *)((R)->desc_ring))[i]))
+
 #define IDPF_TX_SPLITQ_COMPL_TAG_WIDTH	16
 
 #define IDPF_TX_MIN_LEN			17
@@ -95,6 +107,29 @@ struct idpf_buf_lifo {
 	struct idpf_tx_stash **bufs;
 };
 
+#define IDPF_RX_DMA_ATTR \
+	(DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+struct idpf_page_info {
+	dma_addr_t dma;
+	struct page *page;
+	unsigned int page_offset;
+	u16 pagecnt_bias;
+	u8 reuse_bias;
+};
+
+struct idpf_rx_hdr_buf_pages {
+	u32 nr_pages;
+	struct idpf_page_info *pages;
+};
+
+struct idpf_rx_buf {
+#define IDPF_RX_BUF_MAX_PAGES 2
+	struct idpf_page_info page_info[IDPF_RX_BUF_MAX_PAGES];
+	u8 page_indx;
+	u16 buf_size;
+};
+
 #define IDPF_GET_PTYPE_SIZE(p) struct_size((p), proto_id, (p)->proto_id_count)
 
 #define IDPF_TUN_IP_GRE (\
@@ -209,6 +244,10 @@ enum idpf_queue_flags_t {
 	 * writeback. It also flips on every ring wrap.
 	 */
 	__IDPF_Q_GEN_CHK,
+	/* Refill queues are SW only, so Q_GEN acts as the HW bit and RFLGQ_GEN
+	 * is the SW bit.
+	 */
+	__IDPF_RFLQ_GEN_CHK,
 	__IDPF_Q_FLOW_SCH_EN,
 	__IDPF_Q_MISS_TAG_EN,
 
@@ -233,31 +272,53 @@ struct idpf_q_vector {
 	bool tx_intr_mode;
 	u32 tx_itr_idx;
 
+	struct idpf_queue **rx;
+	u16 rx_itr_value;
+	bool rx_intr_mode;
+	u32 rx_itr_idx;
+
+	struct idpf_queue **bufq;
+
 	char name[IDPF_INT_NAME_STR_LEN];
 };
 
 #define IDPF_ITR_DYNAMIC	1
 #define IDPF_ITR_20K		0x0032
 #define IDPF_ITR_TX_DEF		IDPF_ITR_20K
+#define IDPF_ITR_RX_DEF		IDPF_ITR_20K
 
 /* queue associated with a vport */
 struct idpf_queue {
 	struct device *dev;		/* Used for DMA mapping */
 	struct idpf_vport *vport;	/* Backreference to associated vport */
-	struct idpf_txq_group *txq_grp;
+	union {
+		struct idpf_txq_group *txq_grp;
+		struct idpf_rxq_group *rxq_grp;
+	};
 	/* bufq: Used as group id, either 0 or 1, on clean bufq uses this
 	 *       index to determine which group of refill queues to clean.
 	 *       Bufqs are use in splitq only.
 	 * txq: Index to map between txq group and hot path Tx ptrs stored in
-	 *      vport. Used in both singleq/splitq
+	 *      vport.  Used in both singleq/splitq
+	 * rxq: Index to total rxq across groups, used for skb reporting
 	 */
 	u16 idx;
 	/* Used for both queue models single and split. In splitq model relevant
-	 * only to txq
+	 * only to txq and rxq
 	 */
 	void __iomem *tail;
-	/* Used in both singleq and splitq */
-	struct idpf_tx_buf *tx_buf;
+	/* Used in both singleq and splitq. In singleq, txq uses tx_buf and
+	 * rxq uses rx_buf. In splitq, txq uses tx_buf, rxq uses skb, and
+	 * bufq uses rx_buf.
+	 */
+	union {
+		struct idpf_tx_buf *tx_buf;
+		struct {
+			struct idpf_rx_buf *buf;
+			struct idpf_dma_mem **hdr_buf;
+		} rx_buf;
+		struct sk_buff *skb;
+	};
 	u16 q_type;
 	/* Queue id(Tx/Tx compl/Rx/Bufq) */
 	u32 q_id;
@@ -272,6 +333,13 @@ struct idpf_queue {
 	/* Generation bit check stored, as HW flips the bit at Queue end */
 	DECLARE_BITMAP(flags, __IDPF_Q_FLAGS_NBITS);
 
+	bool rx_hsplit_en;
+	u16 rx_hbuf_size;	/* Header buffer size */
+	u16 rx_buf_size;
+	u16 rx_max_pkt_size;
+	u16 rx_buf_stride;
+	u8 rx_buffer_low_watermark;
+	u64 rxdids;
 	/* Used for both queue models single and split. In splitq model relevant
 	 * only to Tx compl Q and Rx compl Q
 	 */
@@ -322,8 +390,71 @@ struct idpf_queue {
 	u16 compl_tag_gen_max;
 
 	DECLARE_HASHTABLE(sched_buf_hash, 12);
+
+	struct idpf_rx_hdr_buf_pages hbuf_pages;
 } ____cacheline_internodealigned_in_smp;
 
+/* Software queues are used in splitq mode to manage buffers between rxq
+ * producer and the bufq consumer.  These are required in order to maintain a
+ * lockless buffer management system and are strictly software only constructs.
+ */
+struct idpf_sw_queue {
+	DECLARE_BITMAP(flags, __IDPF_Q_FLAGS_NBITS)
+		____cacheline_aligned_in_smp;
+	u16 *ring ____cacheline_aligned_in_smp;
+	u16 desc_count;
+	u16 buf_size;
+	struct device *dev;
+} ____cacheline_internodealigned_in_smp;
+
+/* Splitq only.  idpf_rxq_set associates an rxq with at an array of refillqs.
+ * Each rxq needs a refillq to return used buffers back to the respective bufq.
+ * Bufqs then clean these refillqs for buffers to give to hardware.
+ */
+struct idpf_rxq_set {
+	struct idpf_queue rxq;
+	/* refillqs assoc with bufqX mapped to this rxq */
+	struct idpf_sw_queue *refillq0;
+	struct idpf_sw_queue *refillq1;
+};
+
+/* Splitq only.  idpf_bufq_set associates a bufq to an array of refillqs.
+ * In this bufq_set, there will be one refillq for each rxq in this rxq_group.
+ * Used buffers received by rxqs will be put on refillqs which bufqs will
+ * clean to return new buffers back to hardware.
+ *
+ * Buffers needed by some number of rxqs associated in this rxq_group are
+ * managed by at most two bufqs (depending on performance configuration).
+ */
+struct idpf_bufq_set {
+	struct idpf_queue bufq;
+	/* This is always equal to num_rxq_sets in idpf_rxq_group */
+	int num_refillqs;
+	struct idpf_sw_queue *refillqs;
+};
+
+/* In singleq mode, an rxq_group is simply an array of rxqs.  In splitq, a
+ * rxq_group contains all the rxqs, bufqs and refillqs needed to
+ * manage buffers in splitq mode.
+ */
+struct idpf_rxq_group {
+	struct idpf_vport *vport; /* back pointer */
+
+	union {
+		struct {
+			int num_rxq;
+			/* store queue pointers */
+			struct idpf_queue *rxqs[IDPF_LARGE_MAX_Q];
+		} singleq;
+		struct {
+			int num_rxq_sets;
+			/* store queue pointers */
+			struct idpf_rxq_set *rxq_sets[IDPF_LARGE_MAX_Q];
+			struct idpf_bufq_set *bufq_sets;
+		} splitq;
+	};
+};
+
 /* Between singleq and splitq, a txq_group is largely the same except for the
  * complq. In splitq a single complq is responsible for handling completions
  * for some number of txqs associated in this txq_group.
@@ -355,5 +486,12 @@ int idpf_vport_queues_alloc(struct idpf_vport *vport);
 void idpf_vport_queues_rel(struct idpf_vport *vport);
 void idpf_vport_intr_rel(struct idpf_vport *vport);
 int idpf_vport_intr_alloc(struct idpf_vport *vport);
+int idpf_config_rss(struct idpf_vport *vport);
+int idpf_init_rss(struct idpf_vport *vport);
+void idpf_deinit_rss(struct idpf_vport *vport);
+bool idpf_init_rx_buf_hw_alloc(struct idpf_queue *rxq, struct idpf_rx_buf *buf);
+void idpf_rx_buf_hw_update(struct idpf_queue *rxq, u32 val);
+bool idpf_rx_singleq_buf_hw_alloc_all(struct idpf_queue *rxq,
+				      u16 cleaned_count);
 
 #endif /* !_IDPF_TXRX_H_ */
diff --git a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
index 67927082ddd1..61a44e216df8 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
@@ -169,6 +169,17 @@ static int idpf_find_vport(struct idpf_adapter *adapter,
 	case VIRTCHNL2_OP_CONFIG_TX_QUEUES:
 		v_id = le32_to_cpu(((struct virtchnl2_config_tx_queues *)vc_msg)->vport_id);
 		break;
+	case VIRTCHNL2_OP_CONFIG_RX_QUEUES:
+		v_id = le32_to_cpu(((struct virtchnl2_config_rx_queues *)vc_msg)->vport_id);
+		break;
+	case VIRTCHNL2_OP_GET_RSS_LUT:
+	case VIRTCHNL2_OP_SET_RSS_LUT:
+		v_id = le32_to_cpu(((struct virtchnl2_rss_lut *)vc_msg)->vport_id);
+		break;
+	case VIRTCHNL2_OP_GET_RSS_KEY:
+	case VIRTCHNL2_OP_SET_RSS_KEY:
+		v_id = le32_to_cpu(((struct virtchnl2_rss_key *)vc_msg)->vport_id);
+		break;
 	case VIRTCHNL2_OP_ADD_MAC_ADDR:
 	case VIRTCHNL2_OP_DEL_MAC_ADDR:
 		v_id = le32_to_cpu(((struct virtchnl2_mac_addr_list *)vc_msg)->vport_id);
@@ -426,6 +437,31 @@ int idpf_recv_mb_msg(struct idpf_adapter *adapter, u32 op,
 					   IDPF_VC_CONFIG_TXQ,
 					   IDPF_VC_CONFIG_TXQ_ERR);
 			break;
+		case VIRTCHNL2_OP_CONFIG_RX_QUEUES:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_CONFIG_RXQ,
+					   IDPF_VC_CONFIG_RXQ_ERR);
+			break;
+		case VIRTCHNL2_OP_GET_RSS_LUT:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_GET_RSS_LUT,
+					   IDPF_VC_GET_RSS_LUT_ERR);
+			break;
+		case VIRTCHNL2_OP_SET_RSS_LUT:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_SET_RSS_LUT,
+					   IDPF_VC_SET_RSS_LUT_ERR);
+			break;
+		case VIRTCHNL2_OP_GET_RSS_KEY:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_GET_RSS_KEY,
+					   IDPF_VC_GET_RSS_KEY_ERR);
+			break;
+		case VIRTCHNL2_OP_SET_RSS_KEY:
+			idpf_recv_vchnl_op(adapter, vport, &ctlq_msg,
+					   IDPF_VC_SET_RSS_KEY,
+					   IDPF_VC_SET_RSS_KEY_ERR);
+			break;
 		case VIRTCHNL2_OP_ALLOC_VECTORS:
 			idpf_recv_vchnl_op(adapter, NULL, &ctlq_msg,
 					   IDPF_VC_ALLOC_VECTORS,
@@ -903,6 +939,7 @@ static int __idpf_queue_reg_init(struct idpf_vport *vport, u32 *reg_vals,
 				 int num_regs, u32 q_type)
 {
 	struct idpf_adapter *adapter = vport->adapter;
+	struct idpf_queue *q;
 	int i, j, k = 0;
 
 	switch (q_type) {
@@ -915,6 +952,30 @@ static int __idpf_queue_reg_init(struct idpf_vport *vport, u32 *reg_vals,
 					idpf_get_reg_addr(adapter, reg_vals[k]);
 		}
 		break;
+	case VIRTCHNL2_QUEUE_TYPE_RX:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			int num_rxq = rx_qgrp->singleq.num_rxq;
+
+			for (j = 0; j < num_rxq && k < num_regs; j++, k++) {
+				q = rx_qgrp->singleq.rxqs[j];
+				q->tail = idpf_get_reg_addr(adapter,
+							    reg_vals[k]);
+			}
+		}
+		break;
+	case VIRTCHNL2_QUEUE_TYPE_RX_BUFFER:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			u8 num_bufqs = vport->num_bufqs_per_qgrp;
+
+			for (j = 0; j < num_bufqs && k < num_regs; j++, k++) {
+				q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+				q->tail = idpf_get_reg_addr(adapter,
+							    reg_vals[k]);
+			}
+		}
+		break;
 	default:
 		break;
 	}
@@ -964,8 +1025,45 @@ int idpf_queue_reg_init(struct idpf_vport *vport)
 
 	num_regs = __idpf_queue_reg_init(vport, reg_vals, num_regs,
 					 VIRTCHNL2_QUEUE_TYPE_TX);
-	if (num_regs < vport->num_txq)
+	if (num_regs < vport->num_txq) {
 		ret = -EINVAL;
+		goto free_reg_vals;
+	}
+
+	/* Initialize Rx/buffer queue tail register address based on Rx queue
+	 * model
+	 */
+	if (idpf_is_queue_model_split(vport->rxq_model)) {
+		num_regs = idpf_vport_get_q_reg(reg_vals, IDPF_LARGE_MAX_Q,
+						VIRTCHNL2_QUEUE_TYPE_RX_BUFFER,
+						chunks);
+		if (num_regs < vport->num_bufq) {
+			ret = -EINVAL;
+			goto free_reg_vals;
+		}
+
+		num_regs = __idpf_queue_reg_init(vport, reg_vals, num_regs,
+						 VIRTCHNL2_QUEUE_TYPE_RX_BUFFER);
+		if (num_regs < vport->num_bufq) {
+			ret = -EINVAL;
+			goto free_reg_vals;
+		}
+	} else {
+		num_regs = idpf_vport_get_q_reg(reg_vals, IDPF_LARGE_MAX_Q,
+						VIRTCHNL2_QUEUE_TYPE_RX,
+						chunks);
+		if (num_regs < vport->num_rxq) {
+			ret = -EINVAL;
+			goto free_reg_vals;
+		}
+
+		num_regs = __idpf_queue_reg_init(vport, reg_vals, num_regs,
+						 VIRTCHNL2_QUEUE_TYPE_RX);
+		if (num_regs < vport->num_rxq) {
+			ret = -EINVAL;
+			goto free_reg_vals;
+		}
+	}
 
 free_reg_vals:
 	kfree(reg_vals);
@@ -1129,7 +1227,7 @@ int idpf_send_destroy_vport_msg(struct idpf_vport *vport)
  * Send config tx queues virtchnl message. Returns 0 on success, negative on
  * failure.
  */
-int idpf_send_config_tx_queues_msg(struct idpf_vport *vport)
+static int idpf_send_config_tx_queues_msg(struct idpf_vport *vport)
 {
 	struct virtchnl2_config_tx_queues *ctq = NULL;
 	u32 config_sz, chunk_sz, buf_sz = 0;
@@ -1247,6 +1345,174 @@ int idpf_send_config_tx_queues_msg(struct idpf_vport *vport)
 	return err;
 }
 
+/**
+ * idpf_send_config_rx_queues_msg - Send virtchnl config rx queues message
+ * @vport: virtual port data structure
+ *
+ * Send config rx queues virtchnl message.  Returns 0 on success, negative on
+ * failure.
+ */
+static int idpf_send_config_rx_queues_msg(struct idpf_vport *vport)
+{
+	struct virtchnl2_config_rx_queues *crq = NULL;
+	u32 config_sz, chunk_sz, buf_sz = 0;
+	int totqs, num_msgs, num_chunks;
+	struct virtchnl2_rxq_info *qi;
+	int err = 0, i, k = 0;
+
+	totqs = vport->num_rxq + vport->num_bufq;
+	qi = kcalloc(totqs, sizeof(struct virtchnl2_rxq_info), GFP_KERNEL);
+	if (!qi)
+		return -ENOMEM;
+
+	/* Populate the queue info buffer with all queue context info */
+	for (i = 0; i < vport->num_rxq_grp; i++) {
+		struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+		int num_rxq;
+		int j;
+
+		if (!idpf_is_queue_model_split(vport->rxq_model))
+			goto setup_rxqs;
+
+		for (j = 0; j < vport->num_bufqs_per_qgrp; j++, k++) {
+			struct idpf_queue *bufq =
+				&rx_qgrp->splitq.bufq_sets[j].bufq;
+
+			qi[k].queue_id = cpu_to_le32(bufq->q_id);
+			qi[k].model = cpu_to_le16(vport->rxq_model);
+			qi[k].type = cpu_to_le32(bufq->q_type);
+			qi[k].desc_ids = cpu_to_le64(VIRTCHNL2_RXDID_2_FLEX_SPLITQ_M);
+			qi[k].ring_len = cpu_to_le16(bufq->desc_count);
+			qi[k].dma_ring_addr = cpu_to_le64(bufq->dma);
+			qi[k].data_buffer_size = cpu_to_le32(bufq->rx_buf_size);
+			qi[k].buffer_notif_stride = bufq->rx_buf_stride;
+			qi[k].rx_buffer_low_watermark =
+				cpu_to_le16(bufq->rx_buffer_low_watermark);
+			if (idpf_is_feature_ena(vport, NETIF_F_GRO_HW))
+				qi[k].qflags |= cpu_to_le16(VIRTCHNL2_RXQ_RSC);
+		}
+
+setup_rxqs:
+		if (idpf_is_queue_model_split(vport->rxq_model))
+			num_rxq = rx_qgrp->splitq.num_rxq_sets;
+		else
+			num_rxq = rx_qgrp->singleq.num_rxq;
+
+		for (j = 0; j < num_rxq; j++, k++) {
+			struct idpf_queue *rxq;
+
+			if (!idpf_is_queue_model_split(vport->rxq_model)) {
+				rxq = rx_qgrp->singleq.rxqs[j];
+				goto common_qi_fields;
+			}
+			rxq = &rx_qgrp->splitq.rxq_sets[j]->rxq;
+			qi[k].rx_bufq1_id =
+			  cpu_to_le16(rxq->rxq_grp->splitq.bufq_sets[0].bufq.q_id);
+			if (vport->num_bufqs_per_qgrp > IDPF_SINGLE_BUFQ_PER_RXQ_GRP) {
+				qi[k].bufq2_ena = IDPF_BUFQ2_ENA;
+				qi[k].rx_bufq2_id =
+				  cpu_to_le16(rxq->rxq_grp->splitq.bufq_sets[1].bufq.q_id);
+			}
+			qi[k].rx_buffer_low_watermark =
+				cpu_to_le16(rxq->rx_buffer_low_watermark);
+			if (idpf_is_feature_ena(vport, NETIF_F_GRO_HW))
+				qi[k].qflags |= cpu_to_le16(VIRTCHNL2_RXQ_RSC);
+
+common_qi_fields:
+			if (rxq->rx_hsplit_en) {
+				qi[k].qflags |=
+					cpu_to_le16(VIRTCHNL2_RXQ_HDR_SPLIT);
+				qi[k].hdr_buffer_size =
+					cpu_to_le16(rxq->rx_hbuf_size);
+			}
+			qi[k].queue_id = cpu_to_le32(rxq->q_id);
+			qi[k].model = cpu_to_le16(vport->rxq_model);
+			qi[k].type = cpu_to_le32(rxq->q_type);
+			qi[k].ring_len = cpu_to_le16(rxq->desc_count);
+			qi[k].dma_ring_addr = cpu_to_le64(rxq->dma);
+			qi[k].max_pkt_size = cpu_to_le32(rxq->rx_max_pkt_size);
+			qi[k].data_buffer_size = cpu_to_le32(rxq->rx_buf_size);
+			qi[k].qflags |=
+				cpu_to_le16(VIRTCHNL2_RX_DESC_SIZE_32BYTE);
+			qi[k].desc_ids = cpu_to_le64(rxq->rxdids);
+		}
+	}
+
+	/* Make sure accounting agrees */
+	if (k != totqs) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	/* Chunk up the queue contexts into multiple messages to avoid
+	 * sending a control queue message buffer that is too large
+	 */
+	config_sz = sizeof(struct virtchnl2_config_rx_queues);
+	chunk_sz = sizeof(struct virtchnl2_rxq_info);
+
+	num_chunks = min_t(u32, IDPF_NUM_CHUNKS_PER_MSG(config_sz, chunk_sz),
+			   totqs);
+	num_msgs = DIV_ROUND_UP(totqs, num_chunks);
+
+	buf_sz = struct_size(crq, qinfo, num_chunks);
+	crq = kzalloc(buf_sz, GFP_KERNEL);
+	if (!crq) {
+		err = -ENOMEM;
+		goto error;
+	}
+
+	for (i = 0, k = 0; i < num_msgs; i++) {
+		memset(crq, 0, buf_sz);
+		crq->vport_id = cpu_to_le32(vport->vport_id);
+		crq->num_qinfo = cpu_to_le16(num_chunks);
+		memcpy(crq->qinfo, &qi[k], chunk_sz * num_chunks);
+
+		err = idpf_send_mb_msg(vport->adapter,
+				       VIRTCHNL2_OP_CONFIG_RX_QUEUES,
+				       buf_sz, (u8 *)crq);
+		if (err)
+			goto mbx_error;
+
+		err = idpf_wait_for_event(vport->adapter, vport, IDPF_VC_CONFIG_RXQ,
+					  IDPF_VC_CONFIG_RXQ_ERR);
+		if (err)
+			goto mbx_error;
+
+		k += num_chunks;
+		totqs -= num_chunks;
+		num_chunks = min(num_chunks, totqs);
+		/* Recalculate buffer size */
+		buf_sz = struct_size(crq, qinfo, num_chunks);
+
+		clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+	}
+
+mbx_error:
+	kfree(crq);
+error:
+	kfree(qi);
+
+	return err;
+}
+
+/**
+ * idpf_send_config_queues_msg - Send config queues virtchnl message
+ * @vport: Virtual port private data structure
+ *
+ * Will send config queues virtchnl message. Returns 0 on success, negative on
+ * failure.
+ */
+int idpf_send_config_queues_msg(struct idpf_vport *vport)
+{
+	int err;
+
+	err = idpf_send_config_tx_queues_msg(vport);
+	if (err)
+		return err;
+
+	return idpf_send_config_rx_queues_msg(vport);
+}
+
 /**
  * idpf_send_alloc_vectors_msg - Send virtchnl alloc vectors message
  * @adapter: Driver specific private structure
@@ -1334,6 +1600,158 @@ int idpf_send_dealloc_vectors_msg(struct idpf_adapter *adapter)
 	return 0;
 }
 
+/**
+ * idpf_send_get_set_rss_lut_msg - Send virtchnl get or set rss lut message
+ * @vport: virtual port data structure
+ * @get: flag to set or get rss look up table
+ *
+ * Returns 0 on success, negative on failure.
+ */
+int idpf_send_get_set_rss_lut_msg(struct idpf_vport *vport, bool get)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_rss_lut *recv_rl;
+	struct idpf_rss_data *rss_data;
+	struct virtchnl2_rss_lut *rl;
+	int buf_size, lut_buf_size;
+	int i, err = 0;
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+	buf_size = struct_size(rl, lut, rss_data->rss_lut_size);
+	rl = kzalloc(buf_size, GFP_KERNEL);
+	if (!rl)
+		return -ENOMEM;
+
+	rl->vport_id = cpu_to_le32(vport->vport_id);
+	if (!get) {
+		rl->lut_entries = cpu_to_le16(rss_data->rss_lut_size);
+		for (i = 0; i < rss_data->rss_lut_size; i++)
+			rl->lut[i] = cpu_to_le32(rss_data->rss_lut[i]);
+
+		err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_SET_RSS_LUT,
+				       buf_size, (u8 *)rl);
+		if (err)
+			goto free_mem;
+
+		err = idpf_wait_for_event(adapter, vport, IDPF_VC_SET_RSS_LUT,
+					  IDPF_VC_SET_RSS_LUT_ERR);
+		if (!err)
+			clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+
+		goto free_mem;
+	}
+
+	err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_GET_RSS_LUT,
+			       buf_size, (u8 *)rl);
+	if (err)
+		goto free_mem;
+
+	err = idpf_wait_for_event(adapter, vport, IDPF_VC_GET_RSS_LUT,
+				  IDPF_VC_GET_RSS_LUT_ERR);
+	if (err)
+		goto free_mem;
+
+	recv_rl = (struct virtchnl2_rss_lut *)vport->vc_msg;
+	if (rss_data->rss_lut_size == le16_to_cpu(recv_rl->lut_entries))
+		goto do_memcpy;
+
+	rss_data->rss_lut_size = le16_to_cpu(recv_rl->lut_entries);
+	kfree(rss_data->rss_lut);
+
+	lut_buf_size = rss_data->rss_lut_size * sizeof(u32);
+	rss_data->rss_lut = kzalloc(lut_buf_size, GFP_KERNEL);
+	if (!rss_data->rss_lut) {
+		rss_data->rss_lut_size = 0;
+		clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+		err = -ENOMEM;
+		goto free_mem;
+	}
+
+do_memcpy:
+	memcpy(rss_data->rss_lut, vport->vc_msg, rss_data->rss_lut_size);
+	clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+free_mem:
+	kfree(rl);
+
+	return err;
+}
+
+/**
+ * idpf_send_get_set_rss_key_msg - Send virtchnl get or set rss key message
+ * @vport: virtual port data structure
+ * @get: flag to set or get rss look up table
+ *
+ * Returns 0 on success, negative on failure
+ */
+int idpf_send_get_set_rss_key_msg(struct idpf_vport *vport, bool get)
+{
+	struct idpf_adapter *adapter = vport->adapter;
+	struct virtchnl2_rss_key *recv_rk;
+	struct idpf_rss_data *rss_data;
+	struct virtchnl2_rss_key *rk;
+	int i, buf_size, err = 0;
+
+	rss_data = &adapter->vport_config[vport->idx]->user_config.rss_data;
+	buf_size = struct_size(rk, key_flex, rss_data->rss_key_size);
+	rk = kzalloc(buf_size, GFP_KERNEL);
+	if (!rk)
+		return -ENOMEM;
+
+	rk->vport_id = cpu_to_le32(vport->vport_id);
+
+	if (get) {
+		err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_GET_RSS_KEY,
+				       buf_size, (u8 *)rk);
+		if (err)
+			goto error;
+
+		err = idpf_wait_for_event(adapter, vport, IDPF_VC_GET_RSS_KEY,
+					  IDPF_VC_GET_RSS_KEY_ERR);
+		if (err)
+			goto error;
+
+		recv_rk = (struct virtchnl2_rss_key *)vport->vc_msg;
+		if (rss_data->rss_key_size !=
+		    le16_to_cpu(recv_rk->key_len)) {
+			rss_data->rss_key_size =
+				min_t(u16, NETDEV_RSS_KEY_LEN,
+				      le16_to_cpu(recv_rk->key_len));
+			kfree(rss_data->rss_key);
+			rss_data->rss_key = kzalloc(rss_data->rss_key_size,
+						    GFP_KERNEL);
+			if (!rss_data->rss_key) {
+				rss_data->rss_key_size = 0;
+				clear_bit(IDPF_VPORT_VC_MSG_PENDING,
+					  vport->flags);
+				err = -ENOMEM;
+				goto error;
+			}
+		}
+		memcpy(rss_data->rss_key, recv_rk->key_flex,
+		       rss_data->rss_key_size);
+		clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+	} else {
+		rk->key_len = cpu_to_le16(rss_data->rss_key_size);
+		for (i = 0; i < rss_data->rss_key_size; i++)
+			rk->key_flex[i] = rss_data->rss_key[i];
+
+		err = idpf_send_mb_msg(adapter, VIRTCHNL2_OP_SET_RSS_KEY,
+				       buf_size, (u8 *)rk);
+		if (err)
+			goto error;
+
+		err = idpf_wait_for_event(adapter, vport, IDPF_VC_SET_RSS_KEY,
+					  IDPF_VC_SET_RSS_KEY_ERR);
+		if (!err)
+			clear_bit(IDPF_VPORT_VC_MSG_PENDING, vport->flags);
+	}
+
+error:
+	kfree(rk);
+
+	return err;
+}
+
 /**
  * idpf_fill_ptype_lookup - Fill L3 specific fields in ptype lookup table
  * @ptype: ptype lookup table
@@ -1920,9 +2338,11 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	struct idpf_adapter *adapter = vport->adapter;
 	struct virtchnl2_create_vport *vport_msg;
 	struct idpf_vport_config *vport_config;
+	struct idpf_rss_data *rss_data;
 	u16 idx = vport->idx;
 
 	vport_config = adapter->vport_config[idx];
+	rss_data = &vport_config->user_config.rss_data;
 	vport_msg = (struct virtchnl2_create_vport *)
 				adapter->vport_params_recvd[idx];
 
@@ -1936,6 +2356,10 @@ void idpf_vport_init(struct idpf_vport *vport, struct idpf_vport_max_q *max_q)
 	vport->vport_type = le16_to_cpu(vport_msg->vport_type);
 	vport->vport_id = le32_to_cpu(vport_msg->vport_id);
 
+	rss_data->rss_key_size = min_t(u16, NETDEV_RSS_KEY_LEN,
+				       le16_to_cpu(vport_msg->rss_key_size));
+	rss_data->rss_lut_size = le16_to_cpu(vport_msg->rss_lut_size);
+
 	ether_addr_copy(vport->default_mac_addr, vport_msg->default_mac_addr);
 	vport->max_mtu = le16_to_cpu(vport_msg->max_mtu) - IDPF_PACKET_HDR_PAD;
 
@@ -2045,6 +2469,7 @@ static int idpf_vport_get_queue_ids(u32 *qids, int num_qids, u16 q_type,
 static int __idpf_vport_queue_ids_init(struct idpf_vport *vport, const u32 *qids,
 				       int num_qids, u32 q_type)
 {
+	struct idpf_queue *q;
 	int i, j, k = 0;
 
 	switch (q_type) {
@@ -2059,6 +2484,26 @@ static int __idpf_vport_queue_ids_init(struct idpf_vport *vport, const u32 *qids
 			}
 		}
 		break;
+	case VIRTCHNL2_QUEUE_TYPE_RX:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			int num_rxq;
+
+			if (idpf_is_queue_model_split(vport->rxq_model))
+				num_rxq = rx_qgrp->splitq.num_rxq_sets;
+			else
+				num_rxq = rx_qgrp->singleq.num_rxq;
+
+			for (j = 0; j < num_rxq && k < num_qids; j++, k++) {
+				if (idpf_is_queue_model_split(vport->rxq_model))
+					q = &rx_qgrp->splitq.rxq_sets[j]->rxq;
+				else
+					q = rx_qgrp->singleq.rxqs[j];
+				q->q_id = qids[k];
+				q->q_type = VIRTCHNL2_QUEUE_TYPE_RX;
+			}
+		}
+		break;
 	case VIRTCHNL2_QUEUE_TYPE_TX_COMPLETION:
 		for (i = 0; i < vport->num_txq_grp && k < num_qids; i++, k++) {
 			struct idpf_txq_group *tx_qgrp = &vport->txq_grps[i];
@@ -2068,6 +2513,18 @@ static int __idpf_vport_queue_ids_init(struct idpf_vport *vport, const u32 *qids
 				VIRTCHNL2_QUEUE_TYPE_TX_COMPLETION;
 		}
 		break;
+	case VIRTCHNL2_QUEUE_TYPE_RX_BUFFER:
+		for (i = 0; i < vport->num_rxq_grp; i++) {
+			struct idpf_rxq_group *rx_qgrp = &vport->rxq_grps[i];
+			u8 num_bufqs = vport->num_bufqs_per_qgrp;
+
+			for (j = 0; j < num_bufqs && k < num_qids; j++, k++) {
+				q = &rx_qgrp->splitq.bufq_sets[j].bufq;
+				q->q_id = qids[k];
+				q->q_type = VIRTCHNL2_QUEUE_TYPE_RX_BUFFER;
+			}
+		}
+		break;
 	default:
 		break;
 	}
@@ -2121,8 +2578,22 @@ int idpf_vport_queue_ids_init(struct idpf_vport *vport)
 		goto mem_rel;
 	}
 
-	if (!idpf_is_queue_model_split(vport->txq_model))
+	num_ids = idpf_vport_get_queue_ids(qids, IDPF_MAX_QIDS,
+					   VIRTCHNL2_QUEUE_TYPE_RX,
+					   chunks);
+	if (num_ids < vport->num_rxq) {
+		err = -EINVAL;
 		goto mem_rel;
+	}
+	num_ids = __idpf_vport_queue_ids_init(vport, qids, num_ids,
+					      VIRTCHNL2_QUEUE_TYPE_RX);
+	if (num_ids < vport->num_rxq) {
+		err = -EINVAL;
+		goto mem_rel;
+	}
+
+	if (!idpf_is_queue_model_split(vport->txq_model))
+		goto check_rxq;
 
 	q_type = VIRTCHNL2_QUEUE_TYPE_TX_COMPLETION;
 	num_ids = idpf_vport_get_queue_ids(qids, IDPF_MAX_QIDS, q_type, chunks);
@@ -2131,7 +2602,23 @@ int idpf_vport_queue_ids_init(struct idpf_vport *vport)
 		goto mem_rel;
 	}
 	num_ids = __idpf_vport_queue_ids_init(vport, qids, num_ids, q_type);
-	if (num_ids < vport->num_complq)
+	if (num_ids < vport->num_complq) {
+		err = -EINVAL;
+		goto mem_rel;
+	}
+
+check_rxq:
+	if (!idpf_is_queue_model_split(vport->rxq_model))
+		goto mem_rel;
+
+	q_type = VIRTCHNL2_QUEUE_TYPE_RX_BUFFER;
+	num_ids = idpf_vport_get_queue_ids(qids, IDPF_MAX_QIDS, q_type, chunks);
+	if (num_ids < vport->num_bufq) {
+		err = -EINVAL;
+		goto mem_rel;
+	}
+	num_ids = __idpf_vport_queue_ids_init(vport, qids, num_ids, q_type);
+	if (num_ids < vport->num_bufq)
 		err = -EINVAL;
 
 mem_rel:
-- 
2.17.2



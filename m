Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4561FEABB
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgFRFOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:14:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:27993 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726892AbgFRFOG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 01:14:06 -0400
IronPort-SDR: 8L12BwcNHINoA8mVXFxcMXUY14TnKbZZaC2ERAcKDsTqzCHNZKWBcjY7oFxHzwIrxwpyKdb1W9
 hv97oFjDyZ3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9655"; a="207694693"
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="207694693"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 22:13:49 -0700
IronPort-SDR: Tha4q9RAiSVHRbiBs6HoOm1yP3QcQ8cTPSfdFOl7xPY9RTi3VcehqgIWxuBOwH4CPeFxpsAnas
 VmevO8TY7pbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,525,1583222400"; 
   d="scan'208";a="263495570"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga008.fm.intel.com with ESMTP; 17 Jun 2020 22:13:49 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Alice Michael <alice.michael@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Alan Brady <alan.brady@intel.com>,
        Phani Burra <phani.r.burra@intel.com>,
        Joshua Hay <joshua.a.hay@intel.com>,
        Madhu Chittim <madhu.chittim@intel.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        Donald Skidmore <donald.c.skidmore@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 01/15] virtchnl: Extend AVF ops
Date:   Wed, 17 Jun 2020 22:13:30 -0700
Message-Id: <20200618051344.516587-2-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
References: <20200618051344.516587-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alice Michael <alice.michael@intel.com>

This implements the next generation of virtchnl ops which
enable greater functionality and capabilities.

Signed-off-by: Alice Michael <alice.michael@intel.com>
Signed-off-by: Alan Brady <alan.brady@intel.com>
Signed-off-by: Phani Burra <phani.r.burra@intel.com>
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Signed-off-by: Madhu Chittim <madhu.chittim@intel.com>
Signed-off-by: Pavan Kumar Linga <pavan.kumar.linga@intel.com>
Reviewed-by: Donald Skidmore <donald.c.skidmore@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 include/linux/avf/virtchnl.h | 592 +++++++++++++++++++++++++++++++++++
 1 file changed, 592 insertions(+)

diff --git a/include/linux/avf/virtchnl.h b/include/linux/avf/virtchnl.h
index 40bad71865ea..a967ea2c1248 100644
--- a/include/linux/avf/virtchnl.h
+++ b/include/linux/avf/virtchnl.h
@@ -136,6 +136,34 @@ enum virtchnl_ops {
 	VIRTCHNL_OP_DISABLE_CHANNELS = 31,
 	VIRTCHNL_OP_ADD_CLOUD_FILTER = 32,
 	VIRTCHNL_OP_DEL_CLOUD_FILTER = 33,
+	/* New major set of opcodes introduced and so leaving room for
+	 * old misc opcodes to be added in future. Also these opcodes may only
+	 * be used if both the PF and VF have successfully negotiated the
+	 * VIRTCHNL_VF_CAP_EXT_FEATURES capability during initial capabilities
+	 * exchange.
+	 */
+	VIRTCHNL_OP_GET_CAPS = 100,
+	VIRTCHNL_OP_CREATE_VPORT = 101,
+	VIRTCHNL_OP_DESTROY_VPORT = 102,
+	VIRTCHNL_OP_ENABLE_VPORT = 103,
+	VIRTCHNL_OP_DISABLE_VPORT = 104,
+	VIRTCHNL_OP_CONFIG_TX_QUEUES = 105,
+	VIRTCHNL_OP_CONFIG_RX_QUEUES = 106,
+	VIRTCHNL_OP_ENABLE_QUEUES_V2 = 107,
+	VIRTCHNL_OP_DISABLE_QUEUES_V2 = 108,
+	VIRTCHNL_OP_ADD_QUEUES = 109,
+	VIRTCHNL_OP_DEL_QUEUES = 110,
+	VIRTCHNL_OP_MAP_QUEUE_VECTOR = 111,
+	VIRTCHNL_OP_UNMAP_QUEUE_VECTOR = 112,
+	VIRTCHNL_OP_GET_RSS_KEY = 113,
+	VIRTCHNL_OP_GET_RSS_LUT = 114,
+	VIRTCHNL_OP_SET_RSS_LUT = 115,
+	VIRTCHNL_OP_GET_RSS_HASH = 116,
+	VIRTCHNL_OP_SET_RSS_HASH = 117,
+	VIRTCHNL_OP_CREATE_VFS = 118,
+	VIRTCHNL_OP_DESTROY_VFS = 119,
+	VIRTCHNL_OP_ALLOC_VECTORS = 120,
+	VIRTCHNL_OP_DEALLOC_VECTORS = 121,
 };
 
 /* These macros are used to generate compilation errors if a structure/union
@@ -463,6 +491,21 @@ VIRTCHNL_CHECK_STRUCT_LEN(4, virtchnl_promisc_info);
  * PF replies with struct eth_stats in an external buffer.
  */
 
+struct virtchnl_eth_stats {
+	u64 rx_bytes;                   /* received bytes */
+	u64 rx_unicast;                 /* received unicast pkts */
+	u64 rx_multicast;               /* received multicast pkts */
+	u64 rx_broadcast;               /* received broadcast pkts */
+	u64 rx_discards;
+	u64 rx_unknown_protocol;
+	u64 tx_bytes;                   /* transmitted bytes */
+	u64 tx_unicast;                 /* transmitted unicast pkts */
+	u64 tx_multicast;               /* transmitted multicast pkts */
+	u64 tx_broadcast;               /* transmitted broadcast pkts */
+	u64 tx_discards;
+	u64 tx_errors;
+};
+
 /* VIRTCHNL_OP_CONFIG_RSS_KEY
  * VIRTCHNL_OP_CONFIG_RSS_LUT
  * VF sends these messages to configure RSS. Only supported if both PF
@@ -668,6 +711,397 @@ enum virtchnl_vfr_states {
 	VIRTCHNL_VFR_VFACTIVE,
 };
 
+/* PF capability flags
+ * VIRTCHNL_CAP_STATELESS_OFFLOADS flag indicates stateless offloads
+ * such as TX/RX Checksum offloading and TSO for non-tunneled packets. Please
+ * note that old and new capabilities are exclusive and not supposed to be
+ * mixed
+ */
+#define VIRTCHNL_CAP_STATELESS_OFFLOADS	BIT(1)
+#define VIRTCHNL_CAP_UDP_SEG_OFFLOAD		BIT(2)
+#define VIRTCHNL_CAP_RSS			BIT(3)
+#define VIRTCHNL_CAP_TCP_RSC			BIT(4)
+#define VIRTCHNL_CAP_HEADER_SPLIT		BIT(5)
+#define VIRTCHNL_CAP_RDMA			BIT(6)
+#define VIRTCHNL_CAP_SRIOV			BIT(7)
+/* Earliest Departure Time capability used for Timing Wheel */
+#define VIRTCHNL_CAP_EDT			BIT(8)
+
+/* Type of virtual port */
+enum virtchnl_vport_type {
+	VIRTCHNL_VPORT_TYPE_DEFAULT	= 0,
+};
+
+/* Type of queue model */
+enum virtchnl_queue_model {
+	VIRTCHNL_QUEUE_MODEL_SINGLE	= 0,
+	VIRTCHNL_QUEUE_MODEL_SPLIT	= 1,
+};
+
+/* TX and RX queue types are valid in legacy as well as split queue models.
+ * With Split Queue model, 2 additional types are introduced - TX_COMPLETION
+ * and RX_BUFFER. In split queue model, RX corresponds to the queue where HW
+ * posts completions.
+ */
+enum virtchnl_queue_type {
+	VIRTCHNL_QUEUE_TYPE_TX			= 0,
+	VIRTCHNL_QUEUE_TYPE_RX			= 1,
+	VIRTCHNL_QUEUE_TYPE_TX_COMPLETION	= 2,
+	VIRTCHNL_QUEUE_TYPE_RX_BUFFER		= 3,
+};
+
+/* RX Queue Feature bits */
+#define VIRTCHNL_RXQ_RSC			BIT(1)
+#define VIRTCHNL_RXQ_HDR_SPLIT			BIT(2)
+#define VIRTCHNL_RXQ_IMMEDIATE_WRITE_BACK	BIT(4)
+
+/* RX Queue Descriptor Types */
+enum virtchnl_rxq_desc_size {
+	VIRTCHNL_RXQ_DESC_SIZE_16BYTE	= 0,
+	VIRTCHNL_RXQ_DESC_SIZE_32BYTE	= 1,
+};
+
+/* TX Queue Scheduling Modes  Queue mode is the legacy type i.e. inorder
+ * and Flow mode is out of order packet processing
+ */
+enum virtchnl_txq_sched_mode {
+	VIRTCHNL_TXQ_SCHED_MODE_QUEUE	= 0,
+	VIRTCHNL_TXQ_SCHED_MODE_FLOW	= 1,
+};
+
+/* Queue Descriptor Profiles  Base mode is the legacy and Native is the
+ * flex descriptors
+ */
+enum virtchnl_desc_profile {
+	VIRTCHNL_TXQ_DESC_PROFILE_BASE		= 0,
+	VIRTCHNL_TXQ_DESC_PROFILE_NATIVE	= 1,
+};
+
+/* Type of RSS algorithm */
+enum virtchnl_rss_algorithm {
+	VIRTCHNL_RSS_ALG_TOEPLITZ_ASYMMETRIC	= 0,
+	VIRTCHNL_RSS_ALG_R_ASYMMETRIC		= 1,
+	VIRTCHNL_RSS_ALG_TOEPLITZ_SYMMETRIC	= 2,
+	VIRTCHNL_RSS_ALG_XOR_SYMMETRIC		= 3,
+};
+
+/* VIRTCHNL_OP_GET_CAPS
+ * PF sends this message to CP to negotiate capabilities by filling
+ * in the u64 bitmap of its desired capabilities, max_num_vfs and
+ * num_allocated_vectors.
+ * CP responds with an updated virtchnl_get_capabilities structure
+ * with allowed capabilities and the other fields as below.
+ * If PF sets max_num_vfs as 0, CP will respond with max number of VFs
+ * that can be created by this PF. For any other value 'n', CP responds
+ * with max_num_vfs set to max(n, x) where x is the max number of VFs
+ * allowed by CP's policy.
+ * If PF sets num_allocated_vectors as 0, CP will respond with 1 which
+ * is default vector associated with the default mailbox. For any other
+ * value 'n', CP responds with a value <= n based on the CP's policy of
+ * max number of vectors for a PF.
+ */
+struct virtchnl_get_capabilities {
+	u64 cap_flags;
+	u16 max_num_vfs;
+	u16 num_allocated_vectors;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_get_capabilities);
+
+/* structure to specify a chunk of contiguous queues */
+struct virtchnl_queue_chunk {
+	enum virtchnl_queue_type type;
+	u16 start_queue_id;
+	u16 num_queues;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(8, virtchnl_queue_chunk);
+
+/* structure to specify several chunks of contiguous queues */
+struct virtchnl_queue_chunks {
+	u16 num_chunks;
+	u16 rsvd;
+	struct virtchnl_queue_chunk chunks[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_queue_chunks);
+
+/* VIRTCHNL_OP_CREATE_VPORT
+ * PF sends this message to CP to create a vport by filling in the first 8
+ * fields of virtchnl_create_vport structure (vport type, Tx, Rx queue models
+ * and desired number of queues and vectors). CP responds with the updated
+ * virtchnl_create_vport structure containing the number of assigned queues,
+ * vectors, vport id, max mtu, default mac addr followed by chunks which in turn
+ * will have an array of num_chunks entries of virtchnl_queue_chunk structures.
+ */
+struct virtchnl_create_vport {
+	enum virtchnl_vport_type vport_type;
+	/* single or split */
+	enum virtchnl_queue_model txq_model;
+	/* single or split */
+	enum virtchnl_queue_model rxq_model;
+	u16 num_tx_q;
+	/* valid only if txq_model is split Q */
+	u16 num_tx_complq;
+	u16 num_rx_q;
+	/* valid only if rxq_model is split Q */
+	u16 num_rx_bufq;
+	u16 vport_id;
+	u16 max_mtu;
+	u8 default_mac_addr[ETH_ALEN];
+	enum virtchnl_rss_algorithm rss_algorithm;
+	u16 rss_key_size;
+	u16 rss_lut_size;
+	u16 qset_handle;
+	struct virtchnl_queue_chunks chunks;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(56, virtchnl_create_vport);
+
+/* VIRTCHNL_OP_DESTROY_VPORT
+ * VIRTCHNL_OP_ENABLE_VPORT
+ * VIRTCHNL_OP_DISABLE_VPORT
+ * PF sends this message to CP to destroy, enable or disable a vport by filling
+ * in the vport_id in virtchnl_vport structure.
+ * CP responds with the status of the requested operation.
+ */
+struct virtchnl_vport {
+	u16 vport_id;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(2, virtchnl_vport);
+
+/* Tx queue config info */
+struct virtchnl_txq_info_v2 {
+	u16 queue_id;
+	/* single or split */
+	enum virtchnl_queue_model model;
+	/* Tx or tx_completion */
+	enum virtchnl_queue_type type;
+	/* queue or flow based */
+	enum virtchnl_txq_sched_mode sched_mode;
+	/* base or native */
+	enum virtchnl_desc_profile desc_profile;
+	u16 ring_len;
+	u64 dma_ring_addr;
+	/* valid only if queue model is split and type is Tx */
+	u16 tx_compl_queue_id;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(40, virtchnl_txq_info_v2);
+
+/* VIRTCHNL_OP_CONFIG_TX_QUEUES
+ * PF sends this message to set up parameters for one or more TX queues.
+ * This message contains an array of num_qinfo instances of virtchnl_txq_info_v2
+ * structures. CP configures requested queues and returns a status code. If
+ * num_qinfo specified is greater than the number of queues associated with the
+ * vport, an error is returned and no queues are configured.
+ */
+struct virtchnl_config_tx_queues {
+	u16 vport_id;
+	u16 num_qinfo;
+	u32 rsvd;
+	struct virtchnl_txq_info_v2 qinfo[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(48, virtchnl_config_tx_queues);
+
+/* Rx queue config info */
+struct virtchnl_rxq_info_v2 {
+	u16 queue_id;
+	/* single or split */
+	enum virtchnl_queue_model model;
+	/* Rx or Rx buffer */
+	enum virtchnl_queue_type type;
+	/* base or native */
+	enum virtchnl_desc_profile desc_profile;
+	/* rsc, header-split, immediate write back */
+	u16 queue_flags;
+	/* 16 or 32 byte */
+	enum virtchnl_rxq_desc_size desc_size;
+	u16 ring_len;
+	u16 hdr_buffer_size;
+	u32 data_buffer_size;
+	u32 max_pkt_size;
+	u64 dma_ring_addr;
+	u64 dma_head_wb_addr;
+	u16 rsc_low_watermark;
+	u8 buffer_notif_stride;
+	enum virtchnl_rx_hsplit rx_split_pos;
+	/* valid only if queue model is split and type is Rx buffer*/
+	u16 rx_bufq1_id;
+	/* valid only if queue model is split and type is Rx buffer*/
+	u16 rx_bufq2_id;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(72, virtchnl_rxq_info_v2);
+
+/* VIRTCHNL_OP_CONFIG_RX_QUEUES
+ * PF sends this message to set up parameters for one or more RX queues.
+ * This message contains an array of num_qinfo instances of virtchnl_rxq_info_v2
+ * structures. CP configures requested queues and returns a status code.
+ * If the number of queues specified is greater than the number of queues
+ * associated with the vport, an error is returned and no queues are configured.
+ */
+struct virtchnl_config_rx_queues {
+	u16 vport_id;
+	u16 num_qinfo;
+	struct virtchnl_rxq_info_v2 qinfo[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(80, virtchnl_config_rx_queues);
+
+/* VIRTCHNL_OP_ADD_QUEUES
+ * PF sends this message to request additional TX/RX queues beyond the ones
+ * that were assigned via CREATE_VPORT request. virtchnl_add_queues structure is
+ * used to specify the number of each type of queues.
+ * CP responds with the same structure with the actual number of queues assigned
+ * followed by num_chunks of virtchnl_queue_chunk structures.
+ */
+struct virtchnl_add_queues {
+	u16 vport_id;
+	u16 num_tx_q;
+	u16 num_tx_complq;
+	u16 num_rx_q;
+	u16 num_rx_bufq;
+	struct virtchnl_queue_chunks chunks;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(24, virtchnl_add_queues);
+
+/* VIRTCHNL_OP_ENABLE_QUEUES
+ * VIRTCHNL_OP_DISABLE_QUEUES
+ * VIRTCHNL_OP_DEL_QUEUES
+ * PF sends these messages to enable, disable or delete queues specified in
+ * chunks. PF sends virtchnl_del_ena_dis_queues struct to specify the queues
+ * to be enabled/disabled/deleted. Also applicable to single queue RX or
+ * TX. CP performs requested action and returns status.
+ */
+struct virtchnl_del_ena_dis_queues {
+	u16 vport_id;
+	struct virtchnl_queue_chunks chunks;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_del_ena_dis_queues);
+
+/* Virtchannel interrupt throttling rate index */
+enum virtchnl_itr_idx {
+	VIRTCHNL_ITR_IDX_0	= 0,
+	VIRTCHNL_ITR_IDX_1	= 1,
+	VIRTCHNL_ITR_IDX_NO_ITR	= 3,
+};
+
+/* Queue to vector mapping */
+struct virtchnl_queue_vector {
+	u16 queue_id;
+	u16 vector_id;
+	enum virtchnl_itr_idx itr_idx;
+	enum virtchnl_queue_type queue_type;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(12, virtchnl_queue_vector);
+
+/* VIRTCHNL_OP_MAP_QUEUE_VECTOR
+ * VIRTCHNL_OP_UNMAP_QUEUE_VECTOR
+ * PF sends this message to map or unmap queues to vectors and ITR index
+ * registers. External data buffer contains virtchnl_queue_vector_maps structure
+ * that contains num_maps of virtchnl_queue_vector structures.
+ * CP maps the requested queue vector maps after validating the queue and vector
+ * ids and returns a status code.
+ */
+struct virtchnl_queue_vector_maps {
+	u16 vport_id;
+	u16 num_maps;
+	struct virtchnl_queue_vector qv_maps[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_queue_vector_maps);
+
+/* Structure to specify a chunk of contiguous interrupt vectors */
+struct virtchnl_vector_chunk {
+	u16 start_vector_id;
+	u16 num_vectors;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(4, virtchnl_vector_chunk);
+
+/* Structure to specify several chunks of contiguous interrupt vectors */
+struct virtchnl_vector_chunks {
+	u16 num_vector_chunks;
+	struct virtchnl_vector_chunk num_vchunk[1];
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_vector_chunks);
+
+/* VIRTCHNL_OP_ALLOC_VECTORS
+ * PF sends this message to request additional interrupt vectors beyond the
+ * ones that were assigned via GET_CAPS request. virtchnl_alloc_vectors
+ * structure is used to specify the number of vectors requested. CP responds
+ * with the same structure with the actual number of vectors assigned followed
+ * by virtchnl_vector_chunks structure identifying the vector ids.
+ */
+struct virtchnl_alloc_vectors {
+	u16 num_vectors;
+	struct virtchnl_vector_chunks vchunks;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(8, virtchnl_alloc_vectors);
+
+/* VIRTCHNL_OP_DEALLOC_VECTORS
+ * PF sends this message to release the vectors.
+ * PF sends virtchnl_vector_chunks struct to specify the vectors it is giving
+ * away. CP performs requested action and returns status.
+ */
+
+/* VIRTCHNL_OP_GET_RSS_LUT
+ * VIRTCHNL_OP_SET_RSS_LUT
+ * PF sends this message to get or set RSS lookup table. Only supported if
+ * both PF and CP drivers set the VIRTCHNL_CAP_RSS bit during configuration
+ * negotiation. Uses the virtchnl_rss_lut_v2 structure
+ */
+struct virtchnl_rss_lut_v2 {
+	u16 vport_id;
+	u16 lut_entries;
+	u16 lut[1]; /* RSS lookup table */
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(6, virtchnl_rss_lut_v2);
+
+/* VIRTCHNL_OP_GET_RSS_KEY
+ * PF sends this message to get RSS key. Only supported if
+ * both PF and CP drivers set the VIRTCHNL_CAP_RSS bit during configuration
+ * negotiation. Uses the virtchnl_rss_key structure
+ */
+
+/* VIRTCHNL_OP_GET_RSS_HASH
+ * VIRTCHNL_OP_SET_RSS_HASH
+ * PF sends these messages to get and set the hash filter enable bits for RSS.
+ * By default, the CP sets these to all possible traffic types that the
+ * hardware supports. The PF can query this value if it wants to change the
+ * traffic types that are hashed by the hardware.
+ * Only supported if both PF and CP drivers set the VIRTCHNL_CAP_RSS bit
+ * during configuration negotiation.
+ */
+struct virtchnl_rss_hash {
+	u64 hash;
+	u16 vport_id;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(16, virtchnl_rss_hash);
+
+/* VIRTCHNL_OP_CREATE_SRIOV_VFS
+ * VIRTCHNL_OP_DESTROY_SRIOV_VFS
+ * This message is used to let the CP know how many SRIOV VFs need to be
+ * created. The actual allocation of resources for the VFs in terms of VSI,
+ * Queues and Interrupts is done by CP. When this call completes, the APF driver
+ * calls pci_enable_sriov to let the OS instantiate the SRIOV PCIE devices.
+ */
+struct virtchnl_sriov_vfs_info {
+	u16 num_vfs;
+};
+
+VIRTCHNL_CHECK_STRUCT_LEN(2, virtchnl_sriov_vfs_info);
+
 /**
  * virtchnl_vc_validate_vf_msg
  * @ver: Virtchnl version info
@@ -828,6 +1262,164 @@ virtchnl_vc_validate_vf_msg(struct virtchnl_version_info *ver, u32 v_opcode,
 	case VIRTCHNL_OP_DEL_CLOUD_FILTER:
 		valid_len = sizeof(struct virtchnl_filter);
 		break;
+	case VIRTCHNL_OP_GET_CAPS:
+		valid_len = sizeof(struct virtchnl_get_capabilities);
+		break;
+	case VIRTCHNL_OP_CREATE_VPORT:
+		valid_len = sizeof(struct virtchnl_create_vport);
+		if (msglen >= valid_len) {
+			struct virtchnl_create_vport *cvport =
+				(struct virtchnl_create_vport *)msg;
+
+			if (cvport->chunks.num_chunks == 0) {
+				/* zero chunks is allowed as input */
+				break;
+			}
+
+			valid_len += (cvport->chunks.num_chunks - 1) *
+				sizeof(struct virtchnl_queue_chunk);
+		}
+		break;
+	case VIRTCHNL_OP_DESTROY_VPORT:
+	case VIRTCHNL_OP_ENABLE_VPORT:
+	case VIRTCHNL_OP_DISABLE_VPORT:
+		valid_len = sizeof(struct virtchnl_vport);
+		break;
+	case VIRTCHNL_OP_CONFIG_TX_QUEUES:
+		valid_len = sizeof(struct virtchnl_config_tx_queues);
+		if (msglen >= valid_len) {
+			struct virtchnl_config_tx_queues *ctq =
+				(struct virtchnl_config_tx_queues *)msg;
+			if (ctq->num_qinfo == 0) {
+				err_msg_format = true;
+				break;
+			}
+			valid_len += (ctq->num_qinfo - 1) *
+				sizeof(struct virtchnl_txq_info_v2);
+		}
+		break;
+	case VIRTCHNL_OP_CONFIG_RX_QUEUES:
+		valid_len = sizeof(struct virtchnl_config_rx_queues);
+		if (msglen >= valid_len) {
+			struct virtchnl_config_rx_queues *crq =
+				(struct virtchnl_config_rx_queues *)msg;
+			if (crq->num_qinfo == 0) {
+				err_msg_format = true;
+				break;
+			}
+			valid_len += (crq->num_qinfo - 1) *
+				sizeof(struct virtchnl_rxq_info_v2);
+		}
+		break;
+	case VIRTCHNL_OP_ADD_QUEUES:
+		valid_len = sizeof(struct virtchnl_add_queues);
+		if (msglen >= valid_len) {
+			struct virtchnl_add_queues *add_q =
+				(struct virtchnl_add_queues *)msg;
+
+			if (add_q->chunks.num_chunks == 0) {
+				/* zero chunks is allowed as input */
+				break;
+			}
+
+			valid_len += (add_q->chunks.num_chunks - 1) *
+				sizeof(struct virtchnl_queue_chunk);
+		}
+		break;
+	case VIRTCHNL_OP_ENABLE_QUEUES_V2:
+	case VIRTCHNL_OP_DISABLE_QUEUES_V2:
+	case VIRTCHNL_OP_DEL_QUEUES:
+		valid_len = sizeof(struct virtchnl_del_ena_dis_queues);
+		if (msglen >= valid_len) {
+			struct virtchnl_del_ena_dis_queues *qs =
+				(struct virtchnl_del_ena_dis_queues *)msg;
+			if (qs->chunks.num_chunks == 0) {
+				err_msg_format = true;
+				break;
+			}
+			valid_len += (qs->chunks.num_chunks - 1) *
+				sizeof(struct virtchnl_queue_chunk);
+		}
+		break;
+	case VIRTCHNL_OP_MAP_QUEUE_VECTOR:
+	case VIRTCHNL_OP_UNMAP_QUEUE_VECTOR:
+		valid_len = sizeof(struct virtchnl_queue_vector_maps);
+		if (msglen >= valid_len) {
+			struct virtchnl_queue_vector_maps *v_qp =
+				(struct virtchnl_queue_vector_maps *)msg;
+			if (v_qp->num_maps == 0) {
+				err_msg_format = true;
+				break;
+			}
+			valid_len += (v_qp->num_maps - 1) *
+				sizeof(struct virtchnl_queue_vector);
+		}
+		break;
+	case VIRTCHNL_OP_ALLOC_VECTORS:
+		valid_len = sizeof(struct virtchnl_alloc_vectors);
+		if (msglen >= valid_len) {
+			struct virtchnl_alloc_vectors *v_av =
+				(struct virtchnl_alloc_vectors *)msg;
+
+			if (v_av->vchunks.num_vector_chunks == 0) {
+				/* zero chunks is allowed as input */
+				break;
+			}
+
+			valid_len += (v_av->vchunks.num_vector_chunks - 1) *
+				sizeof(struct virtchnl_vector_chunk);
+		}
+		break;
+	case VIRTCHNL_OP_DEALLOC_VECTORS:
+		valid_len = sizeof(struct virtchnl_vector_chunks);
+		if (msglen >= valid_len) {
+			struct virtchnl_vector_chunks *v_chunks =
+				(struct virtchnl_vector_chunks *)msg;
+			if (v_chunks->num_vector_chunks == 0) {
+				err_msg_format = true;
+				break;
+			}
+			valid_len += (v_chunks->num_vector_chunks - 1) *
+				sizeof(struct virtchnl_vector_chunk);
+		}
+		break;
+	case VIRTCHNL_OP_GET_RSS_KEY:
+		valid_len = sizeof(struct virtchnl_rss_key);
+		if (msglen >= valid_len) {
+			struct virtchnl_rss_key *vrk =
+				(struct virtchnl_rss_key *)msg;
+
+			if (vrk->key_len == 0) {
+				/* zero length is allowed as input */
+				break;
+			}
+
+			valid_len += vrk->key_len - 1;
+		}
+		break;
+	case VIRTCHNL_OP_GET_RSS_LUT:
+	case VIRTCHNL_OP_SET_RSS_LUT:
+		valid_len = sizeof(struct virtchnl_rss_lut_v2);
+		if (msglen >= valid_len) {
+			struct virtchnl_rss_lut_v2 *vrl =
+				(struct virtchnl_rss_lut_v2 *)msg;
+
+			if (vrl->lut_entries == 0) {
+				/* zero entries is allowed as input */
+				break;
+			}
+
+			valid_len += (vrl->lut_entries - 1) * sizeof(u16);
+		}
+		break;
+	case VIRTCHNL_OP_GET_RSS_HASH:
+	case VIRTCHNL_OP_SET_RSS_HASH:
+		valid_len = sizeof(struct virtchnl_rss_hash);
+		break;
+	case VIRTCHNL_OP_CREATE_VFS:
+	case VIRTCHNL_OP_DESTROY_VFS:
+		valid_len = sizeof(struct virtchnl_sriov_vfs_info);
+		break;
 	/* These are always errors coming from the VF. */
 	case VIRTCHNL_OP_EVENT:
 	case VIRTCHNL_OP_UNKNOWN:
-- 
2.26.2


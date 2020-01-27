Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779CB14A509
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgA0N05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:26:57 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:6762 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726725AbgA0N0z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:26:55 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00RDQbv0032252;
        Mon, 27 Jan 2020 05:26:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=WJbRjhdgLxEmNFUWNpGmmkmJTVrIyzVXyPpRJq8SASE=;
 b=MoA3DabmMhAtojVSCpfdTi5a6mT0UJGNh8jndLp0O8xqXNbct20qiZbTN5Gb180LKoOg
 lI35q4z8Gn5MvmJ2CznwjGkZrzhKD7S7XBX0wx8F7Cq+dCWq1EnSpOWq3UfWvosvxTwp
 3ToPGjbKVCO/PzbORDrVAypF9su2YU6by7CunADZwXq7uGvp2FOW1PjSXqCZkHev/4yt
 m/2Ne04BRJWEmukVj0009+HRQ2ftwcl1aF5BanI5VvLC4wqVgDJDlr/+mg1Sx/soJF6U
 0L/FQoQlKNQzIFPvi8e8WEbbuyThIThGpVvoAH5ZT700kuB/cNDQx7e9R/AWOBinCUXS Kg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2xrp2sxxvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 27 Jan 2020 05:26:51 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jan
 2020 05:26:48 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 27 Jan 2020 05:26:48 -0800
Received: from lb-tlvb-michal.il.qlogic.org (unknown [10.5.220.215])
        by maili.marvell.com (Postfix) with ESMTP id 0AD5D3F703F;
        Mon, 27 Jan 2020 05:26:46 -0800 (PST)
From:   Michal Kalderon <michal.kalderon@marvell.com>
To:     <michal.kalderon@marvell.com>, <ariel.elior@marvell.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>
Subject: [PATCH v3 net-next 09/13] qed: FW 8.42.2.0 HSI changes
Date:   Mon, 27 Jan 2020 15:26:15 +0200
Message-ID: <20200127132619.27144-10-michal.kalderon@marvell.com>
X-Mailer: git-send-email 2.14.5
In-Reply-To: <20200127132619.27144-1-michal.kalderon@marvell.com>
References: <20200127132619.27144-1-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-27_02:2020-01-24,2020-01-27 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch contains several HSI changes. The changes are part of
features like RDMA VF and OVS, the patch also contains a fix to
how the init code determines if the dmae is ready to be used.

Signed-off-by: Ariel Elior <ariel.elior@marvell.com>
Signed-off-by: Michal Kalderon <michal.kalderon@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_hsi.h      | 317 ++++++++++++++++---------
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c |   6 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c      |   2 +
 drivers/net/ethernet/qlogic/qed/qed_roce.c     |   2 +-
 drivers/net/ethernet/qlogic/qede/qede_fp.c     |   8 +-
 include/linux/qed/common_hsi.h                 |  21 +-
 include/linux/qed/eth_common.h                 |  78 ++++--
 7 files changed, 280 insertions(+), 154 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_hsi.h b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
index 0c3d714e6518..06b94508115a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_hsi.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_hsi.h
@@ -250,7 +250,8 @@ struct core_rx_gsi_offload_cqe {
 	__le16 src_mac_addrlo;
 	__le16 qp_id;
 	__le32 src_qp;
-	__le32 reserved[3];
+	struct core_rx_cqe_opaque_data opaque_data;
+	__le32 reserved;
 };
 
 /* Core RX CQE for Light L2 */
@@ -405,7 +406,7 @@ struct ystorm_core_conn_st_ctx {
 
 /* The core storm context for the Pstorm */
 struct pstorm_core_conn_st_ctx {
-	__le32 reserved[4];
+	__le32 reserved[20];
 };
 
 /* Core Slowpath Connection storm context of Xstorm */
@@ -856,12 +857,12 @@ struct e4_ustorm_core_conn_ag_ctx {
 
 /* The core storm context for the Mstorm */
 struct mstorm_core_conn_st_ctx {
-	__le32 reserved[24];
+	__le32 reserved[40];
 };
 
 /* The core storm context for the Ustorm */
 struct ustorm_core_conn_st_ctx {
-	__le32 reserved[4];
+	__le32 reserved[20];
 };
 
 /* The core storm context for the Tstorm */
@@ -915,12 +916,21 @@ struct eth_pstorm_per_pf_stat {
 	struct regpair sent_gre_bytes;
 	struct regpair sent_vxlan_bytes;
 	struct regpair sent_geneve_bytes;
+	struct regpair sent_mpls_bytes;
+	struct regpair sent_gre_mpls_bytes;
+	struct regpair sent_udp_mpls_bytes;
 	struct regpair sent_gre_pkts;
 	struct regpair sent_vxlan_pkts;
 	struct regpair sent_geneve_pkts;
+	struct regpair sent_mpls_pkts;
+	struct regpair sent_gre_mpls_pkts;
+	struct regpair sent_udp_mpls_pkts;
 	struct regpair gre_drop_pkts;
 	struct regpair vxlan_drop_pkts;
 	struct regpair geneve_drop_pkts;
+	struct regpair mpls_drop_pkts;
+	struct regpair gre_mpls_drop_pkts;
+	struct regpair udp_mpls_drop_pkts;
 };
 
 /* Ethernet TX Per Queue Stats */
@@ -1010,7 +1020,8 @@ union event_ring_data {
 struct event_ring_entry {
 	u8 protocol_id;
 	u8 opcode;
-	__le16 reserved0;
+	u8 reserved0;
+	u8 vf_id;
 	__le16 echo;
 	u8 fw_return_code;
 	u8 flags;
@@ -1088,7 +1099,20 @@ enum malicious_vf_error_id {
 	ETH_CONTROL_PACKET_VIOLATION,
 	ETH_ANTI_SPOOFING_ERR,
 	ETH_PACKET_SIZE_TOO_LARGE,
-	MAX_MALICIOUS_VF_ERROR_ID
+	CORE_ILLEGAL_VLAN_MODE,
+	CORE_ILLEGAL_NBDS,
+	CORE_FIRST_BD_WO_SOP,
+	CORE_INSUFFICIENT_BDS,
+	CORE_PACKET_TOO_SMALL,
+	CORE_ILLEGAL_INBAND_TAGS,
+	CORE_VLAN_INSERT_AND_INBAND_VLAN,
+	CORE_MTU_VIOLATION,
+	CORE_CONTROL_PACKET_VIOLATION,
+	CORE_ANTI_SPOOFING_ERR,
+	CORE_PACKET_SIZE_TOO_LARGE,
+	CORE_ILLEGAL_BD_FLAGS,
+	CORE_GSI_PACKET_VIOLATION,
+	MAX_MALICIOUS_VF_ERROR_ID,
 };
 
 /* Mstorm non-triggering VF zone */
@@ -1394,6 +1418,16 @@ enum vf_zone_size_mode {
 	MAX_VF_ZONE_SIZE_MODE
 };
 
+/* Xstorm non-triggering VF zone */
+struct xstorm_non_trigger_vf_zone {
+	struct regpair non_edpm_ack_pkts;
+};
+
+/* Tstorm VF zone */
+struct xstorm_vf_zone {
+	struct xstorm_non_trigger_vf_zone non_trigger;
+};
+
 /* Attentions status block */
 struct atten_status_block {
 	__le32 atten_bits;
@@ -2748,8 +2782,8 @@ enum chip_ids {
 };
 
 struct fw_asserts_ram_section {
-	u16 section_ram_line_offset;
-	u16 section_ram_line_size;
+	__le16 section_ram_line_offset;
+	__le16 section_ram_line_size;
 	u8 list_dword_offset;
 	u8 list_element_dword_size;
 	u8 list_num_elements;
@@ -2799,6 +2833,7 @@ enum init_modes {
 	MODE_PORTS_PER_ENG_4,
 	MODE_100G,
 	MODE_RESERVED6,
+	MODE_RESERVED7,
 	MAX_INIT_MODES
 };
 
@@ -2833,6 +2868,7 @@ enum bin_init_buffer_type {
 	BIN_BUF_INIT_VAL,
 	BIN_BUF_INIT_MODE_TREE,
 	BIN_BUF_INIT_IRO,
+	BIN_BUF_INIT_OVERLAYS,
 	MAX_BIN_INIT_BUFFER_TYPE
 };
 
@@ -2929,10 +2965,8 @@ struct init_if_phase_op {
 	u32 op_data;
 #define INIT_IF_PHASE_OP_OP_MASK		0xF
 #define INIT_IF_PHASE_OP_OP_SHIFT		0
-#define INIT_IF_PHASE_OP_DMAE_ENABLE_MASK	0x1
-#define INIT_IF_PHASE_OP_DMAE_ENABLE_SHIFT	4
-#define INIT_IF_PHASE_OP_RESERVED1_MASK		0x7FF
-#define INIT_IF_PHASE_OP_RESERVED1_SHIFT	5
+#define INIT_IF_PHASE_OP_RESERVED1_MASK		0xFFF
+#define INIT_IF_PHASE_OP_RESERVED1_SHIFT	4
 #define INIT_IF_PHASE_OP_CMD_OFFSET_MASK	0xFFFF
 #define INIT_IF_PHASE_OP_CMD_OFFSET_SHIFT	16
 	u32 phase_data;
@@ -4226,7 +4260,7 @@ void qed_gft_disable(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt, u16 pf_id);
 /**
  * @brief qed_gft_config - Enable and configure HW for GFT
  *
- * @param p_hwfn
+ * @param p_hwfn - HW device data
  * @param p_ptt - ptt window used for writing the registers.
  * @param pf_id - pf on which to enable GFT.
  * @param tcp - set profile tcp packets.
@@ -5673,9 +5707,9 @@ struct e4_eth_conn_context {
 	struct pstorm_eth_conn_st_ctx pstorm_st_context;
 	struct xstorm_eth_conn_st_ctx xstorm_st_context;
 	struct e4_xstorm_eth_conn_ag_ctx xstorm_ag_context;
+	struct e4_tstorm_eth_conn_ag_ctx tstorm_ag_context;
 	struct ystorm_eth_conn_st_ctx ystorm_st_context;
 	struct e4_ystorm_eth_conn_ag_ctx ystorm_ag_context;
-	struct e4_tstorm_eth_conn_ag_ctx tstorm_ag_context;
 	struct e4_ustorm_eth_conn_ag_ctx ustorm_ag_context;
 	struct ustorm_eth_conn_st_ctx ustorm_st_context;
 	struct mstorm_eth_conn_st_ctx mstorm_st_context;
@@ -5705,6 +5739,16 @@ enum eth_error_code {
 	ETH_FILTERS_VNI_ADD_FAIL_FULL,
 	ETH_FILTERS_VNI_ADD_FAIL_DUP,
 	ETH_FILTERS_GFT_UPDATE_FAIL,
+	ETH_RX_QUEUE_FAIL_LOAD_VF_DATA,
+	ETH_FILTERS_GFS_ADD_FILTER_FAIL_MAX_HOPS,
+	ETH_FILTERS_GFS_ADD_FILTER_FAIL_NO_FREE_ENRTY,
+	ETH_FILTERS_GFS_ADD_FILTER_FAIL_ALREADY_EXISTS,
+	ETH_FILTERS_GFS_ADD_FILTER_FAIL_PCI_ERROR,
+	ETH_FILTERS_GFS_ADD_FINLER_FAIL_MAGIC_NUM_ERROR,
+	ETH_FILTERS_GFS_DEL_FILTER_FAIL_MAX_HOPS,
+	ETH_FILTERS_GFS_DEL_FILTER_FAIL_NO_MATCH_ENRTY,
+	ETH_FILTERS_GFS_DEL_FILTER_FAIL_PCI_ERROR,
+	ETH_FILTERS_GFS_DEL_FILTER_FAIL_MAGIC_NUM_ERROR,
 	MAX_ETH_ERROR_CODE
 };
 
@@ -5728,6 +5772,11 @@ enum eth_event_opcode {
 	ETH_EVENT_RX_CREATE_GFT_ACTION,
 	ETH_EVENT_RX_GFT_UPDATE_FILTER,
 	ETH_EVENT_TX_QUEUE_UPDATE,
+	ETH_EVENT_RGFS_ADD_FILTER,
+	ETH_EVENT_RGFS_DEL_FILTER,
+	ETH_EVENT_TGFS_ADD_FILTER,
+	ETH_EVENT_TGFS_DEL_FILTER,
+	ETH_EVENT_GFS_COUNTERS_REPORT_REQUEST,
 	MAX_ETH_EVENT_OPCODE
 };
 
@@ -5820,18 +5869,31 @@ enum eth_ramrod_cmd_id {
 	ETH_RAMROD_RX_CREATE_GFT_ACTION,
 	ETH_RAMROD_GFT_UPDATE_FILTER,
 	ETH_RAMROD_TX_QUEUE_UPDATE,
+	ETH_RAMROD_RGFS_FILTER_ADD,
+	ETH_RAMROD_RGFS_FILTER_DEL,
+	ETH_RAMROD_TGFS_FILTER_ADD,
+	ETH_RAMROD_TGFS_FILTER_DEL,
+	ETH_RAMROD_GFS_COUNTERS_REPORT_REQUEST,
 	MAX_ETH_RAMROD_CMD_ID
 };
 
 /* Return code from eth sp ramrods */
 struct eth_return_code {
 	u8 value;
-#define ETH_RETURN_CODE_ERR_CODE_MASK	0x1F
-#define ETH_RETURN_CODE_ERR_CODE_SHIFT	0
-#define ETH_RETURN_CODE_RESERVED_MASK	0x3
-#define ETH_RETURN_CODE_RESERVED_SHIFT	5
-#define ETH_RETURN_CODE_RX_TX_MASK	0x1
-#define ETH_RETURN_CODE_RX_TX_SHIFT	7
+#define ETH_RETURN_CODE_ERR_CODE_MASK  0x3F
+#define ETH_RETURN_CODE_ERR_CODE_SHIFT 0
+#define ETH_RETURN_CODE_RESERVED_MASK  0x1
+#define ETH_RETURN_CODE_RESERVED_SHIFT 6
+#define ETH_RETURN_CODE_RX_TX_MASK     0x1
+#define ETH_RETURN_CODE_RX_TX_SHIFT    7
+};
+
+/* tx destination enum */
+enum eth_tx_dst_mode_config_enum {
+	ETH_TX_DST_MODE_CONFIG_DISABLE,
+	ETH_TX_DST_MODE_CONFIG_FORWARD_DATA_IN_BD,
+	ETH_TX_DST_MODE_CONFIG_FORWARD_DATA_IN_VPORT,
+	MAX_ETH_TX_DST_MODE_CONFIG_ENUM
 };
 
 /* What to do in case an error occurs */
@@ -5858,8 +5920,10 @@ struct eth_tx_err_vals {
 #define ETH_TX_ERR_VALS_MTU_VIOLATION_SHIFT			5
 #define ETH_TX_ERR_VALS_ILLEGAL_CONTROL_FRAME_MASK		0x1
 #define ETH_TX_ERR_VALS_ILLEGAL_CONTROL_FRAME_SHIFT		6
-#define ETH_TX_ERR_VALS_RESERVED_MASK				0x1FF
-#define ETH_TX_ERR_VALS_RESERVED_SHIFT				7
+#define ETH_TX_ERR_VALS_ILLEGAL_BD_FLAGS_MASK			0x1
+#define ETH_TX_ERR_VALS_ILLEGAL_BD_FLAGS_SHIFT			7
+#define ETH_TX_ERR_VALS_RESERVED_MASK				0xFF
+#define ETH_TX_ERR_VALS_RESERVED_SHIFT				8
 };
 
 /* vport rss configuration data */
@@ -5889,7 +5953,6 @@ struct eth_vport_rss_config {
 	u8 tbl_size;
 	__le32 reserved2[2];
 	__le16 indirection_table[ETH_RSS_IND_TABLE_ENTRIES_NUM];
-
 	__le32 rss_key[ETH_RSS_KEY_SIZE_REGS];
 	__le32 reserved3[2];
 };
@@ -6091,7 +6154,7 @@ struct rx_update_gft_filter_data {
 	u8 inner_vlan_removal_en;
 };
 
-/* Ramrod data for rx queue start ramrod */
+/* Ramrod data for tx queue start ramrod */
 struct tx_queue_start_ramrod_data {
 	__le16 sb_id;
 	u8 sb_index;
@@ -6104,16 +6167,14 @@ struct tx_queue_start_ramrod_data {
 #define TX_QUEUE_START_RAMROD_DATA_DISABLE_OPPORTUNISTIC_SHIFT	0
 #define TX_QUEUE_START_RAMROD_DATA_TEST_MODE_PKT_DUP_MASK	0x1
 #define TX_QUEUE_START_RAMROD_DATA_TEST_MODE_PKT_DUP_SHIFT	1
-#define TX_QUEUE_START_RAMROD_DATA_TEST_MODE_TX_DEST_MASK	0x1
-#define TX_QUEUE_START_RAMROD_DATA_TEST_MODE_TX_DEST_SHIFT	2
 #define TX_QUEUE_START_RAMROD_DATA_PMD_MODE_MASK		0x1
-#define TX_QUEUE_START_RAMROD_DATA_PMD_MODE_SHIFT		3
+#define TX_QUEUE_START_RAMROD_DATA_PMD_MODE_SHIFT		2
 #define TX_QUEUE_START_RAMROD_DATA_NOTIFY_EN_MASK		0x1
-#define TX_QUEUE_START_RAMROD_DATA_NOTIFY_EN_SHIFT		4
+#define TX_QUEUE_START_RAMROD_DATA_NOTIFY_EN_SHIFT		3
 #define TX_QUEUE_START_RAMROD_DATA_PIN_CONTEXT_MASK		0x1
-#define TX_QUEUE_START_RAMROD_DATA_PIN_CONTEXT_SHIFT		5
-#define TX_QUEUE_START_RAMROD_DATA_RESERVED1_MASK		0x3
-#define TX_QUEUE_START_RAMROD_DATA_RESERVED1_SHIFT		6
+#define TX_QUEUE_START_RAMROD_DATA_PIN_CONTEXT_SHIFT		4
+#define TX_QUEUE_START_RAMROD_DATA_RESERVED1_MASK		0x7
+#define TX_QUEUE_START_RAMROD_DATA_RESERVED1_SHIFT		5
 	u8 pxp_st_hint;
 	u8 pxp_tph_valid_bd;
 	u8 pxp_tph_valid_pkt;
@@ -6169,18 +6230,22 @@ struct vport_start_ramrod_data {
 	__le16 default_vlan;
 	u8 tx_switching_en;
 	u8 anti_spoofing_en;
-
 	u8 default_vlan_en;
-
 	u8 handle_ptp_pkts;
 	u8 silent_vlan_removal_en;
 	u8 untagged;
 	struct eth_tx_err_vals tx_err_behav;
-
 	u8 zero_placement_offset;
 	u8 ctl_frame_mac_check_en;
 	u8 ctl_frame_ethtype_check_en;
+	u8 reserved0;
+	u8 reserved1;
+	u8 tx_dst_port_mode_config;
+	u8 dst_vport_id;
+	u8 tx_dst_port_mode;
+	u8 dst_vport_id_valid;
 	u8 wipe_inner_vlan_pri_en;
+	u8 reserved2[2];
 	struct eth_in_to_in_pri_map_cfg in_to_in_vlan_pri_map_cfg;
 };
 
@@ -6740,19 +6805,6 @@ struct e4_xstorm_eth_hw_conn_ag_ctx {
 	__le16 conn_dpi;
 };
 
-/* GFT CAM line struct */
-struct gft_cam_line {
-	__le32 camline;
-#define GFT_CAM_LINE_VALID_MASK		0x1
-#define GFT_CAM_LINE_VALID_SHIFT	0
-#define GFT_CAM_LINE_DATA_MASK		0x3FFF
-#define GFT_CAM_LINE_DATA_SHIFT		1
-#define GFT_CAM_LINE_MASK_BITS_MASK	0x3FFF
-#define GFT_CAM_LINE_MASK_BITS_SHIFT	15
-#define GFT_CAM_LINE_RESERVED1_MASK	0x7
-#define GFT_CAM_LINE_RESERVED1_SHIFT	29
-};
-
 /* GFT CAM line struct with fields breakout */
 struct gft_cam_line_mapped {
 	__le32 camline;
@@ -6782,10 +6834,6 @@ struct gft_cam_line_mapped {
 #define GFT_CAM_LINE_MAPPED_RESERVED1_SHIFT			29
 };
 
-union gft_cam_line_union {
-	struct gft_cam_line cam_line;
-	struct gft_cam_line_mapped cam_line_mapped;
-};
 
 /* Used in gft_profile_key: Indication for ip version */
 enum gft_profile_ip_version {
@@ -7064,6 +7112,11 @@ struct mstorm_rdma_task_st_ctx {
 	struct regpair temp[4];
 };
 
+/* The roce task context of Ustorm */
+struct ustorm_rdma_task_st_ctx {
+	struct regpair temp[6];
+};
+
 struct e4_ustorm_rdma_task_ag_ctx {
 	u8 reserved;
 	u8 state;
@@ -7073,8 +7126,8 @@ struct e4_ustorm_rdma_task_ag_ctx {
 #define E4_USTORM_RDMA_TASK_AG_CTX_CONNECTION_TYPE_SHIFT	0
 #define E4_USTORM_RDMA_TASK_AG_CTX_EXIST_IN_QM0_MASK		0x1
 #define E4_USTORM_RDMA_TASK_AG_CTX_EXIST_IN_QM0_SHIFT		4
-#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_RUNT_VALID_MASK		0x1
-#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_RUNT_VALID_SHIFT		5
+#define E4_USTORM_RDMA_TASK_AG_CTX_BIT1_MASK			0x1
+#define E4_USTORM_RDMA_TASK_AG_CTX_BIT1_SHIFT			5
 #define E4_USTORM_RDMA_TASK_AG_CTX_DIF_WRITE_RESULT_CF_MASK	0x3
 #define E4_USTORM_RDMA_TASK_AG_CTX_DIF_WRITE_RESULT_CF_SHIFT	6
 	u8 flags1;
@@ -7104,29 +7157,29 @@ struct e4_ustorm_rdma_task_ag_ctx {
 #define E4_USTORM_RDMA_TASK_AG_CTX_RULE2EN_MASK			0x1
 #define E4_USTORM_RDMA_TASK_AG_CTX_RULE2EN_SHIFT		7
 	u8 flags3;
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE3EN_MASK		0x1
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE3EN_SHIFT	0
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE4EN_MASK		0x1
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE4EN_SHIFT	1
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE5EN_MASK		0x1
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE5EN_SHIFT	2
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE6EN_MASK		0x1
-#define E4_USTORM_RDMA_TASK_AG_CTX_RULE6EN_SHIFT	3
-#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_ERROR_TYPE_MASK	0xF
-#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_ERROR_TYPE_SHIFT	4
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_RXMIT_PROD_CONS_EN_MASK	0x1
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_RXMIT_PROD_CONS_EN_SHIFT	0
+#define E4_USTORM_RDMA_TASK_AG_CTX_RULE4EN_MASK			0x1
+#define E4_USTORM_RDMA_TASK_AG_CTX_RULE4EN_SHIFT		1
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_WRITE_PROD_CONS_EN_MASK	0x1
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_WRITE_PROD_CONS_EN_SHIFT	2
+#define E4_USTORM_RDMA_TASK_AG_CTX_RULE6EN_MASK			0x1
+#define E4_USTORM_RDMA_TASK_AG_CTX_RULE6EN_SHIFT		3
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_ERROR_TYPE_MASK		0xF
+#define E4_USTORM_RDMA_TASK_AG_CTX_DIF_ERROR_TYPE_SHIFT		4
 	__le32 dif_err_intervals;
 	__le32 dif_error_1st_interval;
-	__le32 sq_cons;
-	__le32 dif_runt_value;
+	__le32 dif_rxmit_cons;
+	__le32 dif_rxmit_prod;
 	__le32 sge_index;
-	__le32 reg5;
+	__le32 sq_cons;
 	u8 byte2;
 	u8 byte3;
-	__le16 word1;
-	__le16 word2;
+	__le16 dif_write_cons;
+	__le16 dif_write_prod;
 	__le16 word3;
-	__le32 reg6;
-	__le32 reg7;
+	__le32 dif_error_buffer_address_lo;
+	__le32 dif_error_buffer_address_hi;
 };
 
 /* RDMA task context */
@@ -7137,6 +7190,8 @@ struct e4_rdma_task_context {
 	struct e4_mstorm_rdma_task_ag_ctx mstorm_ag_context;
 	struct mstorm_rdma_task_st_ctx mstorm_st_context;
 	struct rdif_task_context rdif_context;
+	struct ustorm_rdma_task_st_ctx ustorm_st_context;
+	struct regpair ustorm_st_padding[2];
 	struct e4_ustorm_rdma_task_ag_ctx ustorm_ag_context;
 };
 
@@ -7172,7 +7227,12 @@ struct rdma_create_cq_ramrod_data {
 	u8 pbl_log_page_size;
 	u8 toggle_bit;
 	__le16 int_timeout;
-	__le16 reserved1;
+	u8 vf_id;
+	u8 flags;
+#define RDMA_CREATE_CQ_RAMROD_DATA_VF_ID_VALID_MASK  0x1
+#define RDMA_CREATE_CQ_RAMROD_DATA_VF_ID_VALID_SHIFT 0
+#define RDMA_CREATE_CQ_RAMROD_DATA_RESERVED1_MASK    0x7F
+#define RDMA_CREATE_CQ_RAMROD_DATA_RESERVED1_SHIFT   1
 };
 
 /* rdma deregister tid ramrod data */
@@ -7216,6 +7276,7 @@ enum rdma_fw_return_code {
 	RDMA_RETURN_DEREGISTER_MR_BAD_STATE_ERR,
 	RDMA_RETURN_RESIZE_CQ_ERR,
 	RDMA_RETURN_NIG_DRAIN_REQ,
+	RDMA_RETURN_GENERAL_ERR,
 	MAX_RDMA_FW_RETURN_CODE
 };
 
@@ -7229,7 +7290,10 @@ struct rdma_init_func_hdr {
 	u8 relaxed_ordering;
 	__le16 first_reg_srq_id;
 	__le32 reg_srq_base_addr;
-	__le32 reserved;
+	u8 searcher_mode;
+	u8 pvrdma_mode;
+	u8 max_num_ns_log;
+	u8 reserved;
 };
 
 /* rdma function init ramrod data */
@@ -7319,16 +7383,20 @@ struct rdma_resize_cq_ramrod_data {
 #define RDMA_RESIZE_CQ_RAMROD_DATA_TOGGLE_BIT_SHIFT		0
 #define RDMA_RESIZE_CQ_RAMROD_DATA_IS_TWO_LEVEL_PBL_MASK	0x1
 #define RDMA_RESIZE_CQ_RAMROD_DATA_IS_TWO_LEVEL_PBL_SHIFT	1
-#define RDMA_RESIZE_CQ_RAMROD_DATA_RESERVED_MASK		0x3F
-#define RDMA_RESIZE_CQ_RAMROD_DATA_RESERVED_SHIFT		2
+#define RDMA_RESIZE_CQ_RAMROD_DATA_VF_ID_VALID_MASK		0x1
+#define RDMA_RESIZE_CQ_RAMROD_DATA_VF_ID_VALID_SHIFT		2
+#define RDMA_RESIZE_CQ_RAMROD_DATA_RESERVED_MASK		0x1F
+#define RDMA_RESIZE_CQ_RAMROD_DATA_RESERVED_SHIFT		3
 	u8 pbl_log_page_size;
 	__le16 pbl_num_pages;
 	__le32 max_cqes;
 	struct regpair pbl_addr;
 	struct regpair output_params_addr;
+	u8 vf_id;
+	u8 reserved1[7];
 };
 
-/* The rdma storm context of Mstorm */
+/* The rdma SRQ context */
 struct rdma_srq_context {
 	struct regpair temp[8];
 };
@@ -7375,6 +7443,7 @@ enum rdma_tid_type {
 	MAX_RDMA_TID_TYPE
 };
 
+/* The rdma XRC SRQ context */
 struct rdma_xrc_srq_context {
 	struct regpair temp[9];
 };
@@ -7556,12 +7625,12 @@ struct e4_xstorm_roce_conn_ag_ctx {
 #define E4_XSTORM_ROCE_CONN_AG_CTX_BIT10_SHIFT            2
 #define E4_XSTORM_ROCE_CONN_AG_CTX_BIT11_MASK             0x1
 #define E4_XSTORM_ROCE_CONN_AG_CTX_BIT11_SHIFT            3
-#define E4_XSTORM_ROCE_CONN_AG_CTX_BIT12_MASK             0x1
-#define E4_XSTORM_ROCE_CONN_AG_CTX_BIT12_SHIFT            4
+#define E4_XSTORM_ROCE_CONN_AG_CTX_MSDM_FLUSH_MASK        0x1
+#define E4_XSTORM_ROCE_CONN_AG_CTX_MSDM_FLUSH_SHIFT       4
 #define E4_XSTORM_ROCE_CONN_AG_CTX_MSEM_FLUSH_MASK        0x1
 #define E4_XSTORM_ROCE_CONN_AG_CTX_MSEM_FLUSH_SHIFT       5
-#define E4_XSTORM_ROCE_CONN_AG_CTX_MSDM_FLUSH_MASK        0x1
-#define E4_XSTORM_ROCE_CONN_AG_CTX_MSDM_FLUSH_SHIFT       6
+#define E4_XSTORM_ROCE_CONN_AG_CTX_BIT14_MASK	       0x1
+#define E4_XSTORM_ROCE_CONN_AG_CTX_BIT14_SHIFT	       6
 #define E4_XSTORM_ROCE_CONN_AG_CTX_YSTORM_FLUSH_MASK      0x1
 #define E4_XSTORM_ROCE_CONN_AG_CTX_YSTORM_FLUSH_SHIFT     7
 	u8 flags2;
@@ -7885,9 +7954,9 @@ struct mstorm_roce_conn_st_ctx {
 	struct regpair temp[6];
 };
 
-/* The roce storm context of Ystorm */
+/* The roce storm context of Ustorm */
 struct ustorm_roce_conn_st_ctx {
-	struct regpair temp[12];
+	struct regpair temp[14];
 };
 
 /* roce connection context */
@@ -7905,6 +7974,7 @@ struct e4_roce_conn_context {
 	struct mstorm_roce_conn_st_ctx mstorm_st_context;
 	struct regpair mstorm_st_padding[2];
 	struct ustorm_roce_conn_st_ctx ustorm_st_context;
+	struct regpair ustorm_st_padding[2];
 };
 
 /* roce cqes statistics */
@@ -7959,12 +8029,17 @@ struct roce_create_qp_req_ramrod_data {
 	struct regpair qp_handle_for_cqe;
 	struct regpair qp_handle_for_async;
 	u8 stats_counter_id;
-	u8 reserved3[6];
+	u8 vf_id;
+	u8 vport_id;
 	u8 flags2;
 #define ROCE_CREATE_QP_REQ_RAMROD_DATA_EDPM_MODE_MASK			0x1
 #define ROCE_CREATE_QP_REQ_RAMROD_DATA_EDPM_MODE_SHIFT			0
-#define ROCE_CREATE_QP_REQ_RAMROD_DATA_RESERVED_MASK			0x7F
-#define ROCE_CREATE_QP_REQ_RAMROD_DATA_RESERVED_SHIFT			1
+#define ROCE_CREATE_QP_REQ_RAMROD_DATA_VF_ID_VALID_MASK			0x1
+#define ROCE_CREATE_QP_REQ_RAMROD_DATA_VF_ID_VALID_SHIFT		1
+#define ROCE_CREATE_QP_REQ_RAMROD_DATA_RESERVED_MASK			0x3F
+#define ROCE_CREATE_QP_REQ_RAMROD_DATA_RESERVED_SHIFT			2
+	u8 name_space;
+	u8 reserved3[3];
 	__le16 regular_latency_phy_queue;
 	__le16 dpi;
 };
@@ -7992,8 +8067,10 @@ struct roce_create_qp_resp_ramrod_data {
 #define ROCE_CREATE_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER_SHIFT		11
 #define ROCE_CREATE_QP_RESP_RAMROD_DATA_XRC_FLAG_MASK             0x1
 #define ROCE_CREATE_QP_RESP_RAMROD_DATA_XRC_FLAG_SHIFT            16
-#define ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_MASK             0x7FFF
-#define ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_SHIFT            17
+#define ROCE_CREATE_QP_RESP_RAMROD_DATA_VF_ID_VALID_MASK	0x1
+#define ROCE_CREATE_QP_RESP_RAMROD_DATA_VF_ID_VALID_SHIFT	17
+#define ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_MASK		0x3FFF
+#define ROCE_CREATE_QP_RESP_RAMROD_DATA_RESERVED_SHIFT		18
 	__le16 xrc_domain;
 	u8 max_ird;
 	u8 traffic_class;
@@ -8020,10 +8097,14 @@ struct roce_create_qp_resp_ramrod_data {
 	struct regpair qp_handle_for_cqe;
 	struct regpair qp_handle_for_async;
 	__le16 low_latency_phy_queue;
-	u8 reserved2[2];
+	u8 vf_id;
+	u8 vport_id;
 	__le32 cq_cid;
 	__le16 regular_latency_phy_queue;
 	__le16 dpi;
+	__le32 src_qp_id;
+	u8 name_space;
+	u8 reserved3[3];
 };
 
 /* roce DCQCN received statistics */
@@ -8057,6 +8138,8 @@ struct roce_destroy_qp_resp_output_params {
 /* RoCE destroy qp responder ramrod data */
 struct roce_destroy_qp_resp_ramrod_data {
 	struct regpair output_params_addr;
+	__le32 src_qp_id;
+	__le32 reserved;
 };
 
 /* roce error statistics */
@@ -8140,8 +8223,8 @@ struct roce_modify_qp_req_ramrod_data {
 #define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PRI_FLG_SHIFT			9
 #define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PRI_MASK				0x7
 #define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PRI_SHIFT			10
-#define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PHYSICAL_QUEUES_FLG_MASK		0x1
-#define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PHYSICAL_QUEUES_FLG_SHIFT	13
+#define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PHYSICAL_QUEUE_FLG_MASK		0x1
+#define ROCE_MODIFY_QP_REQ_RAMROD_DATA_PHYSICAL_QUEUE_FLG_SHIFT		13
 #define ROCE_MODIFY_QP_REQ_RAMROD_DATA_RESERVED1_MASK			0x3
 #define ROCE_MODIFY_QP_REQ_RAMROD_DATA_RESERVED1_SHIFT			14
 	u8 fields;
@@ -8187,8 +8270,8 @@ struct roce_modify_qp_resp_ramrod_data {
 #define ROCE_MODIFY_QP_RESP_RAMROD_DATA_MIN_RNR_NAK_TIMER_FLG_SHIFT	8
 #define ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_OPS_EN_FLG_MASK		0x1
 #define ROCE_MODIFY_QP_RESP_RAMROD_DATA_RDMA_OPS_EN_FLG_SHIFT		9
-#define ROCE_MODIFY_QP_RESP_RAMROD_DATA_PHYSICAL_QUEUES_FLG_MASK	0x1
-#define ROCE_MODIFY_QP_RESP_RAMROD_DATA_PHYSICAL_QUEUES_FLG_SHIFT	10
+#define ROCE_MODIFY_QP_RESP_RAMROD_DATA_PHYSICAL_QUEUE_FLG_MASK		0x1
+#define ROCE_MODIFY_QP_RESP_RAMROD_DATA_PHYSICAL_QUEUE_FLG_SHIFT	10
 #define ROCE_MODIFY_QP_RESP_RAMROD_DATA_RESERVED1_MASK			0x1F
 #define ROCE_MODIFY_QP_RESP_RAMROD_DATA_RESERVED1_SHIFT			11
 	u8 fields;
@@ -8229,7 +8312,7 @@ struct roce_query_qp_req_ramrod_data {
 /* RoCE query qp responder output params */
 struct roce_query_qp_resp_output_params {
 	__le32 psn;
-	__le32 err_flag;
+	__le32 flags;
 #define ROCE_QUERY_QP_RESP_OUTPUT_PARAMS_ERROR_FLG_MASK  0x1
 #define ROCE_QUERY_QP_RESP_OUTPUT_PARAMS_ERROR_FLG_SHIFT 0
 #define ROCE_QUERY_QP_RESP_OUTPUT_PARAMS_RESERVED0_MASK  0x7FFFFFFF
@@ -8296,12 +8379,12 @@ struct e4_xstorm_roce_conn_ag_ctx_dq_ext_ld_part {
 #define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT10_SHIFT		2
 #define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT11_MASK		0x1
 #define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT11_SHIFT		3
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT12_MASK		0x1
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT12_SHIFT		4
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSEM_FLUSH_MASK        0x1
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSEM_FLUSH_SHIFT       5
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSDM_FLUSH_MASK        0x1
-#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSDM_FLUSH_SHIFT       6
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSDM_FLUSH_MASK	0x1
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSDM_FLUSH_SHIFT	4
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSEM_FLUSH_MASK	0x1
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_MSEM_FLUSH_SHIFT	5
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT14_MASK		0x1
+#define E4XSTORMROCECONNAGCTXDQEXTLDPART_BIT14_SHIFT		6
 #define E4XSTORMROCECONNAGCTXDQEXTLDPART_YSTORM_FLUSH_MASK	0x1
 #define E4XSTORMROCECONNAGCTXDQEXTLDPART_YSTORM_FLUSH_SHIFT	7
 	u8 flags2;
@@ -8674,8 +8757,8 @@ struct e4_tstorm_roce_req_conn_ag_ctx {
 	u8 flags5;
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE1EN_MASK		0x1
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE1EN_SHIFT		0
-#define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE2EN_MASK		0x1
-#define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE2EN_SHIFT		1
+#define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_DIF_CNT_EN_MASK		0x1
+#define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_DIF_CNT_EN_SHIFT		1
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE3EN_MASK		0x1
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE3EN_SHIFT		2
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE4EN_MASK		0x1
@@ -8688,13 +8771,13 @@ struct e4_tstorm_roce_req_conn_ag_ctx {
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE7EN_SHIFT		6
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE8EN_MASK		0x1
 #define E4_TSTORM_ROCE_REQ_CONN_AG_CTX_RULE8EN_SHIFT		7
-	__le32 reg0;
+	__le32 dif_rxmit_cnt;
 	__le32 snd_nxt_psn;
 	__le32 snd_max_psn;
 	__le32 orq_prod;
 	__le32 reg4;
-	__le32 reg5;
-	__le32 reg6;
+	__le32 dif_acked_cnt;
+	__le32 dif_cnt;
 	__le32 reg7;
 	__le32 reg8;
 	u8 tx_cqe_error_type;
@@ -8705,7 +8788,7 @@ struct e4_tstorm_roce_req_conn_ag_ctx {
 	__le16 snd_sq_cons;
 	__le16 conn_dpi;
 	__le16 force_comp_cons;
-	__le32 reg9;
+	__le32 dif_rxmit_acked_cnt;
 	__le32 reg10;
 };
 
@@ -8980,10 +9063,10 @@ struct e4_xstorm_roce_req_conn_ag_ctx {
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT10_SHIFT		2
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT11_MASK		0x1
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT11_SHIFT		3
-#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT12_MASK		0x1
-#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT12_SHIFT		4
-#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT13_MASK		0x1
-#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_BIT13_SHIFT		5
+#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_MSDM_FLUSH_MASK		0x1
+#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_MSDM_FLUSH_SHIFT		4
+#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_MSEM_FLUSH_MASK		0x1
+#define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_MSEM_FLUSH_SHIFT		5
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_ERROR_STATE_MASK		0x1
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_ERROR_STATE_SHIFT	6
 #define E4_XSTORM_ROCE_REQ_CONN_AG_CTX_YSTORM_FLUSH_MASK	0x1
@@ -9209,10 +9292,10 @@ struct e4_xstorm_roce_resp_conn_ag_ctx {
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT10_SHIFT		2
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT11_MASK		0x1
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT11_SHIFT		3
-#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT12_MASK		0x1
-#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT12_SHIFT		4
-#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT13_MASK		0x1
-#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_BIT13_SHIFT		5
+#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_MSDM_FLUSH_MASK		0x1
+#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_MSDM_FLUSH_SHIFT	4
+#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_MSEM_FLUSH_MASK		0x1
+#define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_MSEM_FLUSH_SHIFT	5
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_ERROR_STATE_MASK	0x1
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_ERROR_STATE_SHIFT	6
 #define E4_XSTORM_ROCE_RESP_CONN_AG_CTX_YSTORM_FLUSH_MASK	0x1
@@ -9939,7 +10022,7 @@ struct mstorm_iwarp_conn_st_ctx {
 
 /* The iwarp storm context of Ustorm */
 struct ustorm_iwarp_conn_st_ctx {
-	__le32 reserved[24];
+	struct regpair reserved[14];
 };
 
 /* iwarp connection context */
@@ -9957,6 +10040,7 @@ struct e4_iwarp_conn_context {
 	struct regpair tstorm_st_padding[2];
 	struct mstorm_iwarp_conn_st_ctx mstorm_st_context;
 	struct ustorm_iwarp_conn_st_ctx ustorm_st_context;
+	struct regpair ustorm_st_padding[2];
 };
 
 /* iWARP create QP params passed by driver to FW in CreateQP Request Ramrod */
@@ -10009,7 +10093,8 @@ enum iwarp_eqe_async_opcode {
 
 struct iwarp_eqe_data_mpa_async_completion {
 	__le16 ulp_data_len;
-	u8 reserved[6];
+	u8 rtr_type_sent;
+	u8 reserved[5];
 };
 
 struct iwarp_eqe_data_tcp_async_completion {
@@ -10034,7 +10119,7 @@ enum iwarp_eqe_sync_opcode {
 
 /* iWARP EQE completion status */
 enum iwarp_fw_return_code {
-	IWARP_CONN_ERROR_TCP_CONNECT_INVALID_PACKET = 5,
+	IWARP_CONN_ERROR_TCP_CONNECT_INVALID_PACKET = 6,
 	IWARP_CONN_ERROR_TCP_CONNECTION_RST,
 	IWARP_CONN_ERROR_TCP_CONNECT_TIMEOUT,
 	IWARP_CONN_ERROR_MPA_ERROR_REJECT,
@@ -10203,8 +10288,8 @@ struct iwarp_rxmit_stats_drv {
  * offload ramrod.
  */
 struct iwarp_tcp_offload_ramrod_data {
-	struct iwarp_offload_params iwarp;
 	struct tcp_offload_params_opt2 tcp;
+	struct iwarp_offload_params iwarp;
 };
 
 /* iWARP MPA negotiation types */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
index 31222b3e3936..5ca117a8734a 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_init_ops.c
@@ -490,10 +490,10 @@ static u32 qed_init_cmd_phase(struct qed_hwfn *p_hwfn,
 int qed_init_run(struct qed_hwfn *p_hwfn,
 		 struct qed_ptt *p_ptt, int phase, int phase_id, int modes)
 {
+	bool b_dmae = (phase != PHASE_ENGINE);
 	struct qed_dev *cdev = p_hwfn->cdev;
 	u32 cmd_num, num_init_ops;
 	union init_op *init_ops;
-	bool b_dmae = false;
 	int rc = 0;
 
 	num_init_ops = cdev->fw_data->init_ops_size;
@@ -522,7 +522,6 @@ int qed_init_run(struct qed_hwfn *p_hwfn,
 		case INIT_OP_IF_PHASE:
 			cmd_num += qed_init_cmd_phase(p_hwfn, &cmd->if_phase,
 						      phase, phase_id);
-			b_dmae = GET_FIELD(data, INIT_IF_PHASE_OP_DMAE_ENABLE);
 			break;
 		case INIT_OP_DELAY:
 			/* qed_init_run is always invoked from
@@ -533,6 +532,9 @@ int qed_init_run(struct qed_hwfn *p_hwfn,
 
 		case INIT_OP_CALLBACK:
 			rc = qed_init_cmd_cb(p_hwfn, p_ptt, &cmd->callback);
+			if (phase == PHASE_ENGINE &&
+			    cmd->callback.callback_id == DMAE_READY_CB)
+				b_dmae = true;
 			break;
 		}
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
index aeac359941de..af981ff5595e 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
@@ -48,6 +48,8 @@
 #include "qed_reg_addr.h"
 #include "qed_sriov.h"
 
+#define GRCBASE_MCP     0xe00000
+
 #define QED_MCP_RESP_ITER_US	10
 
 #define QED_DRV_MB_MAX_RETRIES	(500 * 1000)	/* Account for 5 sec */
diff --git a/drivers/net/ethernet/qlogic/qed/qed_roce.c b/drivers/net/ethernet/qlogic/qed/qed_roce.c
index e49fada85410..37e70562a964 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_roce.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_roce.c
@@ -900,7 +900,7 @@ int qed_roce_query_qp(struct qed_hwfn *p_hwfn,
 		goto err_resp;
 
 	out_params->rq_psn = le32_to_cpu(p_resp_ramrod_res->psn);
-	rq_err_state = GET_FIELD(le32_to_cpu(p_resp_ramrod_res->err_flag),
+	rq_err_state = GET_FIELD(le32_to_cpu(p_resp_ramrod_res->flags),
 				 ROCE_QUERY_QP_RESP_OUTPUT_PARAMS_ERROR_FLG);
 
 	dma_free_coherent(&p_hwfn->cdev->pdev->dev, sizeof(*p_resp_ramrod_res),
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 004c0bfec41d..c6c20776b474 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -848,13 +848,13 @@ static void qede_tpa_start(struct qede_dev *edev,
 	qede_set_gro_params(edev, tpa_info->skb, cqe);
 
 cons_buf: /* We still need to handle bd_len_list to consume buffers */
-	if (likely(cqe->ext_bd_len_list[0]))
+	if (likely(cqe->bw_ext_bd_len_list[0]))
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
-				   le16_to_cpu(cqe->ext_bd_len_list[0]));
+				   le16_to_cpu(cqe->bw_ext_bd_len_list[0]));
 
-	if (unlikely(cqe->ext_bd_len_list[1])) {
+	if (unlikely(cqe->bw_ext_bd_len_list[1])) {
 		DP_ERR(edev,
-		       "Unlikely - got a TPA aggregation with more than one ext_bd_len_list entry in the TPA start\n");
+		       "Unlikely - got a TPA aggregation with more than one bw_ext_bd_len_list entry in the TPA start\n");
 		tpa_info->state = QEDE_AGG_STATE_ERROR;
 	}
 }
diff --git a/include/linux/qed/common_hsi.h b/include/linux/qed/common_hsi.h
index 718ce72e5965..2c4737e6694a 100644
--- a/include/linux/qed/common_hsi.h
+++ b/include/linux/qed/common_hsi.h
@@ -76,7 +76,6 @@
 
 #define FW_ASSERT_GENERAL_ATTN_IDX		32
 
-#define MAX_PINNED_CCFC				32
 
 /* Queue Zone sizes in bytes */
 #define TSTORM_QZONE_SIZE	8
@@ -139,10 +138,10 @@
 #define MAX_NUM_VFS	(MAX_NUM_VFS_K2)
 
 #define MAX_NUM_FUNCTIONS_BB	(MAX_NUM_PFS_BB + MAX_NUM_VFS_BB)
-#define MAX_NUM_FUNCTIONS	(MAX_NUM_PFS + MAX_NUM_VFS)
 
 #define MAX_FUNCTION_NUMBER_BB	(MAX_NUM_PFS + MAX_NUM_VFS_BB)
-#define MAX_FUNCTION_NUMBER	(MAX_NUM_PFS + MAX_NUM_VFS)
+#define MAX_FUNCTION_NUMBER_K2  (MAX_NUM_PFS + MAX_NUM_VFS_K2)
+#define MAX_NUM_FUNCTIONS	(MAX_FUNCTION_NUMBER_K2)
 
 #define MAX_NUM_VPORTS_K2	(208)
 #define MAX_NUM_VPORTS_BB	(160)
@@ -229,6 +228,7 @@
 #define DQ_XCM_TOE_TX_BD_PROD_CMD		DQ_XCM_AGG_VAL_SEL_WORD4
 #define DQ_XCM_TOE_MORE_TO_SEND_SEQ_CMD		DQ_XCM_AGG_VAL_SEL_REG3
 #define DQ_XCM_TOE_LOCAL_ADV_WND_SEQ_CMD	DQ_XCM_AGG_VAL_SEL_REG4
+#define DQ_XCM_ROCE_ACK_EDPM_DORQ_SEQ_CMD	DQ_XCM_AGG_VAL_SEL_WORD5
 
 /* UCM agg val selection (HW) */
 #define	DQ_UCM_AGG_VAL_SEL_WORD0	0
@@ -406,6 +406,7 @@
 
 /* Number of Protocol Indices per Status Block */
 #define PIS_PER_SB_E4	12
+#define MAX_PIS_PER_SB	PIS_PER_SB
 
 #define CAU_HC_STOPPED_STATE	3
 #define CAU_HC_DISABLE_STATE	4
@@ -436,8 +437,6 @@
 #define IGU_MEM_PBA_MSIX_RESERVED_UPPER	0x03ff
 
 #define IGU_CMD_INT_ACK_BASE		0x0400
-#define IGU_CMD_INT_ACK_UPPER		(IGU_CMD_INT_ACK_BASE +	\
-					 MAX_TOT_SB_PER_PATH - 1)
 #define IGU_CMD_INT_ACK_RESERVED_UPPER	0x05ff
 
 #define IGU_CMD_ATTN_BIT_UPD_UPPER	0x05f0
@@ -450,8 +449,6 @@
 #define IGU_REG_SISR_MDPC_WOMASK_UPPER		0x05f6
 
 #define IGU_CMD_PROD_UPD_BASE			0x0600
-#define IGU_CMD_PROD_UPD_UPPER			(IGU_CMD_PROD_UPD_BASE +\
-						 MAX_TOT_SB_PER_PATH - 1)
 #define IGU_CMD_PROD_UPD_RESERVED_UPPER		0x07ff
 
 /*****************/
@@ -741,6 +738,8 @@ enum protocol_type {
 	PROTOCOLID_PREROCE,
 	PROTOCOLID_COMMON,
 	PROTOCOLID_RESERVED1,
+	PROTOCOLID_RDMA,
+	PROTOCOLID_SCSI,
 	MAX_PROTOCOL_TYPE
 };
 
@@ -761,6 +760,10 @@ union rdma_eqe_data {
 	struct rdma_eqe_destroy_qp rdma_destroy_qp_data;
 };
 
+struct tstorm_queue_zone {
+	__le32 reserved[2];
+};
+
 /* Ustorm Queue Zone */
 struct ustorm_eth_queue_zone {
 	struct coalescing_timeset int_coalescing_timeset;
@@ -883,8 +886,8 @@ struct db_l2_dpm_data {
 #define DB_L2_DPM_DATA_RESERVED0_SHIFT 27
 #define DB_L2_DPM_DATA_SGE_NUM_MASK	0x7
 #define DB_L2_DPM_DATA_SGE_NUM_SHIFT	28
-#define DB_L2_DPM_DATA_GFS_SRC_EN_MASK	0x1
-#define DB_L2_DPM_DATA_GFS_SRC_EN_SHIFT	31
+#define DB_L2_DPM_DATA_TGFS_SRC_EN_MASK  0x1
+#define DB_L2_DPM_DATA_TGFS_SRC_EN_SHIFT 31
 };
 
 /* Structure for SGE in a DPM doorbell of type DPM_L2_BD */
diff --git a/include/linux/qed/eth_common.h b/include/linux/qed/eth_common.h
index d9416ad5ef59..95f5fd615852 100644
--- a/include/linux/qed/eth_common.h
+++ b/include/linux/qed/eth_common.h
@@ -38,9 +38,11 @@
 /********************/
 
 #define ETH_HSI_VER_MAJOR		3
-#define ETH_HSI_VER_MINOR		10
+#define ETH_HSI_VER_MINOR		11
 
-#define ETH_HSI_VER_NO_PKT_LEN_TUNN	5
+#define ETH_HSI_VER_NO_PKT_LEN_TUNN         5
+/* Maximum number of pinned L2 connections (CIDs) */
+#define ETH_PINNED_CONN_MAX_NUM             32
 
 #define ETH_CACHE_LINE_SIZE		64
 #define ETH_RX_CQE_GAP			32
@@ -61,6 +63,7 @@
 #define ETH_TX_MIN_BDS_PER_TUNN_IPV6_WITH_EXT_PKT	3
 #define ETH_TX_MIN_BDS_PER_IPV6_WITH_EXT_PKT		2
 #define ETH_TX_MIN_BDS_PER_PKT_W_LOOPBACK_MODE		2
+#define ETH_TX_MIN_BDS_PER_PKT_W_VPORT_FORWARDING	4
 #define ETH_TX_MAX_NON_LSO_PKT_LEN		(9700 - (4 + 4 + 12 + 8))
 #define ETH_TX_MAX_LSO_HDR_BYTES			510
 #define ETH_TX_LSO_WINDOW_BDS_NUM			(18 - 1)
@@ -75,9 +78,8 @@
 #define ETH_NUM_STATISTIC_COUNTERS_QUAD_VF_ZONE \
 	(ETH_NUM_STATISTIC_COUNTERS - 3 * MAX_NUM_VFS / 4)
 
-/* Maximum number of buffers, used for RX packet placement */
 #define ETH_RX_MAX_BUFF_PER_PKT		5
-#define ETH_RX_BD_THRESHOLD		12
+#define ETH_RX_BD_THRESHOLD             16
 
 /* Num of MAC/VLAN filters */
 #define ETH_NUM_MAC_FILTERS		512
@@ -96,24 +98,24 @@
 #define ETH_RSS_ENGINE_NUM_BB		127
 
 /* TPA constants */
-#define ETH_TPA_MAX_AGGS_NUM		64
-#define ETH_TPA_CQE_START_LEN_LIST_SIZE	ETH_RX_MAX_BUFF_PER_PKT
-#define ETH_TPA_CQE_CONT_LEN_LIST_SIZE	6
-#define ETH_TPA_CQE_END_LEN_LIST_SIZE	4
+#define ETH_TPA_MAX_AGGS_NUM                64
+#define ETH_TPA_CQE_START_BW_LEN_LIST_SIZE  2
+#define ETH_TPA_CQE_CONT_LEN_LIST_SIZE      6
+#define ETH_TPA_CQE_END_LEN_LIST_SIZE       4
 
 /* Control frame check constants */
-#define ETH_CTL_FRAME_ETH_TYPE_NUM	4
+#define ETH_CTL_FRAME_ETH_TYPE_NUM        4
 
 /* GFS constants */
 #define ETH_GFT_TRASHCAN_VPORT         0x1FF	/* GFT drop flow vport number */
 
 /* Destination port mode */
-enum dest_port_mode {
-	DEST_PORT_PHY,
-	DEST_PORT_LOOPBACK,
-	DEST_PORT_PHY_LOOPBACK,
-	DEST_PORT_DROP,
-	MAX_DEST_PORT_MODE
+enum dst_port_mode {
+	DST_PORT_PHY,
+	DST_PORT_LOOPBACK,
+	DST_PORT_PHY_LOOPBACK,
+	DST_PORT_DROP,
+	MAX_DST_PORT_MODE
 };
 
 /* Ethernet address type */
@@ -167,8 +169,8 @@ struct eth_tx_data_2nd_bd {
 #define ETH_TX_DATA_2ND_BD_TUNN_INNER_L2_HDR_SIZE_W_SHIFT	0
 #define ETH_TX_DATA_2ND_BD_TUNN_INNER_ETH_TYPE_MASK		0x3
 #define ETH_TX_DATA_2ND_BD_TUNN_INNER_ETH_TYPE_SHIFT		4
-#define ETH_TX_DATA_2ND_BD_DEST_PORT_MODE_MASK			0x3
-#define ETH_TX_DATA_2ND_BD_DEST_PORT_MODE_SHIFT			6
+#define ETH_TX_DATA_2ND_BD_DST_PORT_MODE_MASK			0x3
+#define ETH_TX_DATA_2ND_BD_DST_PORT_MODE_SHIFT			6
 #define ETH_TX_DATA_2ND_BD_START_BD_MASK			0x1
 #define ETH_TX_DATA_2ND_BD_START_BD_SHIFT			8
 #define ETH_TX_DATA_2ND_BD_TUNN_TYPE_MASK			0x3
@@ -244,8 +246,9 @@ struct eth_fast_path_rx_reg_cqe {
 	struct eth_tunnel_parsing_flags tunnel_pars_flags;
 	u8 bd_num;
 	u8 reserved;
-	__le16 flow_id;
-	u8 reserved1[11];
+	__le16 reserved2;
+	__le32 flow_id_or_resource_id;
+	u8 reserved1[7];
 	struct eth_pmd_flow_flags pmd_flags;
 };
 
@@ -296,9 +299,10 @@ struct eth_fast_path_rx_tpa_start_cqe {
 	struct eth_tunnel_parsing_flags tunnel_pars_flags;
 	u8 tpa_agg_index;
 	u8 header_len;
-	__le16 ext_bd_len_list[ETH_TPA_CQE_START_LEN_LIST_SIZE];
-	__le16 flow_id;
-	u8 reserved;
+	__le16 bw_ext_bd_len_list[ETH_TPA_CQE_START_BW_LEN_LIST_SIZE];
+	__le16 reserved2;
+	__le32 flow_id_or_resource_id;
+	u8 reserved[3];
 	struct eth_pmd_flow_flags pmd_flags;
 };
 
@@ -407,6 +411,29 @@ struct eth_tx_3rd_bd {
 	struct eth_tx_data_3rd_bd data;
 };
 
+/* The parsing information data for the forth tx bd of a given packet. */
+struct eth_tx_data_4th_bd {
+	u8 dst_vport_id;
+	u8 reserved4;
+	__le16 bitfields;
+#define ETH_TX_DATA_4TH_BD_DST_VPORT_ID_VALID_MASK  0x1
+#define ETH_TX_DATA_4TH_BD_DST_VPORT_ID_VALID_SHIFT 0
+#define ETH_TX_DATA_4TH_BD_RESERVED1_MASK           0x7F
+#define ETH_TX_DATA_4TH_BD_RESERVED1_SHIFT          1
+#define ETH_TX_DATA_4TH_BD_START_BD_MASK            0x1
+#define ETH_TX_DATA_4TH_BD_START_BD_SHIFT           8
+#define ETH_TX_DATA_4TH_BD_RESERVED2_MASK           0x7F
+#define ETH_TX_DATA_4TH_BD_RESERVED2_SHIFT          9
+	__le16 reserved3;
+};
+
+/* The forth tx bd of a given packet */
+struct eth_tx_4th_bd {
+	struct regpair addr; /* Single continuous buffer */
+	__le16 nbytes; /* Number of bytes in this BD */
+	struct eth_tx_data_4th_bd data; /* Parsing information data */
+};
+
 /* Complementary information for the regular tx bd of a given packet */
 struct eth_tx_data_bd {
 	__le16 reserved0;
@@ -431,6 +458,7 @@ union eth_tx_bd_types {
 	struct eth_tx_1st_bd first_bd;
 	struct eth_tx_2nd_bd second_bd;
 	struct eth_tx_3rd_bd third_bd;
+	struct eth_tx_4th_bd fourth_bd;
 	struct eth_tx_bd reg_bd;
 };
 
@@ -443,6 +471,12 @@ enum eth_tx_tunn_type {
 	MAX_ETH_TX_TUNN_TYPE
 };
 
+/* Mstorm Queue Zone */
+struct mstorm_eth_queue_zone {
+	struct eth_rx_prod_data rx_producers;
+	__le32 reserved[3];
+};
+
 /* Ystorm Queue Zone */
 struct xstorm_eth_queue_zone {
 	struct coalescing_timeset int_coalescing_timeset;
-- 
2.14.5


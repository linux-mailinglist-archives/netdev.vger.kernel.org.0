Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E52F3969E1
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 00:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEaW6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 18:58:31 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16096 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232386AbhEaW61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 18:58:27 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14VMoiZT001303;
        Mon, 31 May 2021 15:54:38 -0700
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 38vtnja4pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 31 May 2021 15:54:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 31 May
 2021 15:54:35 -0700
Received: from lbtlvb-pcie154.il.qlogic.org (10.69.176.80) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 31 May 2021 15:54:32 -0700
From:   Shai Malin <smalin@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-nvme@lists.infradead.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <sagi@grimberg.me>,
        <hch@lst.de>, <axboe@fb.com>, <kbusch@kernel.org>
CC:     <aelior@marvell.com>, <mkalderon@marvell.com>,
        <okulkarni@marvell.com>, <pkushwaha@marvell.com>,
        <prabhakar.pkin@gmail.com>, <malin1024@gmail.com>,
        <smalin@marvell.com>
Subject: [RFC PATCH v7 13/27] qed: Add NVMeTCP Offload IO Level FW and HW HSI
Date:   Tue, 1 Jun 2021 01:52:08 +0300
Message-ID: <20210531225222.16992-14-smalin@marvell.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
References: <20210531225222.16992-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: PCUCjDvz1UyDTm-JtcS6LiQSesLpyhRA
X-Proofpoint-ORIG-GUID: PCUCjDvz1UyDTm-JtcS6LiQSesLpyhRA
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-31_15:2021-05-31,2021-05-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces the NVMeTCP Offload FW and HW  HSI in order
to initialize the IO level configuration into a per IO HW
resource ("task") as part of the IO path flow.

Acked-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
Signed-off-by: Omkar Kulkarni <okulkarni@marvell.com>
Signed-off-by: Shai Malin <smalin@marvell.com>
Signed-off-by: Michal Kalderon <mkalderon@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 include/linux/qed/nvmetcp_common.h | 335 ++++++++++++++++++++++++++++-
 include/linux/qed/qed_nvmetcp_if.h |  31 +++
 2 files changed, 365 insertions(+), 1 deletion(-)

diff --git a/include/linux/qed/nvmetcp_common.h b/include/linux/qed/nvmetcp_common.h
index c8836b71b866..ad745a9c2264 100644
--- a/include/linux/qed/nvmetcp_common.h
+++ b/include/linux/qed/nvmetcp_common.h
@@ -7,6 +7,7 @@
 #include "tcp_common.h"
 
 #define NVMETCP_SLOW_PATH_LAYER_CODE (6)
+#define NVMETCP_WQE_NUM_SGES_SLOWIO (0xf)
 
 /* NVMeTCP firmware function init parameters */
 struct nvmetcp_spe_func_init {
@@ -194,4 +195,336 @@ struct nvmetcp_wqe {
 #define NVMETCP_WQE_CDB_SIZE_OR_NVMETCP_CMD_SHIFT 24
 };
 
-#endif /* __NVMETCP_COMMON__ */
+struct nvmetcp_host_cccid_itid_entry {
+	__le16 itid;
+};
+
+struct nvmetcp_connect_done_results {
+	__le16 icid;
+	__le16 conn_id;
+	struct tcp_ulp_connect_done_params params;
+};
+
+struct nvmetcp_eqe_data {
+	__le16 icid;
+	__le16 conn_id;
+	__le16 reserved;
+	u8 error_code;
+	u8 error_pdu_opcode_reserved;
+#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_MASK 0x3F
+#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_SHIFT  0
+#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_VALID_MASK  0x1
+#define NVMETCP_EQE_DATA_ERROR_PDU_OPCODE_VALID_SHIFT  6
+#define NVMETCP_EQE_DATA_RESERVED0_MASK 0x1
+#define NVMETCP_EQE_DATA_RESERVED0_SHIFT 7
+};
+
+enum nvmetcp_task_type {
+	NVMETCP_TASK_TYPE_HOST_WRITE,
+	NVMETCP_TASK_TYPE_HOST_READ,
+	NVMETCP_TASK_TYPE_INIT_CONN_REQUEST,
+	NVMETCP_TASK_TYPE_RESERVED0,
+	NVMETCP_TASK_TYPE_CLEANUP,
+	NVMETCP_TASK_TYPE_HOST_READ_NO_CQE,
+	MAX_NVMETCP_TASK_TYPE
+};
+
+struct nvmetcp_db_data {
+	u8 params;
+#define NVMETCP_DB_DATA_DEST_MASK 0x3 /* destination of doorbell (use enum db_dest) */
+#define NVMETCP_DB_DATA_DEST_SHIFT 0
+#define NVMETCP_DB_DATA_AGG_CMD_MASK 0x3 /* aggregative command to CM (use enum db_agg_cmd_sel) */
+#define NVMETCP_DB_DATA_AGG_CMD_SHIFT 2
+#define NVMETCP_DB_DATA_BYPASS_EN_MASK 0x1 /* enable QM bypass */
+#define NVMETCP_DB_DATA_BYPASS_EN_SHIFT 4
+#define NVMETCP_DB_DATA_RESERVED_MASK 0x1
+#define NVMETCP_DB_DATA_RESERVED_SHIFT 5
+#define NVMETCP_DB_DATA_AGG_VAL_SEL_MASK 0x3 /* aggregative value selection */
+#define NVMETCP_DB_DATA_AGG_VAL_SEL_SHIFT 6
+	u8 agg_flags; /* bit for every DQ counter flags in CM context that DQ can increment */
+	__le16 sq_prod;
+};
+
+struct nvmetcp_fw_nvmf_cqe {
+	__le32 reserved[4];
+};
+
+struct nvmetcp_icresp_mdata {
+	u8  digest;
+	u8  cpda;
+	__le16  pfv;
+	__le32 maxdata;
+	__le16 rsvd[4];
+};
+
+union nvmetcp_fw_cqe_data {
+	struct nvmetcp_fw_nvmf_cqe nvme_cqe;
+	struct nvmetcp_icresp_mdata icresp_mdata;
+};
+
+struct nvmetcp_fw_cqe {
+	__le16 conn_id;
+	u8 cqe_type;
+	u8 cqe_error_status_bits;
+#define CQE_ERROR_BITMAP_DIF_ERR_BITS_MASK 0x7
+#define CQE_ERROR_BITMAP_DIF_ERR_BITS_SHIFT 0
+#define CQE_ERROR_BITMAP_DATA_DIGEST_ERR_MASK 0x1
+#define CQE_ERROR_BITMAP_DATA_DIGEST_ERR_SHIFT 3
+#define CQE_ERROR_BITMAP_RCV_ON_INVALID_CONN_MASK 0x1
+#define CQE_ERROR_BITMAP_RCV_ON_INVALID_CONN_SHIFT 4
+	__le16 itid;
+	u8 task_type;
+	u8 fw_dbg_field;
+	u8 caused_conn_err;
+	u8 reserved0[3];
+	__le32 reserved1;
+	union nvmetcp_fw_cqe_data cqe_data;
+	struct regpair task_opaque;
+	__le32 reserved[6];
+};
+
+enum nvmetcp_fw_cqes_type {
+	NVMETCP_FW_CQE_TYPE_NORMAL = 1,
+	NVMETCP_FW_CQE_TYPE_RESERVED0,
+	NVMETCP_FW_CQE_TYPE_RESERVED1,
+	NVMETCP_FW_CQE_TYPE_CLEANUP,
+	NVMETCP_FW_CQE_TYPE_DUMMY,
+	MAX_NVMETCP_FW_CQES_TYPE
+};
+
+struct ystorm_nvmetcp_task_state {
+	struct scsi_cached_sges data_desc;
+	struct scsi_sgl_params sgl_params;
+	__le32 resrved0;
+	__le32 buffer_offset;
+	__le16 cccid;
+	struct nvmetcp_dif_flags dif_flags;
+	u8 flags;
+#define YSTORM_NVMETCP_TASK_STATE_LOCAL_COMP_MASK 0x1
+#define YSTORM_NVMETCP_TASK_STATE_LOCAL_COMP_SHIFT 0
+#define YSTORM_NVMETCP_TASK_STATE_SLOW_IO_MASK 0x1
+#define YSTORM_NVMETCP_TASK_STATE_SLOW_IO_SHIFT 1
+#define YSTORM_NVMETCP_TASK_STATE_SET_DIF_OFFSET_MASK 0x1
+#define YSTORM_NVMETCP_TASK_STATE_SET_DIF_OFFSET_SHIFT 2
+#define YSTORM_NVMETCP_TASK_STATE_SEND_W_RSP_MASK 0x1
+#define YSTORM_NVMETCP_TASK_STATE_SEND_W_RSP_SHIFT 3
+};
+
+struct ystorm_nvmetcp_task_rxmit_opt {
+	__le32 reserved[4];
+};
+
+struct nvmetcp_task_hdr {
+	__le32 reg[18];
+};
+
+struct nvmetcp_task_hdr_aligned {
+	struct nvmetcp_task_hdr task_hdr;
+	__le32 reserved[2];	/* HSI_COMMENT: Align to QREG */
+};
+
+struct e5_tdif_task_context {
+	__le32 reserved[16];
+};
+
+struct e5_rdif_task_context {
+	__le32 reserved[12];
+};
+
+struct ystorm_nvmetcp_task_st_ctx {
+	struct ystorm_nvmetcp_task_state state;
+	struct ystorm_nvmetcp_task_rxmit_opt rxmit_opt;
+	struct nvmetcp_task_hdr_aligned pdu_hdr;
+};
+
+struct mstorm_nvmetcp_task_st_ctx {
+	struct scsi_cached_sges data_desc;
+	struct scsi_sgl_params sgl_params;
+	__le32 rem_task_size;
+	__le32 data_buffer_offset;
+	u8 task_type;
+	struct nvmetcp_dif_flags dif_flags;
+	__le16 dif_task_icid;
+	struct regpair reserved0;
+	__le32 expected_itt;
+	__le32 reserved1;
+};
+
+struct ustorm_nvmetcp_task_st_ctx {
+	__le32 rem_rcv_len;
+	__le32 exp_data_transfer_len;
+	__le32 exp_data_sn;
+	struct regpair reserved0;
+	__le32 reg1_map;
+#define REG1_NUM_SGES_MASK 0xF
+#define REG1_NUM_SGES_SHIFT 0
+#define REG1_RESERVED1_MASK 0xFFFFFFF
+#define REG1_RESERVED1_SHIFT 4
+	u8 flags2;
+#define USTORM_NVMETCP_TASK_ST_CTX_AHS_EXIST_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_AHS_EXIST_SHIFT 0
+#define USTORM_NVMETCP_TASK_ST_CTX_RESERVED1_MASK 0x7F
+#define USTORM_NVMETCP_TASK_ST_CTX_RESERVED1_SHIFT 1
+	struct nvmetcp_dif_flags dif_flags;
+	__le16 reserved3;
+	__le16 tqe_opaque[2];
+	__le32 reserved5;
+	__le32 nvme_tcp_opaque_lo;
+	__le32 nvme_tcp_opaque_hi;
+	u8 task_type;
+	u8 error_flags;
+#define USTORM_NVMETCP_TASK_ST_CTX_DATA_DIGEST_ERROR_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_DATA_DIGEST_ERROR_SHIFT 0
+#define USTORM_NVMETCP_TASK_ST_CTX_DATA_TRUNCATED_ERROR_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_DATA_TRUNCATED_ERROR_SHIFT 1
+#define USTORM_NVMETCP_TASK_ST_CTX_UNDER_RUN_ERROR_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_UNDER_RUN_ERROR_SHIFT 2
+#define USTORM_NVMETCP_TASK_ST_CTX_NVME_TCP_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_NVME_TCP_SHIFT 3
+	u8 flags;
+#define USTORM_NVMETCP_TASK_ST_CTX_CQE_WRITE_MASK 0x3
+#define USTORM_NVMETCP_TASK_ST_CTX_CQE_WRITE_SHIFT 0
+#define USTORM_NVMETCP_TASK_ST_CTX_LOCAL_COMP_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_LOCAL_COMP_SHIFT 2
+#define USTORM_NVMETCP_TASK_ST_CTX_Q0_R2TQE_WRITE_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_Q0_R2TQE_WRITE_SHIFT 3
+#define USTORM_NVMETCP_TASK_ST_CTX_TOTAL_DATA_ACKED_DONE_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_TOTAL_DATA_ACKED_DONE_SHIFT 4
+#define USTORM_NVMETCP_TASK_ST_CTX_HQ_SCANNED_DONE_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_HQ_SCANNED_DONE_SHIFT 5
+#define USTORM_NVMETCP_TASK_ST_CTX_R2T2RECV_DONE_MASK 0x1
+#define USTORM_NVMETCP_TASK_ST_CTX_R2T2RECV_DONE_SHIFT 6
+	u8 cq_rss_number;
+};
+
+struct e5_ystorm_nvmetcp_task_ag_ctx {
+	u8 reserved /* cdu_validation */;
+	u8 byte1 /* state_and_core_id */;
+	__le16 word0 /* icid */;
+	u8 flags0;
+	u8 flags1;
+	u8 flags2;
+	u8 flags3;
+	__le32 TTT;
+	u8 byte2;
+	u8 byte3;
+	u8 byte4;
+	u8 e4_reserved7;
+};
+
+struct e5_mstorm_nvmetcp_task_ag_ctx {
+	u8 cdu_validation;
+	u8 byte1;
+	__le16 task_cid;
+	u8 flags0;
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_MASK 0xF
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_SHIFT 0
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_SHIFT 4
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_SHIFT 5
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_VALID_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_VALID_SHIFT 6
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_FLAG_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_FLAG_SHIFT 7
+	u8 flags1;
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_MASK 0x3
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_SHIFT 0
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1_MASK 0x3
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1_SHIFT 2
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF2_MASK 0x3
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF2_SHIFT 4
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_EN_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_TASK_CLEANUP_CF_EN_SHIFT 6
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1EN_MASK 0x1
+#define E5_MSTORM_NVMETCP_TASK_AG_CTX_CF1EN_SHIFT 7
+	u8 flags2;
+	u8 flags3;
+	__le32 reg0;
+	u8 byte2;
+	u8 byte3;
+	u8 byte4;
+	u8 e4_reserved7;
+};
+
+struct e5_ustorm_nvmetcp_task_ag_ctx {
+	u8 reserved;
+	u8 state_and_core_id;
+	__le16 icid;
+	u8 flags0;
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_MASK 0xF
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONNECTION_TYPE_SHIFT 0
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_EXIST_IN_QM0_SHIFT 4
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CONN_CLEAR_SQ_FLAG_SHIFT 5
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_SHIFT 6
+	u8 flags1;
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_RESERVED1_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_RESERVED1_SHIFT 0
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_SHIFT 2
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3_SHIFT 4
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_SHIFT 6
+	u8 flags2;
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_HQ_SCANNED_CF_EN_SHIFT 0
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DISABLE_DATA_ACKED_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DISABLE_DATA_ACKED_SHIFT 1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_R2T2RECV_EN_SHIFT 2
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CF3EN_SHIFT 3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_CF_EN_SHIFT 4
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_DATA_TOTAL_EXP_EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_DATA_TOTAL_EXP_EN_SHIFT 5
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_RULE1EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_RULE1EN_SHIFT 6
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_CONT_RCV_EXP_EN_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_CMP_CONT_RCV_EXP_EN_SHIFT 7
+	u8 flags3;
+	u8 flags4;
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED5_MASK 0x3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED5_SHIFT 0
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED6_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED6_SHIFT 2
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED7_MASK 0x1
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_E4_RESERVED7_SHIFT 3
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_TYPE_MASK 0xF
+#define E5_USTORM_NVMETCP_TASK_AG_CTX_DIF_ERROR_TYPE_SHIFT 4
+	u8 byte2;
+	u8 byte3;
+	u8 e4_reserved8;
+	__le32 dif_err_intervals;
+	__le32 dif_error_1st_interval;
+	__le32 rcv_cont_len;
+	__le32 exp_cont_len;
+	__le32 total_data_acked;
+	__le32 exp_data_acked;
+	__le16 word1;
+	__le16 next_tid;
+	__le32 hdr_residual_count;
+	__le32 exp_r2t_sn;
+};
+
+struct e5_nvmetcp_task_context {
+	struct ystorm_nvmetcp_task_st_ctx ystorm_st_context;
+	struct e5_ystorm_nvmetcp_task_ag_ctx ystorm_ag_context;
+	struct regpair ystorm_ag_padding[2];
+	struct e5_tdif_task_context tdif_context;
+	struct e5_mstorm_nvmetcp_task_ag_ctx mstorm_ag_context;
+	struct regpair mstorm_ag_padding[2];
+	struct e5_ustorm_nvmetcp_task_ag_ctx ustorm_ag_context;
+	struct regpair ustorm_ag_padding[2];
+	struct mstorm_nvmetcp_task_st_ctx mstorm_st_context;
+	struct regpair mstorm_st_padding[2];
+	struct ustorm_nvmetcp_task_st_ctx ustorm_st_context;
+	struct regpair ustorm_st_padding[2];
+	struct e5_rdif_task_context rdif_context;
+};
+
+#endif /* __NVMETCP_COMMON__*/
diff --git a/include/linux/qed/qed_nvmetcp_if.h b/include/linux/qed/qed_nvmetcp_if.h
index 686f924238e3..4cca00e7a09a 100644
--- a/include/linux/qed/qed_nvmetcp_if.h
+++ b/include/linux/qed/qed_nvmetcp_if.h
@@ -5,6 +5,8 @@
 #define _QED_NVMETCP_IF_H
 #include <linux/types.h>
 #include <linux/qed/qed_if.h>
+#include <linux/qed/storage_common.h>
+#include <linux/qed/nvmetcp_common.h>
 
 #define QED_NVMETCP_MAX_IO_SIZE	0x800000
 
@@ -73,6 +75,35 @@ struct qed_nvmetcp_cb_ops {
 	struct qed_common_cb_ops common;
 };
 
+struct nvmetcp_sge {
+	struct regpair sge_addr; /* SGE address */
+	__le32 sge_len; /* SGE length */
+	__le32 reserved;
+};
+
+/* IO path HSI function SGL params */
+struct storage_sgl_task_params {
+	struct nvmetcp_sge *sgl;
+	struct regpair sgl_phys_addr;
+	u32 total_buffer_size;
+	u16 num_sges;
+	bool small_mid_sge;
+};
+
+/* IO path HSI function FW task context params */
+struct nvmetcp_task_params {
+	void *context; /* Output parameter - set/filled by the HSI function */
+	struct nvmetcp_wqe *sqe;
+	u32 tx_io_size; /* in bytes (Without DIF, if exists) */
+	u32 rx_io_size; /* in bytes (Without DIF, if exists) */
+	u16 conn_icid;
+	u16 itid;
+	struct regpair opq; /* qedn_task_ctx address */
+	u16 host_cccid;
+	u8 cq_rss_number;
+	bool send_write_incapsule;
+};
+
 /**
  * struct qed_nvmetcp_ops - qed NVMeTCP operations.
  * @common:		common operations pointer
-- 
2.22.0


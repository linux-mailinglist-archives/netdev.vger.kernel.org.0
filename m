Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB5F830A50D
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 11:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbhBAKKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 05:10:00 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59797 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232943AbhBAKGJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 05:06:09 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from borisp@mellanox.com)
        with SMTP; 1 Feb 2021 12:05:13 +0200
Received: from gen-l-vrt-133.mtl.labs.mlnx. (gen-l-vrt-133.mtl.labs.mlnx [10.237.11.160])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 111A5C03029353;
        Mon, 1 Feb 2021 12:05:13 +0200
From:   Boris Pismenny <borisp@mellanox.com>
To:     dsahern@gmail.com, kuba@kernel.org, davem@davemloft.net,
        saeedm@nvidia.com, hch@lst.de, sagi@grimberg.me, axboe@fb.com,
        kbusch@kernel.org, viro@zeniv.linux.org.uk, edumazet@google.com,
        smalin@marvell.com
Cc:     boris.pismenny@gmail.com, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, benishay@nvidia.com, ogerlitz@nvidia.com,
        yorayz@nvidia.com, Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: [PATCH v3 net-next  10/21] net/mlx5: Header file changes for nvme-tcp offload
Date:   Mon,  1 Feb 2021 12:04:58 +0200
Message-Id: <20210201100509.27351-11-borisp@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210201100509.27351-1-borisp@mellanox.com>
References: <20210201100509.27351-1-borisp@mellanox.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Ben-ishay <benishay@nvidia.com>

Add the necessary infrastructure for NVMEoTCP offload:

- Add nvmeocp_en + nvmeotcp_crc_en bit to the TIR for identify NVMEoTCP offload flow
  And tag_buffer_id that will be used by the connected nvmeotcp_queues
- Add new CQE field that will be used to pass scattered data information to SW
- Add new capability to HCA_CAP that represnts the NVMEoTCP offload ability

Signed-off-by: Ben Ben-ishay <benishay@nvidia.com>
Signed-off-by: Boris Pismenny <borisp@mellanox.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yoray Zack <yorayz@mellanox.com>
---
 include/linux/mlx5/device.h   |   8 +++
 include/linux/mlx5/mlx5_ifc.h | 101 +++++++++++++++++++++++++++++++++-
 include/linux/mlx5/qp.h       |   1 +
 3 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index c85d96180b8f..ab04959188b9 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -263,6 +263,7 @@ enum {
 enum {
 	MLX5_MKEY_MASK_LEN		= 1ull << 0,
 	MLX5_MKEY_MASK_PAGE_SIZE	= 1ull << 1,
+	MLX5_MKEY_MASK_XLT_OCT_SIZE     = 1ull << 2,
 	MLX5_MKEY_MASK_START_ADDR	= 1ull << 6,
 	MLX5_MKEY_MASK_PD		= 1ull << 7,
 	MLX5_MKEY_MASK_EN_RINVAL	= 1ull << 8,
@@ -1173,6 +1174,7 @@ enum mlx5_cap_type {
 	MLX5_CAP_VDPA_EMULATION = 0x13,
 	MLX5_CAP_DEV_EVENT = 0x14,
 	MLX5_CAP_IPSEC,
+	MLX5_CAP_DEV_NVMEOTCP = 0x19,
 	/* NUM OF CAP Types */
 	MLX5_CAP_NUM
 };
@@ -1393,6 +1395,12 @@ enum mlx5_qcam_feature_groups {
 #define MLX5_CAP_IPSEC(mdev, cap)\
 	MLX5_GET(ipsec_cap, (mdev)->caps.hca_cur[MLX5_CAP_IPSEC], cap)
 
+#define MLX5_CAP_DEV_NVMEOTCP(mdev, cap)\
+	MLX5_GET(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
+#define MLX5_CAP64_NVMEOTCP(mdev, cap)\
+	MLX5_GET64(nvmeotcp_cap, mdev->caps.hca_cur[MLX5_CAP_DEV_NVMEOTCP], cap)
+
 enum {
 	MLX5_CMD_STAT_OK			= 0x0,
 	MLX5_CMD_STAT_INT_ERR			= 0x1,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index b9f5894f6f8d..ae6edf08a70b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1278,7 +1278,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_srq_sz[0x8];
 	u8         log_max_qp_sz[0x8];
 	u8         event_cap[0x1];
-	u8         reserved_at_91[0x7];
+	u8         reserved_at_91[0x5];
+	u8         nvmeotcp[0x1];
+	u8         reserved_at_97[0x1];
 	u8         prio_tag_required[0x1];
 	u8         reserved_at_99[0x2];
 	u8         log_max_qp[0x5];
@@ -3029,6 +3031,21 @@ struct mlx5_ifc_roce_addr_layout_bits {
 	u8         reserved_at_e0[0x20];
 };
 
+struct mlx5_ifc_nvmeotcp_cap_bits {
+	u8    zerocopy[0x1];
+	u8    crc_rx[0x1];
+	u8    crc_tx[0x1];
+	u8    reserved_at_3[0x15];
+	u8    version[0x8];
+
+	u8    reserved_at_20[0x13];
+	u8    log_max_nvmeotcp_tag_buffer_table[0x5];
+	u8    reserved_at_38[0x3];
+	u8    log_max_nvmeotcp_tag_buffer_size[0x5];
+
+	u8    reserved_at_40[0x7c0];
+};
+
 union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_cmd_hca_cap_bits cmd_hca_cap;
 	struct mlx5_ifc_odp_cap_bits odp_cap;
@@ -3045,6 +3062,7 @@ union mlx5_ifc_hca_cap_union_bits {
 	struct mlx5_ifc_tls_cap_bits tls_cap;
 	struct mlx5_ifc_device_mem_cap_bits device_mem_cap;
 	struct mlx5_ifc_virtio_emulation_cap_bits virtio_emulation_cap;
+	struct mlx5_ifc_nvmeotcp_cap_bits nvmeotcp_cap;
 	u8         reserved_at_0[0x8000];
 };
 
@@ -3239,7 +3257,9 @@ struct mlx5_ifc_tirc_bits {
 
 	u8         disp_type[0x4];
 	u8         tls_en[0x1];
-	u8         reserved_at_25[0x1b];
+	u8         nvmeotcp_zero_copy_en[0x1];
+	u8         nvmeotcp_crc_en[0x1];
+	u8         reserved_at_27[0x19];
 
 	u8         reserved_at_40[0x40];
 
@@ -3270,7 +3290,8 @@ struct mlx5_ifc_tirc_bits {
 
 	struct mlx5_ifc_rx_hash_field_select_bits rx_hash_field_selector_inner;
 
-	u8         reserved_at_2c0[0x4c0];
+	u8         nvmeotcp_tag_buffer_table_id[0x20];
+	u8         reserved_at_2e0[0x4a0];
 };
 
 enum {
@@ -10745,12 +10766,14 @@ enum {
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = BIT_ULL(0xc),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_IPSEC = BIT_ULL(0x13),
 	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_SAMPLER = BIT_ULL(0x20),
+	MLX5_HCA_CAP_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = BIT_ULL(0x21),
 };
 
 enum {
 	MLX5_GENERAL_OBJECT_TYPES_ENCRYPTION_KEY = 0xc,
 	MLX5_GENERAL_OBJECT_TYPES_IPSEC = 0x13,
 	MLX5_GENERAL_OBJECT_TYPES_SAMPLER = 0x20,
+	MLX5_GENERAL_OBJECT_TYPES_NVMEOTCP_TAG_BUFFER_TABLE = 0x21
 };
 
 enum {
@@ -10852,6 +10875,20 @@ struct mlx5_ifc_create_sampler_obj_in_bits {
 	struct mlx5_ifc_sampler_obj_bits sampler_object;
 };
 
+struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits {
+	u8    modify_field_select[0x40];
+
+	u8    reserved_at_20[0x20];
+
+	u8    reserved_at_40[0x1b];
+	u8    log_tag_buffer_table_size[0x5];
+};
+
+struct mlx5_ifc_create_nvmeotcp_tag_buf_table_in_bits {
+	struct mlx5_ifc_general_obj_in_cmd_hdr_bits general_obj_in_cmd_hdr;
+	struct mlx5_ifc_nvmeotcp_tag_buf_table_obj_bits nvmeotcp_tag_buf_table_obj;
+};
+
 enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_128 = 0x0,
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_KEY_SIZE_256 = 0x1,
@@ -10862,6 +10899,18 @@ enum {
 	MLX5_GENERAL_OBJECT_TYPE_ENCRYPTION_KEY_TYPE_IPSEC = 0x2,
 };
 
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_XTS               = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_TLS               = 0x1,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP           = 0x2,
+	MLX5_TRANSPORT_STATIC_PARAMS_ACC_TYPE_NVMETCP_WITH_TLS  = 0x3,
+};
+
+enum {
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_INITIATOR  = 0x0,
+	MLX5_TRANSPORT_STATIC_PARAMS_TI_TARGET     = 0x1,
+};
+
 struct mlx5_ifc_tls_static_params_bits {
 	u8         const_2[0x2];
 	u8         tls_version[0x4];
@@ -10902,4 +10951,50 @@ enum {
 	MLX5_MTT_PERM_RW	= MLX5_MTT_PERM_READ | MLX5_MTT_PERM_WRITE,
 };
 
+struct mlx5_ifc_nvmeotcp_progress_params_bits {
+	u8    next_pdu_tcp_sn[0x20];
+
+	u8    hw_resync_tcp_sn[0x20];
+
+	u8    pdu_tracker_state[0x2];
+	u8    offloading_state[0x2];
+	u8    reserved_at_64[0xc];
+	u8    cccid_ttag[0x10];
+};
+
+struct mlx5_ifc_transport_static_params_bits {
+	u8    const_2[0x2];
+	u8    tls_version[0x4];
+	u8    const_1[0x2];
+	u8    reserved_at_8[0x14];
+	u8    acc_type[0x4];
+
+	u8    reserved_at_20[0x20];
+
+	u8    initial_record_number[0x40];
+
+	u8    resync_tcp_sn[0x20];
+
+	u8    gcm_iv[0x20];
+
+	u8    implicit_iv[0x40];
+
+	u8    reserved_at_100[0x8];
+	u8    dek_index[0x18];
+
+	u8    reserved_at_120[0x14];
+	u8    const1[0x1];
+	u8    ti[0x1];
+	u8    zero_copy_en[0x1];
+	u8    ddgst_offload_en[0x1];
+	u8    hdgst_offload_en[0x1];
+	u8    ddgst_en[0x1];
+	u8    hddgst_en[0x1];
+	u8    pda[0x5];
+
+	u8    nvme_resync_tcp_sn[0x20];
+
+	u8    reserved_at_160[0xa0];
+};
+
 #endif /* MLX5_IFC_H */
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index d75ef8aa8fac..5fa8b82c9edb 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -220,6 +220,7 @@ struct mlx5_wqe_ctrl_seg {
 #define MLX5_WQE_CTRL_OPCODE_MASK 0xff
 #define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
 #define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
+#define MLX5_WQE_CTRL_TIR_TIS_INDEX_SHIFT 8
 
 enum {
 	MLX5_ETH_WQE_L3_INNER_CSUM      = 1 << 4,
-- 
2.24.1


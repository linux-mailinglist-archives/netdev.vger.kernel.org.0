Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6621B2BB99C
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 00:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728923AbgKTXET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 18:04:19 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:1191 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728578AbgKTXEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 18:04:11 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb84b5f0004>; Fri, 20 Nov 2020 15:03:59 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 20 Nov
 2020 23:04:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH mlx5-next 08/16] net/mlx5: Update the hardware interface definition for vhca state
Date:   Fri, 20 Nov 2020 15:03:31 -0800
Message-ID: <20201120230339.651609-9-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201120230339.651609-1-saeedm@nvidia.com>
References: <20201120230339.651609-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605913439; bh=gSE417QRbW1iT/sEWv7refMf3aOx6qE4qMBjoyEhK2g=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=RcHhJ4dGV+/Cr1g/ZSJaa006rsg6AXHAKMFd+CmTtCZ8WN0i65GRKBlLPvs3GHs/8
         lI1YVJG3JxXGHGuLbJI+xmkRhN4FEMhmYM9X/dGULdIgaFdpKGpFDwn7SPK7gkXclb
         W39zYCRGuNd70jJkkkvMaSmfWBfVzt+/dnJp7rwyjuhwLzSNqsh5Z3mYSrKAKvgKbl
         G9hLe7R+qQrvKfmp8g1npwUyiPX+8J9tIwb26c9cABnPsZ9jAVj9O/JApreN03eGff
         AVeBYkR22hbX3Ih6+L04YNZ6KuItL2MOR+XrpJT7U+Nn7dUfeN10SoxeEMLpkhfwOd
         n27hAlU8DIFMA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Update the hardware interface definitions to query and modify vhca
state, related EQE and event code.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/device.h   |  7 +++++++
 include/linux/mlx5/mlx5_ifc.h | 17 ++++++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index e9639c4cf2ed..f1de49d64a98 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -346,6 +346,7 @@ enum mlx5_event {
 	MLX5_EVENT_TYPE_NIC_VPORT_CHANGE   =3D 0xd,
=20
 	MLX5_EVENT_TYPE_ESW_FUNCTIONS_CHANGED =3D 0xe,
+	MLX5_EVENT_TYPE_VHCA_STATE_CHANGE =3D 0xf,
=20
 	MLX5_EVENT_TYPE_DCT_DRAINED        =3D 0x1c,
 	MLX5_EVENT_TYPE_DCT_KEY_VIOLATION  =3D 0x1d,
@@ -717,6 +718,11 @@ struct mlx5_eqe_sync_fw_update {
 	u8 sync_rst_state;
 };
=20
+struct mlx5_eqe_vhca_state {
+	__be16 ec_function;
+	__be16 function_id;
+} __packed;
+
 union ev_data {
 	__be32				raw[7];
 	struct mlx5_eqe_cmd		cmd;
@@ -736,6 +742,7 @@ union ev_data {
 	struct mlx5_eqe_temp_warning	temp_warning;
 	struct mlx5_eqe_xrq_err		xrq_err;
 	struct mlx5_eqe_sync_fw_update	sync_fw_update;
+	struct mlx5_eqe_vhca_state	vhca_state;
 } __packed;
=20
 struct mlx5_eqe {
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 632b9a61fda5..3ace1976514c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -299,6 +299,8 @@ enum {
 	MLX5_CMD_OP_CREATE_UMEM                   =3D 0xa08,
 	MLX5_CMD_OP_DESTROY_UMEM                  =3D 0xa0a,
 	MLX5_CMD_OP_SYNC_STEERING                 =3D 0xb00,
+	MLX5_CMD_OP_QUERY_VHCA_STATE              =3D 0xb0d,
+	MLX5_CMD_OP_MODIFY_VHCA_STATE             =3D 0xb0e,
 	MLX5_CMD_OP_MAX
 };
=20
@@ -1244,7 +1246,15 @@ enum mlx5_fc_bulk_alloc_bitmask {
 #define MLX5_FC_BULK_NUM_FCS(fc_enum) (MLX5_FC_BULK_SIZE_FACTOR * (fc_enum=
))
=20
 struct mlx5_ifc_cmd_hca_cap_bits {
-	u8         reserved_at_0[0x30];
+	u8         reserved_at_0[0x20];
+
+	u8         reserved_at_20[0x3];
+	u8         event_on_vhca_state_teardown_request[0x1];
+	u8         event_on_vhca_state_in_use[0x1];
+	u8         event_on_vhca_state_active[0x1];
+	u8         event_on_vhca_state_allocated[0x1];
+	u8         event_on_vhca_state_invalid[0x1];
+	u8         reserved_at_28[0x8];
 	u8         vhca_id[0x10];
=20
 	u8         reserved_at_40[0x40];
@@ -1534,7 +1544,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         disable_local_lb_uc[0x1];
 	u8         disable_local_lb_mc[0x1];
 	u8         log_min_hairpin_wq_data_sz[0x5];
-	u8         reserved_at_3e8[0x3];
+	u8         reserved_at_3e8[0x2];
+	u8         vhca_state[0x1];
 	u8         log_max_vlan_list[0x5];
 	u8         reserved_at_3f0[0x3];
 	u8         log_max_current_mc_list[0x5];
@@ -1602,7 +1613,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         max_num_of_monitor_counters[0x10];
 	u8         num_ppcnt_monitor_counters[0x10];
=20
-	u8         reserved_at_640[0x10];
+	u8         max_num_sf[0x10];
 	u8         num_q_monitor_counters[0x10];
=20
 	u8         reserved_at_660[0x20];
--=20
2.26.2


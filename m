Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF88B2B6FA7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731630AbgKQUHs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:07:48 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:1942 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730654AbgKQUHr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:07:47 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fb42d960003>; Tue, 17 Nov 2020 12:07:50 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 17 Nov
 2020 20:07:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Huy Nguyen" <huyn@mellanox.com>, Raed Salem <raeds@nvidia.com>,
        Ariel Levkovich <lariel@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 3/9] net/mlx5e: Fix IPsec packet drop by mlx5e_tc_update_skb
Date:   Tue, 17 Nov 2020 11:56:56 -0800
Message-ID: <20201117195702.386113-4-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201117195702.386113-1-saeedm@nvidia.com>
References: <20201117195702.386113-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1605643670; bh=RrJO2dT9NWn3zKlmYNaEWytSeKWXHI40hKOWN6xSP1w=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=fVVtGC84na+PCzYDnvjjUuxNbc7n2/MdCZ/cMSRsqIR6ncA2pI4zPz+D9yx+P3GhI
         pikznxa+v7R+KVTF+KyOFoY73zuGD/UsN9SIgydRNfsU6N81C+66hghQUXGZIViMba
         Ou9qqSfH0dOuibqCwyjVJwYI/Cxp2RWTEKGm4/r7TR8E+4HFzaF5AGSPUptn6keYaX
         hmjbYAt+62qnipIKnuzM7n/ORgUCyZtLAoJfDkOnNTZhuxmoDt6TW5LtWiQu6R7NgH
         T2WQ/2oICmt7/Cpt+HA2VGhc43o5T0Vpm8xTmncZao1fdPe7HBCrvA+48/TZF2Ev+g
         U/CD0Zdj6ZeVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

Both TC and IPsec crypto offload use metadata_regB to store
private information. Since TC does not use bit 31 of regB, IPsec
will use bit 31 as the IPsec packet marker. The IPsec's regB usage
is changed to:
Bit31: IPsec marker
Bit30-24: IPsec syndrome
Bit23-0: IPsec obj id

Fixes: b2ac7541e377 ("net/mlx5e: IPsec: Add Connect-X IPsec Rx data path of=
fload")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Ariel Levkovich <lariel@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_fs.c         | 14 +++++++-------
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c       |  3 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |  9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  3 +++
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 0e45590662a8..381a9c8c9da9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -64,13 +64,13 @@ static int rx_err_add_rule(struct mlx5e_priv *priv,
 	if (!spec)
 		return -ENOMEM;
=20
-	/* Action to copy 7 bit ipsec_syndrome to regB[0:6] */
+	/* Action to copy 7 bit ipsec_syndrome to regB[24:30] */
 	MLX5_SET(copy_action_in, action, action_type, MLX5_ACTION_TYPE_COPY);
 	MLX5_SET(copy_action_in, action, src_field, MLX5_ACTION_IN_FIELD_IPSEC_SY=
NDROME);
 	MLX5_SET(copy_action_in, action, src_offset, 0);
 	MLX5_SET(copy_action_in, action, length, 7);
 	MLX5_SET(copy_action_in, action, dst_field, MLX5_ACTION_IN_FIELD_METADATA=
_REG_B);
-	MLX5_SET(copy_action_in, action, dst_offset, 0);
+	MLX5_SET(copy_action_in, action, dst_offset, 24);
=20
 	modify_hdr =3D mlx5_modify_header_alloc(mdev, MLX5_FLOW_NAMESPACE_KERNEL,
 					      1, action);
@@ -488,13 +488,13 @@ static int rx_add_rule(struct mlx5e_priv *priv,
=20
 	setup_fte_common(attrs, ipsec_obj_id, spec, &flow_act);
=20
-	/* Set 1  bit ipsec marker */
-	/* Set 24 bit ipsec_obj_id */
+	/* Set bit[31] ipsec marker */
+	/* Set bit[23-0] ipsec_obj_id */
 	MLX5_SET(set_action_in, action, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, action, field, MLX5_ACTION_IN_FIELD_METADATA_REG_=
B);
-	MLX5_SET(set_action_in, action, data, (ipsec_obj_id << 1) | 0x1);
-	MLX5_SET(set_action_in, action, offset, 7);
-	MLX5_SET(set_action_in, action, length, 25);
+	MLX5_SET(set_action_in, action, data, (ipsec_obj_id | BIT(31)));
+	MLX5_SET(set_action_in, action, offset, 0);
+	MLX5_SET(set_action_in, action, length, 32);
=20
 	modify_hdr =3D mlx5_modify_header_alloc(priv->mdev, MLX5_FLOW_NAMESPACE_K=
ERNEL,
 					      1, action);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 11e31a3db2be..a9b45606dbdb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -453,7 +453,6 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_devic=
e *netdev,
 				       struct mlx5_cqe64 *cqe)
 {
 	u32 ipsec_meta_data =3D be32_to_cpu(cqe->ft_metadata);
-	u8 ipsec_syndrome =3D ipsec_meta_data & 0xFF;
 	struct mlx5e_priv *priv;
 	struct xfrm_offload *xo;
 	struct xfrm_state *xs;
@@ -481,7 +480,7 @@ void mlx5e_ipsec_offload_handle_rx_skb(struct net_devic=
e *netdev,
 	xo =3D xfrm_offload(skb);
 	xo->flags =3D CRYPTO_DONE;
=20
-	switch (ipsec_syndrome & MLX5_IPSEC_METADATA_SYNDROM_MASK) {
+	switch (MLX5_IPSEC_METADATA_SYNDROM(ipsec_meta_data)) {
 	case MLX5E_IPSEC_OFFLOAD_RX_SYNDROME_DECRYPTED:
 		xo->status =3D CRYPTO_SUCCESS;
 		if (WARN_ON_ONCE(priv->ipsec->no_trailer))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 056dacb612b0..9df9b9a8e09b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -39,9 +39,10 @@
 #include "en.h"
 #include "en/txrx.h"
=20
-#define MLX5_IPSEC_METADATA_MARKER_MASK      (0x80)
-#define MLX5_IPSEC_METADATA_SYNDROM_MASK     (0x7F)
-#define MLX5_IPSEC_METADATA_HANDLE(metadata) (((metadata) >> 8) & 0xFF)
+/* Bit31: IPsec marker, Bit30-24: IPsec syndrome, Bit23-0: IPsec obj id */
+#define MLX5_IPSEC_METADATA_MARKER(metadata)  (((metadata) >> 31) & 0x1)
+#define MLX5_IPSEC_METADATA_SYNDROM(metadata) (((metadata) >> 24) & GENMAS=
K(6, 0))
+#define MLX5_IPSEC_METADATA_HANDLE(metadata)  ((metadata) & GENMASK(23, 0)=
)
=20
 struct mlx5e_accel_tx_ipsec_state {
 	struct xfrm_offload *xo;
@@ -78,7 +79,7 @@ static inline unsigned int mlx5e_ipsec_tx_ids_len(struct =
mlx5e_accel_tx_ipsec_st
=20
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
-	return !!(MLX5_IPSEC_METADATA_MARKER_MASK & be32_to_cpu(cqe->ft_metadata)=
);
+	return MLX5_IPSEC_METADATA_MARKER(be32_to_cpu(cqe->ft_metadata));
 }
=20
 static inline bool mlx5e_ipsec_is_tx_flow(struct mlx5e_accel_tx_ipsec_stat=
e *ipsec_st)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.h
index 3b979008143d..4a2ce241522e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -283,6 +283,9 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe=
64 *cqe)
=20
 	reg_b =3D be32_to_cpu(cqe->ft_metadata);
=20
+	if (reg_b >> (MLX5E_TC_TABLE_CHAIN_TAG_BITS + ZONE_RESTORE_BITS))
+		return false;
+
 	chain =3D reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 	if (chain)
 		return true;
--=20
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC4F2A5064
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729755AbgKCTsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:48:16 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:9529 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729744AbgKCTsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 14:48:15 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa1b4010000>; Tue, 03 Nov 2020 11:48:17 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 3 Nov
 2020 19:48:13 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 09/12] net/mlx5e: Validate stop_room size upon user input
Date:   Tue, 3 Nov 2020 11:47:35 -0800
Message-ID: <20201103194738.64061-10-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103194738.64061-1-saeedm@nvidia.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604432897; bh=CJB8O77wDgEHskKRRD2jToipui54u7BkOv5ptKhXjBM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=CBVjgYJaEKr1yyj19lhB8QVgz0cnR0MBTX3P4nexpMvM0+Gnv8a5qUUkabhv2foPx
         WFFX+kd1MugUmlPDubOl2wWbeWjB9Ge37ouf7JP2plQHCraBwFQr/MiUs8xniIK5sO
         DCxMlqOZ4icmwgTPFUl4tZUL4KdlIbAQUu5jKRWnUTliXelhWuHfIjmNSKV4CS9H6e
         GdoIXNsMVoSouWbhQIc4viIuUzMa9UOfsExGjUxM7i2dgi6MZYrbyBhoXRys3yR4LL
         F8tR/d16M5f/DHEPvaN0UmqjXBRrnDKh5SjzxW+mZ1ZjZ5iYLpdjLOa0SSfJY+qc7P
         NlmlpXEr8liPw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>

Stop room is a space that may be taken by WQEs in the SQ during a packet
transmit. It is used to check if next packet has enough room in the SQ.
Stop room guarantees this packet can be served and if not, the queue is
stopped, so no more packets are passed to the driver until it's ready.

Currently, stop_room size is calculated and validated upon tx queues
allocation. This makes it impossible to know if user provided valid
input for certain parameters when interface is down.

Instead, store stop_room in mlx5e_sq_param and create
mlx5e_validate_params(), to validate its fields upon user input even
when the interface is down.

Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/params.c   | 34 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/en/params.h   |  4 +++
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     |  8 ++---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h   |  2 +-
 .../mellanox/mlx5/core/en_accel/tls_rxtx.c    |  6 ++--
 .../mellanox/mlx5/core/en_accel/tls_rxtx.h    |  4 +--
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  5 +++
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 30 +++-------------
 8 files changed, 57 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.c
index 38e4f19d69f8..7f7ae6e2ccbb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.c
@@ -2,6 +2,8 @@
 /* Copyright (c) 2019 Mellanox Technologies. */
=20
 #include "en/params.h"
+#include "en/txrx.h"
+#include "en_accel/tls_rxtx.h"
=20
 static inline bool mlx5e_rx_is_xdp(struct mlx5e_params *params,
 				   struct mlx5e_xsk_param *xsk)
@@ -152,3 +154,35 @@ u16 mlx5e_get_rq_headroom(struct mlx5_core_dev *mdev,
=20
 	return is_linear_skb ? mlx5e_get_linear_rq_headroom(params, xsk) : 0;
 }
+
+u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_param=
s *params)
+{
+	bool is_mpwqe =3D MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
+	u16 stop_room;
+
+	stop_room  =3D mlx5e_tls_get_stop_room(mdev, params);
+	stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+	if (is_mpwqe)
+		/* A MPWQE can take up to the maximum-sized WQE + all the normal
+		 * stop room can be taken if a new packet breaks the active
+		 * MPWQE session and allocates its WQEs right away.
+		 */
+		stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
+
+	return stop_room;
+}
+
+int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *pa=
rams)
+{
+	size_t sq_size =3D 1 << params->log_sq_size;
+	u16 stop_room;
+
+	stop_room =3D mlx5e_calc_sq_stop_room(priv->mdev, params);
+	if (stop_room >=3D sq_size) {
+		netdev_err(priv->netdev, "Stop room %hu is bigger than the SQ size %lu\n=
",
+			   stop_room, sq_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/params.h
index a87273e801b2..187007ad3349 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/params.h
@@ -30,6 +30,7 @@ struct mlx5e_sq_param {
 	u32                        sqc[MLX5_ST_SZ_DW(sqc)];
 	struct mlx5_wq_param       wq;
 	bool                       is_mpw;
+	u16                        stop_room;
 };
=20
 struct mlx5e_channel_param {
@@ -124,4 +125,7 @@ void mlx5e_build_xdpsq_param(struct mlx5e_priv *priv,
 			     struct mlx5e_params *params,
 			     struct mlx5e_sq_param *param);
=20
+u16 mlx5e_calc_sq_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_param=
s *params);
+int mlx5e_validate_params(struct mlx5e_priv *priv, struct mlx5e_params *pa=
rams);
+
 #endif /* __MLX5_EN_PARAMS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index b140e13fdcc8..d16def68ecff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -13,20 +13,20 @@ struct mlx5e_dump_wqe {
 	(DIV_ROUND_UP(sizeof(struct mlx5e_dump_wqe), MLX5_SEND_WQE_BB))
=20
 static u8
-mlx5e_ktls_dumps_num_wqes(struct mlx5e_txqsq *sq, unsigned int nfrags,
+mlx5e_ktls_dumps_num_wqes(struct mlx5e_params *params, unsigned int nfrags=
,
 			  unsigned int sync_len)
 {
 	/* Given the MTU and sync_len, calculates an upper bound for the
 	 * number of DUMP WQEs needed for the TX resync of a record.
 	 */
-	return nfrags + DIV_ROUND_UP(sync_len, sq->hw_mtu);
+	return nfrags + DIV_ROUND_UP(sync_len, MLX5E_SW2HW_MTU(params, params->sw=
_mtu));
 }
=20
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq)
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_params *params)
 {
 	u16 num_dumps, stop_room =3D 0;
=20
-	num_dumps =3D mlx5e_ktls_dumps_num_wqes(sq, MAX_SKB_FRAGS, TLS_MAX_PAYLOA=
D_SIZE);
+	num_dumps =3D mlx5e_ktls_dumps_num_wqes(params, MAX_SKB_FRAGS, TLS_MAX_PA=
YLOAD_SIZE);
=20
 	stop_room +=3D mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_STATIC_PARAMS_WQEBBS=
);
 	stop_room +=3D mlx5e_stop_room_for_wqe(MLX5E_TLS_SET_PROGRESS_PARAMS_WQEB=
BS);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b=
/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index 7521c9be735b..ee04e916fa21 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -14,7 +14,7 @@ struct mlx5e_accel_tx_tls_state {
 	u32 tls_tisn;
 };
=20
-u16 mlx5e_ktls_get_stop_room(struct mlx5e_txqsq *sq);
+u16 mlx5e_ktls_get_stop_room(struct mlx5e_params *params);
=20
 bool mlx5e_ktls_handle_tx_skb(struct tls_context *tls_ctx, struct mlx5e_tx=
qsq *sq,
 			      struct sk_buff *skb, int datalen,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
index 6982b193ee8a..f51c04284e4d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.c
@@ -385,15 +385,13 @@ void mlx5e_tls_handle_rx_skb_metadata(struct mlx5e_rq=
 *rq, struct sk_buff *skb,
 	*cqe_bcnt -=3D MLX5E_METADATA_ETHER_LEN;
 }
=20
-u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_param=
s *params)
 {
-	struct mlx5_core_dev *mdev =3D sq->channel->mdev;
-
 	if (!mlx5_accel_is_tls_device(mdev))
 		return 0;
=20
 	if (mlx5_accel_is_ktls_device(mdev))
-		return mlx5e_ktls_get_stop_room(sq);
+		return mlx5e_ktls_get_stop_room(params);
=20
 	/* FPGA */
 	/* Resync SKB. */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
index 5f162ad2ee8f..9923132c9440 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/tls_rxtx.h
@@ -43,7 +43,7 @@
 #include "en.h"
 #include "en/txrx.h"
=20
-u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq);
+u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, struct mlx5e_param=
s *params);
=20
 bool mlx5e_tls_handle_tx_skb(struct net_device *netdev, struct mlx5e_txqsq=
 *sq,
 			     struct sk_buff *skb, struct mlx5e_accel_tx_tls_state *state);
@@ -71,7 +71,7 @@ mlx5e_accel_is_tls(struct mlx5_cqe64 *cqe, struct sk_buff=
 *skb) { return false;
 static inline void
 mlx5e_tls_handle_rx_skb(struct mlx5e_rq *rq, struct sk_buff *skb,
 			struct mlx5_cqe64 *cqe, u32 *cqe_bcnt) {}
-static inline u16 mlx5e_tls_get_stop_room(struct mlx5e_txqsq *sq)
+static inline u16 mlx5e_tls_get_stop_room(struct mlx5_core_dev *mdev, stru=
ct mlx5e_params *params)
 {
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index d25a56ec6876..42e61dc28ead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -32,6 +32,7 @@
=20
 #include "en.h"
 #include "en/port.h"
+#include "en/params.h"
 #include "en/xsk/pool.h"
 #include "lib/clock.h"
=20
@@ -369,6 +370,10 @@ int mlx5e_ethtool_set_ringparam(struct mlx5e_priv *pri=
v,
 	new_channels.params.log_rq_mtu_frames =3D log_rq_size;
 	new_channels.params.log_sq_size =3D log_sq_size;
=20
+	err =3D mlx5e_validate_params(priv, &new_channels.params);
+	if (err)
+		goto unlock;
+
 	if (!test_bit(MLX5E_STATE_OPENED, &priv->state)) {
 		priv->channels.params =3D new_channels.params;
 		goto unlock;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index b3f02aac7f26..8226a9d2b45e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1121,28 +1121,6 @@ static int mlx5e_alloc_txqsq_db(struct mlx5e_txqsq *=
sq, int numa)
 	return 0;
 }
=20
-static int mlx5e_calc_sq_stop_room(struct mlx5e_txqsq *sq, u8 log_sq_size)
-{
-	int sq_size =3D 1 << log_sq_size;
-
-	sq->stop_room  =3D mlx5e_tls_get_stop_room(sq);
-	sq->stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
-	if (test_bit(MLX5E_SQ_STATE_MPWQE, &sq->state))
-		/* A MPWQE can take up to the maximum-sized WQE + all the normal
-		 * stop room can be taken if a new packet breaks the active
-		 * MPWQE session and allocates its WQEs right away.
-		 */
-		sq->stop_room +=3D mlx5e_stop_room_for_wqe(MLX5_SEND_WQE_MAX_WQEBBS);
-
-	if (WARN_ON(sq->stop_room >=3D sq_size)) {
-		netdev_err(sq->channel->netdev, "Stop room %hu is bigger than the SQ siz=
e %d\n",
-			   sq->stop_room, sq_size);
-		return -ENOSPC;
-	}
-
-	return 0;
-}
-
 static void mlx5e_tx_err_cqe_work(struct work_struct *recover_work);
 static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 			     int txq_ix,
@@ -1176,9 +1154,7 @@ static int mlx5e_alloc_txqsq(struct mlx5e_channel *c,
 		set_bit(MLX5E_SQ_STATE_TLS, &sq->state);
 	if (param->is_mpw)
 		set_bit(MLX5E_SQ_STATE_MPWQE, &sq->state);
-	err =3D mlx5e_calc_sq_stop_room(sq, params->log_sq_size);
-	if (err)
-		return err;
+	sq->stop_room =3D param->stop_room;
=20
 	param->wq.db_numa_node =3D cpu_to_node(c->cpu);
 	err =3D mlx5_wq_cyc_create(mdev, &param->wq, sqc_wq, wq, &sq->wq_ctrl);
@@ -2225,6 +2201,7 @@ static void mlx5e_build_sq_param(struct mlx5e_priv *p=
riv,
 	MLX5_SET(wq, wq, log_wq_sz, params->log_sq_size);
 	MLX5_SET(sqc, sqc, allow_swp, allow_swp);
 	param->is_mpw =3D MLX5E_GET_PFLAG(params, MLX5E_PFLAG_SKB_TX_MPWQE);
+	param->stop_room =3D mlx5e_calc_sq_stop_room(priv->mdev, params);
 	mlx5e_build_tx_cq_param(priv, params, &param->cqp);
 }
=20
@@ -3999,6 +3976,9 @@ int mlx5e_change_mtu(struct net_device *netdev, int n=
ew_mtu,
=20
 	new_channels.params =3D *params;
 	new_channels.params.sw_mtu =3D new_mtu;
+	err =3D mlx5e_validate_params(priv, &new_channels.params);
+	if (err)
+		goto out;
=20
 	if (params->xdp_prog &&
 	    !mlx5e_rx_is_linear_skb(&new_channels.params, NULL)) {
--=20
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF1A428C4E1
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 00:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390492AbgJLWma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 18:42:30 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7848 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730707AbgJLWmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 18:42:25 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f84db950002>; Mon, 12 Oct 2020 15:41:25 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 12 Oct
 2020 22:42:13 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Raed Salem" <raeds@mellanox.com>, Huy Nguyen <huyn@mellanox.com>,
        "Maxim Mikityanskiy" <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 4/4] net/mlx5e: IPsec: Add Connect-X IPsec Tx data path offload
Date:   Mon, 12 Oct 2020 15:41:52 -0700
Message-ID: <20201012224152.191479-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201012224152.191479-1-saeedm@nvidia.com>
References: <20201012224152.191479-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602542485; bh=byAsX3s+mbw8FtZXZpAQ3zOXxf4RePq03tfoxX34J5c=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=GXQx/Jb7dHCr5NzzcNi9AblDZXLn5brYZGCvnsZD1MTAWLSQgnRm2NvZuHOtUFmZ2
         dVzOs30ztEneIdWgJkR4Aujay7co9/WSUoRI7ToSfUvhVSaW9zrgrcitcDdU4wpyDO
         WiuzTckyrPsTrozB0mXlPfnyzc7N+Za74yUeJooVbQa1jLefNFz/IHXodD9hhEhJJk
         LEkgMAPJHATQIuPS/rX0Yk/YOw0JUOLvK7C+iQwNxOXTU12xmR4NU+D8mv6tG8Y+dQ
         FIkI8WhJTPaBV7nd8FE0ga1Ulj/8Z/wop/bjWExvtpSqGApvmOTt//NkK4C8Tyu1wL
         r4FXpn2RniQPw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

In the TX data path, spot packets with xfrm stack IPsec offload
indication.

Fill Software-Parser segment in TX descriptor so that the hardware
may parse the ESP protocol, and perform TX checksum offload on the
inner payload.

Support GSO, by providing the trailer data and ICV placeholder
so HW can fill it post encryption operation.

Padding alignment cannot be performed in HW (ConnectX-6Dx) due to
a bug. Software can overcome this limitation by adding NETIF_F_HW_ESP to
the gso_partial_features field in netdev so the packets being
aligned by the stack.

l4_inner_checksum cannot be offloaded by HW for IPsec tunnel type packet.

Note that for GSO SKBs, the stack does not include an ESP trailer,
unlike the non-GSO case.

Below is the iperf3 performance report on two server of 24 cores
Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz with ConnectX6-DX.
All the bandwidth test uses iperf3 TCP traffic with packet size 128KB.
Each tunnel uses one iperf3 stream with one thread (option -P1).
TX crypto offload shows improvements on both bandwidth
and CPU utilization.

----------------------------------------------------------------------
Mode            |  Num tunnel | BW     | Send CPU util | Recv CPU util
                |             | (Gbps) | (Average %)   | (Average %)
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(RX only)       | 1           | 4.7    | 4.2           | 3.5
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(RX only)       | 24          | 15.6   | 20            | 10
----------------------------------------------------------------------
Non-offload     | 1           | 4.6    | 4             | 5
----------------------------------------------------------------------
Non-offload     | 24          | 11.9   | 16            | 12
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(TX & RX)       | 1           | 11.9   | 2.1           | 5.9
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(TX & RX)       | 24          | 38     | 9.5           | 27.5
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(TX only)       | 1           | 4.7    | 0.7           | 5
----------------------------------------------------------------------
Cryto offload   |             |        |               |
(TX only)       | 24          | 14.5   | 6             | 20

Regression tests show no degradation on non-ipsec and
non-offload-ipsec traffics. The packet rate test uses pktgen UDP to
transmit on single CPU, the instructions and cycles are measured on
the transmit CPU.

before:
----------------------------------------------------------------------
Non-offload             | 1           | 4.7    | 4.2           | 5.1
----------------------------------------------------------------------
Non-offload             | 24          | 11.2   | 14            | 15
----------------------------------------------------------------------
Non-ipsec               | 1           | 28     | 4             | 5.7
----------------------------------------------------------------------
Non-ipsec               | 24          | 68.3   | 17.8          | 39.7
----------------------------------------------------------------------
Non-ipsec packet rate(BURST=3D1000 BC=3D5 NCPUS=3D1 SIZE=3D60)
13.56Mpps, 456 instructions/pkt, 191 cycles/pkt

after:
----------------------------------------------------------------------
Non-offload             | 1           | 4.69    | 4.2          | 5
----------------------------------------------------------------------
Non-offload             | 24          | 11.9   | 13.5          | 15.1
----------------------------------------------------------------------
Non-ipsec               | 1           | 29     | 3.2           | 5.5
----------------------------------------------------------------------
Non-ipsec               | 24          | 68.2   | 18.5          | 39.8
----------------------------------------------------------------------
Non-ipsec packet rate: 13.56Mpps, 472 instructions/pkt, 191 cycles/pkt

Signed-off-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/en_accel.h    |  46 +++++++-
 .../mellanox/mlx5/core/en_accel/ipsec.c       |   3 +
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 110 +++++++++++++++---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  29 ++++-
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   |  43 ++++++-
 5 files changed, 202 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/=
drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 2ea1cdc1ca54..899b98aca0d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -107,6 +107,9 @@ struct mlx5e_accel_tx_state {
 #ifdef CONFIG_MLX5_EN_TLS
 	struct mlx5e_accel_tx_tls_state tls;
 #endif
+#ifdef CONFIG_MLX5_EN_IPSEC
+	struct mlx5e_accel_tx_ipsec_state ipsec;
+#endif
 };
=20
 static inline bool mlx5e_accel_tx_begin(struct net_device *dev,
@@ -125,22 +128,46 @@ static inline bool mlx5e_accel_tx_begin(struct net_de=
vice *dev,
 	}
 #endif
=20
+#ifdef CONFIG_MLX5_EN_IPSEC
+	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state) && xfrm_offload(skb)) {
+		if (unlikely(!mlx5e_ipsec_handle_tx_skb(dev, skb, &state->ipsec)))
+			return false;
+	}
+#endif
+
 	return true;
 }
=20
+static inline bool mlx5e_accel_tx_is_ipsec_flow(struct mlx5e_accel_tx_stat=
e *state)
+{
+#ifdef CONFIG_MLX5_EN_IPSEC
+	return mlx5e_ipsec_is_tx_flow(&state->ipsec);
+#endif
+
+	return false;
+}
+
+static inline unsigned int mlx5e_accel_tx_ids_len(struct mlx5e_txqsq *sq,
+						  struct mlx5e_accel_tx_state *state)
+{
+#ifdef CONFIG_MLX5_EN_IPSEC
+	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state))
+		return mlx5e_ipsec_tx_ids_len(&state->ipsec);
+#endif
+
+	return 0;
+}
+
 /* Part of the eseg touched by TX offloads */
 #define MLX5E_ACCEL_ESEG_LEN offsetof(struct mlx5_wqe_eth_seg, mss)
=20
 static inline bool mlx5e_accel_tx_eseg(struct mlx5e_priv *priv,
-				       struct mlx5e_txqsq *sq,
 				       struct sk_buff *skb,
 				       struct mlx5_wqe_eth_seg *eseg)
 {
 #ifdef CONFIG_MLX5_EN_IPSEC
-	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state)) {
-		if (unlikely(!mlx5e_ipsec_handle_tx_skb(priv, eseg, skb)))
-			return false;
-	}
+	if (xfrm_offload(skb))
+		mlx5e_ipsec_tx_build_eseg(priv, skb, eseg);
 #endif
=20
 #if IS_ENABLED(CONFIG_GENEVE)
@@ -153,11 +180,18 @@ static inline bool mlx5e_accel_tx_eseg(struct mlx5e_p=
riv *priv,
=20
 static inline void mlx5e_accel_tx_finish(struct mlx5e_txqsq *sq,
 					 struct mlx5e_tx_wqe *wqe,
-					 struct mlx5e_accel_tx_state *state)
+					 struct mlx5e_accel_tx_state *state,
+					 struct mlx5_wqe_inline_seg *inlseg)
 {
 #ifdef CONFIG_MLX5_EN_TLS
 	mlx5e_tls_handle_tx_wqe(sq, &wqe->ctrl, &state->tls);
 #endif
+
+#ifdef CONFIG_MLX5_EN_IPSEC
+	if (test_bit(MLX5E_SQ_STATE_IPSEC, &sq->state) &&
+	    state->ipsec.xo && state->ipsec.tailen)
+		mlx5e_ipsec_handle_tx_wqe(wqe, &state->ipsec, inlseg);
+#endif
 }
=20
 static inline int mlx5e_accel_init_rx(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/dri=
vers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index d39989cddd90..3d45341e2216 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -560,6 +560,9 @@ void mlx5e_ipsec_build_netdev(struct mlx5e_priv *priv)
 		return;
 	}
=20
+	if (mlx5_is_ipsec_device(mdev))
+		netdev->gso_partial_features |=3D NETIF_F_GSO_ESP;
+
 	mlx5_core_dbg(mdev, "mlx5e: ESP GSO capability turned on\n");
 	netdev->features |=3D NETIF_F_GSO_ESP;
 	netdev->hw_features |=3D NETIF_F_GSO_ESP;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index 93a8d68815ad..11e31a3db2be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -34,7 +34,7 @@
 #include <crypto/aead.h>
 #include <net/xfrm.h>
 #include <net/esp.h>
-
+#include "accel/ipsec_offload.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en_accel/ipsec.h"
 #include "accel/accel.h"
@@ -233,18 +233,94 @@ static void mlx5e_ipsec_set_metadata(struct sk_buff *=
skb,
 		   ntohs(mdata->content.tx.seq));
 }
=20
-bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *priv,
-			       struct mlx5_wqe_eth_seg *eseg,
-			       struct sk_buff *skb)
+void mlx5e_ipsec_handle_tx_wqe(struct mlx5e_tx_wqe *wqe,
+			       struct mlx5e_accel_tx_ipsec_state *ipsec_st,
+			       struct mlx5_wqe_inline_seg *inlseg)
+{
+	inlseg->byte_count =3D cpu_to_be32(ipsec_st->tailen | MLX5_INLINE_SEG);
+	esp_output_fill_trailer((u8 *)inlseg->data, 0, ipsec_st->plen, ipsec_st->=
xo->proto);
+}
+
+static int mlx5e_ipsec_set_state(struct mlx5e_priv *priv,
+				 struct sk_buff *skb,
+				 struct xfrm_state *x,
+				 struct xfrm_offload *xo,
+				 struct mlx5e_accel_tx_ipsec_state *ipsec_st)
+{
+	unsigned int blksize, clen, alen, plen;
+	struct crypto_aead *aead;
+	unsigned int tailen;
+
+	ipsec_st->x =3D x;
+	ipsec_st->xo =3D xo;
+	if (mlx5_is_ipsec_device(priv->mdev)) {
+		aead =3D x->data;
+		alen =3D crypto_aead_authsize(aead);
+		blksize =3D ALIGN(crypto_aead_blocksize(aead), 4);
+		clen =3D ALIGN(skb->len + 2, blksize);
+		plen =3D max_t(u32, clen - skb->len, 4);
+		tailen =3D plen + alen;
+		ipsec_st->plen =3D plen;
+		ipsec_st->tailen =3D tailen;
+	}
+
+	return 0;
+}
+
+void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *sk=
b,
+			       struct mlx5_wqe_eth_seg *eseg)
 {
 	struct xfrm_offload *xo =3D xfrm_offload(skb);
-	struct mlx5e_ipsec_metadata *mdata;
-	struct mlx5e_ipsec_sa_entry *sa_entry;
+	struct xfrm_encap_tmpl  *encap;
 	struct xfrm_state *x;
 	struct sec_path *sp;
+	u8 l3_proto;
+
+	sp =3D skb_sec_path(skb);
+	if (unlikely(sp->len !=3D 1))
+		return;
+
+	x =3D xfrm_input_state(skb);
+	if (unlikely(!x))
+		return;
+
+	if (unlikely(!x->xso.offload_handle ||
+		     (skb->protocol !=3D htons(ETH_P_IP) &&
+		      skb->protocol !=3D htons(ETH_P_IPV6))))
+		return;
+
+	mlx5e_ipsec_set_swp(skb, eseg, x->props.mode, xo);
=20
-	if (!xo)
-		return true;
+	l3_proto =3D (x->props.family =3D=3D AF_INET) ?
+		   ((struct iphdr *)skb_network_header(skb))->protocol :
+		   ((struct ipv6hdr *)skb_network_header(skb))->nexthdr;
+
+	if (mlx5_is_ipsec_device(priv->mdev)) {
+		eseg->flow_table_metadata |=3D cpu_to_be32(MLX5_ETH_WQE_FT_META_IPSEC);
+		eseg->trailer |=3D cpu_to_be32(MLX5_ETH_WQE_INSERT_TRAILER);
+		encap =3D x->encap;
+		if (!encap) {
+			eseg->trailer |=3D (l3_proto =3D=3D IPPROTO_ESP) ?
+				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_IP_ASSOC) :
+				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_OUTER_L4_ASSOC);
+		} else if (encap->encap_type =3D=3D UDP_ENCAP_ESPINUDP) {
+			eseg->trailer |=3D (l3_proto =3D=3D IPPROTO_ESP) ?
+				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_IP_ASSOC) :
+				cpu_to_be32(MLX5_ETH_WQE_TRAILER_HDR_INNER_L4_ASSOC);
+		}
+	}
+}
+
+bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+			       struct sk_buff *skb,
+			       struct mlx5e_accel_tx_ipsec_state *ipsec_st)
+{
+	struct mlx5e_priv *priv =3D netdev_priv(netdev);
+	struct xfrm_offload *xo =3D xfrm_offload(skb);
+	struct mlx5e_ipsec_sa_entry *sa_entry;
+	struct mlx5e_ipsec_metadata *mdata;
+	struct xfrm_state *x;
+	struct sec_path *sp;
=20
 	sp =3D skb_sec_path(skb);
 	if (unlikely(sp->len !=3D 1)) {
@@ -270,15 +346,21 @@ bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *pri=
v,
 			atomic64_inc(&priv->ipsec->sw_stats.ipsec_tx_drop_trailer);
 			goto drop;
 		}
-	mdata =3D mlx5e_ipsec_add_metadata(skb);
-	if (IS_ERR(mdata)) {
-		atomic64_inc(&priv->ipsec->sw_stats.ipsec_tx_drop_metadata);
-		goto drop;
+
+	if (MLX5_CAP_GEN(priv->mdev, fpga)) {
+		mdata =3D mlx5e_ipsec_add_metadata(skb);
+		if (IS_ERR(mdata)) {
+			atomic64_inc(&priv->ipsec->sw_stats.ipsec_tx_drop_metadata);
+			goto drop;
+		}
 	}
-	mlx5e_ipsec_set_swp(skb, eseg, x->props.mode, xo);
+
 	sa_entry =3D (struct mlx5e_ipsec_sa_entry *)x->xso.offload_handle;
 	sa_entry->set_iv_op(skb, x, xo);
-	mlx5e_ipsec_set_metadata(skb, mdata, xo);
+	if (MLX5_CAP_GEN(priv->mdev, fpga))
+		mlx5e_ipsec_set_metadata(skb, mdata, xo);
+
+	mlx5e_ipsec_set_state(priv, skb, x, xo, ipsec_st);
=20
 	return true;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h =
b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index f96e786db158..056dacb612b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -43,6 +43,13 @@
 #define MLX5_IPSEC_METADATA_SYNDROM_MASK     (0x7F)
 #define MLX5_IPSEC_METADATA_HANDLE(metadata) (((metadata) >> 8) & 0xFF)
=20
+struct mlx5e_accel_tx_ipsec_state {
+	struct xfrm_offload *xo;
+	struct xfrm_state *x;
+	u32 tailen;
+	u32 plen;
+};
+
 #ifdef CONFIG_MLX5_EN_IPSEC
=20
 struct sk_buff *mlx5e_ipsec_handle_rx_skb(struct net_device *netdev,
@@ -55,16 +62,32 @@ void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct=
 xfrm_state *x,
 			    struct xfrm_offload *xo);
 void mlx5e_ipsec_set_iv(struct sk_buff *skb, struct xfrm_state *x,
 			struct xfrm_offload *xo);
-bool mlx5e_ipsec_handle_tx_skb(struct mlx5e_priv *priv,
-			       struct mlx5_wqe_eth_seg *eseg,
-			       struct sk_buff *skb);
+bool mlx5e_ipsec_handle_tx_skb(struct net_device *netdev,
+			       struct sk_buff *skb,
+			       struct mlx5e_accel_tx_ipsec_state *ipsec_st);
+void mlx5e_ipsec_handle_tx_wqe(struct mlx5e_tx_wqe *wqe,
+			       struct mlx5e_accel_tx_ipsec_state *ipsec_st,
+			       struct mlx5_wqe_inline_seg *inlseg);
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
 				       struct sk_buff *skb,
 				       struct mlx5_cqe64 *cqe);
+static inline unsigned int mlx5e_ipsec_tx_ids_len(struct mlx5e_accel_tx_ip=
sec_state *ipsec_st)
+{
+	return ipsec_st->tailen;
+}
+
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe)
 {
 	return !!(MLX5_IPSEC_METADATA_MARKER_MASK & be32_to_cpu(cqe->ft_metadata)=
);
 }
+
+static inline bool mlx5e_ipsec_is_tx_flow(struct mlx5e_accel_tx_ipsec_stat=
e *ipsec_st)
+{
+	return ipsec_st->x;
+}
+
+void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *sk=
b,
+			       struct mlx5_wqe_eth_seg *eseg);
 #else
 static inline
 void mlx5e_ipsec_offload_handle_rx_skb(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index 13bd4f254ed7..82b4419af9d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -144,9 +144,29 @@ static inline void mlx5e_insert_vlan(void *start, stru=
ct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
 }
=20
+/* RM 2311217: no L4 inner checksum for IPsec tunnel type packet */
+static void
+ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
+			    struct mlx5_wqe_eth_seg *eseg)
+{
+	eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
+	if (skb->encapsulation) {
+		eseg->cs_flags |=3D MLX5_ETH_WQE_L3_INNER_CSUM;
+		sq->stats->csum_partial_inner++;
+	} else {
+		eseg->cs_flags |=3D MLX5_ETH_WQE_L4_CSUM;
+		sq->stats->csum_partial++;
+	}
+}
+
 static inline void
 mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb, s=
truct mlx5_wqe_eth_seg *eseg)
 {
+	if (unlikely(eseg->flow_table_metadata & cpu_to_be32(MLX5_ETH_WQE_FT_META=
_IPSEC))) {
+		ipsec_txwqe_build_eseg_csum(sq, skb, eseg);
+		return;
+	}
+
 	if (likely(skb->ip_summed =3D=3D CHECKSUM_PARTIAL)) {
 		eseg->cs_flags =3D MLX5_ETH_WQE_L3_CSUM;
 		if (skb->encapsulation) {
@@ -237,12 +257,14 @@ struct mlx5e_tx_attr {
 	u16 headlen;
 	u16 ihs;
 	__be16 mss;
+	u16 insz;
 	u8 opcode;
 };
=20
 struct mlx5e_tx_wqe_attr {
 	u16 ds_cnt;
 	u16 ds_cnt_inl;
+	u16 ds_cnt_ids;
 	u8 num_wqebbs;
 };
=20
@@ -299,6 +321,7 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *s=
q, struct sk_buff *skb,
 		stats->packets++;
 	}
=20
+	attr->insz =3D mlx5e_accel_tx_ids_len(sq, accel);
 	stats->bytes +=3D attr->num_bytes;
 }
=20
@@ -307,9 +330,13 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb=
, const struct mlx5e_tx_at
 {
 	u16 ds_cnt =3D MLX5E_TX_WQE_EMPTY_DS_COUNT;
 	u16 ds_cnt_inl =3D 0;
+	u16 ds_cnt_ids =3D 0;
=20
-	ds_cnt +=3D !!attr->headlen + skb_shinfo(skb)->nr_frags;
+	if (attr->insz)
+		ds_cnt_ids =3D DIV_ROUND_UP(sizeof(struct mlx5_wqe_inline_seg) + attr->i=
nsz,
+					  MLX5_SEND_WQE_DS);
=20
+	ds_cnt +=3D !!attr->headlen + skb_shinfo(skb)->nr_frags + ds_cnt_ids;
 	if (attr->ihs) {
 		u16 inl =3D attr->ihs - INL_HDR_START_SZ;
=20
@@ -323,6 +350,7 @@ static void mlx5e_sq_calc_wqe_attr(struct sk_buff *skb,=
 const struct mlx5e_tx_at
 	*wqe_attr =3D (struct mlx5e_tx_wqe_attr) {
 		.ds_cnt     =3D ds_cnt,
 		.ds_cnt_inl =3D ds_cnt_inl,
+		.ds_cnt_ids =3D ds_cnt_ids,
 		.num_wqebbs =3D DIV_ROUND_UP(ds_cnt, MLX5_SEND_WQEBB_NUM_DS),
 	};
 }
@@ -398,11 +426,11 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_b=
uff *skb,
=20
 	if (attr->ihs) {
 		if (skb_vlan_tag_present(skb)) {
-			eseg->inline_hdr.sz =3D cpu_to_be16(attr->ihs + VLAN_HLEN);
+			eseg->inline_hdr.sz |=3D cpu_to_be16(attr->ihs + VLAN_HLEN);
 			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
 			stats->added_vlan_packets++;
 		} else {
-			eseg->inline_hdr.sz =3D cpu_to_be16(attr->ihs);
+			eseg->inline_hdr.sz |=3D cpu_to_be16(attr->ihs);
 			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
 		}
 		dseg +=3D wqe_attr->ds_cnt_inl;
@@ -414,6 +442,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buf=
f *skb,
 		stats->added_vlan_packets++;
 	}
=20
+	dseg +=3D wqe_attr->ds_cnt_ids;
 	num_dma =3D mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
 					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
@@ -430,7 +459,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buf=
f *skb,
=20
 static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_=
tx_attr *attr)
 {
-	return !skb_is_nonlinear(skb) && !skb_vlan_tag_present(skb) && !attr->ihs=
;
+	return !skb_is_nonlinear(skb) && !skb_vlan_tag_present(skb) && !attr->ihs=
 &&
+	       !attr->insz;
 }
=20
 static bool mlx5e_tx_mpwqe_same_eseg(struct mlx5e_txqsq *sq, struct mlx5_w=
qe_eth_seg *eseg)
@@ -580,7 +610,7 @@ void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq =
*sq)
 static bool mlx5e_txwqe_build_eseg(struct mlx5e_priv *priv, struct mlx5e_t=
xqsq *sq,
 				   struct sk_buff *skb, struct mlx5_wqe_eth_seg *eseg)
 {
-	if (unlikely(!mlx5e_accel_tx_eseg(priv, sq, skb, eseg)))
+	if (unlikely(!mlx5e_accel_tx_eseg(priv, skb, eseg)))
 		return false;
=20
 	mlx5e_txwqe_build_eseg_csum(sq, skb, eseg);
@@ -625,7 +655,8 @@ netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_=
device *dev)
 	wqe =3D MLX5E_TX_FETCH_WQE(sq, pi);
=20
 	/* May update the WQE, but may not post other WQEs. */
-	mlx5e_accel_tx_finish(sq, wqe, &accel);
+	mlx5e_accel_tx_finish(sq, wqe, &accel,
+			      (struct mlx5_wqe_inline_seg *)(wqe->data + wqe_attr.ds_cnt_inl));
 	if (unlikely(!mlx5e_txwqe_build_eseg(priv, sq, skb, &wqe->eth)))
 		return NETDEV_TX_OK;
=20
--=20
2.26.2


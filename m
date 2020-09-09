Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4B826247E
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 03:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729670AbgIIB2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 21:28:50 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:19421 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgIIB2X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 21:28:23 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f582fa90001>; Tue, 08 Sep 2020 18:28:09 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 08 Sep 2020 18:28:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 08 Sep 2020 18:28:23 -0700
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 9 Sep
 2020 01:28:14 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Tariq Toukan" <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 07/12] net/mlx5e: Move the TLS resync check out of the function
Date:   Tue, 8 Sep 2020 18:27:52 -0700
Message-ID: <20200909012757.32677-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909012757.32677-1-saeedm@nvidia.com>
References: <20200909012757.32677-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1599614889; bh=qo/MQejkdb1QoTxWN2HHE54S3bg2uNXKV0D1ZKsqyRU=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
         Content-Type:X-Originating-IP:X-ClientProxiedBy;
        b=aE15F/GrHaG6oY7+suPRPxADXSbALHMMcyv7ligz5OB5a/DCUaDoY/0hBnaPlCkda
         UsJfuQySp5BBz93hVdITptQww/YfLMa8o2qzdVFecaXlzJtkoOtTt1YdnglRChZAlv
         YbQijwMjQJkTosLaxXBAhY+JI8YuEjA7uvCkbSqJjE/lArJeh0LOSnDtTohngYVJbf
         QlG7PhcXalty46skg9uvgtPejksgZJee+2isxd73AICcpVth02tHIFzrQH7LGFYISh
         RiP4/1HiaHvEzSDPgpTXUTKtT/+lSSem5i6hnKCLL7MGzyKfxXIBe/Va8P6cNh2EJC
         zT5VmzRKKMEUg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Before this patch, mlx5e_ktls_tx_handle_resync_dump_comp checked for
resync_dump_frag_page. It happened for all WQEs without an SKB,
including padding WQEs, and required a function call. Normally, padding
WQEs happen more often than TLS resyncs. Take this check out of the
function and put it to an inline function to save a call on all padding
WQEs.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |  3 ---
 .../mellanox/mlx5/core/en_accel/ktls_txrx.h        | 14 +++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  4 ++--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index f4861545b236..b140e13fdcc8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -345,9 +345,6 @@ void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e=
_txqsq *sq,
 	struct mlx5e_sq_stats *stats;
 	struct mlx5e_sq_dma *dma;
=20
-	if (!wi->resync_dump_frag_page)
-		return;
-
 	dma =3D mlx5e_dma_get(sq, (*dma_fifo_cc)++);
 	stats =3D sq->stats;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h b=
/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
index ff4c740af10b..fcfb156cf09d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_txrx.h
@@ -29,11 +29,19 @@ void mlx5e_ktls_handle_get_psv_completion(struct mlx5e_=
icosq_wqe_info *wi,
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
 					   u32 *dma_fifo_cc);
+static inline void
+mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					  struct mlx5e_tx_wqe_info *wi,
+					  u32 *dma_fifo_cc)
+{
+	if (unlikely(wi->resync_dump_frag_page))
+		mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma_fifo_cc);
+}
 #else
 static inline void
-mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
-				      struct mlx5e_tx_wqe_info *wi,
-				      u32 *dma_fifo_cc)
+mlx5e_ktls_tx_try_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+					  struct mlx5e_tx_wqe_info *wi,
+					  u32 *dma_fifo_cc)
 {
 }
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tx.c
index f045c4be63db..cabc84e71b2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -547,7 +547,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_bud=
get)
 			sqcc +=3D wi->num_wqebbs;
=20
 			if (unlikely(!skb)) {
-				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+				mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 				continue;
 			}
=20
@@ -612,7 +612,7 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 		sqcc +=3D wi->num_wqebbs;
=20
 		if (!skb) {
-			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			mlx5e_ktls_tx_try_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 			continue;
 		}
=20
--=20
2.26.2


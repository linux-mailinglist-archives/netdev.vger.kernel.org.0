Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5B79674638
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 23:34:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbjASWeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 17:34:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjASWc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 17:32:27 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D857AA83BA
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:16:05 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id t12-20020a17090a3e4c00b00225cb4e761cso1505212pjm.3
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 14:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uoKHHKBzvJdoBJBSc3srGkjiZWyjiy/R7iq2Cf3dQvY=;
        b=HhATpx1r7T9HdjKKpDy178lMmG9gesG6DKptjcGx4d2Vbou/DUrtfklGqdIBrDCR0S
         NdYkO+MRWORK7mSDt4RtNv248PXv9pHHDKCxjxHhisM8NXD4wgCzqqmkw/+z7cHW6SkC
         QUaNYg1vU+eyNodrjv4fOaYz+AbL56uzjemqeENkoUPxYNbkAwjimDiNUZOhWq+Guz0B
         NnQG4T4JuftuR44pYA633/n5VPVmC0jVQhXaX3X70hXDHQfPOZkJ6dLnsnPSBsJsIO3S
         y+pZxrLDKAa8cc9Cz/qdK3j34LcZC0O7P7CFRXU4Jp/Zv6BAauDNDOEurB1WDfmo6aSb
         DMFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=uoKHHKBzvJdoBJBSc3srGkjiZWyjiy/R7iq2Cf3dQvY=;
        b=51cyp41s67939yl8JxVyitGnVkUCtDBUoiGnbXILMB7XpKEgYFLq+5ZJ/hcPm5WULv
         DRAwN91yc278+KeXeB9hP2piOMxjuVRFAoT3RITx42aAxipBE1sf+pHl2QCGom6ktG0P
         ukKxGcev8eT1yHaYUlDwwJGUqYPGbYy2GeQXAYx4EQ3YLLiHKm0vlx+bCps/kLkel3lC
         uYde0BALKBfc78KHtVbX06A68hNO5hEwLxNbHuWcSVxqsvRQddBZe5FgKIlrBKaESFu7
         2ub5b/hJiAA29fW/05FtmHb7aU8DAI+ISOT1+3ygimM/zRnF/c6ENQD+005h5N6EXL3+
         7s5g==
X-Gm-Message-State: AFqh2koUeSF6BQVO9hGclgTBhYwFlTgAkeKkVAMU0hqZnrSa2JrWx23u
        tjZg8NXN04L0g28Qw7T3pfQ0D+0=
X-Google-Smtp-Source: AMrXdXuwD1nrUdTh+djbemXJ2rd6v68QGG+jOWN8h93OxtGEwMVuAZ3eyp19A8XfoFCNxQ2KEcp5jxc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:902:f60a:b0:186:e222:9f05 with SMTP id
 n10-20020a170902f60a00b00186e2229f05mr1193081plg.61.1674166565363; Thu, 19
 Jan 2023 14:16:05 -0800 (PST)
Date:   Thu, 19 Jan 2023 14:15:35 -0800
In-Reply-To: <20230119221536.3349901-1-sdf@google.com>
Mime-Version: 1.0
References: <20230119221536.3349901-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <20230119221536.3349901-17-sdf@google.com>
Subject: [PATCH bpf-next v8 16/17] net/mlx5e: Support RX XDP metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
pointer to the mlx5e_skb_from* functions so it can be retrieved from the
XDP ctx to do this.

Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Willem de Bruijn <willemb@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Anatoly Burakov <anatoly.burakov@intel.com>
Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
Cc: Maryam Tahhan <mtahhan@redhat.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 +-
 .../net/ethernet/mellanox/mlx5/core/en/txrx.h |  5 ++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 28 ++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  4 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 14 +++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 51 ++++++++++---------
 8 files changed, 84 insertions(+), 26 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index 2d77fb8a8a01..711dc88d8b48 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -626,10 +626,11 @@ struct mlx5e_rq;
 typedef void (*mlx5e_fp_handle_rx_cqe)(struct mlx5e_rq*, struct mlx5_cqe64=
*);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe_mpwrq)(struct mlx5e_rq *rq, struct mlx5e_mpw_info =
*wi,
-			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
+			       struct mlx5_cqe64 *cqe, u16 cqe_bcnt,
+			       u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *=
wi,
-			 u32 cqe_bcnt);
+			 struct mlx5_cqe64 *cqe, u32 cqe_bcnt);
 typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *rq);
 typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
 typedef void (*mlx5e_fp_shampo_dealloc_hd)(struct mlx5e_rq*, u16, u16, boo=
l);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 853f312cd757..757c012ece27 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -73,6 +73,11 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget);
 void mlx5e_free_rx_descs(struct mlx5e_rq *rq);
 void mlx5e_free_rx_in_progress_descs(struct mlx5e_rq *rq);
=20
+static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
+{
+	return config->rx_filter =3D=3D HWTSTAMP_FILTER_ALL;
+}
+
 /* TX */
 netdev_tx_t mlx5e_xmit(struct sk_buff *skb, struct net_device *dev);
 bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 31bb6806bf5d..f7d52b1d293b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -156,6 +156,34 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx=
5e_rq *rq,
 	return true;
 }
=20
+static int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp=
)
+{
+	const struct mlx5e_xdp_buff *_ctx =3D (void *)ctx;
+
+	if (unlikely(!mlx5e_rx_hw_stamp(_ctx->rq->tstamp)))
+		return -EOPNOTSUPP;
+
+	*timestamp =3D  mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
+					 _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
+	return 0;
+}
+
+static int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
+{
+	const struct mlx5e_xdp_buff *_ctx =3D (void *)ctx;
+
+	if (unlikely(!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH)))
+		return -EOPNOTSUPP;
+
+	*hash =3D be32_to_cpu(_ctx->cqe->rss_hash_result);
+	return 0;
+}
+
+const struct xdp_metadata_ops mlx5e_xdp_metadata_ops =3D {
+	.xmo_rx_timestamp		=3D mlx5e_xdp_rx_timestamp,
+	.xmo_rx_hash			=3D mlx5e_xdp_rx_hash,
+};
+
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index 389818bf6833..69f338bc0633 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -46,6 +46,8 @@
=20
 struct mlx5e_xdp_buff {
 	struct xdp_buff xdp;
+	struct mlx5_cqe64 *cqe;
+	struct mlx5e_rq *rq;
 };
=20
 struct mlx5e_xsk_param;
@@ -60,6 +62,8 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frame=
s,
 		   u32 flags);
=20
+extern const struct xdp_metadata_ops mlx5e_xdp_metadata_ops;
+
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdp=
sq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
 							  struct skb_shared_info *sinfo,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 08d4e5c30b40..b7c84ebe8418 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -52,25 +52,30 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
=20
 	if (likely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_ALIGNED)) {
 		for (i =3D 0; i < batch; i++) {
+			struct mlx5e_xdp_buff *mxbuf =3D xsk_buff_to_mxbuf(wi->alloc_units[i].x=
sk);
 			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
=20
 			umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
 				.ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
 			};
+			mxbuf->rq =3D rq;
 		}
 	} else if (unlikely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_UNALIG=
NED)) {
 		for (i =3D 0; i < batch; i++) {
+			struct mlx5e_xdp_buff *mxbuf =3D xsk_buff_to_mxbuf(wi->alloc_units[i].x=
sk);
 			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
=20
 			umr_wqe->inline_ksms[i] =3D (struct mlx5_ksm) {
 				.key =3D rq->mkey_be,
 				.va =3D cpu_to_be64(addr),
 			};
+			mxbuf->rq =3D rq;
 		}
 	} else if (likely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_TRIPLE))=
 {
 		u32 mapping_size =3D 1 << (rq->mpwqe.page_shift - 2);
=20
 		for (i =3D 0; i < batch; i++) {
+			struct mlx5e_xdp_buff *mxbuf =3D xsk_buff_to_mxbuf(wi->alloc_units[i].x=
sk);
 			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
=20
 			umr_wqe->inline_ksms[i << 2] =3D (struct mlx5_ksm) {
@@ -89,6 +94,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 				.key =3D rq->mkey_be,
 				.va =3D cpu_to_be64(rq->wqe_overflow.addr),
 			};
+			mxbuf->rq =3D rq;
 		}
 	} else {
 		__be32 pad_size =3D cpu_to_be32((1 << rq->mpwqe.page_shift) -
@@ -96,6 +102,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix=
)
 		__be32 frame_size =3D cpu_to_be32(rq->xsk_pool->chunk_size);
=20
 		for (i =3D 0; i < batch; i++) {
+			struct mlx5e_xdp_buff *mxbuf =3D xsk_buff_to_mxbuf(wi->alloc_units[i].x=
sk);
 			dma_addr_t addr =3D xsk_buff_xdp_get_frame_dma(wi->alloc_units[i].xsk);
=20
 			umr_wqe->inline_klms[i << 1] =3D (struct mlx5_klm) {
@@ -108,6 +115,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
 				.va =3D cpu_to_be64(rq->wqe_overflow.addr),
 				.bcount =3D pad_size,
 			};
+			mxbuf->rq =3D rq;
 		}
 	}
=20
@@ -238,6 +246,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct m=
lx5e_rq *rq, struct xdp_b
=20
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx)
@@ -258,6 +267,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(head_offset);
=20
+	/* mxbuf->rq is set on allocation, but cqe is per-packet so set it here *=
/
+	mxbuf->cqe =3D cqe;
 	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
 	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
 	net_prefetch(mxbuf->xdp.data);
@@ -292,6 +303,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
=20
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
+					      struct mlx5_cqe64 *cqe,
 					      u32 cqe_bcnt)
 {
 	struct mlx5e_xdp_buff *mxbuf =3D xsk_buff_to_mxbuf(wi->au->xsk);
@@ -304,6 +316,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct ml=
x5e_rq *rq,
 	 */
 	WARN_ON_ONCE(wi->offset);
=20
+	/* mxbuf->rq is set on allocation, but cqe is per-packet so set it here *=
/
+	mxbuf->cqe =3D cqe;
 	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
 	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
 	net_prefetch(mxbuf->xdp.data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 087c943bd8e9..cefc0ef6105d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -13,11 +13,13 @@ int mlx5e_xsk_alloc_rx_wqes_batched(struct mlx5e_rq *rq=
, u16 ix, int wqe_bulk);
 int mlx5e_xsk_alloc_rx_wqes(struct mlx5e_rq *rq, u16 ix, int wqe_bulk);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
+					      struct mlx5_cqe64 *cqe,
 					      u32 cqe_bcnt);
=20
 #endif /* __MLX5_EN_XSK_RX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en_main.c
index cff5f2e29e1e..3370c8b9f983 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5053,6 +5053,7 @@ static void mlx5e_build_nic_netdev(struct net_device =
*netdev)
 	SET_NETDEV_DEV(netdev, mdev->device);
=20
 	netdev->netdev_ops =3D &mlx5e_netdev_ops;
+	netdev->xdp_metadata_ops =3D &mlx5e_xdp_metadata_ops;
=20
 	mlx5e_dcbnl_build_netdev(netdev);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index c6810ca75530..7b08653be000 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -62,10 +62,12 @@
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info=
 *wi,
-				u16 cqe_bcnt, u32 head_offset, u32 page_idx);
+				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
+				u32 page_idx);
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_i=
nfo *wi,
-				   u16 cqe_bcnt, u32 head_offset, u32 page_idx);
+				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
+				   u32 page_idx);
 static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq=
e);
 static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq *rq, struct mlx5_cqe=
64 *cqe);
 static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct mlx5e_rq *rq, struct m=
lx5_cqe64 *cqe);
@@ -76,11 +78,6 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic =3D=
 {
 	.handle_rx_cqe_mpwqe_shampo =3D mlx5e_handle_rx_cqe_mpwrq_shampo,
 };
=20
-static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
-{
-	return config->rx_filter =3D=3D HWTSTAMP_FILTER_ALL;
-}
-
 static inline void mlx5e_read_cqe_slot(struct mlx5_cqwq *wq,
 				       u32 cqcc, void *data)
 {
@@ -1575,16 +1572,19 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e=
_rq *rq, void *va,
 	return skb;
 }
=20
-static void mlx5e_fill_mxbuf(struct mlx5e_rq *rq, void *va, u16 headroom,
-			     u32 len, struct mlx5e_xdp_buff *mxbuf)
+static void mlx5e_fill_mxbuf(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
+			     void *va, u16 headroom, u32 len,
+			     struct mlx5e_xdp_buff *mxbuf)
 {
 	xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
 	xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
+	mxbuf->cqe =3D cqe;
+	mxbuf->rq =3D rq;
 }
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info =
*wi,
-			  u32 cqe_bcnt)
+			  struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
 	union mlx5e_alloc_unit *au =3D wi->au;
 	u16 rx_headroom =3D rq->buff.headroom;
@@ -1609,7 +1609,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct=
 mlx5e_wqe_frag_info *wi,
 		struct mlx5e_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_mxbuf(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
 			return NULL; /* page/packet was consumed by XDP */
=20
@@ -1630,7 +1630,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct=
 mlx5e_wqe_frag_info *wi,
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_in=
fo *wi,
-			     u32 cqe_bcnt)
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info =3D &rq->wqe.info.arr[0];
 	struct mlx5e_wqe_frag_info *head_wi =3D wi;
@@ -1654,7 +1654,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
=20
-	mlx5e_fill_mxbuf(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
+	mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, frag_consumed_bytes, &mxbuf);
 	sinfo =3D xdp_get_shared_info_from_buff(&mxbuf.xdp);
 	truesize =3D 0;
=20
@@ -1777,7 +1777,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, =
struct mlx5_cqe64 *cqe)
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
 			      mlx5e_xsk_skb_from_cqe_linear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1830,7 +1830,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *=
rq, struct mlx5_cqe64 *cqe)
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1889,7 +1889,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5=
e_rq *rq, struct mlx5_cqe64
 	skb =3D INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
=20
@@ -1940,7 +1940,8 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e=
_rq *rq,
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *rq, struct mlx5e_mpw_i=
nfo *wi,
-				   u16 cqe_bcnt, u32 head_offset, u32 page_idx)
+				   struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
+				   u32 page_idx)
 {
 	union mlx5e_alloc_unit *au =3D &wi->alloc_units[page_idx];
 	u16 headlen =3D min_t(u16, MLX5E_RX_MAX_HEAD, cqe_bcnt);
@@ -1979,7 +1980,8 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *r=
q, struct mlx5e_mpw_info *w
=20
 static struct sk_buff *
 mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info=
 *wi,
-				u16 cqe_bcnt, u32 head_offset, u32 page_idx)
+				struct mlx5_cqe64 *cqe, u16 cqe_bcnt, u32 head_offset,
+				u32 page_idx)
 {
 	union mlx5e_alloc_unit *au =3D &wi->alloc_units[page_idx];
 	u16 rx_headroom =3D rq->buff.headroom;
@@ -2010,7 +2012,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, =
struct mlx5e_mpw_info *wi,
 		struct mlx5e_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_mxbuf(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_mxbuf(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
@@ -2174,8 +2176,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct m=
lx5e_rq *rq, struct mlx5_cq
 		if (likely(head_size))
 			*skb =3D mlx5e_skb_from_cqe_shampo(rq, wi, cqe, header_index);
 		else
-			*skb =3D mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe_bcnt, data_offs=
et,
-								  page_idx);
+			*skb =3D mlx5e_skb_from_cqe_mpwrq_nonlinear(rq, wi, cqe, cqe_bcnt,
+								  data_offset, page_idx);
 		if (unlikely(!*skb))
 			goto free_hd_entry;
=20
@@ -2249,7 +2251,8 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq=
 *rq, struct mlx5_cqe64 *cq
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
 			      mlx5e_xsk_skb_from_cqe_mpwrq_linear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset,
+			      page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
=20
@@ -2494,7 +2497,7 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, =
struct mlx5_cqe64 *cqe)
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb)
 		goto wq_free_wqe;
=20
@@ -2586,7 +2589,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq =
*rq, struct mlx5_cqe64 *cqe
 		goto free_wqe;
 	}
=20
-	skb =3D mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe_bcnt);
+	skb =3D mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe, cqe_bcnt);
 	if (!skb)
 		goto free_wqe;
=20
--=20
2.39.0.246.g2a6d74b583-goog


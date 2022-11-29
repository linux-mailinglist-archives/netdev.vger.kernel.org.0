Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BBE63C888
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 20:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237053AbiK2TgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 14:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236981AbiK2Tfj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 14:35:39 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9993854B10
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:11 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id my9-20020a17090b4c8900b002130d29fd7cso15842313pjb.7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 11:35:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DG7NBqK/yKA4LO0wibUVtVi5jWR272oF0PJynWkaX8E=;
        b=VK3zBK5Yza3qY1BAaAXkcC1IYErBwj3RwIooAZkVIbtWQcMm3lzsHrexSgoG3Wb5A1
         sv7v05KwYD9XGkg7lkOH+Q8JZPo44Y1AzJiPlUawZ6GR5qnq9PUlhM4OSHYBAXGJVYmX
         jgRMI3os7KjMbilrTmehD7j7G64pbZJZQfdl+PWKUoy/8wLJ8lFQ15Bb7CeR20SnSqZb
         2VwCQmtQk+++j86yPBu3v04ZHDoi5nkAjVRvqqO2rADjEljTf2bn2ltIYYhZnUI5gfNS
         67oyT9EFHQwDFqL1PaIKL1shXt5iSUrG3c6zdzg+sCI94wirjSwoH2L6bafRkdZv4xEH
         yC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DG7NBqK/yKA4LO0wibUVtVi5jWR272oF0PJynWkaX8E=;
        b=SIYTyZ4unF4//OTjCp9gDrtxEb3f8fRZ8G0pPQBRIZEJAgr0VHSryAlV68h5v8d+AR
         t6C250i6eNpg0+k8F8PeC8Dw/YaCKIfJKPa+DTte3k7S8TEW0ZYOLx6IazOZGU6cFuzF
         oEFFW2ZOrC8oyqCC0/ofTW/QKATjyInfuj2IKHsruHTY/jucreo2BjDU+g90M4zsihEh
         qiEjqVGOLS9WVC7xctInhIjwGQ9zTHpTBpkI2Wvu3GaT75Gzxo1DfkRO2akFazPYrD6S
         nBE30URZu8ZQmopSR7JM0SD5SUwNXXkhip6Ns49x4icp8wMOCq4S8mOo9Ku0MrKXFHbB
         Eeog==
X-Gm-Message-State: ANoB5pnDiT9kTJAl+FibHPTleaP+e2fRVVlMuVhTgf14vBB7zgyltxXI
        TxMZFd6399TWlV6Ar1pdlWVtpJU=
X-Google-Smtp-Source: AA0mqf6lTjBg8jj06HZYf50f17ogjIYDBpgevDlsxY9YsnhkdWZdoL6hWgzVN/jPUKnwG4wqMEEeDys=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a62:1812:0:b0:56c:afe:e8bf with SMTP id
 18-20020a621812000000b0056c0afee8bfmr39209022pfy.51.1669750511101; Tue, 29
 Nov 2022 11:35:11 -0800 (PST)
Date:   Tue, 29 Nov 2022 11:34:51 -0800
In-Reply-To: <20221129193452.3448944-1-sdf@google.com>
Mime-Version: 1.0
References: <20221129193452.3448944-1-sdf@google.com>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129193452.3448944-11-sdf@google.com>
Subject: [PATCH bpf-next v3 10/11] mlx5: Support RX XDP metadata
From:   Stanislav Fomichev <sdf@google.com>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org,
        "=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?=" <toke@redhat.com>,
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
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 ++++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 29 +++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  7 ++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 10 +++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 42 ++++++++++---------
 7 files changed, 82 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index cdbaac5f6d25..8337ff0cacd5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -627,10 +627,11 @@ struct mlx5e_rq;
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
@@ -1036,6 +1037,11 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, _=
_always_unused __be16 proto,
 			   u16 vid);
 void mlx5e_timestamp_init(struct mlx5e_priv *priv);
=20
+static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
+{
+	return config->rx_filter =3D=3D HWTSTAMP_FILTER_ALL;
+}
+
 struct mlx5e_xsk_param;
=20
 struct mlx5e_rq_param;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index db49b813bcb5..2a4700b3695a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -156,6 +156,35 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx=
5e_rq *rq,
 	return true;
 }
=20
+bool mlx5e_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
+
+	return mlx5e_rx_hw_stamp(_ctx->rq->tstamp);
+}
+
+u64 mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx)
+{
+	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
+
+	return mlx5e_cqe_ts_to_ns(_ctx->rq->ptp_cyc2time,
+				  _ctx->rq->clock, get_cqe_ts(_ctx->cqe));
+}
+
+bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx)
+{
+	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
+
+	return _ctx->xdp.rxq->dev->features & NETIF_F_RXHASH;
+}
+
+u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
+{
+	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
+
+	return be32_to_cpu(_ctx->cqe->rss_hash_result);
+}
+
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		      struct bpf_prog *prog, struct mlx5_xdp_buff *mxbuf)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index a33b448d542d..a5fc30b07617 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -46,6 +46,8 @@
=20
 struct mlx5_xdp_buff {
 	struct xdp_buff xdp;
+	struct mlx5_cqe64 *cqe;
+	struct mlx5e_rq *rq;
 };
=20
 struct mlx5e_xsk_param;
@@ -60,6 +62,11 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frame=
s,
 		   u32 flags);
=20
+bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx);
+u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx);
+bool mlx5e_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
+u64 mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx);
+
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdp=
sq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
 							  struct skb_shared_info *sinfo,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 5e88dc61824e..05cf7987585a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -49,6 +49,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 			umr_wqe->inline_mtts[i] =3D (struct mlx5_mtt) {
 				.ptag =3D cpu_to_be64(addr | MLX5_EN_WR),
 			};
+			wi->alloc_units[i].mxbuf->rq =3D rq;
 		}
 	} else if (unlikely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_UNALIG=
NED)) {
 		for (i =3D 0; i < batch; i++) {
@@ -58,6 +59,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 				.key =3D rq->mkey_be,
 				.va =3D cpu_to_be64(addr),
 			};
+			wi->alloc_units[i].mxbuf->rq =3D rq;
 		}
 	} else if (likely(rq->mpwqe.umr_mode =3D=3D MLX5E_MPWRQ_UMR_MODE_TRIPLE))=
 {
 		u32 mapping_size =3D 1 << (rq->mpwqe.page_shift - 2);
@@ -81,6 +83,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 				.key =3D rq->mkey_be,
 				.va =3D cpu_to_be64(rq->wqe_overflow.addr),
 			};
+			wi->alloc_units[i].mxbuf->rq =3D rq;
 		}
 	} else {
 		__be32 pad_size =3D cpu_to_be32((1 << rq->mpwqe.page_shift) -
@@ -100,6 +103,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 i=
x)
 				.va =3D cpu_to_be64(rq->wqe_overflow.addr),
 				.bcount =3D pad_size,
 			};
+			wi->alloc_units[i].mxbuf->rq =3D rq;
 		}
 	}
=20
@@ -230,6 +234,7 @@ static struct sk_buff *mlx5e_xsk_construct_skb(struct m=
lx5e_rq *rq, struct xdp_b
=20
 struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    struct mlx5e_mpw_info *wi,
+						    struct mlx5_cqe64 *cqe,
 						    u16 cqe_bcnt,
 						    u32 head_offset,
 						    u32 page_idx)
@@ -250,6 +255,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
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
@@ -284,6 +291,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
=20
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
+					      struct mlx5_cqe64 *cqe,
 					      u32 cqe_bcnt)
 {
 	struct mlx5_xdp_buff *mxbuf =3D wi->au->mxbuf;
@@ -296,6 +304,8 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct ml=
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
index 14bd86e368d5..015bfe891458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4890,6 +4890,10 @@ const struct net_device_ops mlx5e_netdev_ops =3D {
 	.ndo_tx_timeout          =3D mlx5e_tx_timeout,
 	.ndo_bpf		 =3D mlx5e_xdp,
 	.ndo_xdp_xmit            =3D mlx5e_xdp_xmit,
+	.ndo_xdp_rx_timestamp_supported =3D mlx5e_xdp_rx_timestamp_supported,
+	.ndo_xdp_rx_timestamp    =3D mlx5e_xdp_rx_timestamp,
+	.ndo_xdp_rx_hash_supported =3D mlx5e_xdp_rx_hash_supported,
+	.ndo_xdp_rx_hash         =3D mlx5e_xdp_rx_hash,
 	.ndo_xsk_wakeup          =3D mlx5e_xsk_wakeup,
 #ifdef CONFIG_MLX5_EN_ARFS
 	.ndo_rx_flow_steer	 =3D mlx5e_rx_flow_steer,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index 434025703e50..a85f82efbc4f 100644
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
@@ -1564,16 +1561,18 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e=
_rq *rq, void *va,
 	return skb;
 }
=20
-static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroo=
m,
+static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, struct mlx5_cqe64 *cq=
e, void *va, u16 headroom,
 				u32 len, struct mlx5_xdp_buff *mxbuf)
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
@@ -1598,7 +1597,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct=
 mlx5e_wqe_frag_info *wi,
 		struct mlx5_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
 			return NULL; /* page/packet was consumed by XDP */
=20
@@ -1619,7 +1618,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct=
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
@@ -1643,7 +1642,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
=20
-	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
+	mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, frag_consumed_bytes, &mxbuf=
);
 	sinfo =3D xdp_get_shared_info_from_buff(&mxbuf.xdp);
 	truesize =3D 0;
=20
@@ -1766,7 +1765,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, =
struct mlx5_cqe64 *cqe)
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
 			      mlx5e_xsk_skb_from_cqe_linear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1929,7 +1928,8 @@ mlx5e_fill_skb_data(struct sk_buff *skb, struct mlx5e=
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
@@ -1968,7 +1968,8 @@ mlx5e_skb_from_cqe_mpwrq_nonlinear(struct mlx5e_rq *r=
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
@@ -1999,7 +2000,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, =
struct mlx5e_mpw_info *wi,
 		struct mlx5_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		mlx5e_fill_xdp_buff(rq, cqe, va, rx_headroom, cqe_bcnt, &mxbuf);
 		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
@@ -2163,8 +2164,8 @@ static void mlx5e_handle_rx_cqe_mpwrq_shampo(struct m=
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
@@ -2238,7 +2239,8 @@ static void mlx5e_handle_rx_cqe_mpwrq(struct mlx5e_rq=
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
@@ -2575,7 +2577,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq =
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
2.38.1.584.g0f3c55d4c2-goog


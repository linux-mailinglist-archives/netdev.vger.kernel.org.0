Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD6D643B81
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 03:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiLFCrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 21:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbiLFCq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 21:46:28 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017031DF1B
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 18:46:16 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id 145-20020a621497000000b00574fab7294dso12193162pfu.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 18:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o6uxkcshDSkwgAKN1NEsjEKfz7uDW+F/pKpMEomNp0k=;
        b=nEjXpio+4m2ESdrlhvvGh6iNtX6bvdRWcnbXQiWPcvmJmOAGGZupk0x2WuKpKOY8hX
         JZFnoG4QAXL/UiNjX3/4xpj0u9BpNeNf1iPbug7XafzbgUADjHVCSzWOW1rVSwmu+2Yt
         wDnxLXYLctK1kxGvA1dlwrqiCDO4K6LB3QrlPo1hjgKKvTPsQzFsFA/y3aW/rO35kXgH
         n+OQ556gH1CXCKyAsefPdZQQXIiegFyAAvQqR7t7O6wOmveOc0EA2+9QHaGiJICD1ZUw
         XQ+4UV7UheEnUC5G8S/Za5rrtW/65Tml1Y8qEdFASAOpHAU/wVu+924si0nm/djRa+W2
         pDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o6uxkcshDSkwgAKN1NEsjEKfz7uDW+F/pKpMEomNp0k=;
        b=xPfJNofx+eGAf/OhF20rEhqrpHgnULH2o56kzPRYtKbglsiELcweFgqQtj7qp/qfZ/
         vtz6GtjphoWBE5aRW47135ti66XqQ+LSIIM1TBhQiOYKlGvb+WMiz+UrkhnNNQQzOqK/
         LH9DU15CW//STekUvT9Z5+ZO+fYOGJBB9rPAPeOQav3xszCbI7D0ASbwvIej1k+vUKdh
         RHMySR7doq/P+tpOlDUzVLc3XI99hwLtaxY2mbmXAxhx2NGGzi1W7ia7V8rtnGA5b/YY
         aZ9j2c9uAn7yyAFCGNELElXku46Kr+cutL3BTpRdvTRIPOXDOjHer65JvtfN+pIniT1h
         PV1w==
X-Gm-Message-State: ANoB5pkp37u280njUI8fXNWxP3C93ZOIOHJtQy/cDqdPbXBM1pXUiOB+
        70v+00YdgNihAWrhoEBziNQbcu8=
X-Google-Smtp-Source: AA0mqf6sm4fZHTbhYeGy1TAy9DEN1drOdpAbI1roI5J/WM++nigHHRSgdgjTezTnVggrhfN5RwVLaDM=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90b:3706:b0:218:fb5c:a762 with SMTP id
 mg6-20020a17090b370600b00218fb5ca762mr58990416pjb.241.1670294775379; Mon, 05
 Dec 2022 18:46:15 -0800 (PST)
Date:   Mon,  5 Dec 2022 18:45:53 -0800
In-Reply-To: <20221206024554.3826186-1-sdf@google.com>
Mime-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221206024554.3826186-12-sdf@google.com>
Subject: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
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
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  | 10 +++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 29 +++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  7 +++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 10 ++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  2 +
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 48 ++++++++++---------
 7 files changed, 85 insertions(+), 25 deletions(-)

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
index 217c8a478977..967a82bf34b4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4891,6 +4891,10 @@ const struct net_device_ops mlx5e_netdev_ops =3D {
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
index 434025703e50..1bc631abe24c 100644
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
@@ -1819,7 +1818,7 @@ static void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *=
rq, struct mlx5_cqe64 *cqe)
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -1878,7 +1877,7 @@ static void mlx5e_handle_rx_cqe_mpwrq_rep(struct mlx5=
e_rq *rq, struct mlx5_cqe64
 	skb =3D INDIRECT_CALL_2(rq->mpwqe.skb_from_cqe_mpwrq,
 			      mlx5e_skb_from_cqe_mpwrq_linear,
 			      mlx5e_skb_from_cqe_mpwrq_nonlinear,
-			      rq, wi, cqe_bcnt, head_offset, page_idx);
+			      rq, wi, cqe, cqe_bcnt, head_offset, page_idx);
 	if (!skb)
 		goto mpwrq_cqe_out;
=20
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
@@ -2483,7 +2485,7 @@ static void mlx5i_handle_rx_cqe(struct mlx5e_rq *rq, =
struct mlx5_cqe64 *cqe)
 	skb =3D INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb)
 		goto wq_free_wqe;
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
2.39.0.rc0.267.gcb52ba06e7-goog


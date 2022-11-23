Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 298E263623C
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbiKWOrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbiKWOrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:47:45 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA98450AF
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669214810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xz+km6/Hwl8oAosXhHMDgdK+wl//qFcWr7SigG5fMGI=;
        b=Y5DufcHpV+ONscMG28HLaa99ZVhp3yYPakMBZlp1Sq5UTraWjgjJFuNKHgpHArL14k2g49
        iD86qF9hFlsBqDcfMoVur0+OhodpT9VpGTR8N/ntRkWgt5izEIJkJvwVar2QIfPxF684YL
        sa+1E0UzLowXRi8zB9MTOuzMoAUWdng=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-493-X90xQynyNL258bi5X5vwzA-1; Wed, 23 Nov 2022 09:46:49 -0500
X-MC-Unique: X90xQynyNL258bi5X5vwzA-1
Received: by mail-ej1-f71.google.com with SMTP id sh31-20020a1709076e9f00b007ae32b7eb51so9993337ejc.9
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:46:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xz+km6/Hwl8oAosXhHMDgdK+wl//qFcWr7SigG5fMGI=;
        b=zXxLfGngfHfgzvABLrYgnFGW6HVoOo65qKbf/EP+kDIHJLHjY7aRKF5ji/QdsiRS6v
         3foy71Qw+YW1xugq89XWba4FpvJIeoC1Pw27U/iWFLkxGkMOocgCaVMvO388+LvEBLdQ
         IgB3vq63W+iZUBD1Z0nN0a0O4GwonTuP73UtZQtWiOb60rAoSWxfhqBCUrdog8TJ2rz3
         Z+yqOyOWsxvnydt825kvi9h4lLDYIVHt/8tebngwKRFfMVqevgyiZu47QcixKW1J8uA6
         fpKBwdyTldi6/SqmSO20mr310/l75pctMnwxxcOTFv30TO98w1csP3MYlqV9IbpN8R1l
         trbQ==
X-Gm-Message-State: ANoB5pn5pp7I9zgX4w3hP0GfFMCb8PU3nWzDRb1seP9m/GO0vMEDsCE1
        7BZE/DgXIUqMmJPfPeHqthHYQ/5UP0YZpxGgX4Jr8TyQMUUpWr4aLwsplVAxOkkaWXCVpbJ/y48
        3ilmJnp7pUCxTIf01
X-Received: by 2002:a17:906:160b:b0:78d:dddb:3974 with SMTP id m11-20020a170906160b00b0078ddddb3974mr23674880ejd.411.1669214807924;
        Wed, 23 Nov 2022 06:46:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7gzrrwlJ97t9gbAltHqOq94T5Eij3iYI7xoXgpdWePyqrT1+AnkNTuxRdJZ1WEi3DXUCAAxQ==
X-Received: by 2002:a17:906:160b:b0:78d:dddb:3974 with SMTP id m11-20020a170906160b00b0078ddddb3974mr23674846ejd.411.1669214807480;
        Wed, 23 Nov 2022 06:46:47 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id mm27-20020a170906cc5b00b007ae693cd265sm7266907ejb.150.2022.11.23.06.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:46:47 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 61E197D5122; Wed, 23 Nov 2022 15:46:46 +0100 (CET)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     bpf@vger.kernel.org
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>,
        Stanislav Fomichev <sdf@google.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/2] mlx5: Support XDP RX metadata
Date:   Wed, 23 Nov 2022 15:46:41 +0100
Message-Id: <20221123144641.339138-2-toke@redhat.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123144641.339138-1-toke@redhat.com>
References: <20221121182552.2152891-1-sdf@google.com>
 <20221123144641.339138-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support RX hash and timestamp metadata kfuncs. We need to pass in the cqe
pointer to the mlx5e_skb_from* functions so it can be retrieved from the
XDP ctx to do this.

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
Cc: Stanislav Fomichev <sdf@google.com>
Cc: xdp-hints@xdp-project.net
Cc: netdev@vger.kernel.org
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
This goes on top of Stanislav's series, obvioulsy. Verified that it works using
the xdp_hw_metadata utility; going to do ome benchmarking and follow up with the
results, but figured I'd send this out straight away in case others wanted to
play with it.

Stanislav, feel free to fold it into the next version of your series if you
want!

-Toke


 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  7 +++-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 32 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  | 10 ++++++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  3 ++
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.h   |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  4 +++
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 19 +++++------
 7 files changed, 65 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index ff5b302531d5..960404027f0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -629,7 +629,7 @@ typedef struct sk_buff *
 			       u16 cqe_bcnt, u32 head_offset, u32 page_idx);
 typedef struct sk_buff *
 (*mlx5e_fp_skb_from_cqe)(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
-			 u32 cqe_bcnt);
+			 struct mlx5_cqe64 *cqe, u32 cqe_bcnt);
 typedef bool (*mlx5e_fp_post_rx_wqes)(struct mlx5e_rq *rq);
 typedef void (*mlx5e_fp_dealloc_wqe)(struct mlx5e_rq*, u16);
 typedef void (*mlx5e_fp_shampo_dealloc_hd)(struct mlx5e_rq*, u16, u16, bool);
@@ -1035,6 +1035,11 @@ int mlx5e_vlan_rx_kill_vid(struct net_device *dev, __always_unused __be16 proto,
 			   u16 vid);
 void mlx5e_timestamp_init(struct mlx5e_priv *priv);
 
+static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
+{
+	return config->rx_filter == HWTSTAMP_FILTER_ALL;
+}
+
 struct mlx5e_xsk_param;
 
 struct mlx5e_rq_param;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index 20507ef2f956..604c8cdfde02 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -156,6 +156,38 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5e_rq *rq,
 	return true;
 }
 
+bool mlx5e_xdp_rx_timestamp_supported(const struct xdp_md *ctx)
+{
+	const struct xdp_buff *xdp = (void *)ctx;
+	struct mlx5_xdp_ctx *mctx = xdp->drv_priv;
+
+	return mlx5e_rx_hw_stamp(mctx->rq->tstamp);
+}
+
+u64 mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx)
+{
+	const struct xdp_buff *xdp = (void *)ctx;
+	struct mlx5_xdp_ctx *mctx = xdp->drv_priv;
+
+	return mlx5e_cqe_ts_to_ns(mctx->rq->ptp_cyc2time,
+				  mctx->rq->clock, get_cqe_ts(mctx->cqe));
+}
+
+bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx)
+{
+	const struct xdp_buff *xdp = (void *)ctx;
+
+	return xdp->rxq->dev->features & NETIF_F_RXHASH;
+}
+
+u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
+{
+	const struct xdp_buff *xdp = (void *)ctx;
+	struct mlx5_xdp_ctx *mctx = xdp->drv_priv;
+
+	return be32_to_cpu(mctx->cqe->rss_hash_result);
+}
+
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
 		      struct bpf_prog *prog, struct xdp_buff *xdp)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index bc2d9034af5b..07d80d0446ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -44,6 +44,11 @@
 	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
 	 sizeof(struct mlx5_wqe_inline_seg))
 
+struct mlx5_xdp_ctx {
+	struct mlx5_cqe64 *cqe;
+	struct mlx5e_rq *rq;
+};
+
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
@@ -56,6 +61,11 @@ void mlx5e_xdp_rx_poll_complete(struct mlx5e_rq *rq);
 int mlx5e_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
 		   u32 flags);
 
+bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx);
+u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx);
+bool mlx5e_xdp_rx_timestamp_supported(const struct xdp_md *ctx);
+u64 mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx);
+
 INDIRECT_CALLABLE_DECLARE(bool mlx5e_xmit_xdp_frame_mpwqe(struct mlx5e_xdpsq *sq,
 							  struct mlx5e_xmit_data *xdptxd,
 							  struct skb_shared_info *sinfo,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index c91b54d9ff27..c6715cb23d45 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -283,8 +283,10 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
+					      struct mlx5_cqe64 *cqe,
 					      u32 cqe_bcnt)
 {
+	struct mlx5_xdp_ctx mlctx = { .cqe = cqe, .rq = rq };
 	struct xdp_buff *xdp = wi->au->xsk;
 	struct bpf_prog *prog;
 
@@ -298,6 +300,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 	xsk_buff_set_size(xdp, cqe_bcnt);
 	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
 	net_prefetch(xdp->data);
+	xdp->drv_priv = &mlctx;
 
 	prog = rcu_dereference(rq->xdp_prog);
 	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
index 087c943bd8e9..9198f137f48f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.h
@@ -18,6 +18,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq,
 						    u32 page_idx);
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
-					      u32 cqe_bcnt);
+                                              struct mlx5_cqe64 *cqe,
+                                              u32 cqe_bcnt);
 
 #endif /* __MLX5_EN_XSK_RX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 14bd86e368d5..015bfe891458 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4890,6 +4890,10 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
 	.ndo_xdp_xmit            = mlx5e_xdp_xmit,
+	.ndo_xdp_rx_timestamp_supported = mlx5e_xdp_rx_timestamp_supported,
+	.ndo_xdp_rx_timestamp    = mlx5e_xdp_rx_timestamp,
+	.ndo_xdp_rx_hash_supported = mlx5e_xdp_rx_hash_supported,
+	.ndo_xdp_rx_hash         = mlx5e_xdp_rx_hash,
 	.ndo_xsk_wakeup          = mlx5e_xsk_wakeup,
 #ifdef CONFIG_MLX5_EN_ARFS
 	.ndo_rx_flow_steer	 = mlx5e_rx_flow_steer,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index b1ea0b995d9c..1d6600441e74 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -76,11 +76,6 @@ const struct mlx5e_rx_handlers mlx5e_rx_handlers_nic = {
 	.handle_rx_cqe_mpwqe_shampo = mlx5e_handle_rx_cqe_mpwrq_shampo,
 };
 
-static inline bool mlx5e_rx_hw_stamp(struct hwtstamp_config *config)
-{
-	return config->rx_filter == HWTSTAMP_FILTER_ALL;
-}
-
 static inline void mlx5e_read_cqe_slot(struct mlx5_cqwq *wq,
 				       u32 cqcc, void *data)
 {
@@ -1573,7 +1568,7 @@ static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroom,
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
-			  u32 cqe_bcnt)
+			  struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
 	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
@@ -1595,7 +1590,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 
 	prog = rcu_dereference(rq->xdp_prog);
 	if (prog) {
-		struct xdp_buff xdp;
+		struct mlx5_xdp_ctx mlctx = { .cqe = cqe, .rq = rq };
+		struct xdp_buff xdp = { .drv_priv = &mlctx };
 
 		net_prefetchw(va); /* xdp_frame data area */
 		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
@@ -1619,16 +1615,17 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
 
 static struct sk_buff *
 mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, struct mlx5e_wqe_frag_info *wi,
-			     u32 cqe_bcnt)
+			     struct mlx5_cqe64 *cqe, u32 cqe_bcnt)
 {
 	struct mlx5e_rq_frag_info *frag_info = &rq->wqe.info.arr[0];
+	struct mlx5_xdp_ctx mlctx = { .cqe = cqe, .rq = rq };
+	struct xdp_buff xdp = { .drv_priv = &mlctx };
 	struct mlx5e_wqe_frag_info *head_wi = wi;
 	union mlx5e_alloc_unit *au = wi->au;
 	u16 rx_headroom = rq->buff.headroom;
 	struct skb_shared_info *sinfo;
 	u32 frag_consumed_bytes;
 	struct bpf_prog *prog;
-	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 	u32 truesize;
@@ -1766,7 +1763,7 @@ static void mlx5e_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 			      mlx5e_skb_from_cqe_linear,
 			      mlx5e_skb_from_cqe_nonlinear,
 			      mlx5e_xsk_skb_from_cqe_linear,
-			      rq, wi, cqe_bcnt);
+			      rq, wi, cqe, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
@@ -2575,7 +2572,7 @@ static void mlx5e_trap_handle_rx_cqe(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe
 		goto free_wqe;
 	}
 
-	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe_bcnt);
+	skb = mlx5e_skb_from_cqe_nonlinear(rq, wi, cqe, cqe_bcnt);
 	if (!skb)
 		goto free_wqe;
 
-- 
2.38.1


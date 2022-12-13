Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9259064ADBF
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 03:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234118AbiLMCh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 21:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234173AbiLMChA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 21:37:00 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 776181E3CD
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:29 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id om16-20020a17090b3a9000b002216006cbffso1292306pjb.3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 18:36:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jUn7yf++A6h6DuOJafUEH14BgG1tpLsbX68awleiLkk=;
        b=JPTxDz1cq+1reaKltMPIXNAJMbFxWkm+fDEYBNWPyZ4M9s8Om3ZkL05D7P3zHXcZcr
         +Rn4KnFT4ZTo1YAl1XP6zElnuwDZrtOuC8+Vuim9KzNYOCfKJPV/VtJOK4YgyxTlGklz
         qwSxDOGaUTpGQktMRfOVwE0/kRW9biwOBidJjeJEnMXUoNTUmzwzSdfFxBryADsXLAXL
         OoGEy6H5d05SSmXG2d1JljwC9BexQAyV7Ap58CZRs9UNQAjYKadBCw2r0mCxQmf8M6Vj
         EHi8KFt919l2a6m1VSYBD0ARUzMpQvNvLXbR4RN9yEyBFxvsnLVx8SroJzJz9MeBqFEi
         BVlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jUn7yf++A6h6DuOJafUEH14BgG1tpLsbX68awleiLkk=;
        b=yrIKqvICr0hFtZfHEVfuABAL9Rvh+BfWgUYM5fawnpHCz/Jw9SP/goswhM/eIpHLbj
         Uf9cP8oPWxXWvWVgHYejZ3ryRuCb8dQR8uEZg/2ON067PYjbdqzO9M8ahnUJs6AY6dWL
         kbpw2JFfpHcfDNzcKgR6rufkHsIy2uu1QwyXO+CiehcQCKKzZ1ALC9ua1rNs3Vg1Xyn3
         L68r3TwPC0JUFC02piZZDvQzA3bQF4+kFI3ClMFa1olMGWLVvSZdJD11kY6QcCra1MRp
         PyQHXN0+cO3+z9cIlqqWa7bxv07BODijh+VsnSd4tZ35oQmMFHmrEpeHcqCV4iRA9suJ
         ktwg==
X-Gm-Message-State: ANoB5pmV+/xd+rkRNzdDkT+fTk3ozUO1lOiVx29C5dnAidj41ABI6Ask
        ppHtq/6T4DlX/V9M8eFhIMrVHlA=
X-Google-Smtp-Source: AA0mqf5giqxaSOqhxZGD74rJj5qlYQTjMYXSUfGDKQ2jfOlRo++NywVhtozQmjTdfHzN7jr2PCNCtyc=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a05:6a00:24c1:b0:573:a1f0:5968 with SMTP id
 d1-20020a056a0024c100b00573a1f05968mr78956499pfv.0.1670898988999; Mon, 12 Dec
 2022 18:36:28 -0800 (PST)
Date:   Mon, 12 Dec 2022 18:36:03 -0800
In-Reply-To: <20221213023605.737383-1-sdf@google.com>
Mime-Version: 1.0
References: <20221213023605.737383-1-sdf@google.com>
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221213023605.737383-14-sdf@google.com>
Subject: [PATCH bpf-next v4 13/15] net/mlx5e: Introduce wrapper for xdp_buff
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

Preparation for implementing HW metadata kfuncs. No functional change.

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
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
 .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 +++++----
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 56 +++++++++----------
 5 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/eth=
ernet/mellanox/mlx5/core/en.h
index ff5b302531d5..be86a599df97 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -469,6 +469,7 @@ struct mlx5e_txqsq {
 union mlx5e_alloc_unit {
 	struct page *page;
 	struct xdp_buff *xsk;
+	struct mlx5e_xdp_buff *mxbuf;
 };
=20
 /* XDP packets can be transmitted in different ways. On completion, we nee=
d to
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.c
index 20507ef2f956..31bb6806bf5d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -158,8 +158,9 @@ mlx5e_xmit_xdp_buff(struct mlx5e_xdpsq *sq, struct mlx5=
e_rq *rq,
=20
 /* returns true if packet was consumed by xdp */
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
-		      struct bpf_prog *prog, struct xdp_buff *xdp)
+		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mxbuf)
 {
+	struct xdp_buff *xdp =3D &mxbuf->xdp;
 	u32 act;
 	int err;
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net=
/ethernet/mellanox/mlx5/core/en/xdp.h
index bc2d9034af5b..389818bf6833 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -44,10 +44,14 @@
 	(MLX5E_XDP_INLINE_WQE_MAX_DS_CNT * MLX5_SEND_WQE_DS - \
 	 sizeof(struct mlx5_wqe_inline_seg))
=20
+struct mlx5e_xdp_buff {
+	struct xdp_buff xdp;
+};
+
 struct mlx5e_xsk_param;
 int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param =
*xsk);
 bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct page *page,
-		      struct bpf_prog *prog, struct xdp_buff *xdp);
+		      struct bpf_prog *prog, struct mlx5e_xdp_buff *mlctx);
 void mlx5e_xdp_mpwqe_complete(struct mlx5e_xdpsq *sq);
 bool mlx5e_poll_xdpsq_cq(struct mlx5e_cq *cq);
 void mlx5e_free_xdpsq_descs(struct mlx5e_xdpsq *sq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/=
net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index c91b54d9ff27..9cff82d764e3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -22,6 +22,7 @@ int mlx5e_xsk_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		goto err;
=20
 	BUILD_BUG_ON(sizeof(wi->alloc_units[0]) !=3D sizeof(wi->alloc_units[0].xs=
k));
+	XSK_CHECK_PRIV_TYPE(struct mlx5e_xdp_buff);
 	batch =3D xsk_buff_alloc_batch(rq->xsk_pool, (struct xdp_buff **)wi->allo=
c_units,
 				     rq->mpwqe.pages_per_wqe);
=20
@@ -233,7 +234,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
 						    u32 head_offset,
 						    u32 page_idx)
 {
-	struct xdp_buff *xdp =3D wi->alloc_units[page_idx].xsk;
+	struct mlx5e_xdp_buff *mxbuf =3D wi->alloc_units[page_idx].mxbuf;
 	struct bpf_prog *prog;
=20
 	/* Check packet size. Note LRO doesn't use linear SKB */
@@ -249,9 +250,9 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(head_offset);
=20
-	xsk_buff_set_size(xdp, cqe_bcnt);
-	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
-	net_prefetch(xdp->data);
+	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
+	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
+	net_prefetch(mxbuf->xdp.data);
=20
 	/* Possible flows:
 	 * - XDP_REDIRECT to XSKMAP:
@@ -269,7 +270,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(str=
uct mlx5e_rq *rq,
 	 */
=20
 	prog =3D rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp))) {
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -278,14 +279,14 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_mpwrq_linear(s=
truct mlx5e_rq *rq,
 	/* XDP_PASS: copy the data from the UMEM to a new SKB and reuse the
 	 * frame. On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp);
+	return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
 }
=20
 struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct mlx5e_rq *rq,
 					      struct mlx5e_wqe_frag_info *wi,
 					      u32 cqe_bcnt)
 {
-	struct xdp_buff *xdp =3D wi->au->xsk;
+	struct mlx5e_xdp_buff *mxbuf =3D wi->au->mxbuf;
 	struct bpf_prog *prog;
=20
 	/* wi->offset is not used in this function, because xdp->data and the
@@ -295,17 +296,17 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_linear(struct =
mlx5e_rq *rq,
 	 */
 	WARN_ON_ONCE(wi->offset);
=20
-	xsk_buff_set_size(xdp, cqe_bcnt);
-	xsk_buff_dma_sync_for_cpu(xdp, rq->xsk_pool);
-	net_prefetch(xdp->data);
+	xsk_buff_set_size(&mxbuf->xdp, cqe_bcnt);
+	xsk_buff_dma_sync_for_cpu(&mxbuf->xdp, rq->xsk_pool);
+	net_prefetch(mxbuf->xdp.data);
=20
 	prog =3D rcu_dereference(rq->xdp_prog);
-	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, xdp)))
+	if (likely(prog && mlx5e_xdp_handle(rq, NULL, prog, mxbuf)))
 		return NULL; /* page/packet was consumed by XDP */
=20
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
 	 * will be handled by mlx5e_free_rx_wqe.
 	 * On SKB allocation failure, NULL is returned.
 	 */
-	return mlx5e_xsk_construct_skb(rq, xdp);
+	return mlx5e_xsk_construct_skb(rq, &mxbuf->xdp);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index b1ea0b995d9c..9785b58ff3bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1565,10 +1565,10 @@ struct sk_buff *mlx5e_build_linear_skb(struct mlx5e=
_rq *rq, void *va,
 }
=20
 static void mlx5e_fill_xdp_buff(struct mlx5e_rq *rq, void *va, u16 headroo=
m,
-				u32 len, struct xdp_buff *xdp)
+				u32 len, struct mlx5e_xdp_buff *mxbuf)
 {
-	xdp_init_buff(xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
-	xdp_prepare_buff(xdp, va, headroom, len, true);
+	xdp_init_buff(&mxbuf->xdp, rq->buff.frame0_sz, &rq->xdp_rxq);
+	xdp_prepare_buff(&mxbuf->xdp, va, headroom, len, true);
 }
=20
 static struct sk_buff *
@@ -1595,16 +1595,16 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, stru=
ct mlx5e_wqe_frag_info *wi,
=20
 	prog =3D rcu_dereference(rq->xdp_prog);
 	if (prog) {
-		struct xdp_buff xdp;
+		struct mlx5e_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp))
+		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf))
 			return NULL; /* page/packet was consumed by XDP */
=20
-		rx_headroom =3D xdp.data - xdp.data_hard_start;
-		metasize =3D xdp.data - xdp.data_meta;
-		cqe_bcnt =3D xdp.data_end - xdp.data;
+		rx_headroom =3D mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
+		metasize =3D mxbuf.xdp.data - mxbuf.xdp.data_meta;
+		cqe_bcnt =3D mxbuf.xdp.data_end - mxbuf.xdp.data;
 	}
 	frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, =
metasize);
@@ -1626,9 +1626,9 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 	union mlx5e_alloc_unit *au =3D wi->au;
 	u16 rx_headroom =3D rq->buff.headroom;
 	struct skb_shared_info *sinfo;
+	struct mlx5e_xdp_buff mxbuf;
 	u32 frag_consumed_bytes;
 	struct bpf_prog *prog;
-	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	dma_addr_t addr;
 	u32 truesize;
@@ -1643,8 +1643,8 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 	net_prefetchw(va); /* xdp_frame data area */
 	net_prefetch(va + rx_headroom);
=20
-	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &xdp);
-	sinfo =3D xdp_get_shared_info_from_buff(&xdp);
+	mlx5e_fill_xdp_buff(rq, va, rx_headroom, frag_consumed_bytes, &mxbuf);
+	sinfo =3D xdp_get_shared_info_from_buff(&mxbuf.xdp);
 	truesize =3D 0;
=20
 	cqe_bcnt -=3D frag_consumed_bytes;
@@ -1662,13 +1662,13 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, s=
truct mlx5e_wqe_frag_info *wi
 		dma_sync_single_for_cpu(rq->pdev, addr + wi->offset,
 					frag_consumed_bytes, rq->buff.map_dir);
=20
-		if (!xdp_buff_has_frags(&xdp)) {
+		if (!xdp_buff_has_frags(&mxbuf.xdp)) {
 			/* Init on the first fragment to avoid cold cache access
 			 * when possible.
 			 */
 			sinfo->nr_frags =3D 0;
 			sinfo->xdp_frags_size =3D 0;
-			xdp_buff_set_frags_flag(&xdp);
+			xdp_buff_set_frags_flag(&mxbuf.xdp);
 		}
=20
 		frag =3D &sinfo->frags[sinfo->nr_frags++];
@@ -1677,7 +1677,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 		skb_frag_size_set(frag, frag_consumed_bytes);
=20
 		if (page_is_pfmemalloc(au->page))
-			xdp_buff_set_frag_pfmemalloc(&xdp);
+			xdp_buff_set_frag_pfmemalloc(&mxbuf.xdp);
=20
 		sinfo->xdp_frags_size +=3D frag_consumed_bytes;
 		truesize +=3D frag_info->frag_stride;
@@ -1690,7 +1690,7 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, str=
uct mlx5e_wqe_frag_info *wi
 	au =3D head_wi->au;
=20
 	prog =3D rcu_dereference(rq->xdp_prog);
-	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
+	if (prog && mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
 		if (test_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
 			int i;
=20
@@ -1700,22 +1700,22 @@ mlx5e_skb_from_cqe_nonlinear(struct mlx5e_rq *rq, s=
truct mlx5e_wqe_frag_info *wi
 		return NULL; /* page/packet was consumed by XDP */
 	}
=20
-	skb =3D mlx5e_build_linear_skb(rq, xdp.data_hard_start, rq->buff.frame0_s=
z,
-				     xdp.data - xdp.data_hard_start,
-				     xdp.data_end - xdp.data,
-				     xdp.data - xdp.data_meta);
+	skb =3D mlx5e_build_linear_skb(rq, mxbuf.xdp.data_hard_start, rq->buff.fr=
ame0_sz,
+				     mxbuf.xdp.data - mxbuf.xdp.data_hard_start,
+				     mxbuf.xdp.data_end - mxbuf.xdp.data,
+				     mxbuf.xdp.data - mxbuf.xdp.data_meta);
 	if (unlikely(!skb))
 		return NULL;
=20
 	page_ref_inc(au->page);
=20
-	if (unlikely(xdp_buff_has_frags(&xdp))) {
+	if (unlikely(xdp_buff_has_frags(&mxbuf.xdp))) {
 		int i;
=20
 		/* sinfo->nr_frags is reset by build_skb, calculate again. */
 		xdp_update_skb_shared_info(skb, wi - head_wi - 1,
 					   sinfo->xdp_frags_size, truesize,
-					   xdp_buff_is_frag_pfmemalloc(&xdp));
+					   xdp_buff_is_frag_pfmemalloc(&mxbuf.xdp));
=20
 		for (i =3D 0; i < sinfo->nr_frags; i++) {
 			skb_frag_t *frag =3D &sinfo->frags[i];
@@ -1996,19 +1996,19 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq=
, struct mlx5e_mpw_info *wi,
=20
 	prog =3D rcu_dereference(rq->xdp_prog);
 	if (prog) {
-		struct xdp_buff xdp;
+		struct mlx5e_xdp_buff mxbuf;
=20
 		net_prefetchw(va); /* xdp_frame data area */
-		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-		if (mlx5e_xdp_handle(rq, au->page, prog, &xdp)) {
+		mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &mxbuf);
+		if (mlx5e_xdp_handle(rq, au->page, prog, &mxbuf)) {
 			if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 				__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 			return NULL; /* page/packet was consumed by XDP */
 		}
=20
-		rx_headroom =3D xdp.data - xdp.data_hard_start;
-		metasize =3D xdp.data - xdp.data_meta;
-		cqe_bcnt =3D xdp.data_end - xdp.data;
+		rx_headroom =3D mxbuf.xdp.data - mxbuf.xdp.data_hard_start;
+		metasize =3D mxbuf.xdp.data - mxbuf.xdp.data_meta;
+		cqe_bcnt =3D mxbuf.xdp.data_end - mxbuf.xdp.data;
 	}
 	frag_size =3D MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 	skb =3D mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt, =
metasize);
--=20
2.39.0.rc1.256.g54fd8350bd-goog


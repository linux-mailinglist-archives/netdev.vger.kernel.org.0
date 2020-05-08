Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EDB1CA941
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgEHLLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:11:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51414 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727980AbgEHLL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 07:11:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588936288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3JldYYClQ8lhN3vE5cEDk8T0Ow3GabPKwoIZ70Lq+O8=;
        b=cC5CbPJgGcWYesQ6NRSU5Ux41C1baGxed1as68TccgJ45+RlfsJ8r+zO6UC4oBBCMH2F8+
        cPLWid4M98zsgFVFlhVN50yCfihrHBHaqwNxxAyc2erh1ujYIUdbpOaThRExMfeOOP+edC
        PeIfq9qKYLV97+/1ppUSKqaDd275fTs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-473-Yk3osTwMMDGze6PU0igoXA-1; Fri, 08 May 2020 07:11:12 -0400
X-MC-Unique: Yk3osTwMMDGze6PU0igoXA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CDC61009629;
        Fri,  8 May 2020 11:11:10 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A29862ABC;
        Fri,  8 May 2020 11:11:09 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 60340300020FB;
        Fri,  8 May 2020 13:11:08 +0200 (CEST)
Subject: [PATCH net-next v3 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>
Date:   Fri, 08 May 2020 13:11:08 +0200
Message-ID: <158893626831.2321140.8243471055668639661.stgit@firesoul>
In-Reply-To: <158893607924.2321140.16117992313983615627.stgit@firesoul>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mlx5 driver have multiple memory models, which are also changed
according to whether a XDP bpf_prog is attached.

The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
 # ethtool --set-priv-flags mlx5p2 rx_striding_rq off

On the general case with 4K page_size and regular MTU packet, then
the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.

The info on the given frame size is stored differently depending on the
RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
what the XDP case cares about.

To reduce effect on fast-path, this patch determine the frame_sz at
setup time, to avoid determining the memory model runtime. Variable
is named first_frame_sz to make it clear that this is only the frame
size of the first fragment.

This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
as it have done a DMA-map on the entire PAGE_SIZE. The driver also
already does a XDP length check against sq->hw_mtu on the possible
XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().

V2: Fix that frag_size need to be recalc before creating SKB.

Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    2 ++
 4 files changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 0864b76ca2c0..8e75a9f9b114 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -652,6 +652,7 @@ struct mlx5e_rq {
 	struct {
 		u16            umem_headroom;
 		u16            headroom;
+		u32            frame0_sz;
 		u8             map_dir;   /* dma map direction */
 	} buff;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index c4a7fb4ecd14..761c8979bd41 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	if (xsk)
 		xdp.handle = di->xsk.handle;
 	xdp.rxq = &rq->xdp_rxq;
+	xdp.frame_sz = rq->buff.frame0_sz;
 
 	act = bpf_prog_run_xdp(prog, &xdp);
 	if (xsk) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 048a4f8601a8..c0f1912bcb65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 
+		rq->buff.frame0_sz = (1 << rq->mpwqe.log_stride_sz);
+
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
 			goto err_rq_wq_destroy;
@@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
 
 		rq->wqe.info = rqp->frags_info;
+		rq->buff.frame0_sz = rq->wqe.info.arr[0].frag_stride;
+
 		rq->wqe.frags =
 			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
 					(wq_sz << rq->wqe.info.log_num_frags)),
@@ -522,6 +526,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 
 	if (xsk) {
+		rq->buff.frame0_sz = xsk_umem_xdp_frame_sz(umem);
+
 		err = mlx5e_xsk_resize_reuseq(umem, num_xsk_frames);
 		if (unlikely(err)) {
 			mlx5_core_err(mdev, "Unable to allocate the Reuse Ring for %u frames\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index d9a5a669b84d..97c2fda8f697 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1064,6 +1064,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	if (consumed)
 		return NULL; /* page/packet was consumed by XDP */
 
+	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
 	if (unlikely(!skb))
 		return NULL;
@@ -1365,6 +1366,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL; /* page/packet was consumed by XDP */
 	}
 
+	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
 	if (unlikely(!skb))
 		return NULL;



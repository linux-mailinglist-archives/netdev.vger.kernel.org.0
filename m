Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081BE1BF6B4
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 13:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgD3LXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 07:23:01 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:47805 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbgD3LXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 07:23:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588245779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IjudM1abJYOZXWTr6d5U8AjkfNM5fAQNlcCDgfff+34=;
        b=Ufys49ALFSZv045G70QYlRmH088+9LDhiH3di8wGOuT3usni7Y2efVaMcFJk4j+U76VhXW
        xwlQU3g4+O4k4xIi+cZh3Kn6Qh4HFTdeT+oldoLJxuaGO5hDSYO8IDq7Qm2zpVO2igBT77
        OnyRuy/NYT2SKPUZGgrH2VSh/XtpQZQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-48jtKgGzNra8gK9xYx-NvQ-1; Thu, 30 Apr 2020 07:22:53 -0400
X-MC-Unique: 48jtKgGzNra8gK9xYx-NvQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6CFF835B43;
        Thu, 30 Apr 2020 11:22:50 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D27B55D787;
        Thu, 30 Apr 2020 11:22:44 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id CE32E324DB2C1;
        Thu, 30 Apr 2020 13:22:43 +0200 (CEST)
Subject: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     sameehj@amazon.com
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, zorik@amazon.com,
        akiyano@amazon.com, gtzalik@amazon.com,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Date:   Thu, 30 Apr 2020 13:22:43 +0200
Message-ID: <158824576377.2172139.12065840702900641458.stgit@firesoul>
In-Reply-To: <158824557985.2172139.4173570969543904434.stgit@firesoul>
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
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
index 23701c0e36ec..ba6a0ee297c6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -652,6 +652,7 @@ struct mlx5e_rq {
 	struct {
 		u16            umem_headroom;
 		u16            headroom;
+		u32            first_frame_sz;
 		u8             map_dir;   /* dma map direction */
 	} buff;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0ac308a..b63abaf51253 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	if (xsk)
 		xdp.handle = di->xsk.handle;
 	xdp.rxq = &rq->xdp_rxq;
+	xdp.frame_sz = rq->buff.first_frame_sz;
 
 	act = bpf_prog_run_xdp(prog, &xdp);
 	if (xsk) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 47396f1b02f4..1d04ed3feead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 
+		rq->buff.first_frame_sz = (1 << rq->mpwqe.log_stride_sz);
+
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
 			goto err_rq_wq_destroy;
@@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
 
 		rq->wqe.info = rqp->frags_info;
+		rq->buff.first_frame_sz = rq->wqe.info.arr[0].frag_stride;
+
 		rq->wqe.frags =
 			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
 					(wq_sz << rq->wqe.info.log_num_frags)),
@@ -522,6 +526,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 	}
 
 	if (xsk) {
+		rq->buff.first_frame_sz = xsk_umem_xdp_frame_sz(umem);
+
 		err = mlx5e_xsk_resize_reuseq(umem, num_xsk_frames);
 		if (unlikely(err)) {
 			mlx5_core_err(mdev, "Unable to allocate the Reuse Ring for %u frames\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index e2beb89c1832..04671ed977a5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1084,6 +1084,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
 	if (consumed)
 		return NULL; /* page/packet was consumed by XDP */
 
+	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
 	if (unlikely(!skb))
 		return NULL;
@@ -1385,6 +1386,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
 		return NULL; /* page/packet was consumed by XDP */
 	}
 
+	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);
 	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
 	if (unlikely(!skb))
 		return NULL;



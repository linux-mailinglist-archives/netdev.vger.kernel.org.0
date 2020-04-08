Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55D171A2052
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 13:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbgDHLw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 07:52:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728725AbgDHLw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 07:52:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586346746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xQy1KLOJ+GIW9rEJSPzyrntrKyatkPT1L3vjqCCiqHY=;
        b=aVzIAbr6HHUqzgkNFqAIJCsubKtRgWm5OL+G7EcR3SPaRH0zkxTqXfbkE30WDQmY1Qrjk9
        av9NE9nxrWuqEw9FVH+X4iOzSS6qvqUyx+w/mDkUfj9aPdRm0UOe4w0Ey57QxXgnlB4bd0
        oDOqQJMimbIbc6jChA+QDpqGthwB6x4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-fQ38NDaINq-UywoF9HsQnQ-1; Wed, 08 Apr 2020 07:52:09 -0400
X-MC-Unique: fQ38NDaINq-UywoF9HsQnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 293388017CE;
        Wed,  8 Apr 2020 11:52:07 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9513E5D9CA;
        Wed,  8 Apr 2020 11:52:01 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id BBED9300020FA;
        Wed,  8 Apr 2020 13:52:00 +0200 (CEST)
Subject: [PATCH RFC v2 17/33] mlx5: rx queue setup time determine frame_sz for
 XDP
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
        Saeed Mahameed <saeedm@mellanox.com>
Date:   Wed, 08 Apr 2020 13:52:00 +0200
Message-ID: <158634672069.707275.13343795980982759611.stgit@firesoul>
In-Reply-To: <158634658714.707275.7903484085370879864.stgit@firesoul>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
in rq->wqe.info.arr[0].frag_stride.

To reduce effect on fast-path, this patch determine the frame_sz at
setup time, to avoid determining the memory model runtime.

Cc: Tariq Toukan <tariqt@mellanox.com>
Cc: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    4 ++++
 3 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 12a61bf82c14..1f280fc142ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -651,6 +651,7 @@ struct mlx5e_rq {
 	struct {
 		u16            umem_headroom;
 		u16            headroom;
+		u32            frame_sz;
 		u8             map_dir;   /* dma map direction */
 	} buff;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
index f049e0ac308a..de4ad2c9f49a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
@@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
 	if (xsk)
 		xdp.handle = di->xsk.handle;
 	xdp.rxq = &rq->xdp_rxq;
+	xdp.frame_sz = rq->buff.frame_sz;
 
 	act = bpf_prog_run_xdp(prog, &xdp);
 	if (xsk) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index dd7f338425eb..b9595315c45b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 		rq->mpwqe.num_strides =
 			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
 
+		rq->buff.frame_sz = (1 << rq->mpwqe.log_stride_sz);
+
 		err = mlx5e_create_rq_umr_mkey(mdev, rq);
 		if (err)
 			goto err_rq_wq_destroy;
@@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
 			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
 
 		rq->wqe.info = rqp->frags_info;
+		rq->buff.frame_sz = rq->wqe.info.arr[0].frag_stride;
+
 		rq->wqe.frags =
 			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
 					(wq_sz << rq->wqe.info.log_num_frags)),



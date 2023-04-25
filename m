Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4095A6EDCD6
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 09:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbjDYHhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 03:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233567AbjDYHgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 03:36:36 -0400
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6F5C157;
        Tue, 25 Apr 2023 00:36:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VgzCnlW_1682408181;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VgzCnlW_1682408181)
          by smtp.aliyun-inc.com;
          Tue, 25 Apr 2023 15:36:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: [PATCH vhost v7 06/11] virtio_ring: packed-indirect: support premapped
Date:   Tue, 25 Apr 2023 15:36:08 +0800
Message-Id: <20230425073613.8839-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
References: <20230425073613.8839-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: c518d34a1cf7
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio core only supports virtual addresses, dma is completed in virtio
core.

In some scenarios (such as the AF_XDP), the memory is allocated
and DMA mapping is completed in advance, so it is necessary for us to
support passing the DMA address to virtio core.

Drives can use sg->dma_address to pass the mapped dma address to virtio
core. If one sg->dma_address is used then all sgs must use sg->dma_address,
otherwise all dma_address must be null when passing it to the APIs of
virtio.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 4b6c6da4cdb4..0bc011e6e96e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1346,6 +1346,7 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	unsigned int i, n;
 	u16 head, id;
 	dma_addr_t addr;
+	bool dma_map_internal;
 
 	head = vq->packed.next_avail_idx;
 	desc = alloc_indirect_packed(total_sg, gfp);
@@ -1363,7 +1364,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	id = vq->free_head;
 	BUG_ON(id == vq->packed.vring.num);
 
-	if (virtqueue_map_sgs(vq, sgs, total_sg, out_sgs, in_sgs))
+	dma_map_internal = !sgs[0]->dma_address;
+	if (dma_map_internal && virtqueue_map_sgs(vq, sgs, total_sg, out_sgs, in_sgs))
 		goto err_map;
 
 	for (n = 0; n < out_sgs + in_sgs; n++) {
@@ -1425,6 +1427,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	vq->packed.desc_state[id].data = data;
 	vq->packed.desc_state[id].indir_desc = desc;
 	vq->packed.desc_state[id].last = id;
+	vq->packed.desc_state[id].flags = dma_map_internal ? VRING_STATE_F_MAP_INTERNAL : 0;
+
 
 	vq->num_added += 1;
 
@@ -1434,7 +1438,8 @@ static int virtqueue_add_indirect_packed(struct vring_virtqueue *vq,
 	return 0;
 
 unmap_release:
-	virtqueue_unmap_sgs(vq, sgs, total_sg, out_sgs, in_sgs);
+	if (dma_map_internal)
+		virtqueue_unmap_sgs(vq, sgs, total_sg, out_sgs, in_sgs);
 
 err_map:
 	kfree(desc);
@@ -1661,7 +1666,7 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 		if (!desc)
 			return;
 
-		if (vq->use_dma_api) {
+		if (vq->use_dma_api && dma_map_internal) {
 			len = vq->packed.desc_extra[id].len;
 			for (i = 0; i < len / sizeof(struct vring_packed_desc);
 					i++)
-- 
2.32.0.3.g01195cf9f


Return-Path: <netdev+bounces-7354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B5571FDBD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:25:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8C95281770
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:25:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F53118AF8;
	Fri,  2 Jun 2023 09:22:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C36A17748;
	Fri,  2 Jun 2023 09:22:21 +0000 (UTC)
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E757E4C;
	Fri,  2 Jun 2023 02:22:19 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vk9M5tA_1685697733;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vk9M5tA_1685697733)
          by smtp.aliyun-inc.com;
          Fri, 02 Jun 2023 17:22:14 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: virtualization@lists.linux-foundation.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	netdev@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH vhost v10 06/10] virtio_ring: packed-detach: support return dma info to driver
Date: Fri,  2 Jun 2023 17:22:02 +0800
Message-Id: <20230602092206.50108-7-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Git-Hash: 3bf1b1dbeb8a
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Under the premapped mode, the driver needs to unmap the DMA address
after receiving the buffer. The virtio core records the DMA address,
so the driver needs a way to get the dma info from the virtio core.

A straightforward approach is to pass an array to the virtio core when
calling virtqueue_get_buf(). However, it is not feasible when there are
multiple DMA addresses in the descriptor chain, and the array size is
unknown.

To solve this problem, a helper be introduced. After calling
virtqueue_get_buf(), the driver can call the helper to
retrieve a dma info. If the helper function returns -EAGAIN, it means
that there are more DMA addresses to be processed, and the driver should
call the helper function again. To keep track of the current position in
the chain, a cursor must be passed to the helper function, which is
initialized by virtqueue_get_buf().

Some processes are done inside this helper, so this helper MUST be
called under the premapped mode.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 105 ++++++++++++++++++++++++++++++++---
 include/linux/virtio.h       |   9 ++-
 2 files changed, 103 insertions(+), 11 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index cdc4349f6066..cbc22daae7e1 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1695,8 +1695,85 @@ static bool virtqueue_kick_prepare_packed(struct virtqueue *_vq)
 	return needs_kick;
 }
 
+static void detach_cursor_init_packed(struct vring_virtqueue *vq,
+				      struct virtqueue_detach_cursor *cursor, u16 id)
+{
+	struct vring_desc_state_packed *state = NULL;
+	u32 len;
+
+	state = &vq->packed.desc_state[id];
+
+	/* Clear data ptr. */
+	state->data = NULL;
+
+	vq->packed.desc_extra[state->last].next = vq->free_head;
+	vq->free_head = id;
+	vq->vq.num_free += state->num;
+
+	/* init cursor */
+	cursor->curr = id;
+	cursor->done = 0;
+	cursor->pos = 0;
+
+	if (vq->packed.desc_extra[id].flags & VRING_DESC_F_INDIRECT) {
+		len = vq->split.desc_extra[id].len;
+
+		cursor->num = len / sizeof(struct vring_packed_desc);
+		cursor->indirect = true;
+
+		vring_unmap_extra_packed(vq, &vq->packed.desc_extra[id]);
+	} else {
+		cursor->num = state->num;
+		cursor->indirect = false;
+	}
+}
+
+static int virtqueue_detach_packed(struct virtqueue *_vq, struct virtqueue_detach_cursor *cursor,
+				   dma_addr_t *addr, u32 *len, enum dma_data_direction *dir)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	if (unlikely(cursor->done))
+		return -EINVAL;
+
+	if (!cursor->indirect) {
+		struct vring_desc_extra *extra;
+
+		extra = &vq->packed.desc_extra[cursor->curr];
+		cursor->curr = extra->next;
+
+		*addr = extra->addr;
+		*len = extra->len;
+		*dir = (extra->flags & VRING_DESC_F_WRITE) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+		if (++cursor->pos == cursor->num) {
+			cursor->done = true;
+			return 0;
+		}
+	} else {
+		struct vring_packed_desc *indir_desc, *desc;
+		u16 flags;
+
+		indir_desc = vq->packed.desc_state[cursor->curr].indir_desc;
+		desc = &indir_desc[cursor->pos];
+
+		flags = le16_to_cpu(desc->flags);
+		*addr = le64_to_cpu(desc->addr);
+		*len = le32_to_cpu(desc->len);
+		*dir = (flags & VRING_DESC_F_WRITE) ?  DMA_FROM_DEVICE : DMA_TO_DEVICE;
+
+		if (++cursor->pos == cursor->num) {
+			kfree(indir_desc);
+			cursor->done = true;
+			return 0;
+		}
+	}
+
+	return -EAGAIN;
+}
+
 static void detach_buf_packed(struct vring_virtqueue *vq,
-			      unsigned int id, void **ctx)
+			      unsigned int id)
 {
 	struct vring_desc_state_packed *state = NULL;
 	struct vring_packed_desc *desc;
@@ -1736,8 +1813,6 @@ static void detach_buf_packed(struct vring_virtqueue *vq,
 		}
 		kfree(desc);
 		state->indir_desc = NULL;
-	} else if (ctx) {
-		*ctx = state->indir_desc;
 	}
 }
 
@@ -1768,7 +1843,8 @@ static bool more_used_packed(const struct vring_virtqueue *vq)
 
 static void *virtqueue_get_buf_ctx_packed(struct virtqueue *_vq,
 					  unsigned int *len,
-					  void **ctx)
+					  void **ctx,
+					  struct virtqueue_detach_cursor *cursor)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	u16 last_used, id, last_used_idx;
@@ -1808,7 +1884,14 @@ static void *virtqueue_get_buf_ctx_packed(struct virtqueue *_vq,
 
 	/* detach_buf_packed clears data, so grab it now. */
 	ret = vq->packed.desc_state[id].data;
-	detach_buf_packed(vq, id, ctx);
+
+	if (!vq->indirect && ctx)
+		*ctx = vq->packed.desc_state[id].indir_desc;
+
+	if (vq->premapped)
+		detach_cursor_init_packed(vq, cursor, id);
+	else
+		detach_buf_packed(vq, id);
 
 	last_used += vq->packed.desc_state[id].num;
 	if (unlikely(last_used >= vq->packed.vring.num)) {
@@ -1960,7 +2043,8 @@ static bool virtqueue_enable_cb_delayed_packed(struct virtqueue *_vq)
 	return true;
 }
 
-static void *virtqueue_detach_unused_buf_packed(struct virtqueue *_vq)
+static void *virtqueue_detach_unused_buf_packed(struct virtqueue *_vq,
+						struct virtqueue_detach_cursor *cursor)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 	unsigned int i;
@@ -1973,7 +2057,10 @@ static void *virtqueue_detach_unused_buf_packed(struct virtqueue *_vq)
 			continue;
 		/* detach_buf clears data, so grab it now. */
 		buf = vq->packed.desc_state[i].data;
-		detach_buf_packed(vq, i, NULL);
+		if (vq->premapped)
+			detach_cursor_init_packed(vq, cursor, i);
+		else
+			detach_buf_packed(vq, i);
 		END_USE(vq);
 		return buf;
 	}
@@ -2458,7 +2545,7 @@ void *virtqueue_get_buf_ctx(struct virtqueue *_vq, unsigned int *len,
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->packed_ring ? virtqueue_get_buf_ctx_packed(_vq, len, ctx) :
+	return vq->packed_ring ? virtqueue_get_buf_ctx_packed(_vq, len, ctx, NULL) :
 				 virtqueue_get_buf_ctx_split(_vq, len, ctx, NULL);
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_buf_ctx);
@@ -2590,7 +2677,7 @@ void *virtqueue_detach_unused_buf(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	return vq->packed_ring ? virtqueue_detach_unused_buf_packed(_vq) :
+	return vq->packed_ring ? virtqueue_detach_unused_buf_packed(_vq, NULL) :
 				 virtqueue_detach_unused_buf_split(_vq, NULL);
 }
 EXPORT_SYMBOL_GPL(virtqueue_detach_unused_buf);
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index eb4a4e4329aa..7f137c7a9034 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -43,8 +43,13 @@ struct virtqueue_detach_cursor {
 	unsigned done:1;
 	unsigned hole:14;
 
-	/* for split head */
-	unsigned head:16;
+	union {
+		/* for split head */
+		unsigned head:16;
+
+		/* for packed id */
+		unsigned curr:16;
+	};
 	unsigned num:16;
 	unsigned pos:16;
 };
-- 
2.32.0.3.g01195cf9f



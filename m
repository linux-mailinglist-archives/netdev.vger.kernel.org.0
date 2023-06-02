Return-Path: <netdev+bounces-7351-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B018171FDB3
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:23:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CE1028173D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:23:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EA8E17FFE;
	Fri,  2 Jun 2023 09:22:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6635F17FED;
	Fri,  2 Jun 2023 09:22:17 +0000 (UTC)
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72302E6E;
	Fri,  2 Jun 2023 02:22:14 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0Vk9OIge_1685697730;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vk9OIge_1685697730)
          by smtp.aliyun-inc.com;
          Fri, 02 Jun 2023 17:22:10 +0800
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
Subject: [PATCH vhost v10 03/10] virtio_ring: split: support add premapped buf
Date: Fri,  2 Jun 2023 17:21:59 +0800
Message-Id: <20230602092206.50108-4-xuanzhuo@linux.alibaba.com>
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

If the vq is the premapped mode, use the sg_dma_address() directly.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 46 ++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 2afdfb9e3e30..18212c3e056b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -598,8 +598,12 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
 			dma_addr_t addr;
 
-			if (vring_map_one_sg(vq, sg, DMA_TO_DEVICE, &addr))
-				goto unmap_release;
+			if (vq->premapped) {
+				addr = sg_dma_address(sg);
+			} else {
+				if (vring_map_one_sg(vq, sg, DMA_TO_DEVICE, &addr))
+					goto unmap_release;
+			}
 
 			prev = i;
 			/* Note that we trust indirect descriptor
@@ -614,8 +618,12 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 		for (sg = sgs[n]; sg; sg = sg_next(sg)) {
 			dma_addr_t addr;
 
-			if (vring_map_one_sg(vq, sg, DMA_FROM_DEVICE, &addr))
-				goto unmap_release;
+			if (vq->premapped) {
+				addr = sg_dma_address(sg);
+			} else {
+				if (vring_map_one_sg(vq, sg, DMA_FROM_DEVICE, &addr))
+					goto unmap_release;
+			}
 
 			prev = i;
 			/* Note that we trust indirect descriptor
@@ -689,21 +697,23 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	return 0;
 
 unmap_release:
-	err_idx = i;
+	if (!vq->premapped) {
+		err_idx = i;
 
-	if (indirect)
-		i = 0;
-	else
-		i = head;
-
-	for (n = 0; n < total_sg; n++) {
-		if (i == err_idx)
-			break;
-		if (indirect) {
-			vring_unmap_one_split_indirect(vq, &desc[i]);
-			i = virtio16_to_cpu(_vq->vdev, desc[i].next);
-		} else
-			i = vring_unmap_one_split(vq, i);
+		if (indirect)
+			i = 0;
+		else
+			i = head;
+
+		for (n = 0; n < total_sg; n++) {
+			if (i == err_idx)
+				break;
+			if (indirect) {
+				vring_unmap_one_split_indirect(vq, &desc[i]);
+				i = virtio16_to_cpu(_vq->vdev, desc[i].next);
+			} else
+				i = vring_unmap_one_split(vq, i);
+		}
 	}
 
 	if (indirect)
-- 
2.32.0.3.g01195cf9f



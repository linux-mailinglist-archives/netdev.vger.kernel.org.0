Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CCB14C2A35
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbiBXLEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbiBXLEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:04:38 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC83D28F977;
        Thu, 24 Feb 2022 03:04:08 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V5O7ats_1645700644;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V5O7ats_1645700644)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 19:04:05 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v2 2/9] virtio_ring: remove flags check for unmap split indirect desc
Date:   Thu, 24 Feb 2022 19:03:55 +0800
Message-Id: <20220224110402.108161-3-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
References: <20220224110402.108161-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: d02e086a8668
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling vring_unmap_one_split_indirect(), it will not encounter the
situation that the flags contains VRING_DESC_F_INDIRECT. So remove this
logic.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/virtio/virtio_ring.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 7cf3ae057833..fadd0a7503e9 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -379,19 +379,11 @@ static void vring_unmap_one_split_indirect(const struct vring_virtqueue *vq,
 
 	flags = virtio16_to_cpu(vq->vq.vdev, desc->flags);
 
-	if (flags & VRING_DESC_F_INDIRECT) {
-		dma_unmap_single(vring_dma_dev(vq),
-				 virtio64_to_cpu(vq->vq.vdev, desc->addr),
-				 virtio32_to_cpu(vq->vq.vdev, desc->len),
-				 (flags & VRING_DESC_F_WRITE) ?
-				 DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	} else {
-		dma_unmap_page(vring_dma_dev(vq),
-			       virtio64_to_cpu(vq->vq.vdev, desc->addr),
-			       virtio32_to_cpu(vq->vq.vdev, desc->len),
-			       (flags & VRING_DESC_F_WRITE) ?
-			       DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	}
+	dma_unmap_page(vring_dma_dev(vq),
+		       virtio64_to_cpu(vq->vq.vdev, desc->addr),
+		       virtio32_to_cpu(vq->vq.vdev, desc->len),
+		       (flags & VRING_DESC_F_WRITE) ?
+		       DMA_FROM_DEVICE : DMA_TO_DEVICE);
 }
 
 static unsigned int vring_unmap_one_split(const struct vring_virtqueue *vq,
-- 
2.31.0


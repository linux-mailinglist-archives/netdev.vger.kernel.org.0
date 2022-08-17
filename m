Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2510B597066
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:09:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239936AbiHQN7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbiHQN7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:59:04 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053AC96FE8;
        Wed, 17 Aug 2022 06:58:57 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id C9DE21008B389;
        Wed, 17 Aug 2022 21:58:35 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id AEB792009BEA0;
        Wed, 17 Aug 2022 21:58:35 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hlbN_24HEFDA; Wed, 17 Aug 2022 21:58:35 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id A1B4E2009BEB0;
        Wed, 17 Aug 2022 21:58:24 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 5/7] virtio: unmask F_NEXT flag in desc_extra
Date:   Wed, 17 Aug 2022 21:57:16 +0800
Message-Id: <20220817135718.2553-6-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
References: <20220817135718.2553-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We didn't unmask F_NEXT flag in desc_extra in the end of a chain,
unmask it so that we can access desc_extra to get next information.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/virtio/virtio_ring.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index a5ec724c01d8..1c1b3fa376a2 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -567,7 +567,7 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 	}
 	/* Last one doesn't continue. */
 	desc[prev].flags &= cpu_to_virtio16(_vq->vdev, ~VRING_DESC_F_NEXT);
-	if (!indirect && vq->use_dma_api)
+	if (!indirect)
 		vq->split.desc_extra[prev & (vq->split.vring.num - 1)].flags &=
 			~VRING_DESC_F_NEXT;
 
@@ -584,6 +584,8 @@ static inline int virtqueue_add_split(struct virtqueue *_vq,
 					 total_sg * sizeof(struct vring_desc),
 					 VRING_DESC_F_INDIRECT,
 					 false);
+		vq->split.desc_extra[head & (vq->split.vring.num - 1)].flags &=
+			~VRING_DESC_F_NEXT;
 	}
 
 	/* We're using some buffers from the free list. */
@@ -693,7 +695,7 @@ static void detach_buf_split(struct vring_virtqueue *vq, unsigned int head,
 	/* Put back on free list: unmap first-level descriptors and find end */
 	i = head;
 
-	while (vq->split.vring.desc[i].flags & nextflag) {
+	while (vq->split.desc_extra[i].flags & nextflag) {
 		vring_unmap_one_split(vq, i);
 		i = vq->split.desc_extra[i].next;
 		vq->vq.num_free++;
-- 
2.17.1


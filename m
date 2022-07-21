Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 992E257C6DF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbiGUIxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232645AbiGUIw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:52:56 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF8880493;
        Thu, 21 Jul 2022 01:52:53 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 90FF41008B38F;
        Thu, 21 Jul 2022 16:44:13 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 7483E200A4ED3;
        Thu, 21 Jul 2022 16:44:13 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id L5Z_9Dui9VVx; Thu, 21 Jul 2022 16:44:10 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id 7A4A0200BFDA8;
        Thu, 21 Jul 2022 16:43:54 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC 1/5] vhost: reorder used descriptors in a batch
Date:   Thu, 21 Jul 2022 16:43:37 +0800
Message-Id: <20220721084341.24183-2-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
References: <20220721084341.24183-1-qtxuning1999@sjtu.edu.cn>
X-Spam-Status: No, score=-0.4 required=5.0 tests=BAYES_00,RCVD_IN_SORBS_WEB,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device may not use descriptors in order, for example, NIC and SCSI may
not call __vhost_add_used_n with buffers in order.  It's the task of
__vhost_add_used_n to order them.  This commit reorder the buffers using
vq->heads, only the batch is begin from the expected start point and is
continuous can the batch be exposed to driver.  And only writing out a
single used ring for a batch of descriptors, according to VIRTIO 1.1
spec.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/vhost.c | 44 +++++++++++++++++++++++++++++++++++++++++--
 drivers/vhost/vhost.h |  3 +++
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826c..e2e77e29f 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -317,6 +317,7 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->used_flags = 0;
 	vq->log_used = false;
 	vq->log_addr = -1ull;
+	vq->next_used_head_idx = 0;
 	vq->private_data = NULL;
 	vq->acked_features = 0;
 	vq->acked_backend_features = 0;
@@ -398,6 +399,8 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
 					  GFP_KERNEL);
 		if (!vq->indirect || !vq->log || !vq->heads)
 			goto err_nomem;
+
+		memset(vq->heads, 0, sizeof(*vq->heads) * dev->iov_limit);
 	}
 	return 0;
 
@@ -2374,12 +2377,49 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 			    unsigned count)
 {
 	vring_used_elem_t __user *used;
+	struct vring_desc desc;
 	u16 old, new;
 	int start;
+	int begin, end, i;
+	int copy_n = count;
+
+	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
+		/* calculate descriptor chain length for each used buffer */
+		for (i = 0; i < count; i++) {
+			begin = heads[i].id;
+			end = begin;
+			vq->heads[begin].len = 0;
+			do {
+				vq->heads[begin].len += 1;
+				if (unlikely(vhost_get_desc(vq, &desc, end))) {
+					vq_err(vq, "Failed to get descriptor: idx %d addr %p\n",
+					       end, vq->desc + end);
+					return -EFAULT;
+				}
+			} while ((end = next_desc(vq, &desc)) != -1);
+		}
+
+		count = 0;
+		/* sort and batch continuous used ring entry */
+		while (vq->heads[vq->next_used_head_idx].len != 0) {
+			count++;
+			i = vq->next_used_head_idx;
+			vq->next_used_head_idx = (vq->next_used_head_idx +
+						  vq->heads[vq->next_used_head_idx].len)
+						  % vq->num;
+			vq->heads[i].len = 0;
+		}
+		/* only write out a single used ring entry with the id corresponding
+		 * to the head entry of the descriptor chain describing the last buffer
+		 * in the batch.
+		 */
+		heads[0].id = i;
+		copy_n = 1;
+	}
 
 	start = vq->last_used_idx & (vq->num - 1);
 	used = vq->used->ring + start;
-	if (vhost_put_used(vq, heads, start, count)) {
+	if (vhost_put_used(vq, heads, start, copy_n)) {
 		vq_err(vq, "Failed to write used");
 		return -EFAULT;
 	}
@@ -2410,7 +2450,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 
 	start = vq->last_used_idx & (vq->num - 1);
 	n = vq->num - start;
-	if (n < count) {
+	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
 		r = __vhost_add_used_n(vq, heads, n);
 		if (r < 0)
 			return r;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107a..7b2c0fbb5 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -107,6 +107,9 @@ struct vhost_virtqueue {
 	bool log_used;
 	u64 log_addr;
 
+	/* Sort heads in order */
+	u16 next_used_head_idx;
+
 	struct iovec iov[UIO_MAXIOV];
 	struct iovec iotlb_iov[64];
 	struct iovec *indirect;
-- 
2.17.1


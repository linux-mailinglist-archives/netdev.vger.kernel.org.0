Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7428597047
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 15:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbiHQN6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 09:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiHQN5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 09:57:55 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46F2096751;
        Wed, 17 Aug 2022 06:57:52 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 38CFD1008B38F;
        Wed, 17 Aug 2022 21:57:44 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 0FF992009BEA0;
        Wed, 17 Aug 2022 21:57:44 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id IDVIL2_B6a_l; Wed, 17 Aug 2022 21:57:43 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id DD9B32009BEAD;
        Wed, 17 Aug 2022 21:57:31 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v2 1/7] vhost: expose used buffers
Date:   Wed, 17 Aug 2022 21:57:12 +0800
Message-Id: <20220817135718.2553-2-qtxuning1999@sjtu.edu.cn>
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

Follow VIRTIO 1.1 spec, only writing out a single used ring for a batch
of descriptors.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/vhost.c | 14 ++++++++++++--
 drivers/vhost/vhost.h |  1 +
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..7b20fa5a46c3 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2376,10 +2376,20 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 	vring_used_elem_t __user *used;
 	u16 old, new;
 	int start;
+	int copy_n = count;
 
+	/**
+	 * If in order feature negotiated, devices can notify the use of a batch of buffers to
+	 * the driver by only writing out a single used ring entry with the id corresponding
+	 * to the head entry of the descriptor chain describing the last buffer in the batch.
+	 */
+	if (vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
+		copy_n = 1;
+		heads = &heads[count - 1];
+	}
 	start = vq->last_used_idx & (vq->num - 1);
 	used = vq->used->ring + start;
-	if (vhost_put_used(vq, heads, start, count)) {
+	if (vhost_put_used(vq, heads, start, copy_n)) {
 		vq_err(vq, "Failed to write used");
 		return -EFAULT;
 	}
@@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 
 	start = vq->last_used_idx & (vq->num - 1);
 	n = vq->num - start;
-	if (n < count) {
+	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
 		r = __vhost_add_used_n(vq, heads, n);
 		if (r < 0)
 			return r;
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index d9109107af08..0d5c49a30421 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -236,6 +236,7 @@ enum {
 	VHOST_FEATURES = (1ULL << VIRTIO_F_NOTIFY_ON_EMPTY) |
 			 (1ULL << VIRTIO_RING_F_INDIRECT_DESC) |
 			 (1ULL << VIRTIO_RING_F_EVENT_IDX) |
+			 (1ULL << VIRTIO_F_IN_ORDER) |
 			 (1ULL << VHOST_F_LOG_ALL) |
 			 (1ULL << VIRTIO_F_ANY_LAYOUT) |
 			 (1ULL << VIRTIO_F_VERSION_1)
-- 
2.17.1


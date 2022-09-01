Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC5E15A8DBC
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233169AbiIAFzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiIAFzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:55:20 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714FD2B241;
        Wed, 31 Aug 2022 22:55:13 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 75EE01008B39A;
        Thu,  1 Sep 2022 13:55:00 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 609CA2020B0F0;
        Thu,  1 Sep 2022 13:55:00 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hp0m2z9P8C9H; Thu,  1 Sep 2022 13:55:00 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id D71342009BEAF;
        Thu,  1 Sep 2022 13:54:46 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v3 1/7] vhost: expose used buffers
Date:   Thu,  1 Sep 2022 13:54:28 +0800
Message-Id: <20220901055434.824-2-qtxuning1999@sjtu.edu.cn>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
References: <20220901055434.824-1-qtxuning1999@sjtu.edu.cn>
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
 drivers/vhost/vhost.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 40097826cff0..26862c8bf751 100644
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
@@ -2388,7 +2398,7 @@ static int __vhost_add_used_n(struct vhost_virtqueue *vq,
 		smp_wmb();
 		/* Log used ring entry write. */
 		log_used(vq, ((void __user *)used - (void __user *)vq->used),
-			 count * sizeof *used);
+			 copy_n * sizeof(*used));
 	}
 	old = vq->last_used_idx;
 	new = (vq->last_used_idx += count);
@@ -2410,7 +2420,7 @@ int vhost_add_used_n(struct vhost_virtqueue *vq, struct vring_used_elem *heads,
 
 	start = vq->last_used_idx & (vq->num - 1);
 	n = vq->num - start;
-	if (n < count) {
+	if (n < count && !vhost_has_feature(vq, VIRTIO_F_IN_ORDER)) {
 		r = __vhost_add_used_n(vq, heads, n);
 		if (r < 0)
 			return r;
-- 
2.17.1


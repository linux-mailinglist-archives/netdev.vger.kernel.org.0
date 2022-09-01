Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 008D85A8DBD
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 07:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbiIAFzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 01:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbiIAFzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 01:55:35 -0400
Received: from smtp236.sjtu.edu.cn (smtp236.sjtu.edu.cn [202.120.2.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170F348EA7;
        Wed, 31 Aug 2022 22:55:32 -0700 (PDT)
Received: from proxy02.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
        by smtp236.sjtu.edu.cn (Postfix) with ESMTPS id 986E71008B399;
        Thu,  1 Sep 2022 13:55:12 +0800 (CST)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by proxy02.sjtu.edu.cn (Postfix) with ESMTP id 7B5CB2020B0ED;
        Thu,  1 Sep 2022 13:55:11 +0800 (CST)
X-Virus-Scanned: amavisd-new at 
Received: from proxy02.sjtu.edu.cn ([127.0.0.1])
        by localhost (proxy02.sjtu.edu.cn [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id tZFLs25QOxNr; Thu,  1 Sep 2022 13:55:11 +0800 (CST)
Received: from localhost.localdomain (unknown [202.120.40.82])
        (Authenticated sender: qtxuning1999@sjtu.edu.cn)
        by proxy02.sjtu.edu.cn (Postfix) with ESMTPSA id AEA1F200BFDA8;
        Thu,  1 Sep 2022 13:55:00 +0800 (CST)
From:   Guo Zhi <qtxuning1999@sjtu.edu.cn>
To:     eperezma@redhat.com, jasowang@redhat.com, sgarzare@redhat.com,
        mst@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Guo Zhi <qtxuning1999@sjtu.edu.cn>
Subject: [RFC v3 2/7] vhost_test: batch used buffer
Date:   Thu,  1 Sep 2022 13:54:29 +0800
Message-Id: <20220901055434.824-3-qtxuning1999@sjtu.edu.cn>
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

Only add to used ring when a batch of buffer have all been used.  And if
in order feature negotiated, only add the last used descriptor for a
batch of buffer.

Signed-off-by: Guo Zhi <qtxuning1999@sjtu.edu.cn>
---
 drivers/vhost/test.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index bc8e7fb1e635..20548a5eb3de 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -28,6 +28,11 @@
  */
 #define VHOST_TEST_PKT_WEIGHT 256
 
+enum {
+	VHOST_TEST_FEATURES = VHOST_FEATURES |
+			      (1ULL << VIRTIO_F_IN_ORDER)
+};
+
 enum {
 	VHOST_TEST_VQ = 0,
 	VHOST_TEST_VQ_MAX = 1,
@@ -44,7 +49,7 @@ static void handle_vq(struct vhost_test *n)
 {
 	struct vhost_virtqueue *vq = &n->vqs[VHOST_TEST_VQ];
 	unsigned out, in;
-	int head;
+	int head, add = 0;
 	size_t len, total_len = 0;
 	void *private;
 
@@ -84,11 +89,14 @@ static void handle_vq(struct vhost_test *n)
 			vq_err(vq, "Unexpected 0 len for TX\n");
 			break;
 		}
-		vhost_add_used_and_signal(&n->dev, vq, head, 0);
+		vq->heads[add].id = cpu_to_vhost32(vq, head);
+		vq->heads[add++].len = cpu_to_vhost32(vq, len);
 		total_len += len;
 		if (unlikely(vhost_exceeds_weight(vq, 0, total_len)))
 			break;
 	}
+	if (add)
+		vhost_add_used_and_signal_n(&n->dev, vq, vq->heads, add);
 
 	mutex_unlock(&vq->mutex);
 }
@@ -328,7 +336,7 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 			return -EFAULT;
 		return vhost_test_set_backend(n, backend.index, backend.fd);
 	case VHOST_GET_FEATURES:
-		features = VHOST_FEATURES;
+		features = VHOST_TEST_FEATURES;
 		if (copy_to_user(featurep, &features, sizeof features))
 			return -EFAULT;
 		return 0;
@@ -337,7 +345,7 @@ static long vhost_test_ioctl(struct file *f, unsigned int ioctl,
 		if (copy_from_user(&features, featurep, sizeof features))
 			return -EFAULT;
 		printk(KERN_ERR "2\n");
-		if (features & ~VHOST_FEATURES)
+		if (features & ~VHOST_TEST_FEATURES)
 			return -EOPNOTSUPP;
 		printk(KERN_ERR "3\n");
 		return vhost_test_set_features(n, features);
-- 
2.17.1


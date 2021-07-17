Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0B23CC2A0
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbhGQKYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 06:24:24 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:60874
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S231317AbhGQKYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 06:24:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fudan.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=DFECFwsmhKmoaWh5jv26HPCrTfdgOfh2qVaPeoF0Ry4=; b=v
        pnLoYXaCz7jBV024MUSE3jKELL5XFhMoHFx5NInTvwEVgb+mHWJ8VBHsZG+tNBlB
        m/KjvIS+xk6jtdkxddQhL16kvwoUrhIa+bctqvf6geMzuJHMksQI/IEC5Frajf/E
        jFpIh6cGyrwpvTFrF+Y0mqde8CZQEsTKJtHRtn7zvQ=
Received: from localhost.localdomain (unknown [39.144.44.130])
        by app2 (Coremail) with SMTP id XQUFCgDn7AzxrvJgAL7YBA--.38476S3;
        Sat, 17 Jul 2021 18:20:34 +0800 (CST)
From:   Xiyu Yang <xiyuyang19@fudan.edu.cn>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     yuanxzhang@fudan.edu.cn, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>
Subject: [PATCH] vhost_net: Convert from atomic_t to refcount_t on vhost_net_ubuf_ref->refcount
Date:   Sat, 17 Jul 2021 18:20:30 +0800
Message-Id: <1626517230-42920-1-git-send-email-xiyuyang19@fudan.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: XQUFCgDn7AzxrvJgAL7YBA--.38476S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWkXrW3Wr1DWrWxtF43ZFb_yoW5Xw4fpF
        WDtrykAa1fKF1xJwn7J340vw1rJw18Cr95GrWakasxCFyagwsrX3yvkFyYvry5AFZrCFyx
        XF4qgr1Sk3y7XaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUvG14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
        JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
        CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
        F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE14v26r1j6r
        4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I
        648v4I1lc2xSY4AK67AK6r4DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r
        4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF
        67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2I
        x0cI8IcVCY1x0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6Fyj6rWUJwCI42IY
        6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa
        73UjIFyTuYvjfUo8nYUUUUU
X-CM-SenderInfo: irzsiiysuqikmy6i3vldqovvfxof0/
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

refcount_t type and corresponding API can protect refcounters from
accidental underflow and overflow and further use-after-free situations.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
---
 drivers/vhost/net.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6414bd5741b8..e23150ca7d4c 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -5,6 +5,7 @@
  * virtio-net server in host kernel.
  */
 
+#include <linux/refcount.h>
 #include <linux/compat.h>
 #include <linux/eventfd.h>
 #include <linux/vhost.h>
@@ -92,7 +93,7 @@ struct vhost_net_ubuf_ref {
 	 *  1: no outstanding ubufs
 	 * >1: outstanding ubufs
 	 */
-	atomic_t refcount;
+	refcount_t refcount;
 	wait_queue_head_t wait;
 	struct vhost_virtqueue *vq;
 };
@@ -240,7 +241,7 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 	ubufs = kmalloc(sizeof(*ubufs), GFP_KERNEL);
 	if (!ubufs)
 		return ERR_PTR(-ENOMEM);
-	atomic_set(&ubufs->refcount, 1);
+	refcount_set(&ubufs->refcount, 1);
 	init_waitqueue_head(&ubufs->wait);
 	ubufs->vq = vq;
 	return ubufs;
@@ -248,7 +249,8 @@ vhost_net_ubuf_alloc(struct vhost_virtqueue *vq, bool zcopy)
 
 static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 {
-	int r = atomic_sub_return(1, &ubufs->refcount);
+	refcount_dec(&ubufs->refcount);
+	int r = refcount_read(&ubufs->refcount);
 	if (unlikely(!r))
 		wake_up(&ubufs->wait);
 	return r;
@@ -257,7 +259,7 @@ static int vhost_net_ubuf_put(struct vhost_net_ubuf_ref *ubufs)
 static void vhost_net_ubuf_put_and_wait(struct vhost_net_ubuf_ref *ubufs)
 {
 	vhost_net_ubuf_put(ubufs);
-	wait_event(ubufs->wait, !atomic_read(&ubufs->refcount));
+	wait_event(ubufs->wait, !refcount_read(&ubufs->refcount));
 }
 
 static void vhost_net_ubuf_put_wait_and_free(struct vhost_net_ubuf_ref *ubufs)
@@ -909,7 +911,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 			ctl.ptr = ubuf;
 			msg.msg_controllen = sizeof(ctl);
 			ubufs = nvq->ubufs;
-			atomic_inc(&ubufs->refcount);
+			refcount_inc(&ubufs->refcount);
 			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
 		} else {
 			msg.msg_control = NULL;
@@ -1384,7 +1386,7 @@ static void vhost_net_flush(struct vhost_net *n)
 		vhost_net_ubuf_put_and_wait(n->vqs[VHOST_NET_VQ_TX].ubufs);
 		mutex_lock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
 		n->tx_flush = false;
-		atomic_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
+		refcount_set(&n->vqs[VHOST_NET_VQ_TX].ubufs->refcount, 1);
 		mutex_unlock(&n->vqs[VHOST_NET_VQ_TX].vq.mutex);
 	}
 }
-- 
2.7.4


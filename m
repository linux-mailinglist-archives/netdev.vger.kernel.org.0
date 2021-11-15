Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB845088A
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236667AbhKOPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbhKOPfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:35:06 -0500
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07228C0613B9;
        Mon, 15 Nov 2021 07:32:06 -0800 (PST)
Received: from iva8-d2cd82b7433e.qloud-c.yandex.net (iva8-d2cd82b7433e.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:a88e:0:640:d2cd:82b7])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id E37B42E0D2E;
        Mon, 15 Nov 2021 18:30:09 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d2cd82b7433e.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 1azPPW854o-U9s8PH06;
        Mon, 15 Nov 2021 18:30:09 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com; s=default;
        t=1636990209; bh=J+h9MxEvCgi9lU9qUsoWtrGY5JYnznqxdEvYLGooECM=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=eYLIjVv35LU1cKVxw+wRpipiW6+rgtAxwKx6CyvYZVw69FKpHjhfdtLrJ5F3Hsbok
         hTeKtaeyXZG4WLzHL9CoMS5ItNHFT32+udslHAZJDJEjvyYK/VJFrhZ2IjjsNgEMlw
         rjHHEdzAxp3o6Pn9FdJ/k2TNeeqbn5Pp3grSQmZM=
Authentication-Results: iva8-d2cd82b7433e.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.com
Received: from dellarbn.yandex.net (dynamic-red3.dhcp.yndx.net [2a02:6b8:0:107:3e85:844d:5b1d:60a])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPS id wuqDqjnGag-U8xaesO8;
        Mon, 15 Nov 2021 18:30:09 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
X-Yandex-Fwd: 2
From:   Andrey Ryabinin <arbn@yandex-team.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Andrey Ryabinin <arbn@yandex-team.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] vhost: get rid of vhost_poll_flush() wrapper
Date:   Mon, 15 Nov 2021 18:29:58 +0300
Message-Id: <20211115153003.9140-1-arbn@yandex-team.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

vhost_poll_flush() is a simple wrapper around vhost_work_dev_flush().
It gives wrong impression that we are doing some work over vhost_poll,
while in fact it flushes vhost_poll->dev.
It only complicate understanding of the code and leads to mistakes
like flushing the same vhost_dev several times in a row.

Just remove vhost_poll_flush() and call vhost_work_dev_flush() directly.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 drivers/vhost/net.c   |  4 ++--
 drivers/vhost/test.c  |  2 +-
 drivers/vhost/vhost.c | 12 ++----------
 drivers/vhost/vsock.c |  2 +-
 4 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..11221f6d11b8 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1375,8 +1375,8 @@ static void vhost_net_stop(struct vhost_net *n, struct socket **tx_sock,
 
 static void vhost_net_flush_vq(struct vhost_net *n, int index)
 {
-	vhost_poll_flush(n->poll + index);
-	vhost_poll_flush(&n->vqs[index].vq.poll);
+	vhost_work_dev_flush(n->poll[index].dev);
+	vhost_work_dev_flush(n->vqs[index].vq.poll.dev);
 }
 
 static void vhost_net_flush(struct vhost_net *n)
diff --git a/drivers/vhost/test.c b/drivers/vhost/test.c
index a09dedc79f68..1a8ab1d8cb1c 100644
--- a/drivers/vhost/test.c
+++ b/drivers/vhost/test.c
@@ -146,7 +146,7 @@ static void vhost_test_stop(struct vhost_test *n, void **privatep)
 
 static void vhost_test_flush_vq(struct vhost_test *n, int index)
 {
-	vhost_poll_flush(&n->vqs[index].poll);
+	vhost_work_dev_flush(n->vqs[index].poll.dev);
 }
 
 static void vhost_test_flush(struct vhost_test *n)
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 59edb5a1ffe2..ca088481da0e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -245,14 +245,6 @@ void vhost_work_dev_flush(struct vhost_dev *dev)
 }
 EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
 
-/* Flush any work that has been scheduled. When calling this, don't hold any
- * locks that are also used by the callback. */
-void vhost_poll_flush(struct vhost_poll *poll)
-{
-	vhost_work_dev_flush(poll->dev);
-}
-EXPORT_SYMBOL_GPL(vhost_poll_flush);
-
 void vhost_work_queue(struct vhost_dev *dev, struct vhost_work *work)
 {
 	if (!dev->worker)
@@ -663,7 +655,7 @@ void vhost_dev_stop(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		if (dev->vqs[i]->kick && dev->vqs[i]->handle_kick) {
 			vhost_poll_stop(&dev->vqs[i]->poll);
-			vhost_poll_flush(&dev->vqs[i]->poll);
+			vhost_work_dev_flush(dev->vqs[i]->poll.dev);
 		}
 	}
 }
@@ -1712,7 +1704,7 @@ long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *arg
 	mutex_unlock(&vq->mutex);
 
 	if (pollstop && vq->handle_kick)
-		vhost_poll_flush(&vq->poll);
+		vhost_work_dev_flush(vq->poll.dev);
 	return r;
 }
 EXPORT_SYMBOL_GPL(vhost_vring_ioctl);
diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 938aefbc75ec..b0361ebbd695 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -711,7 +711,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
 
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
 		if (vsock->vqs[i].handle_kick)
-			vhost_poll_flush(&vsock->vqs[i].poll);
+			vhost_work_dev_flush(vsock->vqs[i].poll.dev);
 	vhost_work_dev_flush(&vsock->dev);
 }
 
-- 
2.32.0


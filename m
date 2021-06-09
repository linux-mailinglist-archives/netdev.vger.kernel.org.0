Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA013A20B8
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 01:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbhFIX3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 19:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbhFIX3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 19:29:39 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA3DC0617A6
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 16:27:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so2644539pjq.3
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 16:27:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r8XBgJHTxrXFtSMQVzajzu+b1SL5llDzrX12khypvWk=;
        b=YRp7IbdiWcuBxknxIpOMnDJBEqWlQkSzds59gCQC/neXQhUv7TodzzMSjgPebbno6v
         DjYtvf2iGHZWtfrc1ZY7XrNh9THCH3+dTY57Ufq0FRt9WuV2NGz7tO4FvkTSL6kP9dQb
         YFDp5qCH3kq64w1N/wuk1gyt1TomnS5CRnzbnnaSSAAWWrMepYoAqxZpePjXNOnr4CGM
         upjKyAfXyekQquGm3/9krmhcaC22r9RUTuAYOXln8dpgUtmWIT7kEgECjxwr/cqfkDg/
         SDH0Nljo1ngY+lDXrpnv+w8fSbJOQfWdkolvfJPtsjrPoJny916dQwU8bPq2Rlob5eTP
         cXng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r8XBgJHTxrXFtSMQVzajzu+b1SL5llDzrX12khypvWk=;
        b=c81Z0c9Fx6kv5KoETBaLoVtuwQ90TI2k+7XNe7TLRcAF7BHreI+pNh6YDNISuZyMUk
         HIo8Pn+kqaZabLAcHARE5ql6wBPSeFRbxWSZp6uNFvrVw8NfUowd9CR6x+DIBhJLBLtC
         dFexuTFEV9YYSPpk74rUG6XVTatAD/LlUSTrKn9gdDATTl0RXV7vGHMpORAnIQDAWa7v
         j3lhaK0XLzSq28yRcXO8MDWllVaTzaxl+KyuKcO22CmocLaCb3rsGZ/PtP30PjfhcWf8
         ex/bmOLpHatpUlOFAVtvy8BUL73pXv8NoGaIiw3SCivukq4BksVminROu0kDQY3FT4st
         ivwg==
X-Gm-Message-State: AOAM533dSHvyjtIT413W4QYDhpKYo41v5L+TMTW2GP5SHHtOLahETp5J
        zfxhtaJn7LzCpyOr95Mqtob2MQ==
X-Google-Smtp-Source: ABdhPJyxFSEKnaZ2ltvDInR67Ojfj4gWGKonXTvsJqyjudBs7otrxqn/jyoKEjVRgmlZu3AziO1Q1g==
X-Received: by 2002:a17:90a:f317:: with SMTP id ca23mr154709pjb.174.1623281249606;
        Wed, 09 Jun 2021 16:27:29 -0700 (PDT)
Received: from n124-121-013.byted.org (ec2-54-241-92-238.us-west-1.compute.amazonaws.com. [54.241.92.238])
        by smtp.gmail.com with ESMTPSA id k1sm526783pfa.30.2021.06.09.16.27.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 16:27:29 -0700 (PDT)
From:   Jiang Wang <jiang.wang@bytedance.com>
To:     sgarzare@redhat.com
Cc:     virtualization@lists.linux-foundation.org, stefanha@redhat.com,
        mst@redhat.com, arseny.krasnov@kaspersky.com,
        jhansen@vmware.comments, cong.wang@bytedance.com,
        duanxiongchun@bytedance.com, xieyongji@bytedance.com,
        chaiwen.cc@bytedance.com, Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC v1 1/6] virtio/vsock: add VIRTIO_VSOCK_F_DGRAM feature bit
Date:   Wed,  9 Jun 2021 23:24:53 +0000
Message-Id: <20210609232501.171257-2-jiang.wang@bytedance.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20210609232501.171257-1-jiang.wang@bytedance.com>
References: <20210609232501.171257-1-jiang.wang@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When this feature is enabled, allocate 5 queues,
otherwise, allocate 3 queues to be compatible with
old QEMU versions.

Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
---
 drivers/vhost/vsock.c             |  3 +-
 include/linux/virtio_vsock.h      |  9 +++++
 include/uapi/linux/virtio_vsock.h |  3 ++
 net/vmw_vsock/virtio_transport.c  | 73 +++++++++++++++++++++++++++++++++++----
 4 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..81d064601093 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -31,7 +31,8 @@
 
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			       (1ULL << VIRTIO_VSOCK_F_DGRAM)
 };
 
 enum {
diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index dc636b727179..ba3189ed9345 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -18,6 +18,15 @@ enum {
 	VSOCK_VQ_MAX    = 3,
 };
 
+enum {
+	VSOCK_VQ_STREAM_RX     = 0, /* for host to guest data */
+	VSOCK_VQ_STREAM_TX     = 1, /* for guest to host data */
+	VSOCK_VQ_DGRAM_RX       = 2,
+	VSOCK_VQ_DGRAM_TX       = 3,
+	VSOCK_VQ_EX_EVENT       = 4,
+	VSOCK_VQ_EX_MAX         = 5,
+};
+
 /* Per-socket state (accessed via vsk->trans) */
 struct virtio_vsock_sock {
 	struct vsock_sock *vsk;
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 1d57ed3d84d2..b56614dff1c9 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -38,6 +38,9 @@
 #include <linux/virtio_ids.h>
 #include <linux/virtio_config.h>
 
+/* The feature bitmap for virtio net */
+#define VIRTIO_VSOCK_F_DGRAM	0	/* Host support dgram vsock */
+
 struct virtio_vsock_config {
 	__le64 guest_cid;
 } __attribute__((packed));
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..7dcb8db23305 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -27,7 +27,8 @@ static DEFINE_MUTEX(the_virtio_vsock_mutex); /* protects the_virtio_vsock */
 
 struct virtio_vsock {
 	struct virtio_device *vdev;
-	struct virtqueue *vqs[VSOCK_VQ_MAX];
+	struct virtqueue **vqs;
+	bool has_dgram;
 
 	/* Virtqueue processing is deferred to a workqueue */
 	struct work_struct tx_work;
@@ -333,7 +334,10 @@ static int virtio_vsock_event_fill_one(struct virtio_vsock *vsock,
 	struct scatterlist sg;
 	struct virtqueue *vq;
 
-	vq = vsock->vqs[VSOCK_VQ_EVENT];
+	if (vsock->has_dgram)
+		vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
+	else
+		vq = vsock->vqs[VSOCK_VQ_EVENT];
 
 	sg_init_one(&sg, event, sizeof(*event));
 
@@ -351,7 +355,10 @@ static void virtio_vsock_event_fill(struct virtio_vsock *vsock)
 		virtio_vsock_event_fill_one(vsock, event);
 	}
 
-	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
+	if (vsock->has_dgram)
+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
+	else
+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
 }
 
 static void virtio_vsock_reset_sock(struct sock *sk)
@@ -391,7 +398,10 @@ static void virtio_transport_event_work(struct work_struct *work)
 		container_of(work, struct virtio_vsock, event_work);
 	struct virtqueue *vq;
 
-	vq = vsock->vqs[VSOCK_VQ_EVENT];
+	if (vsock->has_dgram)
+		vq = vsock->vqs[VSOCK_VQ_EX_EVENT];
+	else
+		vq = vsock->vqs[VSOCK_VQ_EVENT];
 
 	mutex_lock(&vsock->event_lock);
 
@@ -411,7 +421,10 @@ static void virtio_transport_event_work(struct work_struct *work)
 		}
 	} while (!virtqueue_enable_cb(vq));
 
-	virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
+	if (vsock->has_dgram)
+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EX_EVENT]);
+	else
+		virtqueue_kick(vsock->vqs[VSOCK_VQ_EVENT]);
 out:
 	mutex_unlock(&vsock->event_lock);
 }
@@ -434,6 +447,10 @@ static void virtio_vsock_tx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->tx_work);
 }
 
+static void virtio_vsock_dgram_tx_done(struct virtqueue *vq)
+{
+}
+
 static void virtio_vsock_rx_done(struct virtqueue *vq)
 {
 	struct virtio_vsock *vsock = vq->vdev->priv;
@@ -443,6 +460,10 @@ static void virtio_vsock_rx_done(struct virtqueue *vq)
 	queue_work(virtio_vsock_workqueue, &vsock->rx_work);
 }
 
+static void virtio_vsock_dgram_rx_done(struct virtqueue *vq)
+{
+}
+
 static struct virtio_transport virtio_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -545,13 +566,29 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 		virtio_vsock_tx_done,
 		virtio_vsock_event_done,
 	};
+	vq_callback_t *ex_callbacks[] = {
+		virtio_vsock_rx_done,
+		virtio_vsock_tx_done,
+		virtio_vsock_dgram_rx_done,
+		virtio_vsock_dgram_tx_done,
+		virtio_vsock_event_done,
+	};
+
 	static const char * const names[] = {
 		"rx",
 		"tx",
 		"event",
 	};
+	static const char * const ex_names[] = {
+		"rx",
+		"tx",
+		"dgram_rx",
+		"dgram_tx",
+		"event",
+	};
+
 	struct virtio_vsock *vsock = NULL;
-	int ret;
+	int ret, max_vq;
 
 	ret = mutex_lock_interruptible(&the_virtio_vsock_mutex);
 	if (ret)
@@ -572,9 +609,30 @@ static int virtio_vsock_probe(struct virtio_device *vdev)
 
 	vsock->vdev = vdev;
 
-	ret = virtio_find_vqs(vsock->vdev, VSOCK_VQ_MAX,
+	if (virtio_has_feature(vdev, VIRTIO_VSOCK_F_DGRAM))
+		vsock->has_dgram = true;
+
+	if (vsock->has_dgram)
+		max_vq = VSOCK_VQ_EX_MAX;
+	else
+		max_vq = VSOCK_VQ_MAX;
+
+	vsock->vqs = kmalloc_array(max_vq, sizeof(struct virtqueue *), GFP_KERNEL);
+	if (!vsock->vqs) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (vsock->has_dgram) {
+		ret = virtio_find_vqs(vsock->vdev, max_vq,
+			      vsock->vqs, ex_callbacks, ex_names,
+			      NULL);
+	} else {
+		ret = virtio_find_vqs(vsock->vdev, max_vq,
 			      vsock->vqs, callbacks, names,
 			      NULL);
+	}
+
 	if (ret < 0)
 		goto out;
 
@@ -695,6 +753,7 @@ static struct virtio_device_id id_table[] = {
 };
 
 static unsigned int features[] = {
+	VIRTIO_VSOCK_F_DGRAM,
 };
 
 static struct virtio_driver virtio_vsock_driver = {
-- 
2.11.0


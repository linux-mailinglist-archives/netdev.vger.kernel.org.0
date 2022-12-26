Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251AC6560F2
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbiLZHum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiLZHuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:50:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794805FDD
        for <netdev@vger.kernel.org>; Sun, 25 Dec 2022 23:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1672040974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H/Y/p/qkj6rtja+GTIriOAzlecVLNXF/oN1BvsWBKKY=;
        b=g07FrQHuFKizmKBDHbtKSII5lRBSZWY/oaSQTCPKwDZaKYy3sOftsoG27E+EH1paIp/Be6
        2MD8T1Pv5Lir6o8aqUxrueo2rKjGKCxY532Wj09JyV3XHb7jNODO1DMopPcK5+6uVEWgC3
        ZvPUQ5j9o/cvQEdQmCQ1zhJyv9eorDE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-112-Cl6FKtC-O92R4jqHTvdGlQ-1; Mon, 26 Dec 2022 02:49:31 -0500
X-MC-Unique: Cl6FKtC-O92R4jqHTvdGlQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1DD1A101A521;
        Mon, 26 Dec 2022 07:49:31 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-100.pek2.redhat.com [10.72.13.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7642D492B00;
        Mon, 26 Dec 2022 07:49:26 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@redhat.com, alvaro.karsz@solid-run.com,
        eperezma@redhat.com
Subject: [PATCH 3/4] virtio_ring: introduce a per virtqueue waitqueue
Date:   Mon, 26 Dec 2022 15:49:07 +0800
Message-Id: <20221226074908.8154-4-jasowang@redhat.com>
In-Reply-To: <20221226074908.8154-1-jasowang@redhat.com>
References: <20221226074908.8154-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a per virtqueue waitqueue to allow driver to
sleep and wait for more used. Two new helpers are introduced to allow
driver to sleep and wake up.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes since V1:
- check virtqueue_is_broken() as well
- use more_used() instead of virtqueue_get_buf() to allow caller to
  get buffers afterwards
---
 drivers/virtio/virtio_ring.c | 29 +++++++++++++++++++++++++++++
 include/linux/virtio.h       |  3 +++
 2 files changed, 32 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5cfb2fa8abee..9c83eb945493 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -13,6 +13,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kmsan.h>
 #include <linux/spinlock.h>
+#include <linux/wait.h>
 #include <xen/xen.h>
 
 #ifdef DEBUG
@@ -60,6 +61,7 @@
 			"%s:"fmt, (_vq)->vq.name, ##args);	\
 		/* Pairs with READ_ONCE() in virtqueue_is_broken(). */ \
 		WRITE_ONCE((_vq)->broken, true);		       \
+		wake_up_interruptible(&(_vq)->wq);		       \
 	} while (0)
 #define START_USE(vq)
 #define END_USE(vq)
@@ -203,6 +205,9 @@ struct vring_virtqueue {
 	/* DMA, allocation, and size information */
 	bool we_own_ring;
 
+	/* Wait for buffer to be used */
+	wait_queue_head_t wq;
+
 #ifdef DEBUG
 	/* They're supposed to lock for us. */
 	unsigned int in_use;
@@ -2024,6 +2029,8 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
+	init_waitqueue_head(&vq->wq);
+
 	err = vring_alloc_state_extra_packed(&vring_packed);
 	if (err)
 		goto err_state_extra;
@@ -2517,6 +2524,8 @@ static struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	if (virtio_has_feature(vdev, VIRTIO_F_ORDER_PLATFORM))
 		vq->weak_barriers = false;
 
+	init_waitqueue_head(&vq->wq);
+
 	err = vring_alloc_state_extra_split(vring_split);
 	if (err) {
 		kfree(vq);
@@ -2654,6 +2663,8 @@ static void vring_free(struct virtqueue *_vq)
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
+	wake_up_interruptible(&vq->wq);
+
 	if (vq->we_own_ring) {
 		if (vq->packed_ring) {
 			vring_free_queue(vq->vq.vdev,
@@ -2863,4 +2874,22 @@ const struct vring *virtqueue_get_vring(struct virtqueue *vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_get_vring);
 
+int virtqueue_wait_for_used(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	/* TODO: Tweak the timeout. */
+	return wait_event_interruptible_timeout(vq->wq,
+	       virtqueue_is_broken(_vq) || more_used(vq), HZ);
+}
+EXPORT_SYMBOL_GPL(virtqueue_wait_for_used);
+
+void virtqueue_wake_up(struct virtqueue *_vq)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	wake_up_interruptible(&vq->wq);
+}
+EXPORT_SYMBOL_GPL(virtqueue_wake_up);
+
 MODULE_LICENSE("GPL");
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index dcab9c7e8784..2eb62c774895 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -72,6 +72,9 @@ void *virtqueue_get_buf(struct virtqueue *vq, unsigned int *len);
 void *virtqueue_get_buf_ctx(struct virtqueue *vq, unsigned int *len,
 			    void **ctx);
 
+int virtqueue_wait_for_used(struct virtqueue *vq);
+void virtqueue_wake_up(struct virtqueue *vq);
+
 void virtqueue_disable_cb(struct virtqueue *vq);
 
 bool virtqueue_enable_cb(struct virtqueue *vq);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A625D3202AD
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 02:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBTBpV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 20:45:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbhBTBpU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 20:45:20 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19EDC061786
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:40 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id m14so4724361pgr.9
        for <netdev@vger.kernel.org>; Fri, 19 Feb 2021 17:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=WIG7k9z1vYZ8VYEW1iHf41oncCu0hnEz4QoUdkTkx+k=;
        b=iOdUPSiGq7n29MCOOHxMTG1QabzuEc/lqzj/Bq9NwXdZSQ/AQXuxQXsVdt0PEK8oY1
         FMHwpzQZt2BaWX5LNaLqoLhiYhX6WTF8Q6HSRmqyTPqrcibCpnxBXZJPO3Om+AVqksPQ
         78c+tc41oe8zQwL9QebEdzCailLkpHUcyc0xPGbesjy3c7X3+6mlFdY9iYDSVS/etlxp
         pW/J7FbNrM5ksfeHnVwLJdmdpQsdAnhK+vSOLkqMXvls10j7KA+xBLPBFTBKb6kqYKiS
         Ay2Hf1VztZy4qohIbXZHjeqh8FRv6Yktq231qc6C8enW8pL8tcsoCA/RjoKWLx6iuYEE
         k0eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=WIG7k9z1vYZ8VYEW1iHf41oncCu0hnEz4QoUdkTkx+k=;
        b=ZnRmQSUZCQAyJ6Y3VfZyCiji0Kk7Lut2rxLLOh+YdOOmb0kndgQ8DzrOQEoqL28ic9
         g8Il0aWeXtLaO6mBDajXdsZPJJ51mLZGA5Qsa4N80h+f1DOUnkGTOZBMnOi240ACW6hV
         4fCh7uEYoPsapSw5wf18/VqZqvlhh8MzeCUp42KulKn8tYmBVUrnq9QqjbcZZZ8AOVsB
         dYwLhKpzXA1QbCp74e7BbfMga9TShOS+YbHtzGyhmXdTw/YHWebk3KGQxM/lL4BWx8dm
         Q5f2fdJY2CtPX2Sstgi6hNt+Q1D3DAewBpjhzOWpBjV1Fq7Bkgrk+d8q0WOcB+yKLxZK
         ZQLw==
X-Gm-Message-State: AOAM533xLEGEXgW6U0Bs89GT6hePXlGeBLaubj6zMGQwsP8yBf4jfC5o
        b0ebzWfcggNNuQFCp8LwdUkdv81CNYw=
X-Google-Smtp-Source: ABdhPJyDAEU9W4Gc9sSfgLaODM2M+WY2CPc4utQW/M5tVd3AL02DxfLtKhgJ8FcL2sMTozCAjtcqCTSGNO8=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:9433:f9ff:6bb7:ac32])
 (user=weiwan job=sendgmr) by 2002:aa7:94aa:0:b029:1eb:7783:69c5 with SMTP id
 a10-20020aa794aa0000b02901eb778369c5mr4546779pfl.60.1613785480039; Fri, 19
 Feb 2021 17:44:40 -0800 (PST)
Date:   Fri, 19 Feb 2021 17:44:35 -0800
In-Reply-To: <20210220014436.3556492-1-weiwan@google.com>
Message-Id: <20210220014436.3556492-2-weiwan@google.com>
Mime-Version: 1.0
References: <20210220014436.3556492-1-weiwan@google.com>
X-Mailer: git-send-email 2.30.0.617.g56c4b15f3c-goog
Subject: [PATCH net v2 1/2] virtio: add a new parameter in struct virtqueue
From:   Wei Wang <weiwan@google.com>
To:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Willem de Bruijn <willemb@google.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The new parameter is set to suppress the warning in the interrupt
handler when no work needs to be done.
This will be used for virtio net driver in the following patch.

Signed-off-by: Wei Wang <weiwan@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 drivers/virtio/virtio_ring.c | 16 ++++++++++++++++
 include/linux/virtio.h       |  2 ++
 2 files changed, 18 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 71e16b53e9c1..3c5ac1b26dff 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -105,6 +105,9 @@ struct vring_virtqueue {
 	/* Host publishes avail event idx */
 	bool event;
 
+	/* Suppress warning in interrupt handler */
+	bool no_interrupt_check;
+
 	/* Head of free buffer list. */
 	unsigned int free_head;
 	/* Number we've added since last sync. */
@@ -1604,6 +1607,7 @@ static struct virtqueue *vring_create_virtqueue_packed(
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
+	vq->no_interrupt_check = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	vq->packed_ring = true;
@@ -2037,6 +2041,9 @@ irqreturn_t vring_interrupt(int irq, void *_vq)
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
 	if (!more_used(vq)) {
+		if (vq->no_interrupt_check)
+			return IRQ_HANDLED;
+
 		pr_debug("virtqueue interrupt with no work for %p\n", vq);
 		return IRQ_NONE;
 	}
@@ -2082,6 +2089,7 @@ struct virtqueue *__vring_new_virtqueue(unsigned int index,
 	vq->notify = notify;
 	vq->weak_barriers = weak_barriers;
 	vq->broken = false;
+	vq->no_interrupt_check = false;
 	vq->last_used_idx = 0;
 	vq->num_added = 0;
 	vq->use_dma_api = vring_use_dma_api(vdev);
@@ -2266,6 +2274,14 @@ bool virtqueue_is_broken(struct virtqueue *_vq)
 }
 EXPORT_SYMBOL_GPL(virtqueue_is_broken);
 
+void virtqueue_set_no_interrupt_check(struct virtqueue *_vq, bool val)
+{
+	struct vring_virtqueue *vq = to_vvq(_vq);
+
+	vq->no_interrupt_check = val;
+}
+EXPORT_SYMBOL_GPL(virtqueue_set_no_interrupt_check);
+
 /*
  * This should prevent the device from being used, allowing drivers to
  * recover.  You may need to grab appropriate locks to flush.
diff --git a/include/linux/virtio.h b/include/linux/virtio.h
index 55ea329fe72a..27b374df78cc 100644
--- a/include/linux/virtio.h
+++ b/include/linux/virtio.h
@@ -84,6 +84,8 @@ unsigned int virtqueue_get_vring_size(struct virtqueue *vq);
 
 bool virtqueue_is_broken(struct virtqueue *vq);
 
+void virtqueue_set_no_interrupt_check(struct virtqueue *vq, bool val);
+
 const struct vring *virtqueue_get_vring(struct virtqueue *vq);
 dma_addr_t virtqueue_get_desc_addr(struct virtqueue *vq);
 dma_addr_t virtqueue_get_avail_addr(struct virtqueue *vq);
-- 
2.30.0.617.g56c4b15f3c-goog


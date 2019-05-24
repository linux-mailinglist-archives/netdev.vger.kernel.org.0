Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7813292A4
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 10:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389404AbfEXIND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 04:13:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33756 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389254AbfEXINC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 04:13:02 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id ED9AC9B424;
        Fri, 24 May 2019 08:13:01 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30D2719C4F;
        Fri, 24 May 2019 08:12:56 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, peterx@redhat.com,
        James.Bottomley@hansenpartnership.com, hch@infradead.org,
        davem@davemloft.net, jglisse@redhat.com, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
        christophe.de.dinechin@gmail.com, jrdr.linux@gmail.com
Subject: [PATCH net-next 4/6] vhost: introduce helpers to get the size of metadata area
Date:   Fri, 24 May 2019 04:12:16 -0400
Message-Id: <20190524081218.2502-5-jasowang@redhat.com>
In-Reply-To: <20190524081218.2502-1-jasowang@redhat.com>
References: <20190524081218.2502-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Fri, 24 May 2019 08:13:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To avoid code duplication since it will be used by kernel VA prefetching.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 51 ++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index b353a00094aa..8605e44a7001 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -413,6 +413,32 @@ static void vhost_dev_free_iovecs(struct vhost_dev *dev)
 		vhost_vq_free_iovecs(dev->vqs[i]);
 }
 
+static size_t vhost_get_avail_size(struct vhost_virtqueue *vq,
+				   unsigned int num)
+{
+	size_t event __maybe_unused =
+	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
+
+	return sizeof(*vq->avail) +
+	       sizeof(*vq->avail->ring) * num + event;
+}
+
+static size_t vhost_get_used_size(struct vhost_virtqueue *vq,
+				  unsigned int num)
+{
+	size_t event __maybe_unused =
+	       vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
+
+	return sizeof(*vq->used) +
+	       sizeof(*vq->used->ring) * num + event;
+}
+
+static size_t vhost_get_desc_size(struct vhost_virtqueue *vq,
+				  unsigned int num)
+{
+	return sizeof(*vq->desc) * num;
+}
+
 void vhost_dev_init(struct vhost_dev *dev,
 		    struct vhost_virtqueue **vqs, int nvqs, int iov_limit)
 {
@@ -1257,13 +1283,9 @@ static bool vq_access_ok(struct vhost_virtqueue *vq, unsigned int num,
 			 struct vring_used __user *used)
 
 {
-	size_t s __maybe_unused = vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
-
-	return access_ok(desc, num * sizeof *desc) &&
-	       access_ok(avail,
-			 sizeof *avail + num * sizeof *avail->ring + s) &&
-	       access_ok(used,
-			sizeof *used + num * sizeof *used->ring + s);
+	return access_ok(desc, vhost_get_desc_size(vq, num)) &&
+	       access_ok(avail, vhost_get_avail_size(vq, num)) &&
+	       access_ok(used, vhost_get_used_size(vq, num));
 }
 
 static void vhost_vq_meta_update(struct vhost_virtqueue *vq,
@@ -1315,22 +1337,18 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
 
 int vq_meta_prefetch(struct vhost_virtqueue *vq)
 {
-	size_t s = vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
 	unsigned int num = vq->num;
 
 	if (!vq->iotlb)
 		return 1;
 
 	return iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->desc,
-			       num * sizeof(*vq->desc), VHOST_ADDR_DESC) &&
+			       vhost_get_desc_size(vq, num), VHOST_ADDR_DESC) &&
 	       iotlb_access_ok(vq, VHOST_ACCESS_RO, (u64)(uintptr_t)vq->avail,
-			       sizeof *vq->avail +
-			       num * sizeof(*vq->avail->ring) + s,
+			       vhost_get_avail_size(vq, num),
 			       VHOST_ADDR_AVAIL) &&
 	       iotlb_access_ok(vq, VHOST_ACCESS_WO, (u64)(uintptr_t)vq->used,
-			       sizeof *vq->used +
-			       num * sizeof(*vq->used->ring) + s,
-			       VHOST_ADDR_USED);
+			       vhost_get_used_size(vq, num), VHOST_ADDR_USED);
 }
 EXPORT_SYMBOL_GPL(vq_meta_prefetch);
 
@@ -1347,13 +1365,10 @@ EXPORT_SYMBOL_GPL(vhost_log_access_ok);
 static bool vq_log_access_ok(struct vhost_virtqueue *vq,
 			     void __user *log_base)
 {
-	size_t s = vhost_has_feature(vq, VIRTIO_RING_F_EVENT_IDX) ? 2 : 0;
-
 	return vq_memory_access_ok(log_base, vq->umem,
 				   vhost_has_feature(vq, VHOST_F_LOG_ALL)) &&
 		(!vq->log_used || log_access_ok(log_base, vq->log_addr,
-					sizeof *vq->used +
-					vq->num * sizeof *vq->used->ring + s));
+				  vhost_get_used_size(vq, vq->num)));
 }
 
 /* Can we start vq? */
-- 
2.18.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6F66BA93
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 12:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfGQKxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 06:53:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37400 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbfGQKxK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 06:53:10 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E4B0E5AFE9;
        Wed, 17 Jul 2019 10:53:09 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010751001DDE;
        Wed, 17 Jul 2019 10:53:06 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jfreimann@redhat.com, tiwei.bie@intel.com,
        maxime.coquelin@redhat.com
Subject: [PATCH V3 01/15] vhost: simplify meta data pointer accessing
Date:   Wed, 17 Jul 2019 06:52:41 -0400
Message-Id: <20190717105255.63488-2-jasowang@redhat.com>
In-Reply-To: <20190717105255.63488-1-jasowang@redhat.com>
References: <20190717105255.63488-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 17 Jul 2019 10:53:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of open coding meta pointer accessing through caches. This
patch introduces vhost_get_meta_ptr()/vhost_put_meta_ptr() pair to
reduce the code duplication and simplify its callers
implementation. This is helpful for reducing LOC for packed virtqueue
as well.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 207 ++++++++++++++----------------------------
 1 file changed, 70 insertions(+), 137 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index dc9301d31f12..7f51c74d9aee 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1194,25 +1194,37 @@ static inline void __user *__vhost_get_user(struct vhost_virtqueue *vq,
 	ret; \
 })
 
-static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
-{
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
+static void *vhost_get_meta_ptr(struct vhost_virtqueue *vq, int type)
+{
 	struct vhost_map *map;
-	struct vring_used *used;
 
 	if (!vq->iotlb) {
 		rcu_read_lock();
+		map = rcu_dereference(vq->maps[type]);
+		if (likely(map))
+			return map->addr;
+		rcu_read_unlock();
+	}
+	return NULL;
+}
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
-		if (likely(map)) {
-			used = map->addr;
-			*((__virtio16 *)&used->ring[vq->num]) =
-				cpu_to_vhost16(vq, vq->avail_idx);
-			rcu_read_unlock();
-			return 0;
-		}
+static void vhost_put_meta_ptr(void)
+{
+	rcu_read_unlock();
+}
+#endif
 
-		rcu_read_unlock();
+static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
+{
+#if VHOST_ARCH_CAN_ACCEL_UACCESS
+	struct vring_used *used = vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
+
+	if (likely(used)) {
+		*((__virtio16 *)&used->ring[vq->num]) =
+			cpu_to_vhost16(vq, vq->avail_idx);
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1225,23 +1237,14 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
 				 int count)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_used *used;
+	struct vring_used *used = vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
 	size_t size;
 
-	if (!vq->iotlb) {
-		rcu_read_lock();
-
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
-		if (likely(map)) {
-			used = map->addr;
-			size = count * sizeof(*head);
-			memcpy(used->ring + idx, head, size);
-			rcu_read_unlock();
-			return 0;
-		}
-
-		rcu_read_unlock();
+	if (likely(used)) {
+		size = count * sizeof(*head);
+		memcpy(used->ring + idx, head, size);
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1253,21 +1256,12 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_used *used;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
+	struct vring_used *used = vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
-		if (likely(map)) {
-			used = map->addr;
-			used->flags = cpu_to_vhost16(vq, vq->used_flags);
-			rcu_read_unlock();
-			return 0;
-		}
-
-		rcu_read_unlock();
+	if (likely(used)) {
+		used->flags = cpu_to_vhost16(vq, vq->used_flags);
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1279,21 +1273,12 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_used *used;
+	struct vring_used *used = vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
 
-	if (!vq->iotlb) {
-		rcu_read_lock();
-
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
-		if (likely(map)) {
-			used = map->addr;
-			used->idx = cpu_to_vhost16(vq, vq->last_used_idx);
-			rcu_read_unlock();
-			return 0;
-		}
-
-		rcu_read_unlock();
+	if (likely(used)) {
+		used->idx = cpu_to_vhost16(vq, vq->last_used_idx);
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1343,21 +1328,12 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
 				      __virtio16 *idx)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_avail *avail;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
+	struct vring_avail *avail = vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
-		if (likely(map)) {
-			avail = map->addr;
-			*idx = avail->idx;
-			rcu_read_unlock();
-			return 0;
-		}
-
-		rcu_read_unlock();
+	if (likely(avail)) {
+		*idx = avail->idx;
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1368,21 +1344,12 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
 				       __virtio16 *head, int idx)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_avail *avail;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
-
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
-		if (likely(map)) {
-			avail = map->addr;
-			*head = avail->ring[idx & (vq->num - 1)];
-			rcu_read_unlock();
-			return 0;
-		}
+	struct vring_avail *avail = vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
 
-		rcu_read_unlock();
+	if (likely(avail)) {
+		*head = avail->ring[idx & (vq->num - 1)];
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1394,21 +1361,12 @@ static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
 					__virtio16 *flags)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_avail *avail;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
+	struct vring_avail *avail = vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
-		if (likely(map)) {
-			avail = map->addr;
-			*flags = avail->flags;
-			rcu_read_unlock();
-			return 0;
-		}
-
-		rcu_read_unlock();
+	if (likely(avail)) {
+		*flags = avail->flags;
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1419,19 +1377,12 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
 				       __virtio16 *event)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_avail *avail;
+	struct vring_avail *avail = vhost_get_meta_ptr(vq, VHOST_ADDR_AVAIL);
 
-	if (!vq->iotlb) {
-		rcu_read_lock();
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
-		if (likely(map)) {
-			avail = map->addr;
-			*event = (__virtio16)avail->ring[vq->num];
-			rcu_read_unlock();
-			return 0;
-		}
-		rcu_read_unlock();
+	if (likely(avail)) {
+		*event = (__virtio16)avail->ring[vq->num];
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1442,21 +1393,12 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
 				     __virtio16 *idx)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_used *used;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
-
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
-		if (likely(map)) {
-			used = map->addr;
-			*idx = used->idx;
-			rcu_read_unlock();
-			return 0;
-		}
+	struct vring_used *used = vhost_get_meta_ptr(vq, VHOST_ADDR_USED);
 
-		rcu_read_unlock();
+	if (likely(used)) {
+		*idx = used->idx;
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
@@ -1467,21 +1409,12 @@ static inline int vhost_get_desc(struct vhost_virtqueue *vq,
 				 struct vring_desc *desc, int idx)
 {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-	struct vhost_map *map;
-	struct vring_desc *d;
-
-	if (!vq->iotlb) {
-		rcu_read_lock();
-
-		map = rcu_dereference(vq->maps[VHOST_ADDR_DESC]);
-		if (likely(map)) {
-			d = map->addr;
-			*desc = *(d + idx);
-			rcu_read_unlock();
-			return 0;
-		}
+	struct vring_desc *d = vhost_get_meta_ptr(vq, VHOST_ADDR_DESC);
 
-		rcu_read_unlock();
+	if (likely(d)) {
+		*desc = *(d + idx);
+		vhost_put_meta_ptr();
+		return 0;
 	}
 #endif
 
-- 
2.18.1


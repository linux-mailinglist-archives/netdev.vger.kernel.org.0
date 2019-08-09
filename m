Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31325871CA
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405605AbfHIFta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:49:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48762 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405700AbfHIFt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 01:49:28 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CA7768E237;
        Fri,  9 Aug 2019 05:49:27 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 975E95D9CC;
        Fri,  9 Aug 2019 05:49:23 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, jgg@ziepe.ca, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V5 7/9] vhost: do not use RCU to synchronize MMU notifier with worker
Date:   Fri,  9 Aug 2019 01:48:49 -0400
Message-Id: <20190809054851.20118-8-jasowang@redhat.com>
In-Reply-To: <20190809054851.20118-1-jasowang@redhat.com>
References: <20190809054851.20118-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 09 Aug 2019 05:49:28 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to use RCU to synchronize MMU notifier with worker. This leads
calling synchronize_rcu() in invalidate_range_start(). But on a busy
system, there would be many factors that may slow down the
synchronize_rcu() which makes it unsuitable to be called in MMU
notifier. This path switch to use a simple spinlock to do the
synchronization.

Benchmark was done through testpmd + vhost_net + XDP_DROP on
tap. Compare to copy_{to|from}_user() path, on Sandy Bridge (without
SMAP support), 1.5% PPS improvement was measured; on Broadwell (with
SMAP and enabled), 14% PPS improvement was measured.

This means we are not as fast as what 7f466032dc9e did because the
spinlock overhead in the datapath. This needs to be addressed in the
future.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 115 ++++++++++++++++++++++--------------------
 drivers/vhost/vhost.h |   5 +-
 2 files changed, 62 insertions(+), 58 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cfc11f9ed9c9..29e8abe694f7 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -324,17 +324,16 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
 
 	spin_lock(&vq->mmu_lock);
 	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
-		map[i] = rcu_dereference_protected(vq->maps[i],
-				  lockdep_is_held(&vq->mmu_lock));
+		map[i] = vq->maps[i];
 		if (map[i]) {
 			vhost_set_map_dirty(vq, map[i], i);
-			rcu_assign_pointer(vq->maps[i], NULL);
+			vq->maps[i] = NULL;
 		}
 	}
 	spin_unlock(&vq->mmu_lock);
 
-	/* No need for synchronize_rcu() or kfree_rcu() since we are
-	 * serialized with memory accessors (e.g vq mutex held).
+	/* No need for synchronization since we are serialized with
+	 * memory accessors (e.g vq mutex held).
 	 */
 
 	for (i = 0; i < VHOST_NUM_ADDRS; i++)
@@ -362,6 +361,16 @@ static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
 	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
 }
 
+static void inline vhost_vq_access_map_begin(struct vhost_virtqueue *vq)
+{
+	spin_lock(&vq->mmu_lock);
+}
+
+static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
+{
+	spin_unlock(&vq->mmu_lock);
+}
+
 static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 				      int index,
 				      unsigned long start,
@@ -376,16 +385,14 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 	spin_lock(&vq->mmu_lock);
 	++vq->invalidate_count;
 
-	map = rcu_dereference_protected(vq->maps[index],
-					lockdep_is_held(&vq->mmu_lock));
+	map = vq->maps[index];
 	if (map) {
+		vq->maps[index] = NULL;
 		vhost_set_map_dirty(vq, map, index);
-		rcu_assign_pointer(vq->maps[index], NULL);
 	}
 	spin_unlock(&vq->mmu_lock);
 
 	if (map) {
-		synchronize_rcu();
 		vhost_map_unprefetch(map);
 	}
 }
@@ -457,7 +464,7 @@ static void vhost_init_maps(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		for (j = 0; j < VHOST_NUM_ADDRS; j++)
-			RCU_INIT_POINTER(vq->maps[j], NULL);
+			vq->maps[j] = NULL;
 	}
 }
 #endif
@@ -921,7 +928,7 @@ static int vhost_map_prefetch(struct vhost_virtqueue *vq,
 	map->npages = npages;
 	map->pages = pages;
 
-	rcu_assign_pointer(vq->maps[index], map);
+	vq->maps[index] = map;
 	/* No need for a synchronize_rcu(). This function should be
 	 * called by dev->worker so we are serialized with all
 	 * readers.
@@ -1216,18 +1223,18 @@ static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
 	struct vring_used *used;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
+		map = vq->maps[VHOST_ADDR_USED];
 		if (likely(map)) {
 			used = map->addr;
 			*((__virtio16 *)&used->ring[vq->num]) =
 				cpu_to_vhost16(vq, vq->avail_idx);
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1245,18 +1252,18 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
 	size_t size;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
+		map = vq->maps[VHOST_ADDR_USED];
 		if (likely(map)) {
 			used = map->addr;
 			size = count * sizeof(*head);
 			memcpy(used->ring + idx, head, size);
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1272,17 +1279,17 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
 	struct vring_used *used;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
+		map = vq->maps[VHOST_ADDR_USED];
 		if (likely(map)) {
 			used = map->addr;
 			used->flags = cpu_to_vhost16(vq, vq->used_flags);
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1298,17 +1305,17 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
 	struct vring_used *used;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
+		map = vq->maps[VHOST_ADDR_USED];
 		if (likely(map)) {
 			used = map->addr;
 			used->idx = cpu_to_vhost16(vq, vq->last_used_idx);
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1362,17 +1369,17 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
 	struct vring_avail *avail;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
+		map = vq->maps[VHOST_ADDR_AVAIL];
 		if (likely(map)) {
 			avail = map->addr;
 			*idx = avail->idx;
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1387,17 +1394,17 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
 	struct vring_avail *avail;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
+		map = vq->maps[VHOST_ADDR_AVAIL];
 		if (likely(map)) {
 			avail = map->addr;
 			*head = avail->ring[idx & (vq->num - 1)];
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1413,17 +1420,17 @@ static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
 	struct vring_avail *avail;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
+		map = vq->maps[VHOST_ADDR_AVAIL];
 		if (likely(map)) {
 			avail = map->addr;
 			*flags = avail->flags;
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1438,15 +1445,15 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
 	struct vring_avail *avail;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
-		map = rcu_dereference(vq->maps[VHOST_ADDR_AVAIL]);
+		vhost_vq_access_map_begin(vq);
+		map = vq->maps[VHOST_ADDR_AVAIL];
 		if (likely(map)) {
 			avail = map->addr;
 			*event = (__virtio16)avail->ring[vq->num];
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1461,17 +1468,17 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
 	struct vring_used *used;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_USED]);
+		map = vq->maps[VHOST_ADDR_USED];
 		if (likely(map)) {
 			used = map->addr;
 			*idx = used->idx;
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1486,17 +1493,17 @@ static inline int vhost_get_desc(struct vhost_virtqueue *vq,
 	struct vring_desc *d;
 
 	if (!vq->iotlb) {
-		rcu_read_lock();
+		vhost_vq_access_map_begin(vq);
 
-		map = rcu_dereference(vq->maps[VHOST_ADDR_DESC]);
+		map = vq->maps[VHOST_ADDR_DESC];
 		if (likely(map)) {
 			d = map->addr;
 			*desc = *(d + idx);
-			rcu_read_unlock();
+			vhost_vq_access_map_end(vq);
 			return 0;
 		}
 
-		rcu_read_unlock();
+		vhost_vq_access_map_end(vq);
 	}
 #endif
 
@@ -1843,13 +1850,11 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
 static void vhost_vq_map_prefetch(struct vhost_virtqueue *vq)
 {
-	struct vhost_map __rcu *map;
+	struct vhost_map *map;
 	int i;
 
 	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
-		rcu_read_lock();
-		map = rcu_dereference(vq->maps[i]);
-		rcu_read_unlock();
+		map = vq->maps[i];
 		if (unlikely(!map))
 			vhost_map_prefetch(vq, i);
 	}
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index a9a2a93857d2..983d06e62f12 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -115,10 +115,9 @@ struct vhost_virtqueue {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
 	/* Read by memory accessors, modified by meta data
 	 * prefetching, MMU notifier and vring ioctl().
-	 * Synchonrized through mmu_lock (writers) and RCU (writers
-	 * and readers).
+	 * Synchonrized through mmu_lock.
 	 */
-	struct vhost_map __rcu *maps[VHOST_NUM_ADDRS];
+	struct vhost_map *maps[VHOST_NUM_ADDRS];
 	/* Read by MMU notifier, modified by vring ioctl(),
 	 * synchronized through MMU notifier
 	 * registering/unregistering.
-- 
2.18.1


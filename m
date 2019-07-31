Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729D47BC29
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfGaIrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:47:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46332 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbfGaIro (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 04:47:44 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 73C3D356D2;
        Wed, 31 Jul 2019 08:47:43 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBDB600D1;
        Wed, 31 Jul 2019 08:47:36 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
Subject: [PATCH V2 7/9] vhost: do not use RCU to synchronize MMU notifier with worker
Date:   Wed, 31 Jul 2019 04:46:53 -0400
Message-Id: <20190731084655.7024-8-jasowang@redhat.com>
In-Reply-To: <20190731084655.7024-1-jasowang@redhat.com>
References: <20190731084655.7024-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 31 Jul 2019 08:47:43 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We used to use RCU to synchronize MMU notifier with worker. This leads
calling synchronize_rcu() in invalidate_range_start(). But on a busy
system, there would be many factors that may slow down the
synchronize_rcu() which makes it unsuitable to be called in MMU
notifier.

A solution is SRCU but its overhead is obvious with the expensive full
memory barrier. Another choice is to use seqlock, but it doesn't
provide a synchronization method between readers and writers. The last
choice is to use vq mutex, but it need to deal with the worst case
that MMU notifier must be blocked and wait for the finish of swap in.

So this patch switches use a counter to track whether or not the map
was used. The counter was increased when vq try to start or finish
uses the map. This means, when it was even, we're sure there's no
readers and MMU notifier is synchronized. When it was odd, it means
there's a reader we need to wait it to be even again then we are
synchronized. To avoid full memory barrier, store_release +
load_acquire on the counter is used.

Consider the read critical section is pretty small the synchronization
should be done very fast.

Note the patch lead about 3% PPS dropping.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 145 ++++++++++++++++++++++++++----------------
 drivers/vhost/vhost.h |   7 +-
 2 files changed, 94 insertions(+), 58 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index cfc11f9ed9c9..db2c81cb1e90 100644
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
@@ -362,6 +361,44 @@ static bool vhost_map_range_overlap(struct vhost_uaddr *uaddr,
 	return !(end < uaddr->uaddr || start > uaddr->uaddr - 1 + uaddr->size);
 }
 
+static void inline vhost_vq_access_map_begin(struct vhost_virtqueue *vq)
+{
+	int ref = READ_ONCE(vq->ref);
+
+	smp_store_release(&vq->ref, ref + 1);
+	/* Make sure ref counter is visible before accessing the map */
+	smp_load_acquire(&vq->ref);
+}
+
+static void inline vhost_vq_access_map_end(struct vhost_virtqueue *vq)
+{
+	int ref = READ_ONCE(vq->ref);
+
+	/* Make sure vq access is done before increasing ref counter */
+	smp_store_release(&vq->ref, ref + 1);
+}
+
+static void inline vhost_vq_sync_access(struct vhost_virtqueue *vq)
+{
+	int ref;
+
+	/* Make sure map change was done before checking ref counter */
+	smp_mb();
+
+	ref = READ_ONCE(vq->ref);
+	if (ref & 0x1) {
+		/* When ref change, we are sure no reader can see
+		 * previous map */
+		while (READ_ONCE(vq->ref) == ref) {
+			set_current_state(TASK_RUNNING);
+			schedule();
+		}
+	}
+	/* Make sure ref counter was checked before any other
+	 * operations that was dene on map. */
+	smp_mb();
+}
+
 static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 				      int index,
 				      unsigned long start,
@@ -376,16 +413,15 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 	spin_lock(&vq->mmu_lock);
 	++vq->invalidate_count;
 
-	map = rcu_dereference_protected(vq->maps[index],
-					lockdep_is_held(&vq->mmu_lock));
+	map = vq->maps[index];
 	if (map) {
 		vhost_set_map_dirty(vq, map, index);
-		rcu_assign_pointer(vq->maps[index], NULL);
+		vq->maps[index] = NULL;
 	}
 	spin_unlock(&vq->mmu_lock);
 
 	if (map) {
-		synchronize_rcu();
+		vhost_vq_sync_access(vq);
 		vhost_map_unprefetch(map);
 	}
 }
@@ -457,7 +493,7 @@ static void vhost_init_maps(struct vhost_dev *dev)
 	for (i = 0; i < dev->nvqs; ++i) {
 		vq = dev->vqs[i];
 		for (j = 0; j < VHOST_NUM_ADDRS; j++)
-			RCU_INIT_POINTER(vq->maps[j], NULL);
+			vq->maps[j] = NULL;
 	}
 }
 #endif
@@ -655,6 +691,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 		vq->indirect = NULL;
 		vq->heads = NULL;
 		vq->dev = dev;
+		vq->ref = 0;
 		mutex_init(&vq->mutex);
 		spin_lock_init(&vq->mmu_lock);
 		vhost_vq_reset(dev, vq);
@@ -921,7 +958,7 @@ static int vhost_map_prefetch(struct vhost_virtqueue *vq,
 	map->npages = npages;
 	map->pages = pages;
 
-	rcu_assign_pointer(vq->maps[index], map);
+	vq->maps[index] = map;
 	/* No need for a synchronize_rcu(). This function should be
 	 * called by dev->worker so we are serialized with all
 	 * readers.
@@ -1216,18 +1253,18 @@ static inline int vhost_put_avail_event(struct vhost_virtqueue *vq)
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
 
@@ -1245,18 +1282,18 @@ static inline int vhost_put_used(struct vhost_virtqueue *vq,
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
 
@@ -1272,17 +1309,17 @@ static inline int vhost_put_used_flags(struct vhost_virtqueue *vq)
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
 
@@ -1298,17 +1335,17 @@ static inline int vhost_put_used_idx(struct vhost_virtqueue *vq)
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
 
@@ -1362,17 +1399,17 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq,
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
 
@@ -1387,17 +1424,17 @@ static inline int vhost_get_avail_head(struct vhost_virtqueue *vq,
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
 
@@ -1413,17 +1450,17 @@ static inline int vhost_get_avail_flags(struct vhost_virtqueue *vq,
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
 
@@ -1438,15 +1475,15 @@ static inline int vhost_get_used_event(struct vhost_virtqueue *vq,
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
 
@@ -1461,17 +1498,17 @@ static inline int vhost_get_used_idx(struct vhost_virtqueue *vq,
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
 
@@ -1486,17 +1523,17 @@ static inline int vhost_get_desc(struct vhost_virtqueue *vq,
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
 
@@ -1843,13 +1880,11 @@ static bool iotlb_access_ok(struct vhost_virtqueue *vq,
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
index a9a2a93857d2..f9e9558a529d 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -115,16 +115,17 @@ struct vhost_virtqueue {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
 	/* Read by memory accessors, modified by meta data
 	 * prefetching, MMU notifier and vring ioctl().
-	 * Synchonrized through mmu_lock (writers) and RCU (writers
-	 * and readers).
+	 * Synchonrized through mmu_lock (writers) and ref counters,
+	 * see vhost_vq_access_map_begin()/vhost_vq_access_map_end().
 	 */
-	struct vhost_map __rcu *maps[VHOST_NUM_ADDRS];
+	struct vhost_map *maps[VHOST_NUM_ADDRS];
 	/* Read by MMU notifier, modified by vring ioctl(),
 	 * synchronized through MMU notifier
 	 * registering/unregistering.
 	 */
 	struct vhost_uaddr uaddrs[VHOST_NUM_ADDRS];
 #endif
+	int ref;
 	const struct vhost_umem_node *meta_iotlb[VHOST_NUM_ADDRS];
 
 	struct file *kick;
-- 
2.18.1


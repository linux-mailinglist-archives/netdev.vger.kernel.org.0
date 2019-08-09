Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 612E8871C1
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405709AbfHIFtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:49:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405700AbfHIFtQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 01:49:16 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E6EBA30BA080;
        Fri,  9 Aug 2019 05:49:15 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BE455D9CC;
        Fri,  9 Aug 2019 05:49:13 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     linux-mm@kvack.org, jgg@ziepe.ca, Jason Wang <jasowang@redhat.com>
Subject: [PATCH V5 5/9] vhost: mark dirty pages during map uninit
Date:   Fri,  9 Aug 2019 01:48:47 -0400
Message-Id: <20190809054851.20118-6-jasowang@redhat.com>
In-Reply-To: <20190809054851.20118-1-jasowang@redhat.com>
References: <20190809054851.20118-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 09 Aug 2019 05:49:16 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't mark dirty pages if the map was teared down outside MMU
notifier. This will lead untracked dirty pages. Fixing by marking
dirty pages during map uninit.

Reported-by: Michael S. Tsirkin <mst@redhat.com>
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 2a7217c33668..c12cdadb0855 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -305,6 +305,18 @@ static void vhost_map_unprefetch(struct vhost_map *map)
 	kfree(map);
 }
 
+static void vhost_set_map_dirty(struct vhost_virtqueue *vq,
+				struct vhost_map *map, int index)
+{
+	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
+	int i;
+
+	if (uaddr->write) {
+		for (i = 0; i < map->npages; i++)
+			set_page_dirty(map->pages[i]);
+	}
+}
+
 static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
 {
 	struct vhost_map *map[VHOST_NUM_ADDRS];
@@ -314,8 +326,10 @@ static void vhost_uninit_vq_maps(struct vhost_virtqueue *vq)
 	for (i = 0; i < VHOST_NUM_ADDRS; i++) {
 		map[i] = rcu_dereference_protected(vq->maps[i],
 				  lockdep_is_held(&vq->mmu_lock));
-		if (map[i])
+		if (map[i]) {
+			vhost_set_map_dirty(vq, map[i], i);
 			rcu_assign_pointer(vq->maps[i], NULL);
+		}
 	}
 	spin_unlock(&vq->mmu_lock);
 
@@ -353,7 +367,6 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 {
 	struct vhost_uaddr *uaddr = &vq->uaddrs[index];
 	struct vhost_map *map;
-	int i;
 
 	if (!vhost_map_range_overlap(uaddr, start, end))
 		return;
@@ -364,10 +377,7 @@ static void vhost_invalidate_vq_start(struct vhost_virtqueue *vq,
 	map = rcu_dereference_protected(vq->maps[index],
 					lockdep_is_held(&vq->mmu_lock));
 	if (map) {
-		if (uaddr->write) {
-			for (i = 0; i < map->npages; i++)
-				set_page_dirty(map->pages[i]);
-		}
+		vhost_set_map_dirty(vq, map, index);
 		rcu_assign_pointer(vq->maps[index], NULL);
 	}
 	spin_unlock(&vq->mmu_lock);
-- 
2.18.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DB77BC15
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 10:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfGaIrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 04:47:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54480 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727582AbfGaIrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 04:47:09 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2870D307CDFC;
        Wed, 31 Jul 2019 08:47:09 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A39C600CC;
        Wed, 31 Jul 2019 08:47:06 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org, jgg@ziepe.ca
Subject: [PATCH V2 2/9] vhost: validate MMU notifier registration
Date:   Wed, 31 Jul 2019 04:46:48 -0400
Message-Id: <20190731084655.7024-3-jasowang@redhat.com>
In-Reply-To: <20190731084655.7024-1-jasowang@redhat.com>
References: <20190731084655.7024-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 31 Jul 2019 08:47:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of mmu_notifier_register() is not checked in
vhost_vring_set_num_addr(). This will cause an out of sync between mm
and MMU notifier thus a double free. To solve this, introduce a
boolean flag to track whether MMU notifier is registered and only do
unregistering when it was true.

Reported-and-tested-by:
syzbot+e58112d71f77113ddb7b@syzkaller.appspotmail.com
Fixes: 7f466032dc9e ("vhost: access vq metadata through kernel virtual address")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/vhost.c | 19 +++++++++++++++----
 drivers/vhost/vhost.h |  1 +
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 488380a581dc..17f6abea192e 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -629,6 +629,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
+	dev->has_notifier = false;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
@@ -730,6 +731,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	if (err)
 		goto err_mmu_notifier;
 #endif
+	dev->has_notifier = true;
 
 	return 0;
 
@@ -959,7 +961,11 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
 	}
 	if (dev->mm) {
 #if VHOST_ARCH_CAN_ACCEL_UACCESS
-		mmu_notifier_unregister(&dev->mmu_notifier, dev->mm);
+		if (dev->has_notifier) {
+			mmu_notifier_unregister(&dev->mmu_notifier,
+						dev->mm);
+			dev->has_notifier = false;
+		}
 #endif
 		mmput(dev->mm);
 	}
@@ -2064,8 +2070,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 	/* Unregister MMU notifer to allow invalidation callback
 	 * can access vq->uaddrs[] without holding a lock.
 	 */
-	if (d->mm)
+	if (d->has_notifier) {
 		mmu_notifier_unregister(&d->mmu_notifier, d->mm);
+		d->has_notifier = false;
+	}
 
 	vhost_uninit_vq_maps(vq);
 #endif
@@ -2085,8 +2093,11 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
 	if (r == 0)
 		vhost_setup_vq_uaddr(vq);
 
-	if (d->mm)
-		mmu_notifier_register(&d->mmu_notifier, d->mm);
+	if (d->mm) {
+		r = mmu_notifier_register(&d->mmu_notifier, d->mm);
+		if (!r)
+			d->has_notifier = true;
+	}
 #endif
 
 	mutex_unlock(&vq->mutex);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 42a8c2a13ab1..a9a2a93857d2 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -214,6 +214,7 @@ struct vhost_dev {
 	int iov_limit;
 	int weight;
 	int byte_weight;
+	bool has_notifier;
 };
 
 bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
-- 
2.18.1


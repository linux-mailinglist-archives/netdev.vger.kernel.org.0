Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 880E77136C
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 09:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388650AbfGWH5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 03:57:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388605AbfGWH5h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jul 2019 03:57:37 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 32F693082E51;
        Tue, 23 Jul 2019 07:57:37 +0000 (UTC)
Received: from hp-dl380pg8-01.lab.eng.pek2.redhat.com (hp-dl380pg8-01.lab.eng.pek2.redhat.com [10.73.8.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3256C60605;
        Tue, 23 Jul 2019 07:57:30 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] vhost: validate MMU notifier registration
Date:   Tue, 23 Jul 2019 03:57:14 -0400
Message-Id: <20190723075718.6275-3-jasowang@redhat.com>
In-Reply-To: <20190723075718.6275-1-jasowang@redhat.com>
References: <20190723075718.6275-1-jasowang@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 23 Jul 2019 07:57:37 +0000 (UTC)
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
index 34c0d970bcbc..058191d5efad 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -630,6 +630,7 @@ void vhost_dev_init(struct vhost_dev *dev,
 	dev->iov_limit = iov_limit;
 	dev->weight = weight;
 	dev->byte_weight = byte_weight;
+	dev->has_notifier = false;
 	init_llist_head(&dev->work_list);
 	init_waitqueue_head(&dev->wait);
 	INIT_LIST_HEAD(&dev->read_list);
@@ -731,6 +732,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
 	if (err)
 		goto err_mmu_notifier;
 #endif
+	dev->has_notifier = true;
 
 	return 0;
 
@@ -960,7 +962,11 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
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
@@ -2065,8 +2071,10 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
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
@@ -2086,8 +2094,11 @@ static long vhost_vring_set_num_addr(struct vhost_dev *d,
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
index 819296332913..a62f56a4cf72 100644
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


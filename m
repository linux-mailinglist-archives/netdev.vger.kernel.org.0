Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607F651F617
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 09:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiEIHmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:42:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbiEIHS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:18:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 92CC81B1F58
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652080503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=y4dvnbKnaNy27zkgDTuBkmRrOFE3VwNzMUWnMGEyi1M=;
        b=RHct3VQeZfGcWM727voBNKlulpIvaoYO4IRQTV6cnKwqtUCbSdQARuA9xIis28/MvBR/E/
        +7yrCWPCbdQtwRDQtFrOfS79jPUBwMfDj7Q3An7IscSVlDlSoKgGw5/ZJGUVCf8l+JLiKU
        2G4VYbVv0ZnXEfYkTDP26NzI6yAPELE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-I9W7oumRPWWm6mGC5d-AGg-1; Mon, 09 May 2022 03:14:59 -0400
X-MC-Unique: I9W7oumRPWWm6mGC5d-AGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 41A441C068C2;
        Mon,  9 May 2022 07:14:59 +0000 (UTC)
Received: from server.redhat.com (ovpn-12-229.pek2.redhat.com [10.72.12.229])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44B40111F3DB;
        Mon,  9 May 2022 07:14:51 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, jasowang@redhat.com, mst@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH v1] vdpa: Do not count the pages that were already pinned in the vhost-vDPA
Date:   Mon,  9 May 2022 15:14:26 +0800
Message-Id: <20220509071426.155941-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We count pinned_vm as follow in vhost-vDPA

        lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
        if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
                ret = -ENOMEM;
                goto unlock;
        }
This means if we have two vDPA devices for the same VM the pages would be counted twice
So we add a tree to save the page that counted and we will not count it again

Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c     | 79 ++++++++++++++++++++++++++++++++++++++--
 include/linux/mm_types.h |  2 +
 2 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05f5fd2af58f..48cb5c8264b5 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -24,6 +24,9 @@
 #include <linux/vhost.h>
 
 #include "vhost.h"
+#include <linux/rbtree.h>
+#include <linux/interval_tree.h>
+#include <linux/interval_tree_generic.h>
 
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
@@ -505,6 +508,50 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	mutex_unlock(&d->mutex);
 	return r;
 }
+int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last)
+{
+	struct interval_tree_node *new_node;
+
+	if (last < start)
+		return -EFAULT;
+
+	/* If the range being mapped is [0, ULONG_MAX], split it into two entries
+	 * otherwise its size would overflow u64.
+	 */
+	if (start == 0 && last == ULONG_MAX) {
+		u64 mid = last / 2;
+
+		vhost_vdpa_add_range_ctx(root, start, mid);
+		start = mid + 1;
+	}
+
+	new_node = kmalloc(sizeof(struct interval_tree_node), GFP_ATOMIC);
+	if (!new_node)
+		return -ENOMEM;
+
+	new_node->start = start;
+	new_node->last = last;
+
+	interval_tree_insert(new_node, root);
+
+	return 0;
+}
+
+void vhost_vdpa_del_range(struct rb_root_cached *root, u64 start, u64 last)
+{
+	struct interval_tree_node *new_node;
+
+	while ((new_node = interval_tree_iter_first(root, start, last))) {
+		interval_tree_remove(new_node, root);
+		kfree(new_node);
+	}
+}
+
+struct interval_tree_node *vhost_vdpa_search_range(struct rb_root_cached *root,
+						   u64 start, u64 last)
+{
+	return interval_tree_iter_first(root, start, last);
+}
 
 static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
@@ -513,6 +560,7 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	struct vhost_iotlb_map *map;
 	struct page *page;
 	unsigned long pfn, pinned;
+	struct interval_tree_node *new_node = NULL;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
 		pinned = PFN_DOWN(map->size);
@@ -523,7 +571,18 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+
+		new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
+						   map->start,
+						   map->start + map->size - 1);
+
+		if (new_node) {
+			vhost_vdpa_del_range(&dev->mm->root_for_vdpa,
+					     map->start,
+					     map->start + map->size - 1);
+			atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+		}
+
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -591,6 +650,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
+	struct interval_tree_node *new_node = NULL;
 
 	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
@@ -611,9 +671,22 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 		return r;
 	}
 
-	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
+	if (!vdpa->use_va) {
+		new_node = vhost_vdpa_search_range(&dev->mm->root_for_vdpa,
+						   iova, iova + size - 1);
+
+		if (new_node == 0) {
+			r = vhost_vdpa_add_range_ctx(&dev->mm->root_for_vdpa,
+						     iova, iova + size - 1);
+			if (r) {
+				vhost_iotlb_del_range(dev->iotlb, iova,
+						      iova + size - 1);
+				return r;
+			}
 
+			atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
+		}
+	}
 	return 0;
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5140e5feb486..46eaa6d0560b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -634,6 +634,8 @@ struct mm_struct {
 #ifdef CONFIG_IOMMU_SUPPORT
 		u32 pasid;
 #endif
+		struct rb_root_cached root_for_vdpa;
+
 	} __randomize_layout;
 
 	/*
-- 
2.34.1


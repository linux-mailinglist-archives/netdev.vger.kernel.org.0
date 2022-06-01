Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74D539AB5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 03:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348968AbiFABUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 21:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348962AbiFABUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 21:20:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E51F95A3A
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 18:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654046432;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qAzOFD7ObxR7RBhrEOE65Iye7i1jdPXqMYZvPrmJxC8=;
        b=WVtgajrKs69Xi2M3KwS3knzzPqKXAlmaXIXsmxcYZmn4y3hSeWdkcCQTwhCDCGeMI6J+X1
        IROGBJaKFqVbJ4/U9SbGYFrQT8ZQ2J0bdbCrVEf+b6G6lA0oclOLr8DL7k7h6z3RqUFFhl
        srsI9c468bBB37SKKdRcywsAPHM2bag=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-195-1Yq-QPCgO4WwfOJdBWCj-g-1; Tue, 31 May 2022 21:20:28 -0400
X-MC-Unique: 1Yq-QPCgO4WwfOJdBWCj-g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 32E6829AB40F;
        Wed,  1 Jun 2022 01:20:28 +0000 (UTC)
Received: from server.redhat.com (ovpn-13-32.pek2.redhat.com [10.72.13.32])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF327492C3B;
        Wed,  1 Jun 2022 01:20:23 +0000 (UTC)
From:   Cindy Lu <lulu@redhat.com>
To:     lulu@redhat.com, mst@redhat.com, jasowang@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2] vdpa: Do not count the pages that were already pinned in the vhost-vDPA
Date:   Wed,  1 Jun 2022 09:20:19 +0800
Message-Id: <20220601012019.1102186-1-lulu@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
So we add a tree to save the page that counted and we will not count it
again.
Signed-off-by: Cindy Lu <lulu@redhat.com>
---
 drivers/vhost/vdpa.c  | 542 +++++++++++++++++++++++++++++++++++++++++-
 drivers/vhost/vhost.h |   1 +
 2 files changed, 539 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 05f5fd2af58f..1b0da0735efd 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -24,6 +24,10 @@
 #include <linux/vhost.h>
 
 #include "vhost.h"
+#include <linux/rbtree.h>
+#include <linux/interval_tree.h>
+#include <linux/interval_tree_generic.h>
+#include <linux/hashtable.h>
 
 enum {
 	VHOST_VDPA_BACKEND_FEATURES =
@@ -506,12 +510,478 @@ static long vhost_vdpa_unlocked_ioctl(struct file *filep,
 	return r;
 }
 
+struct vdpa_tree_node {
+	struct interval_tree_node tree_node;
+	int ref;
+};
+struct vdpa_link_node {
+	struct vdpa_tree_node *vdpa_node;
+	struct vdpa_link_node *next;
+	u64 node_start;
+	u64 node_last;
+};
+
+int vhost_vdpa_add_range_ctx(struct rb_root_cached *root, u64 start, u64 last,
+			     int ref)
+{
+	struct interval_tree_node *new_node;
+	struct vdpa_tree_node *vdpa_node;
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
+		vhost_vdpa_add_range_ctx(root, start, mid, ref);
+		start = mid + 1;
+	}
+	vdpa_node = kmalloc(sizeof(struct vdpa_tree_node), GFP_ATOMIC);
+
+	new_node = &vdpa_node->tree_node;
+	if (!new_node)
+		return -ENOMEM;
+
+	new_node->start = start;
+	new_node->last = last;
+	vdpa_node->ref = ref;
+
+	interval_tree_insert(new_node, root);
+
+	return 0;
+}
+
+u64 vhost_vdpa_range_ref_add(struct rb_root_cached *root,
+			     struct vdpa_link_node *link_head, int node_number,
+			     u64 start, u64 last)
+{
+	int i = 0;
+	u64 size = 0;
+	int new_ref;
+	u64 node_start;
+	u64 node_last;
+	u64 range_start;
+	u64 range_last;
+	int range_size;
+	struct vdpa_link_node *link_node;
+	struct vdpa_tree_node *vdpa_node = NULL;
+	struct interval_tree_node *node = NULL;
+
+	if (node_number == 0) {
+		vhost_vdpa_add_range_ctx(root, start, last, 1);
+
+		size = last - start + 1;
+		return size;
+	}
+
+	link_node = link_head;
+	range_start = start;
+	range_last = last;
+	range_size = range_start - range_last;
+	for (i = 0; i < node_number; i++) {
+		vdpa_node = link_node->vdpa_node;
+		link_node = link_node->next;
+		node = &vdpa_node->tree_node;
+		new_ref = vdpa_node->ref;
+		node_start = node->start;
+		node_last = node->last;
+
+		if (range_start == node_start) {
+			if (node_last < range_last) {
+				/* range_start= node->start--- node->last--range_last*/
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 node_last,
+							 new_ref + 1);
+				/*count the next range */
+			} else if (node_last > range_last) {
+				/* range_start= node->start	---  last --  node->last*/
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_last,
+							 new_ref + 1);
+				vhost_vdpa_add_range_ctx(root, range_last + 1,
+							 node_last, new_ref);
+			} else {
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 node_last,
+							 new_ref + 1);
+			}
+		} else if (node_start < range_start) {
+			if (range_last < node_last) {
+				/* node->start---  start--- last--- node->last*/
+				/* should the end rang*/
+
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 range_last,
+							 new_ref + 1);
+				vhost_vdpa_add_range_ctx(root, range_last + 1,
+							 node_last, new_ref);
+
+			} else if (range_last > node_last) {
+				/* node->start---  start--- node->last-- last*/
+
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 node_last,
+							 new_ref + 1);
+			} else {
+				/* node->start---  start--- node->last= last*/
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 node_last,
+							 new_ref + 1);
+				/* should the end rang*/
+			}
+		} else {
+			if (node_last < range_last) {
+				/* range_start --- node->start --- node->last ----last  */
+
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 node_start - 1, 1);
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 node_last,
+							 new_ref + 1);
+				size += ((node_start - 1) - range_start) + 1;
+			} else if (node_last > range_last) {
+				/* range_start--- node->start	---  last --  node->last	*/
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 node_start - 1, 1);
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_last,
+							 new_ref + 1);
+				vhost_vdpa_add_range_ctx(root, range_last + 1,
+							 node_last, new_ref);
+				size += ((node_start - 1) - range_start) + 1;
+
+				/* should the end rang*/
+			} else {
+				/* range_start--- node->start	---  last =  node->last	*/
+				vhost_vdpa_add_range_ctx(root, range_start,
+							 node_start - 1, 1);
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 node_last,
+							 new_ref + 1);
+				size += ((node_start - 1) - range_start) + 1;
+
+				/* should the end rang*/
+			}
+		}
+		/* work in next node*/
+		range_start = node_last + 1;
+		if (range_start > range_last)
+			break;
+	}
+
+	range_size = range_last - range_start;
+
+	/* last round and still some range*/
+
+	if ((range_size >= 0) && (range_start >= node_last) &&
+	    (node_number == i + 1)) {
+		vhost_vdpa_add_range_ctx(root, range_start, range_last, 1);
+		size = size + (range_last - range_start) + 1;
+	} else if ((range_size == -1) && (node_number == i + 1)) {
+		return size;
+	} else {
+		printk(KERN_WARNING,
+		       "%s %d FAIL start %lld last %lld node->start %lld  node->last %lld i  %d",
+		       __func__, __LINE__, range_start, range_last, node_start,
+		       node_last, i);
+	}
+
+	return size;
+}
+
+u64 vhost_vdpa_range_ref_del(struct rb_root_cached *root,
+			     struct vdpa_link_node *link_head, int node_number,
+			     u64 start, u64 last)
+{
+	int i = 0;
+	u64 size = 0;
+	int new_ref;
+	u64 node_start;
+	u64 node_last;
+	u64 range_start;
+	u64 range_last;
+	int range_size;
+	struct vdpa_link_node *link_node;
+	struct vdpa_tree_node *vdpa_node = NULL;
+	struct interval_tree_node *node = NULL;
+
+	if (node_number == 0)
+		return 0;
+
+	link_node = link_head;
+	range_start = start;
+	range_last = last;
+
+	for (i = 0; i < node_number; i++) {
+		vdpa_node = link_node->vdpa_node;
+		link_node = link_node->next;
+		node = &vdpa_node->tree_node;
+		new_ref = vdpa_node->ref;
+		node_start = node->start;
+		node_last = node->last;
+
+		if (range_start == node_start) {
+			if (node_last < range_last) {
+				/* range_start =node->start --- node->last ----last*/
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 node_start,
+								 node_last,
+								 new_ref - 1);
+					/*count the next range */
+				} else {
+					/* if the ref =0, do not need add it back, count size*/
+					size += (node_last - node_start) + 1;
+				}
+
+			} else if (node_last > range_last) {
+				/* range_start= node->start	---  last --  node->last*/
+
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 node_start,
+								 range_last,
+								 new_ref - 1);
+				} else {
+					size += (range_last - node_start) + 1;
+				}
+				vhost_vdpa_add_range_ctx(root, range_last + 1,
+							 node_last, new_ref);
+			} else {
+				/* range_start= node->start	---  last = node->last*/
+
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 node_start,
+								 range_last,
+								 new_ref - 1);
+				} else {
+					size += (range_last - node_start) + 1;
+				}
+				/* should be the end */
+			}
+		} else if (node_start < range_start) {
+			if (range_last < node_last) {
+				/* node->start---  start--- last--- node->last*/
+				/* should the end rang*/
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 range_start,
+								 range_last,
+								 new_ref - 1);
+				} else {
+					size += (range_last - range_start) + 1;
+				}
+				vhost_vdpa_add_range_ctx(root, range_last + 1,
+							 node_last, new_ref);
+
+			} else if (range_last > node_last) {
+				/* node->start---  start--- node->last--- last*/
+
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 range_start,
+								 node_last,
+								 new_ref - 1);
+				} else {
+					size += (node_last - range_start) + 1;
+				}
+			} else {
+				/* node->start---  start--- node->last= last*/
+				vhost_vdpa_add_range_ctx(root, node_start,
+							 range_start - 1,
+							 new_ref);
+				if (new_ref > 1) {
+					vhost_vdpa_add_range_ctx(root,
+								 range_start,
+								 range_last,
+								 new_ref - 1);
+				} else {
+					size += (range_last - range_start) + 1;
+				}
+				/* should be the end */
+			}
+		} else {
+			/* some range not in the node, error*/
+			printk(KERN_WARNING,
+			       "%s %d FAIL  start %lld last %lld node->start %lld  node->last %lld new_ref %d",
+			       __func__, __LINE__, range_start, range_last,
+			       node_start, node_last, new_ref);
+		}
+
+		range_start = node_last + 1;
+		if (range_start > range_last)
+			break;
+	}
+
+	range_size = range_last - range_start;
+
+	/* last round and still some range*/
+
+	if ((range_size > 0) && (node_number == i + 1)) {
+		printk(KERN_WARNING,
+		       "%s %d FAIL start %lld last %lld node->start %lld  node->last %lld range_size  %d",
+		       __func__, __LINE__, range_start, range_last, node_start,
+		       node_last, range_size);
+	}
+	return size;
+}
+
+struct vdpa_link_node *vhost_vdpa_merge_list(struct vdpa_link_node *list1,
+					     struct vdpa_link_node *list2)
+{
+	struct vdpa_link_node dummy_head;
+	struct vdpa_link_node *ptr = &dummy_head;
+
+	while (list1 && list2) {
+		if (list1->node_start < list2->node_start) {
+			ptr->next = list1;
+			list1 = list1->next;
+		} else {
+			ptr->next = list2;
+			list2 = list2->next;
+		}
+		ptr = ptr->next;
+	}
+	if (list1)
+		ptr->next = list1;
+	else
+		ptr->next = list2;
+
+	return dummy_head.next;
+}
+
+struct vdpa_link_node *vhost_vdpa_get_mid(struct vdpa_link_node *head)
+{
+	struct vdpa_link_node *mid_prev = NULL;
+	struct vdpa_link_node *mid;
+
+	while (head && head->next) {
+		mid_prev = (mid_prev == NULL) ? head : mid_prev->next;
+		head = head->next->next;
+	}
+	mid = mid_prev->next;
+	mid_prev->next = NULL;
+	return mid;
+}
+struct vdpa_link_node *vhost_vdpa_sort_list(struct vdpa_link_node *head)
+{
+	struct vdpa_link_node *mid;
+	struct vdpa_link_node *left;
+	struct vdpa_link_node *right;
+
+	if (!head || !head->next)
+		return head;
+
+	mid = vhost_vdpa_get_mid(head);
+	left = vhost_vdpa_sort_list(head);
+	right = vhost_vdpa_sort_list(mid);
+	return vhost_vdpa_merge_list(left, right);
+}
+
+u64 vhost_vdpa_range_ops(struct rb_root_cached *root, u64 start, u64 last,
+			 bool ops)
+{
+	struct interval_tree_node *node = NULL;
+	struct vdpa_tree_node *vdpa_node;
+	int node_number = 0;
+	int i = 0;
+	u64 size = 0;
+	struct vdpa_link_node dummy_head = { 0 };
+	struct vdpa_link_node *link_node;
+	struct vdpa_link_node *link_head_tmp;
+	struct vdpa_link_node *pre_link_node;
+
+	pre_link_node = &dummy_head;
+	/*search the rang overlaped, and del from the tree*/
+	for (node = interval_tree_iter_first(root, start, last); node;
+	     node = interval_tree_iter_next(node, start, last)) {
+		link_node = kmalloc(sizeof(struct vdpa_link_node), GFP_ATOMIC);
+		if (link_node == NULL) {
+			goto out;
+		}
+		vdpa_node =
+			container_of(node, struct vdpa_tree_node, tree_node);
+		link_node->vdpa_node = vdpa_node;
+		link_node->node_start = node->start;
+		link_node->node_last = node->last;
+
+		pre_link_node->next = link_node;
+		pre_link_node = link_node;
+		pre_link_node->next = NULL;
+
+		node_number++;
+
+		interval_tree_remove(node, root);
+	}
+	/* sorting the node */
+	link_head_tmp = vhost_vdpa_sort_list(dummy_head.next);
+
+	/* these link node are have overlap with range, check the ref and add back to the tree*/
+	if (ops == true) {
+		size = vhost_vdpa_range_ref_add(root, link_head_tmp,
+						node_number, start, last);
+	} else {
+		size = vhost_vdpa_range_ref_del(root, link_head_tmp,
+						node_number, start, last);
+	}
+out:
+	pre_link_node = link_head_tmp;
+
+	for (i = 0; i < node_number; i++) {
+		vdpa_node = pre_link_node->vdpa_node;
+		link_node = pre_link_node->next;
+		kfree(vdpa_node);
+		kfree(pre_link_node);
+		pre_link_node = link_node;
+	}
+	return size;
+}
+u64 vhost_vdpa_search_range_add(struct rb_root_cached *root, u64 start,
+				u64 last)
+{
+	u64 size;
+
+	size = vhost_vdpa_range_ops(root, start, last, true);
+
+	return size;
+}
+
+u64 vhost_vdpa_search_range_del(struct rb_root_cached *root, u64 start,
+				u64 last)
+{
+	u64 size;
+
+	size = vhost_vdpa_range_ops(root, start, last, false);
+
+	return size;
+}
+
 static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 {
 	struct vhost_dev *dev = &v->vdev;
 	struct vhost_iotlb *iotlb = dev->iotlb;
 	struct vhost_iotlb_map *map;
 	struct page *page;
+	u64 size;
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
@@ -523,7 +993,11 @@ static void vhost_vdpa_pa_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
+
+		size = vhost_vdpa_search_range_del(dev->vdpa_mem_tree,
+						   map->start,
+						   map->start + map->size - 1);
+		atomic64_sub(PFN_DOWN(size), &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -591,6 +1065,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 	struct vdpa_device *vdpa = v->vdpa;
 	const struct vdpa_config_ops *ops = vdpa->config;
 	int r = 0;
+	u64 size_count;
 
 	r = vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1,
 				      pa, perm, opaque);
@@ -610,9 +1085,11 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
 		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
 		return r;
 	}
-
-	if (!vdpa->use_va)
-		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
+	if (!vdpa->use_va) {
+		size_count = vhost_vdpa_search_range_add(dev->vdpa_mem_tree,
+							 iova, iova + size - 1);
+		atomic64_add(PFN_DOWN(size_count), &dev->mm->pinned_vm);
+	}
 
 	return 0;
 }
@@ -946,6 +1423,58 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
 	}
 }
 
+struct root_for_vdpa_node {
+	struct hlist_node hlist;
+	struct rb_root_cached vdpa_mem_tree;
+	pid_t pid_using;
+};
+static DECLARE_HASHTABLE(root_for_vdpa_node_list, 8);
+int status_for_vdpa_tree = 0;
+
+struct root_for_vdpa_node *vhost_vdpa_get_mem_tree(struct task_struct *task)
+{
+	struct root_for_vdpa_node *root_get_tmp = NULL;
+	pid_t pid_using = task_pid_nr(task);
+
+	/* No hased table, init one */
+	if (status_for_vdpa_tree == 0) {
+		hash_init(root_for_vdpa_node_list);
+		status_for_vdpa_tree = 1;
+	}
+
+	hash_for_each_possible (root_for_vdpa_node_list, root_get_tmp, hlist,
+				pid_using) {
+		if (root_get_tmp->pid_using == pid_using)
+			return root_get_tmp;
+	}
+
+	root_get_tmp = kmalloc(sizeof(*root_get_tmp), GFP_KERNEL);
+	root_get_tmp->pid_using = pid_using;
+
+	root_get_tmp->vdpa_mem_tree = RB_ROOT_CACHED;
+
+	hash_add(root_for_vdpa_node_list, &root_get_tmp->hlist,
+		 root_get_tmp->pid_using);
+
+	return root_get_tmp;
+}
+
+void vhost_vdpa_relase_mem_tree(struct task_struct *task)
+{
+	struct root_for_vdpa_node *root_get_tmp = NULL;
+	pid_t pid_using = task_pid_nr(task);
+
+	/* No hased table, init one */
+	hash_for_each_possible (root_for_vdpa_node_list, root_get_tmp, hlist,
+				pid_using) {
+		if (root_get_tmp->pid_using == pid_using)
+			kfree(root_get_tmp);
+		return;
+	}
+
+	return;
+}
+
 static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 {
 	struct vhost_vdpa *v;
@@ -991,10 +1520,13 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
 	vhost_vdpa_set_iova_range(v);
 
 	filep->private_data = v;
+	struct root_for_vdpa_node *tmp = vhost_vdpa_get_mem_tree(current);
+	dev->vdpa_mem_tree = &tmp->vdpa_mem_tree;
 
 	return 0;
 
 err_init_iotlb:
+	vhost_vdpa_relase_mem_tree(current);
 	vhost_dev_cleanup(&v->vdev);
 	kfree(vqs);
 err:
@@ -1016,6 +1548,8 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
 	struct vhost_dev *d = &v->vdev;
 
 	mutex_lock(&d->mutex);
+	vhost_vdpa_relase_mem_tree(current);
+
 	filep->private_data = NULL;
 	vhost_vdpa_clean_irq(v);
 	vhost_vdpa_reset(v);
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 638bb640d6b4..d1c662eb4f26 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -161,6 +161,7 @@ struct vhost_dev {
 	int byte_weight;
 	u64 kcov_handle;
 	bool use_worker;
+	struct rb_root_cached *vdpa_mem_tree;
 	int (*msg_handler)(struct vhost_dev *dev,
 			   struct vhost_iotlb_msg *msg);
 };
-- 
2.34.3


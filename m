Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E017C1A1D
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbfI3CJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:10 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34009 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729329AbfI3CJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:09 -0400
Received: by mail-pl1-f195.google.com with SMTP id k7so3282630pll.1
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=smH45prXaWa99xV+deagFBljpnUmJJvQg3D5ytEuJBw=;
        b=vGGv5H8wpc7GElG0QGj0ddKH2iIbG/RlZix3qUgJBp4UMXo63z9Pwpr6+J2ipCBe/o
         /hQ55FSENg3qdTyFd+8slGnHRZC70tnji1qk+rcNkpbTVZ5JJn3bOsOkO1bau4leNx4e
         eLK3q5EYKJUSa9CtRL8RB8fvAVxpG0HxAMamdpXhG2JWuDHq8+XS2RtuOkLo7DpX1H6h
         NbcBE8/tJSwiSx7o7I7r3OqjGp9Qqe6bJ/1HcjwFTmJ6SP0A4hUm+u3AWWpt8LvVCRHY
         sXz62NQWs2onZYDGqtRwL4ZYVpqVMNJIdCSyHcm7hdYv9UDPY5jtUUw+3MM9uNZh46HA
         hdTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=smH45prXaWa99xV+deagFBljpnUmJJvQg3D5ytEuJBw=;
        b=IHPWqhjax49iyPUgDj/T7Cql5NrkEM/gkcLYBzVgo5BgrQTFdz0ccTBzAZAkVRgRA7
         BdxaBPm54kOpwpzlSct+IRwVVknze+EMfH+APKi7cBIE9XDBtUoZr+zX0/cE94Msa7Dy
         QSkkKFKB0EKwcccPO3x1ZiLiMCnMdhABrdwYh4WekDUEVABq2lpmwRIyafO5Z7z2ws4g
         bWF2wgDJS0JLqCZxIG9PcRrWm03S8f+NnVxiJmnPB+crohTB99r4u9edAXW5/B8Ru65k
         DHbbNG9VAkJQlW2TdMEeXihakWG/nLZwWh7Xmz/N3lLyCcWSf5g4M25UL0I+h56F/XZM
         IxkQ==
X-Gm-Message-State: APjAAAVj/P24JS7N6uf/gFyYpU2ahWgK98I3Vhg3qYYFl3SFXjcSYZW9
        SiqCFTrVK/viYIcaL2JlAeV7HMnU
X-Google-Smtp-Source: APXvYqxiwcpaOZKb9PScR5UlsRF0mGxGoSABklllPnz5zXrnC+fBb5rEQubgp8ohbx/KJ8AErh9kIQ==
X-Received: by 2002:a17:902:b10d:: with SMTP id q13mr4398552plr.109.1569809349219;
        Sun, 29 Sep 2019 19:09:09 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:08 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 5/9] net: openvswitch: optimize flow-mask looking up
Date:   Mon, 30 Sep 2019 01:10:02 +0800
Message-Id: <1569777006-7435-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The full looking up on flow table traverses all mask array.
If mask-array is too large, the number of invalid flow-mask
increase, performance will be drop.

This patch optimizes mask-array operation:

* Inserting, insert it [ma->count- 1] directly.
* Removing, only change last and current mask point, and free current mask.
* Looking up, full looking up will break if mask is NULL.

The function which changes or gets *count* of struct mask_array,
is protected by ovs_lock, but flow_lookup (not protected) should use *max* of
struct mask_array.

Functions protected by ovs_lock:
* tbl_mask_array_del_mask
* tbl_mask_array_add_mask
* flow_mask_find
* ovs_flow_tbl_lookup_exact
* ovs_flow_tbl_num_masks

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 101 +++++++++++++++++++++----------------------
 1 file changed, 49 insertions(+), 52 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e59fac5..5257e4a 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -546,7 +546,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
 		if (!mask)
-			continue;
+			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
@@ -640,15 +640,13 @@ struct sw_flow *ovs_flow_tbl_lookup_exact(struct flow_table *tbl,
 	int i;
 
 	/* Always called under ovs-mutex. */
-	for (i = 0; i < ma->max; i++) {
+	for (i = 0; i < ma->count; i++) {
 		struct table_instance *ti = rcu_dereference_ovsl(tbl->ti);
 		u32 __always_unused n_mask_hit;
 		struct sw_flow_mask *mask;
 		struct sw_flow *flow;
 
 		mask = ovsl_dereference(ma->masks[i]);
-		if (!mask)
-			continue;
 
 		flow = masked_flow_lookup(ti, match->key, mask, &n_mask_hit);
 		if (flow && ovs_identifier_is_key(&flow->id) &&
@@ -712,21 +710,31 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
 	return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }
 
-static void tbl_mask_array_delete_mask(struct mask_array *ma,
-				       struct sw_flow_mask *mask)
+static void tbl_mask_array_del_mask(struct flow_table *tbl,
+				    struct sw_flow_mask *mask)
 {
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
 	int i;
 
 	/* Remove the deleted mask pointers from the array */
-	for (i = 0; i < ma->max; i++) {
-		if (mask == ovsl_dereference(ma->masks[i])) {
-			RCU_INIT_POINTER(ma->masks[i], NULL);
-			ma->count--;
-			kfree_rcu(mask, rcu);
-			return;
-		}
+	for (i = 0; i < ma->count; i++) {
+		if (mask == ovsl_dereference(ma->masks[i]))
+			goto found;
 	}
+
 	BUG();
+	return;
+
+found:
+	rcu_assign_pointer(ma->masks[i], ma->masks[ma->count -1]);
+	RCU_INIT_POINTER(ma->masks[ma->count -1], NULL);
+	ma->count--;
+	kfree_rcu(mask, rcu);
+
+	/* Shrink the mask array if necessary. */
+	if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+	    ma->count <= (ma->max / 3))
+		tbl_mask_array_realloc(tbl, ma->max / 2);
 }
 
 /* Remove 'mask' from the mask list, if it is not needed any more. */
@@ -740,17 +748,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 		BUG_ON(!mask->ref_count);
 		mask->ref_count--;
 
-		if (!mask->ref_count) {
-			struct mask_array *ma;
-
-			ma = ovsl_dereference(tbl->mask_array);
-			tbl_mask_array_delete_mask(ma, mask);
-
-			/* Shrink the mask array if necessary. */
-			if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
-			    ma->count <= (ma->max / 3))
-				tbl_mask_array_realloc(tbl, ma->max / 2);
-		}
+		if (!mask->ref_count)
+			tbl_mask_array_del_mask(tbl, mask);
 	}
 }
 
@@ -803,17 +802,38 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
 	int i;
 
 	ma = ovsl_dereference(tbl->mask_array);
-	for (i = 0; i < ma->max; i++) {
+	for (i = 0; i < ma->count; i++) {
 		struct sw_flow_mask *t;
 		t = ovsl_dereference(ma->masks[i]);
 
-		if (t && mask_equal(mask, t))
+		if (mask_equal(mask, t))
 			return t;
 	}
 
 	return NULL;
 }
 
+static int tbl_mask_array_add_mask(struct flow_table *tbl,
+				   struct sw_flow_mask *new)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int err;
+
+	if (ma->count >= ma->max) {
+		err = tbl_mask_array_realloc(tbl, ma->max +
+					      MASK_ARRAY_SIZE_MIN);
+		if (err)
+			return err;
+	}
+
+	BUG_ON(ovsl_dereference(ma->masks[ma->count]));
+
+	rcu_assign_pointer(ma->masks[ma->count], new);
+	ma->count++;
+
+	return 0;
+}
+
 /* Add 'mask' into the mask list, if it is not already there. */
 static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 			    const struct sw_flow_mask *new)
@@ -822,9 +842,6 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		struct mask_array *ma;
-		int i;
-
 		/* Allocate a new mask if none exsits. */
 		mask = mask_alloc();
 		if (!mask)
@@ -833,29 +850,9 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 		mask->range = new->range;
 
 		/* Add mask to mask-list. */
-		ma = ovsl_dereference(tbl->mask_array);
-		if (ma->count >= ma->max) {
-			int err;
-
-			err = tbl_mask_array_realloc(tbl, ma->max +
-						     MASK_ARRAY_SIZE_MIN);
-			if (err) {
-				kfree(mask);
-				return err;
-			}
-
-			ma = ovsl_dereference(tbl->mask_array);
-		}
-
-		for (i = 0; i < ma->max; i++) {
-			const struct sw_flow_mask *t;
-
-			t = ovsl_dereference(ma->masks[i]);
-			if (!t) {
-				rcu_assign_pointer(ma->masks[i], mask);
-				ma->count++;
-				break;
-			}
+		if (tbl_mask_array_add_mask(tbl, mask)) {
+			kfree(mask);
+			return -ENOMEM;
 		}
 	} else {
 		BUG_ON(!mask->ref_count);
-- 
1.8.3.1


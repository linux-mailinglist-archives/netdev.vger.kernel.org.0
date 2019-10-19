Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248EDE9562
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfJ3Dsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:46 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40887 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Dso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:44 -0400
Received: by mail-pl1-f195.google.com with SMTP id p5so320885plr.7
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0leZDpps0K0dtZHi+cGtthWfpv7itMdBdkx/LWqMEjg=;
        b=tfaFS+mckdAa8vqdx7vHrGKqHekU2k71W8LFQHxSH2CIBCEKqX3pNi3SV00MY3ODq7
         7s9udZPc3Nh9jD5V5WQ9Quoxi5BNm7JMEcU8KWjcasoIsyiuWSkdksKj1pbiIsqaMKCp
         tCT7DYOsczTdG5u8quTNFZVd3tbaMQAkNk2JTUgzIrhCVuWqhOgqxUmpxC0fIU8e0RPc
         1DMahE1Z1nUaLNqmk59G6B4keBe5C4qlrumpSegscYC+onElX7SxqBYJ74kUlWDVskpl
         MDfl6IAPcPNtRK9iwg+iWbGaLZfcvYeSEGlKc+KdjbfSDF2NCjc8U0oDXLg1YUw4aZwp
         gxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0leZDpps0K0dtZHi+cGtthWfpv7itMdBdkx/LWqMEjg=;
        b=IIU0jvrOfLGBdHAb5qQnOOO+B1MH3EGMwKQL2mD6KUDPL+KjoE4uA8MfNZldulnjOW
         MND3dYQ3uzJLGzzThI3JbEm2tmxkfoJrRBCIGL1cPhX83JG1cmeL+86KPyHPkijiz44A
         /JfWBtjK3waoc8aKgmV1xgrBPRVONCIkUHe0fYIDk8tQqCY2DtPifhCIVYRJcCvLqzxU
         tPGRRD/geGagfDm0pnEtR5zuxcxgCMcqqIWr1jVLGkIw/IiXCCOGkTz+f5xj4KpHY3xD
         BEHDwcj0pWCMak6Rmg3DViJFJrtVQeTs392sX5Zer3ACWR3/z/a8d4WtE4Qyk2aLLIaw
         6vyQ==
X-Gm-Message-State: APjAAAWxdzOCiEhvnkvL8gAHJ9cV85rxE039LO3hZLR7WjfnqtsyOBT3
        j2ZTDPecfC7an3Yf1wEvEky+vDO0
X-Google-Smtp-Source: APXvYqzt7QKJ4YWWZ3h+gUjtpox7rvWkiaSEWTzkxBPH5vkaRqN4i1QADZHaFXfVw5s39JqkhIT6DQ==
X-Received: by 2002:a17:902:bf08:: with SMTP id bi8mr2202367plb.249.1572407323880;
        Tue, 29 Oct 2019 20:48:43 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:43 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 05/10] net: openvswitch: optimize flow-mask looking up
Date:   Sat, 19 Oct 2019 16:08:39 +0800
Message-Id: <1571472524-73832-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The full looking up on flow table traverses all mask array.
If mask-array is too large, the number of invalid flow-mask
increase, performance will be drop.

One bad case, for example: M means flow-mask is valid and NULL
of flow-mask means deleted.

+-------------------------------------------+
| M | NULL | ...                  | NULL | M|
+-------------------------------------------+

In that case, without this patch, openvswitch will traverses all
mask array, because there will be one flow-mask in the tail. This
patch changes the way of flow-mask inserting and deleting, and the
mask array will be keep as below: there is not a NULL hole. In the
fast path, we can "break" "for" (not "continue") in flow_lookup
when we get a NULL flow-mask.

         "break"
            v
+-------------------------------------------+
| M | M |  NULL |...           | NULL | NULL|
+-------------------------------------------+

This patch don't optimize slow or control path, still using ma->max
to traverse. Slow path:
* tbl_mask_array_realloc
* ovs_flow_tbl_lookup_exact
* flow_mask_find

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 101 ++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 49 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 8d4f50d..a10d421 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -538,7 +538,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
 		if (!mask)
-			continue;
+			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
@@ -695,7 +695,7 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
 int ovs_flow_tbl_num_masks(const struct flow_table *table)
 {
 	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
-	return ma->count;
+	return READ_ONCE(ma->count);
 }
 
 static struct table_instance *table_instance_expand(struct table_instance *ti,
@@ -704,21 +704,33 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
 	return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }
 
-static void tbl_mask_array_delete_mask(struct mask_array *ma,
-				       struct sw_flow_mask *mask)
+static void tbl_mask_array_del_mask(struct flow_table *tbl,
+				    struct sw_flow_mask *mask)
 {
-	int i;
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i, ma_count = READ_ONCE(ma->count);
 
 	/* Remove the deleted mask pointers from the array */
-	for (i = 0; i < ma->max; i++) {
-		if (mask == ovsl_dereference(ma->masks[i])) {
-			RCU_INIT_POINTER(ma->masks[i], NULL);
-			ma->count--;
-			kfree_rcu(mask, rcu);
-			return;
-		}
+	for (i = 0; i < ma_count; i++) {
+		if (mask == ovsl_dereference(ma->masks[i]))
+			goto found;
 	}
+
 	BUG();
+	return;
+
+found:
+	WRITE_ONCE(ma->count, ma_count -1);
+
+	rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
+	RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
+
+	kfree_rcu(mask, rcu);
+
+	/* Shrink the mask array if necessary. */
+	if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+	    ma_count <= (ma->max / 3))
+		tbl_mask_array_realloc(tbl, ma->max / 2);
 }
 
 /* Remove 'mask' from the mask list, if it is not needed any more. */
@@ -732,17 +744,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
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
 
@@ -806,6 +809,29 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
 	return NULL;
 }
 
+static int tbl_mask_array_add_mask(struct flow_table *tbl,
+				   struct sw_flow_mask *new)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int err, ma_count = READ_ONCE(ma->count);
+
+	if (ma_count >= ma->max) {
+		err = tbl_mask_array_realloc(tbl, ma->max +
+					      MASK_ARRAY_SIZE_MIN);
+		if (err)
+			return err;
+
+		ma = ovsl_dereference(tbl->mask_array);
+	}
+
+	BUG_ON(ovsl_dereference(ma->masks[ma_count]));
+
+	rcu_assign_pointer(ma->masks[ma_count], new);
+	WRITE_ONCE(ma->count, ma_count +1);
+
+	return 0;
+}
+
 /* Add 'mask' into the mask list, if it is not already there. */
 static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 			    const struct sw_flow_mask *new)
@@ -814,9 +840,6 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		struct mask_array *ma;
-		int i;
-
 		/* Allocate a new mask if none exsits. */
 		mask = mask_alloc();
 		if (!mask)
@@ -825,29 +848,9 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
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


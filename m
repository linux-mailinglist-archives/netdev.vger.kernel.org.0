Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B17F2D9187
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 14:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405262AbfJPMup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 08:50:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40796 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405255AbfJPMun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 08:50:43 -0400
Received: by mail-pf1-f193.google.com with SMTP id x127so14670034pfb.7
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 05:50:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0leZDpps0K0dtZHi+cGtthWfpv7itMdBdkx/LWqMEjg=;
        b=i+35rjY/kjPpTi/s5bPvlN+0/Y5I1sddG4cGEdC6WJcHth2tgsSa/LtP50RAuPZyZ1
         WFo5o95WvSDM4xWYfM6pVZe0vxX3ZCiHVVfcEJJfGmTTYfRmjSIjNuRSpMRtCxJMPyhh
         sEQHkL4Cm0/UELghNz/qbkhqE7qEEufdLzxQx9+jSkACrf191aEYfdUNxBxEfKNPBLot
         TharcJwUTvAauD1z2qc3J16WgTXa8abhPMIp9tD06wSKMrEMVj5mWiBMIHUF7rffrzqs
         KKS9FisJThqIjrBQ97wmhp5VsnzU3XDWGqeZl7PMS1zVQ0OcP/lQMUfAXXYE4avnE/DJ
         FfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0leZDpps0K0dtZHi+cGtthWfpv7itMdBdkx/LWqMEjg=;
        b=SiNWAE+mPHzVgItEN0+4mByHLlIgtzbcOFr9FufGsohmnMiFtP4a/id4zMp6nmPhCD
         TIo86jWseudxfgKilvEfduofwfHZB6e3ZxfmsZnexx9JPXzRdhqI/FXFpPlir511onZe
         n9Nt554KQcCf6/QJXV4h7Xt1+PwrOfMUbqJ+9BLmsP+1wi7KRpBybqZk3vRnznASsZJ9
         RQ07UjfQLnD7dj+ffwImCxepyOoN0eWMwLFIM+dM8uu3qu5fxGrnGXYxh8aqOwf3ePxQ
         Isy6XOzOByIvysRTEOyYfbCNHr3eqjjaeo32rPVQrAiClYpAqsx9NgulgC6aHi4tLIF8
         ByIg==
X-Gm-Message-State: APjAAAUiJoCsMPTCbT8w8M03Bu3lKitVWCjUGALpJmerbjOWb4hcgaop
        ht6wQVWkybPZxIdsE4rqit8=
X-Google-Smtp-Source: APXvYqz3KK3A8jV0U/02f5pVmYdlMD7ptt0rPN58mWRcrIka2hYLUIERyV16zOzEWciw6+E9ApfEnQ==
X-Received: by 2002:aa7:87ca:: with SMTP id i10mr44864834pfo.62.1571230242333;
        Wed, 16 Oct 2019 05:50:42 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d19sm2747339pjz.5.2019.10.16.05.50.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 05:50:41 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 05/10] net: openvswitch: optimize flow-mask looking up
Date:   Tue, 15 Oct 2019 18:30:35 +0800
Message-Id: <1571135440-24313-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571135440-24313-1-git-send-email-xiangxia.m.yue@gmail.com>
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


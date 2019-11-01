Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0D2EC49E
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKAOYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:24 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44943 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id e10so6576684pgd.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=+6y7OChHTvMPWpmBp1Ktoa0+GosQY6LfAXE2ork61rA=;
        b=VhXfJh+N4bmOKZLDKZ65/HcyEtHvXWWpYHsNmI4lli4UAcZgGcn2IlNO6sZyNLFmIA
         +Wh/P6hhELu5bh1cMHMRzoiH0XjEoOyd5LC1LNiCDS8Kd5TRBA6unCVS3PxOnZdd9PoT
         IO0NNZRnEnTJQmKrfKOQzUj6aECH/tEbw+ugG5GzT327hJ+8vpGiKJZKjEK2MwJNY1no
         Ag18wgB7tKCx67w0Iqb1yMxgaqT9ZmPtdE1qhLbmT5tuZ1BKXkAPJzU+uQhbXC8i6dXX
         3zyZhhO159+K28wwTOgawnCtI6TCB9L5cMDUJAm/QfBiV0plDRyoEHLXgvkFGrssFp+O
         2E9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=+6y7OChHTvMPWpmBp1Ktoa0+GosQY6LfAXE2ork61rA=;
        b=U+Zw9Ei7PHV5NoJs6+UMMK1M9Oo+qROd96AdheJUO4Su+MZrGq1CMQ/n6ej8uHxUEt
         +I+VrFCQ8ott0h5nSf8dxb1YKgqHcq+TsWtERreSEIxfaVr+iOtlhUI8I2juSPBum/5i
         +CW6ONmkhui/NmCWIilzDgAaQnGvhIaqrLxe0ssMC5VOlOknsXAqUWN9v0AKNbDDsasA
         eRs+ukJExneQ8EMzDdnmfGlc1/2+wTvNQ173nt/b3NsCByEAQp0ZvXa9r8nS6m8i/SvJ
         NKJnodOz3ywPdPHjCzUaTTAp7QYgUQ1i4tvWFIYtipaGY3DApbv/vzxklPu8OJ80DEW0
         4rtA==
X-Gm-Message-State: APjAAAVL4gsUwkvobZ4dcxXfaM/xBXckgyXb7vHsiS+P5OfLN9EOsE1I
        QdQEebm2pS6cnky6xne1CiM=
X-Google-Smtp-Source: APXvYqzkEh4hxpliGiW8ZaZM8eTAEPuQW/LzHyotTlB67yYhCz8Nt1rpooXNpiOMsJJg+6NeKNJvqQ==
X-Received: by 2002:a17:90b:3105:: with SMTP id gc5mr4361862pjb.30.1572618263399;
        Fri, 01 Nov 2019 07:24:23 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:22 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 05/10] net: openvswitch: optimize flow-mask looking up
Date:   Fri,  1 Nov 2019 22:23:49 +0800
Message-Id: <1572618234-6904-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
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
 net/openvswitch/flow_table.c | 104 ++++++++++++++++++++++---------------------
 1 file changed, 53 insertions(+), 51 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index c7ba435..a10d421 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -518,8 +518,8 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 				   u32 *n_mask_hit,
 				   u32 *index)
 {
-	struct sw_flow_mask *mask;
 	struct sw_flow *flow;
+	struct sw_flow_mask *mask;
 	int i;
 
 	if (*index < ma->max) {
@@ -538,7 +538,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
 		if (!mask)
-			continue;
+			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
@@ -695,8 +695,7 @@ struct sw_flow *ovs_flow_tbl_lookup_ufid(struct flow_table *tbl,
 int ovs_flow_tbl_num_masks(const struct flow_table *table)
 {
 	struct mask_array *ma = rcu_dereference_ovsl(table->mask_array);
-
-	return ma->count;
+	return READ_ONCE(ma->count);
 }
 
 static struct table_instance *table_instance_expand(struct table_instance *ti,
@@ -705,21 +704,33 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
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
@@ -733,17 +744,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
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
 
@@ -807,6 +809,29 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
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
@@ -815,9 +840,6 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		struct mask_array *ma;
-		int i;
-
 		/* Allocate a new mask if none exsits. */
 		mask = mask_alloc();
 		if (!mask)
@@ -826,29 +848,9 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
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


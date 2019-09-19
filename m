Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C763BBEDBD
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729801AbfIZIrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33420 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIZIrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id d22so1062715pls.0
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ftsflGWkrcHAHdXLSchXHv9raVuDy3sldKCC/X/xNbY=;
        b=e2Yo3Kt3puyP9tTLBHH56VHtEAJBoY7uLkb2UroHmbQZgNaIuxXDW2fNpRX4GeC1fT
         VAAMJtm8kKwUfm7TfeXiS9ZVWF9kX9MXPWKdr5zRP4+qstsAIGQ69BoA0CQlxXDZTi1a
         pnyjjnyDV7L6ZXzUY2K1Zv1idGhONkNHwL5FnmqmoAxHXIxPvF+1pUlyPHCnoqrXR1gq
         IraifGsXxUoZaA11aUU5U7+rTExBV2IjzfHO8YdcYZ7xYFDcPX99LlHd1ymNOIoaK3ci
         bGFhpsFTq/GmMN+/VrwaHPRrPqmyMuRH79vZA8x0AsHYUHJ3fzk3GZ5ltXfrZnj6qsn/
         oUbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ftsflGWkrcHAHdXLSchXHv9raVuDy3sldKCC/X/xNbY=;
        b=Fzn67FfjOW5OkPDq03z/b7XE3CZqPwVBoYUJanT7oixldsMdtOtCsVC6gBSfaLGUF0
         sSmMW1k7GxoLO08mwB7lE/tsSpagONSP+mAZsxfjoXr2Q7I65Ld/NULvrBE94t01l3uz
         8lpUbynQdt88miPv2Vn/VD9Ny9v6QO6QccIlAXFiNDrUlLUDZutkEEVhkPc0chcJlvqs
         a3M3HZeLq6vGwrBuX0JzxJ7EHcY/LbnVohBufuInB79PM0oap3b6MdhY2FXP9D3vT22K
         QYnQyGoUP7t29TyfucCJGEa6as9VjoNa5zh37sdxfkxDHJXHEhbXj60OdQ97AeS0M+4s
         81bA==
X-Gm-Message-State: APjAAAWepxS56FkQhi2C8DJWMANY+4ju91K+flWYuAy1fJvARiI3f/do
        oZOq5Xzte7SdbkFRlqhqVZ8=
X-Google-Smtp-Source: APXvYqwdDkKJyVhTgubhGWHcAwJGX3QGkNLBojJRPuUJRtGTXuCZ/B2l0/5RvYZYTixw9snR0aiaeA==
X-Received: by 2002:a17:902:7244:: with SMTP id c4mr2621981pll.178.1569487650499;
        Thu, 26 Sep 2019 01:47:30 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:30 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 5/7] net: openvswitch: optimize flow-mask looking up
Date:   Fri, 20 Sep 2019 00:54:51 +0800
Message-Id: <1568912093-68535-6-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
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

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 93 ++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index e59fac5..2d74d74 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -546,7 +546,7 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
 
 		mask = rcu_dereference_ovsl(ma->masks[i]);
 		if (!mask)
-			continue;
+			break;
 
 		flow = masked_flow_lookup(ti, key, mask, n_mask_hit);
 		if (flow) { /* Found */
@@ -712,21 +712,31 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
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
@@ -740,17 +750,8 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
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
 
@@ -814,6 +815,27 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
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
@@ -822,9 +844,6 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 
 	mask = flow_mask_find(tbl, new);
 	if (!mask) {
-		struct mask_array *ma;
-		int i;
-
 		/* Allocate a new mask if none exsits. */
 		mask = mask_alloc();
 		if (!mask)
@@ -833,29 +852,9 @@ static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
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


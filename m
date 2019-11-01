Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9E3EC49B
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfKAOYR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:17 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36522 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726889AbfKAOYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:17 -0400
Received: by mail-pl1-f196.google.com with SMTP id g9so4442511plp.3
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=99ayDtrGXogeYemVBZ8XosUkb5qFRdKURNlUuH0mkvk=;
        b=XLCZ4+G3rlEvjo41pe5K/B/gYE+MVta4weFFcGoJpxF2/LDaGtt6WhIMczbk2iLYng
         bSMY6ytLLW2fUdM73R73QPf41dUzApo2OoCBTajk4URs4AwOuSbu8YZx/8id7pZikKDk
         QOg/X1fje8BhKGy6WVesyymScb9/0Pk89VpN8k/ovY7NnVxGyhnExYlq6nbBpoQayT0/
         wpOer/WhwJ9rLkiX09AuzQ8O1rpVByNoZVrITxLGJHurWeXOk6jXyl73PKYafR4ve6Ao
         OZDqeozXRPbmfvkiCvRBexeStkwePuxbHQk1ERuEkW+Vs3zCM2JY7ebgz2U7SRjiaBD/
         fGtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=99ayDtrGXogeYemVBZ8XosUkb5qFRdKURNlUuH0mkvk=;
        b=b3mJaYd/XQVk3SyUfXQzVqyLBWM2h4TF1BYiWf5NJCOyDIocDOPHV1SW7bmKvC4XM1
         WQ1bNI1t3+qKL+C/7/5yBbYhCLIIZhrcNa2D/RTBtm2OMNjRh9zxDP3RblzwWVui9VdN
         7aeqCaiwMVe02R0oxt31GN53anTQDBhDuVj2UBITjkBjSgpK76qpbZGkL+HD0e0MS/N8
         W2PgYB8la73wE31JBWalfha7oBZ7iFm4URux0iBp1eU/CipimJEXQk9+BjPudfzkqicB
         5uItBmqKLzHIqUjMnZW2+3xDsI67vCr1ap57MDsSqFffPePoWEbF9iwQfvOS10HBEfUY
         lBew==
X-Gm-Message-State: APjAAAWCqhzeTgSzjwZzQ9Jvt9b67shMvtdarICXKoy6HlzulZ2i7KsJ
        /7umR0y5oAwBJ86pkTuVKvw=
X-Google-Smtp-Source: APXvYqzmWG71bMr0d5ph7h6xvhzZ5uJPFbhBwxPU55iW8lWTHhX6KSpvrneMRb48kbvA4TtVrfj1gw==
X-Received: by 2002:a17:902:76ca:: with SMTP id j10mr13135868plt.58.1572618256453;
        Fri, 01 Nov 2019 07:24:16 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:16 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 03/10] net: openvswitch: shrink the mask array if necessary
Date:   Fri,  1 Nov 2019 22:23:47 +0800
Message-Id: <1572618234-6904-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When creating and inserting flow-mask, if there is no available
flow-mask, we realloc the mask array. When removing flow-mask,
if necessary, we shrink mask array.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
Acked-by: William Tu <u9012063@gmail.com>
---
 net/openvswitch/flow_table.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 92efa23..0c0fcd6 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -694,6 +694,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
 	return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }
 
+static void tbl_mask_array_delete_mask(struct mask_array *ma,
+				       struct sw_flow_mask *mask)
+{
+	int i;
+
+	/* Remove the deleted mask pointers from the array */
+	for (i = 0; i < ma->max; i++) {
+		if (mask == ovsl_dereference(ma->masks[i])) {
+			RCU_INIT_POINTER(ma->masks[i], NULL);
+			ma->count--;
+			kfree_rcu(mask, rcu);
+			return;
+		}
+	}
+	BUG();
+}
+
 /* Remove 'mask' from the mask list, if it is not needed any more. */
 static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 {
@@ -707,18 +724,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 
 		if (!mask->ref_count) {
 			struct mask_array *ma;
-			int i;
 
 			ma = ovsl_dereference(tbl->mask_array);
-			for (i = 0; i < ma->max; i++) {
-				if (mask == ovsl_dereference(ma->masks[i])) {
-					RCU_INIT_POINTER(ma->masks[i], NULL);
-					ma->count--;
-					kfree_rcu(mask, rcu);
-					return;
-				}
-			}
-			BUG();
+			tbl_mask_array_delete_mask(ma, mask);
+
+			/* Shrink the mask array if necessary. */
+			if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+			    ma->count <= (ma->max / 3))
+				tbl_mask_array_realloc(tbl, ma->max / 2);
 		}
 	}
 }
-- 
1.8.3.1


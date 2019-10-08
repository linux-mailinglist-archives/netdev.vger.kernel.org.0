Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579DFCF8FB
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfJHL5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:00 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36395 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:56:59 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23so10136165pgk.3
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PSQ6n7rEGH9ybWq76aljx63raNUc8N3PNSc/VIn9XVQ=;
        b=lmuYwW1Hs1L5Boz44uCZKYWo204lVNQTbP61IpM7eXw7FT3ZECnl9ugVROQVJeNwOs
         C3TOI13+uDxPORHBCtg+vk54rNcEKsfSug5PmJdNdW8wI7X+yPCSD7zkbg1nUTScMqdq
         r1r32xV2OKSpYABX2Vi+7BImung2L3GKtt1PSEzbIGqvE8D/ccW381sS2OftF1HImPI2
         UYfA5MHTt6ZI2H1098CRFjoo7aX4FUACNi1BOOGO/BD31UUjsoI5QQmoFV4nVNSqM0eo
         Vi4c6YHOkcOmBpEuVp5qGEKDRqDb4ZZEBJxj8L7P8OU1eBn4oe/gIXF43EUqHm9z52no
         /0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PSQ6n7rEGH9ybWq76aljx63raNUc8N3PNSc/VIn9XVQ=;
        b=RNU3pN4zqn0JgUVTwyGCOE8oqqWs4x+YppuTBac2vkjqZa6Q3Ome0db5v0zIeCluFj
         2JkVlQc7ha0w8s5DMepMJY7CDAnp6TN7rBIda231AInrNCvyXsz9vcOhSbJbxpvEiPQL
         SHIr+CznCEcW2rsAMk8PB2O2hSIK4B/TC/DuJswa5n8Buh2jDtWb8dNfrcUiWBOxk1Is
         pHyUnQdHtNYTRwy8j+KCoKj63Bgxcwq2DqEEaw/9eq7TJBsJouxPr4IsRoQSn2m35gSB
         VRiNH+0tg6DyLqhhttajbECJhtP9o20jHa7dvNr2zA1c+sOdKFVznQE2aEw0ReLclJVX
         JC1w==
X-Gm-Message-State: APjAAAXjY0W3ZHZS1dCnYwZQup2EclNUFdmCNbkLcetiMUyK0U1/hNAr
        GrhE2ytBJnJFEUgH68U2GGLNctXP
X-Google-Smtp-Source: APXvYqxCRBOAVAarXBXBZDM1WAS47eHSOxIZUrHJPWsw884RzG0DhH/KXf6EGuhTaaFc5jU8FsG6qw==
X-Received: by 2002:a63:5615:: with SMTP id k21mr37006318pgb.323.1570535818499;
        Tue, 08 Oct 2019 04:56:58 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.56.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:56:57 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 03/10] net: openvswitch: shrink the mask array if necessary
Date:   Tue,  8 Oct 2019 09:00:31 +0800
Message-Id: <1570496438-15460-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When creating and inserting flow-mask, if there is no available
flow-mask, we realloc the mask array. When removing flow-mask,
if necessary, we shrink mask array.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index aab7a27..ff4c4b049 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -693,6 +693,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
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
@@ -706,18 +723,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 
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


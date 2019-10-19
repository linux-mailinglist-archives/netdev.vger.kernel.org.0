Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB4E9560
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 04:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727261AbfJ3Dsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 23:48:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37535 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbfJ3Dsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 23:48:40 -0400
Received: by mail-pl1-f195.google.com with SMTP id p13so326992pll.4
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 20:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fuVFys6wHzdsbZHBCtec0jlc10d6haIBSzRPctXWZCM=;
        b=VvVKl363fNAcDnGzKNEeE1EOYFOCTUL6rgSqsfZ+ixWcMgsZKr4Kr+/Pr7ok7U9NAL
         57k6ypJ/qkgvARgUXWXsBDhs6J4EVAM+11XQqLKeYhhTkebNOjSp4HgAicRh/1B4BMHz
         X8X4EecKC6L29oViYOi5AL+AR7TES6C2TvzlxddnGk61hjvGBIpId1qqKjNHlASam29M
         TbJrEa/eYGjGbTRtvLprL8e/ZgYvrcgly0hNLpI0CW8Bg1hXypDAmOj31pRPukANHy6d
         UldkX7oPeFXBWbGzj9UtBRn+yixZ4gJ4UFdjZ3FoNhXZBMKs9tZ5KpKaniufQAGmD43Z
         5sIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fuVFys6wHzdsbZHBCtec0jlc10d6haIBSzRPctXWZCM=;
        b=FQGYWqqW/nlIR9ZBl3PYqIZVP6RB9Q0aIc9ZQ6Teazryn45EjyVm+zVogrcfKv5wfo
         MPqvuhO9WotPaKfIn3bH9pyefwkdZ6axPaxoOvqejhKFa0/v9fTTWPVYKQUWNTFzsFua
         BUIE/VvKNELpVc9g3zDvCPlw0znrpOCdNWKsKvUQF522UYs+n6CAZl7/aVAuzHldQLWa
         JPA8MGX5WLGwpG886nItR90PflWTstm3fNerFfgrNHagX/dMVfjvpE7c+JMJG+DSw/DL
         gG03GwdJWq6G2r62ZaGqRgs5V67UedK/SNanOSa0IFHkHYBQQqToGGmGmjh9Uo4/mCjB
         wiww==
X-Gm-Message-State: APjAAAUibfMapea0FEkGneTMmWDDDaOrDJpSA5CziuuR75XGtbbKOtwB
        uyIG3BmHxbRgb0epZ8UazFo=
X-Google-Smtp-Source: APXvYqwONzmiVEcd1NdegNHZy2Y5UH0mpkZJYewGP3OD/V18N84vXfz5IVxzB0ZO6p9h6M/ami+Yvw==
X-Received: by 2002:a17:902:7885:: with SMTP id q5mr2167148pll.317.1572407319448;
        Tue, 29 Oct 2019 20:48:39 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id l22sm632390pgj.4.2019.10.29.20.48.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Oct 2019 20:48:38 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v5 03/10] net: openvswitch: shrink the mask array if necessary
Date:   Sat, 19 Oct 2019 16:08:37 +0800
Message-Id: <1571472524-73832-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 0d1df53..237cf85 100644
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


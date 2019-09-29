Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586DCC1A1A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 04:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfI3CJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 22:09:06 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:35777 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbfI3CJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 22:09:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id 205so4682224pfw.2
        for <netdev@vger.kernel.org>; Sun, 29 Sep 2019 19:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LRRofKZdw88izW3jLkOBrYfzBBphlunfCEFOpEUKOZc=;
        b=FThiTkpz1jdeTcngb9zc2rR37hNxd3ZF6kT3nnLWr911t5r7HLCduSFUPCQ/meEpJI
         U3WItU/UKbNY4syojIbBzxNV1cnwWd8WoaAnoJrZ7YcyMK4WmeUNtTfe7Hy/0HjPLpfE
         48l8Vj2LayjibjDThA1hDL8K+VAnjkv6YTGwZ8hSZFcYSksIswhlf82miXYRQENc9f7a
         kQ2r1Cd61DOvXVoTSowFCTwR6/xrRbliwwmwt9KCjalMQzYy5rLn3lgFuAj3oilelAei
         qIisuY/M7fOtUoR6shgi1Ga10cLelJ4aizgctlmRcP09mZwzVDuVHZCvqaGUwuh/PTTR
         8c+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LRRofKZdw88izW3jLkOBrYfzBBphlunfCEFOpEUKOZc=;
        b=kPSJoqEo7QcC4rAT2WbmYpXcIvI31Odc1fTXhcaOsDGJ+nslnryNAhQpxhcQoIUp+l
         x/gZXXTr1sRoDj7Gc23eK71kxtmrS0/DytR7Sw3hB1n7ZYJKgCokw1t6IQxWIX6rYvMx
         p5SrmKnPD76YUYysTwJBiqyvvnAMcavYJn0/CNKEx9lN9tgDG2ePDJE3qlE0luqO+XOU
         r98GDoEp1YeTqWY+cTBpA1pol1ca/BRO2l1VXOHzISycSG4bKgw3bFaJFqjOZAFpLW+a
         Ijj0mlXA7Gl9SZ6FnGqb4kqDCkcJt6qFyZyeJSV/WLa6SIbzrqflHirIpUMlyW2YdkB3
         bULA==
X-Gm-Message-State: APjAAAXpnK+pZmBctMIlwjSXrfxx8DwJRwHYB5gOSDqdCMDswUwvHfCn
        hnW/AKLEKlOaaEoztssmO66VSghU
X-Google-Smtp-Source: APXvYqzZCDauxWDRk3rv2PGH6+UUdT2oX6N7Mn/Ry/0hTp0RSF8sqP/gQ+1uRMUiQzrq7/7RTWzwTw==
X-Received: by 2002:a17:90b:8d1:: with SMTP id ds17mr23644381pjb.105.1569809345355;
        Sun, 29 Sep 2019 19:09:05 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id d69sm9941635pfd.175.2019.09.29.19.09.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 29 Sep 2019 19:09:04 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 3/9] net: openvswitch: shrink the mask array if necessary
Date:   Mon, 30 Sep 2019 01:10:00 +0800
Message-Id: <1569777006-7435-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1569777006-7435-1-git-send-email-xiangxia.m.yue@gmail.com>
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
index 99954fa..9c72aab 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -701,6 +701,23 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
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
@@ -714,18 +731,14 @@ static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
 
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


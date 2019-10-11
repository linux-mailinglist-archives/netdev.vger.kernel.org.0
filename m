Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9624D422E
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbfJKOFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 10:05:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41104 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbfJKOFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 10:05:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id q7so6155441pfh.8
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PSQ6n7rEGH9ybWq76aljx63raNUc8N3PNSc/VIn9XVQ=;
        b=Df75eBTRx6W/PuV5SSIrtAK/Zjfa5KbYvtvkf5Oo9XOBZrzUyOGxyBspGUQeI28pwd
         gi6SiuDYRnyJV6lOC3UipC70i0UVlMd6+LFRz4iKmHU1eBY5uYhpkUqpWZur2D2zsrHr
         tNB8nAcD2org0aXvBXhuCMzmAGckqrnmCOcl9AEkssRth0TvBKvjJtmEDufm0EufDJx1
         RT60VcoDJgpPMqDU113RePbJCv7Uw2c5lyGrpP1C0LsrHipA4cENDJtaU24fnEWZPCOh
         WZyKqgPQhj7XIgUu9i9BUcu9mJihSV3fr4Y6yYxNjFZa2q5RzWxLcA9ytLjJIv0n2zRz
         j4cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PSQ6n7rEGH9ybWq76aljx63raNUc8N3PNSc/VIn9XVQ=;
        b=mqwp/8nezvyBwq8u0li9uKzcRo4Gh2DJuAQ0WGbMFPrkX69+StzPbR5qtncCYU7ocC
         S4SLOtGFcN7ttiROM9RT00ULEvSiO2OpgcbWrKeM6yjybpRu6JwK4BL61dt3sISOpzsp
         uwU08OBxDGzQEKhi23UdRcId/jt3kSZBeUi6UDKJNDmNC6Xbno+OrDHM1PcH/RSw88xU
         KBRA/kEV3vEkUd487RkVBlt+2/sHIDmEGj2RQtpmlhUZf22FQFRkJx2FgNeN/+5DZq5H
         QR5oWLll8dCDcAlS0fvjjATRthI52Ktd3wVatzvFaqLumTmCe65fAIiDLxZEccaN3AM5
         WlKg==
X-Gm-Message-State: APjAAAXMsIAMiigFZaC/Fz/xx5cHEQrTiV0RsEnYHvaJDOeNH/MTOBcd
        B3VwJDMLpORmvNFpVUq8l0E=
X-Google-Smtp-Source: APXvYqwfsrayuLJyR0vUm6PlhbZqiBep+Vtj2hjQRV9pqQD+VNDSfMex03Kf/Q7nxnXVgHi1Z0gFiA==
X-Received: by 2002:a62:e807:: with SMTP id c7mr16348368pfi.18.1570802746957;
        Fri, 11 Oct 2019 07:05:46 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.165])
        by smtp.gmail.com with ESMTPSA id p190sm11499392pfb.160.2019.10.11.07.05.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 07:05:46 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 03/10] net: openvswitch: shrink the mask array if necessary
Date:   Fri, 11 Oct 2019 22:00:40 +0800
Message-Id: <1570802447-8019-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570802447-8019-1-git-send-email-xiangxia.m.yue@gmail.com>
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


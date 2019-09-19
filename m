Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 145C3BEDBA
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfIZIr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 04:47:28 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34489 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726215AbfIZIr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 04:47:26 -0400
Received: by mail-pg1-f195.google.com with SMTP id y35so1213150pgl.1
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 01:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LRRofKZdw88izW3jLkOBrYfzBBphlunfCEFOpEUKOZc=;
        b=qEbPCTkWjV/3ty9+tQhapgXBnZb6XZbv1kFegwiDKcrKG8ucgD1emh//DYIAX0utWf
         Xc8I/PobDNr+MgrQ/brD80vpv+EtSr2HrpwazJphQ5Jq9a+tz9LoQ4agvRRLTLpbI/QG
         Azaw9OSyZqr5gkPZf2/LI3VI/y6GtCTQL3G2ZAUtZM5ITOAm1wNR5B+U4y9/Wm+r/LSE
         IJgeBgSl4pI2Fi0RvJD410IRMY7yrFqXz2aDpnhuw26t+TqO6bO/fAZXTZFO5dTZyiHq
         Pol4k/Dck7LyJGMQTbDyGAR6XwQP6CRpM4tw4sUOZyLJhw56hrGrxOavT+V89vE8xPQZ
         fUig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LRRofKZdw88izW3jLkOBrYfzBBphlunfCEFOpEUKOZc=;
        b=r763zctUEIkKYH16/g/QRLpHLVm+S/Rclk8pRLsPwviqCui3WEAQTCqs9vuI3WhdPD
         XuxfqICq8UCN4vp5bPl6JOl4XCNEZe7H56X/1Sqi9CjW0769dy/qbTAhoiMln2riSB2W
         doSxqvR9OGd7yEupIjT1zKA07nV8pyF0WFtCVmzM5ZuONKmMKY5EtEYgIDoDBrIANJqm
         aVR8jDKza2SFOvYfUXIGvAPqZ/mZBPJ/tuW/dRukjjlksB3fYmg8kG9jSER1WhkHjdVo
         xl/AjSFI8HKbVrg6TmbLFcwVm3nymWrOIoboHn87mfD2DAoni1JtUenMTSSW+1cjBOvW
         5M6g==
X-Gm-Message-State: APjAAAUm/3OLLg6IjxjO5A9v1d+Hcr7vBxuWmz6ufFvELerHj/1GtMLT
        P8SAvqqZQI+Sj2BAY+z+MCg=
X-Google-Smtp-Source: APXvYqwqXSi3x8LDbO2Pd29sHynaHaaxX9ospMyHXJ+troKm6t5EF83PrUQpzjpAgvWNH7109pQ3mg==
X-Received: by 2002:a65:67ce:: with SMTP id b14mr2320346pgs.68.1569487646197;
        Thu, 26 Sep 2019 01:47:26 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id t12sm1340513pjq.18.2019.09.26.01.47.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 01:47:25 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     pshelar@ovn.org, gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next 3/7] net: openvswitch: shrink the mask array if necessary
Date:   Fri, 20 Sep 2019 00:54:49 +0800
Message-Id: <1568912093-68535-4-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1568912093-68535-1-git-send-email-xiangxia.m.yue@gmail.com>
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433B0CF900
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbfJHL5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 07:57:11 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37189 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbfJHL5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 07:57:10 -0400
Received: by mail-pf1-f193.google.com with SMTP id y5so10648601pfo.4
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 04:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Nv/aO+L3ry1z8o4KOGaamVvHbbUtyFA24jQIdHOGjxE=;
        b=EEh2iM7u8RwoHk6kfGrzhRkFZSvEXXbp56ZpIIl+MlkE84YpJACh865gnB+m+eYNLv
         XGfEwwfi9uoCS/bCPKawLy9orNZVL35DvpwDelwqcMIYp0yRQMymjXus+Lqtz5mxU3ZL
         g4OnaCfDaInZ7+r/ZQDSX95D3GDWgx0mxM4OP30O8Cd+WPA2wjhgaGAtYfn1AoS0u2lx
         OZjsl1Pvid/JqqNQLpU7ewvGI0G+2wzS61ypztbdMNhNq9lRJgwPPVXDbgCb04hshgIe
         qIEtpnvcna1lA+nu3FOiWQE9lrHysQFObGgxh3T8rnufxJYLiT8+MdEgvJAiN2+JMj2p
         o9uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Nv/aO+L3ry1z8o4KOGaamVvHbbUtyFA24jQIdHOGjxE=;
        b=dcVhZeeTgDIQ0NFPfzgCk0dd2gRnS6yc1KF5CFKw352eAksZuAU2y2f2uKDVhvhxeZ
         DqdeWi/vg5s/nMUeW9d8ZP7oRXpLBK96yrFdr+359bqYYsXm8EwQ/oYZwipYf4j2+ZG6
         EqS/DCBxiPIigXGUIk0U6bGBC56jN352antBFyDciTRV0ep58TTmbiCrRuI5tDY/GV1S
         IkS9kvoXVwa1J9OC8J80o6FQsO1sFqtMaMPHXomU51N7FMHB1FIlf4/A1r6JjLiyoefX
         5rtE99D72JF9F0SFU2dvu1UVx73kvuYx62K+VWi8zMgIwtcPWms9qMBvaMfR2aUT0XTE
         83dg==
X-Gm-Message-State: APjAAAXZJW0bXgH4wF0AjF1r2jvqDXMmXRt6zGz0Z/1fiRgMQ3boQkFO
        US5bD+RoSRISkP8Jhfn7hTc=
X-Google-Smtp-Source: APXvYqzKaH8BDXQiD0BQvNATIMNp8XyDteENq2ui716I76qzw3xJVBcOnjWQn3YEd3rcBbQ64NFP9g==
X-Received: by 2002:aa7:9735:: with SMTP id k21mr39646557pfg.174.1570535830237;
        Tue, 08 Oct 2019 04:57:10 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([203.100.54.194])
        by smtp.gmail.com with ESMTPSA id b14sm18149932pfi.95.2019.10.08.04.57.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:57:09 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2 08/10] net: openvswitch: fix possible memleak on destroy flow-table
Date:   Tue,  8 Oct 2019 09:00:36 +0800
Message-Id: <1570496438-15460-9-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1570496438-15460-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When we destroy the flow tables which may contain the flow_mask,
so release the flow mask struct.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 007f7cd..bc14b12 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -295,6 +295,18 @@ static void table_instance_destroy(struct table_instance *ti,
 	}
 }
 
+static void tbl_mask_array_destroy(struct flow_table *tbl)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i;
+
+	/* Free the flow-mask and kfree_rcu the NULL is allowed. */
+	for (i = 0; i < ma->count; i++)
+		kfree_rcu(ma->masks[i], rcu);
+
+	kfree_rcu(tbl->mask_array, rcu);
+}
+
 /* No need for locking this function is called from RCU callback or
  * error path.
  */
@@ -304,7 +316,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 	struct table_instance *ufid_ti = rcu_dereference_raw(table->ufid_ti);
 
 	free_percpu(table->mask_cache);
-	kfree_rcu(table->mask_array, rcu);
+	tbl_mask_array_destroy(table);
 	table_instance_destroy(ti, ufid_ti, false);
 }
 
-- 
1.8.3.1


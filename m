Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8324224829E
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHRKKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbgHRKKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:10:33 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3247DC061342
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:33 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id d14so17663698qke.13
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=z1hv5X0oAAXymBLyMe/KjRiVnwYWlYEP5dKwt6nuRgU=;
        b=iiz2sZZDbhClu28YMtPdooOoXgFVhdAPkY4hv4mYaVDhmaMYP8AmPnL4CGmYF/hUHm
         bQAniB4TDVusHzMena/x5LHyQzPK/uHEU2NF+KM/lLfIN0ZmnGvBh55z3sS/vPdc8S7D
         PRMCjIip1CHozjrDTID4kSK0bBt9Dxb6kXOc1E6iOMunfDx2uUD5qQGIcMXQNYgUY/uc
         3n3fWd5jaqimCN2SxetskxTMX02kjH51LKphiqGu6bvWTrNW6Pk1TNMF/hFg6ZdTy7jx
         rBzT08VoxFML8nkB0T9r2f+p6mH7eELvImkeRI5SBli1AyAgp10xW4T/JSB+YKRHKvUd
         vdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=z1hv5X0oAAXymBLyMe/KjRiVnwYWlYEP5dKwt6nuRgU=;
        b=Gn6rURtwd7D96uoOqfOoNPfyAS5Jd40lcei1fW8zPVUPqOJ0Lm+vqTVp/OxKZkiZhP
         /C5itMw6Se0wAuppvTECK47VSBB5JV/vYDtNdwmCJi78Joie+sEaE5JgsnVIRqQYEXxY
         JVO07IahNqahs+MX84+IF5+pSFC1Cxdoxer4hFvt1b0qbopC2UePeXiANNxpjD5arIvn
         huHDiuQIE+cA+cAaGMTWaOQo5IuceKDBl2J1BxndlK7l8Ap+xdL7cqb+oeChzMenvTsm
         c0B5SKAW7YQWvsYAG52hfYTHHXRkVJ3I39EWqFefgg2rH1FjP16R2QHdS2oSvA2rD6HB
         hDwA==
X-Gm-Message-State: AOAM532yXwGqYR7zMysjG5pTf/glddYiBOY32uhCAzz8mS/+AuM61pDG
        ht9ntovLLQdGeOvn3umQbUo=
X-Google-Smtp-Source: ABdhPJw0uRuNvenq/iueaGopTUFMtIoO3tP4RoJZtWALWvFoYSe5HQ5T6jYG1FDmcwq1X0wDHL7xBQ==
X-Received: by 2002:a37:62c6:: with SMTP id w189mr16380187qkb.106.1597745432515;
        Tue, 18 Aug 2020 03:10:32 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 20sm20632139qkh.110.2020.08.18.03.10.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 03:10:31 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     pshelar@ovn.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v1 2/3] net: openvswitch: refactor flow free function
Date:   Tue, 18 Aug 2020 18:09:22 +0800
Message-Id: <20200818100923.46840-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
References: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Decrease table->count and ufid_count unconditionally,
and add BUG_ON in flush flows function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/flow_table.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 4b7ab62d0e1a..f8a21dd80e72 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -459,18 +459,14 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
 static void table_instance_flow_free(struct flow_table *table,
 				     struct table_instance *ti,
 				     struct table_instance *ufid_ti,
-				     struct sw_flow *flow,
-				     bool count)
+				     struct sw_flow *flow)
 {
 	hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
-	if (count)
-		table->count--;
+	table->count--;
 
 	if (ovs_identifier_is_ufid(&flow->id)) {
 		hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
-
-		if (count)
-			table->ufid_count--;
+		table->ufid_count--;
 	}
 
 	flow_mask_remove(table, flow->mask);
@@ -495,10 +491,13 @@ void table_instance_flow_flush(struct flow_table *table,
 					  flow_table.node[ti->node_ver]) {
 
 			table_instance_flow_free(table, ti, ufid_ti,
-						 flow, false);
+						 flow);
 			ovs_flow_free(flow, true);
 		}
 	}
+
+	BUG_ON(table->count != 0);
+	BUG_ON(table->ufid_count != 0);
 }
 
 static void table_instance_destroy(struct table_instance *ti,
@@ -635,8 +634,6 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	rcu_assign_pointer(flow_table->ti, new_ti);
 	rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
 	flow_table->last_rehash = jiffies;
-	flow_table->count = 0;
-	flow_table->ufid_count = 0;
 
 	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
 	table_instance_destroy(old_ti, old_ufid_ti);
@@ -954,7 +951,7 @@ void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
 
 	BUG_ON(table->count == 0);
-	table_instance_flow_free(table, ti, ufid_ti, flow, true);
+	table_instance_flow_free(table, ti, ufid_ti, flow);
 }
 
 static struct sw_flow_mask *mask_alloc(void)
-- 
2.23.0


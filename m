Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F392C251157
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 07:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgHYFIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 01:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgHYFI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 01:08:27 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999FEC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:27 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id o12so5265730qki.13
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QwU96szKOCY7q37dXYLFd1q36qldJ6vyX8D1sJRJQZQ=;
        b=DkV0cHwYaNgmxHoqv2UfaWQ6aisJqtELikwP+r2cSOXsXFvq734xqc6d084CbWT9mB
         NpEc8oxQPu6fimrowchvAFJ+N7MWVlJtTEA7NDGdwa+szxel5iz0VlzJvdeJ8E9EPEWo
         KSMX12uMyweiogCaLug2JcXogIuoyNFpj8q0VSpMda2nXYhMUzqRICUIxjg6YgG9UKAZ
         kRFSt1q557YAbwZBOWTyGlTgIpmbYHnpHzCYUcFeYzfVmMM3t8TK3daFi8wM0t8ukyjS
         gaA7IN4hT5Ocz9mjt3y8ZlhNg1Z1AFqZMqnChgas6BpRPWNjwBh/LlMSQYcRWVNfAcXH
         SxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QwU96szKOCY7q37dXYLFd1q36qldJ6vyX8D1sJRJQZQ=;
        b=MKssUkTqGoCTyy3lOcrqG1Aq3T7xhlzTBrVvVjNc9zYPlTdBnDdk8XznkZF6zsXMVn
         oMZLZ5FkopE8zq+KPzdMkugrqgqyeKpuquRZYItnc6z/+fy5AgmLVJWFeBTDx38Mm9wt
         cIBCmT1G/xjnLOqHo75L1MiKhHYSs/QOidJsQH2oAU6KWK+2r7FoTnlbJFqk3ByVYnpT
         v1deNszkMVn8A9RHp1K9EfZF+9IWuMoY7P2+1skOQRdmrQJ7w1Hpm7r1GAjnEYLvKgJp
         dtzeGW85VV0+YB6k8yI7XCRx6TK8KndG1UxR+/gKiIdTLdhTbRfJ7VHCiafOKaC2fYM+
         zxEw==
X-Gm-Message-State: AOAM531CKOI4hioq84fiyrgyUZ5o/pAyj9y4syB/LhH8CdWkCUVQU2rh
        Nzzgs7gEWT624dCV384V/zc=
X-Google-Smtp-Source: ABdhPJyDnereKHbpXG7XXTguDOnGRTi2FAzMFs6NRiZiXYNzVTahuDwi9X7hwj4UqSR6vT2ng8W71w==
X-Received: by 2002:a05:620a:4ed:: with SMTP id b13mr7940838qkh.493.1598332106938;
        Mon, 24 Aug 2020 22:08:26 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 16sm7261723qkv.34.2020.08.24.22.08.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 22:08:26 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 2/3] net: openvswitch: refactor flow free function
Date:   Tue, 25 Aug 2020 13:06:35 +0800
Message-Id: <20200825050636.14153-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
References: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Decrease table->count and ufid_count unconditionally,
because we only don't use count or ufid_count to count
when flushing the flows. To simplify the codes, we
remove the "count" argument of table_instance_flow_free.

To avoid a bug when deleting flows in the future, add
WARN_ON in flush flows function.

Cc: Pravin B Shelar <pshelar@ovn.org>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v3:
use WARN_ON instead of BUG_ON 
v2:
add more details why refactor this function.
---
 net/openvswitch/flow_table.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 4b7ab62d0e1a..98dad1c5f9d9 100644
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
@@ -495,10 +491,16 @@ void table_instance_flow_flush(struct flow_table *table,
 					  flow_table.node[ti->node_ver]) {
 
 			table_instance_flow_free(table, ti, ufid_ti,
-						 flow, false);
+						 flow);
 			ovs_flow_free(flow, true);
 		}
 	}
+
+	if (WARN_ON(table->count != 0 ||
+		    table->ufid_count != 0)) {
+		table->count = 0;
+		table->ufid_count = 0;
+	}
 }
 
 static void table_instance_destroy(struct table_instance *ti,
@@ -635,8 +637,6 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	rcu_assign_pointer(flow_table->ti, new_ti);
 	rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
 	flow_table->last_rehash = jiffies;
-	flow_table->count = 0;
-	flow_table->ufid_count = 0;
 
 	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
 	table_instance_destroy(old_ti, old_ufid_ti);
@@ -954,7 +954,7 @@ void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
 
 	BUG_ON(table->count == 0);
-	table_instance_flow_free(table, ti, ufid_ti, flow, true);
+	table_instance_flow_free(table, ti, ufid_ti, flow);
 }
 
 static struct sw_flow_mask *mask_alloc(void)
-- 
2.23.0


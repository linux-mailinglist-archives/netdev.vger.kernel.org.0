Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFB2F258E63
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 14:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgIAMnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 08:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728110AbgIAM3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 08:29:15 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FD14C061247
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 05:29:15 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id b13so386809qvl.2
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 05:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DFLtCp2O15rju9BR/oL6lxBkSxtDKRT0NnIXl1QlTg0=;
        b=TbBohfPROTk4wUyrL3iHsMKzIOl7yaPBz3xMDVoZHZxQ219PKFdx51eN/U4ai2jesL
         REQ45TQjAcpEA3se+7KCLBwI8C3ViW8LHPJRMX1gyVzqELNg6FSXUPQMsmBWul6qRiFq
         x2WmHQz8+Sya9l335do2x5STsXgLc2bDNXzwxdNujsA6LGK83pCfNsx2yWRRaeVjJ1r0
         pfp1c4C/rE/4zBt3awYFNS65FXmRJ1N6fB1aVTkCAhavaWzgMP7TNwW3rHzQWgM3aOwC
         abjyOEIjy0qV0qW3xrmpiQkh4YZdiW+hu8DXeY0jd5HkS62RM2LeohfqGHpJbjXIwwYt
         25IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DFLtCp2O15rju9BR/oL6lxBkSxtDKRT0NnIXl1QlTg0=;
        b=D881vK3L0rKmmZzNk6MxJv82DtW6O8AW516D9mjDHCbTzVROk7ofcWvUhpLh+dHQUr
         RL0BzoaZlekLl2YHze+yyObz0D9f0Bijhj6xqaJrZjhTtOUZfdkGWfaHK76CPk2BWrbK
         lJLY5dcmCUZ0z0N5bpEyO1Ll+AZmCtCcnKorMafN5Blzea8lvhhPvP8XoFJXa+3VWnrB
         mblsveCOcpSYYQcK+dQYJDII6tAeOmVV4uj3pT7g80nzrWJSKAFN3U8gywpaW/FjOqYf
         VQmaPr6ZGKGA7hAO65lo+y3XzZ5GL8h4D2i0u4sFpTFXuTHzzw6p5HCx19avPZZDyNCJ
         sGdg==
X-Gm-Message-State: AOAM533Zm4Z8R3XT9+F7QCyVnekU53r4T2ZvkH1QNxbWmF95FCoJYSEy
        fXLyRLIZA3gHGqxRvKXry4Y=
X-Google-Smtp-Source: ABdhPJyYHjTiHpoz0QHFglzLLpdN6cUx2co0mVrMelDQv9H5GdcaCScxUID/uFa4RbSnaZ5tY4+H7w==
X-Received: by 2002:a05:6214:1045:: with SMTP id l5mr1575263qvr.110.1598963354418;
        Tue, 01 Sep 2020 05:29:14 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id q35sm1174220qtd.75.2020.09.01.05.29.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Sep 2020 05:29:13 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     sbrivio@redhat.com, davem@davemloft.net, pshelar@ovn.org,
        xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v4 2/3] net: openvswitch: refactor flow free function
Date:   Tue,  1 Sep 2020 20:26:13 +0800
Message-Id: <20200901122614.73464-3-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
References: <20200901122614.73464-1-xiangxia.m.yue@gmail.com>
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
Acked-by: Pravin B Shelar <pshelar@ovn.org>
---
 net/openvswitch/flow_table.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 441f68cf8a13..80849bdf45d2 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -461,18 +461,14 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
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
@@ -497,10 +493,16 @@ void table_instance_flow_flush(struct flow_table *table,
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
@@ -637,8 +639,6 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	rcu_assign_pointer(flow_table->ti, new_ti);
 	rcu_assign_pointer(flow_table->ufid_ti, new_ufid_ti);
 	flow_table->last_rehash = jiffies;
-	flow_table->count = 0;
-	flow_table->ufid_count = 0;
 
 	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
 	table_instance_destroy(old_ti, old_ufid_ti);
@@ -956,7 +956,7 @@ void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
 
 	BUG_ON(table->count == 0);
-	table_instance_flow_free(table, ti, ufid_ti, flow, true);
+	table_instance_flow_free(table, ti, ufid_ti, flow);
 }
 
 static struct sw_flow_mask *mask_alloc(void)
-- 
2.23.0


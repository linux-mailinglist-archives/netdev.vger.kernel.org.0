Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1A4C24146E
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 03:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbgHKBK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 21:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727002AbgHKBK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 21:10:28 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E280C06174A;
        Mon, 10 Aug 2020 18:10:28 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b79so10277309qkg.9;
        Mon, 10 Aug 2020 18:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=m9G3yTxUY9hZ7Luzv3PMinQ0YA07qzfItrdZCzOCvwE=;
        b=C2gFF8+iAA+7RjKUip8/el1dJJPoVvrQ2i7IN/dNSgxhIgX46kHQAq9ViWNe0WcpdP
         kG0IzrZbY3O+ptACjMZazozrCqp6UaopA2zf0n0TMpEA1fJYQNdE0crRPqd9JbYQsxFL
         ZqJ2UXxQnOg60aUK7HRO2exWPPwrKb8/GZ20hdI4TnBy2TjPb3A2sarBTKtzfTTHVY1a
         6GeIg0bPADnLNOKCrfDSsvqWxcCmr0byL91KnD/rjtNa6je+AM9YKOXNFPJzH+MMV5Fd
         MuI4ACMoyXywp6p+vx0yvz3BWGrrDWl3UeY7n2jOWe7eEHNKafZS+7n0CAJuKkNOiAZg
         paBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=m9G3yTxUY9hZ7Luzv3PMinQ0YA07qzfItrdZCzOCvwE=;
        b=ozK7eOZztFb9LNMXG/ryEyrhT6h93Y1Nd6fI8E8r7AYnCFVSfnuCipOy3XL3x9I+kU
         rIcONJdVW7rCDCXUT+NBMGDLJjy7dW8wC4hWnbq2mWi7k3Pa9r116+D75MYHkUggzQPD
         3RDYT3YvcHWzNhDEkYMJ6JctfVfXCQ9G8pLAPF5bRXabRYF5gTrcniRJGKi4Av7aDfDg
         DBvJveOhwHruzGi8vSF62LIzhzVhkcGXHaLma1QxJYvL2TJ3FgLBDZwc+Al7pnqQLi9I
         PW88jAvsG6aecp9LaqLLVCcs0joyC5ktUtzfRaFZQWR6fAURzl/DYBsxjyALmpaKUewr
         dg7w==
X-Gm-Message-State: AOAM530kribbPy7NXkCnsOUFxkt3PNUJcTk1LqRM/kUL9QmbCVqLkkaH
        esrtCrgjgNcEUIg2/grZmEo=
X-Google-Smtp-Source: ABdhPJzVK5ixFfTj3QJmTswzQSMBlbPFNbBE7b6aUY6/6O9jMMxd+ulZaqXDB7Qm+3vAJHOYb8gm/A==
X-Received: by 2002:a05:620a:234:: with SMTP id u20mr27789752qkm.54.1597108227157;
        Mon, 10 Aug 2020 18:10:27 -0700 (PDT)
Received: from localhost.localdomain ([111.205.198.3])
        by smtp.gmail.com with ESMTPSA id x50sm11728864qtb.10.2020.08.10.18.10.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2020 18:10:26 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     joel@joelfernandes.org, jknoos@google.com, gvrose8192@gmail.com,
        urezki@gmail.com, paulmck@kernel.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, rcu@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH] net: openvswitch: introduce common code for flushing flows
Date:   Tue, 11 Aug 2020 09:10:01 +0800
Message-Id: <20200811011001.75690-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

To avoid some issues, for example RCU usage warning, we should
flush the flows under ovs_lock. This patch refactors
table_instance_destroy and introduces table_instance_flow_flush
which can be invoked by __dp_destroy or ovs_flow_tbl_flush.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/datapath.c   | 11 ++++++++++-
 net/openvswitch/flow_table.c | 37 ++++++++++++++++--------------------
 net/openvswitch/flow_table.h |  3 +++
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 42f8cc70bb2c..5fec47e62615 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1756,6 +1756,9 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 /* Called with ovs_mutex. */
 static void __dp_destroy(struct datapath *dp)
 {
+	struct flow_table *table = &dp->table;
+	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
+	struct table_instance *ti = ovsl_dereference(table->ti);
 	int i;
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
@@ -1774,7 +1777,13 @@ static void __dp_destroy(struct datapath *dp)
 	 */
 	ovs_dp_detach_port(ovs_vport_ovsl(dp, OVSP_LOCAL));
 
-	/* RCU destroy the flow table */
+	/* Flush sw_flow in the tables. RCU cb only releases resource
+	 * such as dp, ports and tables. That may avoid some issue
+	 * (e.g RCU usage warning).
+	 */
+	table_instance_flow_flush(table, ti, ufid_ti);
+
+	/* RCU destroy the ports, meters and flow tables. */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
 }
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 8c12675cbb67..513024265294 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -473,42 +473,36 @@ static void table_instance_flow_free(struct flow_table *table,
 	flow_mask_remove(table, flow->mask);
 }
 
-static void table_instance_destroy(struct flow_table *table,
-				   struct table_instance *ti,
-				   struct table_instance *ufid_ti,
-				   bool deferred)
+/* Must be called with OVS mutex held. */
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti)
 {
 	int i;
 
-	if (!ti)
-		return;
-
-	BUG_ON(!ufid_ti);
 	if (ti->keep_flows)
-		goto skip_flows;
+		return;
 
 	for (i = 0; i < ti->n_buckets; i++) {
-		struct sw_flow *flow;
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
+		struct sw_flow *flow;
 
 		hlist_for_each_entry_safe(flow, n, head,
 					  flow_table.node[ti->node_ver]) {
 
 			table_instance_flow_free(table, ti, ufid_ti,
 						 flow, false);
-			ovs_flow_free(flow, deferred);
+			ovs_flow_free(flow, true);
 		}
 	}
+}
 
-skip_flows:
-	if (deferred) {
-		call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
-		call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
-	} else {
-		__table_instance_destroy(ti);
-		__table_instance_destroy(ufid_ti);
-	}
+static void table_instance_destroy(struct table_instance *ti,
+				   struct table_instance *ufid_ti)
+{
+	call_rcu(&ti->rcu, flow_tbl_destroy_rcu_cb);
+	call_rcu(&ufid_ti->rcu, flow_tbl_destroy_rcu_cb);
 }
 
 /* No need for locking this function is called from RCU callback or
@@ -523,7 +517,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 
 	call_rcu(&mc->rcu, mask_cache_rcu_cb);
 	call_rcu(&ma->rcu, mask_array_rcu_cb);
-	table_instance_destroy(table, ti, ufid_ti, false);
+	table_instance_destroy(ti, ufid_ti);
 }
 
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -641,7 +635,8 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	flow_table->count = 0;
 	flow_table->ufid_count = 0;
 
-	table_instance_destroy(flow_table, old_ti, old_ufid_ti, true);
+	table_instance_flow_flush(flow_table, old_ti, old_ufid_ti);
+	table_instance_destroy(old_ti, old_ufid_ti);
 	return 0;
 
 err_free_ti:
diff --git a/net/openvswitch/flow_table.h b/net/openvswitch/flow_table.h
index 74ce48fecba9..6e7d4ac59353 100644
--- a/net/openvswitch/flow_table.h
+++ b/net/openvswitch/flow_table.h
@@ -105,5 +105,8 @@ void ovs_flow_mask_key(struct sw_flow_key *dst, const struct sw_flow_key *src,
 		       bool full, const struct sw_flow_mask *mask);
 
 void ovs_flow_masks_rebalance(struct flow_table *table);
+void table_instance_flow_flush(struct flow_table *table,
+			       struct table_instance *ti,
+			       struct table_instance *ufid_ti);
 
 #endif /* flow_table.h */
-- 
2.23.0


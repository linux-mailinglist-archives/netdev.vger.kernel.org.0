Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE2A2427F3
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 11:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgHLJ6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 05:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726722AbgHLJ6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 05:58:03 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0995CC06174A;
        Wed, 12 Aug 2020 02:58:03 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s15so768594pgc.8;
        Wed, 12 Aug 2020 02:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/KV5Nu4GOqpdobD0Vy0F5Lm8c2lLHadx20/MZj2JEU=;
        b=P8IbN2Az2JiBC5X19oePGVFkVCdEwe5FgB6rEiPXaq6H2i8JwHd2A0jPvgpF5YnrgA
         Hi++xCJtKlpq5nYC/qjwFPtHKSIB1Yw4UvGUO1ASGbroVdalS0mWXo9OzW2ET+jtj4Wb
         W/98cGUwha6w9GoR0Tmg16k5spcTKvkLCqRFqcwx94oxv3DhJwi+CAFXTQFiT1zy+qjo
         8qO6S27/S67qJpIhBqM33dXN3AptS8jCyPDKz8pw+dcsc00Gyv1gNfwoCKn1Wil8IqOf
         D9nupC1ugpswEsK00jbmJJohVMOpNhp0WNXarh9zT1i8Z1fX2S8hI/ZhQ8+PIoQ6+kD5
         lH8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=P/KV5Nu4GOqpdobD0Vy0F5Lm8c2lLHadx20/MZj2JEU=;
        b=PGJBqYXmmQhxPEgr3niMdHLtCOtD38+xygojyT5F/3oHVkZNb186fgG1pi+zHN7II/
         VNL+fAxTHMKuAVsBaiBA8/+GQxGfYYNJQtmQVa5YaQcAWs8Ypi0mIvxhqXh1P4Tlfa9t
         SANlI6jqVvb6XyYoKMyxy7pAFK6nwxWF59h5Q1fib2QhgHXtLuIYzM6eEMUw2tKCylBL
         i6VKbYzA67btEo+Sa0fD8F9Po1YxOH9bOez+rt8cobFPQrcV7JS2I7W9m2E5ghptSBEg
         p0+kPQfC8KBC8wldECMfiEAmOy0NgfVq5K5Bhxav1z6H+Fr4MmQkiiItlqNJzkzgvqon
         EGQg==
X-Gm-Message-State: AOAM530CVgVHiL63So323YNYNx4oHZCNHD1EWbt600OjZicrW+Bn2m0x
        UgpcAEaxS8xBvsA6OpJ1OZXc4NYUlJ8I/Q==
X-Google-Smtp-Source: ABdhPJx7wNeffIDFr8Fk0CGV9iuJuBFDAXnJ24eVMRJnIZ10RsoP0jmt3qxSSpIIvMlAuIcFbyujDg==
X-Received: by 2002:a63:6dcd:: with SMTP id i196mr4585271pgc.70.1597226282202;
        Wed, 12 Aug 2020 02:58:02 -0700 (PDT)
Received: from localhost.localdomain ([106.39.149.188])
        by smtp.gmail.com with ESMTPSA id p9sm1698436pjm.1.2020.08.12.02.57.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Aug 2020 02:58:01 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     joel@joelfernandes.org, jknoos@google.com, gvrose8192@gmail.com,
        urezki@gmail.com, paulmck@kernel.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, rcu@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH v2] net: openvswitch: introduce common code for flushing flows
Date:   Wed, 12 Aug 2020 17:56:39 +0800
Message-Id: <20200812095639.4062-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

To avoid some issues, for example RCU usage warning and double free,
we should flush the flows under ovs_lock. This patch refactors
table_instance_destroy and introduces table_instance_flow_flush
which can be invoked by __dp_destroy or ovs_flow_tbl_flush.

Fixes: 50b0e61b32ee ("net: openvswitch: fix possible memleak on destroy flow-table")
Reported-by: Johan Knöös <jknoos@google.com>
Reported-at: https://mail.openvswitch.org/pipermail/ovs-discuss/2020-August/050489.html
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
* Change local var coding style
* Add reported and fixed tag
---
 net/openvswitch/datapath.c   | 10 +++++++++-
 net/openvswitch/flow_table.c | 35 +++++++++++++++--------------------
 net/openvswitch/flow_table.h |  3 +++
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index 42f8cc70bb2c..6e47ef7ef036 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1756,6 +1756,7 @@ static int ovs_dp_cmd_new(struct sk_buff *skb, struct genl_info *info)
 /* Called with ovs_mutex. */
 static void __dp_destroy(struct datapath *dp)
 {
+	struct flow_table *table = &dp->table;
 	int i;
 
 	for (i = 0; i < DP_VPORT_HASH_BUCKETS; i++) {
@@ -1774,7 +1775,14 @@ static void __dp_destroy(struct datapath *dp)
 	 */
 	ovs_dp_detach_port(ovs_vport_ovsl(dp, OVSP_LOCAL));
 
-	/* RCU destroy the flow table */
+	/* Flush sw_flow in the tables. RCU cb only releases resource
+	 * such as dp, ports and tables. That may avoid some issues
+	 * such as RCU usage warning.
+	 */
+	table_instance_flow_flush(table, ovsl_dereference(table->ti),
+				  ovsl_dereference(table->ufid_ti));
+
+	/* RCU destroy the ports, meters and flow tables. */
 	call_rcu(&dp->rcu, destroy_dp_rcu);
 }
 
diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 8c12675cbb67..e2235849a57e 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -473,19 +473,15 @@ static void table_instance_flow_free(struct flow_table *table,
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
 		struct sw_flow *flow;
@@ -497,18 +493,16 @@ static void table_instance_destroy(struct flow_table *table,
 
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


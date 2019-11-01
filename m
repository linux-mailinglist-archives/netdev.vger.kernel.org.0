Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFEEEEC4A1
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 15:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbfKAOYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 10:24:35 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43855 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfKAOYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 10:24:34 -0400
Received: by mail-pf1-f193.google.com with SMTP id 3so7179634pfb.10
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 07:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6q680XjywUSv96PIeU7IzP0LK6sHMsve52sMUypjSwk=;
        b=BxcJn5Fb7H5m1n6lQyX9jmYail7aYR3sWyw5nQVYKWtk2bmH3kwv330m/X54hz4LKs
         QCX8ajlwWExTyJSRG0xDZwCQZGJey9aKGMUpTA7cVva1j/NxYEN9tkf3RlHsWyffJJrG
         jwEUM5Gbjk9VeSRuTdYqwHkXXSC8Fphbr/kC9IlMh+kkuos4ugI5vyDKvtTceqN9DBKO
         yDS/g9YglztLPgIQcHVfdulb3avV+RNF5IW87lH9QVba716w1Ggg4Q8PIgmxknFrzGF+
         Jx+b8cCbe9ceYEWm8pOooCvfvIYH/vD7ZMdVlCAGvGObGc6gUzLaDL2NV7WlYR5DnX7a
         QWaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6q680XjywUSv96PIeU7IzP0LK6sHMsve52sMUypjSwk=;
        b=q+VtcNIsQOUgk+Xip9KRxJmg36+utga9cb0E+lBQKqW1jiWib5EzttyOZAh/g4lFzF
         Nr3pPBcKrdYpPa8Le/6V+wFe9TEkCyFWLZyPWj/oN704/hsNe3Gt1tg6iA1cN5QladRN
         GQxqAqT5WmNliX2ex2ETTsPPgu/NvXZwemWtjZkL7HloYOuNRvWhOoMoa1aA2V3rZxr/
         p1Bq4qjLQ4x3TPmQlX2NFFQ0+THvVw8sKPLjW4hyKeMs8+Xwpqgc8+PpqdvjKKugSeP8
         Ty99g0BiPsDpVkYEcBfr/UtDFdeLllhdeyOWsQCsc51Xav7kIuw3an05uLKA/BDWiSEv
         DJ5A==
X-Gm-Message-State: APjAAAU/95pXU2FeTJDTD1+nbAIWMPgijlC7Y4xuKZJe9VMAvTXcQ0me
        8/0FZx7488XKhqhExSJvAm0=
X-Google-Smtp-Source: APXvYqwhYxXmaQeMf05f+UVKHkYaIZsmFjrWbeYnoZnADChJi18A1qxKC1fwMVx4ZcKrDMMUGzb+hw==
X-Received: by 2002:a63:cf4d:: with SMTP id b13mr13396436pgj.396.1572618273848;
        Fri, 01 Nov 2019 07:24:33 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([1.203.173.208])
        by smtp.gmail.com with ESMTPSA id c12sm8296499pfp.67.2019.11.01.07.24.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:24:33 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     gvrose8192@gmail.com, pshelar@ovn.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v6 08/10] net: openvswitch: fix possible memleak on destroy flow-table
Date:   Fri,  1 Nov 2019 22:23:52 +0800
Message-Id: <1572618234-6904-9-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1572618234-6904-1-git-send-email-xiangxia.m.yue@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

When we destroy the flow tables which may contain the flow_mask,
so release the flow mask struct.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Tested-by: Greg Rose <gvrose8192@gmail.com>
---
 net/openvswitch/flow_table.c | 186 +++++++++++++++++++++++--------------------
 1 file changed, 98 insertions(+), 88 deletions(-)

diff --git a/net/openvswitch/flow_table.c b/net/openvswitch/flow_table.c
index 9f5a06e..5904e93 100644
--- a/net/openvswitch/flow_table.c
+++ b/net/openvswitch/flow_table.c
@@ -210,6 +210,74 @@ static int tbl_mask_array_realloc(struct flow_table *tbl, int size)
 	return 0;
 }
 
+static int tbl_mask_array_add_mask(struct flow_table *tbl,
+				   struct sw_flow_mask *new)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int err, ma_count = READ_ONCE(ma->count);
+
+	if (ma_count >= ma->max) {
+		err = tbl_mask_array_realloc(tbl, ma->max +
+					      MASK_ARRAY_SIZE_MIN);
+		if (err)
+			return err;
+
+		ma = ovsl_dereference(tbl->mask_array);
+	}
+
+	BUG_ON(ovsl_dereference(ma->masks[ma_count]));
+
+	rcu_assign_pointer(ma->masks[ma_count], new);
+	WRITE_ONCE(ma->count, ma_count +1);
+
+	return 0;
+}
+
+static void tbl_mask_array_del_mask(struct flow_table *tbl,
+				    struct sw_flow_mask *mask)
+{
+	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
+	int i, ma_count = READ_ONCE(ma->count);
+
+	/* Remove the deleted mask pointers from the array */
+	for (i = 0; i < ma_count; i++) {
+		if (mask == ovsl_dereference(ma->masks[i]))
+			goto found;
+	}
+
+	BUG();
+	return;
+
+found:
+	WRITE_ONCE(ma->count, ma_count -1);
+
+	rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
+	RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
+
+	kfree_rcu(mask, rcu);
+
+	/* Shrink the mask array if necessary. */
+	if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
+	    ma_count <= (ma->max / 3))
+		tbl_mask_array_realloc(tbl, ma->max / 2);
+}
+
+/* Remove 'mask' from the mask list, if it is not needed any more. */
+static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
+{
+	if (mask) {
+		/* ovs-lock is required to protect mask-refcount and
+		 * mask list.
+		 */
+		ASSERT_OVSL();
+		BUG_ON(!mask->ref_count);
+		mask->ref_count--;
+
+		if (!mask->ref_count)
+			tbl_mask_array_del_mask(tbl, mask);
+	}
+}
+
 int ovs_flow_tbl_init(struct flow_table *table)
 {
 	struct table_instance *ti, *ufid_ti;
@@ -257,7 +325,28 @@ static void flow_tbl_destroy_rcu_cb(struct rcu_head *rcu)
 	__table_instance_destroy(ti);
 }
 
-static void table_instance_destroy(struct table_instance *ti,
+static void table_instance_flow_free(struct flow_table *table,
+				  struct table_instance *ti,
+				  struct table_instance *ufid_ti,
+				  struct sw_flow *flow,
+				  bool count)
+{
+	hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
+	if (count)
+		table->count--;
+
+	if (ovs_identifier_is_ufid(&flow->id)) {
+		hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
+
+		if (count)
+			table->ufid_count--;
+	}
+
+	flow_mask_remove(table, flow->mask);
+}
+
+static void table_instance_destroy(struct flow_table *table,
+				   struct table_instance *ti,
 				   struct table_instance *ufid_ti,
 				   bool deferred)
 {
@@ -274,13 +363,12 @@ static void table_instance_destroy(struct table_instance *ti,
 		struct sw_flow *flow;
 		struct hlist_head *head = &ti->buckets[i];
 		struct hlist_node *n;
-		int ver = ti->node_ver;
-		int ufid_ver = ufid_ti->node_ver;
 
-		hlist_for_each_entry_safe(flow, n, head, flow_table.node[ver]) {
-			hlist_del_rcu(&flow->flow_table.node[ver]);
-			if (ovs_identifier_is_ufid(&flow->id))
-				hlist_del_rcu(&flow->ufid_table.node[ufid_ver]);
+		hlist_for_each_entry_safe(flow, n, head,
+					  flow_table.node[ti->node_ver]) {
+
+			table_instance_flow_free(table, ti, ufid_ti,
+						 flow, false);
 			ovs_flow_free(flow, deferred);
 		}
 	}
@@ -305,7 +393,7 @@ void ovs_flow_tbl_destroy(struct flow_table *table)
 
 	free_percpu(table->mask_cache);
 	kfree_rcu(rcu_dereference_raw(table->mask_array), rcu);
-	table_instance_destroy(ti, ufid_ti, false);
+	table_instance_destroy(table, ti, ufid_ti, false);
 }
 
 struct sw_flow *ovs_flow_tbl_dump_next(struct table_instance *ti,
@@ -421,7 +509,7 @@ int ovs_flow_tbl_flush(struct flow_table *flow_table)
 	flow_table->count = 0;
 	flow_table->ufid_count = 0;
 
-	table_instance_destroy(old_ti, old_ufid_ti, true);
+	table_instance_destroy(flow_table, old_ti, old_ufid_ti, true);
 	return 0;
 
 err_free_ti:
@@ -701,51 +789,6 @@ static struct table_instance *table_instance_expand(struct table_instance *ti,
 	return table_instance_rehash(ti, ti->n_buckets * 2, ufid);
 }
 
-static void tbl_mask_array_del_mask(struct flow_table *tbl,
-				    struct sw_flow_mask *mask)
-{
-	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
-	int i, ma_count = READ_ONCE(ma->count);
-
-	/* Remove the deleted mask pointers from the array */
-	for (i = 0; i < ma_count; i++) {
-		if (mask == ovsl_dereference(ma->masks[i]))
-			goto found;
-	}
-
-	BUG();
-	return;
-
-found:
-	WRITE_ONCE(ma->count, ma_count -1);
-
-	rcu_assign_pointer(ma->masks[i], ma->masks[ma_count -1]);
-	RCU_INIT_POINTER(ma->masks[ma_count -1], NULL);
-
-	kfree_rcu(mask, rcu);
-
-	/* Shrink the mask array if necessary. */
-	if (ma->max >= (MASK_ARRAY_SIZE_MIN * 2) &&
-	    ma_count <= (ma->max / 3))
-		tbl_mask_array_realloc(tbl, ma->max / 2);
-}
-
-/* Remove 'mask' from the mask list, if it is not needed any more. */
-static void flow_mask_remove(struct flow_table *tbl, struct sw_flow_mask *mask)
-{
-	if (mask) {
-		/* ovs-lock is required to protect mask-refcount and
-		 * mask list.
-		 */
-		ASSERT_OVSL();
-		BUG_ON(!mask->ref_count);
-		mask->ref_count--;
-
-		if (!mask->ref_count)
-			tbl_mask_array_del_mask(tbl, mask);
-	}
-}
-
 /* Must be called with OVS mutex held. */
 void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 {
@@ -753,17 +796,7 @@ void ovs_flow_tbl_remove(struct flow_table *table, struct sw_flow *flow)
 	struct table_instance *ufid_ti = ovsl_dereference(table->ufid_ti);
 
 	BUG_ON(table->count == 0);
-	hlist_del_rcu(&flow->flow_table.node[ti->node_ver]);
-	table->count--;
-	if (ovs_identifier_is_ufid(&flow->id)) {
-		hlist_del_rcu(&flow->ufid_table.node[ufid_ti->node_ver]);
-		table->ufid_count--;
-	}
-
-	/* RCU delete the mask. 'flow->mask' is not NULLed, as it should be
-	 * accessible as long as the RCU read lock is held.
-	 */
-	flow_mask_remove(table, flow->mask);
+	table_instance_flow_free(table, ti, ufid_ti, flow, true);
 }
 
 static struct sw_flow_mask *mask_alloc(void)
@@ -806,29 +839,6 @@ static struct sw_flow_mask *flow_mask_find(const struct flow_table *tbl,
 	return NULL;
 }
 
-static int tbl_mask_array_add_mask(struct flow_table *tbl,
-				   struct sw_flow_mask *new)
-{
-	struct mask_array *ma = ovsl_dereference(tbl->mask_array);
-	int err, ma_count = READ_ONCE(ma->count);
-
-	if (ma_count >= ma->max) {
-		err = tbl_mask_array_realloc(tbl, ma->max +
-					      MASK_ARRAY_SIZE_MIN);
-		if (err)
-			return err;
-
-		ma = ovsl_dereference(tbl->mask_array);
-	}
-
-	BUG_ON(ovsl_dereference(ma->masks[ma_count]));
-
-	rcu_assign_pointer(ma->masks[ma_count], new);
-	WRITE_ONCE(ma->count, ma_count +1);
-
-	return 0;
-}
-
 /* Add 'mask' into the mask list, if it is not already there. */
 static int flow_mask_insert(struct flow_table *tbl, struct sw_flow *flow,
 			    const struct sw_flow_mask *new)
-- 
1.8.3.1


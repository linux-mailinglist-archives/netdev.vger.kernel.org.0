Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0F59169761
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbgBWLpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:45:43 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:49076 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727237AbgBWLpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:45:43 -0500
Received: from Internal Mail-Server by MTLPINE2 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Feb 2020 13:45:36 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01NBjZEU006598;
        Sun, 23 Feb 2020 13:45:35 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 1/6] netfilter: flowtable: pass flowtable to nf_flow_table_iterate()
Date:   Sun, 23 Feb 2020 13:45:02 +0200
Message-Id: <1582458307-17067-2-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
References: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Pass flowtable object to the iteration callback that is called from
nf_flow_table_iterate().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Paul Blakey <paulb@mellanox.com>
---
 net/netfilter/nf_flow_table_core.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 8af28e1..face98b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -312,7 +312,8 @@ struct flow_offload_tuple_rhash *
 
 static int
 nf_flow_table_iterate(struct nf_flowtable *flow_table,
-		      void (*iter)(struct flow_offload *flow, void *data),
+		      void (*iter)(struct nf_flowtable *flow_table,
+				   struct flow_offload *flow, void *data),
 		      void *data)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -336,7 +337,7 @@ struct flow_offload_tuple_rhash *
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
-		iter(flow, data);
+		iter(flow_table, flow, data);
 	}
 	rhashtable_walk_stop(&hti);
 	rhashtable_walk_exit(&hti);
@@ -344,10 +345,9 @@ struct flow_offload_tuple_rhash *
 	return err;
 }
 
-static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
+static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
+				    struct flow_offload *flow, void *data)
 {
-	struct nf_flowtable *flow_table = data;
-
 	if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
 	    test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
 		if (test_bit(NF_FLOW_HW, &flow->flags)) {
@@ -368,7 +368,7 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -511,7 +511,8 @@ int nf_flow_table_init(struct nf_flowtable *flowtable)
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_init);
 
-static void nf_flow_table_do_cleanup(struct flow_offload *flow, void *data)
+static void nf_flow_table_do_cleanup(struct nf_flowtable *flowtable,
+				     struct flow_offload *flow, void *data)
 {
 	struct net_device *dev = data;
 
@@ -552,7 +553,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
 	nf_flow_table_offload_flush(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
-- 
1.8.3.1


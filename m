Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22FAA1953AA
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 10:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727352AbgC0JMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 05:12:49 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:58947 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726266AbgC0JMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 05:12:39 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 27 Mar 2020 12:12:36 +0300
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02R9CaYg023271;
        Fri, 27 Mar 2020 12:12:36 +0300
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next v2 2/3] netfilter: flowtable: Use work entry per offload command
Date:   Fri, 27 Mar 2020 12:12:30 +0300
Message-Id: <1585300351-15741-3-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1585300351-15741-1-git-send-email-paulb@mellanox.com>
References: <1585300351-15741-1-git-send-email-paulb@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To allow offload commands to execute in parallel, create workqueue
for flow table offload, and use a work entry per offload command.

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
---
 net/netfilter/nf_flow_table_offload.c | 46 ++++++++++++-----------------------
 1 file changed, 15 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index dbd3685..527114a 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -12,9 +12,7 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-static struct work_struct nf_flow_offload_work;
-static DEFINE_SPINLOCK(flow_offload_pending_list_lock);
-static LIST_HEAD(flow_offload_pending_list);
+static struct workqueue_struct *nf_flow_offload_wq;
 
 struct flow_offload_work {
 	struct list_head	list;
@@ -22,6 +20,7 @@ struct flow_offload_work {
 	int			priority;
 	struct nf_flowtable	*flowtable;
 	struct flow_offload	*flow;
+	struct work_struct	work;
 };
 
 #define NF_FLOW_DISSECTOR(__match, __type, __field)	\
@@ -789,15 +788,10 @@ static void flow_offload_work_stats(struct flow_offload_work *offload)
 
 static void flow_offload_work_handler(struct work_struct *work)
 {
-	struct flow_offload_work *offload, *next;
-	LIST_HEAD(offload_pending_list);
-
-	spin_lock_bh(&flow_offload_pending_list_lock);
-	list_replace_init(&flow_offload_pending_list, &offload_pending_list);
-	spin_unlock_bh(&flow_offload_pending_list_lock);
+	struct flow_offload_work *offload;
 
-	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-		switch (offload->cmd) {
+	offload = container_of(work, struct flow_offload_work, work);
+	switch (offload->cmd) {
 		case FLOW_CLS_REPLACE:
 			flow_offload_work_add(offload);
 			break;
@@ -809,19 +803,14 @@ static void flow_offload_work_handler(struct work_struct *work)
 			break;
 		default:
 			WARN_ON_ONCE(1);
-		}
-		list_del(&offload->list);
-		kfree(offload);
 	}
+
+	kfree(offload);
 }
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	spin_lock_bh(&flow_offload_pending_list_lock);
-	list_add_tail(&offload->list, &flow_offload_pending_list);
-	spin_unlock_bh(&flow_offload_pending_list_lock);
-
-	schedule_work(&nf_flow_offload_work);
+	queue_work(nf_flow_offload_wq, &offload->work);
 }
 
 static struct flow_offload_work *
@@ -838,6 +827,7 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	offload->flow = flow;
 	offload->priority = flowtable->priority;
 	offload->flowtable = flowtable;
+	INIT_WORK(&offload->work, flow_offload_work_handler);
 
 	return offload;
 }
@@ -888,7 +878,7 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable))
-		flush_work(&nf_flow_offload_work);
+		flush_workqueue(nf_flow_offload_wq);
 }
 
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
@@ -1053,7 +1043,10 @@ static void nf_flow_table_indr_block_cb(struct net_device *dev,
 
 int nf_flow_table_offload_init(void)
 {
-	INIT_WORK(&nf_flow_offload_work, flow_offload_work_handler);
+	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
+					      WQ_UNBOUND | WQ_MEM_RECLAIM, 0);
+	if (!nf_flow_offload_wq)
+		return -ENOMEM;
 
 	flow_indr_add_block_cb(&block_ing_entry);
 
@@ -1062,15 +1055,6 @@ int nf_flow_table_offload_init(void)
 
 void nf_flow_table_offload_exit(void)
 {
-	struct flow_offload_work *offload, *next;
-	LIST_HEAD(offload_pending_list);
-
 	flow_indr_del_block_cb(&block_ing_entry);
-
-	cancel_work_sync(&nf_flow_offload_work);
-
-	list_for_each_entry_safe(offload, next, &offload_pending_list, list) {
-		list_del(&offload->list);
-		kfree(offload);
-	}
+	destroy_workqueue(nf_flow_offload_wq);
 }
-- 
1.8.3.1


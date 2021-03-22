Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27DCD34536E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbhCVX5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:57:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230401AbhCVX4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:56:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [IPv6:2001:4b98:dc0:41:216:3eff:fe8c:2bda])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0588CC061574;
        Mon, 22 Mar 2021 16:56:37 -0700 (PDT)
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 24506630CA;
        Tue, 23 Mar 2021 00:56:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 01/10] netfilter: flowtable: separate replace, destroy and stats to different workqueues
Date:   Tue, 23 Mar 2021 00:56:19 +0100
Message-Id: <20210322235628.2204-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Currently the flow table offload replace, destroy and stats work items are
executed on a single workqueue. As such, DESTROY and STATS commands may
be backloged after a burst of REPLACE work items. This scenario can bloat
up memory and may cause active connections to age.

Instatiate add, del and stats workqueues to avoid backlogs of non-dependent
actions. Provide sysfs control over the workqueue attributes, allowing
userspace applications to control the workqueue cpumask.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 44 ++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 2a6993fa40d7..1b979c8b3ba0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -13,7 +13,9 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_tuple.h>
 
-static struct workqueue_struct *nf_flow_offload_wq;
+static struct workqueue_struct *nf_flow_offload_add_wq;
+static struct workqueue_struct *nf_flow_offload_del_wq;
+static struct workqueue_struct *nf_flow_offload_stats_wq;
 
 struct flow_offload_work {
 	struct list_head	list;
@@ -826,7 +828,12 @@ static void flow_offload_work_handler(struct work_struct *work)
 
 static void flow_offload_queue_work(struct flow_offload_work *offload)
 {
-	queue_work(nf_flow_offload_wq, &offload->work);
+	if (offload->cmd == FLOW_CLS_REPLACE)
+		queue_work(nf_flow_offload_add_wq, &offload->work);
+	else if (offload->cmd == FLOW_CLS_DESTROY)
+		queue_work(nf_flow_offload_del_wq, &offload->work);
+	else
+		queue_work(nf_flow_offload_stats_wq, &offload->work);
 }
 
 static struct flow_offload_work *
@@ -898,8 +905,11 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
-	if (nf_flowtable_hw_offload(flowtable))
-		flush_workqueue(nf_flow_offload_wq);
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flush_workqueue(nf_flow_offload_add_wq);
+		flush_workqueue(nf_flow_offload_del_wq);
+		flush_workqueue(nf_flow_offload_stats_wq);
+	}
 }
 
 static int nf_flow_table_block_setup(struct nf_flowtable *flowtable,
@@ -1011,15 +1021,33 @@ EXPORT_SYMBOL_GPL(nf_flow_table_offload_setup);
 
 int nf_flow_table_offload_init(void)
 {
-	nf_flow_offload_wq  = alloc_workqueue("nf_flow_table_offload",
-					      WQ_UNBOUND, 0);
-	if (!nf_flow_offload_wq)
+	nf_flow_offload_add_wq  = alloc_workqueue("nf_ft_offload_add",
+						  WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_add_wq)
 		return -ENOMEM;
 
+	nf_flow_offload_del_wq  = alloc_workqueue("nf_ft_offload_del",
+						  WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_del_wq)
+		goto err_del_wq;
+
+	nf_flow_offload_stats_wq  = alloc_workqueue("nf_ft_offload_stats",
+						    WQ_UNBOUND | WQ_SYSFS, 0);
+	if (!nf_flow_offload_stats_wq)
+		goto err_stats_wq;
+
 	return 0;
+
+err_stats_wq:
+	destroy_workqueue(nf_flow_offload_del_wq);
+err_del_wq:
+	destroy_workqueue(nf_flow_offload_add_wq);
+	return -ENOMEM;
 }
 
 void nf_flow_table_offload_exit(void)
 {
-	destroy_workqueue(nf_flow_offload_wq);
+	destroy_workqueue(nf_flow_offload_add_wq);
+	destroy_workqueue(nf_flow_offload_del_wq);
+	destroy_workqueue(nf_flow_offload_stats_wq);
 }
-- 
2.20.1


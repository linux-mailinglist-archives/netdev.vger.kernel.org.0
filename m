Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFDC456546
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 23:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhKRWEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 17:04:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:57556 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhKRWEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 17:04:01 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 34E6F64A8D;
        Thu, 18 Nov 2021 22:58:52 +0100 (CET)
Date:   Thu, 18 Nov 2021 23:00:53 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Cc:     netdev@vger.kernel.org, mickeyr@marvell.com,
        serhiy.pshyk@plvision.eu, taras.chornyi@plvision.eu,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paul Blakey <paulb@mellanox.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 RESEND] netfilter: fix conntrack flows stuck issue
 on cleanup.
Message-ID: <YZbNFaKUHaCIYdRK@salvia>
References: <1635931896-27539-1-git-send-email-volodymyr.mytnyk@plvision.eu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="UMHJGjOvqhOHZk8H"
Content-Disposition: inline
In-Reply-To: <1635931896-27539-1-git-send-email-volodymyr.mytnyk@plvision.eu>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--UMHJGjOvqhOHZk8H
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi,

On Wed, Nov 03, 2021 at 11:31:36AM +0200, Volodymyr Mytnyk wrote:
> From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> 
> On busy system with big number (few thousands) of HW offloaded flows, it
> is possible to hit the situation, where some of the conntack flows are
> stuck in conntrack table (as offloaded) and cannot be removed by user.
> 
> This behaviour happens if user has configured conntack using tc sub-system,
> offloaded those flows for HW and then deleted tc configuration from Linux
> system by deleting the tc qdiscs.
> 
> When qdiscs are removed, the nf_flow_table_free() is called to do the
> cleanup of HW offloaded flows in conntrack table.
> 
> ...
> process_one_work
>   tcf_ct_flow_table_cleanup_work()
>     nf_flow_table_free()
> 
> The nf_flow_table_free() does the following things:
> 
>   1. cancels gc workqueue
>   2. marks all flows as teardown
>   3. executes nf_flow_offload_gc_step() once for each flow to
>      trigger correct teardown flow procedure (e.g., allocate
>      work to delete the HW flow and marks the flow as "dying").
>   4. waits for all scheduled flow offload works to be finished.
>   5. executes nf_flow_offload_gc_step() once for each flow to
>      trigger the deleting of flows.
> 
> Root cause:
> 
> In step 3, nf_flow_offload_gc_step() expects to move flow to "dying"
> state by using nf_flow_offload_del() and deletes the flow in next
> nf_flow_offload_gc_step() iteration. But, if flow is in "pending" state
> for some reason (e.g., reading HW stats), it will not be moved to
> "dying" state as expected by nf_flow_offload_gc_step() and will not
> be marked as "dead" for delition.
> 
> In step 5, nf_flow_offload_gc_step() assumes that all flows marked
> as "dead" and will be deleted by this call, but this is not true since
> the state was not set diring previous nf_flow_offload_gc_step()
> call.
> 
> It issue causes some of the flows to get stuck in connection tracking
> system or not release properly.
> 
> To fix this problem, add nf_flow_table_offload_flush() call between 2 & 3
> step, to make sure no other flow offload works will be in "pending" state
> during step 3.

Thanks for the detailed report.

I'm attaching two patches, the first one is a preparation patch. The
second patch flushes the pending work, then it sets the teardown flag
to all flows in the flowtable and it forces a garbage collector run to
queue work to remove the flows from hardware, then it flushes this new
pending work and (finally) it forces another garbage collector run to
remove the entry from the software flowtable. Compile-tested only.

--UMHJGjOvqhOHZk8H
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-flowtable-add-nf_flow_table_gc_run.patch"

From 81dd33c687b1e868b40e1aac066529d93fa396d8 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 18 Nov 2021 22:16:37 +0100
Subject: [PATCH 1/2] netfilter: flowtable: add nf_flow_table_gc_run()

Expose nf_flow_table_gc_run() to force a garbage collector run from the
offload infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table_core.c    | 13 +++++++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index a3647fadf1cc..6dc19d1ceeff 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -264,6 +264,7 @@ void flow_offload_refresh(struct nf_flowtable *flow_table,
 
 struct flow_offload_tuple_rhash *flow_offload_lookup(struct nf_flowtable *flow_table,
 						     struct flow_offload_tuple *tuple);
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table);
 void nf_flow_table_gc_cleanup(struct nf_flowtable *flowtable,
 			      struct net_device *dev);
 void nf_flow_table_cleanup(struct net_device *dev);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 87a7388b6c89..37fd6c646ccb 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -474,12 +474,17 @@ static void nf_flow_offload_gc_step(struct flow_offload *flow, void *data)
 	}
 }
 
+void nf_flow_table_gc_run(struct nf_flowtable *flow_table)
+{
+	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+}
+
 static void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct nf_flowtable *flow_table;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_gc_run(flow_table);
 	queue_delayed_work(system_power_efficient_wq, &flow_table->gc_work, HZ);
 }
 
@@ -637,11 +642,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
-	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, flow_table);
+	nf_flow_table_gc_run(flow_table);
 	nf_flow_table_offload_flush(flow_table);
 	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step,
-				      flow_table);
+		nf_flow_table_gc_run(flow_table);
+
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
-- 
2.30.2


--UMHJGjOvqhOHZk8H
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0002-netfilter-flowtable-fix-stuck-flows-on-cleanup-due-t.patch"

From 737a4ff4df8b3e6791352b2b379e102f7682fa0f Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 18 Nov 2021 22:24:15 +0100
Subject: [PATCH 2/2] netfilter: flowtable: fix stuck flows on cleanup due to
 pending work

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 7 +++----
 net/netfilter/nf_flow_table_offload.c | 8 ++++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6dc19d1ceeff..4c3d537f1069 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -301,6 +301,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 37fd6c646ccb..fddc44de3550 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -641,12 +641,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
 	mutex_unlock(&flowtable_lock);
 
 	cancel_delayed_work_sync(&flow_table->gc_work);
+	nf_flow_table_offload_flush(flow_table);
+	/* ... no more pending work after this stage ... */
 	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
 	nf_flow_table_gc_run(flow_table);
-	nf_flow_table_offload_flush(flow_table);
-	if (nf_flowtable_hw_offload(flow_table))
-		nf_flow_table_gc_run(flow_table);
-
+	nf_flow_table_offload_flush_cleanup(flow_table);
 	rhashtable_destroy(&flow_table->rhashtable);
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_free);
diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index b561e0a44a45..c4559fae8acd 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1050,6 +1050,14 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 	flow_offload_queue_work(offload);
 }
 
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable)
+{
+	if (nf_flowtable_hw_offload(flowtable)) {
+		flush_workqueue(nf_flow_offload_del_wq);
+		nf_flow_table_gc_run(flowtable);
+	}
+}
+
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable)
 {
 	if (nf_flowtable_hw_offload(flowtable)) {
-- 
2.30.2


--UMHJGjOvqhOHZk8H--

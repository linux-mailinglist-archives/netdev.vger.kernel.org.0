Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB225990E7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 01:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243287AbiHRXEX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 19:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbiHRXEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 19:04:21 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F22846BD48;
        Thu, 18 Aug 2022 16:04:19 -0700 (PDT)
Date:   Fri, 19 Aug 2022 01:04:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net 1/1] netfilter: flowtable: Fix use after free after
 freeing flow table
Message-ID: <Yv7FauVMX2Smkiqb@salvia>
References: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="PNruHMamiA0etryc"
Content-Disposition: inline
In-Reply-To: <1660807674-28447-1-git-send-email-paulb@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--PNruHMamiA0etryc
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Paul,

On Thu, Aug 18, 2022 at 10:27:54AM +0300, Paul Blakey wrote:
[...]
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index f2def06d1070..19fd3b5f8a1b 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -605,6 +605,7 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
>  	mutex_unlock(&flowtable_lock);
>  
>  	cancel_delayed_work_sync(&flow_table->gc_work);
> +	nf_flow_table_offload_flush(flow_table);
>  	nf_flow_table_iterate(flow_table, nf_flow_table_do_cleanup, NULL);
>  	nf_flow_table_iterate(flow_table, nf_flow_offload_gc_step, NULL);
>  	nf_flow_table_offload_flush(flow_table);

patch looks very similar to:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/1633854320-12326-1-git-send-email-volodymyr.mytnyk@plvision.eu/

I proposed these two instead to avoid reiterative calls to flush from
the cleanup path (see attached).

It should be possible to either take your patch to nf.git (easier for
-stable backport), then look into my patches for nf-next.git, would
you pick up on these follow up?

--PNruHMamiA0etryc
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


--PNruHMamiA0etryc
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


--PNruHMamiA0etryc--

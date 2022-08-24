Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5DA5A03A2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240847AbiHXWEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240849AbiHXWEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:04:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DF0C76968;
        Wed, 24 Aug 2022 15:04:01 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 13/14] netfilter: flowtable: fix stuck flows on cleanup due to pending work
Date:   Thu, 25 Aug 2022 00:03:29 +0200
Message-Id: <20220824220330.64283-14-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To clear the flow table on flow table free, the following sequence
normally happens in order:

  1) gc_step work is stopped to disable any further stats/del requests.
  2) All flow table entries are set to teardown state.
  3) Run gc_step which will queue HW del work for each flow table entry.
  4) Waiting for the above del work to finish (flush).
  5) Run gc_step again, deleting all entries from the flow table.
  6) Flow table is freed.

But if a flow table entry already has pending HW stats or HW add work
step 3 will not queue HW del work (it will be skipped), step 4 will wait
for the pending add/stats to finish, and step 5 will queue HW del work
which might execute after freeing of the flow table.

To fix the above, this patch flushes the pending work, then it sets the
teardown flag to all flows in the flowtable and it forces a garbage
collector run to queue work to remove the flows from hardware, then it
flushes this new pending work and (finally) it forces another garbage
collector run to remove the entry from the software flowtable.

Stack trace:
[47773.882335] BUG: KASAN: use-after-free in down_read+0x99/0x460
[47773.883634] Write of size 8 at addr ffff888103b45aa8 by task kworker/u20:6/543704
[47773.885634] CPU: 3 PID: 543704 Comm: kworker/u20:6 Not tainted 5.12.0-rc7+ #2
[47773.886745] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009)
[47773.888438] Workqueue: nf_ft_offload_del flow_offload_work_handler [nf_flow_table]
[47773.889727] Call Trace:
[47773.890214]  dump_stack+0xbb/0x107
[47773.890818]  print_address_description.constprop.0+0x18/0x140
[47773.892990]  kasan_report.cold+0x7c/0xd8
[47773.894459]  kasan_check_range+0x145/0x1a0
[47773.895174]  down_read+0x99/0x460
[47773.899706]  nf_flow_offload_tuple+0x24f/0x3c0 [nf_flow_table]
[47773.907137]  flow_offload_work_handler+0x72d/0xbe0 [nf_flow_table]
[47773.913372]  process_one_work+0x8ac/0x14e0
[47773.921325]
[47773.921325] Allocated by task 592159:
[47773.922031]  kasan_save_stack+0x1b/0x40
[47773.922730]  __kasan_kmalloc+0x7a/0x90
[47773.923411]  tcf_ct_flow_table_get+0x3cb/0x1230 [act_ct]
[47773.924363]  tcf_ct_init+0x71c/0x1156 [act_ct]
[47773.925207]  tcf_action_init_1+0x45b/0x700
[47773.925987]  tcf_action_init+0x453/0x6b0
[47773.926692]  tcf_exts_validate+0x3d0/0x600
[47773.927419]  fl_change+0x757/0x4a51 [cls_flower]
[47773.928227]  tc_new_tfilter+0x89a/0x2070
[47773.936652]
[47773.936652] Freed by task 543704:
[47773.937303]  kasan_save_stack+0x1b/0x40
[47773.938039]  kasan_set_track+0x1c/0x30
[47773.938731]  kasan_set_free_info+0x20/0x30
[47773.939467]  __kasan_slab_free+0xe7/0x120
[47773.940194]  slab_free_freelist_hook+0x86/0x190
[47773.941038]  kfree+0xce/0x3a0
[47773.941644]  tcf_ct_flow_table_cleanup_work

Original patch description and stack trace by Paul Blakey.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Reported-by: Paul Blakey <paulb@nvidia.com>
Tested-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 2 ++
 net/netfilter/nf_flow_table_core.c    | 7 +++----
 net/netfilter/nf_flow_table_offload.c | 8 ++++++++
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 476cc4423a90..cd982f4a0f50 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -307,6 +307,8 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
 			   struct flow_offload *flow);
 
 void nf_flow_table_offload_flush(struct nf_flowtable *flowtable);
+void nf_flow_table_offload_flush_cleanup(struct nf_flowtable *flowtable);
+
 int nf_flow_table_offload_setup(struct nf_flowtable *flowtable,
 				struct net_device *dev,
 				enum flow_block_command cmd);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 60fc1e1b7182..81c26a96c30b 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -605,12 +605,11 @@ void nf_flow_table_free(struct nf_flowtable *flow_table)
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
index 103b6cbf257f..b04645ced89b 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -1074,6 +1074,14 @@ void nf_flow_offload_stats(struct nf_flowtable *flowtable,
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


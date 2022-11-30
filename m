Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E44363D562
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234602AbiK3MTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiK3MTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:19:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AB3AA303F0;
        Wed, 30 Nov 2022 04:19:40 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 2/4] netfilter: flowtable_offload: fix using __this_cpu_add in preemptible
Date:   Wed, 30 Nov 2022 13:19:32 +0100
Message-Id: <20221130121934.1125-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221130121934.1125-1-pablo@netfilter.org>
References: <20221130121934.1125-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

flow_offload_queue_work() can be called in workqueue without
bh disabled, like the call trace showed in my act_ct testing,
calling NF_FLOW_TABLE_STAT_INC() there would cause a call
trace:

  BUG: using __this_cpu_add() in preemptible [00000000] code: kworker/u4:0/138560
  caller is flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
  Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work [act_ct]
  Call Trace:
   <TASK>
   dump_stack_lvl+0x33/0x46
   check_preemption_disabled+0xc3/0xf0
   flow_offload_queue_work+0xec/0x1b0 [nf_flow_table]
   nf_flow_table_iterate+0x138/0x170 [nf_flow_table]
   nf_flow_table_free+0x140/0x1a0 [nf_flow_table]
   tcf_ct_flow_table_cleanup_work+0x2f/0x2b0 [act_ct]
   process_one_work+0x6a3/0x1030
   worker_thread+0x8a/0xdf0

This patch fixes it by using NF_FLOW_TABLE_STAT_INC_ATOMIC()
instead in flow_offload_queue_work().

Note that for FLOW_CLS_REPLACE branch in flow_offload_queue_work(),
it may not be called in preemptible path, but it's good to use
NF_FLOW_TABLE_STAT_INC_ATOMIC() for all cases in
flow_offload_queue_work().

Fixes: b038177636f8 ("netfilter: nf_flow_table: count pending offload workqueue tasks")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 00b522890d77..0fdcdb2c9ae4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -997,13 +997,13 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
 	struct net *net = read_pnet(&offload->flowtable->net);
 
 	if (offload->cmd == FLOW_CLS_REPLACE) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_add);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_add);
 		queue_work(nf_flow_offload_add_wq, &offload->work);
 	} else if (offload->cmd == FLOW_CLS_DESTROY) {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_del);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_del);
 		queue_work(nf_flow_offload_del_wq, &offload->work);
 	} else {
-		NF_FLOW_TABLE_STAT_INC(net, count_wq_stats);
+		NF_FLOW_TABLE_STAT_INC_ATOMIC(net, count_wq_stats);
 		queue_work(nf_flow_offload_stats_wq, &offload->work);
 	}
 }
-- 
2.30.2


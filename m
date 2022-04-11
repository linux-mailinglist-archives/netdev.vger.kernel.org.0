Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26064FB999
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 12:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345490AbiDKKaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 06:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345471AbiDKKaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 06:30:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 163F12CCB1;
        Mon, 11 Apr 2022 03:27:51 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A927E63004;
        Mon, 11 Apr 2022 12:23:49 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 02/11] netfilter: ecache: move to separate structure
Date:   Mon, 11 Apr 2022 12:27:35 +0200
Message-Id: <20220411102744.282101-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220411102744.282101-1-pablo@netfilter.org>
References: <20220411102744.282101-1-pablo@netfilter.org>
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

From: Florian Westphal <fw@strlen.de>

This makes it easier for a followup patch to only expose ecache
related parts of nf_conntrack_net structure.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h |  8 ++++++--
 net/netfilter/nf_conntrack_ecache.c  | 19 ++++++++++---------
 2 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index b08b70989d2c..69e6c6a218be 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -43,6 +43,11 @@ union nf_conntrack_expect_proto {
 	/* insert expect proto private data here */
 };
 
+struct nf_conntrack_net_ecache {
+	struct delayed_work dwork;
+	struct netns_ct *ct_net;
+};
+
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
 	atomic_t count;
@@ -58,8 +63,7 @@ struct nf_conntrack_net {
 	struct ctl_table_header	*sysctl_header;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
-	struct delayed_work ecache_dwork;
-	struct netns_ct *ct_net;
+	struct nf_conntrack_net_ecache ecache;
 #endif
 };
 
diff --git a/net/netfilter/nf_conntrack_ecache.c b/net/netfilter/nf_conntrack_ecache.c
index 07e65b4e92f8..0cb2da0a759a 100644
--- a/net/netfilter/nf_conntrack_ecache.c
+++ b/net/netfilter/nf_conntrack_ecache.c
@@ -96,8 +96,8 @@ static enum retry_state ecache_work_evict_list(struct ct_pcpu *pcpu)
 
 static void ecache_work(struct work_struct *work)
 {
-	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache_dwork.work);
-	struct netns_ct *ctnet = cnet->ct_net;
+	struct nf_conntrack_net *cnet = container_of(work, struct nf_conntrack_net, ecache.dwork.work);
+	struct netns_ct *ctnet = cnet->ecache.ct_net;
 	int cpu, delay = -1;
 	struct ct_pcpu *pcpu;
 
@@ -127,7 +127,7 @@ static void ecache_work(struct work_struct *work)
 
 	ctnet->ecache_dwork_pending = delay > 0;
 	if (delay >= 0)
-		schedule_delayed_work(&cnet->ecache_dwork, delay);
+		schedule_delayed_work(&cnet->ecache.dwork, delay);
 }
 
 static int __nf_conntrack_eventmask_report(struct nf_conntrack_ecache *e,
@@ -293,12 +293,12 @@ void nf_conntrack_ecache_work(struct net *net, enum nf_ct_ecache_state state)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	if (state == NFCT_ECACHE_DESTROY_FAIL &&
-	    !delayed_work_pending(&cnet->ecache_dwork)) {
-		schedule_delayed_work(&cnet->ecache_dwork, HZ);
+	    !delayed_work_pending(&cnet->ecache.dwork)) {
+		schedule_delayed_work(&cnet->ecache.dwork, HZ);
 		net->ct.ecache_dwork_pending = true;
 	} else if (state == NFCT_ECACHE_DESTROY_SENT) {
 		net->ct.ecache_dwork_pending = false;
-		mod_delayed_work(system_wq, &cnet->ecache_dwork, 0);
+		mod_delayed_work(system_wq, &cnet->ecache.dwork, 0);
 	}
 }
 
@@ -310,8 +310,9 @@ void nf_conntrack_ecache_pernet_init(struct net *net)
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
 	net->ct.sysctl_events = nf_ct_events;
-	cnet->ct_net = &net->ct;
-	INIT_DELAYED_WORK(&cnet->ecache_dwork, ecache_work);
+
+	cnet->ecache.ct_net = &net->ct;
+	INIT_DELAYED_WORK(&cnet->ecache.dwork, ecache_work);
 
 	BUILD_BUG_ON(__IPCT_MAX >= 16);	/* e->ctmask is u16 */
 }
@@ -320,5 +321,5 @@ void nf_conntrack_ecache_pernet_fini(struct net *net)
 {
 	struct nf_conntrack_net *cnet = nf_ct_pernet(net);
 
-	cancel_delayed_work_sync(&cnet->ecache_dwork);
+	cancel_delayed_work_sync(&cnet->ecache.dwork);
 }
-- 
2.30.2


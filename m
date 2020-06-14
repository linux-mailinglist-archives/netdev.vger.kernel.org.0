Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DAA1F8889
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 13:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbgFNLNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 07:13:01 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:54953 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726766AbgFNLM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 07:12:57 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from roid@mellanox.com)
        with SMTP; 14 Jun 2020 14:12:51 +0300
Received: from dev-r-vrt-138.mtr.labs.mlnx (dev-r-vrt-138.mtr.labs.mlnx [10.212.138.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 05EBCoco013296;
        Sun, 14 Jun 2020 14:12:51 +0300
From:   Roi Dayan <roid@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     pablo@netfilter.org, davem@davemloft.net,
        Jiri Pirko <jiri@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Roi Dayan <roid@mellanox.com>, Alaa Hleihel <alaa@mellanox.com>
Subject: [PATCH net 1/2] net/sched: act_ct: Make tcf_ct_flow_table_restore_skb inline
Date:   Sun, 14 Jun 2020 14:12:48 +0300
Message-Id: <20200614111249.6145-2-roid@mellanox.com>
X-Mailer: git-send-email 2.8.4
In-Reply-To: <20200614111249.6145-1-roid@mellanox.com>
References: <20200614111249.6145-1-roid@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alaa Hleihel <alaa@mellanox.com>

Currently, tcf_ct_flow_table_restore_skb is exported by act_ct
module, therefore modules using it will have hard-dependency
on act_ct and will require loading it all the time.

This can lead to an unnecessary overhead on systems that do not
use hardware connection tracking action (ct_metadata action) in
the first place.

To relax the hard-dependency between the modules, we unexport this
function and make it a static inline one.

Fixes: 30b0cf90c6dd ("net/sched: act_ct: Support restoring conntrack info on skbs")
Signed-off-by: Alaa Hleihel <alaa@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
---
 include/net/tc_act/tc_ct.h | 11 ++++++++++-
 net/sched/act_ct.c         | 11 -----------
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/include/net/tc_act/tc_ct.h b/include/net/tc_act/tc_ct.h
index 79654bcb9a29..8250d6f0a462 100644
--- a/include/net/tc_act/tc_ct.h
+++ b/include/net/tc_act/tc_ct.h
@@ -66,7 +66,16 @@ static inline struct nf_flowtable *tcf_ct_ft(const struct tc_action *a)
 #endif /* CONFIG_NF_CONNTRACK */
 
 #if IS_ENABLED(CONFIG_NET_ACT_CT)
-void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie);
+static inline void
+tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
+{
+	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
+	struct nf_conn *ct;
+
+	ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
+	nf_conntrack_get(&ct->ct_general);
+	nf_ct_set(skb, ct, ctinfo);
+}
 #else
 static inline void
 tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie) { }
diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index e29f0f45d688..e9f3576cbf71 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1543,17 +1543,6 @@ static void __exit ct_cleanup_module(void)
 	destroy_workqueue(act_ct_wq);
 }
 
-void tcf_ct_flow_table_restore_skb(struct sk_buff *skb, unsigned long cookie)
-{
-	enum ip_conntrack_info ctinfo = cookie & NFCT_INFOMASK;
-	struct nf_conn *ct;
-
-	ct = (struct nf_conn *)(cookie & NFCT_PTRMASK);
-	nf_conntrack_get(&ct->ct_general);
-	nf_ct_set(skb, ct, ctinfo);
-}
-EXPORT_SYMBOL_GPL(tcf_ct_flow_table_restore_skb);
-
 module_init(ct_init_module);
 module_exit(ct_cleanup_module);
 MODULE_AUTHOR("Paul Blakey <paulb@mellanox.com>");
-- 
2.8.4


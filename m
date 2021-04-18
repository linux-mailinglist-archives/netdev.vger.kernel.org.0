Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8613637AB
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhDRVE5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:04:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35002 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbhDRVEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id AD69163E8F;
        Sun, 18 Apr 2021 23:03:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 04/14] netfilter: conntrack: move autoassign_helper sysctl to net_generic data
Date:   Sun, 18 Apr 2021 23:04:05 +0200
Message-Id: <20210418210415.4719-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

While at it, make it an u8, no need to use an integer for a boolean.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h    | 1 +
 net/netfilter/nf_conntrack_helper.c     | 6 ++++--
 net/netfilter/nf_conntrack_standalone.c | 7 +++----
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index c532b629db7b..db8f047eb75f 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -45,6 +45,7 @@ union nf_conntrack_expect_proto {
 
 struct nf_conntrack_net {
 	/* only used when new connection is allocated: */
+	u8 sysctl_auto_assign_helper;
 	bool auto_assign_helper_warned;
 
 	/* only used from work queues, configuration plane, and so on: */
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index ad91964eaa92..ac396cc8bfae 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -216,7 +216,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 {
 	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
 
-	if (!net->ct.sysctl_auto_assign_helper) {
+	if (!cnet->sysctl_auto_assign_helper) {
 		if (cnet->auto_assign_helper_warned)
 			return NULL;
 		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
@@ -560,7 +560,9 @@ static const struct nf_ct_ext_type helper_extend = {
 
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
-	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
+	cnet->sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
 }
 
 int nf_conntrack_helper_init(void)
diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_conntrack_standalone.c
index 54d36d3eb905..a7538379cfca 100644
--- a/net/netfilter/nf_conntrack_standalone.c
+++ b/net/netfilter/nf_conntrack_standalone.c
@@ -662,10 +662,9 @@ static struct ctl_table nf_ct_sysctl_table[] = {
 	},
 	[NF_SYSCTL_CT_HELPER] = {
 		.procname	= "nf_conntrack_helper",
-		.data		= &init_net.ct.sysctl_auto_assign_helper,
-		.maxlen		= sizeof(int),
+		.maxlen		= sizeof(u8),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= proc_dou8vec_minmax,
 		.extra1 	= SYSCTL_ZERO,
 		.extra2 	= SYSCTL_ONE,
 	},
@@ -1042,7 +1041,7 @@ static int nf_conntrack_standalone_init_sysctl(struct net *net)
 	table[NF_SYSCTL_CT_CHECKSUM].data = &net->ct.sysctl_checksum;
 	table[NF_SYSCTL_CT_LOG_INVALID].data = &net->ct.sysctl_log_invalid;
 	table[NF_SYSCTL_CT_ACCT].data = &net->ct.sysctl_acct;
-	table[NF_SYSCTL_CT_HELPER].data = &net->ct.sysctl_auto_assign_helper;
+	table[NF_SYSCTL_CT_HELPER].data = &cnet->sysctl_auto_assign_helper;
 #ifdef CONFIG_NF_CONNTRACK_EVENTS
 	table[NF_SYSCTL_CT_EVENTS].data = &net->ct.sysctl_events;
 #endif
-- 
2.30.2


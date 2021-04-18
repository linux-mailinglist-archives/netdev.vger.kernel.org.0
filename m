Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 874863637A8
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 23:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhDRVE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 17:04:56 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34996 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbhDRVEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 17:04:54 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 2249463E8C;
        Sun, 18 Apr 2021 23:03:55 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 03/14] netfilter: conntrack: move autoassign warning member to net_generic data
Date:   Sun, 18 Apr 2021 23:04:04 +0200
Message-Id: <20210418210415.4719-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Not accessed in fast path, place this is generic_net data instead.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_conntrack.h | 4 ++++
 net/netfilter/nf_conntrack_helper.c  | 9 ++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index 86d86c860ede..c532b629db7b 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -44,6 +44,10 @@ union nf_conntrack_expect_proto {
 };
 
 struct nf_conntrack_net {
+	/* only used when new connection is allocated: */
+	bool auto_assign_helper_warned;
+
+	/* only used from work queues, configuration plane, and so on: */
 	unsigned int users4;
 	unsigned int users6;
 	unsigned int users_bridge;
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index b055187235f8..ad91964eaa92 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -43,6 +43,8 @@ MODULE_PARM_DESC(nf_conntrack_helper,
 static DEFINE_MUTEX(nf_ct_nat_helpers_mutex);
 static struct list_head nf_ct_nat_helpers __read_mostly;
 
+extern unsigned int nf_conntrack_net_id;
+
 /* Stupid hash, but collision free for the default registrations of the
  * helpers currently in the kernel. */
 static unsigned int helper_hash(const struct nf_conntrack_tuple *tuple)
@@ -212,8 +214,10 @@ EXPORT_SYMBOL_GPL(nf_ct_helper_ext_add);
 static struct nf_conntrack_helper *
 nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 {
+	struct nf_conntrack_net *cnet = net_generic(net, nf_conntrack_net_id);
+
 	if (!net->ct.sysctl_auto_assign_helper) {
-		if (net->ct.auto_assign_helper_warned)
+		if (cnet->auto_assign_helper_warned)
 			return NULL;
 		if (!__nf_ct_helper_find(&ct->tuplehash[IP_CT_DIR_REPLY].tuple))
 			return NULL;
@@ -221,7 +225,7 @@ nf_ct_lookup_helper(struct nf_conn *ct, struct net *net)
 			"has been turned off for security reasons and CT-based "
 			"firewall rule not found. Use the iptables CT target "
 			"to attach helpers instead.\n");
-		net->ct.auto_assign_helper_warned = 1;
+		cnet->auto_assign_helper_warned = true;
 		return NULL;
 	}
 
@@ -556,7 +560,6 @@ static const struct nf_ct_ext_type helper_extend = {
 
 void nf_conntrack_helper_pernet_init(struct net *net)
 {
-	net->ct.auto_assign_helper_warned = false;
 	net->ct.sysctl_auto_assign_helper = nf_ct_auto_assign_helper;
 }
 
-- 
2.30.2


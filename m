Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54E93119CB
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 04:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232155AbhBFDTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 22:19:24 -0500
Received: from correo.us.es ([193.147.175.20]:54022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhBFDH7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Feb 2021 22:07:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 73A5C191907
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61DA9DA78F
        for <netdev@vger.kernel.org>; Sat,  6 Feb 2021 02:50:13 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 56AD3DA78C; Sat,  6 Feb 2021 02:50:13 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF4ABDA704;
        Sat,  6 Feb 2021 02:50:10 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 06 Feb 2021 02:50:10 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 9F6C542E0F80;
        Sat,  6 Feb 2021 02:50:10 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 1/7] netfilter: ctnetlink: remove get_ct indirection
Date:   Sat,  6 Feb 2021 02:49:59 +0100
Message-Id: <20210206015005.23037-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210206015005.23037-1-pablo@netfilter.org>
References: <20210206015005.23037-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Use nf_ct_get() directly, its a small inline helper without dependencies.

Add CONFIG_NF_CONNTRACK guards to elide the relevant part when conntrack
isn't available at all.

v2: add ifdef guard around nf_ct_get call (kernel test robot)
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter.h            |  2 --
 net/netfilter/nf_conntrack_netlink.c |  7 -------
 net/netfilter/nfnetlink_log.c        |  8 +++++++-
 net/netfilter/nfnetlink_queue.c      | 10 ++++++++--
 4 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 0101747de549..f0f3a8354c3c 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -463,8 +463,6 @@ extern struct nf_ct_hook __rcu *nf_ct_hook;
 struct nlattr;
 
 struct nfnl_ct_hook {
-	struct nf_conn *(*get_ct)(const struct sk_buff *skb,
-				  enum ip_conntrack_info *ctinfo);
 	size_t (*build_size)(const struct nf_conn *ct);
 	int (*build)(struct sk_buff *skb, struct nf_conn *ct,
 		     enum ip_conntrack_info ctinfo,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 84caf3316946..1469365bac7e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2686,12 +2686,6 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       ;
 }
 
-static struct nf_conn *ctnetlink_glue_get_ct(const struct sk_buff *skb,
-					     enum ip_conntrack_info *ctinfo)
-{
-	return nf_ct_get(skb, ctinfo);
-}
-
 static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 {
 	const struct nf_conntrack_zone *zone;
@@ -2925,7 +2919,6 @@ static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
 }
 
 static struct nfnl_ct_hook ctnetlink_glue_hook = {
-	.get_ct		= ctnetlink_glue_get_ct,
 	.build_size	= ctnetlink_glue_build_size,
 	.build		= ctnetlink_glue_build,
 	.parse		= ctnetlink_glue_parse,
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index b35e8d9a5b37..26776b88a539 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -43,6 +43,10 @@
 #include "../bridge/br_private.h"
 #endif
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
+#include <net/netfilter/nf_conntrack.h>
+#endif
+
 #define NFULNL_COPY_DISABLED	0xff
 #define NFULNL_NLBUFSIZ_DEFAULT	NLMSG_GOODSIZE
 #define NFULNL_TIMEOUT_DEFAULT 	100	/* every second */
@@ -733,14 +737,16 @@ nfulnl_log_packet(struct net *net,
 		size += nla_total_size(sizeof(u_int32_t));
 	if (inst->flags & NFULNL_CFG_F_SEQ_GLOBAL)
 		size += nla_total_size(sizeof(u_int32_t));
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (inst->flags & NFULNL_CFG_F_CONNTRACK) {
 		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(skb, &ctinfo);
+			ct = nf_ct_get(skb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
 	}
+#endif
 	if (pf == NFPROTO_NETDEV || pf == NFPROTO_BRIDGE)
 		size += nfulnl_get_bridge_size(skb);
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d1d8bca03b4f..48a07914fd94 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -444,13 +444,15 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
 		if (nfnl_ct != NULL) {
-			ct = nfnl_ct->get_ct(entskb, &ctinfo);
+			ct = nf_ct_get(entskb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
 	}
+#endif
 
 	if (queue->flags & NFQA_CFG_F_UID_GID) {
 		size += (nla_total_size(sizeof(u_int32_t))	/* uid */
@@ -1104,9 +1106,10 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      struct nf_queue_entry *entry,
 				      enum ip_conntrack_info *ctinfo)
 {
+#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct;
 
-	ct = nfnl_ct->get_ct(entry->skb, ctinfo);
+	ct = nf_ct_get(entry->skb, ctinfo);
 	if (ct == NULL)
 		return NULL;
 
@@ -1118,6 +1121,9 @@ static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
 				      NETLINK_CB(entry->skb).portid,
 				      nlmsg_report(nlh));
 	return ct;
+#else
+	return NULL;
+#endif
 }
 
 static int nfqa_parse_bridge(struct nf_queue_entry *entry,
-- 
2.20.1


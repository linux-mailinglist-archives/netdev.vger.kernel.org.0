Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18692B70C5
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387817AbfISB02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48106 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387767AbfISB01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 21:26:27 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 842A78A1C87;
        Thu, 19 Sep 2019 01:26:21 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D971060C18;
        Thu, 19 Sep 2019 01:26:13 +0000 (UTC)
From:   Richard Guy Briggs <rgb@redhat.com>
To:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Paul Moore <paul@paul-moore.com>, sgrubb@redhat.com,
        omosnace@redhat.com, dhowells@redhat.com, simo@redhat.com,
        eparis@parisplace.org, serge@hallyn.com, ebiederm@xmission.com,
        nhorman@tuxdriver.com, dwalsh@redhat.com, mpatel@redhat.com,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH ghak90 V7 13/21] audit: NETFILTER_PKT: record each container ID associated with a netNS
Date:   Wed, 18 Sep 2019 21:22:30 -0400
Message-Id: <18f14bfbffc30c53c2b1dd06694b69ef286f3b72.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
In-Reply-To: <cover.1568834524.git.rgb@redhat.com>
References: <cover.1568834524.git.rgb@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Thu, 19 Sep 2019 01:26:26 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add audit container identifier auxiliary record(s) to NETFILTER_PKT
event standalone records.  Iterate through all potential audit container
identifiers associated with a network namespace.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
---
 include/linux/audit.h    |  5 +++++
 kernel/audit.c           | 39 +++++++++++++++++++++++++++++++++++++++
 net/netfilter/nft_log.c  | 11 +++++++++--
 net/netfilter/xt_AUDIT.c | 11 +++++++++--
 4 files changed, 62 insertions(+), 4 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 73e3ab38e3e0..dcd92f964120 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -241,6 +241,8 @@ static inline u64 audit_get_contid(struct task_struct *tsk)
 extern void audit_netns_contid_del(struct net *net, u64 contid);
 extern void audit_switch_task_namespaces(struct nsproxy *ns,
 					 struct task_struct *p);
+extern void audit_log_netns_contid_list(struct net *net,
+					struct audit_context *context);
 
 extern u32 audit_enabled;
 
@@ -328,6 +330,9 @@ static inline void audit_netns_contid_del(struct net *net, u64 contid)
 static inline void audit_switch_task_namespaces(struct nsproxy *ns,
 						struct task_struct *p)
 { }
+static inline void audit_log_netns_contid_list(struct net *net,
+					       struct audit_context *context)
+{ }
 
 #define audit_enabled AUDIT_OFF
 
diff --git a/kernel/audit.c b/kernel/audit.c
index e0c27bc39925..9ce7a1ec7a92 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -450,6 +450,45 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
 		audit_netns_contid_add(new->net_ns, contid);
 }
 
+/**
+ * audit_log_netns_contid_list - List contids for the given network namespace
+ * @net: the network namespace of interest
+ * @context: the audit context to use
+ *
+ * Description:
+ * Issues a CONTAINER_ID record with a CSV list of contids associated
+ * with a network namespace to accompany a NETFILTER_PKT record.
+ */
+void audit_log_netns_contid_list(struct net *net, struct audit_context *context)
+{
+	struct audit_buffer *ab = NULL;
+	struct audit_contid *cont;
+	struct audit_net *aunet;
+
+	/* Generate AUDIT_CONTAINER_ID record with container ID CSV list */
+	rcu_read_lock();
+	aunet = net_generic(net, audit_net_id);
+	if (!aunet)
+		goto out;
+	list_for_each_entry_rcu(cont, &aunet->contid_list, list) {
+		if (!ab) {
+			ab = audit_log_start(context, GFP_ATOMIC,
+					     AUDIT_CONTAINER_ID);
+			if (!ab) {
+				audit_log_lost("out of memory in audit_log_netns_contid_list");
+				goto out;
+			}
+			audit_log_format(ab, "contid=");
+		} else
+			audit_log_format(ab, ",");
+		audit_log_format(ab, "%llu", cont->id);
+	}
+	audit_log_end(ab);
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(audit_log_netns_contid_list);
+
 void audit_panic(const char *message)
 {
 	switch (audit_failure) {
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index fe4831f2258f..98d1e7e1a83c 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -66,13 +66,16 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 	struct sk_buff *skb = pkt->skb;
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (!audit_enabled)
 		return;
 
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (!ab)
-		return;
+		goto errout;
 
 	audit_log_format(ab, "mark=%#x", skb->mark);
 
@@ -99,6 +102,10 @@ static void nft_log_eval_audit(const struct nft_pktinfo *pkt)
 		audit_log_format(ab, " saddr=? daddr=? proto=-1");
 
 	audit_log_end(ab);
+	net = xt_net(&pkt->xt);
+	audit_log_netns_contid_list(net, context);
+errout:
+	audit_free_context(context);
 }
 
 static void nft_log_eval(const struct nft_expr *expr,
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
index 9cdc16b0d0d8..ecf868a1abde 100644
--- a/net/netfilter/xt_AUDIT.c
+++ b/net/netfilter/xt_AUDIT.c
@@ -68,10 +68,13 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 {
 	struct audit_buffer *ab;
 	int fam = -1;
+	struct audit_context *context;
+	struct net *net;
 
 	if (audit_enabled == AUDIT_OFF)
-		goto errout;
-	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
+		goto out;
+	context = audit_alloc_local(GFP_ATOMIC);
+	ab = audit_log_start(context, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
 	if (ab == NULL)
 		goto errout;
 
@@ -101,7 +104,11 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
 
 	audit_log_end(ab);
 
+	net = xt_net(par);
+	audit_log_netns_contid_list(net, context);
 errout:
+	audit_free_context(context);
+out:
 	return XT_CONTINUE;
 }
 
-- 
1.8.3.1


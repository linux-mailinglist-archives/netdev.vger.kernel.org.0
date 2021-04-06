Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4923553AC
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344114AbhDFMW2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34438 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343969AbhDFMWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:02 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F2DA563E5F;
        Tue,  6 Apr 2021 14:21:28 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/28] netfilter: nft_log: perform module load from nf_tables
Date:   Tue,  6 Apr 2021 14:21:13 +0200
Message-Id: <20210406122133.1644-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

modprobe calls from the nf_logger_find_get() API causes deadlock in very
special cases because they occur with the nf_tables transaction mutex held.

In the specific case of nf_log, deadlock is via:

 A nf_tables -> transaction mutex -> nft_log -> modprobe -> nf_log_syslog \
	    -> pernet_ops rwsem -> wait for C
 B netlink event -> rtnl_mutex -> nf_tables transaction mutex -> wait for A
 C close() -> ip6mr_sk_done -> rtnl_mutex -> wait for B

Earlier patch added NFLOG/xt_LOG module softdeps to avoid the need to load
the backend module during a transaction.

For nft_log we would have to add a softdep for both nfnetlink_log or
nf_log_syslog, since we do not know in advance which of the two backends
are going to be configured.

This defers the modprobe op until after the transaction mutex is released.

Tested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +++++
 net/netfilter/nf_log.c            |  3 ---
 net/netfilter/nf_tables_api.c     |  5 +++--
 net/netfilter/nft_log.c           | 20 +++++++++++++++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 0cef5ad9768a..8fefa112ae89 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1562,4 +1562,9 @@ void nf_tables_trans_destroy_flush_work(void);
 int nf_msecs_to_jiffies64(const struct nlattr *nla, u64 *result);
 __be64 nf_jiffies64_to_msecs(u64 input);
 
+#ifdef CONFIG_MODULES
+__printf(2, 3) int nft_request_module(struct net *net, const char *fmt, ...);
+#else
+static inline int nft_request_module(struct net *net, const char *fmt, ...) { return -ENOENT; }
+#endif
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
index eaa8181f5ef7..edee7fa944c1 100644
--- a/net/netfilter/nf_log.c
+++ b/net/netfilter/nf_log.c
@@ -170,9 +170,6 @@ int nf_logger_find_get(int pf, enum nf_log_type type)
 		return 0;
 	}
 
-	if (rcu_access_pointer(loggers[pf][type]) == NULL)
-		request_module("nf-logger-%u-%u", pf, type);
-
 	rcu_read_lock();
 	logger = rcu_dereference(loggers[pf][type]);
 	if (logger == NULL)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fc2526b8bd55..c09b67f2f64c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -586,8 +586,8 @@ struct nft_module_request {
 };
 
 #ifdef CONFIG_MODULES
-static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
-					     ...)
+__printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
+				      ...)
 {
 	char module_name[MODULE_NAME_LEN];
 	struct nft_module_request *req;
@@ -620,6 +620,7 @@ static __printf(2, 3) int nft_request_module(struct net *net, const char *fmt,
 
 	return -EAGAIN;
 }
+EXPORT_SYMBOL_GPL(nft_request_module);
 #endif
 
 static void lockdep_nfnl_nft_mutex_not_held(void)
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index a06a46b039c5..54f6c2035e84 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -128,6 +128,20 @@ static const struct nla_policy nft_log_policy[NFTA_LOG_MAX + 1] = {
 	[NFTA_LOG_FLAGS]	= { .type = NLA_U32 },
 };
 
+static int nft_log_modprobe(struct net *net, enum nf_log_type t)
+{
+	switch (t) {
+	case NF_LOG_TYPE_LOG:
+		return nft_request_module(net, "%s", "nf_log_syslog");
+	case NF_LOG_TYPE_ULOG:
+		return nft_request_module(net, "%s", "nfnetlink_log");
+	case NF_LOG_TYPE_MAX:
+		break;
+	}
+
+	return -ENOENT;
+}
+
 static int nft_log_init(const struct nft_ctx *ctx,
 			const struct nft_expr *expr,
 			const struct nlattr * const tb[])
@@ -197,8 +211,12 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		return 0;
 
 	err = nf_logger_find_get(ctx->family, li->type);
-	if (err < 0)
+	if (err < 0) {
+		if (nft_log_modprobe(ctx->net, li->type) == -EAGAIN)
+			err = -EAGAIN;
+
 		goto err1;
+	}
 
 	return 0;
 
-- 
2.30.2


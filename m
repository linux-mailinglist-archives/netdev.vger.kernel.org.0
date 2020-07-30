Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A939D2338FA
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 21:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgG3T0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 15:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbgG3T0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 15:26:35 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A145FC061574
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 12:26:35 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1k1ECI-0003X2-0u; Thu, 30 Jul 2020 21:26:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     edumazet@google.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 7/9] mptcp: enable JOIN requests even if cookies are in use
Date:   Thu, 30 Jul 2020 21:25:56 +0200
Message-Id: <20200730192558.25697-8-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200730192558.25697-1-fw@strlen.de>
References: <20200730192558.25697-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

JOIN requests do not work in syncookie mode -- for HMAC validation, the
peers nonce and the mptcp token (to obtain the desired connection socket
the join is for) are required, but this information is only present in the
initial syn.

So either we need to drop all JOIN requests once a listening socket enters
syncookie mode, or we need to store enough state to reconstruct the request
socket later.

This adds a state table (1024 entries) to store the data present in the
MP_JOIN syn request and the random nonce used for the cookie syn/ack.

When a MP_JOIN ACK passed cookie validation, the table is consulted
to rebuild the request socket from it.

An alternate approach would be to "cancel" syn-cookie mode and force
MP_JOIN to always use a syn queue entry.

However, doing so brings the backlog over the configured queue limit.

v2: use req->syncookie, not (removed) want_cookie arg

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/syncookies.c  |   6 ++
 net/mptcp/Makefile     |   1 +
 net/mptcp/ctrl.c       |   1 +
 net/mptcp/protocol.h   |  20 +++++++
 net/mptcp/subflow.c    |  14 +++++
 net/mptcp/syncookies.c | 132 +++++++++++++++++++++++++++++++++++++++++
 6 files changed, 174 insertions(+)
 create mode 100644 net/mptcp/syncookies.c

diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 54838ee2e8d4..11b20474be83 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -212,6 +212,12 @@ struct sock *tcp_get_cookie_sock(struct sock *sk, struct sk_buff *skb,
 		refcount_set(&req->rsk_refcnt, 1);
 		tcp_sk(child)->tsoffset = tsoff;
 		sock_rps_save_rxhash(child, skb);
+
+		if (tcp_rsk(req)->drop_req) {
+			refcount_set(&req->rsk_refcnt, 2);
+			return child;
+		}
+
 		if (inet_csk_reqsk_queue_add(sk, req, child))
 			return child;
 
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 2360cbd27d59..a611968be4d7 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -4,6 +4,7 @@ obj-$(CONFIG_MPTCP) += mptcp.o
 mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o \
 	   mib.o pm_netlink.o
 
+obj-$(CONFIG_SYN_COOKIES) += syncookies.o
 obj-$(CONFIG_INET_MPTCP_DIAG) += mptcp_diag.o
 
 mptcp_crypto_test-objs := crypto_test.o
diff --git a/net/mptcp/ctrl.c b/net/mptcp/ctrl.c
index 8e39585d37f3..54b888f94009 100644
--- a/net/mptcp/ctrl.c
+++ b/net/mptcp/ctrl.c
@@ -112,6 +112,7 @@ static struct pernet_operations mptcp_pernet_ops = {
 
 void __init mptcp_init(void)
 {
+	mptcp_join_cookie_init();
 	mptcp_proto_init();
 
 	if (register_pernet_subsys(&mptcp_pernet_ops) < 0)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d76d3b40d69e..60b27d44c184 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -506,4 +506,24 @@ static inline bool subflow_simultaneous_connect(struct sock *sk)
 	       !subflow->conn_finished;
 }
 
+#ifdef CONFIG_SYN_COOKIES
+void subflow_init_req_cookie_join_save(const struct mptcp_subflow_request_sock *subflow_req,
+				       struct sk_buff *skb);
+bool mptcp_token_join_cookie_init_state(struct mptcp_subflow_request_sock *subflow_req,
+					struct sk_buff *skb);
+void __init mptcp_join_cookie_init(void);
+#else
+static inline void
+subflow_init_req_cookie_join_save(const struct mptcp_subflow_request_sock *subflow_req,
+				  struct sk_buff *skb) {}
+static inline bool
+mptcp_token_join_cookie_init_state(struct mptcp_subflow_request_sock *subflow_req,
+				   struct sk_buff *skb)
+{
+	return false;
+}
+
+static inline void mptcp_join_cookie_init(void) {}
+#endif
+
 #endif /* __MPTCP_PROTOCOL_H */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 3d346572d4c9..a4cc4591bd4e 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -173,6 +173,12 @@ static void subflow_init_req(struct request_sock *req,
 		subflow_req->token = mp_opt.token;
 		subflow_req->remote_nonce = mp_opt.nonce;
 		subflow_req->msk = subflow_token_join_request(req, skb);
+
+		if (unlikely(req->syncookie) && subflow_req->msk) {
+			if (mptcp_can_accept_new_subflow(subflow_req->msk))
+				subflow_init_req_cookie_join_save(subflow_req, skb);
+		}
+
 		pr_debug("token=%u, remote_nonce=%u msk=%p", subflow_req->token,
 			 subflow_req->remote_nonce, subflow_req->msk);
 	}
@@ -207,6 +213,14 @@ int mptcp_subflow_init_cookie_req(struct request_sock *req,
 
 		subflow_req->mp_capable = 1;
 		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq - 1;
+	} else if (mp_opt.mp_join && listener->request_mptcp) {
+		if (!mptcp_token_join_cookie_init_state(subflow_req, skb))
+			return -EINVAL;
+
+		if (mptcp_can_accept_new_subflow(subflow_req->msk))
+			subflow_req->mp_join = 1;
+
+		subflow_req->ssn_offset = TCP_SKB_CB(skb)->seq - 1;
 	}
 
 	return 0;
diff --git a/net/mptcp/syncookies.c b/net/mptcp/syncookies.c
new file mode 100644
index 000000000000..6eb992789b50
--- /dev/null
+++ b/net/mptcp/syncookies.c
@@ -0,0 +1,132 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/skbuff.h>
+
+#include "protocol.h"
+
+/* Syncookies do not work for JOIN requests.
+ *
+ * Unlike MP_CAPABLE, where the ACK cookie contains the needed MPTCP
+ * options to reconstruct the initial syn state, MP_JOIN does not contain
+ * the token to obtain the mptcp socket nor the server-generated nonce
+ * that was used in the cookie SYN/ACK response.
+ *
+ * Keep a small best effort state table to store the syn/synack data,
+ * indexed by skb hash.
+ *
+ * A MP_JOIN SYN packet handled by syn cookies is only stored if the 32bit
+ * token matches a known mptcp connection that can still accept more subflows.
+ *
+ * There is no timeout handling -- state is only re-constructed
+ * when the TCP ACK passed the cookie validation check.
+ */
+
+struct join_entry {
+	u32 token;
+	u32 remote_nonce;
+	u32 local_nonce;
+	u8 join_id;
+	u8 local_id;
+	u8 backup;
+	u8 valid;
+};
+
+#define COOKIE_JOIN_SLOTS	1024
+
+static struct join_entry join_entries[COOKIE_JOIN_SLOTS] __cacheline_aligned_in_smp;
+static spinlock_t join_entry_locks[COOKIE_JOIN_SLOTS] __cacheline_aligned_in_smp;
+
+static u32 mptcp_join_entry_hash(struct sk_buff *skb, struct net *net)
+{
+	u32 i = skb_get_hash(skb) ^ net_hash_mix(net);
+
+	return i % ARRAY_SIZE(join_entries);
+}
+
+static void mptcp_join_store_state(struct join_entry *entry,
+				   const struct mptcp_subflow_request_sock *subflow_req)
+{
+	entry->token = subflow_req->token;
+	entry->remote_nonce = subflow_req->remote_nonce;
+	entry->local_nonce = subflow_req->local_nonce;
+	entry->backup = subflow_req->backup;
+	entry->join_id = subflow_req->remote_id;
+	entry->local_id = subflow_req->local_id;
+	entry->valid = 1;
+}
+
+void subflow_init_req_cookie_join_save(const struct mptcp_subflow_request_sock *subflow_req,
+				       struct sk_buff *skb)
+{
+	struct net *net = read_pnet(&subflow_req->sk.req.ireq_net);
+	u32 i = mptcp_join_entry_hash(skb, net);
+
+	/* No use in waiting if other cpu is already using this slot --
+	 * would overwrite the data that got stored.
+	 */
+	spin_lock_bh(&join_entry_locks[i]);
+	mptcp_join_store_state(&join_entries[i], subflow_req);
+	spin_unlock_bh(&join_entry_locks[i]);
+}
+
+/* Called for a cookie-ack with MP_JOIN option present.
+ * Look up the saved state based on skb hash & check token matches msk
+ * in same netns.
+ *
+ * Caller will check msk can still accept another subflow.  The hmac
+ * present in the cookie ACK mptcp option space will be checked later.
+ */
+bool mptcp_token_join_cookie_init_state(struct mptcp_subflow_request_sock *subflow_req,
+					struct sk_buff *skb)
+{
+	struct net *net = read_pnet(&subflow_req->sk.req.ireq_net);
+	u32 i = mptcp_join_entry_hash(skb, net);
+	struct mptcp_sock *msk;
+	struct join_entry *e;
+
+	e = &join_entries[i];
+
+	spin_lock_bh(&join_entry_locks[i]);
+
+	if (e->valid == 0) {
+		spin_unlock_bh(&join_entry_locks[i]);
+		return false;
+	}
+
+	e->valid = 0;
+
+	msk = mptcp_token_get_sock(e->token);
+	if (!msk) {
+		spin_unlock_bh(&join_entry_locks[i]);
+		return false;
+	}
+
+	/* If this fails, the token got re-used in the mean time by another
+	 * mptcp socket in a different netns, i.e. entry is outdated.
+	 */
+	if (!net_eq(sock_net((struct sock *)msk), net))
+		goto err_put;
+
+	subflow_req->remote_nonce = e->remote_nonce;
+	subflow_req->local_nonce = e->local_nonce;
+	subflow_req->backup = e->backup;
+	subflow_req->remote_id = e->join_id;
+	subflow_req->token = e->token;
+	subflow_req->msk = msk;
+	spin_unlock_bh(&join_entry_locks[i]);
+	return true;
+
+err_put:
+	spin_unlock_bh(&join_entry_locks[i]);
+	sock_put((struct sock *)msk);
+	return false;
+}
+
+void __init mptcp_join_cookie_init(void)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(join_entry_locks); i++)
+		spin_lock_init(&join_entry_locks[i]);
+
+	BUILD_BUG_ON(ARRAY_SIZE(join_entry_locks) != ARRAY_SIZE(join_entries));
+}
-- 
2.26.2


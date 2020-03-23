Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33525190049
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbgCWV3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:29:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:27337 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727117AbgCWV3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:29:40 -0400
IronPort-SDR: Xe/9LCq7T7YMgsI5zye41afzVXEAzvXF9t968Zxu35vv+W8obRiruCYXwwHtrzzxnGY4X+TJTb
 3CPS1sMWHOtg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2020 14:29:39 -0700
IronPort-SDR: uMG5c6wGJ7yMlQuSCpHMAMlchXZPDGd/WaoYu1um4BKid1hOF8/ZShf+4YyDUDIdtUbr5xxBF7
 dEqKyAc3ChQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,297,1580803200"; 
   d="scan'208";a="445960434"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.254.100.76])
  by fmsmga005.fm.intel.com with ESMTP; 23 Mar 2020 14:29:39 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, eric.dumazet@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 14/17] mptcp: add and use MIB counter infrastructure
Date:   Mon, 23 Mar 2020 14:26:39 -0700
Message-Id: <20200323212642.34104-15-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
References: <20200323212642.34104-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Exported via same /proc file as the Linux TCP MIB counters, so "netstat -s"
or "nstat" will show them automatically.

The MPTCP MIB counters are allocated in a distinct pcpu area in order to
avoid bloating/wasting TCP pcpu memory.

Counters are allocated once the first MPTCP socket is created in a
network namespace and free'd on exit.

If no sockets have been allocated, all-zero mptcp counters are shown.

The MIB counter list is taken from the multipath-tcp.org kernel, but
only a few counters have been picked up so far.  The counter list can
be increased at any time later on.

Co-developed-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 include/net/mptcp.h     |  4 +++
 include/net/netns/mib.h |  3 ++
 net/ipv4/af_inet.c      |  4 +++
 net/ipv4/proc.c         |  2 ++
 net/mptcp/Makefile      |  2 +-
 net/mptcp/mib.c         | 69 +++++++++++++++++++++++++++++++++++++++++
 net/mptcp/mib.h         | 40 ++++++++++++++++++++++++
 net/mptcp/protocol.c    | 30 +++++++++++++-----
 net/mptcp/subflow.c     | 33 ++++++++++++++++----
 9 files changed, 172 insertions(+), 15 deletions(-)
 create mode 100644 net/mptcp/mib.c
 create mode 100644 net/mptcp/mib.h

diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index b648fa20eec8..0e7c5471010b 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -12,6 +12,8 @@
 #include <linux/tcp.h>
 #include <linux/types.h>
 
+struct seq_file;
+
 /* MPTCP sk_buff extension data */
 struct mptcp_ext {
 	u64		data_ack;
@@ -123,6 +125,7 @@ static inline bool mptcp_skb_can_collapse(const struct sk_buff *to,
 
 bool mptcp_sk_is_subflow(const struct sock *sk);
 
+void mptcp_seq_show(struct seq_file *seq);
 #else
 
 static inline void mptcp_init(void)
@@ -194,6 +197,7 @@ static inline bool mptcp_sk_is_subflow(const struct sock *sk)
 	return false;
 }
 
+static inline void mptcp_seq_show(struct seq_file *seq) { }
 #endif /* CONFIG_MPTCP */
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
diff --git a/include/net/netns/mib.h b/include/net/netns/mib.h
index b5fdb108d602..59b2c3a3db42 100644
--- a/include/net/netns/mib.h
+++ b/include/net/netns/mib.h
@@ -27,6 +27,9 @@ struct netns_mib {
 #if IS_ENABLED(CONFIG_TLS)
 	DEFINE_SNMP_STAT(struct linux_tls_mib, tls_statistics);
 #endif
+#ifdef CONFIG_MPTCP
+	DEFINE_SNMP_STAT(struct mptcp_mib, mptcp_statistics);
+#endif
 };
 
 #endif
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index bd7b4e92e07f..cf58e29cf746 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1793,6 +1793,10 @@ static __net_exit void ipv4_mib_exit_net(struct net *net)
 	free_percpu(net->mib.net_statistics);
 	free_percpu(net->mib.ip_statistics);
 	free_percpu(net->mib.tcp_statistics);
+#ifdef CONFIG_MPTCP
+	/* allocated on demand, see mptcp_init_sock() */
+	free_percpu(net->mib.mptcp_statistics);
+#endif
 }
 
 static __net_initdata struct pernet_operations ipv4_mib_ops = {
diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
index 2580303249e2..75545a829a2b 100644
--- a/net/ipv4/proc.c
+++ b/net/ipv4/proc.c
@@ -32,6 +32,7 @@
 #include <net/icmp.h>
 #include <net/protocol.h>
 #include <net/tcp.h>
+#include <net/mptcp.h>
 #include <net/udp.h>
 #include <net/udplite.h>
 #include <linux/bottom_half.h>
@@ -485,6 +486,7 @@ static int netstat_seq_show(struct seq_file *seq, void *v)
 					     offsetof(struct ipstats_mib, syncp)));
 
 	seq_putc(seq, '\n');
+	mptcp_seq_show(seq);
 	return 0;
 }
 
diff --git a/net/mptcp/Makefile b/net/mptcp/Makefile
index 54494cf5bec0..faebe8ec9f73 100644
--- a/net/mptcp/Makefile
+++ b/net/mptcp/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MPTCP) += mptcp.o
 
-mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o
+mptcp-y := protocol.o subflow.o options.o token.o crypto.o ctrl.o pm.o diag.o mib.o
diff --git a/net/mptcp/mib.c b/net/mptcp/mib.c
new file mode 100644
index 000000000000..0a6a15f3456d
--- /dev/null
+++ b/net/mptcp/mib.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#include <linux/seq_file.h>
+#include <net/ip.h>
+#include <net/mptcp.h>
+#include <net/snmp.h>
+#include <net/net_namespace.h>
+
+#include "mib.h"
+
+static const struct snmp_mib mptcp_snmp_list[] = {
+	SNMP_MIB_ITEM("MPCapableSYNRX", MPTCP_MIB_MPCAPABLEPASSIVE),
+	SNMP_MIB_ITEM("MPCapableACKRX", MPTCP_MIB_MPCAPABLEPASSIVEACK),
+	SNMP_MIB_ITEM("MPCapableFallbackACK", MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK),
+	SNMP_MIB_ITEM("MPCapableFallbackSYNACK", MPTCP_MIB_MPCAPABLEACTIVEFALLBACK),
+	SNMP_MIB_ITEM("MPTCPRetrans", MPTCP_MIB_RETRANSSEGS),
+	SNMP_MIB_ITEM("MPJoinNoTokenFound", MPTCP_MIB_JOINNOTOKEN),
+	SNMP_MIB_ITEM("MPJoinSynRx", MPTCP_MIB_JOINSYNRX),
+	SNMP_MIB_ITEM("MPJoinSynAckRx", MPTCP_MIB_JOINSYNACKRX),
+	SNMP_MIB_ITEM("MPJoinSynAckHMacFailure", MPTCP_MIB_JOINSYNACKMAC),
+	SNMP_MIB_ITEM("MPJoinAckRx", MPTCP_MIB_JOINACKRX),
+	SNMP_MIB_ITEM("MPJoinAckHMacFailure", MPTCP_MIB_JOINACKMAC),
+	SNMP_MIB_ITEM("DSSNotMatching", MPTCP_MIB_DSSNOMATCH),
+	SNMP_MIB_ITEM("InfiniteMapRx", MPTCP_MIB_INFINITEMAPRX),
+	SNMP_MIB_SENTINEL
+};
+
+/* mptcp_mib_alloc - allocate percpu mib counters
+ *
+ * These are allocated when the first mptcp socket is created so
+ * we do not waste percpu memory if mptcp isn't in use.
+ */
+bool mptcp_mib_alloc(struct net *net)
+{
+	struct mptcp_mib __percpu *mib = alloc_percpu(struct mptcp_mib);
+
+	if (!mib)
+		return false;
+
+	if (cmpxchg(&net->mib.mptcp_statistics, NULL, mib))
+		free_percpu(mib);
+
+	return true;
+}
+
+void mptcp_seq_show(struct seq_file *seq)
+{
+	struct net *net = seq->private;
+	int i;
+
+	seq_puts(seq, "MPTcpExt:");
+	for (i = 0; mptcp_snmp_list[i].name; i++)
+		seq_printf(seq, " %s", mptcp_snmp_list[i].name);
+
+	seq_puts(seq, "\nMPTcpExt:");
+
+	if (!net->mib.mptcp_statistics) {
+		for (i = 0; mptcp_snmp_list[i].name; i++)
+			seq_puts(seq, " 0");
+
+		return;
+	}
+
+	for (i = 0; mptcp_snmp_list[i].name; i++)
+		seq_printf(seq, " %lu",
+			   snmp_fold_field(net->mib.mptcp_statistics,
+					   mptcp_snmp_list[i].entry));
+	seq_putc(seq, '\n');
+}
diff --git a/net/mptcp/mib.h b/net/mptcp/mib.h
new file mode 100644
index 000000000000..d7de340fc997
--- /dev/null
+++ b/net/mptcp/mib.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+enum linux_mptcp_mib_field {
+	MPTCP_MIB_NUM = 0,
+	MPTCP_MIB_MPCAPABLEPASSIVE,	/* Received SYN with MP_CAPABLE */
+	MPTCP_MIB_MPCAPABLEPASSIVEACK,	/* Received third ACK with MP_CAPABLE */
+	MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK,/* Server-side fallback during 3-way handshake */
+	MPTCP_MIB_MPCAPABLEACTIVEFALLBACK, /* Client-side fallback during 3-way handshake */
+	MPTCP_MIB_RETRANSSEGS,		/* Segments retransmitted at the MPTCP-level */
+	MPTCP_MIB_JOINNOTOKEN,		/* Received MP_JOIN but the token was not found */
+	MPTCP_MIB_JOINSYNRX,		/* Received a SYN + MP_JOIN */
+	MPTCP_MIB_JOINSYNACKRX,		/* Received a SYN/ACK + MP_JOIN */
+	MPTCP_MIB_JOINSYNACKMAC,	/* HMAC was wrong on SYN/ACK + MP_JOIN */
+	MPTCP_MIB_JOINACKRX,		/* Received an ACK + MP_JOIN */
+	MPTCP_MIB_JOINACKMAC,		/* HMAC was wrong on ACK + MP_JOIN */
+	MPTCP_MIB_DSSNOMATCH,		/* Received a new mapping that did not match the previous one */
+	MPTCP_MIB_INFINITEMAPRX,	/* Received an infinite mapping */
+	__MPTCP_MIB_MAX
+};
+
+#define LINUX_MIB_MPTCP_MAX	__MPTCP_MIB_MAX
+struct mptcp_mib {
+	unsigned long mibs[LINUX_MIB_MPTCP_MAX];
+};
+
+static inline void MPTCP_INC_STATS(struct net *net,
+				   enum linux_mptcp_mib_field field)
+{
+	if (likely(net->mib.mptcp_statistics))
+		SNMP_INC_STATS(net->mib.mptcp_statistics, field);
+}
+
+static inline void __MPTCP_INC_STATS(struct net *net,
+				     enum linux_mptcp_mib_field field)
+{
+	if (likely(net->mib.mptcp_statistics))
+		__SNMP_INC_STATS(net->mib.mptcp_statistics, field);
+}
+
+bool mptcp_mib_alloc(struct net *net);
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 75fa78a09af4..fc82b6508ae7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -21,6 +21,7 @@
 #endif
 #include <net/mptcp.h>
 #include "protocol.h"
+#include "mib.h"
 
 #define MPTCP_SAME_STATE TCP_MAX_STATES
 
@@ -1032,6 +1033,7 @@ static void mptcp_worker(struct work_struct *work)
 		if (ret < 0)
 			break;
 
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_RETRANSSEGS);
 		copied += ret;
 		dfrag->data_len -= ret;
 		dfrag->offset += ret;
@@ -1081,17 +1083,22 @@ static int __mptcp_init_sock(struct sock *sk)
 
 static int mptcp_init_sock(struct sock *sk)
 {
-	int ret = __mptcp_init_sock(sk);
+	struct net *net = sock_net(sk);
+	int ret;
 
+	if (!mptcp_is_enabled(net))
+		return -ENOPROTOOPT;
+
+	if (unlikely(!net->mib.mptcp_statistics) && !mptcp_mib_alloc(net))
+		return -ENOMEM;
+
+	ret = __mptcp_init_sock(sk);
 	if (ret)
 		return ret;
 
 	sk_sockets_allocated_inc(sk);
 	sk->sk_sndbuf = sock_net(sk)->ipv4.sysctl_tcp_wmem[2];
 
-	if (!mptcp_is_enabled(sock_net(sk)))
-		return -ENOPROTOOPT;
-
 	return 0;
 }
 
@@ -1327,7 +1334,12 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		list_add(&subflow->node, &msk->conn_list);
 
 		bh_unlock_sock(new_mptcp_sock);
+
+		__MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEPASSIVEACK);
 		local_bh_enable();
+	} else {
+		MPTCP_INC_STATS(sock_net(sk),
+				MPTCP_MIB_MPCAPABLEPASSIVEFALLBACK);
 	}
 
 	return newsk;
@@ -1448,13 +1460,15 @@ void mptcp_finish_connect(struct sock *ssk)
 	u64 ack_seq;
 
 	subflow = mptcp_subflow_ctx(ssk);
-
-	if (!subflow->mp_capable)
-		return;
-
 	sk = subflow->conn;
 	msk = mptcp_sk(sk);
 
+	if (!subflow->mp_capable) {
+		MPTCP_INC_STATS(sock_net(sk),
+				MPTCP_MIB_MPCAPABLEACTIVEFALLBACK);
+		return;
+	}
+
 	pr_debug("msk=%p, token=%u", sk, subflow->token);
 
 	mptcp_crypto_key_sha(subflow->remote_key, NULL, &ack_seq);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 5ed524ae88ba..479ad7df4554 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -20,6 +20,13 @@
 #endif
 #include <net/mptcp.h>
 #include "protocol.h"
+#include "mib.h"
+
+static inline void SUBFLOW_REQ_INC_STATS(struct request_sock *req,
+					 enum linux_mptcp_mib_field field)
+{
+	MPTCP_INC_STATS(sock_net(req_to_sk(req)), field);
+}
 
 static int subflow_rebuild_header(struct sock *sk)
 {
@@ -88,8 +95,7 @@ static bool subflow_token_join_request(struct request_sock *req,
 
 	msk = mptcp_token_get_sock(subflow_req->token);
 	if (!msk) {
-		pr_debug("subflow_req=%p, token=%u - not found\n",
-			 subflow_req, subflow_req->token);
+		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINNOTOKEN);
 		return false;
 	}
 
@@ -137,8 +143,14 @@ static void subflow_init_req(struct request_sock *req,
 		return;
 #endif
 
-	if (rx_opt.mptcp.mp_capable && rx_opt.mptcp.mp_join)
-		return;
+	if (rx_opt.mptcp.mp_capable) {
+		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_MPCAPABLEPASSIVE);
+
+		if (rx_opt.mptcp.mp_join)
+			return;
+	} else if (rx_opt.mptcp.mp_join) {
+		SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINSYNRX);
+	}
 
 	if (rx_opt.mptcp.mp_capable && listener->request_mptcp) {
 		int err;
@@ -231,6 +243,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			 subflow, subflow->thmac,
 			 subflow->remote_nonce);
 		if (!subflow_thmac_valid(subflow)) {
+			MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINACKMAC);
 			subflow->mp_join = 0;
 			goto do_reset;
 		}
@@ -247,6 +260,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			goto do_reset;
 
 		subflow->conn_finished = 1;
+		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_JOINSYNACKRX);
 	} else {
 do_reset:
 		tcp_send_active_reset(sk, GFP_ATOMIC);
@@ -376,8 +390,10 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		opt_rx.mptcp.mp_join = 0;
 		mptcp_get_options(skb, &opt_rx);
 		if (!opt_rx.mptcp.mp_join ||
-		    !subflow_hmac_valid(req, &opt_rx))
+		    !subflow_hmac_valid(req, &opt_rx)) {
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKMAC);
 			return NULL;
+		}
 	}
 
 create_child:
@@ -414,6 +430,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			ctx->conn = (struct sock *)owner;
 			if (!mptcp_finish_join(child))
 				goto close_child;
+
+			SUBFLOW_REQ_INC_STATS(req, MPTCP_MIB_JOINACKRX);
 		}
 	}
 
@@ -529,6 +547,7 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 	data_len = mpext->data_len;
 	if (data_len == 0) {
 		pr_err("Infinite mapping not handled");
+		MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_INFINITEMAPRX);
 		return MAPPING_INVALID;
 	}
 
@@ -572,8 +591,10 @@ static enum mapping_status get_mapping_status(struct sock *ssk)
 		/* If this skb data are fully covered by the current mapping,
 		 * the new map would need caching, which is not supported
 		 */
-		if (skb_is_fully_mapped(ssk, skb))
+		if (skb_is_fully_mapped(ssk, skb)) {
+			MPTCP_INC_STATS(sock_net(ssk), MPTCP_MIB_DSSNOMATCH);
 			return MAPPING_INVALID;
+		}
 
 		/* will validate the next map after consuming the current one */
 		return MAPPING_OK;
-- 
2.26.0


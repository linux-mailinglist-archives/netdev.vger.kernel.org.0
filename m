Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 361A2C94F9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729283AbfJBXhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:37:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:16472 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729170AbfJBXhl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 19:37:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Oct 2019 16:37:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,250,1566889200"; 
   d="scan'208";a="366862629"
Received: from mjmartin-nuc02.mjmartin-nuc02 (HELO mjmartin-nuc02.sea.intel.com) ([10.251.30.230])
  by orsmga005.jf.intel.com with ESMTP; 02 Oct 2019 16:37:23 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        cpaasch@apple.com, fw@strlen.de, pabeni@redhat.com,
        peter.krystad@linux.intel.com, dcaratti@redhat.com,
        matthieu.baerts@tessares.net
Subject: [RFC PATCH v2 34/45] mptcp: Make MPTCP socket block/wakeup ignore sk_receive_queue
Date:   Wed,  2 Oct 2019 16:36:44 -0700
Message-Id: <20191002233655.24323-35-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
References: <20191002233655.24323-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MPTCP-level socket doesn't use sk_receive_queue, so it was possible
for mptcp_recvmsg() to remain blocked when there was data ready for it
to read. When the MPTCP socket is waiting for additional data and it
releases the subflow socket lock, the subflow may have incoming packets
ready to process and it sometimes called subflow_data_ready() before the
MPTCP socket called sk_wait_data().

This change adds a new function for the MPTCP socket to use when waiting
for a data ready signal. Atomic bitops with memory barriers are used to
set, test, and clear a MPTCP socket flag that indicates waiting subflow
data. This flag replaces the sk_receive_queue checks used by other
socket types.

Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 31 ++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  4 ++++
 net/mptcp/subflow.c  |  5 +++++
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 445800eae767..c8ee20963887 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -367,6 +367,31 @@ static enum mapping_status mptcp_get_mapping(struct sock *ssk)
 	return ret;
 }
 
+static void mptcp_wait_data(struct sock *sk, long *timeo)
+{
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+	struct mptcp_sock *msk = mptcp_sk(sk);
+	int data_ready;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+	sk_set_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+
+	release_sock(sk);
+
+	smp_mb__before_atomic();
+	data_ready = test_and_clear_bit(MPTCP_DATA_READY, &msk->flags);
+	smp_mb__after_atomic();
+
+	if (!data_ready)
+		*timeo = wait_woken(&wait, TASK_INTERRUPTIBLE, *timeo);
+
+	sched_annotate_sleep();
+	lock_sock(sk);
+
+	sk_clear_bit(SOCKWQ_ASYNC_WAITDATA, sk);
+	remove_wait_queue(sk_sleep(sk), &wait);
+}
+
 static void warn_bad_map(struct mptcp_subflow_context *subflow, u32 ssn)
 {
 	WARN_ONCE(1, "Bad mapping: ssn=%d map_seq=%d map_data_len=%d",
@@ -423,6 +448,10 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		u64 old_ack;
 		u32 ssn;
 
+		smp_mb__before_atomic();
+		clear_bit(MPTCP_DATA_READY, &msk->flags);
+		smp_mb__after_atomic();
+
 		status = mptcp_get_mapping(ssk);
 
 		if (status == MAPPING_ADDED) {
@@ -550,7 +579,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		pr_debug("block");
 		release_sock(ssk);
-		sk_wait_data(sk, &timeo, NULL);
+		mptcp_wait_data(sk, &timeo);
 		lock_sock(ssk);
 	}
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 4a1171b75ec6..56df4f46f313 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -74,6 +74,9 @@
 #define MPTCP_ADDR_IPVERSION_4	4
 #define MPTCP_ADDR_IPVERSION_6	6
 
+/* MPTCP socket flags */
+#define MPTCP_DATA_READY	BIT(0)
+
 static inline __be32 mptcp_option(u8 subopt, u8 len, u8 nib, u8 field)
 {
 	return htonl((TCPOPT_MPTCP << 24) | (len << 16) | (subopt << 12) |
@@ -117,6 +120,7 @@ struct mptcp_sock {
 	u64		write_seq;
 	u64		ack_seq;
 	u32		token;
+	unsigned long	flags;
 	u16		dport;
 	struct list_head conn_list;
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 257e52d9595e..7a94049587cc 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -311,6 +311,11 @@ static void subflow_data_ready(struct sock *sk)
 
 	if (parent) {
 		pr_debug("parent=%p", parent);
+
+		smp_mb__before_atomic();
+		set_bit(MPTCP_DATA_READY, &mptcp_sk(parent)->flags);
+		smp_mb__after_atomic();
+
 		parent->sk_data_ready(parent);
 	}
 }
-- 
2.23.0


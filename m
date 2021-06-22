Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3A3AFA35
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 02:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbhFVAff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 20:35:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:8652 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230272AbhFVAfc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 20:35:32 -0400
IronPort-SDR: voTMf5D45wEROORp5U2iW9J1W3cz3T8uMu7KuUkkWG9e69k3tp0QZUgGKMC3OTDUFRJHbdws9z
 uteneF0MfX5g==
X-IronPort-AV: E=McAfee;i="6200,9189,10022"; a="203944695"
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="203944695"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 17:33:15 -0700
IronPort-SDR: 4tOZh1C5/AHVYSx0BCEsZAVOXMlJdL6x1Coyr6CNVf4Q9j/UcLd3kpO9vDBnM1JNLGVRjbJqfU
 lO93rkPsHrXA==
X-IronPort-AV: E=Sophos;i="5.83,290,1616482800"; 
   d="scan'208";a="417234899"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.74.136])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jun 2021 17:33:14 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev, fw@strlen.de, dcaratti@redhat.com,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/2] mptcp: avoid race on msk state changes
Date:   Mon, 21 Jun 2021 17:33:08 -0700
Message-Id: <20210622003309.71224-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210622003309.71224-1-mathew.j.martineau@linux.intel.com>
References: <20210622003309.71224-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

The msk socket state is currently updated in a few spots without
owning the msk socket lock itself.

Some of such operations are safe, as they happens before exposing
the msk socket to user-space and can't race with other changes.

A couple of them, at connect time, can actually race with close()
or shutdown(), leaving breaking the socket state machine.

This change addresses the issue moving such update under the msk
socket lock with the usual:

<acquire spinlock>
<check sk lock onwers>
<ev defer to release_cb>

scheme.

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/56
Fixes: 8fd738049ac3 ("mptcp: fallback in case of simultaneous connect")
Fixes: c3c123d16c0e ("net: mptcp: don't hang in mptcp_sendmsg() after TCP fallback")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  5 +++++
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 30 ++++++++++++++++++++++--------
 3 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 632350018fb6..8ead550df8b1 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2946,6 +2946,11 @@ static void mptcp_release_cb(struct sock *sk)
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
 
+	/* be sure to set the current sk state before tacking actions
+	 * depending on sk_state
+	 */
+	if (test_and_clear_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags))
+		__mptcp_set_connected(sk);
 	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
 		__mptcp_clean_una_wakeup(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5d7c44028e47..7b634568f49c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -109,6 +109,7 @@
 #define MPTCP_ERROR_REPORT	8
 #define MPTCP_RETRANSMIT	9
 #define MPTCP_WORK_SYNC_SETSOCKOPT 10
+#define MPTCP_CONNECTED		11
 
 static inline bool before64(__u64 seq1, __u64 seq2)
 {
@@ -579,6 +580,7 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
+void __mptcp_set_connected(struct sock *sk);
 static inline bool mptcp_is_fully_established(struct sock *sk)
 {
 	return inet_sk_state_load(sk) == TCP_ESTABLISHED &&
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 037fba41e170..9f934603bfe8 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -371,6 +371,24 @@ static bool subflow_use_different_dport(struct mptcp_sock *msk, const struct soc
 	return inet_sk(sk)->inet_dport != inet_sk((struct sock *)msk)->inet_dport;
 }
 
+void __mptcp_set_connected(struct sock *sk)
+{
+	if (sk->sk_state == TCP_SYN_SENT) {
+		inet_sk_state_store(sk, TCP_ESTABLISHED);
+		sk->sk_state_change(sk);
+	}
+}
+
+static void mptcp_set_connected(struct sock *sk)
+{
+	mptcp_data_lock(sk);
+	if (!sock_owned_by_user(sk))
+		__mptcp_set_connected(sk);
+	else
+		set_bit(MPTCP_CONNECTED, &mptcp_sk(sk)->flags);
+	mptcp_data_unlock(sk);
+}
+
 static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
@@ -379,10 +397,6 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 
 	subflow->icsk_af_ops->sk_rx_dst_set(sk, skb);
 
-	if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
-		inet_sk_state_store(parent, TCP_ESTABLISHED);
-		parent->sk_state_change(parent);
-	}
 
 	/* be sure no special action on any packet other than syn-ack */
 	if (subflow->conn_finished)
@@ -411,6 +425,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 			 subflow->remote_key);
 		MPTCP_INC_STATS(sock_net(sk), MPTCP_MIB_MPCAPABLEACTIVEACK);
 		mptcp_finish_connect(sk);
+		mptcp_set_connected(parent);
 	} else if (subflow->request_join) {
 		u8 hmac[SHA256_DIGEST_SIZE];
 
@@ -451,6 +466,7 @@ static void subflow_finish_connect(struct sock *sk, const struct sk_buff *skb)
 	} else if (mptcp_check_fallback(sk)) {
 fallback:
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
+		mptcp_set_connected(parent);
 	}
 	return;
 
@@ -558,6 +574,7 @@ static void mptcp_sock_destruct(struct sock *sk)
 
 static void mptcp_force_close(struct sock *sk)
 {
+	/* the msk is not yet exposed to user-space */
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk_common_release(sk);
 }
@@ -1474,10 +1491,7 @@ static void subflow_state_change(struct sock *sk)
 		mptcp_rcv_space_init(mptcp_sk(parent), sk);
 		pr_fallback(mptcp_sk(parent));
 		subflow->conn_finished = 1;
-		if (inet_sk_state_load(parent) == TCP_SYN_SENT) {
-			inet_sk_state_store(parent, TCP_ESTABLISHED);
-			parent->sk_state_change(parent);
-		}
+		mptcp_set_connected(parent);
 	}
 
 	/* as recvmsg() does not acquire the subflow socket for ssk selection
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802C2467FF2
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 23:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383424AbhLCWjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 17:39:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:46470 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383419AbhLCWjL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 17:39:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10187"; a="223940930"
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="223940930"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
X-IronPort-AV: E=Sophos;i="5.87,284,1631602800"; 
   d="scan'208";a="460185303"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.18.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2021 14:35:47 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 01/10] mptcp: add TCP_INQ cmsg support
Date:   Fri,  3 Dec 2021 14:35:32 -0800
Message-Id: <20211203223541.69364-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
References: <20211203223541.69364-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Support the TCP_INQ setsockopt.

This is a boolean that tells recvmsg path to include the remaining
in-sequence bytes in the cmsg data.

v2: do not use CB(skb)->offset, increment map_seq instead (Paolo Abeni)
v3: adjust CB(skb)->map_seq when taking skb from ofo queue (Paolo Abeni)

Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/224
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 36 +++++++++++++++++++++++++++++++++++-
 net/mptcp/protocol.h |  1 +
 net/mptcp/sockopt.c  | 38 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index b100048e43fe..ffc8068aaad0 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -46,6 +46,7 @@ struct mptcp_skb_cb {
 
 enum {
 	MPTCP_CMSG_TS = BIT(0),
+	MPTCP_CMSG_INQ = BIT(1),
 };
 
 static struct percpu_counter mptcp_sockets_allocated ____cacheline_aligned_in_smp;
@@ -738,6 +739,7 @@ static bool __mptcp_ofo_queue(struct mptcp_sock *msk)
 				 MPTCP_SKB_CB(skb)->map_seq, msk->ack_seq,
 				 delta);
 			MPTCP_SKB_CB(skb)->offset += delta;
+			MPTCP_SKB_CB(skb)->map_seq += delta;
 			__skb_queue_tail(&sk->sk_receive_queue, skb);
 		}
 		msk->ack_seq = end_seq;
@@ -1784,8 +1786,10 @@ static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
 		copied += count;
 
 		if (count < data_len) {
-			if (!(flags & MSG_PEEK))
+			if (!(flags & MSG_PEEK)) {
 				MPTCP_SKB_CB(skb)->offset += count;
+				MPTCP_SKB_CB(skb)->map_seq += count;
+			}
 			break;
 		}
 
@@ -1965,6 +1969,27 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	return !skb_queue_empty(&msk->receive_queue);
 }
 
+static unsigned int mptcp_inq_hint(const struct sock *sk)
+{
+	const struct mptcp_sock *msk = mptcp_sk(sk);
+	const struct sk_buff *skb;
+
+	skb = skb_peek(&msk->receive_queue);
+	if (skb) {
+		u64 hint_val = msk->ack_seq - MPTCP_SKB_CB(skb)->map_seq;
+
+		if (hint_val >= INT_MAX)
+			return INT_MAX;
+
+		return (unsigned int)hint_val;
+	}
+
+	if (sk->sk_state == TCP_CLOSE || (sk->sk_shutdown & RCV_SHUTDOWN))
+		return 1;
+
+	return 0;
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
@@ -1989,6 +2014,9 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	len = min_t(size_t, len, INT_MAX);
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
+	if (unlikely(msk->recvmsg_inq))
+		cmsg_flags = MPTCP_CMSG_INQ;
+
 	while (copied < len) {
 		int bytes_read;
 
@@ -2062,6 +2090,12 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (cmsg_flags && copied >= 0) {
 		if (cmsg_flags & MPTCP_CMSG_TS)
 			tcp_recv_timestamp(msg, sk, &tss);
+
+		if (cmsg_flags & MPTCP_CMSG_INQ) {
+			unsigned int inq = mptcp_inq_hint(sk);
+
+			put_cmsg(msg, SOL_TCP, TCP_CM_INQ, sizeof(inq), &inq);
+		}
 	}
 
 	pr_debug("msk=%p rx queue empty=%d:%d copied=%d",
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index d87cc040352e..bb51fa7f5566 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -249,6 +249,7 @@ struct mptcp_sock {
 	bool		rcv_fastclose;
 	bool		use_64bit_ack; /* Set when we received a 64-bit DSN */
 	bool		csum_enabled;
+	u8		recvmsg_inq:1;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct sk_buff  *ooo_last_skb;
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index fb43e145cb57..11cda8629993 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -557,6 +557,7 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		case TCP_TIMESTAMP:
 		case TCP_NOTSENT_LOWAT:
 		case TCP_TX_DELAY:
+		case TCP_INQ:
 			return true;
 		}
 
@@ -568,7 +569,6 @@ static bool mptcp_supported_sockopt(int level, int optname)
 		/* TCP_FASTOPEN_KEY, TCP_FASTOPEN TCP_FASTOPEN_CONNECT, TCP_FASTOPEN_NO_COOKIE,
 		 * are not supported fastopen is currently unsupported
 		 */
-		/* TCP_INQ is currently unsupported, needs some recvmsg work */
 	}
 	return false;
 }
@@ -698,7 +698,21 @@ static int mptcp_setsockopt_v4(struct mptcp_sock *msk, int optname,
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    sockptr_t optval, unsigned int optlen)
 {
+	struct sock *sk = (void *)msk;
+	int ret, val;
+
 	switch (optname) {
+	case TCP_INQ:
+		ret = mptcp_get_int_option(msk, optval, optlen, &val);
+		if (ret)
+			return ret;
+		if (val < 0 || val > 1)
+			return -EINVAL;
+
+		lock_sock(sk);
+		msk->recvmsg_inq = !!val;
+		release_sock(sk);
+		return 0;
 	case TCP_ULP:
 		return -EOPNOTSUPP;
 	case TCP_CONGESTION:
@@ -1032,6 +1046,26 @@ static int mptcp_getsockopt_subflow_addrs(struct mptcp_sock *msk, char __user *o
 	return 0;
 }
 
+static int mptcp_put_int_option(struct mptcp_sock *msk, char __user *optval,
+				int __user *optlen, int val)
+{
+	int len;
+
+	if (get_user(len, optlen))
+		return -EFAULT;
+
+	len = min_t(unsigned int, len, sizeof(int));
+	if (len < 0)
+		return -EINVAL;
+
+	if (put_user(len, optlen))
+		return -EFAULT;
+	if (copy_to_user(optval, &val, len))
+		return -EFAULT;
+
+	return 0;
+}
+
 static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 				    char __user *optval, int __user *optlen)
 {
@@ -1042,6 +1076,8 @@ static int mptcp_getsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_CC_INFO:
 		return mptcp_getsockopt_first_sf_only(msk, SOL_TCP, optname,
 						      optval, optlen);
+	case TCP_INQ:
+		return mptcp_put_int_option(msk, optval, optlen, msk->recvmsg_inq);
 	}
 	return -EOPNOTSUPP;
 }
-- 
2.34.1


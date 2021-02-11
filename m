Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6783E3196B0
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 00:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhBKXe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 18:34:26 -0500
Received: from mga05.intel.com ([192.55.52.43]:55194 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229969AbhBKXd6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 18:33:58 -0500
IronPort-SDR: ldjdhsruIyyuM6jDSbdGIF9ZhZ2LGufnty0qSUJvrJz2cGK621sa2iybFxi96EvRYYX/CdzKJS
 egqnZg9EqbpQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9892"; a="267177942"
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="267177942"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:50 -0800
IronPort-SDR: srpEAyoocqOuZK1qFBwUG54LYOfCOBgJBoQr5ikhfaEAMOTlnuZYMPoo/wgEKlbJLnFdpemNkU
 Y6813juJn++g==
X-IronPort-AV: E=Sophos;i="5.81,172,1610438400"; 
   d="scan'208";a="381226388"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.100.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2021 15:30:49 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, mptcp@lists.01.org, matthieu.baerts@tessares.net,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 5/6] mptcp: better msk receive window updates
Date:   Thu, 11 Feb 2021 15:30:41 -0800
Message-Id: <20210211233042.304878-6-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
References: <20210211233042.304878-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Move mptcp_cleanup_rbuf() related checks inside the mentioned
helper and extend them to mirror TCP checks more closely.

Additionally drop the 'rmem_pending' hack, since commit 879526030c8b
("mptcp: protect the rx path with the msk socket spinlock") we
can use instead 'rmem_released'.

Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/options.c  |  7 ++++---
 net/mptcp/protocol.c | 38 ++++++++++++++++++++++----------------
 net/mptcp/protocol.h |  3 +--
 3 files changed, 27 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index e0d21c0607e5..82a37cc26776 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -498,8 +498,8 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(sk);
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+	u64 snd_data_fin_enable, ack_seq;
 	unsigned int dss_size = 0;
-	u64 snd_data_fin_enable;
 	struct mptcp_ext *mpext;
 	unsigned int ack_size;
 	bool ret = false;
@@ -531,13 +531,14 @@ static bool mptcp_established_options_dss(struct sock *sk, struct sk_buff *skb,
 		return ret;
 	}
 
+	ack_seq = READ_ONCE(msk->ack_seq);
 	if (READ_ONCE(msk->use_64bit_ack)) {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK64;
-		opts->ext_copy.data_ack = READ_ONCE(msk->ack_seq);
+		opts->ext_copy.data_ack = ack_seq;
 		opts->ext_copy.ack64 = 1;
 	} else {
 		ack_size = TCPOLEN_MPTCP_DSS_ACK32;
-		opts->ext_copy.data_ack32 = (uint32_t)READ_ONCE(msk->ack_seq);
+		opts->ext_copy.data_ack32 = (uint32_t)ack_seq;
 		opts->ext_copy.ack64 = 0;
 	}
 	opts->ext_copy.use_ack = 1;
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c11fcf6f5faf..0dbf5cbd7e56 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -457,7 +457,18 @@ static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
 static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
 {
 	struct sock *ack_hint = READ_ONCE(msk->ack_hint);
+	int old_space = READ_ONCE(msk->old_wspace);
 	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	bool cleanup;
+
+	/* this is a simple superset of what tcp_cleanup_rbuf() implements
+	 * so that we don't have to acquire the ssk socket lock most of the time
+	 * to do actually nothing
+	 */
+	cleanup = __mptcp_space(sk) - old_space >= max(0, old_space);
+	if (!cleanup)
+		return;
 
 	/* if the hinted ssk is still active, try to use it */
 	if (likely(ack_hint)) {
@@ -1865,7 +1876,7 @@ static void __mptcp_splice_receive_queue(struct sock *sk)
 	skb_queue_splice_tail_init(&sk->sk_receive_queue, &msk->receive_queue);
 }
 
-static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
+static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
 	unsigned int moved = 0;
@@ -1885,13 +1896,10 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
 
 		slowpath = lock_sock_fast(ssk);
 		mptcp_data_lock(sk);
+		__mptcp_update_rmem(sk);
 		done = __mptcp_move_skbs_from_subflow(msk, ssk, &moved);
 		mptcp_data_unlock(sk);
-		if (moved && rcv) {
-			WRITE_ONCE(msk->rmem_pending, min(rcv, moved));
-			tcp_cleanup_rbuf(ssk, 1);
-			WRITE_ONCE(msk->rmem_pending, 0);
-		}
+		tcp_cleanup_rbuf(ssk, moved);
 		unlock_sock_fast(ssk, slowpath);
 	} while (!done);
 
@@ -1904,6 +1912,7 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk, unsigned int rcv)
 		ret |= __mptcp_ofo_queue(msk);
 		__mptcp_splice_receive_queue(sk);
 		mptcp_data_unlock(sk);
+		mptcp_cleanup_rbuf(msk);
 	}
 	if (ret)
 		mptcp_check_data_fin((struct sock *)msk);
@@ -1933,7 +1942,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 
 	while (copied < len) {
-		int bytes_read, old_space;
+		int bytes_read;
 
 		bytes_read = __mptcp_recvmsg_mskq(msk, msg, len - copied);
 		if (unlikely(bytes_read < 0)) {
@@ -1944,14 +1953,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 		copied += bytes_read;
 
-		if (skb_queue_empty(&msk->receive_queue) &&
-		    __mptcp_move_skbs(msk, len - copied))
-			continue;
-
 		/* be sure to advertise window change */
-		old_space = READ_ONCE(msk->old_wspace);
-		if ((tcp_space(sk) - old_space) >= old_space)
-			mptcp_cleanup_rbuf(msk);
+		mptcp_cleanup_rbuf(msk);
+
+		if (skb_queue_empty(&msk->receive_queue) && __mptcp_move_skbs(msk))
+			continue;
 
 		/* only the master socket status is relevant here. The exit
 		 * conditions mirror closely tcp_recvmsg()
@@ -1979,7 +1985,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				/* race breaker: the shutdown could be after the
 				 * previous receive queue check
 				 */
-				if (__mptcp_move_skbs(msk, len - copied))
+				if (__mptcp_move_skbs(msk))
 					continue;
 				break;
 			}
@@ -2012,7 +2018,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		/* .. race-breaker: ssk might have gotten new data
 		 * after last __mptcp_move_skbs() returned false.
 		 */
-		if (unlikely(__mptcp_move_skbs(msk, 0)))
+		if (unlikely(__mptcp_move_skbs(msk)))
 			set_bit(MPTCP_DATA_READY, &msk->flags);
 	} else if (unlikely(!test_bit(MPTCP_DATA_READY, &msk->flags))) {
 		/* data to read but mptcp_wait_data() cleared DATA_READY */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6a164add5b6f..8d9f0ff10cb8 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -234,7 +234,6 @@ struct mptcp_sock {
 	u64		wnd_end;
 	unsigned long	timer_ival;
 	u32		token;
-	int		rmem_pending;
 	int		rmem_released;
 	unsigned long	flags;
 	bool		can_ack;
@@ -293,7 +292,7 @@ static inline struct mptcp_sock *mptcp_sk(const struct sock *sk)
 
 static inline int __mptcp_space(const struct sock *sk)
 {
-	return tcp_space(sk) + READ_ONCE(mptcp_sk(sk)->rmem_pending);
+	return tcp_space(sk) + READ_ONCE(mptcp_sk(sk)->rmem_released);
 }
 
 static inline struct mptcp_data_frag *mptcp_send_head(const struct sock *sk)
-- 
2.30.1


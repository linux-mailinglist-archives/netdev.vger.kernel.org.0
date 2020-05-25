Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200F11E13EF
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388621AbgEYSPd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:15:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387644AbgEYSPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:15:32 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6532AC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:15:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jdHdK-0007l9-Od; Mon, 25 May 2020 20:15:30 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     matthieu.baerts@tessares.net, mathew.j.martineau@linux.intel.com,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 net-next 2/2] mptcp: move recbuf adjustment to recvmsg path
Date:   Mon, 25 May 2020 20:15:08 +0200
Message-Id: <20200525181508.13492-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525181508.13492-1-fw@strlen.de>
References: <20200525181508.13492-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Place receive window tuning in the recvmsg path.
This makes sure the size is only increased when userspace consumes data.

Previously we would grow the sk receive buffer towards tcp_rmem[2], now we
so only if userspace reads data.

Simply adjust the msk rcvbuf size to the largest receive buffer of any of
the existing subflows.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 This patch is new in v2.

 net/mptcp/protocol.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index dbb86cbb9e77..89a35c3fc499 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -190,13 +190,6 @@ static bool __mptcp_move_skbs_from_subflow(struct mptcp_sock *msk,
 		return false;
 	}
 
-	if (!(sk->sk_userlocks & SOCK_RCVBUF_LOCK)) {
-		int rcvbuf = max(ssk->sk_rcvbuf, sk->sk_rcvbuf);
-
-		if (rcvbuf > sk->sk_rcvbuf)
-			sk->sk_rcvbuf = rcvbuf;
-	}
-
 	tp = tcp_sk(ssk);
 	do {
 		u32 map_remaining, offset;
@@ -933,6 +926,25 @@ static bool __mptcp_move_skbs(struct mptcp_sock *msk)
 	return moved > 0;
 }
 
+static void mptcp_rcv_space_adjust(struct mptcp_sock *msk)
+{
+	const struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	const struct sock *ssk;
+	int rcvbuf = 0;
+
+	if (sk->sk_userlocks & SOCK_RCVBUF_LOCK)
+		return;
+
+	mptcp_for_each_subflow(msk, subflow) {
+		ssk = mptcp_subflow_tcp_sock(subflow);
+		rcvbuf = max(ssk->sk_rcvbuf, rcvbuf);
+	}
+
+	if (rcvbuf)
+		sk->sk_rcvbuf = rcvbuf;
+}
+
 static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 			 int nonblock, int flags, int *addr_len)
 {
@@ -962,6 +974,8 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
 	__mptcp_flush_join_list(msk);
 
+	mptcp_rcv_space_adjust(msk);
+
 	while (len > (size_t)copied) {
 		int bytes_read;
 
@@ -975,8 +989,10 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		copied += bytes_read;
 
 		if (skb_queue_empty(&sk->sk_receive_queue) &&
-		    __mptcp_move_skbs(msk))
+		    __mptcp_move_skbs(msk)) {
+			mptcp_rcv_space_adjust(msk);
 			continue;
+		}
 
 		/* only the master socket status is relevant here. The exit
 		 * conditions mirror closely tcp_recvmsg()
-- 
2.26.2


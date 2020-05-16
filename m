Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3923F1D5FC1
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbgEPIrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:47:18 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77940C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:47:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsTV-0005t0-5L; Sat, 16 May 2020 10:47:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 3/7] mptcp: avoid blocking in tcp_sendpages
Date:   Sat, 16 May 2020 10:46:19 +0200
Message-Id: <20200516084623.28453-4-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The transmit loop continues to xmit new data until an error is returned
or all data was transmitted.

For the blocking i/o case, this means that tcp_sendpages() may block on
the subflow until more space becomes available, i.e. we end up sleeping
with the mptcp socket lock held.

Instead we should check if a different subflow is ready to be used.

This restarts the subflow sk lookup when the tx operation succeeded
and the tcp subflow can't accept more data or if tcp_sendpages
indicates -EAGAIN on a blocking mptcp socket.

In that case we also need to set the NOSPACE bit to make sure we get
notified once memory becomes available.

In case all subflows are busy, the existing logic will wait until a
subflow is ready, releasing the mptcp socket lock while doing so.

The mptcp worker already sets DONTWAIT, so no need to make changes there.

v2:
 * set NOSPACE bit
 * add a comment to clarify that mptcp-sk sndbuf limits need to
   be checked as well.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 75be8d662ac5..e97357066b21 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -590,7 +590,7 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	 * access the skb after the sendpages call
 	 */
 	ret = do_tcp_sendpages(ssk, page, offset, psize,
-			       msg->msg_flags | MSG_SENDPAGE_NOTLAST);
+			       msg->msg_flags | MSG_SENDPAGE_NOTLAST | MSG_DONTWAIT);
 	if (ret <= 0)
 		return ret;
 
@@ -713,6 +713,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
+	bool tx_ok;
 	long timeo;
 
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
@@ -737,6 +738,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
+restart:
 	mptcp_clean_una(sk);
 
 wait_for_sndbuf:
@@ -772,11 +774,18 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	pr_debug("conn_list->subflow=%p", ssk);
 
 	lock_sock(ssk);
-	while (msg_data_left(msg)) {
+	tx_ok = msg_data_left(msg);
+	while (tx_ok) {
 		ret = mptcp_sendmsg_frag(sk, ssk, msg, NULL, &timeo, &mss_now,
 					 &size_goal);
-		if (ret < 0)
+		if (ret < 0) {
+			if (ret == -EAGAIN && timeo > 0) {
+				mptcp_set_timeout(sk, ssk);
+				release_sock(ssk);
+				goto restart;
+			}
 			break;
+		}
 		if (ret == 0 && unlikely(__mptcp_needs_tcp_fallback(msk))) {
 			/* Can happen for passive sockets:
 			 * 3WHS negotiated MPTCP, but first packet after is
@@ -791,11 +800,31 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 		copied += ret;
 
+		tx_ok = msg_data_left(msg);
+		if (!tx_ok)
+			break;
+
+		if (!sk_stream_memory_free(ssk)) {
+			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
+			tcp_push(ssk, msg->msg_flags, mss_now,
+				 tcp_sk(ssk)->nonagle, size_goal);
+			mptcp_set_timeout(sk, ssk);
+			release_sock(ssk);
+			goto restart;
+		}
+
 		/* memory is charged to mptcp level socket as well, i.e.
 		 * if msg is very large, mptcp socket may run out of buffer
 		 * space.  mptcp_clean_una() will release data that has
 		 * been acked at mptcp level in the mean time, so there is
 		 * a good chance we can continue sending data right away.
+		 *
+		 * Normally, when the tcp subflow can accept more data, then
+		 * so can the MPTCP socket.  However, we need to cope with
+		 * peers that might lag behind in their MPTCP-level
+		 * acknowledgements, i.e.  data might have been acked at
+		 * tcp level only.  So, we must also check the MPTCP socket
+		 * limits before we send more data.
 		 */
 		if (unlikely(!sk_stream_memory_free(sk))) {
 			tcp_push(ssk, msg->msg_flags, mss_now,
-- 
2.26.2


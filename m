Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A53E41D5FC2
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgEPIr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:47:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB17C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:47:26 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsTd-0005tZ-57; Sat, 16 May 2020 10:47:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 4/7] mptcp: fill skb extension cache outside of mptcp_sendmsg_frag
Date:   Sat, 16 May 2020 10:46:20 +0200
Message-Id: <20200516084623.28453-5-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mptcp_sendmsg_frag helper contains a loop that will wait on the
subflow sk.

It seems preferrable to only wait in mptcp_sendmsg() when blocking io is
requested.  mptcp_sendmsg already has such a wait loop that is used when
no subflow socket is available for transmission.

This is a preparation patch that makes sure we call
mptcp_sendmsg_frag only if a skb extension has been allocated.

Moreover, such allocation currently uses GFP_ATOMIC while it
could use sleeping allocation instead.

Followup patches will remove the wait loop from mptcp_sendmsg_frag()
and will allow to do a sleeping allocation for the extension.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e97357066b21..1bdfbca1c23a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -669,6 +669,9 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 
 	sock_owned_by_me((const struct sock *)msk);
 
+	if (!mptcp_ext_cache_refill(msk))
+		return NULL;
+
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
@@ -804,7 +807,8 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (!tx_ok)
 			break;
 
-		if (!sk_stream_memory_free(ssk)) {
+		if (!sk_stream_memory_free(ssk) ||
+		    !mptcp_ext_cache_refill(msk)) {
 			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			tcp_push(ssk, msg->msg_flags, mss_now,
 				 tcp_sk(ssk)->nonagle, size_goal);
@@ -1158,7 +1162,7 @@ static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
 	struct sock *ssk, *sk = &msk->sk.icsk_inet.sk;
-	int orig_len, orig_offset, ret, mss_now = 0, size_goal = 0;
+	int orig_len, orig_offset, mss_now = 0, size_goal = 0;
 	struct mptcp_data_frag *dfrag;
 	u64 orig_write_seq;
 	size_t copied = 0;
@@ -1180,6 +1184,9 @@ static void mptcp_worker(struct work_struct *work)
 	if (!dfrag)
 		goto unlock;
 
+	if (!mptcp_ext_cache_refill(msk))
+		goto reset_unlock;
+
 	ssk = mptcp_subflow_get_retrans(msk);
 	if (!ssk)
 		goto reset_unlock;
@@ -1191,8 +1198,8 @@ static void mptcp_worker(struct work_struct *work)
 	orig_offset = dfrag->offset;
 	orig_write_seq = dfrag->data_seq;
 	while (dfrag->data_len > 0) {
-		ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &timeo, &mss_now,
-					 &size_goal);
+		int ret = mptcp_sendmsg_frag(sk, ssk, &msg, dfrag, &timeo,
+					     &mss_now, &size_goal);
 		if (ret < 0)
 			break;
 
@@ -1200,6 +1207,9 @@ static void mptcp_worker(struct work_struct *work)
 		copied += ret;
 		dfrag->data_len -= ret;
 		dfrag->offset += ret;
+
+		if (!mptcp_ext_cache_refill(msk))
+			break;
 	}
 	if (copied)
 		tcp_push(ssk, msg.msg_flags, mss_now, tcp_sk(ssk)->nonagle,
-- 
2.26.2


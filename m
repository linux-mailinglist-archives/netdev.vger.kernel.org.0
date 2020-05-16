Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40921D5FC4
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgEPIrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:47:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28EE9C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:47:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsTm-0005tz-P2; Sat, 16 May 2020 10:47:34 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 5/7] mptcp: fill skb page frag cache outside of mptcp_sendmsg_frag
Date:   Sat, 16 May 2020 10:46:21 +0200
Message-Id: <20200516084623.28453-6-fw@strlen.de>
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

This is another preparation patch that makes sure we call
mptcp_sendmsg_frag only if the page frag cache has been refilled.

Followup patch will remove the wait loop from mptcp_sendmsg_frag().

The retransmit worker doesn't need to do this refill as it won't
transmit new mptcp-level data.

Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1bdfbca1c23a..a11e51222e59 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -713,6 +713,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 {
 	int mss_now = 0, size_goal = 0, ret = 0;
 	struct mptcp_sock *msk = mptcp_sk(sk);
+	struct page_frag *pfrag;
 	struct socket *ssock;
 	size_t copied = 0;
 	struct sock *ssk;
@@ -741,13 +742,16 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		return ret >= 0 ? ret + copied : (copied ? copied : ret);
 	}
 
+	pfrag = sk_page_frag(sk);
 restart:
 	mptcp_clean_una(sk);
 
 wait_for_sndbuf:
 	__mptcp_flush_join_list(msk);
 	ssk = mptcp_subflow_get_send(msk);
-	while (!sk_stream_memory_free(sk) || !ssk) {
+	while (!sk_stream_memory_free(sk) ||
+	       !ssk ||
+	       !mptcp_page_frag_refill(ssk, pfrag)) {
 		if (ssk) {
 			/* make sure retransmit timer is
 			 * running before we wait for memory.
@@ -808,6 +812,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			break;
 
 		if (!sk_stream_memory_free(ssk) ||
+		    !mptcp_page_frag_refill(ssk, pfrag) ||
 		    !mptcp_ext_cache_refill(msk)) {
 			set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 			tcp_push(ssk, msg->msg_flags, mss_now,
-- 
2.26.2


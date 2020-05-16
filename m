Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8B1D5FBE
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 10:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgEPIrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 04:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgEPIrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 04:47:03 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6161EC061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 01:47:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jZsTG-0005sM-10; Sat, 16 May 2020 10:47:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     pabeni@redhat.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/7] mptcp: move common nospace-pattern to a helper
Date:   Sat, 16 May 2020 10:46:17 +0200
Message-Id: <20200516084623.28453-2-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200516084623.28453-1-fw@strlen.de>
References: <20200516084623.28453-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo noticed that ssk_check_wmem() has same pattern, so add/use
common helper for both places.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1f52a0fa31ed..0413454fcdaf 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -653,6 +653,15 @@ static int mptcp_sendmsg_frag(struct sock *sk, struct sock *ssk,
 	return ret;
 }
 
+static void mptcp_nospace(struct mptcp_sock *msk, struct socket *sock)
+{
+	clear_bit(MPTCP_SEND_SPACE, &msk->flags);
+	smp_mb__after_atomic(); /* msk->flags is changed by write_space cb */
+
+	/* enables sk->write_space() callbacks */
+	set_bit(SOCK_NOSPACE, &sock->flags);
+}
+
 static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
@@ -666,13 +675,8 @@ static struct sock *mptcp_subflow_get_send(struct mptcp_sock *msk)
 		if (!sk_stream_memory_free(ssk)) {
 			struct socket *sock = ssk->sk_socket;
 
-			if (sock) {
-				clear_bit(MPTCP_SEND_SPACE, &msk->flags);
-				smp_mb__after_atomic();
-
-				/* enables sk->write_space() callbacks */
-				set_bit(SOCK_NOSPACE, &sock->flags);
-			}
+			if (sock)
+				mptcp_nospace(msk, sock);
 
 			return NULL;
 		}
@@ -698,13 +702,8 @@ static void ssk_check_wmem(struct mptcp_sock *msk, struct sock *ssk)
 		return;
 
 	sock = READ_ONCE(ssk->sk_socket);
-
-	if (sock) {
-		clear_bit(MPTCP_SEND_SPACE, &msk->flags);
-		smp_mb__after_atomic();
-		/* set NOSPACE only after clearing SEND_SPACE flag */
-		set_bit(SOCK_NOSPACE, &sock->flags);
-	}
+	if (sock)
+		mptcp_nospace(msk, sock);
 }
 
 static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
-- 
2.26.2


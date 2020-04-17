Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF01E1AD771
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728996AbgDQHb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:31:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgDQHb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 03:31:58 -0400
X-Greylist: delayed 190 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 17 Apr 2020 00:31:58 PDT
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7755FC061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 00:31:58 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jPLTh-00034Y-0R; Fri, 17 Apr 2020 09:31:57 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net 1/2] mptcp: fix splat when incoming connection is never accepted before exit/close
Date:   Fri, 17 Apr 2020 09:28:22 +0200
Message-Id: <20200417072823.25864-2-fw@strlen.de>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200417072823.25864-1-fw@strlen.de>
References: <20200417072823.25864-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following snippet (replicated from syzkaller reproducer) generates
warning: "IPv4: Attempt to release TCP socket in state 1".

int main(void) {
 struct sockaddr_in sin1 = { .sin_family = 2, .sin_port = 0x4e20,
                             .sin_addr.s_addr = 0x010000e0, };
 struct sockaddr_in sin2 = { .sin_family = 2,
	                     .sin_addr.s_addr = 0x0100007f, };
 struct sockaddr_in sin3 = { .sin_family = 2, .sin_port = 0x4e20,
	                     .sin_addr.s_addr = 0x0100007f, };
 int r0 = socket(0x2, 0x1, 0x106);
 int r1 = socket(0x2, 0x1, 0x106);

 bind(r1, (void *)&sin1, sizeof(sin1));
 connect(r1, (void *)&sin2, sizeof(sin2));
 listen(r1, 3);
 return connect(r0, (void *)&sin3, 0x4d);
}

Reason is that the newly generated mptcp socket is closed via the ulp
release of the tcp listener socket when its accept backlog gets purged.

To fix this, delay setting the ESTABLISHED state until after userspace
calls accept and via mptcp specific destructor.

Fixes: 58b09919626bf ("mptcp: create msk early")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/9
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c |  1 +
 net/mptcp/subflow.c  | 25 ++++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 9936e33ac351..1c8b021b4537 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1431,6 +1431,7 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
+		inet_sk_state_store(newsk, TCP_ESTABLISHED);
 
 		bh_unlock_sock(new_mptcp_sock);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 50a8bea987c6..57a836fe4988 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -347,6 +347,29 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 	return ret;
 }
 
+static void mptcp_sock_destruct(struct sock *sk)
+{
+	/* if new mptcp socket isn't accepted, it is free'd
+	 * from the tcp listener sockets request queue, linked
+	 * from req->sk.  The tcp socket is released.
+	 * This calls the ULP release function which will
+	 * also remove the mptcp socket, via
+	 * sock_put(ctx->conn).
+	 *
+	 * Problem is that the mptcp socket will not be in
+	 * SYN_RECV state and doesn't have SOCK_DEAD flag.
+	 * Both result in warnings from inet_sock_destruct.
+	 */
+
+	if (sk->sk_state == TCP_SYN_RECV) {
+		sk->sk_state = TCP_CLOSE;
+		WARN_ON_ONCE(sk->sk_socket);
+		sock_orphan(sk);
+	}
+
+	inet_sock_destruct(sk);
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -422,7 +445,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
-			inet_sk_state_store(new_msk, TCP_ESTABLISHED);
+			new_msk->sk_destruct = mptcp_sock_destruct;
 			mptcp_pm_new_connection(mptcp_sk(new_msk), 1);
 			ctx->conn = new_msk;
 			new_msk = NULL;
-- 
2.25.3


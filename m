Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5658E1AD773
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 09:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbgDQHcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Apr 2020 03:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728419AbgDQHcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Apr 2020 03:32:04 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AE7C061A0C
        for <netdev@vger.kernel.org>; Fri, 17 Apr 2020 00:32:03 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1jPLTm-00034m-H8; Fri, 17 Apr 2020 09:32:02 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH net 2/2] mptcp: fix 'Attempt to release TCP socket in state' warnings
Date:   Fri, 17 Apr 2020 09:28:23 +0200
Message-Id: <20200417072823.25864-3-fw@strlen.de>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200417072823.25864-1-fw@strlen.de>
References: <20200417072823.25864-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to set sk_state to CLOSED, else we will get following:

IPv4: Attempt to release TCP socket in state 3 00000000b95f109e
IPv4: Attempt to release TCP socket in state 10 00000000b95f109e

First one is from inet_sock_destruct(), second one from
mptcp_sk_clone failure handling.  Setting sk_state to CLOSED isn't
enough, we also need to orphan sk so it has DEAD flag set.
Otherwise, a very similar warning is printed from inet_sock_destruct().

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 7 +++++--
 net/mptcp/subflow.c  | 8 +++++++-
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1c8b021b4537..7e816c733ccb 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1355,12 +1355,15 @@ struct sock *mptcp_sk_clone(const struct sock *sk, struct request_sock *req)
 	msk->subflow = NULL;
 
 	if (unlikely(mptcp_token_new_accept(subflow_req->token, nsk))) {
+		nsk->sk_state = TCP_CLOSE;
 		bh_unlock_sock(nsk);
 
 		/* we can't call into mptcp_close() here - possible BH context
-		 * free the sock directly
+		 * free the sock directly.
+		 * sk_clone_lock() sets nsk refcnt to two, hence call sk_free()
+		 * too.
 		 */
-		nsk->sk_prot->destroy(nsk);
+		sk_common_release(nsk);
 		sk_free(nsk);
 		return NULL;
 	}
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 57a836fe4988..bc46b5091b9d 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -370,6 +370,12 @@ static void mptcp_sock_destruct(struct sock *sk)
 	inet_sock_destruct(sk);
 }
 
+static void mptcp_force_close(struct sock *sk)
+{
+	inet_sk_state_store(sk, TCP_CLOSE);
+	sk_common_release(sk);
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -467,7 +473,7 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 out:
 	/* dispose of the left over mptcp master, if any */
 	if (unlikely(new_msk))
-		sock_put(new_msk);
+		mptcp_force_close(new_msk);
 	return child;
 
 close_child:
-- 
2.25.3


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3F75ECCF9
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 21:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiI0Tdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 15:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiI0Tdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 15:33:39 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DC2F1628;
        Tue, 27 Sep 2022 12:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664307218; x=1695843218;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+T+ojb/064eW50kyu/docWvls9bdSsjpGYD0DnSFSEU=;
  b=Mpxj6Z+LLzueJOxKd5hcJfD4QQ4c+fvJd8wGxVz7GPDxoxrpSSgnYMk7
   Vy0F+hMrLW9thmJv3wJ7/VPfrSVoTx0/IRnFtkKFkoerPAgR+ZLAU6Gj9
   +sv1aj0xkQLFGfU889w66SzuBSo0IKUuzD+PbuiWf37oTeO9AVLZBosb/
   TP2CewyCP9FgyBkjpsihdlVBBSKP1TmZ0z5gIcYA6aRFE0DD9nPotebwO
   HVaebcPqwnM/OtJt86UX6o11FEfRuquOmzpqoTNtSjkL/dXcEEyoDJE6u
   FtMBdmLlY8kac3nH8s4/valrMH46nO4Nz+qOli5MOmRqepRZzVYZx10Rz
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="299010407"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="299010407"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:04 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10483"; a="652399450"
X-IronPort-AV: E=Sophos;i="5.93,350,1654585200"; 
   d="scan'208";a="652399450"
Received: from soumiban-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.81.98])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2022 12:32:03 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        fw@strlen.de, matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        stable@vger.kernel.org, Jiang Biao <benbjiang@tencent.com>,
        Mengen Sun <mengensun@tencent.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 2/2] mptcp: fix unreleased socket in accept queue
Date:   Tue, 27 Sep 2022 12:31:58 -0700
Message-Id: <20220927193158.195729-3-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
References: <20220927193158.195729-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

The mptcp socket and its subflow sockets in accept queue can't be
released after the process exit.

While the release of a mptcp socket in listening state, the
corresponding tcp socket will be released too. Meanwhile, the tcp
socket in the unaccept queue will be released too. However, only init
subflow is in the unaccept queue, and the joined subflow is not in the
unaccept queue, which makes the joined subflow won't be released, and
therefore the corresponding unaccepted mptcp socket will not be released
to.

This can be reproduced easily with following steps:

1. create 2 namespace and veth:
   $ ip netns add mptcp-client
   $ ip netns add mptcp-server
   $ sysctl -w net.ipv4.conf.all.rp_filter=0
   $ ip netns exec mptcp-client sysctl -w net.mptcp.enabled=1
   $ ip netns exec mptcp-server sysctl -w net.mptcp.enabled=1
   $ ip link add red-client netns mptcp-client type veth peer red-server \
     netns mptcp-server
   $ ip -n mptcp-server address add 10.0.0.1/24 dev red-server
   $ ip -n mptcp-server address add 192.168.0.1/24 dev red-server
   $ ip -n mptcp-client address add 10.0.0.2/24 dev red-client
   $ ip -n mptcp-client address add 192.168.0.2/24 dev red-client
   $ ip -n mptcp-server link set red-server up
   $ ip -n mptcp-client link set red-client up

2. configure the endpoint and limit for client and server:
   $ ip -n mptcp-server mptcp endpoint flush
   $ ip -n mptcp-server mptcp limits set subflow 2 add_addr_accepted 2
   $ ip -n mptcp-client mptcp endpoint flush
   $ ip -n mptcp-client mptcp limits set subflow 2 add_addr_accepted 2
   $ ip -n mptcp-client mptcp endpoint add 192.168.0.2 dev red-client id \
     1 subflow

3. listen and accept on a port, such as 9999. The nc command we used
   here is modified, which makes it use mptcp protocol by default.
   $ ip netns exec mptcp-server nc -l -k -p 9999

4. open another *two* terminal and use each of them to connect to the
   server with the following command:
   $ ip netns exec mptcp-client nc 10.0.0.1 9999
   Input something after connect to trigger the connection of the second
   subflow. So that there are two established mptcp connections, with the
   second one still unaccepted.

5. exit all the nc command, and check the tcp socket in server namespace.
   And you will find that there is one tcp socket in CLOSE_WAIT state
   and can't release forever.

Fix this by closing all of the unaccepted mptcp socket in
mptcp_subflow_queue_clean() with __mptcp_close().

Now, we can ensure that all unaccepted mptcp sockets will be cleaned by
__mptcp_close() before they are released, so mptcp_sock_destruct(), which
is used to clean the unaccepted mptcp socket, is not needed anymore.

The selftests for mptcp is ran for this commit, and no new failures.

Fixes: f296234c98a8 ("mptcp: Add handling of incoming MP_JOIN requests")
Fixes: 6aeed9045071 ("mptcp: fix race on unaccepted mptcp sockets")
Cc: stable@vger.kernel.org
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Mengen Sun <mengensun@tencent.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  2 +-
 net/mptcp/protocol.h |  1 +
 net/mptcp/subflow.c  | 33 +++++++--------------------------
 3 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f7690414320a..f8897a70c11d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2662,7 +2662,7 @@ static void __mptcp_clear_xmit(struct sock *sk)
 		dfrag_clear(sk, dfrag);
 }
 
-static void mptcp_cancel_work(struct sock *sk)
+void mptcp_cancel_work(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 8f123d450c76..8f372b8f059c 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -613,6 +613,7 @@ void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 bool __mptcp_close(struct sock *sk, long timeout);
+void mptcp_cancel_work(struct sock *sk);
 
 bool mptcp_addresses_equal(const struct mptcp_addr_info *a,
 			   const struct mptcp_addr_info *b, bool use_port);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index c7d49fb6e7bd..07dd23d0fe04 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -602,30 +602,6 @@ static bool subflow_hmac_valid(const struct request_sock *req,
 	return !crypto_memneq(hmac, mp_opt->hmac, MPTCPOPT_HMAC_LEN);
 }
 
-static void mptcp_sock_destruct(struct sock *sk)
-{
-	/* if new mptcp socket isn't accepted, it is free'd
-	 * from the tcp listener sockets request queue, linked
-	 * from req->sk.  The tcp socket is released.
-	 * This calls the ULP release function which will
-	 * also remove the mptcp socket, via
-	 * sock_put(ctx->conn).
-	 *
-	 * Problem is that the mptcp socket will be in
-	 * ESTABLISHED state and will not have the SOCK_DEAD flag.
-	 * Both result in warnings from inet_sock_destruct.
-	 */
-	if ((1 << sk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
-		sk->sk_state = TCP_CLOSE;
-		WARN_ON_ONCE(sk->sk_socket);
-		sock_orphan(sk);
-	}
-
-	/* We don't need to clear msk->subflow, as it's still NULL at this point */
-	mptcp_destroy_common(mptcp_sk(sk), 0);
-	inet_sock_destruct(sk);
-}
-
 static void mptcp_force_close(struct sock *sk)
 {
 	/* the msk is not yet exposed to user-space */
@@ -768,7 +744,6 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
-			new_msk->sk_destruct = mptcp_sock_destruct;
 			mptcp_sk(new_msk)->setsockopt_seq = ctx->setsockopt_seq;
 			mptcp_pm_new_connection(mptcp_sk(new_msk), child, 1);
 			mptcp_token_accept(subflow_req, mptcp_sk(new_msk));
@@ -1763,13 +1738,19 @@ void mptcp_subflow_queue_clean(struct sock *listener_ssk)
 
 	for (msk = head; msk; msk = next) {
 		struct sock *sk = (struct sock *)msk;
-		bool slow;
+		bool slow, do_cancel_work;
 
+		sock_hold(sk);
 		slow = lock_sock_fast_nested(sk);
 		next = msk->dl_next;
 		msk->first = NULL;
 		msk->dl_next = NULL;
+
+		do_cancel_work = __mptcp_close(sk, 0);
 		unlock_sock_fast(sk, slow);
+		if (do_cancel_work)
+			mptcp_cancel_work(sk);
+		sock_put(sk);
 	}
 
 	/* we are still under the listener msk socket lock */
-- 
2.37.3


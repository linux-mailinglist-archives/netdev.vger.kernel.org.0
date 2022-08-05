Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA08B58A421
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 02:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbiHEAVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 20:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235780AbiHEAVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 20:21:37 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F8519C08
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 17:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659658895; x=1691194895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SYwNjrUGNlXKJ+DznD96iZmHPRQB1EKPhXt4WC93cEE=;
  b=js0m1CF6nSRcG76ku+L4PBUYV8pgIjM3q8rKIyyYMmU9rxIoLvGc8bT/
   X5N81ZWdJBW+OBCkVCz/45dvbLzH9l5ZRfuegy3K3l3wnQ/WIbc3GL+OU
   JBuTQCKAQ3VguVer8DK5iQYv8BcGW1+4LArIgLN9ZehgqH4WGP1OdfICJ
   ihzV4vqSyJV5yW7B/pgtLP53EvTddtL76dsQLpzUmIBemST0YyrfQsNXg
   Bdwnro+fPh10FzJLC1VjSVQnGZ4n3OJwFD+9hbM+/S4XCIqqf8MkeDp6v
   vcmPU521+gKPGbcHJSdaTFHO/MJNC/a0RkednYk/OPZT2p9tUiahelt9z
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="270467351"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="270467351"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="729810990"
Received: from ramankur-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.212.169.219])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 17:21:34 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        fw@strlen.de, dcaratti@redhat.com, mptcp@lists.linux.dev,
        Nguyen Dinh Phi <phind.uet@gmail.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 1/3] mptcp: move subflow cleanup in mptcp_destroy_common()
Date:   Thu,  4 Aug 2022 17:21:25 -0700
Message-Id: <20220805002127.88430-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
References: <20220805002127.88430-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If the mptcp socket creation fails due to a CGROUP_INET_SOCK_CREATE
eBPF program, the MPTCP protocol ends-up leaking all the subflows:
the related cleanup happens in __mptcp_destroy_sock() that is not
invoked in such code path.

Address the issue moving the subflow sockets cleanup in the
mptcp_destroy_common() helper, which is invoked in every msk cleanup
path.

Additionally get rid of the intermediate list_splice_init step, which
is an unneeded relic from the past.

The issue is present since before the reported root cause commit, but
any attempt to backport the fix before that hash will require a complete
rewrite.

Fixes: e16163b6e2 ("mptcp: refactor shutdown and close")
Reported-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Co-developed-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 39 +++++++++++++++------------------------
 net/mptcp/protocol.h |  2 +-
 net/mptcp/subflow.c  |  3 ++-
 3 files changed, 18 insertions(+), 26 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index a3f1c1461874..07fcc86e1fc9 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2769,30 +2769,16 @@ static void __mptcp_wr_shutdown(struct sock *sk)
 
 static void __mptcp_destroy_sock(struct sock *sk)
 {
-	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	LIST_HEAD(conn_list);
 
 	pr_debug("msk=%p", msk);
 
 	might_sleep();
 
-	/* join list will be eventually flushed (with rst) at sock lock release time*/
-	list_splice_init(&msk->conn_list, &conn_list);
-
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
 	msk->pm.status = 0;
 
-	/* clears msk->subflow, allowing the following loop to close
-	 * even the initial subflow
-	 */
-	mptcp_dispose_initial_subflow(msk);
-	list_for_each_entry_safe(subflow, tmp, &conn_list, node) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-		__mptcp_close_ssk(sk, ssk, subflow, 0);
-	}
-
 	sk->sk_prot->destroy(sk);
 
 	WARN_ON_ONCE(msk->rmem_fwd_alloc);
@@ -2884,24 +2870,20 @@ static void mptcp_copy_inaddrs(struct sock *msk, const struct sock *ssk)
 
 static int mptcp_disconnect(struct sock *sk, int flags)
 {
-	struct mptcp_subflow_context *subflow, *tmp;
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	inet_sk_state_store(sk, TCP_CLOSE);
 
-	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node) {
-		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
-
-		__mptcp_close_ssk(sk, ssk, subflow, MPTCP_CF_FASTCLOSE);
-	}
-
 	mptcp_stop_timer(sk);
 	sk_stop_timer(sk, &sk->sk_timer);
 
 	if (mptcp_sk(sk)->token)
 		mptcp_event(MPTCP_EVENT_CLOSED, mptcp_sk(sk), NULL, GFP_KERNEL);
 
-	mptcp_destroy_common(msk);
+	/* msk->subflow is still intact, the following will not free the first
+	 * subflow
+	 */
+	mptcp_destroy_common(msk, MPTCP_CF_FASTCLOSE);
 	msk->last_snd = NULL;
 	WRITE_ONCE(msk->flags, 0);
 	msk->cb_flags = 0;
@@ -3051,12 +3033,17 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 	return newsk;
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk)
+void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags)
 {
+	struct mptcp_subflow_context *subflow, *tmp;
 	struct sock *sk = (struct sock *)msk;
 
 	__mptcp_clear_xmit(sk);
 
+	/* join list will be eventually flushed (with rst) at sock lock release time */
+	list_for_each_entry_safe(subflow, tmp, &msk->conn_list, node)
+		__mptcp_close_ssk(sk, mptcp_subflow_tcp_sock(subflow), subflow, flags);
+
 	/* move to sk_receive_queue, sk_stream_kill_queues will purge it */
 	mptcp_data_lock(sk);
 	skb_queue_splice_tail_init(&msk->receive_queue, &sk->sk_receive_queue);
@@ -3078,7 +3065,11 @@ static void mptcp_destroy(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
-	mptcp_destroy_common(msk);
+	/* clears msk->subflow, allowing the following to close
+	 * even the initial subflow
+	 */
+	mptcp_dispose_initial_subflow(msk);
+	mptcp_destroy_common(msk, 0);
 	sk_sockets_allocated_dec(sk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 5d6043c16b09..40881a7df5d5 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -717,7 +717,7 @@ static inline void mptcp_write_space(struct sock *sk)
 	}
 }
 
-void mptcp_destroy_common(struct mptcp_sock *msk);
+void mptcp_destroy_common(struct mptcp_sock *msk, unsigned int flags);
 
 #define MPTCP_TOKEN_MAX_RETRIES	4
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 901c763dcdbb..c7d49fb6e7bd 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -621,7 +621,8 @@ static void mptcp_sock_destruct(struct sock *sk)
 		sock_orphan(sk);
 	}
 
-	mptcp_destroy_common(mptcp_sk(sk));
+	/* We don't need to clear msk->subflow, as it's still NULL at this point */
+	mptcp_destroy_common(mptcp_sk(sk), 0);
 	inet_sock_destruct(sk);
 }
 
-- 
2.37.1


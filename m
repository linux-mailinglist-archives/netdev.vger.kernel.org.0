Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FF055DF2A
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242819AbiF1BDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 21:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242998AbiF1BCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 21:02:53 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BAD22B3A
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 18:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656378173; x=1687914173;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cwCjWO7p4fYLgITbqWT1J/qDbZF+jfQ+eMSp5vmDTCk=;
  b=O4OvMPf9IjKb/cUDWSWAnVNr3ro/sC2L6L38vG8CEJ3scgH7vLIS/Guk
   OjF4rl76YGYgGPcD6FyGKDS1ffh55JEB7RFSW40Oor50y6pXjv4PH2+/g
   S/+CwLC5fWvVxEc0ZhcJfTZJ9tI+hi7Lk8ddXulaoKkoL9jxfROG/qNUz
   yD9+u8fWRsPnxZa1uIlWPsmIZUN1Pw77ZtrpqevO/4W59X17qZ0Yt2tzO
   shWt9jh2ZOJLzIHLtfutL64UWdvHlJwd/EkxMMO4otvvhMTqkbQjRyvzF
   sGjFdvjqyGaWayv+pI6ipqZGVoZPiPafw3pjnetaIoxy3xJdr4o3ZEii9
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10391"; a="264642454"
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="264642454"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:51 -0700
X-IronPort-AV: E=Sophos;i="5.92,227,1650956400"; 
   d="scan'208";a="692867396"
Received: from cgarner-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.0.217])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 18:02:51 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, fw@strlen.de,
        geliang.tang@suse.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 6/9] mptcp: fix race on unaccepted mptcp sockets
Date:   Mon, 27 Jun 2022 18:02:40 -0700
Message-Id: <20220628010243.166605-7-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
References: <20220628010243.166605-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When the listener socket owning the relevant request is closed,
it frees the unaccepted subflows and that causes later deletion
of the paired MPTCP sockets.

The mptcp socket's worker can run in the time interval between such delete
operations. When that happens, any access to msk->first will cause an UaF
access, as the subflow cleanup did not cleared such field in the mptcp
socket.

Address the issue explicitly traversing the listener socket accept
queue at close time and performing the needed cleanup on the pending
msk.

Note that the locking is a bit tricky, as we need to acquire the msk
socket lock, while still owning the subflow socket one.

Fixes: 86e39e04482b ("mptcp: keep track of local endpoint still available for each msk")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c |  5 +++++
 net/mptcp/protocol.h |  2 ++
 net/mptcp/subflow.c  | 52 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 59 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index e63bc2bb7fff..e475212f2618 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -2331,6 +2331,11 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		kfree_rcu(subflow, rcu);
 	} else {
 		/* otherwise tcp will dispose of the ssk and subflow ctx */
+		if (ssk->sk_state == TCP_LISTEN) {
+			tcp_set_state(ssk, TCP_CLOSE);
+			mptcp_subflow_queue_clean(ssk);
+			inet_csk_listen_stop(ssk);
+		}
 		__tcp_close(ssk, 0);
 
 		/* close acquired an extra ref */
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 9860179bfd5e..c14d70c036d0 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -306,6 +306,7 @@ struct mptcp_sock {
 
 	u32 setsockopt_seq;
 	char		ca_name[TCP_CA_NAME_MAX];
+	struct mptcp_sock	*dl_next;
 };
 
 #define mptcp_data_lock(sk) spin_lock_bh(&(sk)->sk_lock.slock)
@@ -608,6 +609,7 @@ void mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 		     struct mptcp_subflow_context *subflow);
 void mptcp_subflow_send_ack(struct sock *ssk);
 void mptcp_subflow_reset(struct sock *ssk);
+void mptcp_subflow_queue_clean(struct sock *ssk);
 void mptcp_sock_graft(struct sock *sk, struct socket *parent);
 struct socket *__mptcp_nmpc_socket(const struct mptcp_sock *msk);
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 03862103665d..63e8892ec807 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1723,6 +1723,58 @@ static void subflow_state_change(struct sock *sk)
 	}
 }
 
+void mptcp_subflow_queue_clean(struct sock *listener_ssk)
+{
+	struct request_sock_queue *queue = &inet_csk(listener_ssk)->icsk_accept_queue;
+	struct mptcp_sock *msk, *next, *head = NULL;
+	struct request_sock *req;
+
+	/* build a list of all unaccepted mptcp sockets */
+	spin_lock_bh(&queue->rskq_lock);
+	for (req = queue->rskq_accept_head; req; req = req->dl_next) {
+		struct mptcp_subflow_context *subflow;
+		struct sock *ssk = req->sk;
+		struct mptcp_sock *msk;
+
+		if (!sk_is_mptcp(ssk))
+			continue;
+
+		subflow = mptcp_subflow_ctx(ssk);
+		if (!subflow || !subflow->conn)
+			continue;
+
+		/* skip if already in list */
+		msk = mptcp_sk(subflow->conn);
+		if (msk->dl_next || msk == head)
+			continue;
+
+		msk->dl_next = head;
+		head = msk;
+	}
+	spin_unlock_bh(&queue->rskq_lock);
+	if (!head)
+		return;
+
+	/* can't acquire the msk socket lock under the subflow one,
+	 * or will cause ABBA deadlock
+	 */
+	release_sock(listener_ssk);
+
+	for (msk = head; msk; msk = next) {
+		struct sock *sk = (struct sock *)msk;
+		bool slow;
+
+		slow = lock_sock_fast_nested(sk);
+		next = msk->dl_next;
+		msk->first = NULL;
+		msk->dl_next = NULL;
+		unlock_sock_fast(sk, slow);
+	}
+
+	/* we are still under the listener msk socket lock */
+	lock_sock_nested(listener_ssk, SINGLE_DEPTH_NESTING);
+}
+
 static int subflow_ulp_init(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
-- 
2.37.0


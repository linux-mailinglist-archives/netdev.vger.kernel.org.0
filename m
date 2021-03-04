Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4B0332DBE0
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239582AbhCDVgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:36:07 -0500
Received: from mga03.intel.com ([134.134.136.65]:46928 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239568AbhCDVf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 16:35:57 -0500
IronPort-SDR: 0UclJXELv4TzmzNVNLKt9AleuJnxcbH7yqiNcJKKmmatR4HUo87mzB9wPoQho2YRYeeg2Oo1PG
 QpFQrDsXefVQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9913"; a="187566595"
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="187566595"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:25 -0800
IronPort-SDR: wK6RJdfQcvTQUoNjhkz0IN/sSTy33X/ODbxA6rvQw/o2EWvNiv9LVuq/AkuoZru8jNT3b/tqON
 dCH1r296UmEA==
X-IronPort-AV: E=Sophos;i="5.81,223,1610438400"; 
   d="scan'208";a="368329489"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.254.105.71])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 13:32:24 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net, mptcp@lists.01.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net 7/9] mptcp: fix race in release_cb
Date:   Thu,  4 Mar 2021 13:32:14 -0800
Message-Id: <20210304213216.205472-8-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
References: <20210304213216.205472-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

If we receive a MPTCP_PUSH_PENDING even from a subflow when
mptcp_release_cb() is serving the previous one, the latter
will be delayed up to the next release_sock(msk).

Address the issue implementing a test/serve loop for such
event.

Additionally rename the push helper to __mptcp_push_pending()
to be more consistent with the existing code.

Fixes: 6e628cd3a8f7 ("mptcp: use mptcp release_cb for delayed tasks")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 67aaf7154dca..d2a2169e6d9e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1445,7 +1445,7 @@ static void mptcp_push_release(struct sock *sk, struct sock *ssk,
 	release_sock(ssk);
 }
 
-static void mptcp_push_pending(struct sock *sk, unsigned int flags)
+static void __mptcp_push_pending(struct sock *sk, unsigned int flags)
 {
 	struct sock *prev_ssk = NULL, *ssk = NULL;
 	struct mptcp_sock *msk = mptcp_sk(sk);
@@ -1697,14 +1697,14 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 wait_for_memory:
 		mptcp_set_nospace(sk);
-		mptcp_push_pending(sk, msg->msg_flags);
+		__mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
 			goto out;
 	}
 
 	if (copied)
-		mptcp_push_pending(sk, msg->msg_flags);
+		__mptcp_push_pending(sk, msg->msg_flags);
 
 out:
 	release_sock(sk);
@@ -2959,13 +2959,14 @@ static void mptcp_release_cb(struct sock *sk)
 {
 	unsigned long flags, nflags;
 
-	/* push_pending may touch wmem_reserved, do it before the later
-	 * cleanup
-	 */
-	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
-		__mptcp_clean_una(sk);
-	if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags)) {
-		/* mptcp_push_pending() acquires the subflow socket lock
+	for (;;) {
+		flags = 0;
+		if (test_and_clear_bit(MPTCP_PUSH_PENDING, &mptcp_sk(sk)->flags))
+			flags |= MPTCP_PUSH_PENDING;
+		if (!flags)
+			break;
+
+		/* the following actions acquire the subflow socket lock
 		 *
 		 * 1) can't be invoked in atomic scope
 		 * 2) must avoid ABBA deadlock with msk socket spinlock: the RX
@@ -2974,13 +2975,21 @@ static void mptcp_release_cb(struct sock *sk)
 		 */
 
 		spin_unlock_bh(&sk->sk_lock.slock);
-		mptcp_push_pending(sk, 0);
+		if (flags & MPTCP_PUSH_PENDING)
+			__mptcp_push_pending(sk, 0);
+
+		cond_resched();
 		spin_lock_bh(&sk->sk_lock.slock);
 	}
+
+	if (test_and_clear_bit(MPTCP_CLEAN_UNA, &mptcp_sk(sk)->flags))
+		__mptcp_clean_una(sk);
 	if (test_and_clear_bit(MPTCP_ERROR_REPORT, &mptcp_sk(sk)->flags))
 		__mptcp_error_report(sk);
 
-	/* clear any wmem reservation and errors */
+	/* push_pending may touch wmem_reserved, ensure we do the cleanup
+	 * later
+	 */
 	__mptcp_update_wmem(sk);
 	__mptcp_update_rmem(sk);
 
-- 
2.30.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 214735F0F74
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbiI3QBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231879AbiI3QAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:00:37 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176DD925A1
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664553631; x=1696089631;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VByxH30YMrFFT03SK19iwWzFpOXOu0TywF/XLaKQObI=;
  b=IL6mpJo9eLdSbs6cnVaFcLId/ktIPQKUEUXudna5IhWf9pkUlX7M0AtR
   7MgBwP4KhENiNYum97UgkDZS5oxwRmQuKWWmGUHo1D01+hRRsWQnV+D6I
   5MhdudZgCWbO2ug+soCiuCsws5I3MuTUXBoSSdJEE7RhffhAeZG2ktj9m
   QOPmdEkVX9FV4bzzoYxRLJAAUI7zxKoxZQrG3Ybp1v5EY70k0zMN6wfxa
   AcL2bcCA5HMTgJlrUi9rlP0Feu/BxI4h5NwUIFfzJcGEY/VMMBCwdKjvX
   XfUtpRcIIpa6izi4uOzQoRWjSqc1k6MPTZhyxJ+fQ90RmSnUGGcrjECO5
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="303132489"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="303132489"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:28 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10486"; a="655996108"
X-IronPort-AV: E=Sophos;i="5.93,358,1654585200"; 
   d="scan'208";a="655996108"
Received: from cmforest-mobl1.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.251.22.5])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Sep 2022 09:00:27 -0700
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 1/4] mptcp: propagate fastclose error
Date:   Fri, 30 Sep 2022 08:59:31 -0700
Message-Id: <20220930155934.404466-2-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
References: <20220930155934.404466-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

When an mptcp socket is closed due to an incoming FASTCLOSE
option, so specific sk_err is set and later syscall will
fail usually with EPIPE.

Align the current fastclose error handling with TCP reset,
properly setting the socket error according to the current
msk state and propagating such error.

Additionally sendmsg() is currently not handling properly
the sk_err, always returning EPIPE.

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 47 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 760404b15cd0..cad0346c9281 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1707,7 +1707,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 			goto out;
 		} else if (ret) {
 			release_sock(ssk);
-			goto out;
+			goto do_error;
 		}
 		release_sock(ssk);
 	}
@@ -1717,9 +1717,13 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	if ((1 << sk->sk_state) & ~(TCPF_ESTABLISHED | TCPF_CLOSE_WAIT)) {
 		ret = sk_stream_wait_connect(sk, &timeo);
 		if (ret)
-			goto out;
+			goto do_error;
 	}
 
+	ret = -EPIPE;
+	if (unlikely(sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN)))
+		goto do_error;
+
 	pfrag = sk_page_frag(sk);
 
 	while (msg_data_left(msg)) {
@@ -1728,11 +1732,6 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		bool dfrag_collapsed;
 		size_t psize, offset;
 
-		if (sk->sk_err || (sk->sk_shutdown & SEND_SHUTDOWN)) {
-			ret = -EPIPE;
-			goto out;
-		}
-
 		/* reuse tail pfrag, if possible, or carve a new one from the
 		 * page allocator
 		 */
@@ -1764,7 +1763,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		if (copy_page_from_iter(dfrag->page, offset, psize,
 					&msg->msg_iter) != psize) {
 			ret = -EFAULT;
-			goto out;
+			goto do_error;
 		}
 
 		/* data successfully copied into the write queue */
@@ -1796,7 +1795,7 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 		__mptcp_push_pending(sk, msg->msg_flags);
 		ret = sk_stream_wait_memory(sk, &timeo);
 		if (ret)
-			goto out;
+			goto do_error;
 	}
 
 	if (copied)
@@ -1804,7 +1803,14 @@ static int mptcp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 
 out:
 	release_sock(sk);
-	return copied ? : ret;
+	return copied;
+
+do_error:
+	if (copied)
+		goto out;
+
+	copied = sk_stream_error(sk, msg->msg_flags, ret);
+	goto out;
 }
 
 static int __mptcp_recvmsg_mskq(struct mptcp_sock *msk,
@@ -2441,12 +2447,31 @@ static void mptcp_check_fastclose(struct mptcp_sock *msk)
 		unlock_sock_fast(tcp_sk, slow);
 	}
 
+	/* Mirror the tcp_reset() error propagation */
+	switch (sk->sk_state) {
+	case TCP_SYN_SENT:
+		sk->sk_err = ECONNREFUSED;
+		break;
+	case TCP_CLOSE_WAIT:
+		sk->sk_err = EPIPE;
+		break;
+	case TCP_CLOSE:
+		return;
+	default:
+		sk->sk_err = ECONNRESET;
+	}
+
 	inet_sk_state_store(sk, TCP_CLOSE);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 	smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
 	set_bit(MPTCP_WORK_CLOSE_SUBFLOW, &msk->flags);
 
-	mptcp_close_wake_up(sk);
+	/* the calling mptcp_worker will properly destroy the socket */
+	if (sock_flag(sk, SOCK_DEAD))
+		return;
+
+	sk->sk_state_change(sk);
+	sk_error_report(sk);
 }
 
 static void __mptcp_retrans(struct sock *sk)
-- 
2.37.3


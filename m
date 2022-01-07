Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177EA486EA7
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 01:20:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbiAGAUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 19:20:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:47984 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343961AbiAGAUn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 19:20:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641514843; x=1673050843;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nEUaOYMjQqfID6wwgBBxgtsFSt7zKq2ozbBAjHuOQhk=;
  b=SiKZhfovY/ef7BRDEl1mNKiD82NY2owsXw8S9SuKoGq8aO0whMFFfNNj
   bJGaBBFxOdWPGecQkuTC0ppv6JEah/AqW28BEIvNdAWNcf8+fRYEqollj
   hWrymuHbGxvqCPzX+9UEvs9SZenzTrD1+QPhwxjWAumjaMwnqK3D9IQKT
   kePWPDtmFWxjI9cxzDCw2wRH7xeFzce+3Bondt9gfXI3nCJEppkJn1k3V
   JvfD7ACISu2/OdDf5m2B8ISP41j+Mo/OfmNWA+1Z+KUz5k6EvY2cQlgAX
   L7XL4Gs1soJHrLHmZGDd6M3aXvKRgE9TYPMKtPYAgrYed6wxCqd9l8yc2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="242721305"
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="242721305"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:35 -0800
X-IronPort-AV: E=Sophos;i="5.88,268,1635231600"; 
   d="scan'208";a="618508498"
Received: from mjmartin-desk2.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.94.200])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2022 16:20:34 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        kuba@kernel.org, matthieu.baerts@tessares.net,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH net-next 04/13] mptcp: cleanup accept and poll
Date:   Thu,  6 Jan 2022 16:20:17 -0800
Message-Id: <20220107002026.375427-5-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
References: <20220107002026.375427-1-mathew.j.martineau@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

After the previous patch,  msk->subflow will never be deleted during
the whole msk lifetime. We don't need anymore to acquire references to
it in mptcp_stream_accept() and we can use the listener subflow accept
queue to simplify mptcp_poll() for listener socket.

Overall this removes a lock pair and 4 more atomic operations per
accept().

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 net/mptcp/protocol.c | 25 +++++++------------------
 net/mptcp/protocol.h |  1 -
 net/mptcp/subflow.c  |  1 -
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 83f6d6c3e3eb..628cd60c9d0f 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3493,17 +3493,9 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 
 	pr_debug("msk=%p", msk);
 
-	lock_sock(sock->sk);
-	if (sock->sk->sk_state != TCP_LISTEN)
-		goto unlock_fail;
-
 	ssock = __mptcp_nmpc_socket(msk);
 	if (!ssock)
-		goto unlock_fail;
-
-	clear_bit(MPTCP_DATA_READY, &msk->flags);
-	sock_hold(ssock->sk);
-	release_sock(sock->sk);
+		return -EINVAL;
 
 	err = ssock->ops->accept(sock, newsock, flags, kern);
 	if (err == 0 && !mptcp_is_tcpsk(newsock->sk)) {
@@ -3543,14 +3535,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		release_sock(newsk);
 	}
 
-	if (inet_csk_listen_poll(ssock->sk))
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-	sock_put(ssock->sk);
 	return err;
-
-unlock_fail:
-	release_sock(sock->sk);
-	return -EINVAL;
 }
 
 static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
@@ -3596,8 +3581,12 @@ static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 
 	state = inet_sk_state_load(sk);
 	pr_debug("msk=%p state=%d flags=%lx", msk, state, msk->flags);
-	if (state == TCP_LISTEN)
-		return test_bit(MPTCP_DATA_READY, &msk->flags) ? EPOLLIN | EPOLLRDNORM : 0;
+	if (state == TCP_LISTEN) {
+		if (WARN_ON_ONCE(!msk->subflow || !msk->subflow->sk))
+			return 0;
+
+		return inet_csk_listen_poll(msk->subflow->sk);
+	}
 
 	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
 		mask |= mptcp_check_readable(msk);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 1a4ca5a202c8..386d1a98ff1d 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -111,7 +111,6 @@
 #define MPTCP_RST_TRANSIENT	BIT(0)
 
 /* MPTCP socket flags */
-#define MPTCP_DATA_READY	0
 #define MPTCP_NOSPACE		1
 #define MPTCP_WORK_RTX		2
 #define MPTCP_WORK_EOF		3
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 24bc9d5e87be..d861307f7efe 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1293,7 +1293,6 @@ static void subflow_data_ready(struct sock *sk)
 		if (reqsk_queue_empty(&inet_csk(sk)->icsk_accept_queue))
 			return;
 
-		set_bit(MPTCP_DATA_READY, &msk->flags);
 		parent->sk_data_ready(parent);
 		return;
 	}
-- 
2.34.1


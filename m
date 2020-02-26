Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F63B16FA65
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 10:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBZJPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 04:15:12 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60762 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726082AbgBZJPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 04:15:11 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j6smb-0001Mc-Er; Wed, 26 Feb 2020 10:15:09 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 2/7] mptcp: add work queue skeleton
Date:   Wed, 26 Feb 2020 10:14:47 +0100
Message-Id: <20200226091452.1116-3-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226091452.1116-1-fw@strlen.de>
References: <20200226091452.1116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

Will be extended with functionality in followup patches.
Initial user is moving skbs from subflows receive queue to
the mptcp-level receive queue.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/mptcp/protocol.c | 22 ++++++++++++++++++++++
 net/mptcp/protocol.h |  1 +
 2 files changed, 23 insertions(+)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 1d55563e9aca..cbf184a71ed7 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -551,12 +551,24 @@ static void __mptcp_close_ssk(struct sock *sk, struct sock *ssk,
 	}
 }
 
+static void mptcp_worker(struct work_struct *work)
+{
+	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
+	struct sock *sk = &msk->sk.icsk_inet.sk;
+
+	lock_sock(sk);
+
+	release_sock(sk);
+	sock_put(sk);
+}
+
 static int __mptcp_init_sock(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
 	INIT_LIST_HEAD(&msk->conn_list);
 	__set_bit(MPTCP_SEND_SPACE, &msk->flags);
+	INIT_WORK(&msk->work, mptcp_worker);
 
 	msk->first = NULL;
 
@@ -571,6 +583,14 @@ static int mptcp_init_sock(struct sock *sk)
 	return __mptcp_init_sock(sk);
 }
 
+static void mptcp_cancel_work(struct sock *sk)
+{
+	struct mptcp_sock *msk = mptcp_sk(sk);
+
+	if (cancel_work_sync(&msk->work))
+		sock_put(sk);
+}
+
 static void mptcp_subflow_shutdown(struct sock *ssk, int how)
 {
 	lock_sock(ssk);
@@ -616,6 +636,8 @@ static void mptcp_close(struct sock *sk, long timeout)
 		__mptcp_close_ssk(sk, ssk, subflow, timeout);
 	}
 
+	mptcp_cancel_work(sk);
+
 	sk_common_release(sk);
 }
 
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 67895a7c1e5b..6e6e162d25f1 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -70,6 +70,7 @@ struct mptcp_sock {
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
+	struct work_struct work;
 	struct list_head conn_list;
 	struct skb_ext	*cached_ext;	/* for the next sendmsg */
 	struct socket	*subflow; /* outgoing connect/listener/!mp_capable */
-- 
2.24.1


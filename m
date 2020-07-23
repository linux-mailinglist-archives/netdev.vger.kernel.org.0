Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 587D222AD2C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 13:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbgGWLDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 07:03:12 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:46624 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728408AbgGWLDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 07:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595502189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+C0jv0E+odNM2s2g9uCQ13ZuwlchFE0/6Bv2Yitpft8=;
        b=KTFyDYGdvi5avSFSYPN7+qh4JpFMmP/Il3R35HpUhicqwsJWBqNvByTSewa5qvZiDo8Hwx
        KTeXxZmiWFU7BIghXb3QqE2H1Cx+Fwgv/FkFSI0+GjtlTklUpDO/BtXd0CqAVS/VvUw4Dq
        UewYBuD5BGuWAf7mhcdMEFVc2jre0kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-154-YbJXVhevMReD0xly1337dg-1; Thu, 23 Jul 2020 07:03:05 -0400
X-MC-Unique: YbJXVhevMReD0xly1337dg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 76E37106B244;
        Thu, 23 Jul 2020 11:03:04 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-113-9.ams2.redhat.com [10.36.113.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7855D8BED5;
        Thu, 23 Jul 2020 11:03:03 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>, mptcp@lists.01.org
Subject: [PATCH net-next 4/8] mptcp: explicitly track the fully established status
Date:   Thu, 23 Jul 2020 13:02:32 +0200
Message-Id: <598ccdd666232ad24b069e99d6095af83484ce68.1595431326.git.pabeni@redhat.com>
In-Reply-To: <cover.1595431326.git.pabeni@redhat.com>
References: <cover.1595431326.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently accepted msk sockets become established only after
accept() returns the new sk to user-space.

As MP_JOIN request are refused as per RFC spec on non fully
established socket, the above causes mp_join self-tests
instabilities.

This change lets the msk entering the established status
as soon as it receives the 3rd ack and propagates the first
subflow fully established status on the msk socket.

Finally we can change the subflow acceptance condition to
take in account both the sock state and the msk fully
established flag.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Tested-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/options.c  |  5 ++---
 net/mptcp/protocol.c |  4 ++--
 net/mptcp/protocol.h |  8 ++++++++
 net/mptcp/subflow.c  | 23 +++++++++++++++++++----
 4 files changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/mptcp/options.c b/net/mptcp/options.c
index 19707c07efc1..3bc56eb608d8 100644
--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -709,6 +709,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 		 * additional ack.
 		 */
 		subflow->fully_established = 1;
+		WRITE_ONCE(msk->fully_established, true);
 		goto fully_established;
 	}
 
@@ -724,9 +725,7 @@ static bool check_fully_established(struct mptcp_sock *msk, struct sock *sk,
 
 	if (unlikely(!READ_ONCE(msk->pm.server_side)))
 		pr_warn_once("bogus mpc option on established client sk");
-	subflow->fully_established = 1;
-	subflow->remote_key = mp_opt->sndr_key;
-	subflow->can_ack = 1;
+	mptcp_subflow_fully_established(subflow, mp_opt);
 
 fully_established:
 	if (likely(subflow->pm_notified))
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 2936413171be..979dfcd2aa14 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1522,6 +1522,7 @@ struct sock *mptcp_sk_clone(const struct sock *sk,
 	msk->local_key = subflow_req->local_key;
 	msk->token = subflow_req->token;
 	msk->subflow = NULL;
+	WRITE_ONCE(msk->fully_established, false);
 
 	msk->write_seq = subflow_req->idsn + 1;
 	atomic64_set(&msk->snd_una, msk->write_seq);
@@ -1605,7 +1606,6 @@ static struct sock *mptcp_accept(struct sock *sk, int flags, int *err,
 		newsk = new_mptcp_sock;
 		mptcp_copy_inaddrs(newsk, ssk);
 		list_add(&subflow->node, &msk->conn_list);
-		inet_sk_state_store(newsk, TCP_ESTABLISHED);
 
 		mptcp_rcv_space_init(msk, ssk);
 		bh_unlock_sock(new_mptcp_sock);
@@ -1855,7 +1855,7 @@ bool mptcp_finish_join(struct sock *sk)
 	pr_debug("msk=%p, subflow=%p", msk, subflow);
 
 	/* mptcp socket already closing? */
-	if (inet_sk_state_load(parent) != TCP_ESTABLISHED)
+	if (!mptcp_is_fully_established(parent))
 		return false;
 
 	if (!msk->pm.server_side)
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index 6e114c09e5b4..67634b595466 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -198,6 +198,7 @@ struct mptcp_sock {
 	u32		token;
 	unsigned long	flags;
 	bool		can_ack;
+	bool		fully_established;
 	spinlock_t	join_list_lock;
 	struct work_struct work;
 	struct list_head conn_list;
@@ -342,6 +343,8 @@ mptcp_subflow_get_mapped_dsn(const struct mptcp_subflow_context *subflow)
 }
 
 int mptcp_is_enabled(struct net *net);
+void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
+				     struct mptcp_options_received *mp_opt);
 bool mptcp_subflow_data_available(struct sock *sk);
 void __init mptcp_subflow_init(void);
 
@@ -373,6 +376,11 @@ void mptcp_get_options(const struct sk_buff *skb,
 		       struct mptcp_options_received *mp_opt);
 
 void mptcp_finish_connect(struct sock *sk);
+static inline bool mptcp_is_fully_established(struct sock *sk)
+{
+	return inet_sk_state_load(sk) == TCP_ESTABLISHED &&
+	       READ_ONCE(mptcp_sk(sk)->fully_established);
+}
 void mptcp_rcv_space_init(struct mptcp_sock *msk, const struct sock *ssk);
 void mptcp_data_ready(struct sock *sk, struct sock *ssk);
 bool mptcp_finish_join(struct sock *sk);
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 84e70806b250..ea81842fc3b2 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -387,6 +387,17 @@ static void subflow_drop_ctx(struct sock *ssk)
 	kfree_rcu(ctx, rcu);
 }
 
+void mptcp_subflow_fully_established(struct mptcp_subflow_context *subflow,
+				     struct mptcp_options_received *mp_opt)
+{
+	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
+
+	subflow->remote_key = mp_opt->sndr_key;
+	subflow->fully_established = 1;
+	subflow->can_ack = 1;
+	WRITE_ONCE(msk->fully_established, true);
+}
+
 static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 					  struct sk_buff *skb,
 					  struct request_sock *req,
@@ -466,6 +477,11 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 		}
 
 		if (ctx->mp_capable) {
+			/* this can't race with mptcp_close(), as the msk is
+			 * not yet exposted to user-space
+			 */
+			inet_sk_state_store((void *)new_msk, TCP_ESTABLISHED);
+
 			/* new mpc subflow takes ownership of the newly
 			 * created mptcp socket
 			 */
@@ -478,9 +494,8 @@ static struct sock *subflow_syn_recv_sock(const struct sock *sk,
 			/* with OoO packets we can reach here without ingress
 			 * mpc option
 			 */
-			ctx->remote_key = mp_opt.sndr_key;
-			ctx->fully_established = mp_opt.mp_capable;
-			ctx->can_ack = mp_opt.mp_capable;
+			if (mp_opt.mp_capable)
+				mptcp_subflow_fully_established(ctx, &mp_opt);
 		} else if (ctx->mp_join) {
 			struct mptcp_sock *owner;
 
@@ -967,7 +982,7 @@ int __mptcp_subflow_connect(struct sock *sk, int ifindex,
 	int addrlen;
 	int err;
 
-	if (sk->sk_state != TCP_ESTABLISHED)
+	if (!mptcp_is_fully_established(sk))
 		return -ENOTCONN;
 
 	err = mptcp_subflow_create_socket(sk, &sf);
-- 
2.26.2


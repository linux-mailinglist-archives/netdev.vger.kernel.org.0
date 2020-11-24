Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 838C62C2400
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 12:21:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732349AbgKXLU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 06:20:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57073 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726315AbgKXLU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 06:20:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606216825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=x+i8eisHsUvc+uidVsrRrMFlr9xLsFFNzUmU45Do/CU=;
        b=SJVaMiWo6+TrV9/nKpMy4P3TFSmlNECB2hjApldERWDLmXlCbacP3tU7m1AfZwshQascrL
        9WjgOqWhiXqf12XFtynWYtXzQbszq6p2GYwGHnH2YEDqPAvxeGHOckq9UFal/5RKLZVgbt
        Od+4ohd0n/6KinKsIsJPKUiekQ0u1Tc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-SA2Fat6fPyKX4yGpay2UJQ-1; Tue, 24 Nov 2020 06:20:21 -0500
X-MC-Unique: SA2Fat6fPyKX4yGpay2UJQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 029611009B64;
        Tue, 24 Nov 2020 11:20:20 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-90.ams2.redhat.com [10.36.113.90])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF51D60864;
        Tue, 24 Nov 2020 11:20:18 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] mptcp: be careful on MPTCP-level ack.
Date:   Tue, 24 Nov 2020 12:20:11 +0100
Message-Id: <722e1a13493897c7cc194035e9b394e0dbeeb1af.1606213920.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can enter the main mptcp_recvmsg() loop even when
no subflows are connected. As note by Eric, that would
result in a divide by zero oops on ack generation.

Address the issue by checking the subflow status before
sending the ack.

Additionally protect mptcp_recvmsg() against invocation
with weird socket states.

Reported-and-suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Fixes: ea4ca586b16f ("mptcp: refine MPTCP-level ack scheduling")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 67 ++++++++++++++++++++++++++++++++------------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 4b7794835fea..b50164efb741 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -419,31 +419,57 @@ static bool mptcp_subflow_active(struct mptcp_subflow_context *subflow)
 	return ((1 << ssk->sk_state) & (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT));
 }
 
-static void mptcp_send_ack(struct mptcp_sock *msk, bool force)
+static inline bool tcp_can_send_ack(const struct sock *ssk)
+{
+	return !((1 << inet_sk_state_load(ssk)) &
+	       (TCPF_SYN_SENT | TCPF_SYN_RECV | TCPF_TIME_WAIT | TCPF_CLOSE));
+}
+
+static void mptcp_send_ack(struct mptcp_sock *msk)
 {
 	struct mptcp_subflow_context *subflow;
-	struct sock *pick = NULL;
 
 	mptcp_for_each_subflow(msk, subflow) {
 		struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 
-		if (force) {
-			lock_sock(ssk);
+		lock_sock(ssk);
+		if (tcp_can_send_ack(ssk))
 			tcp_send_ack(ssk);
-			release_sock(ssk);
-			continue;
-		}
-
-		/* if the hintes ssk is still active, use it */
-		pick = ssk;
-		if (ssk == msk->ack_hint)
-			break;
+		release_sock(ssk);
 	}
-	if (!force && pick) {
-		lock_sock(pick);
-		tcp_cleanup_rbuf(pick, 1);
-		release_sock(pick);
+}
+
+static bool mptcp_subflow_cleanup_rbuf(struct sock *ssk)
+{
+	int ret;
+
+	lock_sock(ssk);
+	ret = tcp_can_send_ack(ssk);
+	if (ret)
+		tcp_cleanup_rbuf(ssk, 1);
+	release_sock(ssk);
+	return ret;
+}
+
+static void mptcp_cleanup_rbuf(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+
+	/* if the hinted ssk is still active, try to use it */
+	if (likely(msk->ack_hint)) {
+		mptcp_for_each_subflow(msk, subflow) {
+			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+
+			if (msk->ack_hint == ssk &&
+			    mptcp_subflow_cleanup_rbuf(ssk))
+				return;
+		}
 	}
+
+	/* otherwise pick the first active subflow */
+	mptcp_for_each_subflow(msk, subflow)
+		if (mptcp_subflow_cleanup_rbuf(mptcp_subflow_tcp_sock(subflow)))
+			return;
 }
 
 static bool mptcp_check_data_fin(struct sock *sk)
@@ -494,7 +520,7 @@ static bool mptcp_check_data_fin(struct sock *sk)
 
 		ret = true;
 		mptcp_set_timeout(sk, NULL);
-		mptcp_send_ack(msk, true);
+		mptcp_send_ack(msk);
 		mptcp_close_wake_up(sk);
 	}
 	return ret;
@@ -1579,6 +1605,11 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return -EOPNOTSUPP;
 
 	lock_sock(sk);
+	if (unlikely(sk->sk_state == TCP_LISTEN)) {
+		copied = -ENOTCONN;
+		goto out_err;
+	}
+
 	timeo = sock_rcvtimeo(sk, nonblock);
 
 	len = min_t(size_t, len, INT_MAX);
@@ -1604,7 +1635,7 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		/* be sure to advertise window change */
 		old_space = READ_ONCE(msk->old_wspace);
 		if ((tcp_space(sk) - old_space) >= old_space)
-			mptcp_send_ack(msk, false);
+			mptcp_cleanup_rbuf(msk);
 
 		/* only the master socket status is relevant here. The exit
 		 * conditions mirror closely tcp_recvmsg()
-- 
2.26.2


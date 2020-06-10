Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FAC01F5088
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 10:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726919AbgFJIsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 04:48:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41231 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726753AbgFJIsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 04:48:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591778885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vkcejUSN9pvEJkJVGV5DUomFfP5ZIULSOtOTHN43lNM=;
        b=ApZ4/ShiuyUlxHxXoVQm8i4jgMwfYP3AWBrCdZYQZGQu8BsqW5ZDWeOrsb8RAL7smQUXQZ
        l4B0gskXoctrNkuvsts3FupcKqQbkt6VEBGMkYZAQ2gLK+N3R70BxgmD5a9av4jS/GXDxB
        ITV61UdNEliPmrANikwBQ5CuBrPn30Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-6zlssVomN1ywRWxl_xaJPw-1; Wed, 10 Jun 2020 04:48:03 -0400
X-MC-Unique: 6zlssVomN1ywRWxl_xaJPw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78FF78014D4;
        Wed, 10 Jun 2020 08:48:02 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-163.ams2.redhat.com [10.36.114.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 11B137B5F4;
        Wed, 10 Jun 2020 08:48:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Subject: [PATCH net] mptcp: fix races between shutdown and recvmsg
Date:   Wed, 10 Jun 2020 10:47:41 +0200
Message-Id: <766c50ce4e7e0415adaf0c63e3f92e75abb8470c.1591778786.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The msk sk_shutdown flag is set by a workqueue, possibly
introducing some delay in user-space notification. If the last
subflow carries some data with the fin packet, the user space
can wake-up before RCV_SHUTDOWN is set. If it executes unblocking
recvmsg(), it may return with an error instead of eof.

Address the issue explicitly checking for eof in recvmsg(), when
no data is found.

Fixes: 59832e246515 ("mptcp: subflow: check parent mptcp socket on subflow state change")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 45 +++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 14b253d10ccf..3980fbb6f31e 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -374,6 +374,27 @@ void mptcp_subflow_eof(struct sock *sk)
 		sock_hold(sk);
 }
 
+static void mptcp_check_for_eof(struct mptcp_sock *msk)
+{
+	struct mptcp_subflow_context *subflow;
+	struct sock *sk = (struct sock *)msk;
+	int receivers = 0;
+
+	mptcp_for_each_subflow(msk, subflow)
+		receivers += !subflow->rx_eof;
+
+	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
+		/* hopefully temporary hack: propagate shutdown status
+		 * to msk, when all subflows agree on it
+		 */
+		sk->sk_shutdown |= RCV_SHUTDOWN;
+
+		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
+		set_bit(MPTCP_DATA_READY, &msk->flags);
+		sk->sk_data_ready(sk);
+	}
+}
+
 static void mptcp_stop_timer(struct sock *sk)
 {
 	struct inet_connection_sock *icsk = inet_csk(sk);
@@ -1011,6 +1032,9 @@ static int mptcp_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 				break;
 			}
 
+			if (test_and_clear_bit(MPTCP_WORK_EOF, &msk->flags))
+				mptcp_check_for_eof(msk);
+
 			if (sk->sk_shutdown & RCV_SHUTDOWN)
 				break;
 
@@ -1148,27 +1172,6 @@ static unsigned int mptcp_sync_mss(struct sock *sk, u32 pmtu)
 	return 0;
 }
 
-static void mptcp_check_for_eof(struct mptcp_sock *msk)
-{
-	struct mptcp_subflow_context *subflow;
-	struct sock *sk = (struct sock *)msk;
-	int receivers = 0;
-
-	mptcp_for_each_subflow(msk, subflow)
-		receivers += !subflow->rx_eof;
-
-	if (!receivers && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
-		/* hopefully temporary hack: propagate shutdown status
-		 * to msk, when all subflows agree on it
-		 */
-		sk->sk_shutdown |= RCV_SHUTDOWN;
-
-		smp_mb__before_atomic(); /* SHUTDOWN must be visible first */
-		set_bit(MPTCP_DATA_READY, &msk->flags);
-		sk->sk_data_ready(sk);
-	}
-}
-
 static void mptcp_worker(struct work_struct *work)
 {
 	struct mptcp_sock *msk = container_of(work, struct mptcp_sock, work);
-- 
2.21.3


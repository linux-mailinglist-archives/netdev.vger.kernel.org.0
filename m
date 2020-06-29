Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F4D020DE97
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388841AbgF2U1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:07 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:23314 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389108AbgF2U1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:27:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XceIh8Y3sIXxWbc3XYUgBoKNPJ4S9xUkoJ2RIbjdXC8=;
        b=VFjSfibbHCcOkXdDIKruetCQGGN3D/XbrGshn8pX+jo5LVzTl55iSbrAUwEoyKEGlnYjV9
        SIkztJkuvVa3/rLOPJkDdQZcWO9AvaRfBIiT5BYy+7+ujvf2GbR/KxtI01ndPFp66g8Qvp
        /bbiOgZA349S1kFszQLR8cKH5i2E9J4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-106-rUUopEosOeG89pBzx5nmMw-1; Mon, 29 Jun 2020 16:26:57 -0400
X-MC-Unique: rUUopEosOeG89pBzx5nmMw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 66A951932487;
        Mon, 29 Jun 2020 20:26:56 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDA831C4;
        Mon, 29 Jun 2020 20:26:54 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 6/6] mptcp: close poll() races
Date:   Mon, 29 Jun 2020 22:26:25 +0200
Message-Id: <0c0e9026c97b90d92047b3771dc248e5d873ac6a.1593461586.git.dcaratti@redhat.com>
In-Reply-To: <cover.1593461586.git.dcaratti@redhat.com>
References: <cover.1593461586.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

mptcp_poll always return POLLOUT for unblocking
connect(), ensure that the socket is a suitable
state.
The MPTCP_DATA_READY bit is never cleared on accept:
ensure we don't leave mptcp_accept() with an empty
accept queue and such bit set.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index f2b2bd37e371..28ec26d97f96 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1841,6 +1841,7 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 	if (!ssock)
 		goto unlock_fail;
 
+	clear_bit(MPTCP_DATA_READY, &msk->flags);
 	sock_hold(ssock->sk);
 	release_sock(sock->sk);
 
@@ -1861,6 +1862,8 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 		}
 	}
 
+	if (inet_csk_listen_poll(ssock->sk))
+		set_bit(MPTCP_DATA_READY, &msk->flags);
 	sock_put(ssock->sk);
 	return err;
 
@@ -1869,21 +1872,33 @@ static int mptcp_stream_accept(struct socket *sock, struct socket *newsock,
 	return -EINVAL;
 }
 
+static __poll_t mptcp_check_readable(struct mptcp_sock *msk)
+{
+	return test_bit(MPTCP_DATA_READY, &msk->flags) ? EPOLLIN | EPOLLRDNORM :
+	       0;
+}
+
 static __poll_t mptcp_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait)
 {
 	struct sock *sk = sock->sk;
 	struct mptcp_sock *msk;
 	__poll_t mask = 0;
+	int state;
 
 	msk = mptcp_sk(sk);
 	sock_poll_wait(file, sock, wait);
 
-	if (test_bit(MPTCP_DATA_READY, &msk->flags))
-		mask = EPOLLIN | EPOLLRDNORM;
-	if (sk_stream_is_writeable(sk) &&
-	    test_bit(MPTCP_SEND_SPACE, &msk->flags))
-		mask |= EPOLLOUT | EPOLLWRNORM;
+	state = inet_sk_state_load(sk);
+	if (state == TCP_LISTEN)
+		return mptcp_check_readable(msk);
+
+	if (state != TCP_SYN_SENT && state != TCP_SYN_RECV) {
+		mask |= mptcp_check_readable(msk);
+		if (sk_stream_is_writeable(sk) &&
+		    test_bit(MPTCP_SEND_SPACE, &msk->flags))
+			mask |= EPOLLOUT | EPOLLWRNORM;
+	}
 	if (sk->sk_shutdown & RCV_SHUTDOWN)
 		mask |= EPOLLIN | EPOLLRDNORM | EPOLLRDHUP;
 
-- 
2.26.2


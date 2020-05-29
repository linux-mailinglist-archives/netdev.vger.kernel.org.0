Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4293A1E8258
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 17:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgE2PoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 11:44:14 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727937AbgE2PoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 11:44:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590767051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rNcToRMiHeBW2c9VDvLcv0SsxSrOtRRmagn6dFvdpXg=;
        b=JPpgk26l17KeYaHOxbMHoBry3DXMxFhPeFUVD7doEhQisuVqa7/mSyVMrnQgvyCvuuC2SV
        jaCKAE5q2w/i2KNZbFNsMZGCTyIXMxaRxFSk2UDdofw+HB2guHDYDnPs1WGRP6KUk9ecHI
        x8aGXGm/toM7ZuEIzvEnwxl/jUaybYM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-3dCNCO-ZMC2vDQYLAZe-3A-1; Fri, 29 May 2020 11:44:06 -0400
X-MC-Unique: 3dCNCO-ZMC2vDQYLAZe-3A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9BB36107ACF9;
        Fri, 29 May 2020 15:44:05 +0000 (UTC)
Received: from linux.fritz.box.com (ovpn-114-94.ams2.redhat.com [10.36.114.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B0B87A8C0;
        Fri, 29 May 2020 15:44:04 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] mptcp: fix unblocking connect()
Date:   Fri, 29 May 2020 17:43:29 +0200
Message-Id: <ed95b3e88cd4dfc3efc495c0be646c095aefb975.1590766645.git.pabeni@redhat.com>
In-Reply-To: <cover.1590766645.git.pabeni@redhat.com>
References: <cover.1590766645.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently unblocking connect() on MPTCP sockets fails frequently.
If mptcp_stream_connect() is invoked to complete a previously
attempted unblocking connection, it will still try to create
the first subflow via __mptcp_socket_create(). If the 3whs is
completed and the 'can_ack' flag is already set, the latter
will fail with -EINVAL.

This change addresses the issue checking for pending connect and
delegating the completion to the first subflow. Additionally
do msk addresses and sk_state changes only when needed.

Fixes: 2303f994b3e1 ("mptcp: Associate MPTCP context with TCP socket")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/mptcp/protocol.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index c8675d2eb5b9..8959a74f707d 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -1712,6 +1712,14 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 	int err;
 
 	lock_sock(sock->sk);
+	if (sock->state != SS_UNCONNECTED && msk->subflow) {
+		/* pending connection or invalid state, let existing subflow
+		 * cope with that
+		 */
+		ssock = msk->subflow;
+		goto do_connect;
+	}
+
 	ssock = __mptcp_socket_create(msk, TCP_SYN_SENT);
 	if (IS_ERR(ssock)) {
 		err = PTR_ERR(ssock);
@@ -1726,9 +1734,17 @@ static int mptcp_stream_connect(struct socket *sock, struct sockaddr *uaddr,
 		mptcp_subflow_ctx(ssock->sk)->request_mptcp = 0;
 #endif
 
+do_connect:
 	err = ssock->ops->connect(ssock, uaddr, addr_len, flags);
-	inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
-	mptcp_copy_inaddrs(sock->sk, ssock->sk);
+	sock->state = ssock->state;
+
+	/* on successful connect, the msk state will be moved to established by
+	 * subflow_finish_connect()
+	 */
+	if (!err || err == EINPROGRESS)
+		mptcp_copy_inaddrs(sock->sk, ssock->sk);
+	else
+		inet_sk_state_store(sock->sk, inet_sk_state_load(ssock->sk));
 
 unlock:
 	release_sock(sock->sk);
-- 
2.21.3


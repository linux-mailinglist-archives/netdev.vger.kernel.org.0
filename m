Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0F420DE9A
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732635AbgF2U1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:27:16 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:52465 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389105AbgF2U1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:27:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593462420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cK6XV9GWtDDbDZKJ4ooyQEgOiCenDNn1GvlhQw/h89E=;
        b=iLyL24bzxm2p78uq76ZMkOf39o/FdynRVVIOuJNqO/vs9koqpt9464TK8/JZYBiWCsqh/Y
        ByMz4NkEi8NY/xevFQfHks+UEOn24giJdwNWrOG+tQtHc4l84GK6bG4ZwQlksZEMmt+CAp
        01dWF0Hw+eyjd9znW5LXSk6oYt+DwtE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-qcsJPMB_MimRNACOWLf8EA-1; Mon, 29 Jun 2020 16:26:56 -0400
X-MC-Unique: qcsJPMB_MimRNACOWLf8EA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 71DF2804001;
        Mon, 29 Jun 2020 20:26:54 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.194.100])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA1CE1C4;
        Mon, 29 Jun 2020 20:26:52 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        mptcp@lists.01.org
Subject: [PATCH net-next 5/6] mptcp: __mptcp_tcp_fallback() returns a struct sock
Date:   Mon, 29 Jun 2020 22:26:24 +0200
Message-Id: <f4474c22d50669fa3702224677fd2c2541b83ca9.1593461586.git.dcaratti@redhat.com>
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

Currently __mptcp_tcp_fallback() always return NULL
on incoming connections, because MPTCP does not create
the additional socket for the first subflow.
Since the previous commit no __mptcp_tcp_fallback()
caller needs a struct socket, so let __mptcp_tcp_fallback()
return the first subflow sock and cope correctly even with
incoming connections.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/mptcp/protocol.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index ad619bda71cc..f2b2bd37e371 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -76,14 +76,14 @@ static bool mptcp_is_tcpsk(struct sock *sk)
 	return false;
 }
 
-static struct socket *__mptcp_tcp_fallback(struct mptcp_sock *msk)
+static struct sock *__mptcp_tcp_fallback(struct mptcp_sock *msk)
 {
 	sock_owned_by_me((const struct sock *)msk);
 
 	if (likely(!__mptcp_check_fallback(msk)))
 		return NULL;
 
-	return msk->subflow;
+	return msk->first;
 }
 
 static int __mptcp_socket_create(struct mptcp_sock *msk)
@@ -1498,7 +1498,7 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, unsigned int optlen)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *ssock;
+	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
@@ -1509,11 +1509,10 @@ static int mptcp_setsockopt(struct sock *sk, int level, int optname,
 	 * to the one remaining subflow.
 	 */
 	lock_sock(sk);
-	ssock = __mptcp_tcp_fallback(msk);
+	ssk = __mptcp_tcp_fallback(msk);
 	release_sock(sk);
-	if (ssock)
-		return tcp_setsockopt(ssock->sk, level, optname, optval,
-				      optlen);
+	if (ssk)
+		return tcp_setsockopt(ssk, level, optname, optval, optlen);
 
 	return -EOPNOTSUPP;
 }
@@ -1522,7 +1521,7 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 			    char __user *optval, int __user *option)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
-	struct socket *ssock;
+	struct sock *ssk;
 
 	pr_debug("msk=%p", msk);
 
@@ -1533,11 +1532,10 @@ static int mptcp_getsockopt(struct sock *sk, int level, int optname,
 	 * to the one remaining subflow.
 	 */
 	lock_sock(sk);
-	ssock = __mptcp_tcp_fallback(msk);
+	ssk = __mptcp_tcp_fallback(msk);
 	release_sock(sk);
-	if (ssock)
-		return tcp_getsockopt(ssock->sk, level, optname, optval,
-				      option);
+	if (ssk)
+		return tcp_getsockopt(ssk, level, optname, optval, option);
 
 	return -EOPNOTSUPP;
 }
-- 
2.26.2


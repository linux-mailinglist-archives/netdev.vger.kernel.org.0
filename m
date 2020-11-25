Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82C462C479F
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 19:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733032AbgKYS33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 13:29:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26116 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730551AbgKYS33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 13:29:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606328967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w3UIbweN2X4UtNNbokxEfstuvXkroSzVxkp7iA/VMu4=;
        b=GRF8UdEiD//W7GCty1ngXeMnB9qYo4xuc106F9RkL+TYf/TRFtT+luetMO4aZGsNDPFAyH
        TFRelt3WrzE7qNB4yPnvZG9tThBCQC1bQYLO8tgpEYk6h4m+yhVFoBaj+XOuDdPN8MhdUG
        d7dh/7fmEXUe2JC38a28Rtuj9ogs6do=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-5TKTY64rPs-8lVWFT8FMqA-1; Wed, 25 Nov 2020 13:29:23 -0500
X-MC-Unique: 5TKTY64rPs-8lVWFT8FMqA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1D6287309E;
        Wed, 25 Nov 2020 18:29:21 +0000 (UTC)
Received: from f31.redhat.com (ovpn-113-167.rdu2.redhat.com [10.10.113.167])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C84AA19C46;
        Wed, 25 Nov 2020 18:29:19 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net-next 1/3] tipc: refactor tipc_sk_bind() function
Date:   Wed, 25 Nov 2020 13:29:13 -0500
Message-Id: <20201125182915.711370-2-jmaloy@redhat.com>
In-Reply-To: <20201125182915.711370-1-jmaloy@redhat.com>
References: <20201125182915.711370-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

We refactor the tipc_sk_bind() function, so that the lock handling
is handled separately from the logics. We also move some sanity
tests to earlier in the call chain, to the function tipc_bind().

Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 66 +++++++++++++++++++++--------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index 69c4b16e8184..2b633463f40d 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1,8 +1,9 @@
 /*
  * net/tipc/socket.c: TIPC socket API
  *
- * Copyright (c) 2001-2007, 2012-2017, Ericsson AB
+ * Copyright (c) 2001-2007, 2012-2019, Ericsson AB
  * Copyright (c) 2004-2008, 2010-2013, Wind River Systems
+ * Copyright (c) 2020, Red Hat Inc
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -644,10 +645,10 @@ static int tipc_release(struct socket *sock)
 }
 
 /**
- * tipc_bind - associate or disassocate TIPC name(s) with a socket
+ * __tipc_bind - associate or disassocate TIPC name(s) with a socket
  * @sock: socket structure
- * @uaddr: socket address describing name(s) and desired operation
- * @uaddr_len: size of socket address data structure
+ * @skaddr: socket address describing name(s) and desired operation
+ * @alen: size of socket address data structure
  *
  * Name and name sequence binding is indicated using a positive scope value;
  * a negative scope value unbinds the specified name.  Specifying no name
@@ -658,44 +659,33 @@ static int tipc_release(struct socket *sock)
  * NOTE: This routine doesn't need to take the socket lock since it doesn't
  *       access any non-constant socket information.
  */
-
-int tipc_sk_bind(struct socket *sock, struct sockaddr *uaddr, int uaddr_len)
+static int __tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 {
-	struct sock *sk = sock->sk;
-	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
-	struct tipc_sock *tsk = tipc_sk(sk);
-	int res = -EINVAL;
+	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)skaddr;
+	struct tipc_sock *tsk = tipc_sk(sock->sk);
 
-	lock_sock(sk);
-	if (unlikely(!uaddr_len)) {
-		res = tipc_sk_withdraw(tsk, 0, NULL);
-		goto exit;
-	}
-	if (tsk->group) {
-		res = -EACCES;
-		goto exit;
-	}
-	if (uaddr_len < sizeof(struct sockaddr_tipc)) {
-		res = -EINVAL;
-		goto exit;
-	}
-	if (addr->family != AF_TIPC) {
-		res = -EAFNOSUPPORT;
-		goto exit;
-	}
+	if (unlikely(!alen))
+		return tipc_sk_withdraw(tsk, 0, NULL);
 
 	if (addr->addrtype == TIPC_ADDR_NAME)
 		addr->addr.nameseq.upper = addr->addr.nameseq.lower;
-	else if (addr->addrtype != TIPC_ADDR_NAMESEQ) {
-		res = -EAFNOSUPPORT;
-		goto exit;
-	}
 
-	res = (addr->scope >= 0) ?
-		tipc_sk_publish(tsk, addr->scope, &addr->addr.nameseq) :
-		tipc_sk_withdraw(tsk, -addr->scope, &addr->addr.nameseq);
-exit:
-	release_sock(sk);
+	if (tsk->group)
+		return -EACCES;
+
+	if (addr->scope >= 0)
+		return tipc_sk_publish(tsk, addr->scope, &addr->addr.nameseq);
+	else
+		return tipc_sk_withdraw(tsk, -addr->scope, &addr->addr.nameseq);
+}
+
+int tipc_sk_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
+{
+	int res;
+
+	lock_sock(sock->sk);
+	res = __tipc_bind(sock, skaddr, alen);
+	release_sock(sock->sk);
 	return res;
 }
 
@@ -706,6 +696,10 @@ static int tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
 	if (alen) {
 		if (alen < sizeof(struct sockaddr_tipc))
 			return -EINVAL;
+		if (addr->family != AF_TIPC)
+			return -EAFNOSUPPORT;
+		if (addr->addrtype > TIPC_SERVICE_ADDR)
+			return -EAFNOSUPPORT;
 		if (addr->addr.nameseq.type < TIPC_RESERVED_TYPES) {
 			pr_warn_once("Can't bind to reserved service type %u\n",
 				     addr->addr.nameseq.type);
-- 
2.25.4


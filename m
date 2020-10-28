Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094F629D7A2
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:28:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbgJ1WZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:25:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46875 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732870AbgJ1WZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:25:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603923919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OKpJLQNcbdtXqKfUCsznLvCGwnNpeeIO7SiSWz007aM=;
        b=UA4ALD1+4D9M4ujknev8POdcic6sKcc1P4vj0Uc8K3D0xVzKMacqwLq48cgiy7OTxioQcM
        qNiV9xX8LJZzTV3kcy471vLuybux8abR96eMXTdAEqp1lPU1IxZ61jTq59UyvutzmtgFag
        W1NTVvgm6aqeuaH9rRc0GWCeGTyetUM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-83-wL0uJA1XO6WuRrcFsFJMEQ-1; Wed, 28 Oct 2020 09:23:01 -0400
X-MC-Unique: wL0uJA1XO6WuRrcFsFJMEQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80F518A8A7C;
        Wed, 28 Oct 2020 13:19:14 +0000 (UTC)
Received: from f31.redhat.com (ovpn-112-215.rdu2.redhat.com [10.10.112.215])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF88E60C04;
        Wed, 28 Oct 2020 13:19:12 +0000 (UTC)
From:   jmaloy@redhat.com
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     tipc-discussion@lists.sourceforge.net,
        tung.q.nguyen@dektech.com.au, hoang.h.le@dektech.com.au,
        tuong.t.lien@dektech.com.au, jmaloy@redhat.com, maloy@donjonn.com,
        xinl@redhat.com, ying.xue@windriver.com,
        parthasarathy.bhuvaragan@gmail.com
Subject: [net] tipc: add stricter control of reserved service types
Date:   Wed, 28 Oct 2020 09:19:12 -0400
Message-Id: <20201028131912.3773561-1-jmaloy@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jon Maloy <jmaloy@redhat.com>

TIPC reserves 64 service types for current and future internal use.
Therefore, the bind() function is meant to block regular user sockets
from being bound to these values, while it should let through such
bindings from internal users.

However, since we at the design moment saw no way to distinguish
between regular and internal users the filter function ended up
with allowing all bindings of the reserved types which were really
in use ([0,1]), and block all the rest ([2,63]).

This is risky, since a regular user may bind to the service type
representing the topology server (TIPC_TOP_SRV == 1) or the one used
for indicating neighboring node status (TIPC_CFG_SRV == 0), and wreak
havoc for users of those services, i.e., most users.

The reality is however that TIPC_CFG_SRV never is bound through the
bind() function, since it doesn't represent a regular socket, and
TIPC_TOP_SRV can also be made to bypass the checks in tipc_bind()
by introducing a different entry function, tipc_sk_bind().

It should be noted that although this is a change of the API semantics,
there is no risk we will break any currently working applications by
doing this. Any application trying to bind to the values in question
would be badly broken from the outset, so there is no chance we would
find any such applications in real-world production systems.

Acked-by: Yung Xue <ying.xue@windriver.com>
Signed-off-by: Jon Maloy <jmaloy@redhat.com>
---
 net/tipc/socket.c | 24 +++++++++++++++---------
 net/tipc/socket.h |  2 +-
 net/tipc/topsrv.c |  4 ++--
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e795a8a2955b..222fd53da2d0 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -658,8 +658,8 @@ static int tipc_release(struct socket *sock)
  * NOTE: This routine doesn't need to take the socket lock since it doesn't
  *       access any non-constant socket information.
  */
-static int tipc_bind(struct socket *sock, struct sockaddr *uaddr,
-		     int uaddr_len)
+
+int tipc_sk_bind(struct socket *sock, struct sockaddr *uaddr, int uaddr_len)
 {
 	struct sock *sk = sock->sk;
 	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)uaddr;
@@ -691,13 +691,6 @@ static int tipc_bind(struct socket *sock, struct sockaddr *uaddr,
 		goto exit;
 	}
 
-	if ((addr->addr.nameseq.type < TIPC_RESERVED_TYPES) &&
-	    (addr->addr.nameseq.type != TIPC_TOP_SRV) &&
-	    (addr->addr.nameseq.type != TIPC_CFG_SRV)) {
-		res = -EACCES;
-		goto exit;
-	}
-
 	res = (addr->scope >= 0) ?
 		tipc_sk_publish(tsk, addr->scope, &addr->addr.nameseq) :
 		tipc_sk_withdraw(tsk, -addr->scope, &addr->addr.nameseq);
@@ -706,6 +699,19 @@ static int tipc_bind(struct socket *sock, struct sockaddr *uaddr,
 	return res;
 }
 
+static int tipc_bind(struct socket *sock, struct sockaddr *skaddr, int alen)
+{
+	struct sockaddr_tipc *addr = (struct sockaddr_tipc *)skaddr;
+
+	if (alen) {
+		if (alen < sizeof(struct sockaddr_tipc))
+			return -EINVAL;
+		if (addr->addr.nameseq.type < TIPC_RESERVED_TYPES)
+			return -EACCES;
+	}
+	return tipc_sk_bind(sock, skaddr, alen);
+}
+
 /**
  * tipc_getname - get port ID of socket or peer socket
  * @sock: socket structure
diff --git a/net/tipc/socket.h b/net/tipc/socket.h
index b11575afc66f..02cdf166807d 100644
--- a/net/tipc/socket.h
+++ b/net/tipc/socket.h
@@ -74,7 +74,7 @@ int tipc_dump_done(struct netlink_callback *cb);
 u32 tipc_sock_get_portid(struct sock *sk);
 bool tipc_sk_overlimit1(struct sock *sk, struct sk_buff *skb);
 bool tipc_sk_overlimit2(struct sock *sk, struct sk_buff *skb);
-
+int tipc_sk_bind(struct socket *sock, struct sockaddr *skaddr, int alen);
 int tsk_set_importance(struct sock *sk, int imp);
 
 #endif
diff --git a/net/tipc/topsrv.c b/net/tipc/topsrv.c
index 5f6f86051c83..cec029349662 100644
--- a/net/tipc/topsrv.c
+++ b/net/tipc/topsrv.c
@@ -520,12 +520,12 @@ static int tipc_topsrv_create_listener(struct tipc_topsrv *srv)
 
 	saddr.family	                = AF_TIPC;
 	saddr.addrtype		        = TIPC_ADDR_NAMESEQ;
-	saddr.addr.nameseq.type	        = TIPC_TOP_SRV;
+	saddr.addr.nameseq.type         = TIPC_TOP_SRV;
 	saddr.addr.nameseq.lower	= TIPC_TOP_SRV;
 	saddr.addr.nameseq.upper	= TIPC_TOP_SRV;
 	saddr.scope			= TIPC_NODE_SCOPE;
 
-	rc = kernel_bind(lsock, (struct sockaddr *)&saddr, sizeof(saddr));
+	rc = tipc_sk_bind(lsock, (struct sockaddr *)&saddr, sizeof(saddr));
 	if (rc < 0)
 		goto err;
 	rc = kernel_listen(lsock, 0);
-- 
2.25.4


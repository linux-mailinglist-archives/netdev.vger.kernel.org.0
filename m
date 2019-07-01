Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E375C1C1
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbfGARKC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:10:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGARKA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:10:00 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BE6F30860A3;
        Mon,  1 Jul 2019 17:09:55 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-226.ams2.redhat.com [10.36.117.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CB5E1001B20;
        Mon,  1 Jul 2019 17:09:54 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/5] inet: factor out inet_send_prepare()
Date:   Mon,  1 Jul 2019 19:09:33 +0200
Message-Id: <25eff23ae755bb2674327943f958bb1ebcced33b.1561999976.git.pabeni@redhat.com>
In-Reply-To: <cover.1561999976.git.pabeni@redhat.com>
References: <cover.1561999976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 01 Jul 2019 17:10:00 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The same code is replicated verbatim in multiple places, and the next
patches will introduce an additional user for it. Factor out a
helper and use it where appropriate. No functional change intended.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/inet_common.h |  1 +
 net/ipv4/af_inet.c        | 21 +++++++++++++--------
 2 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/include/net/inet_common.h b/include/net/inet_common.h
index 975901a95c0f..ae2ba897675c 100644
--- a/include/net/inet_common.h
+++ b/include/net/inet_common.h
@@ -25,6 +25,7 @@ int inet_dgram_connect(struct socket *sock, struct sockaddr *uaddr,
 		       int addr_len, int flags);
 int inet_accept(struct socket *sock, struct socket *newsock, int flags,
 		bool kern);
+int inet_send_prepare(struct sock *sk);
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
 ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 		      size_t size, int flags);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 52bdb881a506..8421e2f5bbb3 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -784,10 +784,8 @@ int inet_getname(struct socket *sock, struct sockaddr *uaddr,
 }
 EXPORT_SYMBOL(inet_getname);
 
-int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+int inet_send_prepare(struct sock *sk)
 {
-	struct sock *sk = sock->sk;
-
 	sock_rps_record_flow(sk);
 
 	/* We may need to bind the socket. */
@@ -795,6 +793,17 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	    inet_autobind(sk))
 		return -EAGAIN;
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(inet_send_prepare);
+
+int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return -EAGAIN;
+
 	return sk->sk_prot->sendmsg(sk, msg, size);
 }
 EXPORT_SYMBOL(inet_sendmsg);
@@ -804,11 +813,7 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 {
 	struct sock *sk = sock->sk;
 
-	sock_rps_record_flow(sk);
-
-	/* We may need to bind the socket. */
-	if (!inet_sk(sk)->inet_num && !sk->sk_prot->no_autobind &&
-	    inet_autobind(sk))
+	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
 	if (sk->sk_prot->sendpage)
-- 
2.20.1


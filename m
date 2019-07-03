Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93A45E60F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfGCOHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:07:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40596 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCOHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:07:12 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E87DAC04AC70;
        Wed,  3 Jul 2019 14:07:11 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF0EC1001DCF;
        Wed,  3 Jul 2019 14:07:09 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 1/5] inet: factor out inet_send_prepare()
Date:   Wed,  3 Jul 2019 16:06:52 +0200
Message-Id: <d3f4f9ad64e9e573ef003eb69d84f03d4320ad12.1562162469.git.pabeni@redhat.com>
In-Reply-To: <cover.1562162469.git.pabeni@redhat.com>
References: <cover.1562162469.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Wed, 03 Jul 2019 14:07:12 +0000 (UTC)
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


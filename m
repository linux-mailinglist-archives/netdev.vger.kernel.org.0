Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7229E5C1C3
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728974AbfGARKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44864 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGARKC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:10:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 40EF730C1205;
        Mon,  1 Jul 2019 17:10:02 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-226.ams2.redhat.com [10.36.117.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 80A381001B10;
        Mon,  1 Jul 2019 17:10:00 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 5/5] ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()
Date:   Mon,  1 Jul 2019 19:09:37 +0200
Message-Id: <8c32b92eee12bf0725ead331e7607d8c4012d51f.1561999976.git.pabeni@redhat.com>
In-Reply-To: <cover.1561999976.git.pabeni@redhat.com>
References: <cover.1561999976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 01 Jul 2019 17:10:02 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids an indirect call per syscall for common ipv4 transports

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/af_inet.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8421e2f5bbb3..9a2f17d0c5f5 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -797,6 +797,8 @@ int inet_send_prepare(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(inet_send_prepare);
 
+INDIRECT_CALLABLE_DECLARE(int udp_sendmsg(struct sock *, struct msghdr *,
+					  size_t));
 int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 {
 	struct sock *sk = sock->sk;
@@ -804,7 +806,8 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
-	return sk->sk_prot->sendmsg(sk, msg, size);
+	return INDIRECT_CALL_2(sk->sk_prot->sendmsg, tcp_sendmsg, udp_sendmsg,
+			       sk, msg, size);
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
@@ -822,6 +825,8 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 }
 EXPORT_SYMBOL(inet_sendpage);
 
+INDIRECT_CALLABLE_DECLARE(int udp_recvmsg(struct sock *, struct msghdr *,
+					  size_t, int, int, int *));
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		 int flags)
 {
@@ -832,8 +837,9 @@ int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (likely(!(flags & MSG_ERRQUEUE)))
 		sock_rps_record_flow(sk);
 
-	err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
-				   flags & ~MSG_DONTWAIT, &addr_len);
+	err = INDIRECT_CALL_2(sk->sk_prot->recvmsg, tcp_recvmsg, udp_recvmsg,
+			      sk, msg, size, flags & MSG_DONTWAIT,
+			      flags & ~MSG_DONTWAIT, &addr_len);
 	if (err >= 0)
 		msg->msg_namelen = addr_len;
 	return err;
-- 
2.20.1


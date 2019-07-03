Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5BB75E614
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727158AbfGCOHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:07:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfGCOHS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:07:18 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F3F323E2CD;
        Wed,  3 Jul 2019 14:07:17 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0770C1001B18;
        Wed,  3 Jul 2019 14:07:16 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 5/5] ipv4: use indirect call wrappers for {tcp,udp}_{recv,send}msg()
Date:   Wed,  3 Jul 2019 16:06:56 +0200
Message-Id: <21a27b8f0014712f29cef00d1191841ad8dd57d9.1562162469.git.pabeni@redhat.com>
In-Reply-To: <cover.1562162469.git.pabeni@redhat.com>
References: <cover.1562162469.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Wed, 03 Jul 2019 14:07:18 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids an indirect call per syscall for common ipv4 transports

v1 -> v2:
 - avoid unneeded reclaration for udp_sendmsg, as suggested by Willem

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/ipv4/af_inet.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 8421e2f5bbb3..ed2301ef872e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -804,7 +804,8 @@ int inet_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (unlikely(inet_send_prepare(sk)))
 		return -EAGAIN;
 
-	return sk->sk_prot->sendmsg(sk, msg, size);
+	return INDIRECT_CALL_2(sk->sk_prot->sendmsg, tcp_sendmsg, udp_sendmsg,
+			       sk, msg, size);
 }
 EXPORT_SYMBOL(inet_sendmsg);
 
@@ -822,6 +823,8 @@ ssize_t inet_sendpage(struct socket *sock, struct page *page, int offset,
 }
 EXPORT_SYMBOL(inet_sendpage);
 
+INDIRECT_CALLABLE_DECLARE(int udp_recvmsg(struct sock *, struct msghdr *,
+					  size_t, int, int, int *));
 int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		 int flags)
 {
@@ -832,8 +835,9 @@ int inet_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
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


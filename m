Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3795C1C0
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbfGARJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:09:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGARJ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:09:58 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 256643087935;
        Mon,  1 Jul 2019 17:09:58 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-226.ams2.redhat.com [10.36.117.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 666EA1001B35;
        Mon,  1 Jul 2019 17:09:57 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 3/5] net: adjust socket level ICW to cope with ipv6 variant of {recv,send}msg
Date:   Mon,  1 Jul 2019 19:09:35 +0200
Message-Id: <995829b544599913b84e7bf925877f0316a3a8c7.1561999976.git.pabeni@redhat.com>
In-Reply-To: <cover.1561999976.git.pabeni@redhat.com>
References: <cover.1561999976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 01 Jul 2019 17:09:58 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch we have ipv{6,4} variants for {recv,send}msg,
we should use the generic _INET ICW variant to call into the proper
build-in.

This also allows dropping the now unused and rather ugly _INET4 ICW macro

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/socket.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 963df5dbdd54..f5e0e460012b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -103,13 +103,6 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 
-/* proto_ops for ipv4 and ipv6 use the same {recv,send}msg function */
-#if IS_ENABLED(CONFIG_INET)
-#define INDIRECT_CALL_INET4(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
-#else
-#define INDIRECT_CALL_INET4(f, f1, ...) f(__VA_ARGS__)
-#endif
-
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
 unsigned int sysctl_net_busy_poll __read_mostly;
@@ -643,8 +636,9 @@ INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
 					   size_t));
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
-	int ret = INDIRECT_CALL_INET4(sock->ops->sendmsg, inet_sendmsg, sock,
-				      msg, msg_data_left(msg));
+	int ret = INDIRECT_CALL_INET(sock->ops->sendmsg, inet6_sendmsg,
+				     inet_sendmsg, sock, msg,
+				     msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
 	return ret;
 }
@@ -874,8 +868,9 @@ INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return INDIRECT_CALL_INET4(sock->ops->recvmsg, inet_recvmsg, sock, msg,
-				   msg_data_left(msg), flags);
+	return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
+				  inet_recvmsg, sock, msg, msg_data_left(msg),
+				  flags);
 }
 
 /**
-- 
2.20.1


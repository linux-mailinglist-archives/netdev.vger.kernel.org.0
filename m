Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E3F5E612
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfGCOHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 10:07:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39120 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfGCOHP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jul 2019 10:07:15 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5ED9083F3B;
        Wed,  3 Jul 2019 14:07:15 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-79.ams2.redhat.com [10.36.117.79])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 66E511001B18;
        Wed,  3 Jul 2019 14:07:14 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH net-next v2 3/5] net: adjust socket level ICW to cope with ipv6 variant of {recv,send}msg
Date:   Wed,  3 Jul 2019 16:06:54 +0200
Message-Id: <dc2878401b52240581ce4f78afb9b226b78fcdef.1562162469.git.pabeni@redhat.com>
In-Reply-To: <cover.1562162469.git.pabeni@redhat.com>
References: <cover.1562162469.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 03 Jul 2019 14:07:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch we have ipv{6,4} variants for {recv,send}msg,
we should use the generic _INET ICW variant to call into the proper
build-in.

This also allows dropping the now unused and rather ugly _INET4 ICW macro

v1 -> v2:
 - use ICW macro to declare inet6_{recv,send}msg
 - fix a couple of checkpatch offender in the code context

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/socket.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index 963df5dbdd54..a865708940f9 100644
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
@@ -641,10 +634,13 @@ EXPORT_SYMBOL(__sock_tx_timestamp);
 
 INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
 					   size_t));
+INDIRECT_CALLABLE_DECLARE(int inet6_sendmsg(struct socket *, struct msghdr *,
+					    size_t));
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
@@ -870,12 +866,15 @@ void __sock_recv_ts_and_drops(struct msghdr *msg, struct sock *sk,
 EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
 
 INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
-					   size_t , int ));
+					   size_t, int));
+INDIRECT_CALLABLE_DECLARE(int inet6_recvmsg(struct socket *, struct msghdr *,
+					    size_t, int));
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


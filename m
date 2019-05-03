Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABDDC130CF
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 17:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfECPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 11:01:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59978 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfECPBv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 11:01:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 621EBC0B0234;
        Fri,  3 May 2019 15:01:51 +0000 (UTC)
Received: from localhost.localdomain.com (unknown [10.32.181.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8FBD22DACC;
        Fri,  3 May 2019 15:01:50 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 4/4] net: use indirect calls helpers at the socket layer
Date:   Fri,  3 May 2019 17:01:39 +0200
Message-Id: <fd4e398581e0660c7228bdb778052201e61b1da8.1556889691.git.pabeni@redhat.com>
In-Reply-To: <cover.1556889691.git.pabeni@redhat.com>
References: <cover.1556889691.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 03 May 2019 15:01:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This avoids an indirect call per {send,recv}msg syscall in
the common (IPv6 or IPv4 socket) case.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/socket.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index a180e1a9ff23..472fbefa5d9b 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -90,6 +90,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/nospec.h>
+#include <linux/indirect_call_wrapper.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -108,6 +109,13 @@
 #include <net/busy_poll.h>
 #include <linux/errqueue.h>
 
+/* proto_ops for ipv4 and ipv6 use the same {recv,send}msg function */
+#if IS_ENABLED(CONFIG_INET)
+#define INDIRECT_CALL_INET4(f, f1, ...) INDIRECT_CALL_1(f, f1, __VA_ARGS__)
+#else
+#define INDIRECT_CALL_INET4(f, f1, ...) f(__VA_ARGS__)
+#endif
+
 #ifdef CONFIG_NET_RX_BUSY_POLL
 unsigned int sysctl_net_busy_read __read_mostly;
 unsigned int sysctl_net_busy_poll __read_mostly;
@@ -645,10 +653,12 @@ EXPORT_SYMBOL(__sock_tx_timestamp);
  *	Sends @msg through @sock, passing through LSM.
  *	Returns the number of bytes sent, or an error code.
  */
-
+INDIRECT_CALLABLE_DECLARE(int inet_sendmsg(struct socket *, struct msghdr *,
+					   size_t));
 static inline int sock_sendmsg_nosec(struct socket *sock, struct msghdr *msg)
 {
-	int ret = sock->ops->sendmsg(sock, msg, msg_data_left(msg));
+	int ret = INDIRECT_CALL_INET4(sock->ops->sendmsg, inet_sendmsg, sock,
+				      msg, msg_data_left(msg));
 	BUG_ON(ret == -EIOCBQUEUED);
 	return ret;
 }
@@ -874,11 +884,13 @@ EXPORT_SYMBOL_GPL(__sock_recv_ts_and_drops);
  *	Receives @msg from @sock, passing through LSM. Returns the total number
  *	of bytes received, or an error.
  */
-
+INDIRECT_CALLABLE_DECLARE(int inet_recvmsg(struct socket *, struct msghdr *,
+					   size_t , int ));
 static inline int sock_recvmsg_nosec(struct socket *sock, struct msghdr *msg,
 				     int flags)
 {
-	return sock->ops->recvmsg(sock, msg, msg_data_left(msg), flags);
+	return INDIRECT_CALL_INET4(sock->ops->recvmsg, inet_recvmsg, sock, msg,
+				   msg_data_left(msg), flags);
 }
 
 int sock_recvmsg(struct socket *sock, struct msghdr *msg, int flags)
-- 
2.20.1


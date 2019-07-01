Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02E605C1BF
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbfGARJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:09:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33108 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbfGARJ5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 13:09:57 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 194BA30832F2;
        Mon,  1 Jul 2019 17:09:57 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-117-226.ams2.redhat.com [10.36.117.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5A5141001B34;
        Mon,  1 Jul 2019 17:09:55 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 2/5] ipv6: provide and use ipv6 specific version for {recv,send}msg
Date:   Mon,  1 Jul 2019 19:09:34 +0200
Message-Id: <1b953679cde558878b9f82b30fbfe693e421019b.1561999976.git.pabeni@redhat.com>
In-Reply-To: <cover.1561999976.git.pabeni@redhat.com>
References: <cover.1561999976.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Mon, 01 Jul 2019 17:09:57 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This will simplify indirect call wrapper invocation in the following
patch.

No functional change intended, any - out-of-tree - IPv6 user of
inet_{recv,send}msg can keep using the existing functions.

SCTP code still uses the existing version even for ipv6: as this series
will not add ICW for SCTP, moving to the new helper would not give
any benefit.

The only other in-kernel user of inet_{recv,send}msg is
pvcalls_conn_back_read(), but psvcalls explicitly creates only IPv4 socket,
so no need to update that code path, too.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 include/net/ipv6.h  |  3 +++
 net/ipv6/af_inet6.c | 35 +++++++++++++++++++++++++++++++----
 2 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index b41f6a0fa903..aecc28dff8f8 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -1089,6 +1089,9 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg);
 
 int inet6_hash_connect(struct inet_timewait_death_row *death_row,
 			      struct sock *sk);
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size);
+int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		  int flags);
 
 /*
  * reassembly.c
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 7382a927d1eb..4628681eca88 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -564,6 +564,33 @@ int inet6_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 }
 EXPORT_SYMBOL(inet6_ioctl);
 
+int inet6_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
+{
+	struct sock *sk = sock->sk;
+
+	if (unlikely(inet_send_prepare(sk)))
+		return -EAGAIN;
+
+	return sk->sk_prot->sendmsg(sk, msg, size);
+}
+
+int inet6_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		  int flags)
+{
+	struct sock *sk = sock->sk;
+	int addr_len = 0;
+	int err;
+
+	if (likely(!(flags & MSG_ERRQUEUE)))
+		sock_rps_record_flow(sk);
+
+	err = sk->sk_prot->recvmsg(sk, msg, size, flags & MSG_DONTWAIT,
+				   flags & ~MSG_DONTWAIT, &addr_len);
+	if (err >= 0)
+		msg->msg_namelen = addr_len;
+	return err;
+}
+
 const struct proto_ops inet6_stream_ops = {
 	.family		   = PF_INET6,
 	.owner		   = THIS_MODULE,
@@ -580,8 +607,8 @@ const struct proto_ops inet6_stream_ops = {
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
-	.recvmsg	   = inet_recvmsg,		/* ok		*/
+	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
+	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
 #ifdef CONFIG_MMU
 	.mmap		   = tcp_mmap,
 #endif
@@ -614,8 +641,8 @@ const struct proto_ops inet6_dgram_ops = {
 	.shutdown	   = inet_shutdown,		/* ok		*/
 	.setsockopt	   = sock_common_setsockopt,	/* ok		*/
 	.getsockopt	   = sock_common_getsockopt,	/* ok		*/
-	.sendmsg	   = inet_sendmsg,		/* ok		*/
-	.recvmsg	   = inet_recvmsg,		/* ok		*/
+	.sendmsg	   = inet6_sendmsg,		/* retpoline's sake */
+	.recvmsg	   = inet6_recvmsg,		/* retpoline's sake */
 	.mmap		   = sock_no_mmap,
 	.sendpage	   = sock_no_sendpage,
 	.set_peek_off	   = sk_set_peek_off,
-- 
2.20.1


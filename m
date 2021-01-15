Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216D92F7272
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:45:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbhAOFnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:43:43 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:61520 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731908AbhAOFnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:43:39 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id CF80F75B8A;
        Fri, 15 Jan 2021 08:42:53 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689373;
        bh=ljgNBqBbqAp+WTz3NeQEjfjnUjyCFJNthe0rdbBz0ks=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=o8il0Uqcx3rPvdxLGlaBTWiooNGNm3EraYWl1azVN3EX00ytOYOO8Ac7LTaKpa37p
         fK1nMBR36KoE07Ys6xevrujeazoYk9OU/eNzcdhhVeZ3TaaFXp8QvtOTMKeawuswxf
         x8xTFNnBybS2Q0hzLNUov9AnUosIlLGA/DSxW1wE=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 984C575BB6;
        Fri, 15 Jan 2021 08:42:53 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:42:53 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 06/13] af_vsock: general support of SOCK_SEQPACKET type.
Date:   Fri, 15 Jan 2021 08:42:43 +0300
Message-ID: <20210115054247.1456375-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/15/2021 05:18:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161159 [Jan 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 420 420 0b339e70b2b1bb108f53ec9b40aa316bba18ceea
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/15/2021 05:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.01.2021 2:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/15 05:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/15 02:12:00 #16041563
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds socket operations for SOCK_SEQPACKET and adds this type of
socket for conditions where SOCK_STREAM is involved because both type of
sockets are connect oriented.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 108 +++++++++++++++++++++++++++++++++------
 1 file changed, 92 insertions(+), 16 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4a7cdf7756c0..d0ef066e9352 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -452,6 +452,7 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 		new_transport = transport_dgram;
 		break;
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		if (vsock_use_local_transport(remote_cid))
 			new_transport = transport_local;
 		else if (remote_cid <= VMADDR_CID_HOST || !transport_h2g ||
@@ -459,6 +460,13 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 			new_transport = transport_g2h;
 		else
 			new_transport = transport_h2g;
+
+		if (sk->sk_type == SOCK_SEQPACKET) {
+			if (!new_transport->seqpacket_seq_send_len ||
+			    !new_transport->seqpacket_seq_get_len ||
+			    !new_transport->seqpacket_dequeue)
+				return -ENODEV;
+		}
 		break;
 	default:
 		return -ESOCKTNOSUPPORT;
@@ -604,8 +612,8 @@ static void vsock_pending_work(struct work_struct *work)
 
 /**** SOCKET OPERATIONS ****/
 
-static int __vsock_bind_stream(struct vsock_sock *vsk,
-			       struct sockaddr_vm *addr)
+static int __vsock_bind_connectible(struct vsock_sock *vsk,
+				    struct sockaddr_vm *addr)
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
@@ -684,8 +692,9 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 
 	switch (sk->sk_socket->type) {
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		spin_lock_bh(&vsock_table_lock);
-		retval = __vsock_bind_stream(vsk, addr);
+		retval = __vsock_bind_connectible(vsk, addr);
 		spin_unlock_bh(&vsock_table_lock);
 		break;
 
@@ -767,6 +776,11 @@ static struct sock *__vsock_create(struct net *net,
 	return sk;
 }
 
+static bool sock_type_connectible(u16 type)
+{
+	return (type == SOCK_STREAM || type == SOCK_SEQPACKET);
+}
+
 static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
@@ -785,7 +799,7 @@ static void __vsock_release(struct sock *sk, int level)
 
 		if (vsk->transport)
 			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
+		else if (sock_type_connectible(sk->sk_type))
 			vsock_remove_sock(vsk);
 
 		sock_orphan(sk);
@@ -945,7 +959,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	sk = sock->sk;
 	if (sock->state == SS_UNCONNECTED) {
 		err = -ENOTCONN;
-		if (sk->sk_type == SOCK_STREAM)
+		if (sock_type_connectible(sk->sk_type))
 			return err;
 	} else {
 		sock->state = SS_DISCONNECTING;
@@ -960,7 +974,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
 		sk->sk_state_change(sk);
 		release_sock(sk);
 
-		if (sk->sk_type == SOCK_STREAM) {
+		if (sock_type_connectible(sk->sk_type)) {
 			sock_reset_flag(sk, SOCK_DONE);
 			vsock_send_shutdown(sk, mode);
 		}
@@ -1013,7 +1027,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
-	} else if (sock->type == SOCK_STREAM) {
+	} else if (sock_type_connectible(sk->sk_type)) {
 		const struct vsock_transport *transport = vsk->transport;
 		lock_sock(sk);
 
@@ -1259,8 +1273,8 @@ static void vsock_connect_timeout(struct work_struct *work)
 	sock_put(sk);
 }
 
-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
-				int addr_len, int flags)
+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
+			 int addr_len, int flags)
 {
 	int err;
 	struct sock *sk;
@@ -1410,7 +1424,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	lock_sock(listener);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sock->type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1477,6 +1491,18 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 	return err;
 }
 
+static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
+				int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
+static int vsock_seqpacket_connect(struct socket *sock, struct sockaddr *addr,
+				   int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
 static int vsock_listen(struct socket *sock, int backlog)
 {
 	int err;
@@ -1487,7 +1513,7 @@ static int vsock_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sk->sk_type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1531,11 +1557,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
 	vsk->buffer_size = val;
 }
 
-static int vsock_stream_setsockopt(struct socket *sock,
-				   int level,
-				   int optname,
-				   sockptr_t optval,
-				   unsigned int optlen)
+static int vsock_setsockopt(struct socket *sock,
+			    int level,
+			    int optname,
+			    sockptr_t optval,
+			    unsigned int optlen)
 {
 	int err;
 	struct sock *sk;
@@ -1612,6 +1638,24 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	return err;
 }
 
+static int vsock_seqpacket_setsockopt(struct socket *sock,
+				      int level,
+				      int optname,
+				      sockptr_t optval,
+				      unsigned int optlen)
+{
+	return vsock_setsockopt(sock, level, optname, optval, optlen);
+}
+
+static int vsock_stream_setsockopt(struct socket *sock,
+				   int level,
+				   int optname,
+				   sockptr_t optval,
+				   unsigned int optlen)
+{
+	return vsock_setsockopt(sock, level, optname, optval, optlen);
+}
+
 static int vsock_stream_getsockopt(struct socket *sock,
 				   int level, int optname,
 				   char __user *optval,
@@ -1683,6 +1727,14 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	return 0;
 }
 
+static int vsock_seqpacket_getsockopt(struct socket *sock,
+				      int level, int optname,
+				      char __user *optval,
+				      int __user *optlen)
+{
+	return vsock_stream_getsockopt(sock, level, optname, optval, optlen);
+}
+
 static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 				     size_t len)
 {
@@ -2184,6 +2236,27 @@ static const struct proto_ops vsock_stream_ops = {
 	.sendpage = sock_no_sendpage,
 };
 
+static const struct proto_ops vsock_seqpacket_ops = {
+	.family = PF_VSOCK,
+	.owner = THIS_MODULE,
+	.release = vsock_release,
+	.bind = vsock_bind,
+	.connect = vsock_seqpacket_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = vsock_accept,
+	.getname = vsock_getname,
+	.poll = vsock_poll,
+	.ioctl = sock_no_ioctl,
+	.listen = vsock_listen,
+	.shutdown = vsock_shutdown,
+	.setsockopt = vsock_seqpacket_setsockopt,
+	.getsockopt = vsock_seqpacket_getsockopt,
+	.sendmsg = vsock_seqpacket_sendmsg,
+	.recvmsg = vsock_seqpacket_recvmsg,
+	.mmap = sock_no_mmap,
+	.sendpage = sock_no_sendpage,
+};
+
 static int vsock_create(struct net *net, struct socket *sock,
 			int protocol, int kern)
 {
@@ -2204,6 +2277,9 @@ static int vsock_create(struct net *net, struct socket *sock,
 	case SOCK_STREAM:
 		sock->ops = &vsock_stream_ops;
 		break;
+	case SOCK_SEQPACKET:
+		sock->ops = &vsock_seqpacket_ops;
+		break;
 	default:
 		return -ESOCKTNOSUPPORT;
 	}
-- 
2.25.1


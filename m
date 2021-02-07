Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8B9312507
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBGPPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:15:35 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:12283 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhBGPPc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:15:32 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 9640675BDD;
        Sun,  7 Feb 2021 18:14:39 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710879;
        bh=+BJT0p4wLlF+uinBv9HlifTXu5xsC6yZ+ZgMGINHYY8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=WdiVOt3Ys60LtIoQ/wG1ssYMEH5AnuUUKl8Hm0yOOCXdko9cNpTryiKrq3rKCnNct
         NwQYTOk2PKcwIi2bXoegLEgdLvi+kUqLnvkQsNFk6K8o9/h4fPlbz+w8DilDOCGaM5
         m1ujqO1kMzS14K/eYT+8KLOcDzqAW9TiwEd3ZwCg=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id C323175BAB;
        Sun,  7 Feb 2021 18:14:38 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:14:38 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 01/17] af_vsock: update functions for connectible socket
Date:   Sun, 7 Feb 2021 18:14:23 +0300
Message-ID: <20210207151426.804348-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2021 9:17:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/07 14:21:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/07 10:49:00 #16133380
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prepares af_vsock.c for SEQPACKET support: some functions such
as setsockopt(), getsockopt(), connect(), recvmsg(), sendmsg() are
shared between both types of sockets, so rename them in general
manner.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 64 +++++++++++++++++++++-------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 6894f21dc147..f4fabec50650 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -604,8 +604,8 @@ static void vsock_pending_work(struct work_struct *work)
 
 /**** SOCKET OPERATIONS ****/
 
-static int __vsock_bind_stream(struct vsock_sock *vsk,
-			       struct sockaddr_vm *addr)
+static int __vsock_bind_connectible(struct vsock_sock *vsk,
+				    struct sockaddr_vm *addr)
 {
 	static u32 port;
 	struct sockaddr_vm new_addr;
@@ -685,7 +685,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 	switch (sk->sk_socket->type) {
 	case SOCK_STREAM:
 		spin_lock_bh(&vsock_table_lock);
-		retval = __vsock_bind_stream(vsk, addr);
+		retval = __vsock_bind_connectible(vsk, addr);
 		spin_unlock_bh(&vsock_table_lock);
 		break;
 
@@ -767,6 +767,11 @@ static struct sock *__vsock_create(struct net *net,
 	return sk;
 }
 
+static bool sock_type_connectible(u16 type)
+{
+	return type == SOCK_STREAM;
+}
+
 static void __vsock_release(struct sock *sk, int level)
 {
 	if (sk) {
@@ -785,7 +790,7 @@ static void __vsock_release(struct sock *sk, int level)
 
 		if (vsk->transport)
 			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
+		else if (sock_type_connectible(sk->sk_type))
 			vsock_remove_sock(vsk);
 
 		sock_orphan(sk);
@@ -945,7 +950,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
 	sk = sock->sk;
 	if (sock->state == SS_UNCONNECTED) {
 		err = -ENOTCONN;
-		if (sk->sk_type == SOCK_STREAM)
+		if (sock_type_connectible(sk->sk_type))
 			return err;
 	} else {
 		sock->state = SS_DISCONNECTING;
@@ -960,7 +965,7 @@ static int vsock_shutdown(struct socket *sock, int mode)
 		sk->sk_state_change(sk);
 		release_sock(sk);
 
-		if (sk->sk_type == SOCK_STREAM) {
+		if (sock_type_connectible(sk->sk_type)) {
 			sock_reset_flag(sk, SOCK_DONE);
 			vsock_send_shutdown(sk, mode);
 		}
@@ -1013,7 +1018,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 		if (!(sk->sk_shutdown & SEND_SHUTDOWN))
 			mask |= EPOLLOUT | EPOLLWRNORM | EPOLLWRBAND;
 
-	} else if (sock->type == SOCK_STREAM) {
+	} else if (sock_type_connectible(sk->sk_type)) {
 		const struct vsock_transport *transport;
 
 		lock_sock(sk);
@@ -1263,8 +1268,8 @@ static void vsock_connect_timeout(struct work_struct *work)
 	sock_put(sk);
 }
 
-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
-				int addr_len, int flags)
+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
+			 int addr_len, int flags)
 {
 	int err;
 	struct sock *sk;
@@ -1414,7 +1419,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	lock_sock(listener);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sock->type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1491,7 +1496,7 @@ static int vsock_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sk->sk_type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1535,11 +1540,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
 	vsk->buffer_size = val;
 }
 
-static int vsock_stream_setsockopt(struct socket *sock,
-				   int level,
-				   int optname,
-				   sockptr_t optval,
-				   unsigned int optlen)
+static int vsock_connectible_setsockopt(struct socket *sock,
+					int level,
+					int optname,
+					sockptr_t optval,
+					unsigned int optlen)
 {
 	int err;
 	struct sock *sk;
@@ -1617,10 +1622,10 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	return err;
 }
 
-static int vsock_stream_getsockopt(struct socket *sock,
-				   int level, int optname,
-				   char __user *optval,
-				   int __user *optlen)
+static int vsock_connectible_getsockopt(struct socket *sock,
+					int level, int optname,
+					char __user *optval,
+					int __user *optlen)
 {
 	int err;
 	int len;
@@ -1688,8 +1693,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	return 0;
 }
 
-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-				size_t len)
+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1828,10 +1833,9 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
-
 static int
-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-		     int flags)
+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			  int flags)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -2007,7 +2011,7 @@ static const struct proto_ops vsock_stream_ops = {
 	.owner = THIS_MODULE,
 	.release = vsock_release,
 	.bind = vsock_bind,
-	.connect = vsock_stream_connect,
+	.connect = vsock_connect,
 	.socketpair = sock_no_socketpair,
 	.accept = vsock_accept,
 	.getname = vsock_getname,
@@ -2015,10 +2019,10 @@ static const struct proto_ops vsock_stream_ops = {
 	.ioctl = sock_no_ioctl,
 	.listen = vsock_listen,
 	.shutdown = vsock_shutdown,
-	.setsockopt = vsock_stream_setsockopt,
-	.getsockopt = vsock_stream_getsockopt,
-	.sendmsg = vsock_stream_sendmsg,
-	.recvmsg = vsock_stream_recvmsg,
+	.setsockopt = vsock_connectible_setsockopt,
+	.getsockopt = vsock_connectible_getsockopt,
+	.sendmsg = vsock_connectible_sendmsg,
+	.recvmsg = vsock_connectible_recvmsg,
 	.mmap = sock_no_mmap,
 	.sendpage = sock_no_sendpage,
 };
-- 
2.25.1


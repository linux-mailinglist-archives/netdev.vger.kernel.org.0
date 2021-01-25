Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77DEF3025A0
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 14:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729007AbhAYNlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 08:41:49 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44558 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728977AbhAYNkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:40:08 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 46E3952171C;
        Mon, 25 Jan 2021 14:11:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573100;
        bh=ao3eKpBX8J/+L1k22rFVyfAW0g5AkKguMub/PXUW4VE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=HyoX4+pGBD3+g3jml4yw9Mi12TfCCaqdqtgtJjZQFe7jWKpU+mh6e8l7LTXFcRsel
         Rx8qf/cdw7lYbO7UCX5FxNQr2+V8jr3VFs8vftb+Tglg7L/1Fe71dUC3i4/ENzZRVz
         bTnsNeB1ibQQ5G633AvU1O8G0rCTXz5Fmp+n3eJM=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id E42EC52170B;
        Mon, 25 Jan 2021 14:11:39 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:11:39 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v3 01/13] af_vsock: prepare for SOCK_SEQPACKET support
Date:   Mon, 25 Jan 2021 14:11:28 +0300
Message-ID: <20210125111131.597930-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/25/2021 10:59:54
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161363 [Jan 25 2021]
X-KSE-AntiSpam-Info: LuaCore: 421 421 33a18ad4049b4a5e5420c907b38d332fafd06b09
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/25/2021 11:02:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 1/25/2021 10:11:00 AM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/25 10:04:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/25 05:31:00 #16022694
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prepares af_vsock.c for SEQPACKET support:
1) As both stream and seqpacket sockets are connection oriented, add
   check for SOCK_SEQPACKET to conditions where SOCK_STREAM is checked.
2) Some functions such as setsockopt(), getsockopt(), connect(),
   recvmsg(), sendmsg() are shared between both types of sockets, so
   rename them in general manner and create entry points for each type
   of socket to call these functions(for stream in this patch, for
   seqpacket in further patches).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 91 +++++++++++++++++++++++++++++-----------
 1 file changed, 67 insertions(+), 24 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b12d3a322242..c9ce57db9554 100644
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
+	return (type == SOCK_STREAM || type == SOCK_SEQPACKET);
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
 		const struct vsock_transport *transport = vsk->transport;
 		lock_sock(sk);
 
@@ -1259,8 +1264,8 @@ static void vsock_connect_timeout(struct work_struct *work)
 	sock_put(sk);
 }
 
-static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
-				int addr_len, int flags)
+static int vsock_connect(struct socket *sock, struct sockaddr *addr,
+			 int addr_len, int flags)
 {
 	int err;
 	struct sock *sk;
@@ -1395,6 +1400,12 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 	return err;
 }
 
+static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
+				int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
 static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 			bool kern)
 {
@@ -1410,7 +1421,7 @@ static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	lock_sock(listener);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sock->type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1487,7 +1498,7 @@ static int vsock_listen(struct socket *sock, int backlog)
 
 	lock_sock(sk);
 
-	if (sock->type != SOCK_STREAM) {
+	if (!sock_type_connectible(sk->sk_type)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -1531,11 +1542,11 @@ static void vsock_update_buffer_size(struct vsock_sock *vsk,
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
@@ -1612,10 +1623,20 @@ static int vsock_stream_setsockopt(struct socket *sock,
 	return err;
 }
 
-static int vsock_stream_getsockopt(struct socket *sock,
-				   int level, int optname,
-				   char __user *optval,
-				   int __user *optlen)
+static int vsock_stream_setsockopt(struct socket *sock,
+				   int level,
+				   int optname,
+				   sockptr_t optval,
+				   unsigned int optlen)
+{
+	return vsock_connectible_setsockopt(sock, level, optname, optval,
+					    optlen);
+}
+
+static int vsock_connectible_getsockopt(struct socket *sock,
+					int level, int optname,
+					char __user *optval,
+					int __user *optlen)
 {
 	int err;
 	int len;
@@ -1683,8 +1704,17 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	return 0;
 }
 
-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-				size_t len)
+static int vsock_stream_getsockopt(struct socket *sock,
+				   int level, int optname,
+				   char __user *optval,
+				   int __user *optlen)
+{
+	return vsock_connectible_getsockopt(sock, level, optname, optval,
+					    optlen);
+}
+
+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1822,10 +1852,16 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
+				size_t len)
+{
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
+
 
 static int
-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-		     int flags)
+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			  int flags)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1995,6 +2031,13 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return err;
 }
 
+static int
+vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+		     int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
 static const struct proto_ops vsock_stream_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
-- 
2.25.1


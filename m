Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 022E53033FC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728265AbhAZFLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:11:06 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:42230 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728953AbhAYNez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:34:55 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id B7AF952170B;
        Mon, 25 Jan 2021 14:13:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573213;
        bh=qNILJ6yQ/GHfTfHXyXIT4ckYgSbNRSzrC0vF2/kDqlU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=GCz2JyA13zaZ3pQEN4KHsYjadhUtYzL64RThmkVTjwf0MjaBmVYqbBe4PxMW7Tam3
         Gyd4taKnovyyTi9PKqYzxGzSqsuqMLAK6RKxqJDjGbiI/Abz7+7YgmSsuwQAKiT+QY
         cebSeCclXxt3uy/TIZQ1bpoLjGhu2e/8xQjOp5uI=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 57CED52173D;
        Mon, 25 Jan 2021 14:13:33 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:13:32 +0300
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
Subject: [RFC PATCH v3 05/13] af_vsock: rest of SEQPACKET support
Date:   Mon, 25 Jan 2021 14:13:18 +0300
Message-ID: <20210125111321.598653-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
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
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
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

This does rest of SOCK_SEQPACKET support:
1) Adds socket ops for SEQPACKET type.
2) Allows to create socket with SEQPACKET type.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 71 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4600c1ec3bb3..bbc3c31085aa 100644
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
@@ -684,6 +692,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 
 	switch (sk->sk_socket->type) {
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		spin_lock_bh(&vsock_table_lock);
 		retval = __vsock_bind_connectible(vsk, addr);
 		spin_unlock_bh(&vsock_table_lock);
@@ -1406,6 +1415,12 @@ static int vsock_stream_connect(struct socket *sock, struct sockaddr *addr,
 	return vsock_connect(sock, addr, addr_len, flags);
 }
 
+static int vsock_seqpacket_connect(struct socket *sock, struct sockaddr *addr,
+				   int addr_len, int flags)
+{
+	return vsock_connect(sock, addr, addr_len, flags);
+}
+
 static int vsock_accept(struct socket *sock, struct socket *newsock, int flags,
 			bool kern)
 {
@@ -1633,6 +1648,16 @@ static int vsock_stream_setsockopt(struct socket *sock,
 					    optlen);
 }
 
+static int vsock_seqpacket_setsockopt(struct socket *sock,
+				      int level,
+				      int optname,
+				      sockptr_t optval,
+				      unsigned int optlen)
+{
+	return vsock_connectible_setsockopt(sock, level, optname, optval,
+					    optlen);
+}
+
 static int vsock_connectible_getsockopt(struct socket *sock,
 					int level, int optname,
 					char __user *optval,
@@ -1713,6 +1738,15 @@ static int vsock_stream_getsockopt(struct socket *sock,
 					    optlen);
 }
 
+static int vsock_seqpacket_getsockopt(struct socket *sock,
+				      int level, int optname,
+				      char __user *optval,
+				      int __user *optlen)
+{
+	return vsock_connectible_getsockopt(sock, level, optname, optval,
+					    optlen);
+}
+
 static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 				     size_t len)
 {
@@ -1870,6 +1904,12 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	return vsock_connectible_sendmsg(sock, msg, len);
 }
 
+static int vsock_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
+				   size_t len)
+{
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
+
 static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 			   long timeout,
 			   struct vsock_transport_recv_notify_data *recv_data,
@@ -2184,6 +2224,13 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return vsock_connectible_recvmsg(sock, msg, len, flags);
 }
 
+static int
+vsock_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
 static const struct proto_ops vsock_stream_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
@@ -2205,6 +2252,27 @@ static const struct proto_ops vsock_stream_ops = {
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
@@ -2225,6 +2293,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


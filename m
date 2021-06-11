Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0883A40EA
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhFKLN3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:13:29 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:14588 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhFKLNT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:13:19 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id E431D520CC8;
        Fri, 11 Jun 2021 14:11:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409874;
        bh=KZRi8NeUL8qomkR50i5IZrg6OHwatw47A6tBHBWijZE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=QOmwiWNPrhbAFCRSD32OCjq+rW5ovtShiE+75/TvkujkdG0V8OQ8E9z/nThlp/Ugk
         YVqjT2A7z0yMapMTpAksgXCOoY02mZ6Czu6hUVo53o7kgWWrY2nRevEuk1aMSplkZa
         DArdN3DGCQhx8vg6BN0mgjOEjPjcSsLI+62DXIPUkWhV0FxomCEtJsB6XS32N70p0y
         R3w9DI4f2arLTtmnHIw6sYLcZ1WVUbUYBVKNBp1MmOO0u4JnPOuqSRnPNcAfwAcnnx
         gzbQBFnM/jQtuf37unz3rogLPvnx+UX94/Q/gJGwz3HySJ88KGvC2iJaRdjkxkOOms
         9Hj6iAMEcFYUw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 976A0520CA6;
        Fri, 11 Jun 2021 14:11:13 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:11:12 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 06/18] af_vsock: rest of SEQPACKET support
Date:   Fri, 11 Jun 2021 14:11:04 +0300
Message-ID: <20210611111107.3651634-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add socket ops for SEQPACKET type and .seqpacket_allow() callback
to query transports if they support SEQPACKET. Also split path
for data check for STREAM and SEQPACKET branches.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) 'vsock_has_data()' function added.
 2) Commit message updated.

 include/net/af_vsock.h   |  2 ++
 net/vmw_vsock/af_vsock.c | 48 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index d6745d8b8f3e..ab207677e0a8 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -140,6 +140,8 @@ struct vsock_transport {
 				     int flags);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
+	bool (*seqpacket_allow)(u32 remote_cid);
+	u32 (*seqpacket_has_data)(struct vsock_sock *vsk);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9e0cc07e3caf..21a56f52d683 100644
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
@@ -484,6 +485,14 @@ int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk)
 	if (!new_transport || !try_module_get(new_transport->module))
 		return -ENODEV;
 
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		if (!new_transport->seqpacket_allow ||
+		    !new_transport->seqpacket_allow(remote_cid)) {
+			module_put(new_transport->module);
+			return -ESOCKTNOSUPPORT;
+		}
+	}
+
 	ret = new_transport->init(vsk, psk);
 	if (ret) {
 		module_put(new_transport->module);
@@ -684,6 +693,7 @@ static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr)
 
 	switch (sk->sk_socket->type) {
 	case SOCK_STREAM:
+	case SOCK_SEQPACKET:
 		spin_lock_bh(&vsock_table_lock);
 		retval = __vsock_bind_connectible(vsk, addr);
 		spin_unlock_bh(&vsock_table_lock);
@@ -770,7 +780,7 @@ static struct sock *__vsock_create(struct net *net,
 
 static bool sock_type_connectible(u16 type)
 {
-	return type == SOCK_STREAM;
+	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
 }
 
 static void __vsock_release(struct sock *sk, int level)
@@ -849,6 +859,16 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
 }
 EXPORT_SYMBOL_GPL(vsock_stream_has_data);
 
+static s64 vsock_has_data(struct vsock_sock *vsk)
+{
+	struct sock *sk = sk_vsock(vsk);
+
+	if (sk->sk_type == SOCK_SEQPACKET)
+		return vsk->transport->seqpacket_has_data(vsk);
+	else
+		return vsock_stream_has_data(vsk);
+}
+
 s64 vsock_stream_has_space(struct vsock_sock *vsk)
 {
 	return vsk->transport->stream_has_space(vsk);
@@ -1857,7 +1877,7 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_stream_has_data(vsk)) == 0) {
+	while ((data = vsock_has_data(vsk)) == 0) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
 
 		if (sk->sk_err != 0 ||
@@ -2120,6 +2140,27 @@ static const struct proto_ops vsock_stream_ops = {
 	.sendpage = sock_no_sendpage,
 };
 
+static const struct proto_ops vsock_seqpacket_ops = {
+	.family = PF_VSOCK,
+	.owner = THIS_MODULE,
+	.release = vsock_release,
+	.bind = vsock_bind,
+	.connect = vsock_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = vsock_accept,
+	.getname = vsock_getname,
+	.poll = vsock_poll,
+	.ioctl = sock_no_ioctl,
+	.listen = vsock_listen,
+	.shutdown = vsock_shutdown,
+	.setsockopt = vsock_connectible_setsockopt,
+	.getsockopt = vsock_connectible_getsockopt,
+	.sendmsg = vsock_connectible_sendmsg,
+	.recvmsg = vsock_connectible_recvmsg,
+	.mmap = sock_no_mmap,
+	.sendpage = sock_no_sendpage,
+};
+
 static int vsock_create(struct net *net, struct socket *sock,
 			int protocol, int kern)
 {
@@ -2140,6 +2181,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


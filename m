Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E48345F18
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhCWNLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:11:49 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:47694 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhCWNLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:11:33 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id E1958521EE1;
        Tue, 23 Mar 2021 16:11:23 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505084;
        bh=ERm28xxzug3GBzayEYp1rd+2/Pjtq6tUtQNVqdx3d4c=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=2BY/qtZmJBWntH2pcPG3ed0tN6TDOSdDj6QDNQ2/nG3KBlGEvHW6dA2g7UQnzP/mQ
         m7dAtaqbwdcFgxcsLhHwIVaVWXxWSw7+AkNMjdtRaSQdsKVXZaQ5Ck+tvfm10Pj468
         Nyd2NImtRyiAzloXnCb2t04S0BrQgUtpRzb12fcqQIq/oIGh+u7B1rP8IpXmR8C46m
         zzPm50R7vduVXaDHQWBIk8dnWbeqfmJ3qU9EKNa3ffO3sdghvHxP2RfF5aKnttr6VO
         qFWCW5c6cWH4A7LGl/ZRPV6n6SDP30hyJjZfsukOWqrIW7Uyt6JIoRHQsWhoFU9e/i
         zOBBYHfhocukw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 70C13521EAF;
        Tue, 23 Mar 2021 16:11:23 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:11:22 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 07/22] af_vsock: rest of SEQPACKET support
Date:   Tue, 23 Mar 2021 16:11:05 +0300
Message-ID: <20210323131108.2460465-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/23/2021 12:55:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162595 [Mar 23 2021]
X-KSE-AntiSpam-Info: LuaCore: 437 437 85ecb8eec06a7bf2f475f889e784f42bce7b4445
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/23/2021 12:58:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2021 11:46:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/23 11:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/23 11:40:00 #16480199
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This does rest of SOCK_SEQPACKET support:
1) Adds socket ops for SEQPACKET type.
2) Allows to create socket with SEQPACKET type.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b7063820d0bc..6c88ba0df588 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -140,6 +140,7 @@ struct vsock_transport {
 				 int flags, bool *msg_ready, size_t *record_len);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
+	bool (*seqpacket_allow)(void);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index a98e5daa06b7..802afe253781 100644
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
+		    !new_transport->seqpacket_allow()) {
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
@@ -769,7 +779,7 @@ static struct sock *__vsock_create(struct net *net,
 
 static bool sock_type_connectible(u16 type)
 {
-	return type == SOCK_STREAM;
+	return (type == SOCK_STREAM) || (type == SOCK_SEQPACKET);
 }
 
 static void __vsock_release(struct sock *sk, int level)
@@ -2174,6 +2184,27 @@ static const struct proto_ops vsock_stream_ops = {
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
@@ -2194,6 +2225,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


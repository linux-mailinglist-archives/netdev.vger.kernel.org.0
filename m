Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB00330395
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 19:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbhCGSBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:01:18 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:50038 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232738AbhCGSBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:01:00 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id E2EA452138A;
        Sun,  7 Mar 2021 21:00:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615140058;
        bh=K12Wt9irZwAlbPDPZU/ya2oE1tHH6lzKPGiSOvisMqE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=mkPC3mHaoJbBalfjuBymfXbIkfk5U4oBwT/7j/RbgaqSPsDhlIuwUfNU7gzofU2aJ
         JTpv2anjZZ6jkvdSNmLLzRoS847n4f8QmzcMM7IGlTz3vHym+pbPYXvnTtXx3gyTBN
         iTnAoJ0S1Xi+mob92a64difYXi5vmIPfnvSzz7aPiw+IEx00FAt6JiHvFWX90zzrc2
         c/BvAMMNQcw6hdIFcVDgtJ2a4TJNYfBOScJUoD7S3T1AUoIjX3pOIuZov70Rdq5aba
         /tVLDa9bNAVUTdSUw2NhzZQ2le58d9YtETY2co1EafCkEGpLkB7y4I74+FINtyEkmx
         FRQDPOvVytFuQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 9EF685213B7;
        Sun,  7 Mar 2021 21:00:57 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 7 Mar
 2021 21:00:57 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v6 07/22] af_vsock: rest of SEQPACKET support
Date:   Sun, 7 Mar 2021 21:00:47 +0300
Message-ID: <20210307180050.3465297-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/07/2021 17:49:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162254 [Mar 07 2021]
X-KSE-AntiSpam-Info: LuaCore: 431 431 6af1f0c9661e70e28927a654c0fea10ff13ade05
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_MISSED}
X-KSE-AntiSpam-Info: {Macro_DATE_DOUBLE_SPACE}
X-KSE-AntiSpam-Info: {Macro_DATE_MOSCOW}
X-KSE-AntiSpam-Info: {Macro_FROM_DOUBLE_ENG_NAME}
X-KSE-AntiSpam-Info: {Macro_FROM_LOWCAPS_DOUBLE_ENG_NAME_IN_EMAIL}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RU}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RUS_CHARSET}
X-KSE-AntiSpam-Info: {Macro_FROM_REAL_NAME_MATCHES_ALL_USERNAME_PROB}
X-KSE-AntiSpam-Info: {Macro_HEADERS_NOT_LIST}
X-KSE-AntiSpam-Info: {Macro_MAILER_OTHER}
X-KSE-AntiSpam-Info: {Macro_MISC_X_PRIORITY_MISSED}
X-KSE-AntiSpam-Info: {Macro_NO_DKIM}
X-KSE-AntiSpam-Info: {Macro_REPLY_TO_MISSED}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_AT_LEAST_2_WORDS}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_LONG_TEXT}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_5_EMAILS}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_SEVERAL_EMAILS}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/07/2021 17:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 07.03.2021 15:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/07 17:11:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/07 15:50:00 #16360637
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This does rest of SOCK_SEQPACKET support:
1) Adds socket ops for SEQPACKET type.
2) Allows to create socket with SEQPACKET type.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |  1 +
 net/vmw_vsock/af_vsock.c | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index aed306292ab3..ee16744ed4a8 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -141,6 +141,7 @@ struct vsock_transport {
 				 int flags, bool *msg_ready);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 int flags, size_t len);
+	bool (*seqpacket_allow)(void);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index a031f165494d..673eb0de79fe 100644
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
@@ -2182,6 +2192,27 @@ static const struct proto_ops vsock_stream_ops = {
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
@@ -2202,6 +2233,9 @@ static int vsock_create(struct net *net, struct socket *sock,
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


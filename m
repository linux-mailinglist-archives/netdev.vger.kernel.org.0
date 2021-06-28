Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F0E3B5C05
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhF1KGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:06:09 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:21234 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhF1KGF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:06:05 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 20D8975B70;
        Mon, 28 Jun 2021 13:03:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874618;
        bh=ftVlHUQVi6Hz3lGl9ZJhrGsPguZLGSjfejDA2sUFwxE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=ToiZzfh38MkFb2NPzyjZYhRTJGxKvJGBaXK6hc1S0hBLL7tdeHdCXNFotBk257fdA
         NPwePOVvUiRw4rZQaIj2ce+pOE9wFlPytlbmOyXtV1TjfR4FHUjZgMy0XDhU6Zjuh4
         XgavYu4cnJTDDm1UDjVe7qTQ4lnPa0HUPYLY04syWcaEnCOEDsyD68pjY6SUSMoqqS
         Nbz+rOGVxbKLW4duHoZz4DlwfUK5VYaikwamJq0ImWy29cWRH3kDON7QC8hVc9bYK0
         X4MH8y0ZLSzqzuVjxwOA9GU6joF08F7cudN1e7Lf18tPMLxVzuGSZGSUQL8n+REZ0y
         jGmwsRE4l+0mA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id DA63875B6D;
        Mon, 28 Jun 2021 13:03:37 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:03:37 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 08/16] af_vsock: change SEQPACKET receive loop
Date:   Mon, 28 Jun 2021 13:03:28 +0300
Message-ID: <20210628100331.571056-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Receive "loop" now really loop: it reads fragments one by
one, sleeping if queue is empty.

NOTE: 'msg_ready' pointer is not passed to 'seqpacket_dequeue()'
here - it change callback interface, so it is moved to next patch.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 59ce35da2e5b..9552f05119f2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2003,6 +2003,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 				     size_t len, int flags)
 {
 	const struct vsock_transport *transport;
+	bool msg_ready;
 	struct vsock_sock *vsk;
 	ssize_t record_len;
 	long timeout;
@@ -2013,23 +2014,36 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	transport = vsk->transport;
 
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	msg_ready = false;
+	record_len = 0;
 
-	err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
-	if (err <= 0)
-		goto out;
+	while (!msg_ready) {
+		ssize_t fragment_len;
+		int intr_err;
 
-	record_len = transport->seqpacket_dequeue(vsk, msg, flags);
+		intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
+		if (intr_err <= 0) {
+			err = intr_err;
+			break;
+		}
 
-	if (record_len < 0) {
-		err = -ENOMEM;
-		goto out;
+		fragment_len = transport->seqpacket_dequeue(vsk, msg, flags);
+
+		if (fragment_len < 0) {
+			err = -ENOMEM;
+			break;
+		}
+
+		record_len += fragment_len;
 	}
 
 	if (sk->sk_err) {
 		err = -sk->sk_err;
 	} else if (sk->sk_shutdown & RCV_SHUTDOWN) {
 		err = 0;
-	} else {
+	}
+
+	if (msg_ready && !err) {
 		/* User sets MSG_TRUNC, so return real length of
 		 * packet.
 		 */
@@ -2045,7 +2059,6 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 			msg->msg_flags |= MSG_TRUNC;
 	}
 
-out:
 	return err;
 }
 
-- 
2.25.1


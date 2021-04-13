Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5866F35DF1F
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhDMMov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:44:51 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:18235 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242445AbhDMMnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:43:15 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id A20AE521A85;
        Tue, 13 Apr 2021 15:42:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618317762;
        bh=UrJco2MX5gJREUQRQYvLaOVSQCpOr2kWGo6mlfrz5Qg=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=qD9Y5fXCmjst4h3lXhAbudL5YiDePljKF2oREdh8UynH8tdXVRmNTANsFx5mRrJye
         UCDzRSELOaFMQ7FAUevuPVC4AIT878sW/CZ7qKDRzq0t90cwJo6HzsRiwR4AeWh1hZ
         NXdrLS1LqQAxrv19UUU1Z2IX1bzKhAHFHEh+L+OH/zGE1A/qs9h5OLe+WGZh2vfkQf
         Al/vEMdamPPDeEr8Ny/lAK9vmJ8erPMGEMFycmpPsJmJ3IzM27p/iOTmTnbblh4TrN
         FqSv2dRgpZ6eKfrODNGaOZ/4ERPECoEFx9CxW1QFEmDpYJCR2WH4IfMkAPkTaLQyI/
         v02zEohjn8uAQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 635E8521A9B;
        Tue, 13 Apr 2021 15:42:42 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:42:41 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 03/19] af_vsock: separate receive data loop
Date:   Tue, 13 Apr 2021 15:42:34 +0300
Message-ID: <20210413124237.3399645-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:26:17
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:28:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.04.2021 10:53:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 03:14:00 #16587160
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move STREAM specific data receive logic to '__vsock_stream_recvmsg()'
dedicated function, while checks, that will be same for both STREAM
and SEQPACKET sockets, stays in 'vsock_connectible_recvmsg()' shared
functions.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 116 ++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 49 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index ba5ec37a4e12..c4f6bfa1e381 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1896,65 +1896,22 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 	return data;
 }
 
-static int
-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-			  int flags)
+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int flags)
 {
-	struct sock *sk;
-	struct vsock_sock *vsk;
+	struct vsock_transport_recv_notify_data recv_data;
 	const struct vsock_transport *transport;
-	int err;
-	size_t target;
+	struct vsock_sock *vsk;
 	ssize_t copied;
+	size_t target;
 	long timeout;
-	struct vsock_transport_recv_notify_data recv_data;
+	int err;
 
 	DEFINE_WAIT(wait);
 
-	sk = sock->sk;
 	vsk = vsock_sk(sk);
-	err = 0;
-
-	lock_sock(sk);
-
 	transport = vsk->transport;
 
-	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
-		/* Recvmsg is supposed to return 0 if a peer performs an
-		 * orderly shutdown. Differentiate between that case and when a
-		 * peer has not connected or a local shutdown occured with the
-		 * SOCK_DONE flag.
-		 */
-		if (sock_flag(sk, SOCK_DONE))
-			err = 0;
-		else
-			err = -ENOTCONN;
-
-		goto out;
-	}
-
-	if (flags & MSG_OOB) {
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* We don't check peer_shutdown flag here since peer may actually shut
-	 * down, but there can be data in the queue that a local socket can
-	 * receive.
-	 */
-	if (sk->sk_shutdown & RCV_SHUTDOWN) {
-		err = 0;
-		goto out;
-	}
-
-	/* It is valid on Linux to pass in a zero-length receive buffer.  This
-	 * is not an error.  We may as well bail out now.
-	 */
-	if (!len) {
-		err = 0;
-		goto out;
-	}
-
 	/* We must not copy less than target bytes into the user's buffer
 	 * before returning successfully, so we wait for the consume queue to
 	 * have that much data to consume before dequeueing.  Note that this
@@ -2013,6 +1970,67 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (copied > 0)
 		err = copied;
 
+out:
+	return err;
+}
+
+static int
+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			  int flags)
+{
+	struct sock *sk;
+	struct vsock_sock *vsk;
+	const struct vsock_transport *transport;
+	int err;
+
+	DEFINE_WAIT(wait);
+
+	sk = sock->sk;
+	vsk = vsock_sk(sk);
+	err = 0;
+
+	lock_sock(sk);
+
+	transport = vsk->transport;
+
+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
+		/* Recvmsg is supposed to return 0 if a peer performs an
+		 * orderly shutdown. Differentiate between that case and when a
+		 * peer has not connected or a local shutdown occurred with the
+		 * SOCK_DONE flag.
+		 */
+		if (sock_flag(sk, SOCK_DONE))
+			err = 0;
+		else
+			err = -ENOTCONN;
+
+		goto out;
+	}
+
+	if (flags & MSG_OOB) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	/* We don't check peer_shutdown flag here since peer may actually shut
+	 * down, but there can be data in the queue that a local socket can
+	 * receive.
+	 */
+	if (sk->sk_shutdown & RCV_SHUTDOWN) {
+		err = 0;
+		goto out;
+	}
+
+	/* It is valid on Linux to pass in a zero-length receive buffer.  This
+	 * is not an error.  We may as well bail out now.
+	 */
+	if (!len) {
+		err = 0;
+		goto out;
+	}
+
+	err = __vsock_stream_recvmsg(sk, msg, len, flags);
+
 out:
 	release_sock(sk);
 	return err;
-- 
2.25.1


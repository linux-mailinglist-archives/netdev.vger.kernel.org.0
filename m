Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6284231250F
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:17:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhBGPQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:16:22 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:12487 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhBGPQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:16:11 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id A255A75FDC;
        Sun,  7 Feb 2021 18:15:15 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710915;
        bh=13R8Wn2qM11ST7Naw+OjjFcv5i8UtT1KZpVfi7pHgvI=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=jzOysr2n6RCHND1So/MLMGMfZFC9ip1JWvOcdePh4rH+OdYTxMOJG1EHjs6dv4zRh
         z6MCw2xehNuCS6TDtp9rKJlClKlA3nqknJKVzcMOuJmV1kx7OhhGpMBXZ23vLUp9vO
         819EAGxbiSwzrChZ4zS6BLyBUrlkbNwMUlWUJEfU=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 6D81375FD4;
        Sun,  7 Feb 2021 18:15:15 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:15:14 +0300
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
Subject: [RFC PATCH v4 03/17] af_vsock: separate receive data loop
Date:   Sun, 7 Feb 2021 18:15:05 +0300
Message-ID: <20210207151508.804615-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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

This moves STREAM specific data receive logic to dedicated function:
'__vsock_stream_recvmsg()', while checks that will be same for both
types of socket are in shared function: 'vsock_connectible_recvmsg()'.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 117 +++++++++++++++++++++++----------------
 1 file changed, 68 insertions(+), 49 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 38927695786f..66c8a932f49b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1898,65 +1898,22 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 	return err;
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
@@ -2020,6 +1977,68 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return err;
 }
 
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
+out:
+	release_sock(sk);
+	return err;
+}
+
 static const struct proto_ops vsock_stream_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1931130247E
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 12:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbhAYLtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 06:49:41 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:36288 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727830AbhAYLrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 06:47:10 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 317C152170D;
        Mon, 25 Jan 2021 14:12:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573127;
        bh=PQvxSXikVxKrVvCVMuElHDDXYoRL/SJwgxpXVZlaTv4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=J0l4ZiKz2VgdK3yjznbepmRpPcf6NdweTVPUbzSW690fZ6WdY4zh1Iem9uRBJwB2b
         PAqNHShidV+0h1UoLQ4hUeZxLoMhoEyMox4OJaUq5SfEanvijsgAz833M3pYMUW7pf
         NJuKXLs2QRbisd3RQxSsZWZM5jz+bypphN04a5XI=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id D3FD7521738;
        Mon, 25 Jan 2021 14:12:06 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:12:06 +0300
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
Subject: [RFC PATCH v3 02/13] af_vsock: prepare 'vsock_connectible_recvmsg()'
Date:   Mon, 25 Jan 2021 14:11:57 +0300
Message-ID: <20210125111200.598103-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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

This prepares 'vsock_connectible_recvmg()' to call SEQPACKET receive
loop:
1) Some shared check left in this function, then socket type
   specific receive loop is called.
2) Stream receive loop is moved to separate function.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 242 ++++++++++++++++++++++-----------------
 1 file changed, 138 insertions(+), 104 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c9ce57db9554..524df8fc84cd 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1858,65 +1858,69 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	return vsock_connectible_sendmsg(sock, msg, len);
 }
 
-
-static int
-vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-			  int flags)
+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
+			   long timeout,
+			   struct vsock_transport_recv_notify_data *recv_data,
+			   size_t target)
 {
-	struct sock *sk;
+	int err = 0;
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
-	int err;
-	size_t target;
-	ssize_t copied;
-	long timeout;
-	struct vsock_transport_recv_notify_data recv_data;
-
-	DEFINE_WAIT(wait);
 
-	sk = sock->sk;
 	vsk = vsock_sk(sk);
 	transport = vsk->transport;
-	err = 0;
-
-	lock_sock(sk);
-
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
 
+	if (sk->sk_err != 0 ||
+	    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+	    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+		err = -1;
 		goto out;
 	}
-
-	if (flags & MSG_OOB) {
-		err = -EOPNOTSUPP;
+	/* Don't wait for non-blocking sockets. */
+	if (timeout == 0) {
+		err = -EAGAIN;
 		goto out;
 	}
 
-	/* We don't check peer_shutdown flag here since peer may actually shut
-	 * down, but there can be data in the queue that a local socket can
-	 * receive.
-	 */
-	if (sk->sk_shutdown & RCV_SHUTDOWN) {
-		err = 0;
-		goto out;
+	if (recv_data) {
+		err = transport->notify_recv_pre_block(vsk, target, recv_data);
+		if (err < 0)
+			goto out;
 	}
 
-	/* It is valid on Linux to pass in a zero-length receive buffer.  This
-	 * is not an error.  We may as well bail out now.
-	 */
-	if (!len) {
-		err = 0;
+	release_sock(sk);
+	timeout = schedule_timeout(timeout);
+	lock_sock(sk);
+
+	if (signal_pending(current)) {
+		err = sock_intr_errno(timeout);
+		goto out;
+	} else if (timeout == 0) {
+		err = -EAGAIN;
 		goto out;
 	}
 
+out:
+	finish_wait(sk_sleep(sk), wait);
+	return err;
+}
+
+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int flags)
+{
+	struct vsock_transport_recv_notify_data recv_data;
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	ssize_t copied;
+	size_t target;
+	long timeout;
+	int err;
+
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
 	/* We must not copy less than target bytes into the user's buffer
 	 * before returning successfully, so we wait for the consume queue to
 	 * have that much data to consume before dequeueing.  Note that this
@@ -1937,85 +1941,53 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 
 	while (1) {
+		ssize_t read;
 		s64 ready;
 
 		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
 		ready = vsock_stream_has_data(vsk);
 
 		if (ready == 0) {
-			if (sk->sk_err != 0 ||
-			    (sk->sk_shutdown & RCV_SHUTDOWN) ||
-			    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
-			/* Don't wait for non-blocking sockets. */
-			if (timeout == 0) {
-				err = -EAGAIN;
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
-
-			err = transport->notify_recv_pre_block(
-					vsk, target, &recv_data);
-			if (err < 0) {
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			}
-			release_sock(sk);
-			timeout = schedule_timeout(timeout);
-			lock_sock(sk);
-
-			if (signal_pending(current)) {
-				err = sock_intr_errno(timeout);
-				finish_wait(sk_sleep(sk), &wait);
-				break;
-			} else if (timeout == 0) {
-				err = -EAGAIN;
-				finish_wait(sk_sleep(sk), &wait);
+			if (vsock_wait_data(sk, &wait, timeout, &recv_data, target))
 				break;
-			}
-		} else {
-			ssize_t read;
+			continue;
+		}
 
-			finish_wait(sk_sleep(sk), &wait);
+		finish_wait(sk_sleep(sk), &wait);
 
-			if (ready < 0) {
-				/* Invalid queue pair content. XXX This should
-				* be changed to a connection reset in a later
-				* change.
-				*/
+		if (ready < 0) {
+			/* Invalid queue pair content. XXX This should
+			 * be changed to a connection reset in a later
+			 * change.
+			 */
 
-				err = -ENOMEM;
-				goto out;
-			}
+			err = -ENOMEM;
+			goto out;
+		}
 
-			err = transport->notify_recv_pre_dequeue(
-					vsk, target, &recv_data);
-			if (err < 0)
-				break;
+		err = transport->notify_recv_pre_dequeue(vsk,
+					target, &recv_data);
+		if (err < 0)
+			break;
+		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
 
-			read = transport->stream_dequeue(
-					vsk, msg,
-					len - copied, flags);
-			if (read < 0) {
-				err = -ENOMEM;
-				break;
-			}
+		if (read < 0) {
+			err = -ENOMEM;
+			break;
+		}
 
-			copied += read;
+		copied += read;
 
-			err = transport->notify_recv_post_dequeue(
-					vsk, target, read,
+		err = transport->notify_recv_post_dequeue(vsk,
+					target, read,
 					!(flags & MSG_PEEK), &recv_data);
-			if (err < 0)
-				goto out;
+		if (err < 0)
+			goto out;
 
-			if (read >= target || flags & MSG_PEEK)
-				break;
+		if (read >= target || flags & MSG_PEEK)
+			break;
 
-			target -= read;
-		}
+		target -= read;
 	}
 
 	if (sk->sk_err)
@@ -2031,6 +2003,68 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	return err;
 }
 
+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	return -1;
+}
+
+static int
+vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
+			  int flags)
+{
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	struct sock *sk;
+	int err = 0;
+
+	sk = sock->sk;
+
+	lock_sock(sk);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
+	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
+		/* Recvmsg is supposed to return 0 if a peer performs an
+		 * orderly shutdown. Differentiate between that case and when a
+		 * peer has not connected or a local shutdown occurred with the
+		 * SOCK_DONE flag.
+		 */
+		if (!sock_flag(sk, SOCK_DONE))
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
+	if (sk->sk_shutdown & RCV_SHUTDOWN)
+		goto out;
+
+	/* It is valid on Linux to pass in a zero-length receive buffer.  This
+	 * is not an error.  We may as well bail out now.
+	 */
+	if (!len)
+		goto out;
+
+	if (sk->sk_type == SOCK_STREAM)
+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	else
+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
+
+out:
+	release_sock(sk);
+	return err;
+}
+
 static int
 vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		     int flags)
-- 
2.25.1


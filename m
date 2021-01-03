Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45AF2E8E01
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 21:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbhACUEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 15:04:43 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:24358 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbhACUEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jan 2021 15:04:43 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 75AD77813C;
        Sun,  3 Jan 2021 23:03:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1609704236;
        bh=bOTJcnJ7qA+9DufkNlo8OkthGVS2Rr1GE8CTfizT21U=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=cBxQGOtRJFqOvvJCpnVd4xQsBrOaSEc87JsS0aWVSMUJJZj2PY9XFuchdpY2M1GfR
         use066u9v0s5XFIiNJh2L+0LyuZeNs4xg+Y5fKHG06ZC7yTndr07TBowOnQ2hljA3V
         iioIldRZldyUWMNl1MaId7tby8egEjPFIi7Ayeck=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 4F74A7813E;
        Sun,  3 Jan 2021 23:03:55 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 3 Jan
 2021 23:03:54 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Colin Ian King <colin.king@canonical.com>,
        Arseniy Krasnov <oxffffaa@gmail.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>
Subject: [PATCH 3/5] af_vsock: send/receive loops for SOCK_SEQPACKET.
Date:   Sun, 3 Jan 2021 23:03:45 +0300
Message-ID: <20210103200347.1956354-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
References: <20210103195454.1954169-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/03/2021 19:48:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 160977 [Jan 03 2021]
X-KSE-AntiSpam-Info: LuaCore: 419 419 70b0c720f8ddd656e5f4eb4a4449cf8ce400df94
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, dbl_space}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/03/2021 19:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.01.2021 18:13:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/03 18:58:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/03 18:13:00 #16005632
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arseniy Krasnov <oxffffaa@gmail.com>

  For send, this patch adds:
  1) Send of record begin marker with record length.
  2) Return error if send of whole record is failed.

  For receive, this patch adds another loop, it looks like
  stream loop, but:
  1) It doesn't call notify callbacks.
  2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT'
     values.
  3) It waits until whole record is received or error is
     found during receiving.
  3) It processes and sets 'MSG_TRUNC' flag.
---
 net/vmw_vsock/af_vsock.c | 319 +++++++++++++++++++++++++++++++--------
 1 file changed, 256 insertions(+), 63 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index b12d3a322242..7ff00449a9a2 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1683,8 +1683,8 @@ static int vsock_stream_getsockopt(struct socket *sock,
 	return 0;
 }
 
-static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
-				size_t len)
+static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len)
 {
 	struct sock *sk;
 	struct vsock_sock *vsk;
@@ -1737,6 +1737,12 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	if (err < 0)
 		goto out;
 
+	if (sk->sk_type == SOCK_SEQPACKET) {
+		err = transport->seqpacket_seq_send_len(vsk, len);
+		if (err < 0)
+			goto out;
+	}
+
 	while (total_written < len) {
 		ssize_t written;
 
@@ -1796,10 +1802,8 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 		 * smaller than the queue size.  It is the caller's
 		 * responsibility to check how many bytes we were able to send.
 		 */
-
-		written = transport->stream_enqueue(
-				vsk, msg,
-				len - total_written);
+		written = transport->stream_enqueue(vsk, msg,
+						    len - total_written);
 		if (written < 0) {
 			err = -ENOMEM;
 			goto out_err;
@@ -1815,36 +1819,96 @@ static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
 	}
 
 out_err:
-	if (total_written > 0)
-		err = total_written;
+	if (total_written > 0) {
+		/* Return number of written bytes only if:
+		 * 1) SOCK_STREAM socket.
+		 * 2) SOCK_SEQPACKET socket when whole buffer is sent.
+		 */
+		if (sk->sk_type == SOCK_STREAM || total_written == len)
+			err = total_written;
+	}
 out:
 	release_sock(sk);
 	return err;
 }
 
+static int vsock_stream_sendmsg(struct socket *sock, struct msghdr *msg,
+				size_t len)
+{
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
 
-static int
-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-		     int flags)
+static int vsock_seqpacket_sendmsg(struct socket *sock, struct msghdr *msg,
+				   size_t len)
 {
-	struct sock *sk;
+	return vsock_connectible_sendmsg(sock, msg, len);
+}
+
+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
+			   long timeout,
+			   struct vsock_transport_recv_notify_data *recv_data,
+			   size_t target)
+{
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
 
+	if (sk->sk_err != 0 ||
+	    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+	    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+		finish_wait(sk_sleep(sk), wait);
+		return -1;
+	}
+	/* Don't wait for non-blocking sockets. */
+	if (timeout == 0) {
+		err = -EAGAIN;
+		finish_wait(sk_sleep(sk), wait);
+		return err;
+	}
+
+	if (sk->sk_type == SOCK_STREAM) {
+		err = transport->notify_recv_pre_block(vsk, target, recv_data);
+		if (err < 0) {
+			finish_wait(sk_sleep(sk), wait);
+			return err;
+		}
+	}
+
+	release_sock(sk);
+	timeout = schedule_timeout(timeout);
 	lock_sock(sk);
 
+	if (signal_pending(current)) {
+		err = sock_intr_errno(timeout);
+		finish_wait(sk_sleep(sk), wait);
+	} else if (timeout == 0) {
+		err = -EAGAIN;
+		finish_wait(sk_sleep(sk), wait);
+	}
+
+	return err;
+}
+
+static int vsock_wait_data_seqpacket(struct sock *sk, struct wait_queue_entry *wait,
+				     long timeout)
+{
+	return vsock_wait_data(sk, wait, timeout, NULL, 0);
+}
+
+static int vsock_pre_recv_check(struct socket *sock,
+				int flags, size_t len, int *err)
+{
+	struct sock *sk;
+	struct vsock_sock *vsk;
+	const struct vsock_transport *transport;
+
+	sk = sock->sk;
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
 	if (!transport || sk->sk_state != TCP_ESTABLISHED) {
 		/* Recvmsg is supposed to return 0 if a peer performs an
 		 * orderly shutdown. Differentiate between that case and when a
@@ -1852,16 +1916,16 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		 * SOCK_DONE flag.
 		 */
 		if (sock_flag(sk, SOCK_DONE))
-			err = 0;
+			*err = 0;
 		else
-			err = -ENOTCONN;
+			*err = -ENOTCONN;
 
-		goto out;
+		return false;
 	}
 
 	if (flags & MSG_OOB) {
-		err = -EOPNOTSUPP;
-		goto out;
+		*err = -EOPNOTSUPP;
+		return false;
 	}
 
 	/* We don't check peer_shutdown flag here since peer may actually shut
@@ -1869,17 +1933,143 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 * receive.
 	 */
 	if (sk->sk_shutdown & RCV_SHUTDOWN) {
-		err = 0;
-		goto out;
+		*err = 0;
+		return false;
 	}
 
 	/* It is valid on Linux to pass in a zero-length receive buffer.  This
 	 * is not an error.  We may as well bail out now.
 	 */
 	if (!len) {
+		*err = 0;
+		return false;
+	}
+
+	return true;
+}
+
+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	int err = 0;
+	size_t record_len;
+	struct vsock_sock *vsk;
+	const struct vsock_transport *transport;
+	long timeout;
+	ssize_t dequeued_total = 0;
+	unsigned long orig_nr_segs;
+	const struct iovec *orig_iov;
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	msg->msg_flags &= ~MSG_EOR;
+	orig_nr_segs = msg->msg_iter.nr_segs;
+	orig_iov = msg->msg_iter.iov;
+
+	while (1) {
+		s64 ready;
+
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		ready = vsock_stream_has_data(vsk);
+
+		if (ready == 0) {
+			if (vsock_wait_data_seqpacket(sk, &wait, timeout)) {
+				/* In case of any loop break(timeout, signal
+				 * interrupt or shutdown), we report user that
+				 * nothing was copied.
+				 */
+				dequeued_total = 0;
+				break;
+			}
+		} else {
+			ssize_t dequeued;
+
+			finish_wait(sk_sleep(sk), &wait);
+
+			if (ready < 0) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			if (dequeued_total == 0) {
+				record_len =
+					transport->seqpacket_seq_get_len(vsk);
+
+				if (record_len == 0)
+					continue;
+			}
+
+			/* 'msg_iter.count' is number of unused bytes in iov.
+			 * On every copy to iov iterator it is decremented at
+			 * size of data.
+			 */
+			dequeued = transport->stream_dequeue(vsk, msg,
+						msg->msg_iter.count, flags);
+
+			if (dequeued < 0) {
+				dequeued_total = 0;
+
+				if (dequeued == -EAGAIN) {
+					iov_iter_init(&msg->msg_iter, READ,
+						      orig_iov, orig_nr_segs,
+						      len);
+					msg->msg_flags &= ~MSG_EOR;
+					continue;
+				}
+
+				err = -ENOMEM;
+				break;
+			}
+
+			dequeued_total += dequeued;
+
+			if (dequeued_total >= record_len)
+				break;
+		}
+	}
+
+	if (sk->sk_err)
+		err = -sk->sk_err;
+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
 		err = 0;
-		goto out;
+
+	if (dequeued_total > 0) {
+		/* User sets MSG_TRUNC, so return real length of
+		 * packet.
+		 */
+		if (flags & MSG_TRUNC)
+			err = record_len;
+		else
+			err = len - msg->msg_iter.count;
+
+		/* Always set MSG_TRUNC if real length of packet is
+		 * bigger that user buffer.
+		 */
+		if (record_len > len)
+			msg->msg_flags |= MSG_TRUNC;
 	}
+out:
+	return err;
+}
+
+static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
+				  size_t len, int flags)
+{
+	int err;
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	size_t target;
+	struct vsock_transport_recv_notify_data recv_data;
+	long timeout;
+	ssize_t copied;
+
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
 
 	/* We must not copy less than target bytes into the user's buffer
 	 * before returning successfully, so we wait for the consume queue to
@@ -1907,38 +2097,8 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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
+			if (vsock_wait_data(sk, &wait, timeout, &recv_data, target))
 				break;
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
-				break;
-			}
 		} else {
 			ssize_t read;
 
@@ -1959,9 +2119,8 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			if (err < 0)
 				break;
 
-			read = transport->stream_dequeue(
-					vsk, msg,
-					len - copied, flags);
+			read = transport->stream_dequeue(vsk, msg, len - copied, flags);
+
 			if (read < 0) {
 				err = -ENOMEM;
 				break;
@@ -1990,11 +2149,45 @@ vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	if (copied > 0)
 		err = copied;
 
+out:
+	return err;
+}
+
+static int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	struct sock *sk;
+	int err;
+
+	sk = sock->sk;
+
+	lock_sock(sk);
+
+	if (!vsock_pre_recv_check(sock, flags,  len, &err))
+		goto out;
+
+	if (sk->sk_type == SOCK_STREAM)
+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	else
+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
+
 out:
 	release_sock(sk);
 	return err;
 }
 
+static int vsock_seqpacket_recvmsg(struct socket *sock, struct msghdr *msg,
+				   size_t len, int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
+static int vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg,
+				size_t len, int flags)
+{
+	return vsock_connectible_recvmsg(sock, msg, len, flags);
+}
+
 static const struct proto_ops vsock_stream_ops = {
 	.family = PF_VSOCK,
 	.owner = THIS_MODULE,
-- 
2.25.1


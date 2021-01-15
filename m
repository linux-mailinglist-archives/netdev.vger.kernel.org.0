Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7E12F726C
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733258AbhAOFmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:42:37 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:46530 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732093AbhAOFmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:42:36 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 3040952176E;
        Fri, 15 Jan 2021 08:41:50 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689310;
        bh=uiTfdp+y1ejoIzWucUCkbz6uafmLJAh22TeFNE5cU3Y=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=NxuSil7dg/yqbTabYOrYU9Vef1l+7KfjZZQ318xOTG0B1cuR1OyzjYMI5eJVOgoFX
         bW6s2cZOWJ0OkKSK9mFhGRhFARLT60SeQsqe7jmknn7NTTsqcymrsmWUl4F1VMzUij
         +ZgELqRjUDZc8mMhb/JMD06+7JijG4nbfysUlQ7s=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id CD8F1521779;
        Fri, 15 Jan 2021 08:41:49 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:41:49 +0300
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
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 04/13] af_vsock: replace previous stream rx loop.
Date:   Fri, 15 Jan 2021 08:41:38 +0300
Message-ID: <20210115054141.1456019-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/15/2021 05:18:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161159 [Jan 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 420 420 0b339e70b2b1bb108f53ec9b40aa316bba18ceea
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/15/2021 05:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.01.2021 2:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/15 05:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/15 02:12:00 #16041563
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes previous 'vsock_stream_recvmsg()' and uses newly implemented
receive loops. Moved to separate patch to make review easier.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 184 +++------------------------------------
 1 file changed, 12 insertions(+), 172 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 38afaa90d141..5bf887190881 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2072,178 +2072,6 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 	return err;
 }
 
-static int
-vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
-		     int flags)
-{
-	struct sock *sk;
-	struct vsock_sock *vsk;
-	const struct vsock_transport *transport;
-	int err;
-	size_t target;
-	ssize_t copied;
-	long timeout;
-	struct vsock_transport_recv_notify_data recv_data;
-
-	DEFINE_WAIT(wait);
-
-	sk = sock->sk;
-	vsk = vsock_sk(sk);
-	transport = vsk->transport;
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
-	/* We must not copy less than target bytes into the user's buffer
-	 * before returning successfully, so we wait for the consume queue to
-	 * have that much data to consume before dequeueing.  Note that this
-	 * makes it impossible to handle cases where target is greater than the
-	 * queue size.
-	 */
-	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
-	if (target >= transport->stream_rcvhiwat(vsk)) {
-		err = -ENOMEM;
-		goto out;
-	}
-	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
-	copied = 0;
-
-	err = transport->notify_recv_init(vsk, target, &recv_data);
-	if (err < 0)
-		goto out;
-
-
-	while (1) {
-		s64 ready;
-
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		ready = vsock_stream_has_data(vsk);
-
-		if (ready == 0) {
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
-				break;
-			}
-		} else {
-			ssize_t read;
-
-			finish_wait(sk_sleep(sk), &wait);
-
-			if (ready < 0) {
-				/* Invalid queue pair content. XXX This should
-				* be changed to a connection reset in a later
-				* change.
-				*/
-
-				err = -ENOMEM;
-				goto out;
-			}
-
-			err = transport->notify_recv_pre_dequeue(
-					vsk, target, &recv_data);
-			if (err < 0)
-				break;
-
-			read = transport->stream_dequeue(
-					vsk, msg,
-					len - copied, flags);
-			if (read < 0) {
-				err = -ENOMEM;
-				break;
-			}
-
-			copied += read;
-
-			err = transport->notify_recv_post_dequeue(
-					vsk, target, read,
-					!(flags & MSG_PEEK), &recv_data);
-			if (err < 0)
-				goto out;
-
-			if (read >= target || flags & MSG_PEEK)
-				break;
-
-			target -= read;
-		}
-	}
-
-	if (sk->sk_err)
-		err = -sk->sk_err;
-	else if (sk->sk_shutdown & RCV_SHUTDOWN)
-		err = 0;
-
-	if (copied > 0)
-		err = copied;
-
-out:
-	release_sock(sk);
-	return err;
-}
-
 static int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg,
 				     size_t len, int flags)
 {
@@ -2299,6 +2127,18 @@ static int vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg,
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


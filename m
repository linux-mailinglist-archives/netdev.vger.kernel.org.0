Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2ACE345EFF
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhCWNJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:09:49 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:46497 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231368AbhCWNJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:09:34 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id B1A5D520DF2;
        Tue, 23 Mar 2021 16:09:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616504969;
        bh=m5r6elPoeBWYyW9A+cGx8SXGcB4XtBcglbjd82LbT+g=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=w96kN06fcSHEi+700VfAdZrcf0rQsDsJv1eJIWZ/lSI4tVZQzY1Oi1mYlFo6CK6ZS
         2J7KtWePEV+ZZ4/B+vngpMwesnsjIOyAsMZBXmucTzNKFppnOkCEQtYZluxIXuXfEg
         x/E2RzuqYB2wC3ymeWUl+LUNlLKRdBHgN2Rw2szWAhuGRSMcgBGGuA0DZeklEZY1zr
         usXXDvDFQEpQKqzZeawJdLHr04GvQGBy+otlyKcTIIXbNefyqQIguksLOeKzd8RMh5
         hQEku1HC7E2WM87xK4xGErdmBKvFe5W6tGeRmsF7ShQaZGdB9wtl+DsOBJTovTBEvt
         2gnmcO+yahLQA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 68082520D02;
        Tue, 23 Mar 2021 16:09:29 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:09:28 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 02/22] af_vsock: separate wait data loop
Date:   Tue, 23 Mar 2021 16:09:13 +0300
Message-ID: <20210323130916.2459756-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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

This moves wait loop for data to dedicated function, because later it
will be used by SEQPACKET data receive loop. While moving the code
around, let's update an old comment.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 156 +++++++++++++++++++++------------------
 1 file changed, 84 insertions(+), 72 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 656370e11707..421c0303b26f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1832,6 +1832,69 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	return err;
 }
 
+static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
+			   long timeout,
+			   struct vsock_transport_recv_notify_data *recv_data,
+			   size_t target)
+{
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	s64 data;
+	int err;
+
+	vsk = vsock_sk(sk);
+	err = 0;
+	transport = vsk->transport;
+
+	while ((data = vsock_stream_has_data(vsk)) == 0) {
+		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
+
+		if (sk->sk_err != 0 ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+			break;
+		}
+
+		/* Don't wait for non-blocking sockets. */
+		if (timeout == 0) {
+			err = -EAGAIN;
+			break;
+		}
+
+		if (recv_data) {
+			err = transport->notify_recv_pre_block(vsk, target, recv_data);
+			if (err < 0)
+				break;
+		}
+
+		release_sock(sk);
+		timeout = schedule_timeout(timeout);
+		lock_sock(sk);
+
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeout);
+			break;
+		} else if (timeout == 0) {
+			err = -EAGAIN;
+			break;
+		}
+	}
+
+	finish_wait(sk_sleep(sk), wait);
+
+	if (err)
+		return err;
+
+	/* Internal transport error when checking for available
+	 * data. XXX This should be changed to a connection
+	 * reset in a later change.
+	 */
+	if (data < 0)
+		return -ENOMEM;
+
+	return data;
+}
+
 static int
 vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			  int flags)
@@ -1911,85 +1974,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 
 	while (1) {
-		s64 ready;
+		ssize_t read;
 
-		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
-		ready = vsock_stream_has_data(vsk);
+		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
+		if (err <= 0)
+			break;
 
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
+		err = transport->notify_recv_pre_dequeue(vsk, target,
+							 &recv_data);
+		if (err < 0)
+			break;
 
-			read = transport->stream_dequeue(
-					vsk, msg,
-					len - copied, flags);
-			if (read < 0) {
-				err = -ENOMEM;
-				break;
-			}
+		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
+		if (read < 0) {
+			err = -ENOMEM;
+			break;
+		}
 
-			copied += read;
+		copied += read;
 
-			err = transport->notify_recv_post_dequeue(
-					vsk, target, read,
-					!(flags & MSG_PEEK), &recv_data);
-			if (err < 0)
-				goto out;
+		err = transport->notify_recv_post_dequeue(vsk, target, read,
+						!(flags & MSG_PEEK), &recv_data);
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
-- 
2.25.1


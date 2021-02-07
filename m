Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE30A31250B
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbhBGPPu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:15:50 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:15483 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhBGPPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:15:44 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 79D81521233;
        Sun,  7 Feb 2021 18:14:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710899;
        bh=w4t5Y5z6hP9hLRrXJ3Rh+yPDoKiqNey9NGd640iBmqk=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=J82qXoo2EFYB8O81a2EN8besMlgSTv2BG+a7pw6dmUA2fXwG9V/twXY2ndApLZsYY
         9XjeXj41Tbq83WHZ5P4yTWhMYELRxnfiGvU/d2Ur/eQUIXx5i8CnNof6yoNaOtTZfj
         SqhisASisV2DLz6+bZFMCtCPoLxjHdQkmEEPgx70=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 2924A521217;
        Sun,  7 Feb 2021 18:14:59 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:14:58 +0300
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
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 02/17] af_vsock: separate wait data loop
Date:   Sun, 7 Feb 2021 18:14:48 +0300
Message-ID: <20210207151451.804498-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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

This moves wait loop for data to dedicated function, because later
it will be used by SEQPACKET data receive loop.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/af_vsock.c | 158 +++++++++++++++++++++------------------
 1 file changed, 86 insertions(+), 72 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index f4fabec50650..38927695786f 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1833,6 +1833,71 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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
+	prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
+
+	while ((data = vsock_stream_has_data(vsk)) == 0) {
+		if (sk->sk_err != 0 ||
+		    (sk->sk_shutdown & RCV_SHUTDOWN) ||
+		    (vsk->peer_shutdown & SEND_SHUTDOWN)) {
+			goto out;
+		}
+
+		/* Don't wait for non-blocking sockets. */
+		if (timeout == 0) {
+			err = -EAGAIN;
+			goto out;
+		}
+
+		if (recv_data) {
+			err = transport->notify_recv_pre_block(vsk, target, recv_data);
+			if (err < 0)
+				goto out;
+		}
+
+		release_sock(sk);
+		timeout = schedule_timeout(timeout);
+		lock_sock(sk);
+
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeout);
+			goto out;
+		} else if (timeout == 0) {
+			err = -EAGAIN;
+			goto out;
+		}
+	}
+
+	finish_wait(sk_sleep(sk), wait);
+
+	/* Invalid queue pair content. XXX This should
+	 * be changed to a connection reset in a later
+	 * change.
+	 */
+	if (data < 0)
+		return -ENOMEM;
+
+	/* Have some data, return. */
+	if (data)
+		return data;
+
+out:
+	finish_wait(sk_sleep(sk), wait);
+	return err;
+}
+
 static int
 vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			  int flags)
@@ -1912,85 +1977,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 
 	while (1) {
-		s64 ready;
+		ssize_t read;
 
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
+		err = vsock_wait_data(sk, &wait, timeout, &recv_data, target);
+		if (err <= 0)
+			break;
 
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


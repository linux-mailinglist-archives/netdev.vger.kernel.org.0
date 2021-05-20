Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9042838B704
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237676AbhETTRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:17:16 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:28306 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234210AbhETTRO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:17:14 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0AC6152143B;
        Thu, 20 May 2021 22:15:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538151;
        bh=2SCAXQqEnMds5nDI4CYPTbZIWZJpFyRZ6gelmXZ1b6o=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=un4jlpTlyH1TRtX2GQoB/cLNYJuPYLC52+t3JXHjnOzv10YEMt4Fh2QOnbFTGl3Wk
         RArMbBu7VBPjL1WwtB5fIHY5vfvLOaYMKui9AZy6uBUOGBamex3ya+MWFYDNDyWM4u
         A7AxxLx0ku7fC0g5p7+/4qws/JSoNrFouDdX7VFLEEv03WA7jD0i+iwmwamsZm3+vP
         j2H+zRjqVpTNz0uBiwj/1P6L4qfYXfTDpVlnlFTDSg5pKS8Fr17AoQNYuC06RqEbU0
         Yd0xd1vIGnRCrNelLqJ8spXHDeJ25jE7L76DRBWNQ02UWjQfu6NPbvbRlsT0gquWpf
         ifMFSE/SXnIBA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id AC93452142D;
        Thu, 20 May 2021 22:15:50 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:15:49 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 02/18] af_vsock: separate wait data loop
Date:   Thu, 20 May 2021 22:15:41 +0300
Message-ID: <20210520191544.1270985-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wait loop for data could be shared between SEQPACKET and STREAM
sockets, so move it to dedicated function. While moving the code
around, let's update an old comment.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 156 +++++++++++++++++++++------------------
 1 file changed, 84 insertions(+), 72 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 7dd8e70d78cd..4269e80b02cd 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1833,6 +1833,69 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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
@@ -1912,85 +1975,34 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 
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


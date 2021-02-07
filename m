Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39DE312516
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhBGPRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:17:10 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:12701 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBGPQr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:16:47 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id ACAB47601B;
        Sun,  7 Feb 2021 18:15:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710951;
        bh=rHifXE+UtLnEKvIrbXNmcRzsnUcnja9TP6Xp9JnrXGo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=FFGar2K7X6hbZOBwkOV3BE7p3G3wfhD0gB4rVaRQyBQ+/Emk6ugCEXu9ZOgv+4QCp
         tvs7xqkM6GG87/hvV8WvRNClnt0QYrwpLku3JMPyyvQn9jflveILNzP42lSqJnCAhh
         Kf+G+tKiL3upmShJJr6ZDxI8Ty+WIY/moJgUUq9M=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 697EF7601C;
        Sun,  7 Feb 2021 18:15:51 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:15:50 +0300
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
Subject: [RFC PATCH v4 05/17] af_vsock: separate wait space loop
Date:   Sun, 7 Feb 2021 18:15:41 +0300
Message-ID: <20210207151545.804889-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
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

This moves loop that waits for space on send to separate function,
because it will be used for SEQ_BEGIN/SEQ_END sending before and
after data transmission. Waiting for SEQ_BEGIN/SEQ_END is needed
because such packets carries SEQPACKET header that couldn't be
fragmented by credit mechanism, so to avoid it, sender waits until
enough space will be ready.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |  2 +
 net/vmw_vsock/af_vsock.c | 93 ++++++++++++++++++++++++++--------------
 2 files changed, 62 insertions(+), 33 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index bb6a0e52be86..19f6f22821ec 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -205,6 +205,8 @@ void vsock_remove_sock(struct vsock_sock *vsk);
 void vsock_for_each_connected_socket(void (*fn)(struct sock *sk));
 int vsock_assign_transport(struct vsock_sock *vsk, struct vsock_sock *psk);
 bool vsock_find_cid(unsigned int cid);
+int vsock_wait_space(struct sock *sk, size_t space, int flags,
+		     struct vsock_transport_send_notify_data *send_data);
 
 /**** TAP ****/
 
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3d8af987216a..ea99261e88ac 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1693,6 +1693,64 @@ static int vsock_connectible_getsockopt(struct socket *sock,
 	return 0;
 }
 
+int vsock_wait_space(struct sock *sk, size_t space, int flags,
+		     struct vsock_transport_send_notify_data *send_data)
+{
+	const struct vsock_transport *transport;
+	struct vsock_sock *vsk;
+	long timeout;
+	int err;
+
+	DEFINE_WAIT_FUNC(wait, woken_wake_function);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+	timeout = sock_sndtimeo(sk, flags & MSG_DONTWAIT);
+	err = 0;
+
+	add_wait_queue(sk_sleep(sk), &wait);
+
+	while (vsock_stream_has_space(vsk) < space &&
+	       sk->sk_err == 0 &&
+	       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
+	       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
+		/* Don't wait for non-blocking sockets. */
+		if (timeout == 0) {
+			err = -EAGAIN;
+			goto out_err;
+		}
+
+		if (send_data) {
+			err = transport->notify_send_pre_block(vsk, send_data);
+			if (err < 0)
+				goto out_err;
+		}
+
+		release_sock(sk);
+		timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
+		lock_sock(sk);
+		if (signal_pending(current)) {
+			err = sock_intr_errno(timeout);
+			goto out_err;
+		} else if (timeout == 0) {
+			err = -EAGAIN;
+			goto out_err;
+		}
+	}
+
+	if (sk->sk_err) {
+		err = -sk->sk_err;
+	} else if ((sk->sk_shutdown & SEND_SHUTDOWN) ||
+		   (vsk->peer_shutdown & RCV_SHUTDOWN)) {
+		err = -EPIPE;
+	}
+
+out_err:
+	remove_wait_queue(sk_sleep(sk), &wait);
+	return err;
+}
+EXPORT_SYMBOL_GPL(vsock_wait_space);
+
 static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 				     size_t len)
 {
@@ -1751,39 +1809,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	while (total_written < len) {
 		ssize_t written;
 
-		add_wait_queue(sk_sleep(sk), &wait);
-		while (vsock_stream_has_space(vsk) == 0 &&
-		       sk->sk_err == 0 &&
-		       !(sk->sk_shutdown & SEND_SHUTDOWN) &&
-		       !(vsk->peer_shutdown & RCV_SHUTDOWN)) {
-
-			/* Don't wait for non-blocking sockets. */
-			if (timeout == 0) {
-				err = -EAGAIN;
-				remove_wait_queue(sk_sleep(sk), &wait);
-				goto out_err;
-			}
-
-			err = transport->notify_send_pre_block(vsk, &send_data);
-			if (err < 0) {
-				remove_wait_queue(sk_sleep(sk), &wait);
-				goto out_err;
-			}
-
-			release_sock(sk);
-			timeout = wait_woken(&wait, TASK_INTERRUPTIBLE, timeout);
-			lock_sock(sk);
-			if (signal_pending(current)) {
-				err = sock_intr_errno(timeout);
-				remove_wait_queue(sk_sleep(sk), &wait);
-				goto out_err;
-			} else if (timeout == 0) {
-				err = -EAGAIN;
-				remove_wait_queue(sk_sleep(sk), &wait);
-				goto out_err;
-			}
-		}
-		remove_wait_queue(sk_sleep(sk), &wait);
+		if (vsock_wait_space(sk, 1, msg->msg_flags, &send_data))
+			goto out_err;
 
 		/* These checks occur both as part of and after the loop
 		 * conditional since we need to check before and after
-- 
2.25.1


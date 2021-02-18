Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DD431E5D1
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhBRFmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:42:09 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:44584 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbhBRFjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:39:52 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 2571B521505;
        Thu, 18 Feb 2021 08:38:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626688;
        bh=LA/0q6c2gXvOdseaLW3DauuqCCDWvP7xCzmgoGt3qek=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=AqpAyRsSg0Dx8d9TakE88OmySwRM/uH3BkByU1nu6xdstbqYaHB06Lnnns1+ZKI96
         s3t6xGa87u/Ey2hUECOk/1sMI05+cc5doPL55M4Wfl/pMQEqxvE55xD37HCBvrbuWl
         ftghg/By6Gsr8iSMNl4VJL0jxNOD7UssynN6HjSsYT3y75Ayz2b6eqs7smo1m4FOr7
         rA5VemoIlWWJdMjylUIgyKp+zwnJ47+Y6ulju5fpOMTtYxVAo1oxBQyuH0jtGf1+Cg
         lNiPzUZS98xosN/wX0kMSlsfT/fURBCEpRt8ADawBK6z/u75O85ZPgOxfAWxKAJlw4
         xmkOr209ycjuA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 993835214CB;
        Thu, 18 Feb 2021 08:38:07 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:38:03 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v5 05/19] af_vsock: separate wait space loop
Date:   Thu, 18 Feb 2021 08:37:54 +0300
Message-ID: <20210218053758.1067436-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
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
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/18 04:51:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/18 04:31:00 #16269527
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
 net/vmw_vsock/af_vsock.c | 99 +++++++++++++++++++++++++---------------
 2 files changed, 63 insertions(+), 38 deletions(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 01563338cc03..6fbe88306403 100644
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
index b754927a556a..09b377422b1e 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1692,6 +1692,65 @@ static int vsock_connectible_getsockopt(struct socket *sock,
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
+
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
@@ -1699,10 +1758,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 	struct vsock_sock *vsk;
 	const struct vsock_transport *transport;
 	ssize_t total_written;
-	long timeout;
 	int err;
 	struct vsock_transport_send_notify_data send_data;
-	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 
 	sk = sock->sk;
 	vsk = vsock_sk(sk);
@@ -1740,9 +1797,6 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
-	/* Wait for room in the produce queue to enqueue our user's data. */
-	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
-
 	err = transport->notify_send_init(vsk, &send_data);
 	if (err < 0)
 		goto out;
@@ -1750,39 +1804,8 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
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


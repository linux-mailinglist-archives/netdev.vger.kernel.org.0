Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A69738B712
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhETTSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:18:02 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:28593 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237241AbhETTR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:17:56 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 14C74521146;
        Thu, 20 May 2021 22:16:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538192;
        bh=UBsavzFZWcT0S3IYlrCNPPD8gQTQS24RNjbAotniV7I=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=ZFx1pcAvi8DCCPPo1yEEOh+J3mFjPMco6wVsmCrrxSH3xOLxB2inx6pAZ0GBUbfrs
         JqJuSaqvqUWZFarHxWYXr2VQDmXmPChy5knng8VbwezQk/B/uazb6IG2DsDEvLXu04
         U1+v67Bl4B5WjdoZm6gcFWWCJ8lCy5AWUY5mx3+33+q1+D5w6m7/stnrEXKST59tEe
         9v5JmPSMJGGpTid7QGu+craZ6N4o8n1bcj5OjFOoYwFjnnl6artjv7GwKjFhohV5gd
         eSYN8Fb+xsrJh435bfTr1aCslEvGFkkeBQGrGaE/v+d4Q9Yn12kG/8YlUVnnOXHY/k
         2yC7eyOHKK9LA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id C0DE0520FB3;
        Thu, 20 May 2021 22:16:31 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:16:02 +0300
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
        <oxffffaa@gmail.com>
Subject: [PATCH v10 03/18] af_vsock: separate receive data loop
Date:   Thu, 20 May 2021 22:15:54 +0300
Message-ID: <20210520191557.1271095-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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

Some code in receive data loop could be shared between SEQPACKET
and STREAM sockets, while another part is type specific, so move STREAM
specific data receive logic to '__vsock_stream_recvmsg()' dedicated
function, while checks, that will be same for both STREAM and SEQPACKET
sockets, stays in 'vsock_connectible_recvmsg()'.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/af_vsock.c | 116 ++++++++++++++++++++++-----------------
 1 file changed, 67 insertions(+), 49 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4269e80b02cd..c4f6bfa1e381 100644
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
-		 * peer has not connected or a local shutdown occurred with the
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67AAC345F0B
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhCWNKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:10:47 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:46936 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbhCWNKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:10:20 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id A0FCB5216D2;
        Tue, 23 Mar 2021 16:10:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505018;
        bh=/tbCs4TAsfEhIIBiHQx6WLW7CwTkzQ0Z/qTyWxJ0Cx8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=lq5UJTMk7Fw0csRH9QNtynBY20cyy/JSbfHHd6PiEeJV53Ce923AqSc9h04aFLCF0
         SAqKCL/3rL6LTIBrv6bMbrXEVaqR/OYYeKrMKujH7BCJOI4JmmIJnCeOfA3oarwCES
         69gJO0ShZah5H3aLf08otPCYBDmnhbRSfBb77BQkwLkUCK7ZNLCOectxaPuCaJnDBG
         8Rxuackbpo3BiMa3tnnnNmIzMpQj7imdAcBfB6Dt1OtfNE2q2DdeJhcRL+MU6Pdbaj
         yblYDQ2rZtSxr+KGUqsc0L1gFrk8mK6TxdklRHu+ZWe19Y0j0sqtB2BFjglWkPwv50
         AeOxTx9BigGAA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 471825216F0;
        Tue, 23 Mar 2021 16:10:18 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:10:17 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 04/22] af_vsock: implement SEQPACKET receive loop
Date:   Tue, 23 Mar 2021 16:10:03 +0300
Message-ID: <20210323131006.2460058-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
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

This adds receive loop for SEQPACKET. It looks like receive loop for
STREAM, but there is a little bit difference:
1) It doesn't call notify callbacks.
2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
   there is no sense for these values in SEQPACKET case.
3) It waits until whole record is received or error is found during
   receiving.
4) It processes and sets 'MSG_TRUNC' flag.

So to avoid extra conditions for two types of socket inside one loop, two
independent functions were created.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v6 -> v7:
 'seqpacket_get_len' callback now removed, length of message is returned
  by 'seqpacket_dequeue' callback.

 include/net/af_vsock.h   |  4 ++
 net/vmw_vsock/af_vsock.c | 88 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..74ac8a4c4168 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -135,6 +135,10 @@ struct vsock_transport {
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
 
+	/* SEQ_PACKET. */
+	int (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
+				 int flags, bool *msg_ready, size_t *record_len);
+
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 0bc661e54262..fa0c37f97330 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1973,6 +1973,89 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 	return err;
 }
 
+static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
+				     size_t len, int flags)
+{
+	const struct vsock_transport *transport;
+	const struct iovec *orig_iov;
+	unsigned long orig_nr_segs;
+	bool msg_ready;
+	struct vsock_sock *vsk;
+	size_t record_len;
+	long timeout;
+	int err = 0;
+	DEFINE_WAIT(wait);
+
+	vsk = vsock_sk(sk);
+	transport = vsk->transport;
+
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	orig_nr_segs = msg->msg_iter.nr_segs;
+	orig_iov = msg->msg_iter.iov;
+	msg_ready = false;
+	record_len = 0;
+
+	while (1) {
+		err = vsock_wait_data(sk, &wait, timeout, NULL, 0);
+
+		if (err <= 0) {
+			/* In case of any loop break(timeout, signal
+			 * interrupt or shutdown), we report user that
+			 * nothing was copied.
+			 */
+			err = 0;
+			break;
+		}
+
+		err = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready, &record_len);
+
+		if (err < 0) {
+			if (err == -EAGAIN) {
+				iov_iter_init(&msg->msg_iter, READ,
+					      orig_iov, orig_nr_segs,
+					      len);
+				/* Clear 'MSG_EOR' here, because dequeue
+				 * callback above set it again if it was
+				 * set by sender. This 'MSG_EOR' is from
+				 * dropped record.
+				 */
+				msg->msg_flags &= ~MSG_EOR;
+				record_len = 0;
+				continue;
+			}
+
+			err = -ENOMEM;
+			break;
+		}
+
+		if (msg_ready)
+			break;
+	}
+
+	if (sk->sk_err)
+		err = -sk->sk_err;
+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
+		err = 0;
+
+	if (msg_ready) {
+		/* User sets MSG_TRUNC, so return real length of
+		 * packet.
+		 */
+		if (flags & MSG_TRUNC)
+			err = record_len;
+		else
+			err = len - msg->msg_iter.count;
+
+		/* Always set MSG_TRUNC if real length of packet is
+		 * bigger than user's buffer.
+		 */
+		if (record_len > len)
+			msg->msg_flags |= MSG_TRUNC;
+	}
+
+	return err;
+}
+
 static int
 vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			  int flags)
@@ -2028,7 +2111,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		goto out;
 	}
 
-	err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	if (sk->sk_type == SOCK_STREAM)
+		err = __vsock_stream_recvmsg(sk, msg, len, flags);
+	else
+		err = __vsock_seqpacket_recvmsg(sk, msg, len, flags);
 
 out:
 	release_sock(sk);
-- 
2.25.1


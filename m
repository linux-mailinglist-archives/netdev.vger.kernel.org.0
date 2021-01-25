Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366DE304A29
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728830AbhAZFMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:12:00 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:11145 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728973AbhAYNj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 08:39:57 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 36BD275F9A;
        Mon, 25 Jan 2021 14:12:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1611573169;
        bh=pkTumD+fZqWlO43eEnV4ccjNyUhusQnXcnmd+wP9qEE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=dd+l48+6pt2ITTaGgHlAyDZS8MpHF21XQ+it9mOg8/i4SOwnbWEGylgXN8Rs18XTN
         vVX9KOJW8p2LSlZ7OfKX85Qofl/PcPhYIcy+wVxLYoMdc5MvI224B7279SgGsfAYwC
         cA0/+Lba2868+MXBs2JjpzROzX6lkyJaRwX3rEE0=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 68A2575FBD;
        Mon, 25 Jan 2021 14:12:48 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Mon, 25
 Jan 2021 14:12:47 +0300
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
Subject: [RFC PATCH v3 03/13] af_vsock: implement SEQPACKET rx loop
Date:   Mon, 25 Jan 2021 14:12:36 +0300
Message-ID: <20210125111239.598377-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
References: <20210125110903.597155-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
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

This adds receive loop for SEQPACKET. It looks like receive loop for
SEQPACKET, but there is a little bit difference:
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
 include/net/af_vsock.h   |   5 ++
 net/vmw_vsock/af_vsock.c | 102 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 106 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..46073842d489 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -135,6 +135,11 @@ struct vsock_transport {
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
 
+	/* SEQ_PACKET. */
+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
+	ssize_t (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
+				     size_t len, int flags);
+
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 524df8fc84cd..3b266880b7c8 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2006,7 +2006,107 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 				     size_t len, int flags)
 {
-	return -1;
+	const struct vsock_transport *transport;
+	const struct iovec *orig_iov;
+	unsigned long orig_nr_segs;
+	ssize_t dequeued_total = 0;
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
+	msg->msg_flags &= ~MSG_EOR;
+	orig_nr_segs = msg->msg_iter.nr_segs;
+	orig_iov = msg->msg_iter.iov;
+
+	while (1) {
+		ssize_t dequeued;
+		s64 ready;
+
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		ready = vsock_stream_has_data(vsk);
+
+		if (ready == 0) {
+			if (vsock_wait_data(sk, &wait, timeout, NULL, 0)) {
+				/* In case of any loop break(timeout, signal
+				 * interrupt or shutdown), we report user that
+				 * nothing was copied.
+				 */
+				dequeued_total = 0;
+				break;
+			}
+			continue;
+		}
+
+		finish_wait(sk_sleep(sk), &wait);
+
+		if (ready < 0) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		if (dequeued_total == 0) {
+			record_len =
+				transport->seqpacket_seq_get_len(vsk);
+
+			if (record_len == 0)
+				continue;
+		}
+
+		/* 'msg_iter.count' is number of unused bytes in iov.
+		 * On every copy to iov iterator it is decremented at
+		 * size of data.
+		 */
+		dequeued = transport->seqpacket_dequeue(vsk, msg,
+					msg->msg_iter.count, flags);
+
+		if (dequeued < 0) {
+			dequeued_total = 0;
+
+			if (dequeued == -EAGAIN) {
+				iov_iter_init(&msg->msg_iter, READ,
+					      orig_iov, orig_nr_segs,
+					      len);
+				msg->msg_flags &= ~MSG_EOR;
+				continue;
+			}
+
+			err = -ENOMEM;
+			break;
+		}
+
+		dequeued_total += dequeued;
+
+		if (dequeued_total >= record_len)
+			break;
+	}
+	if (sk->sk_err)
+		err = -sk->sk_err;
+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
+		err = 0;
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
+	}
+out:
+	return err;
 }
 
 static int
-- 
2.25.1


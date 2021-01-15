Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A512F7266
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:42:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733216AbhAOFl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:41:57 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:46215 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733201AbhAOFlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:41:55 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id E2AEE520FB4;
        Fri, 15 Jan 2021 08:41:08 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689269;
        bh=9Z9ZO4B4lKxfvNuTIWVBRpQKct45TlQpRvGOlgncXkE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=BkH7dsmJjJ9vwwcp3gabM67D10ah9EF6Pb/h/+PtqpcoY733Xqveb+bEeOWlktCfk
         q+5FlOdjtHTfNBqWApaLlIYX5EOwxeA4bl6uK2CAd9rFadk6O1FrLL2N7kANlOsOsn
         Lqmds7K2WLOtzanRpmu9s+EhQZhXdvmLcPUrVBB4=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 61512520ED7;
        Fri, 15 Jan 2021 08:41:08 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:41:07 +0300
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
Subject: [RFC PATCH v2 02/13] af_vsock: separate rx loops for STREAM/SEQPACKET.
Date:   Fri, 15 Jan 2021 08:40:50 +0300
Message-ID: <20210115054054.1455729-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1
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

This adds two receive loops: for SOCK_STREAM and SOCK_SEQPACKET. Both are
look like twins, but SEQPACKET is a little bit different from STREAM:
1) It doesn't call notify callbacks.
2) It doesn't care about 'SO_SNDLOWAT' and 'SO_RCVLOWAT' values, because
   there is no sense for these values in SEQPACKET case.
3) It waits until whole record is received or error is found during
   receiving.
4) It processes and sets 'MSG_TRUNC' flag.

So to avoid extra conditions for two types of socket inside on loop, two
independent functions were created.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/net/af_vsock.h   |   5 +
 net/vmw_vsock/af_vsock.c | 202 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 207 insertions(+)

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
index af716f5a93a4..afacbe9f4231 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1870,6 +1870,208 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
 	return err;
 }
 
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
+			if (vsock_wait_data(sk, &wait, timeout, NULL, 0)) {
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
+			dequeued = transport->seqpacket_dequeue(vsk, msg,
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
+
+	/* We must not copy less than target bytes into the user's buffer
+	 * before returning successfully, so we wait for the consume queue to
+	 * have that much data to consume before dequeueing.  Note that this
+	 * makes it impossible to handle cases where target is greater than the
+	 * queue size.
+	 */
+	target = sock_rcvlowat(sk, flags & MSG_WAITALL, len);
+	if (target >= transport->stream_rcvhiwat(vsk)) {
+		err = -ENOMEM;
+		goto out;
+	}
+	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	copied = 0;
+
+	err = transport->notify_recv_init(vsk, target, &recv_data);
+	if (err < 0)
+		goto out;
+
+	while (1) {
+		s64 ready;
+
+		prepare_to_wait(sk_sleep(sk), &wait, TASK_INTERRUPTIBLE);
+		ready = vsock_stream_has_data(vsk);
+
+		if (ready == 0) {
+			if (vsock_wait_data(sk, &wait, timeout, &recv_data, target))
+				break;
+		} else {
+			ssize_t read;
+
+			finish_wait(sk_sleep(sk), &wait);
+
+			if (ready < 0) {
+				/* Invalid queue pair content. XXX This should
+				 * be changed to a connection reset in a later
+				 * change.
+				 */
+
+				err = -ENOMEM;
+				goto out;
+			}
+
+			err = transport->notify_recv_pre_dequeue(vsk,
+						target, &recv_data);
+			if (err < 0)
+				break;
+			read = transport->stream_dequeue(vsk, msg, len - copied, flags);
+
+			if (read < 0) {
+				err = -ENOMEM;
+				break;
+			}
+
+			copied += read;
+
+			err = transport->notify_recv_post_dequeue(vsk,
+						target, read,
+						!(flags & MSG_PEEK), &recv_data);
+			if (err < 0)
+				goto out;
+
+			if (read >= target || flags & MSG_PEEK)
+				break;
+
+			target -= read;
+		}
+	}
+
+	if (sk->sk_err)
+		err = -sk->sk_err;
+	else if (sk->sk_shutdown & RCV_SHUTDOWN)
+		err = 0;
+	if (copied > 0)
+		err = copied;
+
+out:
+	release_sock(sk);
+	return err;
+}
+
 static int
 vsock_stream_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		     int flags)
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4CEC312512
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhBGPQr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:16:47 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:15770 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbhBGPQT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:16:19 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 1838652194F;
        Sun,  7 Feb 2021 18:15:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612710933;
        bh=yXzORJ3um9E3cVu47+2l+Q/xtxOxHFFpqbcFlP4sHeo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=hbqBvUaHI9EYKxR/hf+uB0H7COY3CJPj8smbAatTtAt1t3h59ZY/3+DKS80w8dqM3
         G8gFgOs4M90doiSX6SaFaQA+EEY8OgFwKWkO970SnWgF4AfTC1c2KKBOEY3V6yOIKd
         RxNWAsCgjOz6l7TKhnoHhnZBDghjhcA6w/PZTy4I=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id A80CC52193F;
        Sun,  7 Feb 2021 18:15:32 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:15:32 +0300
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
Subject: [RFC PATCH v4 04/17] af_vsock: implement SEQPACKET receive loop
Date:   Sun, 7 Feb 2021 18:15:22 +0300
Message-ID: <20210207151526.804741-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
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
 include/net/af_vsock.h   |  5 +++
 net/vmw_vsock/af_vsock.c | 96 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 100 insertions(+), 1 deletion(-)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index b1c717286993..bb6a0e52be86 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -135,6 +135,11 @@ struct vsock_transport {
 	bool (*stream_is_active)(struct vsock_sock *);
 	bool (*stream_allow)(u32 cid, u32 port);
 
+	/* SEQ_PACKET. */
+	size_t (*seqpacket_seq_get_len)(struct vsock_sock *);
+	int (*seqpacket_dequeue)(struct vsock_sock *, struct msghdr *,
+				     int flags, bool *msg_ready);
+
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
 	int (*notify_poll_out)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 66c8a932f49b..3d8af987216a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1977,6 +1977,97 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
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
+		if (record_len == 0) {
+			record_len =
+				transport->seqpacket_seq_get_len(vsk);
+
+			if (record_len == 0)
+				continue;
+		}
+
+		err = transport->seqpacket_dequeue(vsk, msg,
+					flags, &msg_ready);
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
@@ -2032,7 +2123,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
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


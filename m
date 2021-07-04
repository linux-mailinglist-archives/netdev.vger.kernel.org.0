Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C051F3BABFC
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhGDIMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:12:33 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:54280 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbhGDIMc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:12:32 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 121697708D;
        Sun,  4 Jul 2021 11:09:56 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625386196;
        bh=RajuJz4DZvmPmgiDiZOvlwCrD5RJTFG6Z5Yb+bJxFNU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Z7rsKbkZsuW9SoynFCLLZdjVdBcJpUkjLUTBA19mZKLPv25RYUSF9s7lKvcJmEJXB
         Y+JCeTw+A7BHLIuVNKeVo9WrcajBAAKxgOujPqo+VrDFF2z7fJu3c420/ptC0RYsmn
         zAv35XQwJ1eOC5+u72F+ou1ETrKwa2Jei2osbN3N5d2/ks8Pyhwh+1M6AwdeXwovjF
         7C9cGbLcZNyw087uRt0gy+aElQVUCDi+D6Ltj9L9xPixNeQlnAi3KJWiDSfxXiYoTo
         XhUL8AygOVtfgohFlW58ryWaYQ2jVLe5cHoHse9O8KItxfhq9F180CFoT5eTn3Rahh
         yNUh7/F8ajvJw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id CFADC770D8;
        Sun,  4 Jul 2021 11:09:55 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Sun, 4
 Jul 2021 11:09:55 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 1/6] af_vsock/virtio/vsock: change seqpacket receive logic
Date:   Sun, 4 Jul 2021 11:09:39 +0300
Message-ID: <20210704080942.89177-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/04/2021 07:43:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164820 [Jul 03 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_exist}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/04/2021 07:45:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.07.2021 5:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/04 06:12:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/04 01:03:00 #16855183
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

1) In af_vsock "loop" now is really loop: it receives
   message fragments one by one, until 'msg_ready'
   value is returned by transport.
2) In virtio transport, dequeue callback is called
   everytime when at least one fragment of message is
   received.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  3 +-
 include/net/af_vsock.h                  |  2 +-
 net/vmw_vsock/af_vsock.c                | 33 +++++++++----
 net/vmw_vsock/virtio_transport_common.c | 62 +++++++++++--------------
 4 files changed, 52 insertions(+), 48 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 35d7eedb5e8e..e68b4029f038 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -88,7 +88,8 @@ virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 ssize_t
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
-				   int flags);
+				   int flags,
+				   bool *msg_ready);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 u32 virtio_transport_seqpacket_has_data(struct vsock_sock *vsk);
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index ab207677e0a8..c40d341611b0 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -137,7 +137,7 @@ struct vsock_transport {
 
 	/* SEQ_PACKET. */
 	ssize_t (*seqpacket_dequeue)(struct vsock_sock *vsk, struct msghdr *msg,
-				     int flags);
+				     int flags, bool *msg_ready);
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
 	bool (*seqpacket_allow)(u32 remote_cid);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 3e02cc3b24f8..b66884def8e8 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1881,7 +1881,7 @@ static int vsock_connectible_wait_data(struct sock *sk,
 	err = 0;
 	transport = vsk->transport;
 
-	while ((data = vsock_connectible_has_data(vsk)) == 0) {
+	while ((data = vsock_stream_has_data(vsk)) == 0) {
 		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
 
 		if (sk->sk_err != 0 ||
@@ -2013,6 +2013,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 				     size_t len, int flags)
 {
 	const struct vsock_transport *transport;
+	bool msg_ready;
 	struct vsock_sock *vsk;
 	ssize_t record_len;
 	long timeout;
@@ -2023,23 +2024,36 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	transport = vsk->transport;
 
 	timeout = sock_rcvtimeo(sk, flags & MSG_DONTWAIT);
+	msg_ready = false;
+	record_len = 0;
 
-	err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
-	if (err <= 0)
-		goto out;
+	while (!msg_ready) {
+		ssize_t fragment_len;
+		int intr_err;
 
-	record_len = transport->seqpacket_dequeue(vsk, msg, flags);
+		intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
+		if (intr_err <= 0) {
+			err = intr_err;
+			break;
+		}
 
-	if (record_len < 0) {
-		err = -ENOMEM;
-		goto out;
+		fragment_len = transport->seqpacket_dequeue(vsk, msg, flags, &msg_ready);
+
+		if (fragment_len < 0) {
+			err = -ENOMEM;
+			break;
+		}
+
+		record_len += fragment_len;
 	}
 
 	if (sk->sk_err) {
 		err = -sk->sk_err;
 	} else if (sk->sk_shutdown & RCV_SHUTDOWN) {
 		err = 0;
-	} else {
+	}
+
+	if (msg_ready && !err) {
 		/* User sets MSG_TRUNC, so return real length of
 		 * packet.
 		 */
@@ -2055,7 +2069,6 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 			msg->msg_flags |= MSG_TRUNC;
 	}
 
-out:
 	return err;
 }
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 169ba8b72a63..053bcea1a03f 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -407,58 +407,48 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 
 static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 struct msghdr *msg,
-						 int flags)
+						 int flags,
+						 bool *msg_ready)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
 	struct virtio_vsock_pkt *pkt;
 	int dequeued_len = 0;
 	size_t user_buf_len = msg_data_left(msg);
-	bool msg_ready = false;
 
+	*msg_ready = false;
 	spin_lock_bh(&vvs->rx_lock);
 
-	if (vvs->msg_count == 0) {
-		spin_unlock_bh(&vvs->rx_lock);
-		return 0;
-	}
+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && dequeued_len >= 0) {
+		size_t pkt_len;
+		size_t bytes_to_copy;
 
-	while (!msg_ready) {
 		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
 
-		if (dequeued_len >= 0) {
-			size_t pkt_len;
-			size_t bytes_to_copy;
+		bytes_to_copy = min(user_buf_len, pkt_len);
 
-			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
-			bytes_to_copy = min(user_buf_len, pkt_len);
-
-			if (bytes_to_copy) {
-				int err;
-
-				/* sk_lock is held by caller so no one else can dequeue.
-				 * Unlock rx_lock since memcpy_to_msg() may sleep.
-				 */
-				spin_unlock_bh(&vvs->rx_lock);
+		if (bytes_to_copy) {
+			int err;
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
-				if (err) {
-					/* Copy of message failed. Rest of
-					 * fragments will be freed without copy.
-					 */
-					dequeued_len = err;
-				} else {
-					user_buf_len -= bytes_to_copy;
-				}
+			err = memcpy_to_msg(msg, pkt->buf, bytes_to_copy);
 
-				spin_lock_bh(&vvs->rx_lock);
-			}
+			spin_lock_bh(&vvs->rx_lock);
 
-			if (dequeued_len >= 0)
-				dequeued_len += pkt_len;
+			if (err)
+				dequeued_len = err;
+			else
+				user_buf_len -= bytes_to_copy;
 		}
 
+		if (dequeued_len >= 0)
+			dequeued_len += pkt_len;
+
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
-			msg_ready = true;
+			*msg_ready = true;
 			vvs->msg_count--;
 		}
 
@@ -489,12 +479,12 @@ EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 ssize_t
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
-				   int flags)
+				   int flags, bool *msg_ready)
 {
 	if (flags & MSG_PEEK)
 		return -EOPNOTSUPP;
 
-	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags, msg_ready);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
-- 
2.25.1


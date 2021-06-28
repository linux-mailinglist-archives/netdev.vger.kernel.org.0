Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727E23B5C0B
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbhF1KGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:06:37 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:21393 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbhF1KGe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:06:34 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 492FA763F2;
        Mon, 28 Jun 2021 13:04:07 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874647;
        bh=BL/GEsWADIvZq4LQcS1TfLmKcXVqFvh2F8HkCRIz9Vo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=OWPLn1TZFW0fe1QWhbsPuMW5p1UI1xANWg1tSmHU+e+9NpHRKFQQ7jUEwRmr2vuD8
         1Ft7dZyJ6Bs+FuzqjKzG2sf/npREMnBZ8TLb5WXQ5vkF32bIuehEBdt9AYH3xMZys0
         ysOoB/moKnRPDPuIyMRliz+ykgg9c9fvBFmr6KQXVXo865kJcmnpW1EPKlG0/pQ6/5
         MHW1GwfhHPqa+8kR8eSIQZZkv28TkSFo1bQ8REVXlNAuUljP+sC0ouFdrqB6Tq9ire
         aK3Bd/vAr8x7XjMMo4DZW/K7QPpaanBtoilPRjPavfj0V5o3oOvKDoLq9K+Ji/OahO
         oj6g+u8yZpNiw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1294475B70;
        Mon, 28 Jun 2021 13:04:07 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:04:06 +0300
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
Subject: [RFC PATCH v1 10/16] virtio/vsock: update SEQPACKET dequeue logic
Date:   Mon, 28 Jun 2021 13:03:58 +0300
Message-ID: <20210628100401.571282-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
References: <20210628095959.569772-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/28/2021 09:47:58
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164664 [Jun 28 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/28/2021 09:51:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 28.06.2021 5:59:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/28 08:23:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/28 05:40:00 #16806866
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As message copied by fragments, in addition to EOR met,
dequeue loop iterates until queue will be empty or copy
error found.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  1 -
 net/vmw_vsock/virtio_transport_common.c | 61 ++++++++++---------------
 2 files changed, 25 insertions(+), 37 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 8d34f3d73bbb..7360ab7ea0af 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -36,7 +36,6 @@ struct virtio_vsock_sock {
 	u32 rx_bytes;
 	u32 buf_alloc;
 	struct list_head rx_queue;
-	u32 msg_count;
 };
 
 struct virtio_vsock_pkt {
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9c2bd84ab8e6..5a46c3f94e83 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -407,59 +407,48 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 
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
-			vvs->msg_count--;
+			*msg_ready = true;
 		}
 
 		virtio_transport_dec_rx_pkt(vvs, pkt);
@@ -494,7 +483,7 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 	if (flags & MSG_PEEK)
 		return -EOPNOTSUPP;
 
-	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags);
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, flags, msg_ready);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8238B3B5C12
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 12:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhF1KHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 06:07:12 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:21653 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232804AbhF1KHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 06:07:05 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 6773175B6D;
        Mon, 28 Jun 2021 13:04:37 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624874677;
        bh=BZ3jvjqP0xCXEbI7iayhyYQw7MsrUL69d6g1M8V5buA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=yTxDsPYXj6w27A4gagCsZb80X5LF8N3MsjYL/dGVCCMcQmE69C0//inbM/2DtwK3s
         R1zN/4OomSdIrUIS796TfbjNp8diTOMActuVcn3N3BgVhoE6G5NDXmc/3D8DVz9nvf
         6RDZbE4T/+te/ynJLP44was87X1eI/Ejv4u3SPSyUGCzuXQRu0fIT+ITKscuZNHXh5
         uqRVvGO9Ms6qSf3z8GY1qzBSkDIZSEuYBotKNy60khs97Txg41+ftDW4YQCwYmuJCD
         uVqUvFe26XLymV9P6qJGJXIwWb1/DkKaiihea2AtoYeFKiTqe7qHrkRltj+diMVxy4
         OhyvsE00VdT+A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 24E3B75B2F;
        Mon, 28 Jun 2021 13:04:37 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Mon, 28
 Jun 2021 13:04:36 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 12/16] virtio/vsock: add 'drop until EOR' logic
Date:   Mon, 28 Jun 2021 13:04:29 +0300
Message-ID: <20210628100432.571516-1-arseny.krasnov@kaspersky.com>
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

Data will copied only if 'drop until EOR' mode is disabled, also
if EOR found, 'msg_ready' is set only if we don't have current
message to drop.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  2 ++
 net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 7360ab7ea0af..18a50f64bf54 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -36,6 +36,7 @@ struct virtio_vsock_sock {
 	u32 rx_bytes;
 	u32 buf_alloc;
 	struct list_head rx_queue;
+	bool drop_until_eor;
 };
 
 struct virtio_vsock_pkt {
@@ -89,6 +90,7 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   int flags,
 				   bool *msg_ready);
+void virtio_transport_seqpacket_drop(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5a46c3f94e83..a8f74cc343e4 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -425,7 +425,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
 		pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
 
-		bytes_to_copy = min(user_buf_len, pkt_len);
+		bytes_to_copy = vvs->drop_until_eor ? 0 : min(user_buf_len, pkt_len);
 
 		if (bytes_to_copy) {
 			int err;
@@ -438,17 +438,22 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 
 			spin_lock_bh(&vvs->rx_lock);
 
-			if (err)
+			if (err) {
 				dequeued_len = err;
-			else
+				vvs->drop_until_eor = true;
+			} else {
 				user_buf_len -= bytes_to_copy;
+			}
 		}
 
 		if (dequeued_len >= 0)
 			dequeued_len += pkt_len;
 
 		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
-			*msg_ready = true;
+			if (vvs->drop_until_eor)
+				vvs->drop_until_eor = false;
+			else
+				*msg_ready = true;
 		}
 
 		virtio_transport_dec_rx_pkt(vvs, pkt);
@@ -487,6 +492,16 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+void virtio_transport_seqpacket_drop(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+
+	spin_lock_bh(&vvs->rx_lock);
+	vvs->drop_until_eor = true;
+	spin_unlock_bh(&vvs->rx_lock);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_drop);
+
 int
 virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECCAC3E593D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240180AbhHJLke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:40:34 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:12040 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236424AbhHJLkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 07:40:33 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 0E779520FC9;
        Tue, 10 Aug 2021 14:40:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628595610;
        bh=hjb2uZ2Fjqyy8K7/b3XOw0wHhIoB2WTMVW8sQLvHqZ0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=5KWQPuKnX6AgiV/oyfSycf7M2W+emTU8peNSdado4ufFEUvGZTI8mONBAUfK0+y5n
         Y3xIp37C0iQoUvTsAESHEy9yoBdMdHSrFYEyS3SbuktzAuJf79HdVPY9fbRnvqc+UV
         lBbHz1cf8wyjeHHpsa9x3SluKoD7CEjQLno+iBopeg15eRRtRrczxiG1fm/F/8p+JK
         Mq+8ihM3R5P3J3LHanrUCanknG83VD19FNIu1ZDfG+djweAHcuihgKdzWbQRHTTlmP
         AYm+kN3wkDQjD0IG+FxkP3v/wvcie8FyPDrEzjeaEAPwCWcGEy6i9pvXH6MjtySr/1
         yRkOVQdTMEwBw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B5862520FE1;
        Tue, 10 Aug 2021 14:40:09 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 10
 Aug 2021 14:40:08 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 1/5] virtio/vsock: add 'VIRTIO_VSOCK_SEQ_EOM' bit
Date:   Tue, 10 Aug 2021 14:39:53 +0300
Message-ID: <20210810113956.1214463-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
References: <20210810113901.1214116-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/10/2021 11:22:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165493 [Aug 10 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 454 454 39c6e442fd417993330528e7f9d13ac1bf7fdf8c
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/10/2021 11:24:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 10.08.2021 6:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/10 08:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/10 05:40:00 #17007547
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is used to mark end of messages('EOM' - end of message), while
'VIRIO_VSOCK_SEQ_EOR' is used to pass MSG_EOR. Also rename 'record' to
'message' in implementation as it is different things.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c                   | 12 ++++++------
 include/uapi/linux/virtio_vsock.h       |  3 ++-
 net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f249622ef11b..feaf650affbe 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -178,15 +178,15 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			 * small rx buffers, headers of packets in rx queue are
 			 * created dynamically and are initialized with header
 			 * of current packet(except length). But in case of
-			 * SOCK_SEQPACKET, we also must clear record delimeter
-			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
-			 * packet with delimeter(which marks end of record),
+			 * SOCK_SEQPACKET, we also must clear message delimeter
+			 * bit(VIRTIO_VSOCK_SEQ_EOM). Otherwise, instead of one
+			 * packet with delimeter(which marks end of message),
 			 * there will be sequence of packets with delimeter
 			 * bit set. After initialized header will be copied to
 			 * rx buffer, this bit will be restored.
 			 */
-			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
-				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 				restore_flag = true;
 			}
 		}
@@ -225,7 +225,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 */
 		if (pkt->off < pkt->len) {
 			if (restore_flag)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 3dd3555b2740..64738838bee5 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -97,7 +97,8 @@ enum virtio_vsock_shutdown {
 
 /* VIRTIO_VSOCK_OP_RW flags values */
 enum virtio_vsock_rw {
-	VIRTIO_VSOCK_SEQ_EOR = 1,
+	VIRTIO_VSOCK_SEQ_EOM = 1,
+	VIRTIO_VSOCK_SEQ_EOR = 2,
 };
 
 #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 081e7ae93cb1..4d5a93beceb0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -77,7 +77,7 @@ virtio_transport_alloc_pkt(struct virtio_vsock_pkt_info *info,
 
 		if (msg_data_left(info->msg) == 0 &&
 		    info->type == VIRTIO_VSOCK_TYPE_SEQPACKET)
-			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 	}
 
 	trace_virtio_transport_alloc_pkt(src_cid, src_port,
@@ -457,7 +457,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				dequeued_len += pkt_len;
 		}
 
-		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+		if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
 			msg_ready = true;
 			vvs->msg_count--;
 		}
@@ -1029,7 +1029,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		goto out;
 	}
 
-	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)
 		vvs->msg_count++;
 
 	/* Try to copy small packets into the buffer of last packet queued,
@@ -1044,12 +1044,12 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 
 		/* If there is space in the last packet queued, we copy the
 		 * new packet in its buffer. We avoid this if the last packet
-		 * queued has VIRTIO_VSOCK_SEQ_EOR set, because this is
-		 * delimiter of SEQPACKET record, so 'pkt' is the first packet
-		 * of a new record.
+		 * queued has VIRTIO_VSOCK_SEQ_EOM set, because this is
+		 * delimiter of SEQPACKET message, so 'pkt' is the first packet
+		 * of a new message.
 		 */
 		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
-		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM)) {
 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
 			       pkt->len);
 			last_pkt->len += pkt->len;
-- 
2.25.1


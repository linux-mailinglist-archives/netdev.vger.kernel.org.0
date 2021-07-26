Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACF9A3D63F3
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 18:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239551AbhGZPxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 11:53:22 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:29428 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239532AbhGZPxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 11:53:15 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id C6833520E90;
        Mon, 26 Jul 2021 19:33:33 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1627317213;
        bh=YQJW5NaeQanQlVSQeh/biXwBH47JI/IjG/tWj5YqnQU=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=2jiHiVcCvzNf+pkgjAy5guKiY5Nn0nfATQLJPnQwT0k5pswEi2ezOwKeUH4UyXAWW
         7gyieMiW0po8txinAMowttglZR9KG3FRMGtNGkKzCnhXpku2O744f9J1h2K9eKp43C
         CvVrffA63qr2ddZfToDjDVmUU7/0Lw9CZGDClUfIiZNkSOuokGDLqxSvg/gJVCuq0Y
         ylVAWi/bGSbZruiQmbJ0ZkJoTISQGQrOJcRIg3byHEbrYVLH0oFjZHT3RdNVzhR9Ol
         hkR9MVlL81281gUkZgL3z7ejSDxz7LIdZC2rzXxNshgqLQF0D/2TQX5FUsU1TfdJbm
         ddTGGKO9jll6A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 8173C520E36;
        Mon, 26 Jul 2021 19:33:33 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Mon, 26
 Jul 2021 19:33:33 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v1 2/7] vsock: rename implementation from 'record' to 'message'
Date:   Mon, 26 Jul 2021 19:33:25 +0300
Message-ID: <20210726163328.2589649-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 16:13:33
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165254 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 16:15:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 26.07.2021 14:57:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/26 14:52:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/26 14:01:00 #16958312
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As 'record' is not same as 'message', rename current variables,
comments and defines from 'record' concept to 'message'.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c                   | 18 +++++++++---------
 net/vmw_vsock/virtio_transport_common.c | 14 +++++++-------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index f249622ef11b..3b55de70ac77 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -114,7 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		size_t nbytes;
 		size_t iov_len, payload_len;
 		int head;
-		bool restore_flag = false;
+		bool restore_msg_eom_flag = false;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -178,16 +178,16 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
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
-				restore_flag = true;
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOM) {
+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
+				restore_msg_eom_flag = true;
 			}
 		}
 
@@ -224,8 +224,8 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 * to send it with the next available buffer.
 		 */
 		if (pkt->off < pkt->len) {
-			if (restore_flag)
-				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			if (restore_msg_eom_flag)
+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOM);
 
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 169ba8b72a63..dea564e4b482 100644
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


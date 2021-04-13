Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF22735DF54
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345958AbhDMMrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:47:46 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:58380 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344717AbhDMMq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 08:46:56 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id CD43375F95;
        Tue, 13 Apr 2021 15:46:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1618317988;
        bh=mkCM235Ir6H7UphiUTqd+/Zt/GfM3ovCMsYqQkB+90Q=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Pi16n+eiplL3LSuwxAwYX97Wf6bV0BiOLOLRbnMZy3H7u2hiH71krc+ZFoc69tknR
         dF2FrE6qs2Ex5s7OmEHV9ifgEDZYvV0SeFhcEg9RAY2SDx9YARVEhPaGt3SKg3SHqp
         D+pbaZdg1nE4eM4eEe280Qh+caBh0K9qvHdW+fLTypWIhHXFG39zmHyEvxiGg43R+W
         G2jLDrUQUMapK25H5XQgBFUtBC1141s818zSqMMp0KWhDmvY9/DxknMTJ6HskVYx8K
         VUtKvAv3XvWxQ9pxb7wcm3bcqGhbqCJJ+Cua4/6GJe4l1zC0qrFWc9wdq+bgW7Dcya
         pVeNCHrMZSnkg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 79F8075ED2;
        Tue, 13 Apr 2021 15:46:28 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 13
 Apr 2021 15:46:28 +0300
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
        David Brazdil <dbrazdil@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v8 15/19] vhost/vsock: enable SEQPACKET for transport
Date:   Tue, 13 Apr 2021 15:46:18 +0300
Message-ID: <20210413124620.3405764-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
References: <20210413123954.3396314-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/13/2021 12:36:22
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163057 [Apr 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/13/2021 12:38:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.04.2021 10:53:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/04/13 07:05:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/04/13 03:14:00 #16587160
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes:
1) Ignore of non-stream type of packets.
This adds:
1) Handling of SEQPACKET bit: if guest sets features with this bit cleared,
   then SOCK_SEQPACKET support will be disabled.
2) 'seqpacket_allow()' callback.
3) Handling of SEQ_EOR bit: when vhost places data in buffers of guest's
   rx queue, keep this bit set only when last piece of data is copied.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
v7 -> v8:
 - This patch merged with patch which adds SEQPACKET feature bit to
   virtio transport.
 - It now handles VIRTIO_VSOCK_SEQ_EOR bit(see commit msg).

 drivers/vhost/vsock.c | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..0969cdc87830 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -31,7 +31,8 @@
 
 enum {
 	VHOST_VSOCK_FEATURES = VHOST_FEATURES |
-			       (1ULL << VIRTIO_F_ACCESS_PLATFORM)
+			       (1ULL << VIRTIO_F_ACCESS_PLATFORM) |
+			       (1ULL << VIRTIO_VSOCK_F_SEQPACKET)
 };
 
 enum {
@@ -112,6 +113,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		size_t nbytes;
 		size_t iov_len, payload_len;
 		int head;
+		bool restore_flag = false;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -174,6 +176,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		/* Set the correct length in the header */
 		pkt->hdr.len = cpu_to_le32(payload_len);
 
+		if (pkt->off + payload_len < pkt->len &&
+		    pkt->hdr.flags & VIRTIO_VSOCK_SEQ_EOR) {
+			pkt->hdr.flags &= ~VIRTIO_VSOCK_SEQ_EOR;
+			restore_flag = true;
+		}
+
 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
 		if (nbytes != sizeof(pkt->hdr)) {
 			virtio_transport_free_pkt(pkt);
@@ -181,6 +189,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
+		if (restore_flag)
+			pkt->hdr.flags |= VIRTIO_VSOCK_SEQ_EOR;
+
 		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
 				      &iov_iter);
 		if (nbytes != payload_len) {
@@ -354,8 +365,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
-		pkt->len = le32_to_cpu(pkt->hdr.len);
+	pkt->len = le32_to_cpu(pkt->hdr.len);
 
 	/* No payload */
 	if (!pkt->len)
@@ -398,6 +408,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_seqpacket_allow(void);
+
 static struct virtio_transport vhost_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -424,6 +436,10 @@ static struct virtio_transport vhost_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -439,8 +455,14 @@ static struct virtio_transport vhost_transport = {
 	},
 
 	.send_pkt = vhost_transport_send_pkt,
+	.seqpacket_allow = false
 };
 
+static bool vhost_transport_seqpacket_allow(void)
+{
+	return vhost_transport.seqpacket_allow;
+}
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -785,6 +807,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
+		vhost_transport.seqpacket_allow = true;
+
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
 		mutex_lock(&vq->mutex);
-- 
2.25.1


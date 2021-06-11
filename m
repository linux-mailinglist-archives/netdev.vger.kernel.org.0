Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0400D3A410A
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbhFKLQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:16:18 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:37151 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbhFKLPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:15:52 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 5120C76514;
        Fri, 11 Jun 2021 14:13:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623410026;
        bh=OabXEnj7Na4Od7ykCv4uydBkaiD8+OLWbL2iRW11akM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=jfI6w5fWhyD2KFjMxSj8CiN3lsiOAk6rhqkxASguxlRyMpSOJXh9R7nz0U5BUTQmu
         TuDTKGlfWSIkodGv88LDm1zBGX8cv3XFbAxwxwHysxLZg4nL5I56apExNLy6PQBF47
         3VkCX3hHZyJmBtqv7ylbqockAQ2GC/w9+UbFbYOgjlhO2UHKySUkRkRk4dD2xUlfxO
         nqxn5FzRKJvHYB2Ho6eIvpoLaXoY9yBQAhc5pc1AMmGExuK0D55Zb2BLrBb3BJswLk
         2JCd0HFWujXhKNRcmllJyKW6Zrp9DRkoLwtjoeuUmg9TIyqYGqBWqzDJACoURW1/J3
         cdDN4jUn2SSBA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 0B45876521;
        Fri, 11 Jun 2021 14:13:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:13:45 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v11 15/18] vhost/vsock: support SEQPACKET for transport
Date:   Fri, 11 Jun 2021 14:13:37 +0300
Message-ID: <20210611111340.3652727-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When received packet is copied to guests's rx queue, data buffers
of rx queue could be smaller that data buffer of input packet, so
data of input packet is copied to each rx buffer, thus each rx
buffer will be a packet with dynamically created header. Fields
of such header are initialized from header of input packet(except
length field which value is depends on number of bytes copied to
rx buffer). But in SEQPACKET case, we also need to take care of
record delimeter bit: if input packet has this bit set, we don't
copy it to header of packet in rx buffer, except case when such
rx buffer is last part of input packet. Otherwise, we will get
sequence of packets with delimeter bit set, thus braking record
bounds.
Also remove ignore of non-stream type of packets, handle SEQPACKET
feature bit.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) Large comment added to describe idea of patch.
 2) Comment message updated.
 3) 'seqpacket_has_data()' callback set.

 drivers/vhost/vsock.c | 56 +++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..119f08491d3c 100644
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
@@ -56,6 +57,7 @@ struct vhost_vsock {
 	atomic_t queued_replies;
 
 	u32 guest_cid;
+	bool seqpacket_allow;
 };
 
 static u32 vhost_transport_get_local_cid(void)
@@ -112,6 +114,7 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		size_t nbytes;
 		size_t iov_len, payload_len;
 		int head;
+		bool restore_flag = false;
 
 		spin_lock_bh(&vsock->send_pkt_list_lock);
 		if (list_empty(&vsock->send_pkt_list)) {
@@ -168,9 +171,26 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		/* If the packet is greater than the space available in the
 		 * buffer, we split it using multiple buffers.
 		 */
-		if (payload_len > iov_len - sizeof(pkt->hdr))
+		if (payload_len > iov_len - sizeof(pkt->hdr)) {
 			payload_len = iov_len - sizeof(pkt->hdr);
 
+			/* As we are copying pieces of large packet's buffer to
+			 * small rx buffers, headers of packets in rx queue are
+			 * created dynamically and are initialized with header
+			 * of current packet(except length). But in case of
+			 * SOCK_SEQPACKET, we also must clear record delimeter
+			 * bit(VIRTIO_VSOCK_SEQ_EOR). Otherwise, instead of one
+			 * packet with delimeter(which marks end of record),
+			 * there will be sequence of packets with delimeter
+			 * bit set. After initialized header will be copied to
+			 * rx buffer, this bit will be restored.
+			 */
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+				pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+				restore_flag = true;
+			}
+		}
+
 		/* Set the correct length in the header */
 		pkt->hdr.len = cpu_to_le32(payload_len);
 
@@ -204,6 +224,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		 * to send it with the next available buffer.
 		 */
 		if (pkt->off < pkt->len) {
+			if (restore_flag)
+				pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+
 			/* We are queueing the same virtio_vsock_pkt to handle
 			 * the remaining bytes, and we want to deliver it
 			 * to monitoring devices in the next iteration.
@@ -354,8 +377,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
-		pkt->len = le32_to_cpu(pkt->hdr.len);
+	pkt->len = le32_to_cpu(pkt->hdr.len);
 
 	/* No payload */
 	if (!pkt->len)
@@ -398,6 +420,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_seqpacket_allow(u32 remote_cid);
+
 static struct virtio_transport vhost_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -424,6 +448,11 @@ static struct virtio_transport vhost_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
+		.seqpacket_has_data       = virtio_transport_seqpacket_has_data,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -441,6 +470,22 @@ static struct virtio_transport vhost_transport = {
 	.send_pkt = vhost_transport_send_pkt,
 };
 
+static bool vhost_transport_seqpacket_allow(u32 remote_cid)
+{
+	struct vhost_vsock *vsock;
+	bool seqpacket_allow = false;
+
+	rcu_read_lock();
+	vsock = vhost_vsock_get(remote_cid);
+
+	if (vsock)
+		seqpacket_allow = vsock->seqpacket_allow;
+
+	rcu_read_unlock();
+
+	return seqpacket_allow;
+}
+
 static void vhost_vsock_handle_tx_kick(struct vhost_work *work)
 {
 	struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
@@ -785,6 +830,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
 			goto err;
 	}
 
+	if (features & (1ULL << VIRTIO_VSOCK_F_SEQPACKET))
+		vsock->seqpacket_allow = true;
+
 	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++) {
 		vq = &vsock->vqs[i];
 		mutex_lock(&vq->mutex);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63837732C
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhEHQhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 12:37:55 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:45317 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhEHQhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 12:37:45 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 54F7E76F14;
        Sat,  8 May 2021 19:36:40 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620491800;
        bh=DzbPS2lNIsA+0+HOVt3X+4bx9K5W7FSMYQ08stgbMLw=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=bt/CFRubbtZphqs3HBJ6GknrrTLXrWpCcpgQPVBVytcT/lt5YJCpM5PnEpW4yjNCJ
         eIhLKtEyVT+SRH+Px0ZsYoN3gcvn8vLUr0NKuB5wxBC/whjsZGfkt+LKyXTCmR4k0z
         6MvYv5mZSnIWjSmsupOqaRa4tGBlJ8uC48mhW3obAr9jZaz9RTqmWiEnV6eCZCkXIm
         +ygfJ04ZFFB8+0KqUYJTktPdmR6XQr6xDnDThWKCRIpSicKw3gLRzajQc1NItybJEC
         tafejADBKbC5LeVShRQ9PNwGo+0g1q34Di7OwS26MdAh1qI/5XuZQylQFE4b7fmsXX
         SmcVIXHd5xAPg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1013E76F20;
        Sat,  8 May 2021 19:36:40 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sat, 8 May
 2021 19:36:39 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v9 15/19] vhost/vsock: enable SEQPACKET for transport
Date:   Sat, 8 May 2021 19:36:31 +0300
Message-ID: <20210508163634.3432505-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/08/2021 16:27:11
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163552 [May 08 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/08/2021 16:29:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 08.05.2021 12:32:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/08 15:50:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/08 12:32:00 #16600610
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
 v8 -> v9:
 1) Move 'seqpacket_allow' to 'struct vhost_vsock'.
 2) Use cpu_to_le32()/le32_to_cpu() to work with 'flags' of packet.

 drivers/vhost/vsock.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index 5e78fb719602..3395b25d4a35 100644
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
@@ -174,6 +177,12 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 		/* Set the correct length in the header */
 		pkt->hdr.len = cpu_to_le32(payload_len);
 
+		if (pkt->off + payload_len < pkt->len &&
+		    le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR) {
+			pkt->hdr.flags &= ~cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+			restore_flag = true;
+		}
+
 		nbytes = copy_to_iter(&pkt->hdr, sizeof(pkt->hdr), &iov_iter);
 		if (nbytes != sizeof(pkt->hdr)) {
 			virtio_transport_free_pkt(pkt);
@@ -181,6 +190,9 @@ vhost_transport_do_send_pkt(struct vhost_vsock *vsock,
 			break;
 		}
 
+		if (restore_flag)
+			pkt->hdr.flags |= cpu_to_le32(VIRTIO_VSOCK_SEQ_EOR);
+
 		nbytes = copy_to_iter(pkt->buf + pkt->off, payload_len,
 				      &iov_iter);
 		if (nbytes != payload_len) {
@@ -354,8 +366,7 @@ vhost_vsock_alloc_pkt(struct vhost_virtqueue *vq,
 		return NULL;
 	}
 
-	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM)
-		pkt->len = le32_to_cpu(pkt->hdr.len);
+	pkt->len = le32_to_cpu(pkt->hdr.len);
 
 	/* No payload */
 	if (!pkt->len)
@@ -398,6 +409,8 @@ static bool vhost_vsock_more_replies(struct vhost_vsock *vsock)
 	return val < vq->num;
 }
 
+static bool vhost_transport_seqpacket_allow(u32 remote_cid);
+
 static struct virtio_transport vhost_transport = {
 	.transport = {
 		.module                   = THIS_MODULE,
@@ -424,6 +437,10 @@ static struct virtio_transport vhost_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
+		.seqpacket_allow          = vhost_transport_seqpacket_allow,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
@@ -441,6 +458,22 @@ static struct virtio_transport vhost_transport = {
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
@@ -785,6 +818,9 @@ static int vhost_vsock_set_features(struct vhost_vsock *vsock, u64 features)
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


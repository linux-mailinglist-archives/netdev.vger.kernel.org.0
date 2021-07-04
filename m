Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258ED3BAC04
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 10:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhGDIN2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 04:13:28 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:54560 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhGDINZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 04:13:25 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 22E387708D;
        Sun,  4 Jul 2021 11:10:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1625386247;
        bh=LQ5uTvlOl/+bUcy/bs3GMRCwmUErv0CHgQSMCFCoSUA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=1gxdhCk/mFXdLBxXlUaMSOpzTAy3l3Wy4i+9q3VqoEueKIuTaBVi5InkiAzb0SC/w
         lpt+WIOv+NFcQSs+kh/KKE+0K+sRnpBLfiL71g8MyIge2jv9ggNaKre5ZAny/flD5+
         NBxTnEbaM7y0ZBnlzoq+BAR1RpTAaAuepVUQWYbhmMaImMoNLwSiR/zMDOSAFw2xDf
         E9w1gTmFUMg2Abj30FAan5SsfoAKQzYPT1cHhZfLzf7AXVF57RMxps+NiLEfzYKJkd
         zAJtUBefVxVLBQPKYl02E7mzoDyvEFLj/zZBq4DN611YuxR3kptZzm9RWkLyoqxicD
         Kt7UgLb6KiZxQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id DF3B9770D4;
        Sun,  4 Jul 2021 11:10:46 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Sun, 4
 Jul 2021 11:10:46 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 4/6] af_vsock/virtio/vsock: add 'seqpacket_drop()' callback
Date:   Sun, 4 Jul 2021 11:10:37 +0300
Message-ID: <20210704081040.89567-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
References: <20210704080820.88746-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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

Add special callback for SEQPACKET socket which is called when
we need to drop current in-progress record: part of record was
copied successfully, reader wait rest of record, but signal
interrupts it and reader leaves it's loop, leaving packets of
current record still in queue. So to avoid copy of "orphaned"
record, we tell transport to drop every packet until EOR will
be found.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 drivers/vhost/vsock.c                   |  1 +
 include/linux/virtio_vsock.h            |  2 ++
 include/net/af_vsock.h                  |  1 +
 net/vmw_vsock/af_vsock.c                |  1 +
 net/vmw_vsock/virtio_transport.c        |  1 +
 net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++++++++++----
 net/vmw_vsock/vsock_loopback.c          |  1 +
 7 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
index c9713d8db0f4..731b9fe07cd3 100644
--- a/drivers/vhost/vsock.c
+++ b/drivers/vhost/vsock.c
@@ -447,6 +447,7 @@ static struct virtio_transport vhost_transport = {
 		.stream_rcvhiwat          = virtio_transport_stream_rcvhiwat,
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
+		.seqpacket_drop           = virtio_transport_seqpacket_drop,
 
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
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
 
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 1747c0b564ef..356878aabbd4 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -141,6 +141,7 @@ struct vsock_transport {
 	int (*seqpacket_enqueue)(struct vsock_sock *vsk, struct msghdr *msg,
 				 size_t len);
 	bool (*seqpacket_allow)(u32 remote_cid);
+	void (*seqpacket_drop)(struct vsock_sock *vsk);
 
 	/* Notification. */
 	int (*notify_poll_in)(struct vsock_sock *, size_t, bool *);
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 87955f9ff065..380a90c758c4 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2024,6 +2024,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 		intr_err = vsock_connectible_wait_data(sk, &wait, timeout, NULL, 0);
 		if (intr_err <= 0) {
 			err = intr_err;
+			transport->seqpacket_drop(vsk);
 			break;
 		}
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2a7c56fcb062..2f7d54071ee2 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -475,6 +475,7 @@ static struct virtio_transport virtio_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = virtio_transport_seqpacket_allow,
+		.seqpacket_drop           = virtio_transport_seqpacket_drop,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index ce67cf449ef8..52765754edcd 100644
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
diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 809f807d0710..d9030a46e4b9 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -94,6 +94,7 @@ static struct virtio_transport loopback_transport = {
 		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
 		.seqpacket_enqueue        = virtio_transport_seqpacket_enqueue,
 		.seqpacket_allow          = vsock_loopback_seqpacket_allow,
+		.seqpacket_drop           = virtio_transport_seqpacket_drop,
 
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
-- 
2.25.1


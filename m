Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23FA2F7283
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:45:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732334AbhAOFp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:45:29 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:62065 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726641AbhAOFpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:45:21 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 2BB6475B8A;
        Fri, 15 Jan 2021 08:44:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689472;
        bh=EeQgrVe/SVCrAdkDlI1JYIF1hIlLpeml3jvxiXTrhjA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Gv/mSxPq5S29Br957U301Ro4f6dzh3ck/5LBe5ALdX5xifMCym/A2A13PLNjx8rJk
         Iu3PC4jH+C+YIZz3CADH2ALb7/8rx+A6bLNwfwc/CHn7hGMtZWm5n9GhnjxCq9g5U5
         lBHYi7OJF89Fr34wqUUKu/mLVXECYPMg+q/hd3j8=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id DB08B75952;
        Fri, 15 Jan 2021 08:44:31 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:44:31 +0300
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
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 11/13] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Fri, 15 Jan 2021 08:44:22 +0300
Message-ID: <20210115054426.1457041-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 01/15/2021 05:18:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161159 [Jan 15 2021]
X-KSE-AntiSpam-Info: LuaCore: 420 420 0b339e70b2b1bb108f53ec9b40aa316bba18ceea
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 01/15/2021 05:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 15.01.2021 2:12:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/01/15 05:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/01/15 02:12:00 #16041563
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rest of logic for SEQPACKET:
1) Shared functions for packet sending now set valid type of packet
   according socket type.
2) SEQPACKET specific function like SEQ_BEGIN send and data dequeue.
3) Ops for virtio transport.
4) TAP support for SEQPACKET is not so easy if it is necessary to send
   whole record to TAP interface. This could be done by allocating
   new packet when whole record is received, data of record must be
   copied to TAP packet.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  7 ++++
 net/vmw_vsock/virtio_transport.c        |  4 ++
 net/vmw_vsock/virtio_transport_common.c | 54 ++++++++++++++++++++++---
 3 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index af8705ea8b95..ad9783df97c9 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -84,7 +84,14 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len);
 size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len,
+				   int type);
+
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 2700a63ab095..5a7ab1befee8 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -469,6 +469,10 @@ static struct virtio_transport virtio_transport = {
 		.stream_is_active         = virtio_transport_stream_is_active,
 		.stream_allow             = virtio_transport_stream_allow,
 
+		.seqpacket_seq_send_len	  = virtio_transport_seqpacket_seq_send_len,
+		.seqpacket_seq_get_len	  = virtio_transport_seqpacket_seq_get_len,
+		.seqpacket_dequeue        = virtio_transport_seqpacket_dequeue,
+
 		.notify_poll_in           = virtio_transport_notify_poll_in,
 		.notify_poll_out          = virtio_transport_notify_poll_out,
 		.notify_recv_init         = virtio_transport_notify_recv_init,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index c3e07eb1c666..5fdf1adfdaab 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -139,6 +139,7 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 		break;
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
 		break;
 	default:
@@ -157,6 +158,10 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 
 void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
 {
+	/* TODO: implement tap support for SOCK_SEQPACKET. */
+	if (le32_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_SEQPACKET)
+		return;
+
 	if (pkt->tap_delivered)
 		return;
 
@@ -405,6 +410,19 @@ static u16 virtio_transport_get_type(struct sock *sk)
 		return VIRTIO_VSOCK_TYPE_SEQPACKET;
 }
 
+bool virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len)
+{
+	struct virtio_vsock_pkt_info info = {
+		.type = VIRTIO_VSOCK_TYPE_SEQPACKET,
+		.op = VIRTIO_VSOCK_OP_SEQ_BEGIN,
+		.vsk = vsk,
+		.flags = len
+	};
+
+	return virtio_transport_send_pkt_info(vsk, &info);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_len);
+
 static inline void virtio_transport_del_n_free_pkt(struct virtio_vsock_pkt *pkt)
 {
 	list_del(&pkt->list);
@@ -576,6 +594,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 
+ssize_t
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len, int flags)
+{
+	if (flags & MSG_PEEK)
+		return -EOPNOTSUPP;
+
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, len);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -659,13 +689,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
 void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
+	int type;
 
 	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
 		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
 	vvs->buf_alloc = *val;
 
-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
+	type = virtio_transport_get_type(sk_vsock(vsk));
+	virtio_transport_send_credit_update(vsk, type,
 					    NULL);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
@@ -793,10 +825,11 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.vsk = vsk,
 	};
 
+	info.type = virtio_transport_get_type(sk_vsock(vsk));
+
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_connect);
@@ -805,7 +838,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.flags = (mode & RCV_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
 			 (mode & SEND_SHUTDOWN ?
@@ -813,6 +845,8 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 		.vsk = vsk,
 	};
 
+	info.type = virtio_transport_get_type(sk_vsock(vsk));
+
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_shutdown);
@@ -834,12 +868,18 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RW,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
+		.flags = 0,
 	};
 
+	info.type = virtio_transport_get_type(sk_vsock(vsk));
+
+	if (info.type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
+	    msg->msg_flags & MSG_EOR)
+		info.flags |= VIRTIO_VSOCK_RW_EOR;
+
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_enqueue);
@@ -857,7 +897,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.reply = !!pkt,
 		.vsk = vsk,
 	};
@@ -866,6 +905,8 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 	if (pkt && le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_RST)
 		return 0;
 
+	info.type = virtio_transport_get_type(sk_vsock(vsk));
+
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 
@@ -1177,13 +1218,14 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RESPONSE,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
 		.reply = true,
 		.vsk = vsk,
 	};
 
+	info.type = virtio_transport_get_type(sk_vsock(vsk));
+
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 
-- 
2.25.1


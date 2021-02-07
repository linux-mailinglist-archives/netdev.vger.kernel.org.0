Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2151431252C
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhBGPVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:21:46 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:13559 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhBGPTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:19:07 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 7484C7601B;
        Sun,  7 Feb 2021 18:17:55 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612711075;
        bh=lo9wjvmBPa1l8FqAvKBOuMpQM5ZyAazYTHeoXC/SuV4=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=KgIiN28YHO3xEwGAAYe0XSo3UqPawGxN22RTQm9D09srAM7ZTwsEdsz2rTNdT+4TV
         ZUIR8FRZ+ciT0csuV7n/nhDcJWvH+8DDXcYL9yrsseAh5IITZLX0xBL2mZMVonJXES
         2aPwNRMh82elap79BdOefPsUBTxpygGnkSc72slc=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 3CC997601C;
        Sun,  7 Feb 2021 18:17:55 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:17:54 +0300
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
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 12/17] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Sun, 7 Feb 2021 18:17:44 +0300
Message-ID: <20210207151747.805754-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.16, Database issued on: 02/06/2021 23:52:08
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 161679 [Feb 06 2021]
X-KSE-AntiSpam-Info: LuaCore: 422 422 763e61bea9fcfcd94e075081cb96e065bc0509b4
X-KSE-AntiSpam-Info: Version: 5.9.16.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_date, moscow}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 02/06/2021 23:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 2/6/2021 9:17:00 PM
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/07 14:21:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/07 10:49:00 #16133380
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rest of logic for SEQPACKET:
1) Packet's type is now set in 'virtio_send_pkt_info()' using
   type of socket.
2) SEQPACKET specific functions which send SEQ_BEGIN/SEQ_END.
   Note that both functions may sleep to wait enough space for
   SEQPACKET header.
3) SEQ_BEGIN/SEQ_END to TAP packet capture.
4) Send SHUTDOWN on socket close for SEQPACKET type.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  9 +++
 net/vmw_vsock/virtio_transport_common.c | 99 +++++++++++++++++++++----
 2 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index a5e8681bfc6a..c4a39424686d 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -41,6 +41,7 @@ struct virtio_vsock_sock {
 	u32 user_read_seq_len;
 	u32 user_read_copied;
 	u32 curr_rx_msg_cnt;
+	u32 next_tx_msg_cnt;
 };
 
 struct virtio_vsock_pkt {
@@ -85,7 +86,15 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+int virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len, int flags);
+int virtio_transport_seqpacket_seq_send_eor(struct vsock_sock *vsk, int flags);
 size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
+int
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags,
+				   bool *msg_ready);
+
 s64 virtio_transport_stream_has_data(struct vsock_sock *vsk);
 s64 virtio_transport_stream_has_space(struct vsock_sock *vsk);
 
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 51b66f8dd7c7..0aa0fd33e9d6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -139,6 +139,8 @@ static struct sk_buff *virtio_transport_build_skb(void *opaque)
 		break;
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
 	case VIRTIO_VSOCK_OP_CREDIT_REQUEST:
+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
+	case VIRTIO_VSOCK_OP_SEQ_END:
 		hdr->op = cpu_to_le16(AF_VSOCK_OP_CONTROL);
 		break;
 	default:
@@ -165,6 +167,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
 }
 EXPORT_SYMBOL_GPL(virtio_transport_deliver_tap_pkt);
 
+static u16 virtio_transport_get_type(struct sock *sk)
+{
+	if (sk->sk_type == SOCK_STREAM)
+		return VIRTIO_VSOCK_TYPE_STREAM;
+	else
+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
+}
+
 /* This function can only be used on connecting/connected sockets,
  * since a socket assigned to a transport is required.
  *
@@ -179,6 +189,13 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
+
+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
+	    info->msg &&
+	    info->msg->msg_flags & MSG_EOR)
+		info->flags |= VIRTIO_VSOCK_RW_EOR;
+
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
 		return -EFAULT;
@@ -397,13 +414,61 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
-static u16 virtio_transport_get_type(struct sock *sk)
+static int virtio_transport_seqpacket_send_ctrl(struct vsock_sock *vsk,
+						int type,
+						size_t len,
+						int flags)
 {
-	if (sk->sk_type == SOCK_STREAM)
-		return VIRTIO_VSOCK_TYPE_STREAM;
-	else
-		return VIRTIO_VSOCK_TYPE_SEQPACKET;
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt_info info = {
+		.op = type,
+		.vsk = vsk,
+		.pkt_len = sizeof(struct virtio_vsock_seq_hdr)
+	};
+
+	struct virtio_vsock_seq_hdr seq_hdr = {
+		.msg_cnt = vvs->next_tx_msg_cnt,
+		.msg_len = len
+	};
+
+	struct kvec seq_hdr_kiov = {
+		.iov_base = (void *)&seq_hdr,
+		.iov_len = sizeof(struct virtio_vsock_seq_hdr)
+	};
+
+	struct msghdr msg = {0};
+
+	//XXX: do we need 'vsock_transport_send_notify_data' pointer?
+	if (vsock_wait_space(sk_vsock(vsk),
+			     sizeof(struct virtio_vsock_seq_hdr),
+			     flags, NULL))
+		return -1;
+
+	iov_iter_kvec(&msg.msg_iter, WRITE, &seq_hdr_kiov, 1, sizeof(seq_hdr));
+
+	info.msg = &msg;
+	vvs->next_tx_msg_cnt++;
+
+	return virtio_transport_send_pkt_info(vsk, &info);
+}
+
+int virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len, int flags)
+{
+	return virtio_transport_seqpacket_send_ctrl(vsk,
+						    VIRTIO_VSOCK_OP_SEQ_BEGIN,
+						    len,
+						    flags);
 }
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_len);
+
+int virtio_transport_seqpacket_seq_send_eor(struct vsock_sock *vsk, int flags)
+{
+	return virtio_transport_seqpacket_send_ctrl(vsk,
+						    VIRTIO_VSOCK_OP_SEQ_END,
+						    0,
+						    flags);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_send_eor);
 
 static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
 {
@@ -577,6 +642,18 @@ virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_stream_dequeue);
 
+int
+virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags, bool *msg_ready)
+{
+	if (flags & MSG_PEEK)
+		return -EOPNOTSUPP;
+
+	return virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -658,14 +735,15 @@ EXPORT_SYMBOL_GPL(virtio_transport_do_socket_init);
 void virtio_transport_notify_buffer_size(struct vsock_sock *vsk, u64 *val)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
+	int type;
 
 	if (*val > VIRTIO_VSOCK_MAX_BUF_SIZE)
 		*val = VIRTIO_VSOCK_MAX_BUF_SIZE;
 
 	vvs->buf_alloc = *val;
 
-	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_STREAM,
-					    NULL);
+	type = virtio_transport_get_type(sk_vsock(vsk));
+	virtio_transport_send_credit_update(vsk, type, NULL);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_notify_buffer_size);
 
@@ -792,7 +870,6 @@ int virtio_transport_connect(struct vsock_sock *vsk)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_REQUEST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.vsk = vsk,
 	};
 
@@ -804,7 +881,6 @@ int virtio_transport_shutdown(struct vsock_sock *vsk, int mode)
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_SHUTDOWN,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.flags = (mode & RCV_SHUTDOWN ?
 			  VIRTIO_VSOCK_SHUTDOWN_RCV : 0) |
 			 (mode & SEND_SHUTDOWN ?
@@ -833,7 +909,6 @@ virtio_transport_stream_enqueue(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RW,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.msg = msg,
 		.pkt_len = len,
 		.vsk = vsk,
@@ -856,7 +931,6 @@ static int virtio_transport_reset(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RST,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.reply = !!pkt,
 		.vsk = vsk,
 	};
@@ -1001,7 +1075,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
@@ -1164,7 +1238,6 @@ virtio_transport_send_response(struct vsock_sock *vsk,
 {
 	struct virtio_vsock_pkt_info info = {
 		.op = VIRTIO_VSOCK_OP_RESPONSE,
-		.type = VIRTIO_VSOCK_TYPE_STREAM,
 		.remote_cid = le64_to_cpu(pkt->hdr.src_cid),
 		.remote_port = le32_to_cpu(pkt->hdr.src_port),
 		.reply = true,
-- 
2.25.1


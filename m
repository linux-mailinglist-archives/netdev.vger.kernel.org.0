Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6B53303A9
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 19:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbhCGSD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:03:26 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:51243 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhCGSDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:03:20 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 3976F521304;
        Sun,  7 Mar 2021 21:03:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615140198;
        bh=xA4tLScICE4WptwfeJ0r8BqaBcNvp6ScNYqK2vsJySo=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=hruHu8eeCxJvekJa8fjCr7u83yHfTZN//yGOMn3EJ684naU2ong4act8KbnEzDKWB
         9AvNfFdWLRF6UAcklUL79dubXdw6F/rXIE1CzZLiej4bwSxVPJt086A3LuKnXTdM8P
         M7cvUg0Z4sXFRAPI5H0hRy1Wh+WqyK37SDYIxLgm4pGlvNNOfvVuWeV1iGcxU0Bdts
         vh1Qb1iy3/nGNPFfYodeyLA7DuetjnqPDxClIT1ggLTHhMB8W2S0fQYpq3hfFt7jG3
         oTfH+vBbw6hrKt3M8hOFuhiYIFwdQPegX1xjl4VNPkaFxWtS17z/HpIhrsN2rsIQtI
         yOK3djWFG8veQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id D37945212FD;
        Sun,  7 Mar 2021 21:03:17 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 7 Mar
 2021 21:03:17 +0300
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
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v6 14/22] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Sun, 7 Mar 2021 21:03:09 +0300
Message-ID: <20210307180312.3466235-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/07/2021 17:49:03
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162254 [Mar 07 2021]
X-KSE-AntiSpam-Info: LuaCore: 431 431 6af1f0c9661e70e28927a654c0fea10ff13ade05
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_MISSED}
X-KSE-AntiSpam-Info: {Macro_DATE_DOUBLE_SPACE}
X-KSE-AntiSpam-Info: {Macro_DATE_MOSCOW}
X-KSE-AntiSpam-Info: {Macro_FROM_DOUBLE_ENG_NAME}
X-KSE-AntiSpam-Info: {Macro_FROM_LOWCAPS_DOUBLE_ENG_NAME_IN_EMAIL}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RU}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RUS_CHARSET}
X-KSE-AntiSpam-Info: {Macro_FROM_REAL_NAME_MATCHES_ALL_USERNAME_PROB}
X-KSE-AntiSpam-Info: {Macro_HEADERS_NOT_LIST}
X-KSE-AntiSpam-Info: {Macro_MAILER_OTHER}
X-KSE-AntiSpam-Info: {Macro_MISC_X_PRIORITY_MISSED}
X-KSE-AntiSpam-Info: {Macro_NO_DKIM}
X-KSE-AntiSpam-Info: {Macro_REPLY_TO_MISSED}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_AT_LEAST_2_WORDS}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_LONG_TEXT}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_5_EMAILS}
X-KSE-AntiSpam-Info: {Macro_TO_CONTAINS_SEVERAL_EMAILS}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/07/2021 17:52:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 07.03.2021 15:50:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/07 17:11:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/07 15:50:00 #16360637
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds rest of logic for SEQPACKET:
1) SEQPACKET specific functions which send SEQ_BEGIN/SEQ_END.
   Note that both functions may sleep to wait enough space for
   SEQPACKET header.
2) SEQ_BEGIN/SEQ_END in TAP packet capture.
3) Send SHUTDOWN on socket close for SEQPACKET type.
4) Set SEQPACKET packet type during send.
5) Set MSG_EOR in flags for SEQPACKET during send.
6) 'seqpacket_allow' flag to virtio transport.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  8 +++
 net/vmw_vsock/virtio_transport_common.c | 87 ++++++++++++++++++++++++-
 2 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index d7edcfeb4cd2..6b45a8b98226 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -22,6 +22,7 @@ struct virtio_vsock_seqpack_state {
 	u32 user_read_seq_len;
 	u32 user_read_copied;
 	u32 curr_rx_msg_id;
+	u32 next_tx_msg_id;
 };
 
 /* Per-socket state (accessed via vsk->trans) */
@@ -76,6 +77,8 @@ struct virtio_transport {
 
 	/* Takes ownership of the packet */
 	int (*send_pkt)(struct virtio_vsock_pkt *pkt);
+
+	bool seqpacket_allow;
 };
 
 ssize_t
@@ -90,6 +93,11 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 
 size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
 int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags,
+				   size_t len);
+int
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   int flags,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9d86375935ce..8e9fdd8aba5d 100644
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
@@ -187,7 +189,12 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 	struct virtio_vsock_pkt *pkt;
 	u32 pkt_len = info->pkt_len;
 
-	info->type = VIRTIO_VSOCK_TYPE_STREAM;
+	info->type = virtio_transport_get_type(sk_vsock(vsk));
+
+	if (info->type == VIRTIO_VSOCK_TYPE_SEQPACKET &&
+	    info->msg &&
+	    info->msg->msg_flags & MSG_EOR)
+		info->flags |= VIRTIO_VSOCK_RW_EOR;
 
 	t_ops = virtio_transport_get_ops(vsk);
 	if (unlikely(!t_ops))
@@ -401,6 +408,43 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static int virtio_transport_seqpacket_send_ctrl(struct vsock_sock *vsk,
+						int type,
+						size_t len,
+						int flags)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt_info info = {
+		.op = type,
+		.vsk = vsk,
+		.pkt_len = sizeof(struct virtio_vsock_seq_hdr)
+	};
+
+	struct virtio_vsock_seq_hdr seq_hdr = {
+		.msg_id = cpu_to_le32(vvs->seqpacket_state.next_tx_msg_id),
+		.msg_len = cpu_to_le32(len)
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
+
+	return virtio_transport_send_pkt_info(vsk, &info);
+}
+
 static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
 {
 	list_del(&pkt->list);
@@ -582,6 +626,45 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   int flags,
+				   size_t len)
+{
+	int written;
+
+	if (msg->msg_iter.iov_offset == 0) {
+		/* Send SEQBEGIN. */
+		if (virtio_transport_seqpacket_send_ctrl(vsk,
+							 VIRTIO_VSOCK_OP_SEQ_BEGIN,
+							 len,
+							 flags) < 0)
+			return -1;
+	}
+
+	written = virtio_transport_stream_enqueue(vsk, msg, len);
+
+	if (written < 0)
+		return -1;
+
+	if (msg->msg_iter.count == 0) {
+		struct virtio_vsock_sock *vvs = vsk->trans;
+
+		/* Send SEQEND. */
+		if (virtio_transport_seqpacket_send_ctrl(vsk,
+							 VIRTIO_VSOCK_OP_SEQ_END,
+							 0,
+							 flags) < 0)
+			return -1;
+
+		vvs->seqpacket_state.next_tx_msg_id++;
+	}
+
+	return written;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -1001,7 +1084,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-- 
2.25.1


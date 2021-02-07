Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605CB312523
	for <lists+netdev@lfdr.de>; Sun,  7 Feb 2021 16:21:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbhBGPUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Feb 2021 10:20:39 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:16370 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhBGPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Feb 2021 10:17:59 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 8A5EA520DD1;
        Sun,  7 Feb 2021 18:17:00 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1612711020;
        bh=jy0VEgmXgeL9dk4DUCmK0+ajMZFv0k0UOaUzvYT2VhE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=qy3jGZFAPC3e6OxI5l4KApLNoRQv6ZdrjBPxm72PHEncjTJZvws5QTeARHKWcbW44
         TEnpvQgEUExQvzUCuasxpkB3G/RjX4p2pAvDRY5HhKVa6aGd9WhwEZjYFL0+EdtsPp
         WUGTIRNhtq4DY5tGLqw9JpJLP1T1+8hFkpwwoB6Q=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 1A75F520DB9;
        Sun,  7 Feb 2021 18:17:00 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Sun, 7 Feb
 2021 18:16:59 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v4 09/17] virtio/vsock: dequeue callback for SOCK_SEQPACKET
Date:   Sun, 7 Feb 2021 18:16:46 +0300
Message-ID: <20210207151649.805359-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
References: <20210207151259.803917-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
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

This adds transport callback and it's logic for SEQPACKET dequeue.
Callback fetches RW packets from rx queue of socket until whole record
is copied(if user's buffer is full, user is not woken up). This is done
to not stall sender, because if we wake up user and it leaves syscall,
nobody will send credit update for rest of record, and sender will wait
for next enter of read syscall at receiver's side. So if user buffer is
full, we just send credit update and drop data. If during copy SEQ_BEGIN
was found(and not all data was copied), copying is restarted by reset
user's iov iterator(previous unfinished data is dropped).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |   5 +
 include/uapi/linux/virtio_vsock.h       |  16 ++++
 net/vmw_vsock/virtio_transport_common.c | 120 ++++++++++++++++++++++++
 3 files changed, 141 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index dc636b727179..4d0de3dee9a4 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -36,6 +36,11 @@ struct virtio_vsock_sock {
 	u32 rx_bytes;
 	u32 buf_alloc;
 	struct list_head rx_queue;
+
+	/* For SOCK_SEQPACKET */
+	u32 user_read_seq_len;
+	u32 user_read_copied;
+	u32 curr_rx_msg_cnt;
 };
 
 struct virtio_vsock_pkt {
diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
index 1d57ed3d84d2..cf9c165e5cca 100644
--- a/include/uapi/linux/virtio_vsock.h
+++ b/include/uapi/linux/virtio_vsock.h
@@ -63,8 +63,14 @@ struct virtio_vsock_hdr {
 	__le32	fwd_cnt;
 } __attribute__((packed));
 
+struct virtio_vsock_seq_hdr {
+	__le32  msg_cnt;
+	__le32  msg_len;
+} __attribute__((packed));
+
 enum virtio_vsock_type {
 	VIRTIO_VSOCK_TYPE_STREAM = 1,
+	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
 };
 
 enum virtio_vsock_op {
@@ -83,6 +89,11 @@ enum virtio_vsock_op {
 	VIRTIO_VSOCK_OP_CREDIT_UPDATE = 6,
 	/* Request the peer to send the credit info to us */
 	VIRTIO_VSOCK_OP_CREDIT_REQUEST = 7,
+
+	/* Record begin for SOCK_SEQPACKET */
+	VIRTIO_VSOCK_OP_SEQ_BEGIN = 8,
+	/* Record end for SOCK_SEQPACKET */
+	VIRTIO_VSOCK_OP_SEQ_END = 9,
 };
 
 /* VIRTIO_VSOCK_OP_SHUTDOWN flags values */
@@ -91,4 +102,9 @@ enum virtio_vsock_shutdown {
 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
 };
 
+/* VIRTIO_VSOCK_OP_RW flags values */
+enum virtio_vsock_rw {
+	VIRTIO_VSOCK_RW_EOR = 1,
+};
+
 #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5956939eebb7..4572d01c8ea5 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -397,6 +397,126 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
+{
+	list_del(&pkt->list);
+	virtio_transport_free_pkt(pkt);
+}
+
+static size_t virtio_transport_drop_until_seq_begin(struct virtio_vsock_sock *vvs)
+{
+	struct virtio_vsock_pkt *pkt, *n;
+	size_t bytes_dropped = 0;
+
+	list_for_each_entry_safe(pkt, n, &vvs->rx_queue, list) {
+		if (le16_to_cpu(pkt->hdr.op) == VIRTIO_VSOCK_OP_SEQ_BEGIN)
+			break;
+
+		bytes_dropped += le32_to_cpu(pkt->hdr.len);
+		virtio_transport_dec_rx_pkt(vvs, pkt);
+		virtio_transport_remove_pkt(pkt);
+	}
+
+	return bytes_dropped;
+}
+
+static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
+						 struct msghdr *msg,
+						 bool *msg_ready)
+{
+	struct virtio_vsock_sock *vvs = vsk->trans;
+	struct virtio_vsock_pkt *pkt;
+	int err = 0;
+	size_t user_buf_len = msg->msg_iter.count;
+
+	*msg_ready = false;
+	spin_lock_bh(&vvs->rx_lock);
+
+	while (!*msg_ready && !list_empty(&vvs->rx_queue) && !err) {
+		pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+		switch (le16_to_cpu(pkt->hdr.op)) {
+		case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
+			/* Unexpected 'SEQ_BEGIN' during record copy:
+			 * Leave receive loop, 'EAGAIN' will restart it from
+			 * outer receive loop, packet is still in queue and
+			 * counters are cleared. So in next loop enter,
+			 * 'SEQ_BEGIN' will be dequeued first. User's iov
+			 * iterator will be reset in outer loop. Also
+			 * send credit update, because some bytes could be
+			 * copied. User will never see unfinished record.
+			 */
+			err = -EAGAIN;
+			break;
+		}
+		case VIRTIO_VSOCK_OP_SEQ_END: {
+			struct virtio_vsock_seq_hdr *seq_hdr;
+
+			seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
+			/* First check that whole record is received. */
+
+			if (vvs->user_read_copied != vvs->user_read_seq_len ||
+			    (le32_to_cpu(seq_hdr->msg_cnt) - vvs->curr_rx_msg_cnt) != 1) {
+				/* Tail of current record and head of next missed,
+				 * so this EOR is from next record. Restart receive.
+				 * Current record will be dropped, next headless will
+				 * be dropped on next attempt to get record length.
+				 */
+				err = -EAGAIN;
+			} else {
+				/* Success. */
+				*msg_ready = true;
+			}
+
+			break;
+		}
+		case VIRTIO_VSOCK_OP_RW: {
+			size_t bytes_to_copy;
+			size_t pkt_len;
+
+			pkt_len = (size_t)le32_to_cpu(pkt->hdr.len);
+			bytes_to_copy = min(user_buf_len, pkt_len);
+
+			/* sk_lock is held by caller so no one else can dequeue.
+			 * Unlock rx_lock since memcpy_to_msg() may sleep.
+			 */
+			spin_unlock_bh(&vvs->rx_lock);
+
+			if (memcpy_to_msg(msg, pkt->buf, bytes_to_copy)) {
+				spin_lock_bh(&vvs->rx_lock);
+				err = -EINVAL;
+				break;
+			}
+
+			spin_lock_bh(&vvs->rx_lock);
+			user_buf_len -= bytes_to_copy;
+			vvs->user_read_copied += pkt_len;
+
+			if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_RW_EOR)
+				msg->msg_flags |= MSG_EOR;
+			break;
+		}
+		default:
+			;
+		}
+
+		/* For unexpected 'SEQ_BEGIN', keep such packet in queue,
+		 * but drop any other type of packet.
+		 */
+		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN) {
+			virtio_transport_dec_rx_pkt(vvs, pkt);
+			virtio_transport_remove_pkt(pkt);
+		}
+	}
+
+	spin_unlock_bh(&vvs->rx_lock);
+
+	virtio_transport_send_credit_update(vsk, VIRTIO_VSOCK_TYPE_SEQPACKET,
+					    NULL);
+
+	return err;
+}
+
 ssize_t
 virtio_transport_stream_dequeue(struct vsock_sock *vsk,
 				struct msghdr *msg,
-- 
2.25.1


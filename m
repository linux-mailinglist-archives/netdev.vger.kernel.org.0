Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E535345F35
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhCWNO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:14:29 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:49053 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231684AbhCWNNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:13:44 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 536E85213CF;
        Tue, 23 Mar 2021 16:13:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505222;
        bh=soHyxPut5Lbj6jPtowirynLrFFR6Pw/0R+7EE/cjPFE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=tbWC56Co2AxA1mbOeTVBDT7D51BiojG90flTyXg59MrA2PCryVM+z79Bv4nW6FW2I
         Tu1MIfLIZkap/2hX8JL78MZrun7E5fYOsJezRVbxajaeYhKsH33Sv4ScZnut7JvDes
         NaMUgfg9YvU58FKsV38tx9tQ/eyifhk0cEhDmqM4LqKlDMuSchth1aL7lZfFE8Y+73
         1VUNkOo3h2iVhtHM06fMhAgaBYZPO8zlTGVF+NxK+hDLXSYYsHRdocDGrpKUIWgFtA
         hx0uTYND9BXnuohOvipqfiR5UbxTbS2NVncr76fjzkmGud6RSK7DzPmyqFFjj45fWu
         tU3MOXX9txYlQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 0531E5213DF;
        Tue, 23 Mar 2021 16:13:42 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:13:41 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 14/22] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Tue, 23 Mar 2021 16:13:29 +0300
Message-ID: <20210323131332.2461409-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/23/2021 12:55:25
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 162595 [Mar 23 2021]
X-KSE-AntiSpam-Info: LuaCore: 437 437 85ecb8eec06a7bf2f475f889e784f42bce7b4445
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/23/2021 12:58:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 23.03.2021 11:46:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/23 11:43:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/23 11:40:00 #16480199
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
 v6 -> v7:
 In 'virtio_transport_seqpacket_enqueue()', 'next_tx_msg_id' is updated
 in both cases when message send successfully or error occured.

 include/linux/virtio_vsock.h            |  7 ++
 net/vmw_vsock/virtio_transport_common.c | 88 ++++++++++++++++++++++++-
 2 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 0e3aa395c07c..ab5f56fd7251 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -22,6 +22,7 @@ struct virtio_vsock_seq_state {
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
@@ -89,6 +92,10 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       size_t len, int flags);
 
 int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len);
+int
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
 				   int flags,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index bfe0d7026bf8..01a56c7da8bd 100644
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
+		.msg_id = cpu_to_le32(vvs->seq_state.next_tx_msg_id),
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
@@ -595,6 +639,46 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
 
+int
+virtio_transport_seqpacket_enqueue(struct vsock_sock *vsk,
+				   struct msghdr *msg,
+				   size_t len)
+{
+	int written = -1;
+
+	if (msg->msg_iter.iov_offset == 0) {
+		/* Send SEQBEGIN. */
+		if (virtio_transport_seqpacket_send_ctrl(vsk,
+							 VIRTIO_VSOCK_OP_SEQ_BEGIN,
+							 len,
+							 msg->msg_flags) < 0)
+			goto out;
+	}
+
+	written = virtio_transport_stream_enqueue(vsk, msg, len);
+
+	if (written < 0)
+		goto out;
+
+	if (msg->msg_iter.count == 0) {
+		/* Send SEQEND. */
+		virtio_transport_seqpacket_send_ctrl(vsk,
+						     VIRTIO_VSOCK_OP_SEQ_END,
+						     0,
+						     msg->msg_flags);
+	}
+out:
+	/* Update next id on error or message transmission done. */
+	if (written < 0 || msg->msg_iter.count == 0) {
+		struct virtio_vsock_sock *vvs = vsk->trans;
+
+		vvs->seq_state.next_tx_msg_id++;
+	}
+
+	return written;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_enqueue);
+
 int
 virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
@@ -1014,7 +1098,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-- 
2.25.1


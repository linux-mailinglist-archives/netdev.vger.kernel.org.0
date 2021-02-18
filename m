Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBD31E5F2
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhBRFt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:49:27 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:48822 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbhBRFms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:42:48 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id CCFD37619A;
        Thu, 18 Feb 2021 08:41:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626871;
        bh=+576CvVFqFT7XiZJmRPLSCd2DWH0FO+pcwESh09S8kE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=nykMRIZt2KxVavMZFvAEkIskjVeE0oz9gonDMf3DBJj58ev/4V4itWit0K+y44tcx
         u1dVTbY0ff1h2l52lgkDzZTtTNJ2/NbaH0mB3fhaXS0mtYKkrt60/HalhKdFhohvVA
         Mc00z/EKvJKAfiXbmp+c9ThBdz2fDzeVHY93jRwTrdXU9pCWR1JHsEyWnPz5CloBih
         KxVn1tyIqc8EdmpSVdmc5VL2L1tMnGn1NW4Ajn8/xPHL+UGcPwaMVLcgxGSltOgZV6
         5NAP9sN9kUkqfgg+ll3ioVcYzqfJKu4YqJefSIKm2Ix6bDxJMk2T4EtVaOVz2Tg/2z
         OiaP8qpGAI0Ww==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 1E36E75F50;
        Thu, 18 Feb 2021 08:41:11 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:40:47 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v5 14/19] virtio/vsock: rest of SOCK_SEQPACKET support
Date:   Thu, 18 Feb 2021 08:40:39 +0300
Message-ID: <20210218054042.1068571-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
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
X-KSE-Antivirus-Info: Clean, bases: 06.02.2021 21:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/02/18 04:51:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/02/18 04:31:00 #16269527
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

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  3 ++
 net/vmw_vsock/virtio_transport_common.c | 67 ++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 022667d57884..bf09d9aafa20 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -41,6 +41,7 @@ struct virtio_vsock_sock {
 	u32 user_read_seq_len;
 	u32 user_read_copied;
 	u32 curr_rx_msg_cnt;
+	u32 next_tx_msg_cnt;
 };
 
 struct virtio_vsock_pkt {
@@ -85,6 +86,8 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+int virtio_transport_seqpacket_seq_send_len(struct vsock_sock *vsk, size_t len, int flags);
+int virtio_transport_seqpacket_seq_send_eor(struct vsock_sock *vsk, int flags);
 size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
 int
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 3ca0009c553e..8431d0a891ed 100644
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
@@ -401,6 +408,62 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
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
+		.msg_cnt = cpu_to_le32(vvs->next_tx_msg_cnt),
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
+}
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
+
 static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
 {
 	list_del(&pkt->list);
@@ -999,7 +1062,7 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	if (sk->sk_type == SOCK_STREAM)
+	if (sk->sk_type == SOCK_STREAM || sk->sk_type == SOCK_SEQPACKET)
 		remove_sock = virtio_transport_close(vsk);
 
 	list_for_each_entry_safe(pkt, tmp, &vvs->rx_queue, list) {
-- 
2.25.1


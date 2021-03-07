Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E813303A5
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbhCGSCw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 13:02:52 -0500
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:57845 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232158AbhCGSCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 13:02:43 -0500
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 8BA2077822;
        Sun,  7 Mar 2021 21:02:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1615140161;
        bh=hBXyj1lKZmAOw6GVYbkNSCutI1Kppbm39znGxYY49CA=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=2dZNNdxe8ekqr9yOMvj+jNurjtsM6QPjmIg2l0zUBIGwSbCN6hf+10koYMxdkA5gg
         oYIvAWJ8TuXMdafulvk2jdDf2/eW9qt67jJSbJdVJWVHGqDaWhWM5Xf1VLv9tFT6e2
         mNa2QojLouVkQY8UykhSt6SSAi8LxOQMBcCB4moJLhapFk3BbQLoFfbet7fWJjBlxa
         wpp++eJBMAAvj7BxYmV84OrDR3JxIwUXJnILTr4ZCIOOQeDnxvhwn44L0mY3k8qVCQ
         aRhwN6uuzdyrZ4TIhTuYZz+awl1k2uWWbNQlxeNSBgKDXTHDpJ4wB+Xms0m7vtaCBm
         U3rVfblUZqgXg==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 48D51777F2;
        Sun,  7 Mar 2021 21:02:41 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Sun, 7 Mar
 2021 21:02:40 +0300
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
Subject: [RFC PATCH v6 12/22] virtio/vsock: fetch length for SEQPACKET record
Date:   Sun, 7 Mar 2021 21:02:31 +0300
Message-ID: <20210307180235.3465973-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
References: <20210307175722.3464068-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2
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

This adds transport callback which tries to fetch record begin marker
from socket's rx queue. It is called from af_vsock.c before reading data
packets of record.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 53 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 466a5832d2f5..d7edcfeb4cd2 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -88,6 +88,7 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
 int
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 5f1e283e43f3..6fc78fec41c0 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -399,6 +399,59 @@ static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
 	virtio_transport_free_pkt(pkt);
 }
 
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
+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_seq_hdr *seq_hdr;
+	struct virtio_vsock_sock *vvs;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes_dropped;
+
+	vvs = vsk->trans;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	/* Fetch all orphaned 'RW' packets and send credit update. */
+	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
+
+	if (list_empty(&vvs->rx_queue))
+		goto out;
+
+	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+	vvs->seqpacket_state.user_read_copied = 0;
+
+	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
+	vvs->seqpacket_state.user_read_seq_len = le32_to_cpu(seq_hdr->msg_len);
+	vvs->seqpacket_state.curr_rx_msg_id = le32_to_cpu(seq_hdr->msg_id);
+	virtio_transport_dec_rx_pkt(vvs, pkt);
+	virtio_transport_remove_pkt(pkt);
+out:
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (bytes_dropped)
+		virtio_transport_send_credit_update(vsk);
+
+	return vvs->seqpacket_state.user_read_seq_len;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
+
 static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 struct msghdr *msg,
 						 bool *msg_ready)
-- 
2.25.1


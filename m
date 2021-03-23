Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C6D345F2D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbhCWNOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 09:14:03 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:48701 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbhCWNNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 09:13:11 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id A447C521154;
        Tue, 23 Mar 2021 16:13:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1616505185;
        bh=Sj4HMi5wqo/knBOf/axMpQ9Ft2+J+H77Dm6ahRKzcwQ=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=u+pjX8ZidKjPjs5OisSyl66t3pChzQgFgRUm6qQ9ZiSwhM9JZjsfPkBB6cxBJaMF+
         6LJZIAXA1dSbL9dcrOz2hjBctjClEs4LYdof4KQkw4jw1tkF7TmKnCP07i5vmRNy8J
         iZ+3oQMnXSIZTr8IYBiapIozNIwIJBHYq4bbomMNaGyBP7dOHN88RAB1iPZqcD4srG
         6xqvTdPxZ4eJUTELZUpjwP4FHnRm478q7Qn5Dg043AAyEMarR0bZsa4AzC+OmsvrRG
         JUGfiD7gfLPunqiXxKuhYz6QYOFJFv5t6Xg/vb5+MD6Rd0atie2jzzwQVMPyMyeYUT
         USI1gj2mU/T7A==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 54C5D52110F;
        Tue, 23 Mar 2021 16:13:05 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.129) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 23
 Mar 2021 16:13:04 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Alexander Popov <alex.popov@linux.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <arseny.krasnov@kaspersky.com>,
        <oxffffaa@gmail.com>
Subject: [RFC PATCH v7 12/22] virtio/vsock: fetch length for SEQPACKET record
Date:   Tue, 23 Mar 2021 16:12:55 +0300
Message-ID: <20210323131258.2461163-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.129]
X-ClientProxiedBy: hqmailmbx2.avp.ru (10.64.67.242) To hqmailmbx3.avp.ru
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

This adds transport callback which tries to fetch record begin marker
from socket's rx queue. It is called from af_vsock.c before reading data
packets of record.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v6 -> v7:
 1) Now 'virtio_transport_seqpacket_seq_get_len()' returns 0, if rx
    queue of socket is empty. Else it returns length of current message
    to handle.
 2) If dequeue callback is called, but there is no detected length of
    message to dequeue, EAGAIN is returned, and outer loop restarts
    receiving.

 net/vmw_vsock/virtio_transport_common.c | 61 +++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a8f4326e45e8..41f05034593e 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -399,6 +399,62 @@ static inline void virtio_transport_remove_pkt(struct virtio_vsock_pkt *pkt)
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
+static size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk)
+{
+	struct virtio_vsock_seq_hdr *seq_hdr;
+	struct virtio_vsock_sock *vvs;
+	struct virtio_vsock_pkt *pkt;
+	size_t bytes_dropped = 0;
+
+	vvs = vsk->trans;
+
+	spin_lock_bh(&vvs->rx_lock);
+
+	/* Have some record to process, return it's length. */
+	if (vvs->seq_state.user_read_seq_len)
+		goto out;
+
+	/* Fetch all orphaned 'RW' packets and send credit update. */
+	bytes_dropped = virtio_transport_drop_until_seq_begin(vvs);
+
+	if (list_empty(&vvs->rx_queue))
+		goto out;
+
+	pkt = list_first_entry(&vvs->rx_queue, struct virtio_vsock_pkt, list);
+
+	vvs->seq_state.user_read_copied = 0;
+
+	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
+	vvs->seq_state.user_read_seq_len = le32_to_cpu(seq_hdr->msg_len);
+	vvs->seq_state.curr_rx_msg_id = le32_to_cpu(seq_hdr->msg_id);
+	virtio_transport_dec_rx_pkt(vvs, pkt);
+	virtio_transport_remove_pkt(pkt);
+out:
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (bytes_dropped)
+		virtio_transport_send_credit_update(vsk);
+
+	return vvs->seq_state.user_read_seq_len;
+}
+
 static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 struct msghdr *msg,
 						 bool *msg_ready)
@@ -522,6 +578,11 @@ virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 	if (flags & MSG_PEEK)
 		return -EOPNOTSUPP;
 
+	*msg_len = virtio_transport_seqpacket_seq_get_len(vsk);
+
+	if (*msg_len == 0)
+		return -EAGAIN;
+
 	return virtio_transport_seqpacket_do_dequeue(vsk, msg, msg_ready);
 }
 EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_dequeue);
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2D931E5F3
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhBRFtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:49:33 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:45385 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbhBRFmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:42:46 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id BCCBD521471;
        Thu, 18 Feb 2021 08:40:42 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626842;
        bh=8CMQ5UcYIIPk/Cj3cjoFX25kD++8DHx5H1ojTnmxgTs=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=bUYRwFDQteNOedMey4Vgo2T8Ilf/GGBYdRKDP0F7H+Rua2KcVht3AGXp2Js6GrrCG
         EQdjtgS/62PPjVAWFwRF+NSF+JLiaNOqLKiFGiuBoo3pom3wdiu1keo6TO9HzHA50q
         i59Z8baQNR1Fq5hZaViSQi7ETqLMA2pYiHzq22sAm69y0N5lYzhtSAUJoM/z0qXE4N
         B9FqdvIla3iPuuy4ZOBJOYnAONT1m9emMsUxPb8oAL2ruOrdQsrxJKLHzyf3yxU7kj
         hTWMKyuu1eKA8sPBiZ3QQ7H3dVY/Fj67FoVZUl0OGqGBlvM5A4fH7FlcMGdNwpUAt9
         EQAaeU+LjlH/Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 6424E520D11;
        Thu, 18 Feb 2021 08:40:42 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:40:09 +0300
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
Subject: [RFC PATCH v5 12/19] virtio/vsock: fetch length for SEQPACKET record
Date:   Thu, 18 Feb 2021 08:39:58 +0300
Message-ID: <20210218054001.1068305-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
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

This adds transport callback which tries to fetch record begin marker
from socket's rx queue. It is called from af_vsock.c before reading data
packets of record.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 53 +++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 003d06ae4a85..022667d57884 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -85,6 +85,7 @@ virtio_transport_dgram_dequeue(struct vsock_sock *vsk,
 			       struct msghdr *msg,
 			       size_t len, int flags);
 
+size_t virtio_transport_seqpacket_seq_get_len(struct vsock_sock *vsk);
 int
 virtio_transport_seqpacket_dequeue(struct vsock_sock *vsk,
 				   struct msghdr *msg,
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d8ec2dfa2315..e9a2de72ebbf 100644
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
+	vvs->user_read_copied = 0;
+
+	seq_hdr = (struct virtio_vsock_seq_hdr *)pkt->buf;
+	vvs->user_read_seq_len = le32_to_cpu(seq_hdr->msg_len);
+	vvs->curr_rx_msg_cnt = le32_to_cpu(seq_hdr->msg_cnt);
+	virtio_transport_dec_rx_pkt(vvs, pkt);
+	virtio_transport_remove_pkt(pkt);
+out:
+	spin_unlock_bh(&vvs->rx_lock);
+
+	if (bytes_dropped)
+		virtio_transport_send_credit_update(vsk);
+
+	return vvs->user_read_seq_len;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_seqpacket_seq_get_len);
+
 static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 						 struct msghdr *msg,
 						 bool *msg_ready)
-- 
2.25.1


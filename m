Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DCBF3A4104
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 13:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhFKLPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 07:15:34 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:37012 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231438AbhFKLPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 07:15:18 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 58F0E76521;
        Fri, 11 Jun 2021 14:13:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1623409997;
        bh=Z/ubgElR26UwjGmoq+dEkGhUAsR7aixFbG9HP+oaXU8=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=q5kskV+aZy222Un5u7tceCV0opQUNcR/zEuKKCHEMxz3lus6rZx2B4vURi7O9x5hP
         7C96STGCUEDny8jL3ROvvvVn8X/l/fZBXOZyN76O+trBLFwmFKGIVol6G8BFIxgEC0
         NrL9QumlbxrG3KG3+U0SZDtnIR1tkwDRuq2YBofk5IPgQGBanIK+r6YLON5RB8he8o
         orYCpUevBQJKfUDrau4SHYKzn+wZY48xKDhTGHF1/pDAX25hRNboFgwssjODeEhd7D
         ZCWyLYUU3UK9iaRPJ52mb2+u/I9bMhJQy1wVfBgshE8ekKOorSfmXSsUinAPlQLc8R
         fhtssxZ2XY1Xw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id ADA7575A38;
        Fri, 11 Jun 2021 14:13:16 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 11
 Jun 2021 14:13:01 +0300
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
        <oxffffaa@gmail.com>
Subject: [PATCH v11 12/18] virtio/vsock: add SEQPACKET receive logic
Date:   Fri, 11 Jun 2021 14:12:53 +0300
Message-ID: <20210611111256.3652391-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
References: <20210611110744.3650456-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/11/2021 10:44:49
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164266 [Jun 11 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;arseniy-pc.avp.ru:7.1.1;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/11/2021 10:48:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 11.06.2021 5:31:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/11 09:09:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/10 21:54:00 #16707142
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update current receive logic for SEQPACKET support: performs
check for packet and socket types on receive(if mismatch, then
reset connection). Increment EOR counter on receive. Also if
buffer of new packet was appended to buffer of last packet in
rx queue, update flags of last packet with flags of new packet.

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v10 -> v11:
 1) 'msg_count' processing added.
 2) Comment updated.
 3) Commit message updated.

 net/vmw_vsock/virtio_transport_common.c | 34 ++++++++++++++++++++++---
 1 file changed, 31 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 1e1df19ec164..3a658ff8fccb 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -165,6 +165,14 @@ void virtio_transport_deliver_tap_pkt(struct virtio_vsock_pkt *pkt)
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
@@ -987,6 +995,9 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		goto out;
 	}
 
+	if (le32_to_cpu(pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)
+		vvs->msg_count++;
+
 	/* Try to copy small packets into the buffer of last packet queued,
 	 * to avoid wasting memory queueing the entire buffer with a small
 	 * payload.
@@ -998,13 +1009,18 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 					   struct virtio_vsock_pkt, list);
 
 		/* If there is space in the last packet queued, we copy the
-		 * new packet in its buffer.
+		 * new packet in its buffer. We avoid this if the last packet
+		 * queued has VIRTIO_VSOCK_SEQ_EOR set, because this is
+		 * delimiter of SEQPACKET record, so 'pkt' is the first packet
+		 * of a new record.
 		 */
-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
+		if ((pkt->len <= last_pkt->buf_len - last_pkt->len) &&
+		    !(le32_to_cpu(last_pkt->hdr.flags) & VIRTIO_VSOCK_SEQ_EOR)) {
 			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
 			       pkt->len);
 			last_pkt->len += pkt->len;
 			free_pkt = true;
+			last_pkt->hdr.flags |= pkt->hdr.flags;
 			goto out;
 		}
 	}
@@ -1170,6 +1186,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
 	return 0;
 }
 
+static bool virtio_transport_valid_type(u16 type)
+{
+	return (type == VIRTIO_VSOCK_TYPE_STREAM) ||
+	       (type == VIRTIO_VSOCK_TYPE_SEQPACKET);
+}
+
 /* We are under the virtio-vsock's vsock->rx_lock or vhost-vsock's vq->mutex
  * lock.
  */
@@ -1195,7 +1217,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(pkt->hdr.buf_alloc),
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
@@ -1212,6 +1234,12 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		}
 	}
 
+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
+		(void)virtio_transport_reset_no_sock(t, pkt);
+		sock_put(sk);
+		goto free_pkt;
+	}
+
 	vsk = vsock_sk(sk);
 
 	lock_sock(sk);
-- 
2.25.1


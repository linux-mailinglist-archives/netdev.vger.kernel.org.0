Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45BF2F727F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbhAOFpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:45:16 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:47317 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726433AbhAOFpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:45:05 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id CC9CF520D82;
        Fri, 15 Jan 2021 08:44:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail; t=1610689459;
        bh=VeEJtFfFFvAyU4gRN7UkJiPjTwW5+qY2c3ssMTAi8ic=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Bv1j/U9MSFLhDxRaOgIjK5Rh5AzhLn3aXcPFBisBFeqNUKCu1V9QgRlhIWGi+ErCh
         Zty5IMVhBcaqgdpJK3bsm9LwCTaGtjZtDJENFyD4wfBZO8tYaBOLPzfQsbR1zJxy4h
         8EdUmNgY/6K+hLweNCYvQPMpSl2iudjMyVrx4jK8=
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 71C35520DD4;
        Fri, 15 Jan 2021 08:44:18 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Fri, 15
 Jan 2021 08:44:17 +0300
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arseny Krasnov <arseny.krasnov@kaspersky.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Jeff Vander Stoep <jeffv@google.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stsp2@yandex.ru>, <oxffffaa@gmail.com>
Subject: [RFC PATCH v2 10/13] virtio/vsock: update receive logic
Date:   Fri, 15 Jan 2021 08:44:07 +0300
Message-ID: <20210115054410.1456928-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
References: <20210115053553.1454517-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
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

This modifies current receive logic for SEQPACKET support:
1) Add 'SEQ_BEGIN' packet to socket's rx queue.
2) Add 'RW' packet to rx queue, but without merging inside buffer of last
   packet in queue.
3) Perform check for packet type and socket type on receive(if mismatch,
   then reset connection).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport_common.c | 79 ++++++++++++++++++-------
 1 file changed, 58 insertions(+), 21 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index fe1272e74517..c3e07eb1c666 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -397,6 +397,14 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	return err;
 }
 
+static u16 virtio_transport_get_type(struct sock *sk)
+{
+	if (sk->sk_type == SOCK_STREAM)
+		return VIRTIO_VSOCK_TYPE_STREAM;
+	else
+		return VIRTIO_VSOCK_TYPE_SEQPACKET;
+}
+
 static inline void virtio_transport_del_n_free_pkt(struct virtio_vsock_pkt *pkt)
 {
 	list_del(&pkt->list);
@@ -1050,39 +1058,49 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 			      struct virtio_vsock_pkt *pkt)
 {
 	struct virtio_vsock_sock *vvs = vsk->trans;
-	bool can_enqueue, free_pkt = false;
+	bool free_pkt = false;
 
 	pkt->len = le32_to_cpu(pkt->hdr.len);
 	pkt->off = 0;
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, pkt);
-	if (!can_enqueue) {
+	if (!virtio_transport_inc_rx_pkt(vvs, pkt)) {
 		free_pkt = true;
 		goto out;
 	}
 
-	/* Try to copy small packets into the buffer of last packet queued,
-	 * to avoid wasting memory queueing the entire buffer with a small
-	 * payload.
-	 */
-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
-		struct virtio_vsock_pkt *last_pkt;
+	switch (le32_to_cpu(pkt->hdr.type)) {
+	case VIRTIO_VSOCK_TYPE_STREAM: {
+		/* Try to copy small packets into the buffer of last packet queued,
+		 * to avoid wasting memory queueing the entire buffer with a small
+		 * payload.
+		 */
+		if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
+			struct virtio_vsock_pkt *last_pkt;
 
-		last_pkt = list_last_entry(&vvs->rx_queue,
-					   struct virtio_vsock_pkt, list);
+			last_pkt = list_last_entry(&vvs->rx_queue,
+						   struct virtio_vsock_pkt, list);
 
-		/* If there is space in the last packet queued, we copy the
-		 * new packet in its buffer.
-		 */
-		if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
-			memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
-			       pkt->len);
-			last_pkt->len += pkt->len;
-			free_pkt = true;
-			goto out;
+			/* If there is space in the last packet queued, we copy the
+			 * new packet in its buffer.
+			 */
+			if (pkt->len <= last_pkt->buf_len - last_pkt->len) {
+				memcpy(last_pkt->buf + last_pkt->len, pkt->buf,
+				       pkt->len);
+				last_pkt->len += pkt->len;
+				free_pkt = true;
+				goto out;
+			}
 		}
+
+		break;
+	}
+	case VIRTIO_VSOCK_TYPE_SEQPACKET: {
+		break;
+	}
+	default:
+		goto out;
 	}
 
 	list_add_tail(&pkt->list, &vvs->rx_queue);
@@ -1101,6 +1119,14 @@ virtio_transport_recv_connected(struct sock *sk,
 	int err = 0;
 
 	switch (le16_to_cpu(pkt->hdr.op)) {
+	case VIRTIO_VSOCK_OP_SEQ_BEGIN: {
+		struct virtio_vsock_sock *vvs = vsk->trans;
+
+		spin_lock_bh(&vvs->rx_lock);
+		list_add_tail(&pkt->list, &vvs->rx_queue);
+		spin_unlock_bh(&vvs->rx_lock);
+		return err;
+	}
 	case VIRTIO_VSOCK_OP_RW:
 		virtio_transport_recv_enqueue(vsk, pkt);
 		sk->sk_data_ready(sk);
@@ -1247,6 +1273,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
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
@@ -1272,7 +1304,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(pkt->hdr.buf_alloc),
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
@@ -1289,6 +1321,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		}
 	}
 
+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
+		(void)virtio_transport_reset_no_sock(t, pkt);
+		goto free_pkt;
+	}
+
 	vsk = vsock_sk(sk);
 
 	space_available = virtio_transport_space_update(sk, pkt);
-- 
2.25.1


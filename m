Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FCEB31E5F4
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 06:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbhBRFti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 00:49:38 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:45421 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbhBRFmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 00:42:47 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id BDB8E521626;
        Thu, 18 Feb 2021 08:40:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1613626843;
        bh=1UaZclJz8rZknilH4L9PDdWwUfC6OfW1gmYmfcvSbG0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=0U233typIATypHsFddMdtKfqHppcRRjkmogt9XEWiCo6ZXeK+uGAcviQYg8zunv6g
         VCeCrMd9SISCzXuPBCLuujdLaKdxQjsou8MDUU4RoDIwHFwciBvjEG+jI4q6yQq7HC
         SgRs91iO16lHkmSOLPx81s2fq1asDNHcD7ZvhW1a6ROck0qLeP10zxOVvY55Zq7NKW
         XjhasmQAhKypufSxZlXxkJvYO5h2242TZ85hOr9EKoqmJaCps7ukLkAF+3CpZnbQsQ
         +cfjMdOk2EA3It/CYJ8BzaoPrwWS4jH6EhNNpDJfhwUSKE0zQck3f3lYL22RM/1O2o
         OCVY8sqzGjCqA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id B9476521395;
        Thu, 18 Feb 2021 08:40:42 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Thu, 18
 Feb 2021 08:40:30 +0300
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
Subject: [RFC PATCH v5 13/19] virtio/vsock: add SEQPACKET receive logic
Date:   Thu, 18 Feb 2021 08:40:16 +0300
Message-ID: <20210218054019.1068430-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
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

This modifies current receive logic for SEQPACKET support:
1) Inserts 'SEQ_BEGIN' packet to socket's rx queue.
2) Inserts 'RW' packet to socket's rx queue, but without merging with
   buffer of last packet in queue.
3) Performs check for packet and socket types on receive(if mismatch,
   then reset connection).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 net/vmw_vsock/virtio_transport_common.c | 63 +++++++++++++++++--------
 1 file changed, 44 insertions(+), 19 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index e9a2de72ebbf..3ca0009c553e 100644
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
@@ -1060,25 +1068,27 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 		goto out;
 	}
 
-	/* Try to copy small packets into the buffer of last packet queued,
-	 * to avoid wasting memory queueing the entire buffer with a small
-	 * payload.
-	 */
-	if (pkt->len <= GOOD_COPY_LEN && !list_empty(&vvs->rx_queue)) {
-		struct virtio_vsock_pkt *last_pkt;
+	if (le16_to_cpu(pkt->hdr.type) == VIRTIO_VSOCK_TYPE_STREAM) {
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
 	}
 
@@ -1098,9 +1108,13 @@ virtio_transport_recv_connected(struct sock *sk,
 	int err = 0;
 
 	switch (le16_to_cpu(pkt->hdr.op)) {
+	case VIRTIO_VSOCK_OP_SEQ_BEGIN:
+	case VIRTIO_VSOCK_OP_SEQ_END:
 	case VIRTIO_VSOCK_OP_RW:
 		virtio_transport_recv_enqueue(vsk, pkt);
-		sk->sk_data_ready(sk);
+
+		if (le16_to_cpu(pkt->hdr.op) != VIRTIO_VSOCK_OP_SEQ_BEGIN)
+			sk->sk_data_ready(sk);
 		return err;
 	case VIRTIO_VSOCK_OP_CREDIT_UPDATE:
 		sk->sk_write_space(sk);
@@ -1243,6 +1257,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
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
@@ -1268,7 +1288,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(pkt->hdr.buf_alloc),
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
@@ -1285,6 +1305,11 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 		}
 	}
 
+	if (virtio_transport_get_type(sk) != le16_to_cpu(pkt->hdr.type)) {
+		(void)virtio_transport_reset_no_sock(t, pkt);
+		goto free_pkt;
+	}
+
 	vsk = vsock_sk(sk);
 
 	lock_sock(sk);
-- 
2.25.1


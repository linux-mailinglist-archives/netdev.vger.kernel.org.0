Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC20738B737
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 21:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236421AbhETTUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 15:20:07 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:53799 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239299AbhETTT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 15:19:59 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 8C08E78436;
        Thu, 20 May 2021 22:18:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1621538310;
        bh=h9IadXliHjeByCv8Ry0Yf11FXdP4cd0ZTmmuYhJrPlM=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=C23sB7VMboS57LKroRqkr8suqzg/UdENiNHHNWklv2fCiJIqnkThuvpy96QZgrmHQ
         jbwTsclcqqTLq0V4IIKJVqPb0WO1zGp4ZwU/01dtZ6ZJlLTSheelMCfpE6auV1iyXx
         CJeLVw3Nl/2Ffhp2NF98xOAwkQ+bjpnxykKjL9VQE9KKzKgbpZ4TsvP6dAgCTsK6C2
         BVAJyK8c/Cr9uWS/FXTBqyqDw334m0WvhMlG5dtPXpZ/CGActRoZP6TPO7SDM5RwmC
         pbWEncK9OVMjirakuQXl9zEqsNcaUtoX28F+i9lbLVwnTPYViPj09f9Buy9btrUW4r
         b/+53IfdYLHbQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 5487277F2C;
        Thu, 20 May 2021 22:18:30 +0300 (MSK)
Received: from arseniy-pc.avp.ru (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Thu, 20
 May 2021 22:18:29 +0300
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
        Norbert Slusarek <nslusarek@gmx.net>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <oxffffaa@gmail.com>
Subject: [PATCH v10 12/18] virtio/vsock: add SEQPACKET receive logic
Date:   Thu, 20 May 2021 22:18:21 +0300
Message-ID: <20210520191824.1272172-1-arseny.krasnov@kaspersky.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
References: <20210520191357.1270473-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/20/2021 18:58:27
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 10
X-KSE-AntiSpam-Info: Lua profiles 163818 [May 20 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 446 446 0309aa129ce7cd9d810f87a68320917ac2eba541
X-KSE-AntiSpam-Info: {Prob_from_in_msgid}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: arseniy-pc.avp.ru:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 10
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/20/2021 19:01:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 20.05.2021 14:47:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/20 17:27:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/20 14:47:00 #16622423
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update current receive logic for SEQPACKET support: performs
check for packet and socket types on receive(if mismatch, then
reset connection).

Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
---
 v9 -> v10:
 1) Commit message updated.
 2) Comment updated.
 3) Updated way to to set 'last_pkt' flags.

 net/vmw_vsock/virtio_transport_common.c | 30 ++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 61349b2ea7fe..a6f8b0f39775 100644
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
@@ -979,13 +987,17 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 					   struct virtio_vsock_pkt, list);
 
 		/* If there is space in the last packet queued, we copy the
-		 * new packet in its buffer.
+		 * new packet in its buffer(except SEQPACKET case, when we
+		 * also check that last packet is not last packet of previous
+		 * record).
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
@@ -1151,6 +1163,12 @@ virtio_transport_recv_listen(struct sock *sk, struct virtio_vsock_pkt *pkt,
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
@@ -1176,7 +1194,7 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
 					le32_to_cpu(pkt->hdr.buf_alloc),
 					le32_to_cpu(pkt->hdr.fwd_cnt));
 
-	if (le16_to_cpu(pkt->hdr.type) != VIRTIO_VSOCK_TYPE_STREAM) {
+	if (!virtio_transport_valid_type(le16_to_cpu(pkt->hdr.type))) {
 		(void)virtio_transport_reset_no_sock(t, pkt);
 		goto free_pkt;
 	}
@@ -1193,6 +1211,12 @@ void virtio_transport_recv_pkt(struct virtio_transport *t,
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


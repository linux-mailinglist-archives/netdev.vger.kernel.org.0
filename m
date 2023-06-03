Return-Path: <netdev+bounces-7709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B44C37212E0
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:55:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 377001C209F2
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:55:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EFA1101DD;
	Sat,  3 Jun 2023 20:54:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF39101C5
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:54:54 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26361B3;
	Sat,  3 Jun 2023 13:54:49 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 6A8285FD12;
	Sat,  3 Jun 2023 23:54:46 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825686;
	bh=PDBAwhjzQiqgrPTljhwk+nGe366nkV6M9z7XnlirNW8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=FR3zMR8YRK5GQa6omA48DZfBFK8qiKu7IHMLXkG597CuAn/lHd3aksNa/DAsWDWr3
	 znvKwhkwL/AbKaVCrXJF2979aU1r3E6EitpbU2fSEEVoxRlpMonhjGiFuzC9wHFhz2
	 /MpQ0zde9leqwFIDj761TGWyyfiVehPnTI0QWIfvd/L0NgH/epWKA5ijaU5jjW5AHf
	 UESxZn3ATlwRgymk0Xs2tTknuiMRjVREZamed1vSOjDxuJw05OW4/VIqDMyavuCIzI
	 DmLHG8uP1E+vPCsZc31/nvPA7AwoQcl01X3ZHRbU6/r+nsr4IjIV1cJ+0GyDIT+Rsc
	 FO6W8AEbCuObw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:46 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v4 01/17] vsock/virtio: read data from non-linear skb
Date: Sat, 3 Jun 2023 23:49:23 +0300
Message-ID: <20230603204939.1598818-2-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This is preparation patch for non-linear skbuff handling. It replaces
direct calls of 'memcpy_to_msg()' with 'skb_copy_datagram_iter()'. Main
advantage of the second one is that is can handle paged part of the skb
by using 'kmap()' on each page, but if there are no pages in the skb,
it behaves like simple copying to iov iterator. This patch also adds
new field to the control block of skb - this value shows current offset
in the skb to read next portion of data (it doesn't matter linear it or
not). Idea is that 'skb_copy_datagram_iter()' handles both types of
skb internally - it just needs an offset from which to copy data from
the given skb. This offset is incremented on each read from skb. This
approach allows to avoid special handling of non-linear skbs:
1) We can't call 'skb_pull()' on it, because it updates 'data' pointer.
2) We need to update 'data_len' also on each read from this skb.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/linux/virtio_vsock.h            |  1 +
 net/vmw_vsock/virtio_transport_common.c | 26 +++++++++++++++++--------
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..17dbb7176e37 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,7 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	u32 frag_off;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b769fc258931..5819a9cd4515 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -355,7 +355,7 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 	spin_lock_bh(&vvs->rx_lock);
 
 	skb_queue_walk_safe(&vvs->rx_queue, skb,  tmp) {
-		off = 0;
+		off = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
 
 		if (total == len)
 			break;
@@ -370,7 +370,10 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 			 */
 			spin_unlock_bh(&vvs->rx_lock);
 
-			err = memcpy_to_msg(msg, skb->data + off, bytes);
+			err = skb_copy_datagram_iter(skb, off,
+						     &msg->msg_iter,
+						     bytes);
+
 			if (err)
 				goto out;
 
@@ -414,24 +417,28 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		skb = skb_peek(&vvs->rx_queue);
 
 		bytes = len - total;
-		if (bytes > skb->len)
-			bytes = skb->len;
+		if (bytes > skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off)
+			bytes = skb->len - VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
 
 		/* sk_lock is held by caller so no one else can dequeue.
 		 * Unlock rx_lock since memcpy_to_msg() may sleep.
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		err = skb_copy_datagram_iter(skb,
+					     VIRTIO_VSOCK_SKB_CB(skb)->frag_off,
+					     &msg->msg_iter, bytes);
+
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		skb_pull(skb, bytes);
 
-		if (skb->len == 0) {
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off += bytes;
+
+		if (skb->len == VIRTIO_VSOCK_SKB_CB(skb)->frag_off) {
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 
 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
@@ -503,7 +510,10 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				err = skb_copy_datagram_iter(skb, 0,
+							     &msg->msg_iter,
+							     bytes_to_copy);
+
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
-- 
2.25.1



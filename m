Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAACA6EC1D8
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjDWTba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjDWTb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:26 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17183E63;
        Sun, 23 Apr 2023 12:31:23 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 09AE75FD0B;
        Sun, 23 Apr 2023 22:31:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278279;
        bh=6GXN8Z4A5pzJKwUwAblmfS0l0b76F1IUad3+Vj3aKY0=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=shjYlIjxj3hxvvpP8No56KwLSqVFM8t313Q1+mBmJNJQdBgLY3Oi3yaijVYy6E27f
         t3vBh11K6UBYy9b2OnhUmmehr8/4E5sfctj3W/D2pRoqvTHTRM3lwcoN9gpNp4g2U7
         xrlxvjrjFfXOWam3GK6mqZPBOKEGGga3j7YPBHsUbtxaoI/deDMr436K4+SheZe/MW
         eXmVsPUWh4jspoID9+ew3p0hWmbUIitC9XR9bxfzOYWY88gMszgKEGhPU9j+zovkS6
         +iLCOfnj8nCPIRyiO7HA/leS4h9+s/qVhR9WTvgCz1q0vQuTOqb4Esc8Xc1C9oTpyr
         8WKMRLB4JdofQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:18 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 01/15] vsock/virtio: prepare for non-linear skb support
Date:   Sun, 23 Apr 2023 22:26:29 +0300
Message-ID: <20230423192643.1537470-2-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is preparation patch for non-linear skbuff handling. It does two
things:
1) Handles freeing of non-linear skbuffs.
2) Adds copying from non-linear skbuffs to user's buffer.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/linux/virtio_vsock.h            |  7 +++
 net/vmw_vsock/virtio_transport_common.c | 84 +++++++++++++++++++++++--
 2 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index c58453699ee9..848ec255e665 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -12,6 +12,10 @@
 struct virtio_vsock_skb_cb {
 	bool reply;
 	bool tap_delivered;
+	/* Current fragment in 'frags' of skb. */
+	u32 curr_frag;
+	/* Offset from 0 in current fragment. */
+	u32 frag_off;
 };
 
 #define VIRTIO_VSOCK_SKB_CB(skb) ((struct virtio_vsock_skb_cb *)((skb)->cb))
@@ -246,4 +250,7 @@ void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit);
 void virtio_transport_deliver_tap_pkt(struct sk_buff *skb);
 int virtio_transport_purge_skbs(void *vsk, struct sk_buff_head *list);
 int virtio_transport_read_skb(struct vsock_sock *vsk, skb_read_actor_t read_actor);
+int virtio_transport_nl_skb_to_iov(struct sk_buff *skb,
+				   struct iov_iter *iov_iter, size_t len,
+				   bool peek);
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index dde3c870bddd..b901017b9f92 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -337,6 +337,60 @@ static int virtio_transport_send_credit_update(struct vsock_sock *vsk)
 	return virtio_transport_send_pkt_info(vsk, &info);
 }
 
+int virtio_transport_nl_skb_to_iov(struct sk_buff *skb,
+				   struct iov_iter *iov_iter,
+				   size_t len,
+				   bool peek)
+{
+	unsigned int skb_len;
+	size_t rest_len = len;
+	int curr_frag;
+	int curr_offs;
+	int err = 0;
+
+	skb_len = skb->len;
+	curr_frag = VIRTIO_VSOCK_SKB_CB(skb)->curr_frag;
+	curr_offs = VIRTIO_VSOCK_SKB_CB(skb)->frag_off;
+
+	while (rest_len && skb->len) {
+		struct bio_vec *curr_vec;
+		size_t curr_vec_end;
+		size_t to_copy;
+		void *data;
+
+		curr_vec = &skb_shinfo(skb)->frags[curr_frag];
+		curr_vec_end = curr_vec->bv_offset + curr_vec->bv_len;
+		to_copy = min(rest_len, (size_t)(curr_vec_end - curr_offs));
+		data = kmap_local_page(curr_vec->bv_page);
+
+		if (copy_to_iter(data + curr_offs, to_copy, iov_iter) != to_copy)
+			err = -EFAULT;
+
+		kunmap_local(data);
+
+		if (err)
+			break;
+
+		rest_len -= to_copy;
+		skb_len -= to_copy;
+		curr_offs += to_copy;
+
+		if (curr_offs == (curr_vec_end)) {
+			curr_frag++;
+			curr_offs = 0;
+		}
+	}
+
+	if (!peek) {
+		skb->len = skb_len;
+		VIRTIO_VSOCK_SKB_CB(skb)->curr_frag = curr_frag;
+		VIRTIO_VSOCK_SKB_CB(skb)->frag_off = curr_offs;
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(virtio_transport_nl_skb_to_iov);
+
 static ssize_t
 virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 				struct msghdr *msg,
@@ -365,7 +419,14 @@ virtio_transport_stream_do_peek(struct vsock_sock *vsk,
 			 */
 			spin_unlock_bh(&vvs->rx_lock);
 
-			err = memcpy_to_msg(msg, skb->data + off, bytes);
+			if (skb_is_nonlinear(skb)) {
+				err = virtio_transport_nl_skb_to_iov(skb,
+								     &msg->msg_iter,
+								     bytes,
+								     true);
+			} else {
+				err = memcpy_to_msg(msg, skb->data + off, bytes);
+			}
 			if (err)
 				goto out;
 
@@ -417,14 +478,22 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		 */
 		spin_unlock_bh(&vvs->rx_lock);
 
-		err = memcpy_to_msg(msg, skb->data, bytes);
+		if (skb_is_nonlinear(skb)) {
+			err = virtio_transport_nl_skb_to_iov(skb, &msg->msg_iter,
+							     bytes, false);
+		} else {
+			err = memcpy_to_msg(msg, skb->data, bytes);
+		}
+
 		if (err)
 			goto out;
 
 		spin_lock_bh(&vvs->rx_lock);
 
 		total += bytes;
-		skb_pull(skb, bytes);
+
+		if (!skb_is_nonlinear(skb))
+			skb_pull(skb, bytes);
 
 		if (skb->len == 0) {
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
@@ -498,7 +567,14 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				 */
 				spin_unlock_bh(&vvs->rx_lock);
 
-				err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				if (skb_is_nonlinear(skb)) {
+					err = virtio_transport_nl_skb_to_iov(skb,
+									     &msg->msg_iter,
+									     bytes_to_copy,
+									     false);
+				} else {
+					err = memcpy_to_msg(msg, skb->data, bytes_to_copy);
+				}
 				if (err) {
 					/* Copy of message failed. Rest of
 					 * fragments will be freed without copy.
-- 
2.25.1


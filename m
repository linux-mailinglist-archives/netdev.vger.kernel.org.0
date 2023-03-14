Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB236B907B
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 11:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbjCNKqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 06:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNKqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 06:46:50 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C6DAD02;
        Tue, 14 Mar 2023 03:46:24 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id EB5EC5FD1B;
        Tue, 14 Mar 2023 13:45:45 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678790746;
        bh=3iLPJaGeMrLb7xNjIHjUqhJAp4hqvLxn8oJMxDMG6R0=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=Mh6CXTWqdb0MRZ4PqlZvkcVKvjPOONs26mLmnVxfv4NhrTfsY9r1wqzykxD4aPit4
         /wtXJt1ZzvJey0C3GLgYxtbokw55ehCZCjkBQsUkc+v26LuMj1tWStZd3GFRjphDPB
         LdVBdK8xq2Y7E29rkNPuZZFt9crQfMbiC3gd76iIR6fncm+tCAdjHcp6kPs+1Osh3G
         mTSTD0wDLAuv1xAJq4ooyGUrlcwbYxBcE3qHYQq4hCiaJpSKc5KipD28eHsde2stVT
         o6gs6TGG7JcBqW6gUSEc+w9+CiyKD1N9a6XO+r30l2T4sD43iersYND5Q5XEcSebfY
         5FKMZW6w0XnUA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 13:45:45 +0300 (MSK)
Message-ID: <77841baa-47de-63e9-240a-76c76d2c0764@sberdevices.ru>
Date:   Tue, 14 Mar 2023 13:42:36 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <34d65539-015e-23c8-cf5e-f34bd5795e52@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [PATCH net v4 1/4] virtio/vsock: don't use skbuff state to account
 credit
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/14 06:01:00 #20942017
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'skb->len' can vary when we partially read the data, this complicates the
calculation of credit to be updated in 'virtio_transport_inc_rx_pkt()/
virtio_transport_dec_rx_pkt()'.

Also in 'virtio_transport_dec_rx_pkt()' we were miscalculating the
credit since 'skb->len' was redundant.

For these reasons, let's replace the use of skbuff state to calculate new
'rx_bytes'/'fwd_cnt' values with explicit value as input argument. This
makes code more simple, because it is not needed to change skbuff state
before each call to update 'rx_bytes'/'fwd_cnt'.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a1581c77cf84..618680fd9906 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -241,21 +241,18 @@ static int virtio_transport_send_pkt_info(struct vsock_sock *vsk,
 }
 
 static bool virtio_transport_inc_rx_pkt(struct virtio_vsock_sock *vvs,
-					struct sk_buff *skb)
+					u32 len)
 {
-	if (vvs->rx_bytes + skb->len > vvs->buf_alloc)
+	if (vvs->rx_bytes + len > vvs->buf_alloc)
 		return false;
 
-	vvs->rx_bytes += skb->len;
+	vvs->rx_bytes += len;
 	return true;
 }
 
 static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
-					struct sk_buff *skb)
+					u32 len)
 {
-	int len;
-
-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
 	vvs->rx_bytes -= len;
 	vvs->fwd_cnt += len;
 }
@@ -388,7 +385,9 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		skb_pull(skb, bytes);
 
 		if (skb->len == 0) {
-			virtio_transport_dec_rx_pkt(vvs, skb);
+			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
+
+			virtio_transport_dec_rx_pkt(vvs, pkt_len);
 			consume_skb(skb);
 		} else {
 			__skb_queue_head(&vvs->rx_queue, skb);
@@ -437,17 +436,17 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 
 	while (!msg_ready) {
 		struct virtio_vsock_hdr *hdr;
+		size_t pkt_len;
 
 		skb = __skb_dequeue(&vvs->rx_queue);
 		if (!skb)
 			break;
 		hdr = virtio_vsock_hdr(skb);
+		pkt_len = (size_t)le32_to_cpu(hdr->len);
 
 		if (dequeued_len >= 0) {
-			size_t pkt_len;
 			size_t bytes_to_copy;
 
-			pkt_len = (size_t)le32_to_cpu(hdr->len);
 			bytes_to_copy = min(user_buf_len, pkt_len);
 
 			if (bytes_to_copy) {
@@ -484,7 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				msg->msg_flags |= MSG_EOR;
 		}
 
-		virtio_transport_dec_rx_pkt(vvs, skb);
+		virtio_transport_dec_rx_pkt(vvs, pkt_len);
 		kfree_skb(skb);
 	}
 
@@ -1040,7 +1039,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 
 	spin_lock_bh(&vvs->rx_lock);
 
-	can_enqueue = virtio_transport_inc_rx_pkt(vvs, skb);
+	can_enqueue = virtio_transport_inc_rx_pkt(vvs, len);
 	if (!can_enqueue) {
 		free_pkt = true;
 		goto out;
-- 
2.25.1

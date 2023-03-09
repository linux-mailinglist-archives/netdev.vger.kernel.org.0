Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E36B210B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:16:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjCIKQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCIKPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:15:30 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B868FE63D1;
        Thu,  9 Mar 2023 02:15:08 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0B6475FD3A;
        Thu,  9 Mar 2023 13:14:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678356887;
        bh=j4u8esguJpS8punv0Tt8LlZsmPGSr23mg2hrkVvwQU8=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=DmMKvK5s7uXi7NDaGz3QUVnV3bVOMgx8yPK02SuAcTm9GNKmzX3bouOqKKZR/1dsB
         Bk5I6djoo2zF9TTYITKScJElzVaG7n601KyLT8URUsIyE34JBalIZsru/06laVGtDN
         QULxDkQdOeGEdYMy0CPvNA/ODNUW5tWXMMZD7ewEFlmFeYKoJdp6G5d+xd1sMPpWE+
         syZ7IgnIrH489u6VkymYKuvLl3BD2oMoRiOrbMiyijGCsUisNoeZWb5ZbzQMGK4in+
         Dn5rJqOHAJwVAddft+G6xKIHl5YQUz+Qhys346Bng4WedEqD+e+bN6p8iBwHo5Kyop
         swS/Mie8SfaTA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Mar 2023 13:14:46 +0300 (MSK)
Message-ID: <453d77fd-8344-26d8-bb44-7ed829b7de47@sberdevices.ru>
Date:   Thu, 9 Mar 2023 13:11:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0abeec42-a11d-3a51-453b-6acf76604f2e@sberdevices.ru>
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
Subject: [RFC PATCH v3 1/4] virtio/vsock: don't use skbuff state to account
 credit
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/09 05:43:00 #20927523
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces use of skbuff state to calculate new 'rx_bytes'/'fwd_cnt'
values with explicit value as input argument. This makes code more
simple, because it is not needed to change skbuff state before each
call to update 'rx_bytes'/'fwd_cnt'.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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

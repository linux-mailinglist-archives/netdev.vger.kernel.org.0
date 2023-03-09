Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4468A6B211F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231379AbjCIKSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbjCIKRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:17:51 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57AA5CEFB3;
        Thu,  9 Mar 2023 02:17:00 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A83955FD38;
        Thu,  9 Mar 2023 13:16:51 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678357011;
        bh=twQ60nnpAyulvzxPcu0ha11knd8LOrgUyOb/wJN9jCA=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=g19SdJjkunhov7Cg/9Iavuv6kt0M12I0iYQkitkTwzR2VeGWDJqUOiH6e+8KPyb/c
         rV9y1c8xRGF06lVYzXnSrLyWnSuJoznJG3aSfoIbEgcyR2geDcBZk9aywi2P8YTptu
         ruxwcZ5hHCLkeXyU9JSbBi9phTCT1l+95rIXeZmrGTQdK2KSt2+tNyllTwnpikivc6
         7vrIK9BhZIwJ06k2Su2cljEPeSux6nFoAXYJc90x3xf/dQARPCZGsKrTc6P2O8hT+n
         U4NHFKrp6illpvUIvbYTkhvYFv8DyGc/6HuSZMRfB9z9BW7RozyIKcKEu3wl43jnG6
         dxSJzG3Vfkueg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Mar 2023 13:16:51 +0300 (MSK)
Message-ID: <d140f8c3-d7d9-89b3-94ce-207c1f7990da@sberdevices.ru>
Date:   Thu, 9 Mar 2023 13:13:51 +0300
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
Subject: [RFC PATCH v3 3/4] virtio/vsock: don't drop skbuff on copy failure
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

This returns behaviour of SOCK_STREAM read as before skbuff usage. When
copying to user fails current skbuff won't be dropped, but returned to
sockets's queue. Technically instead of 'skb_dequeue()', 'skb_peek()' is
called and when skbuff becomes empty, it is removed from queue by
'__skb_unlink()'.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9a411475e201..6564192e7f20 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -364,7 +364,7 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 
 	spin_lock_bh(&vvs->rx_lock);
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
-		skb = __skb_dequeue(&vvs->rx_queue);
+		skb = skb_peek(&vvs->rx_queue);
 
 		bytes = len - total;
 		if (bytes > skb->len)
@@ -388,9 +388,8 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 			u32 pkt_len = le32_to_cpu(virtio_vsock_hdr(skb)->len);
 
 			virtio_transport_dec_rx_pkt(vvs, pkt_len);
+			__skb_unlink(skb, &vvs->rx_queue);
 			consume_skb(skb);
-		} else {
-			__skb_queue_head(&vvs->rx_queue, skb);
 		}
 	}
 
-- 
2.25.1

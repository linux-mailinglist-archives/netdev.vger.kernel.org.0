Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0168B6B9137
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjCNLMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCNLMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:12:48 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD99581CC9;
        Tue, 14 Mar 2023 04:12:11 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id DB44A5FD1A;
        Tue, 14 Mar 2023 14:11:29 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678792289;
        bh=O9gE/e3yodgY9/2lXhwQfpuuKkQb1WuGw0jqX7CdLPE=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=rs9aJKEUB94LWJ6gM88+e0+Foo1slZ3l9Xyt1LIHuAlwih6EAq2Tkssm2STXl411C
         V+EWkuO51SsBk7CfKtKxnfNp+ruKcm1oQzOTLSCKgutTfNi9g1kpCW+hZjClV3mw2A
         pcOzemdiU90rfiNgSBu3ag9OmJuWLLDbTUkUir16nkWGOEeOD3DSnQOogpWcZKLajG
         bZnnoBRj+LX1OeU9CQXiV0bEOy1iOP9ocIoIuO7rLeWhjIlBsF4KfkE9JtIt9bLY3j
         FKa3yx8L00cg58vUa8pshHl2isnDD21LkS9anWlC2aAKIa8Ot/t4tS87m42zaPsNvf
         h55qF/Hw+SB3A==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 14:11:29 +0300 (MSK)
Message-ID: <3f8fcfb1-6d5e-93db-f2d6-651e22dba9ce@sberdevices.ru>
Date:   Tue, 14 Mar 2023 14:08:20 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
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
Subject: [PATCH RESEND net v4 3/4] virtio/vsock: don't drop skbuff on copy
 failure
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

This returns behaviour of SOCK_STREAM read as before skbuff usage. When
copying to user fails current skbuff won't be dropped, but returned to
sockets's queue. Technically instead of 'skb_dequeue()', 'skb_peek()' is
called and when skbuff becomes empty, it is removed from queue by
'__skb_unlink()'.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

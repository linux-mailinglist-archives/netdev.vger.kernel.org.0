Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF50D6AB206
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCEULl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:11:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjCEULk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:11:40 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0917CDD;
        Sun,  5 Mar 2023 12:11:33 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 0E01A5FD04;
        Sun,  5 Mar 2023 23:11:32 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678047092;
        bh=L7Da6J5rFTLCyGxPPlCQpR06uIFFfMTCDUQ95Mc4yIg=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=sAYdmP2FkWe3wXhXTMZu6zuZLixtYz3kfbiRaUzkwIJKRmHsdp26jhM7OHQx/iSNd
         n0G8Xbk2uvUUruBpIw5WTl9Rjg3NZkSYLkZPo1Z3+gDbSLvqf8uiD1U61X1t7XYX8t
         EvPlzNk5v9YyfmmEQ/8WgRdy3AHYX10hkcPSdJF6Yq7pC/XxCLZpjtPziLcpuWMZnU
         m1+dSW8I+Cq8tMA/TpzhNBBC+At2IHavY9xQ/fpuofE2G/QoHX3K0KawRb3M4xIG1Y
         ErLqdyDkQ7uihZJyZVjJifcTWOWyvdWh3rA7gmL9kaf7RVt1fuE2YYjUMFiVHoNpGe
         JU65c1wBdgALA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  5 Mar 2023 23:11:31 +0300 (MSK)
Message-ID: <ef98aad4-f86d-fe60-9a35-792363a78a68@sberdevices.ru>
Date:   Sun, 5 Mar 2023 23:08:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
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
Subject: [RFC PATCH v2 3/4] virtio/vsock: free skb on data copy failure
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/05 16:13:00 #20917262
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes two things in case when 'memcpy_to_msg()' fails:
1) Update credit parameters of the socket, like this skbuff was
   copied to user successfully. This is needed because when skbuff was
   received it's length was used to update 'rx_bytes', thus when we drop
   skbuff here, we must account rest of it's data in 'rx_bytes'.
2) Free skbuff which was removed from socket's queue.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 30b0539990ba..ffb1af4f2b52 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -379,8 +379,12 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 		spin_unlock_bh(&vvs->rx_lock);
 
 		err = memcpy_to_msg(msg, skb->data, bytes);
-		if (err)
+		if (err) {
+			skb_pull(skb, skb->len);
+			virtio_transport_dec_rx_pkt(vvs, skb);
+			consume_skb(skb);
 			goto out;
+		}
 
 		spin_lock_bh(&vvs->rx_lock);
 
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F097B6AB1F7
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:09:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCEUJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:09:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjCEUJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:09:23 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116FE6EBD;
        Sun,  5 Mar 2023 12:09:22 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 6D6655FD04;
        Sun,  5 Mar 2023 23:09:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678046960;
        bh=OP9Q+D6ddKpeccLb8Rmg9aPK4JcBMYN/s1rz2P24TnQ=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=pvRXfzfYGzpc+pLpl2XVgBwgUqDIDKDVwBu61NuJw6pFIFzwQ4JMJ989jxq6qWvwN
         VoVc15b+2FrAtp9/WVnm7jC5rhl8b3mMuS5/oxY1tMM8+8Kh3AvIYBgMXWbq8HyIhA
         Cz+O6dfugq9AI4+y6liW4YAguudzQBIpmFbJ/LgjswJv9eu+yvJyQDium+NNcgat3y
         GIevkso0bdj7Rg1/FJIwjXB/GUoomtoYx4x7aTb+nAh71laGR11mgOdjmeja9G1AOL
         rFaKu+YfWjTXQyIcLocFUIEdke9//kdGTc70SQheIYP64wSLHaouTAOSm6YlcJCM9N
         i+iegLpyxz8pw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  5 Mar 2023 23:09:19 +0300 (MSK)
Message-ID: <4a3f3978-1093-4c0a-663f-28d77eeb0806@sberdevices.ru>
Date:   Sun, 5 Mar 2023 23:06:26 +0300
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
Subject: [RFC PATCH v2 1/4] virtio/vsock: fix 'rx_bytes'/'fwd_cnt' calculation
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

Substraction of 'skb->len' is redundant here: 'skb_headroom()' is delta
between 'data' and 'head' pointers, e.g. it is number of bytes returned
to user (of course accounting size of header). 'skb->len' is number of
bytes rest in buffer.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a1581c77cf84..2e2a773df5c1 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -255,7 +255,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
 {
 	int len;
 
-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
+	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr);
 	vvs->rx_bytes -= len;
 	vvs->fwd_cnt += len;
 }
-- 
2.25.1

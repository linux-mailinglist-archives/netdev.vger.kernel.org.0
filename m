Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5B06C912A
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbjCYWMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYWMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:12:44 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E89F40E3;
        Sat, 25 Mar 2023 15:12:43 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8DFA15FD02;
        Sun, 26 Mar 2023 01:12:41 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782361;
        bh=sApy1sk/eDYWsdjYPmVDEETHIACjQ0+qySU/8hKLXrM=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=ZwkFysTTwhpaGLxqNy1srOh0p0PcehA3Hbf3gm823p/EE1m1FUGtWZgO+vUbl2ybB
         4Fn24zcr9ZumYlTooeOhkNu/oi7Rb/AJZppPomL9k9LGCZMCW6KM1vxvBnKERXF6Sl
         eqjeWai8LIFtNY6GSkzolihUMwz/EaIpRc4e0zFvSNTFdHDFPrItZqgyFnmEULoUG8
         /TXYn+a2S1WgFBpnJHAn4h7gO0GQ4Kf4+C9KP/UJkweVFuZa50jtlAoogQQl/cnIRl
         C9DaJa+oa9gKSsTeCXm6jPDCLwohlAOpAP+o0iYweGAOii5z4U4tYhFhiYhaMUroS2
         nHpgl/cqS+s7Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:12:41 +0300 (MSK)
Message-ID: <30aa2604-77c0-322e-44fd-ff99fc25e388@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:09:25 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <728181e9-6b35-0092-3d01-3d7aff4521b6@sberdevices.ru>
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
Subject: [RFC PATCH v2 2/3] virtio/vsock: WARN_ONCE() for invalid state of
 socket
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 20:38:00 #21009968
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds WARN_ONCE() and return from stream dequeue callback when
socket's queue is empty, but 'rx_bytes' still non-zero.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index b9144af71553..ad70531de133 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -398,6 +398,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	u32 free_space;
 
 	spin_lock_bh(&vvs->rx_lock);
+
+	if (WARN_ONCE(skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes,
+		      "No skbuffs with non-zero 'rx_bytes'\n")) {
+		spin_unlock_bh(&vvs->rx_lock);
+		return err;
+	}
+
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
 		skb = skb_peek(&vvs->rx_queue);
 
-- 
2.25.1

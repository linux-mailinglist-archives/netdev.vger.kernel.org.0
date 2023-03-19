Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D99236C03EB
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjCSSyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:54:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCSSyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:54:33 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837FB196BE;
        Sun, 19 Mar 2023 11:54:32 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D9CD05FD0B;
        Sun, 19 Mar 2023 21:54:30 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679252070;
        bh=4xeEPECpVnpzfQf1fesctV2AnA8LeKYtLCBEiuPhocg=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=akgHfvv8AkVLHgeCDpICG7WM0q3/HjV+IbSmam+sMzpXSE0xxLodG4Y1ZxKLOWZA2
         PBhBsJbTchNoIJfSBv45e0YwBoSNjYbrFoM+A9dw5y+dYgSHXOksoyTsSlmgJRhq0t
         hDPPb27+rrFfkVMqQ52mBFjK/RQ0qo5VBnLqIoU+6FWkJ2aRGddlfQrpqchr895ZVi
         Kr/Bx5/gMQx9dvMfF+u0SAXCqg7RNrJdxpUrpMuBBfg/LXFCJeGxiHMTPMLvU5FHs4
         hRtNG3VjTcbNPqfu6ZTUjjwE8iFGWChJLo6v1Q78dlD8X1qrkniM95ca7qKB9NgV9S
         AZl93kgvL5/zw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 19 Mar 2023 21:54:30 +0300 (MSK)
Message-ID: <63445f2f-a0bb-153c-0e15-74a09ea26dc1@sberdevices.ru>
Date:   Sun, 19 Mar 2023 21:51:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
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
Subject: [RFC PATCH v1 1/3] virtio/vsock: fix header length on skb merging
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/19 16:43:00 #20974059
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes header length calculation of skbuff during data appending to
it. When such skbuff is processed in dequeue callbacks, e.g. 'skb_pull()'
is called on it, 'skb->len' is dynamic value, so it is impossible to use
it in header, because value from header must be permanent for valid
credit calculation ('rx_bytes'/'fwd_cnt').

Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 6d15cd4d090a..3c75986e16c2 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1091,7 +1091,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
 			memcpy(skb_put(last_skb, skb->len), skb->data, skb->len);
 			free_pkt = true;
 			last_hdr->flags |= hdr->flags;
-			last_hdr->len = cpu_to_le32(last_skb->len);
+			le32_add_cpu(&last_hdr->len, len);
 			goto out;
 		}
 	}
-- 
2.25.1

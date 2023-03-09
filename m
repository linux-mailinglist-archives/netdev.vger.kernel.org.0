Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACBD56B2EBE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbjCIUbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:31:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCIUbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:31:15 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38097E7EDB;
        Thu,  9 Mar 2023 12:31:04 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9AD935FD1B;
        Thu,  9 Mar 2023 23:31:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678393862;
        bh=hrrHq0NfzOnE5uXZKILc0Jws2vvk8qJw234H8bwXodk=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=YvfPj0e4oE+UIg9//74vqMtCIev3zaaowg2aczKnu/WuGmaJz5z7TT6QgLuKk7pqJ
         vFnA0QuL3lFoq846TRY3MIrPGtMkBxC6mcAwouCid69mNadd52GPX3ps1rIijsEmJU
         LCK0OKD2eJDgAuXz2MaHEshKd2hnm9QbwwPY8P9PoxZd6BOxm/2SZnRc4ZBEPwQZc3
         TCaG8CxEwl388EdsdIPAzEoQjarReLoungeEvBIdWvPTRZQRaHlx1W0i885sk7ViyM
         7Q4aew6TKDm/YXrAjypXdUUg5qXCN4tZsQFDgsYqf6PsNzZpNf0pKsAo9evMaimEia
         5o0JKmnDhziIA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Mar 2023 23:31:02 +0300 (MSK)
Message-ID: <e29e788a-51d7-f733-85a5-707044f54dd6@sberdevices.ru>
Date:   Thu, 9 Mar 2023 23:28:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <1804d100-1652-d463-8627-da93cb61144e@sberdevices.ru>
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
Subject: [RFC PATCH v4 3/4] virtio/vsock: don't drop skbuff on copy failure
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/09 18:14:00 #20929517
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

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
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

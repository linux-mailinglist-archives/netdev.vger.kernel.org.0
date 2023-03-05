Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B452B6AB1F9
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:10:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjCEUKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCEUKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:10:34 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30A2710AAE;
        Sun,  5 Mar 2023 12:10:33 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8E2FF5FD04;
        Sun,  5 Mar 2023 23:10:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678047031;
        bh=B1csgoVu7NP3tPpJfIEd1Is03PuaIF7WOwsc6mPxpMo=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=fVvC+MKyIZIBUwCzPm2zEXoiwyd8w/QY/cclz8FOwtxtnXszutBjkx1wN6ZMznZj4
         +fruQpxq8fHvs3lr9H8eppemU45eIWUbLxt0lGlaOC3uDc1KXIZ9kqJFiaK1T+EOLn
         WE1Myu76V+gulNQGeL4/Np7FDfShWKxYtZIURCJVYH0a0Nb8SCdhbJo8vlLKo2uWic
         ZJUcsi49mTEXxiuZjBrFi8xT/7sU1XdvKEU6gxE0/PIM2+ds89uwYIbIUlOro5PBkA
         7RylTG0PXAIVLfXtM8NoFOq901Fj4KTlKGdboetrSRmk4fMkGI1vMZnczkvkx4lFoZ
         joyzO4NT1unLQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  5 Mar 2023 23:10:31 +0300 (MSK)
Message-ID: <dfadea17-a91e-105f-c213-a73f9731c8bd@sberdevices.ru>
Date:   Sun, 5 Mar 2023 23:07:37 +0300
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
Subject: [RFC PATCH v2 2/4] virtio/vsock: remove all data from sk_buff
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

In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
data from it, it will be removed, so user will never read rest of the
data. Thus we need to update credit parameters of the socket like whole
sk_buff is read - so call 'skb_pull()' for the whole buffer.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 2e2a773df5c1..30b0539990ba 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -466,7 +466,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 					dequeued_len = err;
 				} else {
 					user_buf_len -= bytes_to_copy;
-					skb_pull(skb, bytes_to_copy);
 				}
 
 				spin_lock_bh(&vvs->rx_lock);
@@ -484,6 +483,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 				msg->msg_flags |= MSG_EOR;
 		}
 
+		skb_pull(skb, skb->len);
 		virtio_transport_dec_rx_pkt(vvs, skb);
 		kfree_skb(skb);
 	}
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B66196C9126
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbjCYWLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYWLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:11:41 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEAEACA36;
        Sat, 25 Mar 2023 15:11:39 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4C72B5FD02;
        Sun, 26 Mar 2023 01:11:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782298;
        bh=m0cak6B6kKaSjX0K/CVdseOVYXWF3wJENBSNW2prVtE=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=owLHTDq/lrjGPExTh1NQMZ6URK4T/bE5bhKZuEkyNyRTYoyG1xSsgvKvgm5F8FhkV
         kvbLzWi/E2WDJ6HjbSTIT8q4SPBdqAADiuQuzjxBGChFQTps2G3gUEv+wdTXxw2Cld
         E7/6JQyi8qmuqj+1iH6j8/CDmcMcggzKBYUZ+L6p2KSnicbz528kJmVensXu0uRLYW
         +qiVaXZTFN0XvBf+OVKCkTV3SiiYLs7Xv6l8b8iXmozGEtRN4WkNJvWqTzAaGgsPEi
         a6RwYSHt3un8y3CJRgCW3xbTbV/JGvCZfpie8kz6uAGXtbZpEQRmcB/HgqQFqi+Xkd
         OLFd6py73d3FQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:11:38 +0300 (MSK)
Message-ID: <b5d31a81-a089-146b-d04f-569710e6b14b@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:08:22 +0300
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
Subject: [RFC PATCH v2 1/3] virtio/vsock: fix header length on skb merging
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

This fixes appending newly arrived skbuff to the last skbuff of the
socket's queue. Problem fires when we are trying to append data to skbuff
which was already processed in dequeue callback at least once. Dequeue
callback calls function 'skb_pull()' which changes 'skb->len'. In current
implementation 'skb->len' is used to update length in header of the last
skbuff after new data was copied to it. This is bug, because value in
header is used to calculate 'rx_bytes'/'fwd_cnt' and thus must be not
be changed during skbuff's lifetime.

Bug starts to fire since:

commit 077706165717
("virtio/vsock: don't use skbuff state to account credit")

It presents before, but didn't triggered due to a little bit buggy
implementation of credit calculation logic. So use Fixes tag for it.

Fixes: 077706165717 ("virtio/vsock: don't use skbuff state to account credit")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 7fc178c3ee07..b9144af71553 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1101,7 +1101,7 @@ virtio_transport_recv_enqueue(struct vsock_sock *vsk,
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

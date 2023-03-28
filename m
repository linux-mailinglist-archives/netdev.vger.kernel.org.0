Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D936CBDD8
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbjC1LfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjC1Lew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:34:52 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9B65FFD;
        Tue, 28 Mar 2023 04:34:51 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9B04A5FD14;
        Tue, 28 Mar 2023 14:34:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680003289;
        bh=njThAgJ0APChbsy6LUtd1QrIVKwwvn+F93D+MWgxsAU=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=JpA1GfxlBQOq/krden97+glI/+SvnxW6q2Z8PejvYXuXjbaoNZ+FqOjQdLvZpPua/
         8AeJPFalW700PxisrIvXV9BeZ0hatw65ZlE+BZIPx2wo27QTEippqpTZ630AxR1fjG
         Tz0mYq3Kq+WIQ6G3zx1OzToZqXrgT1qWoA/QGXbCEw3gHnYj1/H8TdRN5LpR/CwTr8
         tYe5W92FxHDDGdSbe9HA1by5REndUuyF/R5Be4BnWXvga2kSoT6oJS5yGSz/IGMhx2
         d21RMM5UH2KvhgXayshkKkuh15sU5g1eVRChsK7H7fQClJ/ehRN2wk8MFPk6dTEFMX
         2OHgbPrEbZ2UA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 28 Mar 2023 14:34:48 +0300 (MSK)
Message-ID: <f353cf87-dbb6-375b-6428-c51663ab4d3a@sberdevices.ru>
Date:   Tue, 28 Mar 2023 14:31:28 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0683cc6e-5130-484c-1105-ef2eb792d355@sberdevices.ru>
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
Subject: [PATCH net v2 1/3] virtio/vsock: fix header length on skb merging
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/28 06:38:00 #21021220
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

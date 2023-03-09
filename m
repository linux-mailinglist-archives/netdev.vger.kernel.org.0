Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3831A6B2118
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 11:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbjCIKRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 05:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbjCIKQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 05:16:57 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA61EB89D;
        Thu,  9 Mar 2023 02:15:59 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id A911F5FD38;
        Thu,  9 Mar 2023 13:15:49 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678356949;
        bh=pEUT86ikon0sBC2KSBuNIGLhBhGsTeozoRveheVlr4Y=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=r7xIN1aIeFVncexr7O9vq3lT3Yp6jfhNFezQpoVfUsCnEEW67fBB6RthuzpWTAB/8
         cA5KG/Ig38O6ypd7baQxpmnwu0Q0/wm4RnvzJJFS/Ile2fRBstzc/NUflyp9p1oYmC
         rFOoRU3rcCBb9KiuZ71MNbADrDlphpnT3lM8lq9HQJzahar7g3zdN8DH4SBrao2JRL
         eJtqrmYaL8trWLPcp3GQpcNBaOW6VYqb1InqGy7rLDJvmbPgIgbBi3NW002vLrscxF
         sn8SLtIymetqF8/rwOVIa2Fk4j6Ktpc1QIXsjH4WZ5n5K0PcU8+RReSjfqdGVn4BcE
         6U/McRUC5a5gg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu,  9 Mar 2023 13:15:49 +0300 (MSK)
Message-ID: <ea7a542b-8772-e204-6b2b-a60d89614f3b@sberdevices.ru>
Date:   Thu, 9 Mar 2023 13:12:42 +0300
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
Subject: [RFC PATCH v3 2/4] virtio/vsock: remove redundant 'skb_pull()' call
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

There is no sense to update skbuff state, because it is used only once
after dequeue to copy data and then will be released.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 618680fd9906..9a411475e201 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -465,7 +465,6 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 					dequeued_len = err;
 				} else {
 					user_buf_len -= bytes_to_copy;
-					skb_pull(skb, bytes_to_copy);
 				}
 
 				spin_lock_bh(&vvs->rx_lock);
-- 
2.25.1

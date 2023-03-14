Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4506B912D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjCNLKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbjCNLK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:10:29 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B94D1E9F5;
        Tue, 14 Mar 2023 04:10:04 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 5D9F75FD62;
        Tue, 14 Mar 2023 14:10:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678792202;
        bh=BqQPywzkRmwCTA57RbQWMUd1CdLRbsre5I6PgGn4zLc=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=BN0l2/TfDTCvsziVYfNoVC4mjBCurnqS4VS8aYpiO7hTx4sXavjRCJufKIfRHMicT
         6tjzPREFYda1wSXPLrwMk5P7xKn8vpLK31bzoeskcJgABxg4X2cbO+XUH1SMf5Y9CK
         HKO9Y3nSM54exR5FnTDFOU4Ki+bGcoaVzZMvI4icl6VkkxW2rQap1an+amcsGZl7yc
         bIbxm4LOWYJHIVj7uXnSfO+L3tPMPqzAts75TdgfRW0SjJX5UyXqeMFmwk2hf7JSMq
         bVLmJtNMaI0+w89QTAs5xP7zzTht7TcisGNS7vA+UFuQC2E6KRBvwCoxyxqZ4dLn8I
         0TgNt+dZ9h1EA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 14:10:02 +0300 (MSK)
Message-ID: <75e3f51b-2848-d3ce-a995-4ac8320663f6@sberdevices.ru>
Date:   Tue, 14 Mar 2023 14:06:53 +0300
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
Subject: [PATCH RESEND net v4 2/4] virtio/vsock: remove redundant 'skb_pull()'
 call
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

Since we now no longer use 'skb->len' to update credit, there is no sense
to update skbuff state, because it is used only once after dequeue to
copy data and then will be released.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

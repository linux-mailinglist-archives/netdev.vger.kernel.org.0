Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2506DC130
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 21:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbjDITVp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 15:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDITVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 15:21:44 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3056F2707;
        Sun,  9 Apr 2023 12:21:42 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8FF055FD05;
        Sun,  9 Apr 2023 22:21:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1681068098;
        bh=J7zpBAxQ22u0GAaVe4TBJJwPsTv+M41weOXMx2R7sTc=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=ReUNUxKM/65C8FFsbC56Soj6eNdv+I0SyraX4jvRoByWYLItao2s5LN/w7m8UOX2M
         UB7B6P/GtZsFFF+bZc73s9HutQc4/rdWuS7TfJhB8/+IgfIm4XiPZSq7GHffoyiTze
         4c4fO8OmjilzuCYcfHs/3TPdGQDdeNS5umSLOHjlJhJVT5/cMh65xsLXMmy2B/6Kt/
         Ekv4yv1Jq4M3YnU976UuqJFREgigI90OJVmlPWy5i0X2ccy2wl0uNnscEXomOzCbXE
         qk5i2Y+nMLM0Uf/+93sq7JjjQF4+2FppWUW76QlFjpeeA2146i10g9bFMh5jr/LX83
         yrn9ZHYq0zgjw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  9 Apr 2023 22:21:34 +0300 (MSK)
Message-ID: <b6dd26b3-97d7-ef8e-d8f8-a0e728fa2b02@sberdevices.ru>
Date:   Sun, 9 Apr 2023 22:17:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v1] vsock/loopback: don't disable irqs for queue access
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/09 07:48:00 #21070576
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This replaces 'skb_queue_tail()' with 'virtio_vsock_skb_queue_tail()'.
The first one uses 'spin_lock_irqsave()', second uses 'spin_lock_bh()'.
There is no need to disable interrupts in the loopback transport as
there is no access to the queue with skbs from interrupt context. Both
virtio and vhost transports work in the same way.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/vsock_loopback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index e3afc0c866f5..5c6360df1f31 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -31,8 +31,7 @@ static int vsock_loopback_send_pkt(struct sk_buff *skb)
 	struct vsock_loopback *vsock = &the_vsock_loopback;
 	int len = skb->len;
 
-	skb_queue_tail(&vsock->pkt_queue, skb);
-
+	virtio_vsock_skb_queue_tail(&vsock->pkt_queue, skb);
 	queue_work(vsock->workqueue, &vsock->pkt_work);
 
 	return len;
-- 
2.25.1

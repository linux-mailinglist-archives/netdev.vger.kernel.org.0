Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697036E0A0D
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjDMJVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjDMJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:21:19 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AE019AF;
        Thu, 13 Apr 2023 02:21:16 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 1071B5FD06;
        Thu, 13 Apr 2023 12:21:14 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1681377674;
        bh=j93koGWuMMEp3dZcZqVMh81FqwazTMY/cbuzmyQhZHs=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=iMsVdMDMKKbbCqTftnFRtMuQ0GEl4+Z4eb6Cw+sGzRF//84ZJYvwMzuPgRePsyvOr
         H6UVkj5CdHEV5CGgmFe6M2MJgrytyAr8iNYBB+Oa7uZIJlfKIbcMU0Hf7sXFA9l1Kw
         6L+vTVz7Qf8mU6PtWSk33J+nV/OOn5n3nBQKJ0g/N2L0wHdt/bLc+5TeAIfb+90VfF
         MwvBerWu+z23ZNtvXyQQV9P+JkNr9LrCIqdVcbWhKvLtQzcC80OjuNKiL5AUEuIBQ9
         TFUowG1+zvjfYvqU+zro7o9yv0Eg1Y3wEMKMs2/Hs9nGGU97vkQehwO52GWhv2PKYq
         FmGbOAtjpmEWQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 13 Apr 2023 12:21:09 +0300 (MSK)
Message-ID: <a4f17ab9-4be9-1b0a-0fc0-9fa8ef98273d@sberdevices.ru>
Date:   Thu, 13 Apr 2023 12:17:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
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
Subject: [PATCH net-next v1] vsock/loopback: don't disable irqs for queue
 access
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/12 22:40:00 #21096401
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BAF96A674D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 06:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjCAFWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 00:22:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjCAFWk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 00:22:40 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70283757A;
        Tue, 28 Feb 2023 21:22:37 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B29095FD5F;
        Wed,  1 Mar 2023 08:22:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677648154;
        bh=pSybxYLtaFBPZn4llcjWoXZByulTRftoVwSM3MF7hHo=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=tDGr+UA3jvR+kF0RvxTyVjehhcpoRu7UxYNr+9dfAuOuKp2zy7+x7r0cfQcTVsVgb
         yYhwvmecXJ1pyBJsEGOXZrUcoGNLO3IKPPZIfNxQBAGafERZZIZjZU6YZSIDarck9x
         OQzfG6rxypuBlELR0LptuaSVDC9zzp3wogV3ISlu5m3T6/GDh0V9t9GIk9rCpJzJS3
         /E+6t9zBR7AYUOLtyvmhMJgIA9uqTe3EwmLk7z5ieM0RARIBhqmtbJ1olGqwfWQitL
         v8mDnvA7VEOn9HiDMPigpzQ+1YTXNuMuPlO51Jolh6XSm2KiWdnIAr1AYdp3L2YNbm
         uXZSi1KfXA/qA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed,  1 Mar 2023 08:22:31 +0300 (MSK)
Message-ID: <76e7698d-890b-d14d-fa34-da5dd7dd13d8@sberdevices.ru>
Date:   Wed, 1 Mar 2023 08:19:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <oxffffaa@gmail.com>, <kernel@sberdevices.ru>,
        <avkrasnov@sberdevices.ru>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v1] vsock: check error queue to set EPOLLERR
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/01 02:04:00 #20904788
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EPOLLERR must be set not only when there is error on the socket, but also
when error queue of it is not empty (may be it contains some control
messages). Without this patch 'poll()' won't detect data in error queue.
This patch is based on 'tcp_poll()'.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/af_vsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 19aea7cba26e..b5e51ef4a74c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1026,7 +1026,7 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	poll_wait(file, sk_sleep(sk), wait);
 	mask = 0;
 
-	if (sk->sk_err)
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		/* Signify that there has been an error on this socket. */
 		mask |= EPOLLERR;
 
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3154E6C9136
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbjCYWQd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCYWQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:16:31 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB97CC30;
        Sat, 25 Mar 2023 15:16:30 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8FCD45FD02;
        Sun, 26 Mar 2023 01:16:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782588;
        bh=bkc6d1yYqgIUYawce1wHqHL23hRQ4dzBaaa6S+OuT/c=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=eyVwZfIRi1ANQNCylXloNg95A3u5qjMOKvXJQlTt++/OSkQfTS34zrtLO+UUjWsXU
         gnvUT11dd7l+O6EZTNHBU2PJrAWk/pN+mQ37xSUQuA7U1HRkF8Ntv/cFomi96UwR2S
         87SAOv5/eS5nIJc1iGeaNFHY5Xk5kJEUJHJTrcMre8uF7ffN7L3PCCBHnVyzyXCLcz
         JyxOXbpkCvJCIPWDmUCctdKpfwk/t2CTqQQ6Xp4qs9BtR13ZV98ZtbxdWsp644dN5n
         EuEw+si670/5qpFin/owGhU69ddY6OjXquroBphysgiUzdk3GTRZqeHtl6D7SyOlBw
         jaFPVFatlXmDQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:16:27 +0300 (MSK)
Message-ID: <99da938b-3e67-150c-2f74-41d917a95950@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:13:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <97f19214-ba04-c47e-7486-72e8aa16c690@sberdevices.ru>
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
Subject: [RFC PATCH v1 1/2] vsock: return errors other than -ENOMEM to socket
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

This removes behaviour, where error code returned from any transport
was always switched to ENOMEM. This works in the same way as:
commit
c43170b7e157 ("vsock: return errors other than -ENOMEM to socket"),
but for receive calls.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/af_vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 19aea7cba26e..9262e0b77d47 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2007,7 +2007,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 
 		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
 		if (read < 0) {
-			err = -ENOMEM;
+			err = read;
 			break;
 		}
 
@@ -2058,7 +2058,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
 
 	if (msg_len < 0) {
-		err = -ENOMEM;
+		err = msg_len;
 		goto out;
 	}
 
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052EC6D39C0
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbjDBSUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 14:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDBSUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 14:20:20 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4D29030;
        Sun,  2 Apr 2023 11:20:19 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 018EF5FD04;
        Sun,  2 Apr 2023 21:20:18 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680459618;
        bh=wK7GCYWOw+lG9q/p1ToXem8gzHNx+PH+yGZk1ens7jQ=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=TyTrPp67JvOTC+ooSlj9oK2/0E9LVAAMdyKSE48buIj0DYXbi859U4+r/dtYEFJ1o
         UAlLxs1lx8mj1TliZBnmcVuR8SqtKHjsApUtbRoN7eb3PQ6eV9SLUwfKb04LEeh/x6
         p47W94NJDVV1vyVrun+TpsJNQ8sg1eodzkbJxVrqFNBKHFZzNtHemtiVAD6e3cbX+c
         GTpIh4mGTQfr2HZcgzto8OsFc/ugo6YP04F27G7mX7GTDY6/JTXc+ZPPKzvY714/em
         CBHN2EC63lSL1WwOuVHnFWGZ5Fgxk3MuBA96X9S/B+dVFQoDbmPqC6ema5fycfX33y
         NuM7aNJXD1eTQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  2 Apr 2023 21:20:17 +0300 (MSK)
Message-ID: <7715fd7f-1c50-7202-03c7-9d17c7f63cab@sberdevices.ru>
Date:   Sun, 2 Apr 2023 21:16:46 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <5440aa51-8a6c-ac9f-9578-5bf9d66217a5@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>, <pv-drivers@vmware.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
Subject: [RFC PATCH v4 2/3] vsock: return errors other than -ENOMEM to socket
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/02 13:52:00 #21029650
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
index 5f2dda35c980..413407bb646c 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -2043,7 +2043,7 @@ static int __vsock_stream_recvmsg(struct sock *sk, struct msghdr *msg,
 
 		read = transport->stream_dequeue(vsk, msg, len - copied, flags);
 		if (read < 0) {
-			err = -ENOMEM;
+			err = read;
 			break;
 		}
 
@@ -2094,7 +2094,7 @@ static int __vsock_seqpacket_recvmsg(struct sock *sk, struct msghdr *msg,
 	msg_len = transport->seqpacket_dequeue(vsk, msg, flags);
 
 	if (msg_len < 0) {
-		err = -ENOMEM;
+		err = msg_len;
 		goto out;
 	}
 
-- 
2.25.1

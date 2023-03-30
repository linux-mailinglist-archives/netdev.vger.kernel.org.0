Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2866D0FDE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbjC3USX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3USW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:18:22 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB7940D3;
        Thu, 30 Mar 2023 13:18:21 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B2F405FD0B;
        Thu, 30 Mar 2023 23:18:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680207499;
        bh=wK7GCYWOw+lG9q/p1ToXem8gzHNx+PH+yGZk1ens7jQ=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=QPzKoVZ9fA7urps0wPlKOGy00Pox1UhqGRLngle5n+hxEwd3/Y2Bruk4YiCVYZEo3
         hntATVDcyodP3gIihTdBra54u/5NSUYbr5hcqMPie6zwkCMuQrEu83DkPnP0Fc4tWX
         PYsJ+qRpa+B5mYRDSMp7qj4hais2c/Z3QPd0RFP3l7BLWac8KQg2G5+se3ivjynumx
         B6E8mCAwjDXjEbUUK2ukNq5kPo37VBWqJqEFhHWc8DcNB9hEZWWOJ1Uv50wdhbf0dn
         z32KlB7ln6q77Xz81FsCs8rMvNmAelZ0YJpp87QjLDHPzLqc4PUaTZlxS5IxFfdGO7
         EJpqqhwi1I+Og==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 23:18:19 +0300 (MSK)
Message-ID: <afbe4a05-78c3-0bc9-2164-d5bb76b4c19d@sberdevices.ru>
Date:   Thu, 30 Mar 2023 23:14:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <dead4842-333a-015e-028b-302151336ff9@sberdevices.ru>
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
Subject: [RFC PATCH v3 3/4] vsock: return errors other than -ENOMEM to socket
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/30 18:07:00 #21069213
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

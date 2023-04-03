Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04FE6D437E
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjDCL2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:28:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232238AbjDCL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:28:47 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B127C4224;
        Mon,  3 Apr 2023 04:28:45 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 079385FD22;
        Mon,  3 Apr 2023 14:28:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680521324;
        bh=PMQoUlr6fMnlWZgvIkETHRIUvgj+Tiz5vrh8HAFCAUw=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=smc6Tp11ta3Y/nEm69dGlKm9EAdjP20xwlU97Fdk7gE5GLNoyWDSl27ygH0prTMBL
         SgKzriCBXY0GLdzgHJnQJeS5H9xzrgm6hbczABAiFlSFmv6ccz727eDVyQlfk7Y+wv
         kKIDtHBRZUYyjG8r+kORqYKzC/Py8TyYwEs/yM4plsik4tyLuucW6aD6/BBxYaYgLu
         XLTK8RBgSOXDF1pwbE5hPdVuwiZMAY+Ng8HsRAQG2hGnBqLPNL39eNw7gHRx35Fpki
         SxO7lIWNn8t4GSPeXdxtO12Byav1R3VgA6cZdAUqBkc8v8J0RITmvdMawRUXG9C2xG
         3GMmdICjYsuVA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon,  3 Apr 2023 14:28:43 +0300 (MSK)
Message-ID: <067371c8-f5a8-59a5-9485-cee85e3d27ef@sberdevices.ru>
Date:   Mon, 3 Apr 2023 14:25:12 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0d20e25a-640c-72c1-2dcb-7a53a05e3132@sberdevices.ru>
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
Subject: [PATCH net-next v4 2/3] vsock: return errors other than -ENOMEM to
 socket
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/03 05:35:00 #21028078
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
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
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

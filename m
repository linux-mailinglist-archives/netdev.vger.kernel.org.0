Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A7E6D39C3
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 20:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbjDBSTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 14:19:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbjDBSTW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 14:19:22 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76802902A;
        Sun,  2 Apr 2023 11:19:21 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id CB3435FD04;
        Sun,  2 Apr 2023 21:19:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680459559;
        bh=ylxN7UqQ/M1z7OMhkHvFEk22Nzg7mYVbxzsd6Ok5gYk=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=qkgRmy0fCvdg4Rmxz7Bya+i2lWqY2nRMIZOJPRV3xQuTOh0NYYWde9pZi2eIlBk7w
         IxIOsboZr96vpG1/ydZFk8mpQ4+uBj//drk/l8sUlgo1jrFvyRG54OOK5XbF1MMsEQ
         ndE2yMEwJ93hcNGEGcjLRKUE4v0Tepr6TPMXD0u09Gm5z1MO3uF+x12Q87oF7n+fG5
         XCJXBfGj1VQK96jDY0t/8TPTWJtcWJfBZ2YN+oe+jad9mMUN61XreMA5RkDPH3bt/x
         47A4mR5cUDLwA/VfGfdybad48AZTfRSJNopp1P3zjnSZkaljt3WBKTiPbKYWRC6rzi
         itKp/WArm5hug==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  2 Apr 2023 21:19:19 +0300 (MSK)
Message-ID: <fb3308c0-4a7a-a0b0-dbfd-92e50985600e@sberdevices.ru>
Date:   Sun, 2 Apr 2023 21:15:49 +0300
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
Subject: [RFC PATCH v4 1/3] vsock/vmci: convert VMCI error code to -ENOMEM on
 receive
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

This adds conversion of VMCI specific error code to general -ENOMEM. It
is preparation for the next patch, which changes af_vsock.c behaviour
on receive to pass value returned from transport to the user.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
---
 net/vmw_vsock/vmci_transport.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 36eb16a40745..a5375c97f5b0 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1831,10 +1831,17 @@ static ssize_t vmci_transport_stream_dequeue(
 	size_t len,
 	int flags)
 {
+	ssize_t err;
+
 	if (flags & MSG_PEEK)
-		return vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
+		err = vmci_qpair_peekv(vmci_trans(vsk)->qpair, msg, len, 0);
 	else
-		return vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
+		err = vmci_qpair_dequev(vmci_trans(vsk)->qpair, msg, len, 0);
+
+	if (err < 0)
+		err = -ENOMEM;
+
+	return err;
 }
 
 static ssize_t vmci_transport_stream_enqueue(
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 273E96D0FD5
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 22:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbjC3UQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 16:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3UQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 16:16:15 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE963D53B;
        Thu, 30 Mar 2023 13:16:11 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 05AA75FD0B;
        Thu, 30 Mar 2023 23:16:10 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680207370;
        bh=Bmxyh54lX6vx3ZvD3CMgQVOYil7AZCn1e5XpBZtA3TI=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=Dxc66ArHyPpBcSE8UnUuR5unLlbZsRAblKuFnLSsNz4AUg/lz0wbnVaho85ynfQy+
         Iha6hIM9y5EEA75Q6Q038Sxd6CJgozGZyBSL3yUuMw0+ryyXbnUaZiVftUNTfqNZkK
         V9hs87zr6jSqy2seEbWTJNnFCujxCi8+pc92DqtW2UrwxtKvuiLHbaJuy7DfGCH9ko
         GxIMZBM3n5XxhV8bV3gtkxGJGk+Bgl/P96OSsPV6uipvlflL9mPYODUFUD9SuzQwcO
         i4KlytpmrbFQa23Su8SHhSo4VrGy706Aue0ShC80mwm1O7s7fOFHmpQlX/GOuca7L1
         9/VaVPKMSlXjw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Thu, 30 Mar 2023 23:16:09 +0300 (MSK)
Message-ID: <a0915a9d-ba41-5a90-0e16-40c2315f0445@sberdevices.ru>
Date:   Thu, 30 Mar 2023 23:12:44 +0300
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
Subject: [RFC PATCH v3 1/4] vsock/vmci: convert VMCI error code to -ENOMEM on
 send
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

This adds conversion of VMCI specific error code to general -ENOMEM. It
is needed, because af_vsock.c passes error value returned from transport
to the user, which does not expect to get VMCI_ERROR_* values.

Fixes: c43170b7e157 ("vsock: return errors other than -ENOMEM to socket")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/vmci_transport.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index 36eb16a40745..95cc4d79ba29 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1842,7 +1842,13 @@ static ssize_t vmci_transport_stream_enqueue(
 	struct msghdr *msg,
 	size_t len)
 {
-	return vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+	ssize_t err;
+
+	err = vmci_qpair_enquev(vmci_trans(vsk)->qpair, msg, len, 0);
+	if (err < 0)
+		err = -ENOMEM;
+
+	return err;
 }
 
 static s64 vmci_transport_stream_has_data(struct vsock_sock *vsk)
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40896EC1F6
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDWTby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjDWTbb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:31 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA864E5D;
        Sun, 23 Apr 2023 12:31:30 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id F30245FD17;
        Sun, 23 Apr 2023 22:31:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278289;
        bh=DOvMiyMl9T/2K7i2my/swBI2rgDyc1aBJR26UiP7x5o=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=auT+o/tP2A15cToEEKYnRmS6p89PBmSxxoNkCqqy/pfLfuQm1n+5C0ErRkET2f8V+
         eVlCQgwsymUWz/ckTl53hj5S1Xqk67lgvwffW4s2t2KiCLQVPcK/dyiXfcKHjm2a7s
         cD0RSajJpZPU8baow1lhPGQJK+0PD7UBF9TPiP7n0WVrdE1gpXtmFxpUndloNR42FU
         dCD+aC9Mx7/KHyyqPxLi8y/yBBK2W6lQB4S9MX51u57GyZTUMu97omMSZIH9yFReNA
         rSCXAcj/ied3rx9aDgsGrmrGiuS8BA7AOxGxK8Nq/L3BZbzljNV3zprHSZ7ow/yHvU
         5x68HWXO7FXZg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:28 +0300 (MSK)
From:   Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>
CC:     <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel@sberdevices.ru>, <oxffffaa@gmail.com>,
        <avkrasnov@sberdevices.ru>,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v2 12/15] net/sock: enable setting SO_ZEROCOPY for PF_VSOCK
Date:   Sun, 23 Apr 2023 22:26:40 +0300
Message-ID: <20230423192643.1537470-13-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
References: <20230423192643.1537470-1-AVKrasnov@sberdevices.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/04/23 16:01:00 #21150277
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PF_VSOCK supports MSG_ZEROCOPY transmission, so SO_ZEROCOPY could
be enabled.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/core/sock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index c25888795390..13a89c6cbfb8 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1457,9 +1457,11 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 			      (sk->sk_type == SOCK_DGRAM &&
 			       sk->sk_protocol == IPPROTO_UDP)))
 				ret = -EOPNOTSUPP;
-		} else if (sk->sk_family != PF_RDS) {
+		} else if (sk->sk_family != PF_RDS &&
+			   sk->sk_family != PF_VSOCK) {
 			ret = -EOPNOTSUPP;
 		}
+
 		if (!ret) {
 			if (val < 0 || val > 1)
 				ret = -EINVAL;
-- 
2.25.1


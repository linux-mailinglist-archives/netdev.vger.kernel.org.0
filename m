Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89DC56EC1FF
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjDWTbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjDWTb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:28 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FDFE52;
        Sun, 23 Apr 2023 12:31:27 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 4CF2A5FD13;
        Sun, 23 Apr 2023 22:31:22 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278282;
        bh=8MkOLhUem8zje6YCZe3k8/M7+vTx+mrb7f0DcsdGdpY=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=KoO6dzXSzca3ttXVlKbvpwC3NwC5pb5eblm52zMokNdxh1SlYEEMB5LTkTdBoPwhd
         LKrrWG1ggHFLSx28sULqj7Fv7R2u36fHrcRfT7KWZXODEV/uujk9ikrmVrobYOZy/X
         h3KvORYZ3TyrHc9hiM1Klf/YJNRJq50O2R7uLL9t+k8uINNLiPz+6fUkRpwWUZ31fn
         m7TIlwljA/lnsHZaVQ3CgPLktq1gunvZJE+0SxvPQbHAso7iNSfkD2cmvRZniGyRbm
         AZKz3FwsuMvL+kmXyIdYB/LVJMqm9S2ltOGpSki/TL9iqwRbFHwO2T/6bRHqvczvGd
         AgBDybI60Gzfg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:22 +0300 (MSK)
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
Subject: [RFC PATCH v2 08/15] vsock: check for MSG_ZEROCOPY support
Date:   Sun, 23 Apr 2023 22:26:36 +0300
Message-ID: <20230423192643.1537470-9-AVKrasnov@sberdevices.ru>
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

This feature totally depends on transport, so if transport doesn't
support it, return error.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/net/af_vsock.h   | 3 +++
 net/vmw_vsock/af_vsock.c | 7 +++++++
 2 files changed, 10 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0e7504a42925..270ca54cfab8 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -177,6 +177,9 @@ struct vsock_transport {
 
 	/* Read a single skb */
 	int (*read_skb)(struct vsock_sock *, skb_read_actor_t);
+
+	/* Zero-copy. */
+	bool (*msgzerocopy_allow)(void);
 };
 
 /**** CORE ****/
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index c50d2632a75f..eac8c1affd6a 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1824,6 +1824,13 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
+	if (msg->msg_flags & MSG_ZEROCOPY &&
+	    (!transport->msgzerocopy_allow ||
+	     !transport->msgzerocopy_allow())) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* Wait for room in the produce queue to enqueue our user's data. */
 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
-- 
2.25.1


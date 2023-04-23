Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B982D6EC1EA
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 21:34:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbjDWTbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 15:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjDWTb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 15:31:27 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD59E10E3;
        Sun, 23 Apr 2023 12:31:26 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 845135FD11;
        Sun, 23 Apr 2023 22:31:20 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1682278280;
        bh=92TjpAFzgN19cdeV3DB5ob03wq+mklevZg38Rj0IMpE=;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
        b=Mng9PSOvlrxvx5X/lA8GlGv+KKcbYKMDrsWhqZzW/HNfBLp1wasviZQwRM4f6Q7eG
         0U0mIPJ2/rUrBhRf0NueNKj9bNnR9jTVb0c/HaG89B2FGYkI23Ax/XhcPq0EAAhaxD
         q5gceOhOxvJmuBrEr10WX1yMjKRmchmucWX4w0zShfGACUvI9dsqzdPT5iMjCkGrgn
         eule7pCMmBOedTnBw4/ljqYCZsF1lv6u4lg/pqxvEQGZFhHLm/5Ar5OdhcFPDnnfax
         Q1xB4wlEKLQz7oQ444+Z1OqPw9fy6lXqVgBWDEmK8F3Rox4PwAyB5jWaNhH22jsAgg
         sHvwA9O0Pz06Q==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 23 Apr 2023 22:31:20 +0300 (MSK)
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
Subject: [RFC PATCH v2 06/15] vsock: check error queue to set EPOLLERR
Date:   Sun, 23 Apr 2023 22:26:34 +0300
Message-ID: <20230423192643.1537470-7-AVKrasnov@sberdevices.ru>
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

If socket's error queue is not empty, EPOLLERR must be set.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/af_vsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 413407bb646c..137a0db6eaac 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1030,8 +1030,8 @@ static __poll_t vsock_poll(struct file *file, struct socket *sock,
 	poll_wait(file, sk_sleep(sk), wait);
 	mask = 0;
 
-	if (sk->sk_err)
-		/* Signify that there has been an error on this socket. */
+	/* Signify that there has been an error on this socket. */
+	if (sk->sk_err || !skb_queue_empty_lockless(&sk->sk_error_queue))
 		mask |= EPOLLERR;
 
 	/* INET sockets treat local write shutdown and peer write shutdown as a
-- 
2.25.1


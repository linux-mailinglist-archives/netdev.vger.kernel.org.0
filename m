Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082D76C03EF
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbjCSSzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjCSSzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:55:41 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB934485;
        Sun, 19 Mar 2023 11:55:40 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 8A9995FD08;
        Sun, 19 Mar 2023 21:55:38 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679252138;
        bh=C781NWpzeOK41C9p67pG5T6Jta5orOVTpQeZsJpmG/8=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=Oy80ZgyHynh27XtVAJRm3hu4Pm8dP5oed2sCfK9E9/SIcnCtqyNHMWai0IXCAsd6E
         SDKEThUAF1BD6VQdWAIeXJFdjkp/czlQace9ewICsfAUJB71Z1xWgilOGAylEE0fLg
         ZiQV27pHtD5ziKQ8z/oijZSI+NVg1Y4JFQGqTmfjGt1VgkKMToSV+osLYP7QZydFgL
         lTrtlAkiKi00oDxCK17fZG5cZHpAKhg+oOJDqBwUEdFJFT4hlr4JY37vstNGStb7yX
         qsnxht7tReX2KI0nnCbA6HazNuiTTMT+OADc0oKcX5eIBdvdnwWqtJ+CZESVwjuXXy
         KXJFR3QAMvNlw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 19 Mar 2023 21:55:38 +0300 (MSK)
Message-ID: <da93402d-920e-c248-a5a1-baf24b70ebee@sberdevices.ru>
Date:   Sun, 19 Mar 2023 21:52:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
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
Subject: [RFC PATCH v1 2/3] virtio/vsock: add WARN() for invalid state of
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/19 16:43:00 #20974059
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prints WARN() and returns from stream dequeue callback when socket's
queue is empty, but 'rx_bytes' still non-zero.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 3c75986e16c2..c35b03adad8d 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -388,6 +388,13 @@ virtio_transport_stream_do_dequeue(struct vsock_sock *vsk,
 	u32 free_space;
 
 	spin_lock_bh(&vvs->rx_lock);
+
+	if (skb_queue_empty(&vvs->rx_queue) && vvs->rx_bytes) {
+		WARN(1, "No skbuffs with non-zero 'rx_bytes'\n");
+		spin_unlock_bh(&vvs->rx_lock);
+		return err;
+	}
+
 	while (total < len && !skb_queue_empty(&vvs->rx_queue)) {
 		skb = skb_peek(&vvs->rx_queue);
 
-- 
2.25.1

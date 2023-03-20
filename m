Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493976C1E9E
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230494AbjCTRyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjCTRxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:53:46 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38D93D908;
        Mon, 20 Mar 2023 10:48:08 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 88A535FD1B;
        Mon, 20 Mar 2023 20:46:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679334414;
        bh=RrqTDk5Lswfr0hdos6/GnxqNwq7ga/eQN2kff/rK/xE=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=eCuJ2lAGZxL69Lqwii04IvPClHzbzFqAK/eI3CMewvovZ6ShHl895fRp1sJREuVZy
         fjDixRM1FnEjWCcSyibuqJN0Q2MliFkEyOl9+/zQBzrnSJWIe6gBumqaQg4dvYZnxB
         1k6/QjOO20OLj/xo/lKVo+CRKr6WFqpuGFSRMvPrWVadAku/qgnXVNPdQn31ISixLj
         et/UsKwTXLGjzfD2Mhk4GG7NJIvf4OIljD+EGliIihGiA36Rl9zEL+kpHyYX3SFB6C
         ZcZyc941/r2ypSsZotGZs/Js2s5KC49PqvZRMDDwVpAnOvYlMNkgwyI95kXpqj9+pB
         LnLwWrCy0f1lA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Mon, 20 Mar 2023 20:46:50 +0300 (MSK)
Message-ID: <08d61bef-0c11-c7f9-9266-cb2109070314@sberdevices.ru>
Date:   Mon, 20 Mar 2023 20:43:29 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
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
Subject: [PATCH net-next v1] virtio/vsock: check transport before skb
 allocation
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/20 09:56:00 #20977321
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pointer to transport could be checked before allocation of skbuff, thus
there is no need to free skbuff when this pointer is NULL.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index cda587196475..607149259e8b 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -867,6 +867,9 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (le16_to_cpu(hdr->op) == VIRTIO_VSOCK_OP_RST)
 		return 0;
 
+	if (!t)
+		return -ENOTCONN;
+
 	reply = virtio_transport_alloc_skb(&info, 0,
 					   le64_to_cpu(hdr->dst_cid),
 					   le32_to_cpu(hdr->dst_port),
@@ -875,11 +878,6 @@ static int virtio_transport_reset_no_sock(const struct virtio_transport *t,
 	if (!reply)
 		return -ENOMEM;
 
-	if (!t) {
-		kfree_skb(reply);
-		return -ENOTCONN;
-	}
-
 	return t->send_pkt(reply);
 }
 
-- 
2.25.1

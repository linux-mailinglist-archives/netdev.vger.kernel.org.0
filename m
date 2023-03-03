Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4756AA609
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:03:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbjCDAD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDAD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:03:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6B95EC71;
        Fri,  3 Mar 2023 16:03:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C4DB85FD19;
        Sat,  4 Mar 2023 01:04:24 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677881064;
        bh=Icgy8iDTd8OsLA0qcC7gyzpquMde/dsgpaxAtiinzyo=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=bBOOyNLjfdEd0XdCMzLE+adQMP36CslJqEklfr63E9CrBCwE6EPFLDpSGUbxhL+uE
         9+PiLk1FV2GDtqjPqDFZhIg9QtlwRlt5ffO5bDFsFU4HM8OlZNEtc/J84NUP7l+Pc4
         SpnxpNF9BMGvHtU0nMzUNVS7IhmokX9C192mwi5QnMRRtVn9V28NNMDo/WntG8EZSn
         5vFsK6X30TEm+YiDW1Glcdu5N2Rmxg4eKiaiFr0At5F0G1M+khWOoKcVGq6uAJTq40
         9UPgdHM50t3WUIWQhZpBxdypTIfTymbanNevw8AHi1nlqx5eFE8f+VEBuIicdNQYyr
         diI7J7Ow17ieA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  4 Mar 2023 01:04:24 +0300 (MSK)
Message-ID: <0ec95196-7445-b183-022d-fd3e1e1a7529@sberdevices.ru>
Date:   Sat, 4 Mar 2023 01:01:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru>
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
Subject: [RFC PATCH v1 2/3] virtio/vsock: fix 'rx_bytes'/'fwd_cnt' calculation
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/03 17:09:00 #20912733
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Substraction of 'skb->len' is redundant here: 'skb_headroom()' is delta
between 'data' and 'head' pointers, e.g. it is number of bytes returned
to user (of course accounting size of header). 'skb->len' is number of
bytes rest in buffer.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 77bb1cad8471..d80075e1db42 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -255,7 +255,7 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
 {
 	int len;
 
-	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
+	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr);
 
 	if (len < 0)
 		pr_emerg("Negative len %i\n", len);
-- 
2.25.1

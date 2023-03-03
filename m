Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD3E6AA604
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjCDAD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjCDAD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:03:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B655FEB50;
        Fri,  3 Mar 2023 16:03:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 64FE45FD2E;
        Sat,  4 Mar 2023 01:05:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677881119;
        bh=e3N0YJ0uSXUIygh8I5oRxE8zPq5uyuoYZQhh7v2tXp4=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=bEKaIMcFKwNSwUf9ShSc9fH+vHOfHn84oXfVs+JOqa0cEqfp4DbzYMC15A03tDHh7
         3v8S32KaH1beaxPMyp9BAsCkFOIDPQE3uYbdSi1f91YijkE0i12Sb4P9g/0juaDv7p
         t+PPLZFt25ogbsBqHiFLgSXQxtnWJyQMWGEr+zGDMnNV0XRoOatBiaFk5NdmwD6Zc+
         ZofIZ1tbuPzNdzvdiyYZrj4fsAx+DBzK+696tpxVcqEwjuqL7JZtmtlJya0RUUOKY8
         xnr2wdKaseE7+hMynk9xbG8GfX//9I9aFR0SjPKXfDZOEZMjTk7Y6MhRKdrJJFB4n5
         4LTocHToMBjEw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  4 Mar 2023 01:05:19 +0300 (MSK)
Message-ID: <b6fe000f-5638-28d0-525f-ce38cc2cb036@sberdevices.ru>
Date:   Sat, 4 Mar 2023 01:02:29 +0300
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
Subject: [RFC PATCH v1 3/3] virtio/vsock: remove all data from sk_buff
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

In case of SOCK_SEQPACKET all sk_buffs are used once - after read some
data from it, it will be removed, so user will never read rest of the
data. Thus we need to update credit parameters of the socket like whole
sk_buff is read - so call 'skb_pull()' for the whole buffer.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d80075e1db42..bbcf331b6ad6 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -470,7 +470,7 @@ static int virtio_transport_seqpacket_do_dequeue(struct vsock_sock *vsk,
 					dequeued_len = err;
 				} else {
 					user_buf_len -= bytes_to_copy;
-					skb_pull(skb, bytes_to_copy);
+					skb_pull(skb, skb->len);
 				}
 
 				spin_lock_bh(&vvs->rx_lock);
-- 
2.25.1

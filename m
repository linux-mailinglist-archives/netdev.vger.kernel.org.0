Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFFD86C911C
	for <lists+netdev@lfdr.de>; Sat, 25 Mar 2023 23:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbjCYWIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Mar 2023 18:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCYWII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Mar 2023 18:08:08 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670122D41;
        Sat, 25 Mar 2023 15:08:07 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C3AAE5FD02;
        Sun, 26 Mar 2023 01:08:05 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679782085;
        bh=qj2eKpHg24lBwg8Ceng11FmHD2L6ZT5DPMiSeVXYd5I=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=Ycs9Ovje0B4OKkIJ/clxG6LEDH4VwyLuA93Gz+OTctkXltwnvYo2Q2uVRttVOm+9C
         HDugKuMhCSpaOUXlwcRksXnHep9dGd5bwA1JmgJUR884hfeiRYSNjTvjjEwtb8zDKE
         zMNlR5KdIgu0MLluBcpoBcO2jyPCyXxvzJoozSTVQGJ+d3/LBXPoM8eysq/Z59KDnf
         4/KqvCV+XcFFnVsWW7GJv2GjgyUAA8o0DAjNdYe7hv9Xazgmy8zzou24aYJSyaI6Tc
         om1v483NxzYV56k53Fr6ISmAqYsNBXgTUdTL4X7m7JaLg/RRk4k0zViw5AtX7mzOYt
         Ipz8sBJjAduXg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 26 Mar 2023 01:08:05 +0300 (MSK)
Message-ID: <1ea0c407-814f-38a0-1fb7-4f146e5643ba@sberdevices.ru>
Date:   Sun, 26 Mar 2023 01:04:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <b0d15942-65ba-3a32-ba8d-fed64332d8f6@sberdevices.ru>
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
Subject: [PATCH net-next v5 2/2] virtio/vsock: check argument to avoid no
 effect call
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/25 18:14:00 #21009230
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both of these functions have no effect when input argument is 0, so to
avoid useless spinlock access, check argument before it.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 net/vmw_vsock/virtio_transport_common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index 9e87c7d4d7cf..312658c176bd 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -302,6 +302,9 @@ u32 virtio_transport_get_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
 	u32 ret;
 
+	if (!credit)
+		return 0;
+
 	spin_lock_bh(&vvs->tx_lock);
 	ret = vvs->peer_buf_alloc - (vvs->tx_cnt - vvs->peer_fwd_cnt);
 	if (ret > credit)
@@ -315,6 +318,9 @@ EXPORT_SYMBOL_GPL(virtio_transport_get_credit);
 
 void virtio_transport_put_credit(struct virtio_vsock_sock *vvs, u32 credit)
 {
+	if (!credit)
+		return;
+
 	spin_lock_bh(&vvs->tx_lock);
 	vvs->tx_cnt -= credit;
 	spin_unlock_bh(&vvs->tx_lock);
-- 
2.25.1

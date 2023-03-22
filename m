Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE55E6C53DD
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjCVSji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVSjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:39:37 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFD810F8;
        Wed, 22 Mar 2023 11:39:36 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 87DC25FD3E;
        Wed, 22 Mar 2023 21:39:34 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679510374;
        bh=2jI7XF69xGSYc6uWoXcTewsdZMSwsHV3zIs6n8EvIlc=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=SZpMU2qEABc12peDtdbirDKGuboITfiDWAirBrD6tS8q1573+ddUDcT40cjQtEPvE
         v8HUT2EfMlxnzHn3hHhbAjZdf+/roRZcTrSNAdD9hyD9wcfnt1Cqao5CDZ5DRs6BXO
         tc7mbOPAyo+dj/qBRGCDaPDBdjHfjC8J8vQ2Dbptf3NnUPnN64vdair/N5WgweZ35y
         eoU+gRWNdp0YKRN5KX0ku2QRugtBV37cSBWkEMUgfBEhkFTD6ApMiyTR09B3Zs+JwI
         4uhdPb2Qyg0NPKhwQv3QXLKhBwthB0cvfQtfyb7IQxpFm+YrrJiTJsl7eJB5/OooTg
         dB9e3N1t8nvCg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Wed, 22 Mar 2023 21:39:34 +0300 (MSK)
Message-ID: <50bb0210-1ed7-42fb-b5f6-8d97247209b5@sberdevices.ru>
Date:   Wed, 22 Mar 2023 21:36:24 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <f0b283a1-cc63-dc3d-cc0c-0da7f684d4d2@sberdevices.ru>
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
Subject: [RFC PATCH v5 2/2] virtio/vsock: check argument to avoid no effect
 call
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/22 14:20:00 #20991698
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both of these functions have no effect when input argument is 0, so to
avoid useless spinlock access, check argument before it.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
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

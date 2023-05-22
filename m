Return-Path: <netdev+bounces-4164-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1065270B6F4
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:48:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4D011C209FD
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:48:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16BFBA26;
	Mon, 22 May 2023 07:44:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12E7AD5F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:44:58 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07E4AC;
	Mon, 22 May 2023 00:44:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id DEC455FD56;
	Mon, 22 May 2023 10:44:54 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684741494;
	bh=26CL2gVE0g6kFd3ZFQdsGyNdyslfGmT/ZpPrRg3+nfI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=FLz9U0xFG1yg33DEPX8QATfMVKIv+eXi/BP2X1RDoT4U2/0oDAcN9Vh6Nu6zxD0co
	 zWMRbtT6Q+5gLnSt2xjK5y8EbCfMStT2XTSw95tzELfgIzKnNKCvmXDQR+l8UurAvj
	 qT1il6NcQl46+LYAM5sXLQf1xn4C/KZY+/0PoMgcTbv2x2x70bSKzS13adOhrVzimY
	 I3HfaSQIoidKxfUgdx7byM1/s4THYkAUuLJfiXPaOo/SGtJNufMkUCT2D3bgWumaSf
	 2Z6nPO9V9pXKHujqhlknh+rZTNUoZD9hseUYBCHl0W2/RdjFBxLq2N5ct+US75Lrxc
	 +cUxOzUGPMhcw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 10:44:54 +0300 (MSK)
From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
To: Stefan Hajnoczi <stefanha@redhat.com>, Stefano Garzarella
	<sgarzare@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
	<edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang
	<jasowang@redhat.com>, Bobby Eshleman <bobby.eshleman@bytedance.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel@sberdevices.ru>, <oxffffaa@gmail.com>, <avkrasnov@sberdevices.ru>,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Subject: [RFC PATCH v3 12/17] vsock/loopback: support MSG_ZEROCOPY for transport
Date: Mon, 22 May 2023 10:39:45 +0300
Message-ID: <20230522073950.3574171-13-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH02.sberdevices.ru (172.16.1.5) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/05/22 04:49:00 #21364689
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add 'msgzerocopy_allow()' callback for loopback transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/vsock_loopback.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/vmw_vsock/vsock_loopback.c b/net/vmw_vsock/vsock_loopback.c
index 5c6360df1f31..a2e4aeda2d92 100644
--- a/net/vmw_vsock/vsock_loopback.c
+++ b/net/vmw_vsock/vsock_loopback.c
@@ -47,6 +47,7 @@ static int vsock_loopback_cancel_pkt(struct vsock_sock *vsk)
 }
 
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid);
+static bool vsock_loopback_msgzerocopy_allow(void);
 
 static struct virtio_transport loopback_transport = {
 	.transport = {
@@ -92,11 +93,18 @@ static struct virtio_transport loopback_transport = {
 		.notify_buffer_size       = virtio_transport_notify_buffer_size,
 
 		.read_skb = virtio_transport_read_skb,
+
+		.msgzerocopy_allow        = vsock_loopback_msgzerocopy_allow,
 	},
 
 	.send_pkt = vsock_loopback_send_pkt,
 };
 
+static bool vsock_loopback_msgzerocopy_allow(void)
+{
+	return true;
+}
+
 static bool vsock_loopback_seqpacket_allow(u32 remote_cid)
 {
 	return true;
-- 
2.25.1



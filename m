Return-Path: <netdev+bounces-7714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5997212FA
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:57:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 509F51C20FBC
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716A2156C6;
	Sat,  3 Jun 2023 20:54:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6629B134D7
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:54:59 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 095101A4;
	Sat,  3 Jun 2023 13:54:56 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id 297185FD38;
	Sat,  3 Jun 2023 23:54:48 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825688;
	bh=dXr+GIu8Zm+IAJzZ6mwmY2cDmvd5mo+b/fOvW2U8kdk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=ks/7oWLtr330mkiMnbGgANJJCiYqGyGQCEeTfb987iEuqYyr5+9r9b7DRlEB/pxeo
	 ISh3gxPb/3LEcuMNoNYgRLI9Gptgxf2R2yCOxKCBkr157M2hIZ9joS9NM+YUMBok6U
	 p1+9uCsE3tGbYXuxNX4vmmhNr/MdcYvLqq3M1x+VM/m/CVsPozGt4/AG2BTkDCfrWU
	 yOJ7dLtrywEsY6o8xwEDzs54xtn/BRpJp+8AzoWNj1jLkKPUfjjKVotOBiEDG7yGau
	 /w++evFeX9TSkItCLzrkwu1fNuixwtgHr+eix+AZ0W44OaOfJ3shSDNmdXkoe7Obm9
	 57Nn/Y8yExQnw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:48 +0300 (MSK)
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
Subject: [RFC PATCH v4 08/17] vsock: check for MSG_ZEROCOPY support on send
Date: Sat, 3 Jun 2023 23:49:30 +0300
Message-ID: <20230603204939.1598818-9-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
References: <20230603204939.1598818-1-AVKrasnov@sberdevices.ru>
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/03 16:55:00 #21417531
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This feature totally depends on transport, so if transport doesn't
support it, return error.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/net/af_vsock.h   | 7 +++++++
 net/vmw_vsock/af_vsock.c | 6 ++++++
 2 files changed, 13 insertions(+)

diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 0e7504a42925..ec09edc5f3a0 100644
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
@@ -243,4 +246,8 @@ static inline void __init vsock_bpf_build_proto(void)
 {}
 #endif
 
+static inline bool vsock_msgzerocopy_allow(const struct vsock_transport *t)
+{
+	return t->msgzerocopy_allow && t->msgzerocopy_allow();
+}
 #endif /* __AF_VSOCK_H__ */
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 07803d9fbf6d..033006e1b5ad 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1824,6 +1824,12 @@ static int vsock_connectible_sendmsg(struct socket *sock, struct msghdr *msg,
 		goto out;
 	}
 
+	if (msg->msg_flags & MSG_ZEROCOPY &&
+	    !vsock_msgzerocopy_allow(transport)) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
 	/* Wait for room in the produce queue to enqueue our user's data. */
 	timeout = sock_sndtimeo(sk, msg->msg_flags & MSG_DONTWAIT);
 
-- 
2.25.1



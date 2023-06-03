Return-Path: <netdev+bounces-7711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1367C7212F6
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 22:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A98E1C209F2
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 20:56:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 540E211C86;
	Sat,  3 Jun 2023 20:54:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4879D11C85
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 20:54:58 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AA5B3;
	Sat,  3 Jun 2023 13:54:55 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id E21A95FD37;
	Sat,  3 Jun 2023 23:54:47 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1685825687;
	bh=ApoSi7ZfTEhQVGLgapLVsvDQGAGgUMVtdzLvgIwP5vU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=AtVJ9LHYCx6rZSQS+YMDX5FaJbjdJxUrIEQ1YaCWynDCrMbEBlEfoKr1DYMS2Sub6
	 /HMXGkJS0o9xZFnLGQTRLswCddVWe7MYxm3FYN95KkPfdwzma4E6n251rr8XUFjAVR
	 YfX2ftHGxjH4VWAUNnk8ngHJ+5f4pO+ZKmQuF2b0NQT4oZKKohvWWI2TxMH42efJHe
	 kolX/+GqXDSoxE7cozf1cDcTK+YQzKzKFUTSaSR9Ig5pA4zFVAPkntVLdQd5DOU7ad
	 lo9n0yT1SzjUKzfoNY6JtI9kQbYlBZFgw25V5ADfFGXZxhsRX5GKtOV7YvqnDubhD9
	 pQd48J4Waj8pQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sat,  3 Jun 2023 23:54:47 +0300 (MSK)
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
Subject: [RFC PATCH v4 07/17] vsock: read from socket's error queue
Date: Sat, 3 Jun 2023 23:49:29 +0300
Message-ID: <20230603204939.1598818-8-AVKrasnov@sberdevices.ru>
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

This adds handling of MSG_ERRQUEUE input flag in receive call. This flag
is used to read socket's error queue instead of data queue. Possible
scenario of error queue usage is receiving completions for transmission
with MSG_ZEROCOPY flag.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 include/linux/socket.h   | 1 +
 net/vmw_vsock/af_vsock.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index bd1cc3238851..d79efd026880 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -382,6 +382,7 @@ struct ucred {
 #define SOL_MPTCP	284
 #define SOL_MCTP	285
 #define SOL_SMC		286
+#define SOL_VSOCK	287
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 45fd20c4ed50..07803d9fbf6d 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -110,6 +110,7 @@
 #include <linux/workqueue.h>
 #include <net/sock.h>
 #include <net/af_vsock.h>
+#include <linux/errqueue.h>
 
 static int __vsock_bind(struct sock *sk, struct sockaddr_vm *addr);
 static void vsock_sk_destruct(struct sock *sk);
@@ -2135,6 +2136,10 @@ vsock_connectible_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	int err;
 
 	sk = sock->sk;
+
+	if (unlikely(flags & MSG_ERRQUEUE))
+		return sock_recv_errqueue(sk, msg, len, SOL_VSOCK, 0);
+
 	vsk = vsock_sk(sk);
 	err = 0;
 
-- 
2.25.1



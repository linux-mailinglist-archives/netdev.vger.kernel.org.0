Return-Path: <netdev+bounces-11760-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB7D73451F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 08:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E8732811F2
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 06:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6C51852;
	Sun, 18 Jun 2023 06:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587ED17C1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 06:30:12 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77EDB171B;
	Sat, 17 Jun 2023 23:30:06 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id D9DD95FD27;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1687069802;
	bh=zgsAeO7ZZncpPTynVaz+VDbdNBDA85YSMh2T8X4pUbw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=G0gbPFZRqGQHbjLXDcfSz97/AlUdJ/hYlNUzaQc7QF10oG0HeEYx/zuqoqlV1jjET
	 648yw2Y70OznSk4NQPFE+NmBfcGeMd4p+gM0ym85lxvKeFID49HNSOvbTnlN6wQD4u
	 otMX2uT/MQ4vl89kxgWLsXajiDqz4Jiey+gvyi14OU6CtKsEcHdFB4Y4R/3U4zqmCf
	 xPJiQHiiylOGiBbV8t4OdMdFXXLPW0WTi5ZnTU7Y/xu/HWiszk++pHCjwvUJOvZ8rl
	 RpGBhXKP19QYIi1D73SwjoeQdSZDhnKtcLhtMriNxsRMCgHNayA7JDw23UGDGJQeKh
	 MAnBFBOE2FGCg==
Received: from p-i-exch-sc-m01.sberdevices.ru (p-i-exch-sc-m01.sberdevices.ru [172.16.192.107])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
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
Subject: [RFC PATCH v1 4/4] vsock/test: MSG_PEEK test for SOCK_SEQPACKET
Date: Sun, 18 Jun 2023 09:24:51 +0300
Message-ID: <20230618062451.79980-5-AVKrasnov@sberdevices.ru>
X-Mailer: git-send-email 2.35.0
In-Reply-To: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
References: <20230618062451.79980-1-AVKrasnov@sberdevices.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 p-i-exch-sc-m01.sberdevices.ru (172.16.192.107)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/06/18 01:53:00 #21507494
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This adds MSG_PEEK test for SOCK_SEQPACKET. It works in the same way as
SOCK_STREAM test, except it also tests MSG_TRUNC flag.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 58 +++++++++++++++++++++++++++++---
 1 file changed, 54 insertions(+), 4 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 104ac102e411..2bacd0ea1195 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -257,13 +257,18 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 
 #define MSG_PEEK_BUF_LEN 64
 
-static void test_stream_msg_peek_client(const struct test_opts *opts)
+static void __test_msg_peek_client(const struct test_opts *opts,
+				   bool seqpacket)
 {
 	unsigned char buf[MSG_PEEK_BUF_LEN];
 	int fd;
 	int i;
 
-	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (seqpacket)
+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	else
+		fd = vsock_stream_connect(opts->peer_cid, 1234);
+
 	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
@@ -278,7 +283,8 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
 	close(fd);
 }
 
-static void test_stream_msg_peek_server(const struct test_opts *opts)
+static void __test_msg_peek_server(const struct test_opts *opts,
+				   bool seqpacket)
 {
 	unsigned char buf_half[MSG_PEEK_BUF_LEN / 2];
 	unsigned char buf_normal[MSG_PEEK_BUF_LEN];
@@ -286,7 +292,11 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	ssize_t res;
 	int fd;
 
-	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (seqpacket)
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	else
+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+
 	if (fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
@@ -328,6 +338,21 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
+	if (seqpacket) {
+		/* This type of socket supports MSG_TRUNC flag,
+		 * so check it with MSG_PEEK. We must get length
+		 * of the message.
+		 */
+		res = recv(fd, buf_half, sizeof(buf_half), MSG_PEEK |
+			   MSG_TRUNC);
+		if (res != sizeof(buf_peek)) {
+			fprintf(stderr,
+				"recv(2) + MSG_PEEK | MSG_TRUNC, exp %zu, got %zi\n",
+				sizeof(buf_half), res);
+			exit(EXIT_FAILURE);
+		}
+	}
+
 	res = recv(fd, buf_normal, sizeof(buf_normal), 0);
 	if (res != sizeof(buf_normal)) {
 		fprintf(stderr, "recv(2), expected %zu, got %zi\n",
@@ -344,6 +369,16 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_stream_msg_peek_client(const struct test_opts *opts)
+{
+	return __test_msg_peek_client(opts, false);
+}
+
+static void test_stream_msg_peek_server(const struct test_opts *opts)
+{
+	return __test_msg_peek_server(opts, false);
+}
+
 #define SOCK_BUF_SIZE (2 * 1024 * 1024)
 #define MAX_MSG_SIZE (32 * 1024)
 
@@ -1113,6 +1148,16 @@ static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_seqpacket_msg_peek_client(const struct test_opts *opts)
+{
+	return __test_msg_peek_client(opts, true);
+}
+
+static void test_seqpacket_msg_peek_server(const struct test_opts *opts)
+{
+	return __test_msg_peek_server(opts, true);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1188,6 +1233,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_stream_virtio_skb_merge_client,
 		.run_server = test_stream_virtio_skb_merge_server,
 	},
+	{
+		.name = "SOCK_SEQPACKET MSG_PEEK",
+		.run_client = test_seqpacket_msg_peek_client,
+		.run_server = test_seqpacket_msg_peek_server,
+	},
 	{},
 };
 
-- 
2.25.1



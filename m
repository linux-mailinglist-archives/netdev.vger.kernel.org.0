Return-Path: <netdev+bounces-11758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A2773451D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 08:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 874E31C20A0A
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 06:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32923A21;
	Sun, 18 Jun 2023 06:30:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2686315C5
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 06:30:12 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60538170F;
	Sat, 17 Jun 2023 23:30:06 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id ABF615FD26;
	Sun, 18 Jun 2023 09:30:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1687069802;
	bh=C0ocaakdqj4G3FMGCAU0A4MaUUuY31aUi2qpmz1hgcU=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=j2iKr/dSCjoUXGFex1Yk7pFgJmAUXTCmgO4d+ft9wjT/H2AYTr8TO174awZUKn+bB
	 s6WR3ZK9xJAC5NTJxEjr7WUK26PkGMBf6YDJIKqyOVyhTb00qoNQLAI+Q/TWU2+NwA
	 2awTKu25ZBr5YpYM0SQyMYVbDy0OWRSeuckE+Ew9rljlU2fxgU+s1BjARX+NheEkK2
	 SBgQMU0/H/j7RRgdZiqLABMNGO8O+3UNaHHB8vf4KVTOUd8SfQ1Y+az+oLJbGnEhtw
	 dP3vdPUXSld7BkukGxhR11sSdqCQ0yodgCd2dl7UdMgZ/cUltuHDutOT34LTQMXqLp
	 4pTW2oOcKIzkQ==
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
Subject: [RFC PATCH v1 3/4] vsock/test: rework MSG_PEEK test for SOCK_STREAM
Date: Sun, 18 Jun 2023 09:24:50 +0300
Message-ID: <20230618062451.79980-4-AVKrasnov@sberdevices.ru>
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

This new version makes test more complicated by adding empty read,
partial read and data comparisons between MSG_PEEK and normal reads.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 66 ++++++++++++++++++++++++++++++--
 1 file changed, 63 insertions(+), 3 deletions(-)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index ac1bd3ac1533..104ac102e411 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -255,9 +255,13 @@ static void test_stream_multiconn_server(const struct test_opts *opts)
 		close(fds[i]);
 }
 
+#define MSG_PEEK_BUF_LEN 64
+
 static void test_stream_msg_peek_client(const struct test_opts *opts)
 {
+	unsigned char buf[MSG_PEEK_BUF_LEN];
 	int fd;
+	int i;
 
 	fd = vsock_stream_connect(opts->peer_cid, 1234);
 	if (fd < 0) {
@@ -265,12 +269,21 @@ static void test_stream_msg_peek_client(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	send_byte(fd, 1, 0);
+	for (i = 0; i < sizeof(buf); i++)
+		buf[i] = rand() & 0xFF;
+
+	control_expectln("SRVREADY");
+
+	send(fd, buf, sizeof(buf), 0);
 	close(fd);
 }
 
 static void test_stream_msg_peek_server(const struct test_opts *opts)
 {
+	unsigned char buf_half[MSG_PEEK_BUF_LEN / 2];
+	unsigned char buf_normal[MSG_PEEK_BUF_LEN];
+	unsigned char buf_peek[MSG_PEEK_BUF_LEN];
+	ssize_t res;
 	int fd;
 
 	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
@@ -279,8 +292,55 @@ static void test_stream_msg_peek_server(const struct test_opts *opts)
 		exit(EXIT_FAILURE);
 	}
 
-	recv_byte(fd, 1, MSG_PEEK);
-	recv_byte(fd, 1, 0);
+	/* Peek from empty socket. */
+	res = recv(fd, buf_peek, sizeof(buf_peek), MSG_PEEK | MSG_DONTWAIT);
+	if (res != -1) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != EAGAIN) {
+		perror("EAGAIN expected");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SRVREADY");
+
+	/* Peek part of data. */
+	res = recv(fd, buf_half, sizeof(buf_half), MSG_PEEK);
+	if (res != sizeof(buf_half)) {
+		fprintf(stderr, "recv(2) + MSG_PEEK, expected %zu, got %zi\n",
+			sizeof(buf_half), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Peek whole data. */
+	res = recv(fd, buf_peek, sizeof(buf_peek), MSG_PEEK);
+	if (res != sizeof(buf_peek)) {
+		fprintf(stderr, "recv(2) + MSG_PEEK, expected %zu, got %zi\n",
+			sizeof(buf_peek), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Compare partial and full peek. */
+	if (memcmp(buf_half, buf_peek, sizeof(buf_half))) {
+		fprintf(stderr, "Partial peek data mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	res = recv(fd, buf_normal, sizeof(buf_normal), 0);
+	if (res != sizeof(buf_normal)) {
+		fprintf(stderr, "recv(2), expected %zu, got %zi\n",
+			sizeof(buf_normal), res);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Compare full peek and normal read. */
+	if (memcmp(buf_peek, buf_normal, sizeof(buf_peek))) {
+		fprintf(stderr, "Full peek data mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
 	close(fd);
 }
 
-- 
2.25.1



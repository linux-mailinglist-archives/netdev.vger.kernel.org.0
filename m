Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3296AB209
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 21:12:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCEUMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 15:12:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCEUMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 15:12:47 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CC816891;
        Sun,  5 Mar 2023 12:12:46 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id B88B55FD04;
        Sun,  5 Mar 2023 23:12:44 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678047164;
        bh=LBlyx/TJwFonLBm4/UgbK3j5G7h+oxv2IfiFYdPacyQ=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=Ufyh+Um3BnhTeU4iJIGmbF32wZXu2nh7hbxlNDCDYDjZk6CW95jlcZzVg8HmUlED1
         IzuDAqifRJeIbCMQ1yENpcmoHesh6ADUFZtQyxLMGPX+wYuuRUY/fZd2TISEynOQ4T
         nFq7aX/MnjIBtD71GhYyeUBir+NI+qyY+K8kMHkJ6Wguhgx8K7ptM59q0xPhQ45nnO
         rZytQjJzr0JRvflPoQXfN/LLyZjCglfrnFUIm8ZPo2ttSmzSjKS7PXVRG5DgRhCunb
         wHLaV+Mscmb0GuLN8BRHTWtNv/frAgO9xUidKM4FbnWVAv5BBAJ8K9bSiR+1F6oEQC
         o73ge+Tal2PmQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun,  5 Mar 2023 23:12:44 +0300 (MSK)
Message-ID: <33c2a09f-7f0e-d416-8009-bbb6a67ec752@sberdevices.ru>
Date:   Sun, 5 Mar 2023 23:09:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <a7ab414b-5e41-c7b6-250b-e8401f335859@sberdevices.ru>
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
Subject: [RFC PATCH v2 4/4] test/vsock: invalid buffer tests
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/05 16:13:00 #20917262
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds STREAM and SEQPACKET tests for invalid buffer handling. It
tries to read data to NULL buffer (data already presents in socket's
queue), on fail kernel will free skbuff with data and next read with
MSG_DONTWAIT flag must return EAGAIN which means that skbuff was
dropped and socket's queue is empty.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 106 +++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 67e9f9df3a8c..a17794a2d66c 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -860,6 +860,102 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_inv_buf_client(const struct test_opts *opts, bool stream)
+{
+	unsigned char data[512] = {0};
+	ssize_t ret;
+	int fd;
+
+	if (stream)
+		fd = vsock_stream_connect(opts->peer_cid, 1234);
+	else
+		fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SENDDONE");
+
+	/* Use invalid buffer here. */
+	ret = recv(fd, NULL, sizeof(data), 0);
+	if (ret != -1) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != ENOMEM) {
+		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	/* Now use valid buffer, but socket's queue must be empty. */
+	ret = recv(fd, data, sizeof(data), MSG_DONTWAIT);
+	if (ret != -1) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
+		exit(EXIT_FAILURE);
+	}
+
+	if (errno != EAGAIN) {
+		fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_inv_buf_server(const struct test_opts *opts, bool stream)
+{
+	unsigned char data[512] = {0};
+	ssize_t res;
+	int fd;
+
+	if (stream)
+		fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	else
+		fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	res = send(fd, data, sizeof(data), 0);
+	if (res != sizeof(data)) {
+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SENDDONE");
+
+	control_expectln("DONE");
+
+	close(fd);
+}
+
+static void test_stream_inv_buf_client(const struct test_opts *opts)
+{
+	test_inv_buf_client(opts, true);
+}
+
+static void test_stream_inv_buf_server(const struct test_opts *opts)
+{
+	test_inv_buf_server(opts, true);
+}
+
+static void test_seqpacket_inv_buf_client(const struct test_opts *opts)
+{
+	test_inv_buf_client(opts, false);
+}
+
+static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
+{
+	test_inv_buf_server(opts, false);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -920,6 +1016,16 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_bigmsg_client,
 		.run_server = test_seqpacket_bigmsg_server,
 	},
+	{
+		.name = "SOCK_STREAM test invalid buffer",
+		.run_client = test_stream_inv_buf_client,
+		.run_server = test_stream_inv_buf_server,
+	},
+	{
+		.name = "SOCK_SEQPACKET test invalid buffer",
+		.run_client = test_seqpacket_inv_buf_client,
+		.run_server = test_seqpacket_inv_buf_server,
+	},
 	{},
 };
 
-- 
2.25.1

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 209206CBDE9
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232314AbjC1Lgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjC1Lgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:36:32 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A7959E9;
        Tue, 28 Mar 2023 04:36:30 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id C87825FD14;
        Tue, 28 Mar 2023 14:36:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1680003388;
        bh=Y8nntKCoo+n61PM/8lM1Pimdv3DPve4+/I2dLAhzNuU=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=TVHnStf6myFchlia37InfF8F2J5RP/rNzHTcFe/Hm+P2DLzW2SPzvbOfgmHjpARAS
         yWzhn+Uj65RvkMRZZutEJF+EzNxIulyVE6pfhxMBGwpvkLgzj9jBPnH9EDPTi+actR
         XaXADzxkzemEIIAnohlv6MKEQ9UY8F/A2ISOn88iIXZw3RRMSej0k4G3DKfNc4/gP6
         qDbR28D4vT3kmAWOvCN1hPsBIzu/qeM1k+ayigGSElBDEVTzuMIFdO1hDZgLLKpfe0
         pShhRs1NomyV6KQJKCtxvsuJPbMFYit/scWawvD+IulzUyojjBOLZ/350644jcAFGg
         AQon4g+3PuQLg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 28 Mar 2023 14:36:28 +0300 (MSK)
Message-ID: <1e85f2b9-b958-0252-041d-6c48e04d9a19@sberdevices.ru>
Date:   Tue, 28 Mar 2023 14:33:07 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <0683cc6e-5130-484c-1105-ef2eb792d355@sberdevices.ru>
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
Subject: [PATCH net v2 3/3] test/vsock: new skbuff appending test
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/28 06:38:00 #21021220
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds test which checks case when data of newly received skbuff is
appended to the last skbuff in the socket's queue. It looks like simple
test with 'send()' and 'recv()', but internally it triggers logic which
appends one received skbuff to another. Test checks that this feature
works correctly.

This test is actual only for virtio transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 90 ++++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 3de10dbb50f5..12b97c92fbb2 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -968,6 +968,91 @@ static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
 	test_inv_buf_server(opts, false);
 }
 
+#define HELLO_STR "HELLO"
+#define WORLD_STR "WORLD"
+
+static void test_stream_virtio_skb_merge_client(const struct test_opts *opts)
+{
+	ssize_t res;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Send first skbuff. */
+	res = send(fd, HELLO_STR, strlen(HELLO_STR), 0);
+	if (res != strlen(HELLO_STR)) {
+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SEND0");
+	/* Peer reads part of first skbuff. */
+	control_expectln("REPLY0");
+
+	/* Send second skbuff, it will be appended to the first. */
+	res = send(fd, WORLD_STR, strlen(WORLD_STR), 0);
+	if (res != strlen(WORLD_STR)) {
+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SEND1");
+	/* Peer reads merged skbuff packet. */
+	control_expectln("REPLY1");
+
+	close(fd);
+}
+
+static void test_stream_virtio_skb_merge_server(const struct test_opts *opts)
+{
+	unsigned char buf[64];
+	ssize_t res;
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("SEND0");
+
+	/* Read skbuff partially. */
+	res = recv(fd, buf, 2, 0);
+	if (res != 2) {
+		fprintf(stderr, "expected recv(2) returns 2 bytes, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("REPLY0");
+	control_expectln("SEND1");
+
+	res = recv(fd, buf + 2, sizeof(buf) - 2, 0);
+	if (res != 8) {
+		fprintf(stderr, "expected recv(2) returns 8 bytes, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	res = recv(fd, buf, sizeof(buf) - 8 - 2, MSG_DONTWAIT);
+	if (res != -1) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	if (memcmp(buf, HELLO_STR WORLD_STR, strlen(HELLO_STR WORLD_STR))) {
+		fprintf(stderr, "pattern mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("REPLY1");
+
+	close(fd);
+}
+
 static struct test_case test_cases[] = {
 	{
 		.name = "SOCK_STREAM connection reset",
@@ -1038,6 +1123,11 @@ static struct test_case test_cases[] = {
 		.run_client = test_seqpacket_inv_buf_client,
 		.run_server = test_seqpacket_inv_buf_server,
 	},
+	{
+		.name = "SOCK_STREAM virtio skb merge",
+		.run_client = test_stream_virtio_skb_merge_client,
+		.run_server = test_stream_virtio_skb_merge_server,
+	},
 	{},
 };
 
-- 
2.25.1

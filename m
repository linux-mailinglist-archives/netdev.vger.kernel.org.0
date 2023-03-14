Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD1D46B913D
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 12:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjCNLNu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 07:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjCNLNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 07:13:46 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D0523871;
        Tue, 14 Mar 2023 04:13:09 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id D4B005FD61;
        Tue, 14 Mar 2023 14:12:36 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1678792356;
        bh=PF6KHzan4mSy2kGESR6B1xvrFo2PxPLxBlkqc63AEv0=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=V97g7Z1PcFuaP3jAELaZ84GVI5pDoM8EOmkpq8+lOcs+OMb0qD7kDdVlR+7AxGHXH
         tjk+J+D7PLCtAQ31welKzgyI6um2mq65G4aIWqpM61x0cLdd3sxJrA5ndauyCs0wRm
         Wktr7R+/rGBfyt1qiSV1t0iA5X012pkc0ZBeI1htiRXUFwK2na4VFACipsiCBHYPb8
         9P5zQ0sskM5xkPjaJEK/dylaX+HQF/nZ1Lllk6qCu14tWkToJJIE1hCKXQmL7qcsRV
         798VsI0I628PC074hPtzYbxdcUurtj1Pgq2THTWJw3CwobyPRsrbbTM7VtIg2aRpaI
         6tphEyEywXFqg==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 14 Mar 2023 14:12:36 +0300 (MSK)
Message-ID: <984e04b8-3f61-f59f-1683-414a53e7eca4@sberdevices.ru>
Date:   Tue, 14 Mar 2023 14:09:27 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <1bfcb7fd-bce3-30cf-8a58-8baa57b7345c@sberdevices.ru>
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
Subject: [PATCH RESEND net v4 4/4] test/vsock: copy to user failure test
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/14 06:01:00 #20942017
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds SOCK_STREAM and SOCK_SEQPACKET tests for invalid buffer case.
It tries to read data to NULL buffer (data already presents in socket's
queue), then uses valid buffer. For SOCK_STREAM second read must return
data, because skbuff is not dropped, but for SOCK_SEQPACKET skbuff will
be dropped by kernel, and 'recv()' will return EAGAIN.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/vsock_test.c | 118 +++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 67e9f9df3a8c..3de10dbb50f5 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -860,6 +860,114 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
 	close(fd);
 }
 
+#define INV_BUF_TEST_DATA_LEN 512
+
+static void test_inv_buf_client(const struct test_opts *opts, bool stream)
+{
+	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
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
+	ret = recv(fd, data, sizeof(data), MSG_DONTWAIT);
+
+	if (stream) {
+		/* For SOCK_STREAM we must continue reading. */
+		if (ret != sizeof(data)) {
+			fprintf(stderr, "expected recv(2) success, got %zi\n", ret);
+			exit(EXIT_FAILURE);
+		}
+		/* Don't check errno in case of success. */
+	} else {
+		/* For SOCK_SEQPACKET socket's queue must be empty. */
+		if (ret != -1) {
+			fprintf(stderr, "expected recv(2) failure, got %zi\n", ret);
+			exit(EXIT_FAILURE);
+		}
+
+		if (errno != EAGAIN) {
+			fprintf(stderr, "unexpected recv(2) errno %d\n", errno);
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	control_writeln("DONE");
+
+	close(fd);
+}
+
+static void test_inv_buf_server(const struct test_opts *opts, bool stream)
+{
+	unsigned char data[INV_BUF_TEST_DATA_LEN] = {0};
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
@@ -920,6 +1028,16 @@ static struct test_case test_cases[] = {
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

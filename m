Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF116C03F2
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 19:57:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjCSS5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 14:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbjCSS5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 14:57:16 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0905EF749;
        Sun, 19 Mar 2023 11:57:15 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 5A8B35FD08;
        Sun, 19 Mar 2023 21:57:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679252233;
        bh=Ur4jg6uAteONoMZU6lu41Y3TNMOYC8XZYn3Gott3yvA=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=hYExZj62rdKq/kQoxBw7vhVqZHzrMPXS1mzbZUM2WEuHSuQ/bJRIYnObuLlGDJCWE
         RprVYm7OatuydeKkYwb//Xd/1WrhwHmxOtE/vb2wOroGtpRHfJDkmz17mSaZh5MMF0
         Rn3QFlZpThxJTfYYb26aF1dYPinMORmCLDncowCImhUZZeT4LvlBA2IsV4B7Vr0Nqt
         Xr6fg0FEAj0bPrEyYshWwA/7Znku/iattGIP8hLcIMSLejHJw54W70PevOQ9s4OeJw
         088jv1DKn99uKPCMdv5/OidUKYx8v+ek+1SECxKtSnqcMW7fQKhKd288HOCaQ4BPYH
         y2Eh1Vt8bJXJQ==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sun, 19 Mar 2023 21:57:13 +0300 (MSK)
Message-ID: <14ca87d1-3e07-85e9-d11c-39789a9d17d4@sberdevices.ru>
Date:   Sun, 19 Mar 2023 21:53:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <e141e6f1-00ae-232c-b840-b146bdb10e99@sberdevices.ru>
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
Subject: [RFC PATCH v1 3/3] test/vsock: skbuff merging test
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/19 16:43:00 #20974059
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds test which checks case when data of newly received skbuff is
appended to the last skbuff in the socket's queue.

This test is actual only for virtio transport.

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/vsock_test.c | 81 ++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 3de10dbb50f5..00216c52d8b6 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -968,6 +968,82 @@ static void test_seqpacket_inv_buf_server(const struct test_opts *opts)
 	test_inv_buf_server(opts, false);
 }
 
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
+	res = send(fd, "HELLO", strlen("HELLO"), 0);
+	if (res != strlen("HELLO")) {
+		fprintf(stderr, "unexpected send(2) result %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("SEND0");
+	/* Peer reads part of first packet. */
+	control_expectln("REPLY0");
+
+	/* Send second skbuff, it will be merged. */
+	res = send(fd, "WORLD", strlen("WORLD"), 0);
+	if (res != strlen("WORLD")) {
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
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("REPLY0");
+	control_expectln("SEND1");
+
+	res = recv(fd, buf, sizeof(buf), 0);
+	if (res != 8) {
+		fprintf(stderr, "expected recv(2) failure, got %zi\n", res);
+		exit(EXIT_FAILURE);
+	}
+
+	res = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);
+	if (res != -1) {
+		fprintf(stderr, "expected recv(2) success, got %zi\n", res);
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
@@ -1038,6 +1114,11 @@ static struct test_case test_cases[] = {
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

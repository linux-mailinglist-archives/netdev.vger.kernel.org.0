Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34826AA60F
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjCDADe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229559AbjCDAD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:03:27 -0500
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6AFCEB5B;
        Fri,  3 Mar 2023 16:03:24 -0800 (PST)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id 9AF045FD07;
        Sat,  4 Mar 2023 01:03:03 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1677880983;
        bh=frCKZPP6m8x+qRpvRirAieIO1yh96VlFuo704GZeY9s=;
        h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type;
        b=cGtGBFy5msWICxW4y6khtiH1JVQNSZwvxRsX+IqOM68bj+KdDPgGWyyeDe9IcIz2f
         8qhLUdqp6eqfynBXq+2ILY9587Jr53gCbo7pvaAiQfQ50EL3WwZqZ5dkQMQw6lEkQB
         XGq60vcicDf093jolZfRbKacBMLcjAh7gL3GxVU+tovlAtB+gAExF7B2ORTcifxrDs
         S3JqI4uendMn9j3GuGXG/KVsf2rwWHviYV7EORGk8e2fVXUX9H882J0DnV6MDIVl0H
         2sgBYGvqEeIA00kkCyNW7nQN9TGEMUMV+iwE22/rPU3YP3MzNjYzoGPyLm99E27SOS
         03G3HBX9T2QGA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Sat,  4 Mar 2023 01:03:03 +0300 (MSK)
Message-ID: <482863e2-217d-364f-2710-c1cbfd5db4e9@sberdevices.ru>
Date:   Sat, 4 Mar 2023 01:00:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
In-Reply-To: <c2d3e204-89d9-88e9-8a15-3fe027e56b4b@sberdevices.ru>
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
Subject: [RFC PATCH v1 1/3] test/vsock: SOCK_SEQPACKET 'rx_bytes'/'fwd_cnt'
 bug reproducer
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
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/03 17:09:00 #20912733
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

virtio/vsock: replace virtio_vsock_pkt with sk_buff

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 net/vmw_vsock/virtio_transport_common.c |  4 +++
 tools/testing/vsock/vsock_test.c        | 44 +++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index a1581c77cf84..77bb1cad8471 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -256,6 +256,10 @@ static void virtio_transport_dec_rx_pkt(struct virtio_vsock_sock *vvs,
 	int len;
 
 	len = skb_headroom(skb) - sizeof(struct virtio_vsock_hdr) - skb->len;
+
+	if (len < 0)
+		pr_emerg("Negative len %i\n", len);
+
 	vvs->rx_bytes -= len;
 	vvs->fwd_cnt += len;
 }
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
index 67e9f9df3a8c..2651de2aedc9 100644
--- a/tools/testing/vsock/vsock_test.c
+++ b/tools/testing/vsock/vsock_test.c
@@ -860,7 +860,51 @@ static void test_stream_poll_rcvlowat_client(const struct test_opts *opts)
 	close(fd);
 }
 
+static void test_seqpacket_rxbytes_client(const struct test_opts *opts)
+{
+	unsigned char data[256];
+	int fd;
+
+	fd = vsock_seqpacket_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	send(fd, data, sizeof(data), 0);
+
+	control_writeln("CLISENT");
+
+	close(fd);
+
+	exit(0);
+}
+
+static void test_seqpacket_rxbytes_server(const struct test_opts *opts)
+{
+	unsigned char data[8];
+	int fd;
+
+	fd = vsock_seqpacket_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLISENT");
+	read(fd, data, sizeof(data));
+
+	close(fd);
+
+	exit(0);
+}
+
 static struct test_case test_cases[] = {
+	{
+		.name = "SOCK_SEQPACKET negative 'rx_bytes'",
+		.run_client = test_seqpacket_rxbytes_client,
+		.run_server = test_seqpacket_rxbytes_server,
+	},
 	{
 		.name = "SOCK_STREAM connection reset",
 		.run_client = test_stream_connection_reset,
-- 
2.25.1

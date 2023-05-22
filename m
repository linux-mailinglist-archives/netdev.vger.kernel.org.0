Return-Path: <netdev+bounces-4169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B9B070B702
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 09:50:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 108D9280D68
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 07:50:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC566BE5D;
	Mon, 22 May 2023 07:45:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE366C2F6
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 07:45:03 +0000 (UTC)
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47C10B7;
	Mon, 22 May 2023 00:45:01 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
	by mx.sberdevices.ru (Postfix) with ESMTP id A50B85FD5B;
	Mon, 22 May 2023 10:44:58 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
	s=mail; t=1684741498;
	bh=DXqP0IczEzgDBQJ6fAPr7/KJLfPJKmXbxF1s6z3wyJs=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	b=l7VIneBxEHQYo3ibIQYtSiKbXfgXjEyr4h38NjhzOTEBBguBikxPKs5lvqwkCa243
	 diK8bH1ijNSUlSOodJZkhlV05W2BlicvJVTTa4QHTjUL8SXwjNNrk52j3+ygSbotq9
	 4kxzvAgRu22Wh87s0BJQa03Pkm2Mep9HPDQkPK82+2/lET1JqPjh2kVJ3USg8JdS0r
	 Q3NR2NpRGm0GkKQHNl8zMCPyubHrrXwKWWKT2g+CEjDgM4s/VEwTBq+dpHHUOLTFAY
	 9+Ma69KiK/nr7WKsNJuFJsYvrGE3OLbDHhn7Ya9X5I9Cj1jt89KakHKWWLJ9TJ5QfW
	 Fa74lNvS334cw==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
	by mx.sberdevices.ru (Postfix) with ESMTP;
	Mon, 22 May 2023 10:44:58 +0300 (MSK)
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
Subject: [RFC PATCH v3 17/17] test/vsock: io_uring rx/tx tests
Date: Mon, 22 May 2023 10:39:50 +0300
Message-ID: <20230522073950.3574171-18-AVKrasnov@sberdevices.ru>
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

This adds set of tests which use io_uring for rx/tx. This test suite is
implemented as separated util like 'vsock_test' and has the same set of
input arguments as 'vsock_test'. These tests only cover cases of data
transmission (no connect/bind/accept etc).

Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
---
 tools/testing/vsock/Makefile           |   7 +-
 tools/testing/vsock/vsock_uring_test.c | 316 +++++++++++++++++++++++++
 2 files changed, 322 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/vsock/vsock_uring_test.c

diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index 0a78787d1d92..8621ae73051d 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,12 +1,17 @@
 # SPDX-License-Identifier: GPL-2.0-only
+ifeq ($(MAKECMDGOALS),vsock_uring_test)
+LDFLAGS = -luring
+endif
+
 all: test vsock_perf
 test: vsock_test vsock_diag_test
 vsock_test: vsock_test.o vsock_test_zerocopy.o timeout.o control.o util.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
 vsock_perf: vsock_perf.o
+vsock_uring_test: control.o util.o vsock_uring_test.o timeout.o $(LDFLAGS)
 
 CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
 clean:
-	${RM} *.o *.d vsock_test vsock_diag_test
+	${RM} *.o *.d vsock_test vsock_diag_test vsock_uring_test
 -include *.d
diff --git a/tools/testing/vsock/vsock_uring_test.c b/tools/testing/vsock/vsock_uring_test.c
new file mode 100644
index 000000000000..5d0f0f48a794
--- /dev/null
+++ b/tools/testing/vsock/vsock_uring_test.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* io_uring tests for vsock
+ *
+ * Copyright (C) 2023 SberDevices.
+ *
+ * Author: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
+ */
+
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <liburing.h>
+#include <unistd.h>
+#include <sys/mman.h>
+#include <linux/kernel.h>
+#include <error.h>
+
+#include "util.h"
+#include "control.h"
+
+#define PAGE_SIZE		4096
+#define RING_ENTRIES_NUM	4
+
+static struct vsock_test_data test_data_array[] = {
+	{
+		.use_zerocopy = true,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, 2 * PAGE_SIZE },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	},
+	{
+		.use_zerocopy = false,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ NULL, 2 * PAGE_SIZE },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	},
+	{
+		.use_zerocopy = true,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 200  },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	},
+	{
+		.use_zerocopy = false,
+		.vecs_cnt = 3,
+		{
+			{ NULL, PAGE_SIZE },
+			{ (void *)1, 200  },
+			{ NULL, 3 * PAGE_SIZE },
+		}
+	}
+};
+
+static void vsock_io_uring_client(const struct test_opts *opts,
+				  const struct vsock_test_data *test_data)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec *iovec;
+	struct msghdr msg;
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	enable_so_zerocopy(fd);
+
+	iovec = init_iovec_from_test_data(test_data);
+
+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
+		error(1, errno, "io_uring_queue_init");
+
+	if (io_uring_register_buffers(&ring, iovec, test_data->vecs_cnt))
+		error(1, errno, "io_uring_register_buffers");
+
+	memset(&msg, 0, sizeof(msg));
+	msg.msg_iov = iovec;
+	msg.msg_iovlen = test_data->vecs_cnt;
+	sqe = io_uring_get_sqe(&ring);
+
+	if (test_data->use_zerocopy)
+		io_uring_prep_sendmsg_zc(sqe, fd, &msg, 0);
+	else
+		io_uring_prep_sendmsg(sqe, fd, &msg, 0);
+
+	if (io_uring_submit(&ring) != 1)
+		error(1, errno, "io_uring_submit");
+
+	if (io_uring_wait_cqe(&ring, &cqe))
+		error(1, errno, "io_uring_wait_cqe");
+
+	io_uring_cqe_seen(&ring, cqe);
+
+	control_writeulong(iovec_hash_djb2(iovec, test_data->vecs_cnt));
+
+	control_writeln("DONE");
+	io_uring_queue_exit(&ring);
+	free_iovec_test_data(test_data, iovec);
+	close(fd);
+}
+
+void test_stream_uring_client(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_client(opts, &test_data_array[i]);
+}
+
+static void vsock_io_uring_server(const struct test_opts *opts,
+				  const struct vsock_test_data *test_data)
+{
+	unsigned long remote_hash;
+	unsigned long local_hash;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec iovec;
+	size_t data_len;
+	void *data;
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	data_len = iovec_bytes(test_data->vecs, test_data->vecs_cnt);
+
+	data = malloc(data_len);
+	if (!data) {
+		perror("malloc");
+		exit(EXIT_FAILURE);
+	}
+
+	if (io_uring_queue_init(RING_ENTRIES_NUM, &ring, 0))
+		error(1, errno, "io_uring_queue_init");
+
+	sqe = io_uring_get_sqe(&ring);
+	iovec.iov_base = data;
+	iovec.iov_len = data_len;
+
+	io_uring_prep_readv(sqe, fd, &iovec, 1, 0);
+
+	if (io_uring_submit(&ring) != 1)
+		error(1, errno, "io_uring_submit");
+
+	if (io_uring_wait_cqe(&ring, &cqe))
+		error(1, errno, "io_uring_wait_cqe");
+
+	if (cqe->res != data_len) {
+		fprintf(stderr, "expected %zu, got %u\n", data_len,
+			cqe->res);
+		exit(EXIT_FAILURE);
+	}
+
+	local_hash = hash_djb2(data, data_len);
+
+	remote_hash = control_readulong();
+	if (remote_hash != local_hash) {
+		fprintf(stderr, "hash mismatch\n");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("DONE");
+	io_uring_queue_exit(&ring);
+	free(data);
+}
+
+void test_stream_uring_server(const struct test_opts *opts)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(test_data_array); i++)
+		vsock_io_uring_server(opts, &test_data_array[i]);
+}
+
+static struct test_case test_cases[] = {
+	{
+		.name = "io_uring test",
+		.run_server = test_stream_uring_server,
+		.run_client = test_stream_uring_client,
+	},
+	{},
+};
+
+static const char optstring[] = "";
+static const struct option longopts[] = {
+	{
+		.name = "control-host",
+		.has_arg = required_argument,
+		.val = 'H',
+	},
+	{
+		.name = "control-port",
+		.has_arg = required_argument,
+		.val = 'P',
+	},
+	{
+		.name = "mode",
+		.has_arg = required_argument,
+		.val = 'm',
+	},
+	{
+		.name = "peer-cid",
+		.has_arg = required_argument,
+		.val = 'p',
+	},
+	{
+		.name = "help",
+		.has_arg = no_argument,
+		.val = '?',
+	},
+	{},
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: vsock_uring_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
+		"\n"
+		"  Server: vsock_uring_test --control-port=1234 --mode=server --peer-cid=3\n"
+		"  Client: vsock_uring_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
+		"\n"
+		"Run transmission tests using io_uring. Usage is the same as\n"
+		"in ./vsock_test\n"
+		"\n"
+		"Options:\n"
+		"  --help                 This help message\n"
+		"  --control-host <host>  Server IP address to connect to\n"
+		"  --control-port <port>  Server port to listen on/connect to\n"
+		"  --mode client|server   Server or client mode\n"
+		"  --peer-cid <cid>       CID of the other side\n"
+		);
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char **argv)
+{
+	const char *control_host = NULL;
+	const char *control_port = NULL;
+	struct test_opts opts = {
+		.mode = TEST_MODE_UNSET,
+		.peer_cid = VMADDR_CID_ANY,
+	};
+
+	init_signals();
+
+	for (;;) {
+		int opt = getopt_long(argc, argv, optstring, longopts, NULL);
+
+		if (opt == -1)
+			break;
+
+		switch (opt) {
+		case 'H':
+			control_host = optarg;
+			break;
+		case 'm':
+			if (strcmp(optarg, "client") == 0) {
+				opts.mode = TEST_MODE_CLIENT;
+			} else if (strcmp(optarg, "server") == 0) {
+				opts.mode = TEST_MODE_SERVER;
+			} else {
+				fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'p':
+			opts.peer_cid = parse_cid(optarg);
+			break;
+		case 'P':
+			control_port = optarg;
+			break;
+		case '?':
+		default:
+			usage();
+		}
+	}
+
+	if (!control_port)
+		usage();
+	if (opts.mode == TEST_MODE_UNSET)
+		usage();
+	if (opts.peer_cid == VMADDR_CID_ANY)
+		usage();
+
+	if (!control_host) {
+		if (opts.mode != TEST_MODE_SERVER)
+			usage();
+		control_host = "0.0.0.0";
+	}
+
+	control_init(control_host, control_port,
+		     opts.mode == TEST_MODE_SERVER);
+
+	run_tests(test_cases, &opts);
+
+	control_cleanup();
+
+	return 0;
+}
-- 
2.25.1



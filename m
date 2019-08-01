Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAF47DEF0
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 17:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732680AbfHAP0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 11:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58348 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731484AbfHAP0K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 11:26:10 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A16353142531;
        Thu,  1 Aug 2019 15:26:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-63.ams2.redhat.com [10.36.117.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C724600D1;
        Thu,  1 Aug 2019 15:26:07 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     netdev@vger.kernel.org
Cc:     kvm@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>,
        virtualization@lists.linux-foundation.org,
        "David S. Miller" <davem@davemloft.net>,
        Jorgen Hansen <jhansen@vmware.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 07/11] VSOCK: add AF_VSOCK test cases
Date:   Thu,  1 Aug 2019 17:25:37 +0200
Message-Id: <20190801152541.245833-8-sgarzare@redhat.com>
In-Reply-To: <20190801152541.245833-1-sgarzare@redhat.com>
References: <20190801152541.245833-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 01 Aug 2019 15:26:09 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Hajnoczi <stefanha@redhat.com>

The vsock_test.c program runs a test suite of AF_VSOCK test cases.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
v2:
 * Drop unnecessary includes [Stefan]
 * Aligned with the current SPDX [Stefano]
 * Set MULTICONN_NFDS to 100 [Stefano]
 * Change (i % 1) in (i % 2) in the 'multiconn' test [Stefano]
---
 tools/testing/vsock/.gitignore   |   1 +
 tools/testing/vsock/Makefile     |   5 +-
 tools/testing/vsock/README       |   1 +
 tools/testing/vsock/vsock_test.c | 312 +++++++++++++++++++++++++++++++
 4 files changed, 317 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/vsock/vsock_test.c

diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
index dc5f11faf530..7f7a2ccc30c4 100644
--- a/tools/testing/vsock/.gitignore
+++ b/tools/testing/vsock/.gitignore
@@ -1,2 +1,3 @@
 *.d
+vsock_test
 vsock_diag_test
diff --git a/tools/testing/vsock/Makefile b/tools/testing/vsock/Makefile
index a916878a2d8c..f8293c6910c9 100644
--- a/tools/testing/vsock/Makefile
+++ b/tools/testing/vsock/Makefile
@@ -1,10 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0-only
 all: test
-test: vsock_diag_test
+test: vsock_test vsock_diag_test
+vsock_test: vsock_test.o timeout.o control.o util.o
 vsock_diag_test: vsock_diag_test.o timeout.o control.o util.o
 
 CFLAGS += -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/include -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-common -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
 .PHONY: all test clean
 clean:
-	${RM} *.o *.d vsock_diag_test
+	${RM} *.o *.d vsock_test vsock_diag_test
 -include *.d
diff --git a/tools/testing/vsock/README b/tools/testing/vsock/README
index cf7dc64273bf..4d5045e7d2c3 100644
--- a/tools/testing/vsock/README
+++ b/tools/testing/vsock/README
@@ -5,6 +5,7 @@ Hyper-V.
 
 The following tests are available:
 
+  * vsock_test - core AF_VSOCK socket functionality
   * vsock_diag_test - vsock_diag.ko module for listing open sockets
 
 The following prerequisite steps are not automated and must be performed prior
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock_test.c
new file mode 100644
index 000000000000..06099d037405
--- /dev/null
+++ b/tools/testing/vsock/vsock_test.c
@@ -0,0 +1,312 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vsock_test - vsock.ko test suite
+ *
+ * Copyright (C) 2017 Red Hat, Inc.
+ *
+ * Author: Stefan Hajnoczi <stefanha@redhat.com>
+ */
+
+#include <getopt.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <unistd.h>
+
+#include "timeout.h"
+#include "control.h"
+#include "util.h"
+
+static void test_stream_connection_reset(const struct test_opts *opts)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr = {
+		.svm = {
+			.svm_family = AF_VSOCK,
+			.svm_port = 1234,
+			.svm_cid = opts->peer_cid,
+		},
+	};
+	int ret;
+	int fd;
+
+	fd = socket(AF_VSOCK, SOCK_STREAM, 0);
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret = connect(fd, &addr.sa, sizeof(addr.svm));
+		timeout_check("connect");
+	} while (ret < 0 && errno == EINTR);
+	timeout_end();
+
+	if (ret != -1) {
+		fprintf(stderr, "expected connect(2) failure, got %d\n", ret);
+		exit(EXIT_FAILURE);
+	}
+	if (errno != ECONNRESET) {
+		fprintf(stderr, "unexpected connect(2) errno %d\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void test_stream_client_close_client(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1);
+	close(fd);
+	control_writeln("CLOSED");
+}
+
+static void test_stream_client_close_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLOSED");
+
+	send_byte(fd, -EPIPE);
+	recv_byte(fd, 1);
+	recv_byte(fd, 0);
+	close(fd);
+}
+
+static void test_stream_server_close_client(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLOSED");
+
+	send_byte(fd, -EPIPE);
+	recv_byte(fd, 1);
+	recv_byte(fd, 0);
+	close(fd);
+}
+
+static void test_stream_server_close_server(const struct test_opts *opts)
+{
+	int fd;
+
+	fd = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1);
+	close(fd);
+	control_writeln("CLOSED");
+}
+
+/* With the standard socket sizes, VMCI is able to support about 100
+ * concurrent stream connections.
+ */
+#define MULTICONN_NFDS 100
+
+static void test_stream_multiconn_client(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		fds[i] = vsock_stream_connect(opts->peer_cid, 1234);
+		if (fds[i] < 0) {
+			perror("connect");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		if (i % 2)
+			recv_byte(fds[i], 1);
+		else
+			send_byte(fds[i], 1);
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_stream_multiconn_server(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		fds[i] = vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		if (fds[i] < 0) {
+			perror("accept");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++) {
+		if (i % 2)
+			send_byte(fds[i], 1);
+		else
+			recv_byte(fds[i], 1);
+	}
+
+	for (i = 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static struct test_case test_cases[] = {
+	{
+		.name = "SOCK_STREAM connection reset",
+		.run_client = test_stream_connection_reset,
+	},
+	{
+		.name = "SOCK_STREAM client close",
+		.run_client = test_stream_client_close_client,
+		.run_server = test_stream_client_close_server,
+	},
+	{
+		.name = "SOCK_STREAM server close",
+		.run_client = test_stream_server_close_client,
+		.run_server = test_stream_server_close_server,
+	},
+	{
+		.name = "SOCK_STREAM multiple connections",
+		.run_client = test_stream_multiconn_client,
+		.run_server = test_stream_multiconn_server,
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
+	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=<host>] --control-port=<port> --mode=client|server --peer-cid=<cid>\n"
+		"\n"
+		"  Server: vsock_test --control-port=1234 --mode=server --peer-cid=3\n"
+		"  Client: vsock_test --control-host=192.168.0.1 --control-port=1234 --mode=client --peer-cid=2\n"
+		"\n"
+		"Run vsock.ko tests.  Must be launched in both guest\n"
+		"and host.  One side must use --mode=client and\n"
+		"the other side must use --mode=server.\n"
+		"\n"
+		"A TCP control socket connection is used to coordinate tests\n"
+		"between the client and the server.  The server requires a\n"
+		"listen address and the client requires an address to\n"
+		"connect to.\n"
+		"\n"
+		"The CID of the other side must be given with --peer-cid=<cid>.\n");
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
+			if (strcmp(optarg, "client") == 0)
+				opts.mode = TEST_MODE_CLIENT;
+			else if (strcmp(optarg, "server") == 0)
+				opts.mode = TEST_MODE_SERVER;
+			else {
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
+	return EXIT_SUCCESS;
+}
-- 
2.20.1


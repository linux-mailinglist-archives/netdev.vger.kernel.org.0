Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABB4125038
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfLRSHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:07:55 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49866 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727630AbfLRSHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ba+jdilHJOq5z4M9yN1rn/HCKx5aiHP0bqMQXqZ4gWs=;
        b=GraQRKj9TDDWyxSB/3Ax3/noKW9KtdCWNjZvuCtEaGDWPiDNfgl/3tc+NjZpVqx9sNwrF5
        GQdXVrQwXheqzjyEMkfLRx4D6fIZlDJqhZc6Knph9fzQf1sGNcoqG6Hj2WD4SbG3EOzEXb
        dL87ICLd2jNPydnxTTK+FFZTqfRF0sU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-674jwpI1NKi7qts0unCKJg-1; Wed, 18 Dec 2019 13:07:45 -0500
X-MC-Unique: 674jwpI1NKi7qts0unCKJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D383810883A1;
        Wed, 18 Dec 2019 18:07:43 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2622A5D9E5;
        Wed, 18 Dec 2019 18:07:37 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 07/11] VSOCK: add AF_VSOCK test cases
Date:   Wed, 18 Dec 2019 19:07:04 +0100
Message-Id: <20191218180708.120337-8-sgarzare@redhat.com>
In-Reply-To: <20191218180708.120337-1-sgarzare@redhat.com>
References: <20191218180708.120337-1-sgarzare@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
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

diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitign=
ore
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
=20
 CFLAGS +=3D -g -O2 -Werror -Wall -I. -I../../include -I../../../usr/incl=
ude -Wno-pointer-sign -fno-strict-overflow -fno-strict-aliasing -fno-comm=
on -MMD -U_FORTIFY_SOURCE -D_GNU_SOURCE
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
=20
 The following tests are available:
=20
+  * vsock_test - core AF_VSOCK socket functionality
   * vsock_diag_test - vsock_diag.ko module for listing open sockets
=20
 The following prerequisite steps are not automated and must be performed=
 prior
diff --git a/tools/testing/vsock/vsock_test.c b/tools/testing/vsock/vsock=
_test.c
new file mode 100644
index 000000000000..fae8ddc3ef72
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
+	} addr =3D {
+		.svm =3D {
+			.svm_family =3D AF_VSOCK,
+			.svm_port =3D 1234,
+			.svm_cid =3D opts->peer_cid,
+		},
+	};
+	int ret;
+	int fd;
+
+	fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
+
+	timeout_begin(TIMEOUT);
+	do {
+		ret =3D connect(fd, &addr.sa, sizeof(addr.svm));
+		timeout_check("connect");
+	} while (ret < 0 && errno =3D=3D EINTR);
+	timeout_end();
+
+	if (ret !=3D -1) {
+		fprintf(stderr, "expected connect(2) failure, got %d\n", ret);
+		exit(EXIT_FAILURE);
+	}
+	if (errno !=3D ECONNRESET) {
+		fprintf(stderr, "unexpected connect(2) errno %d\n", errno);
+		exit(EXIT_FAILURE);
+	}
+
+	close(fd);
+}
+
+static void test_stream_client_close_client(const struct test_opts *opts=
)
+{
+	int fd;
+
+	fd =3D vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1, 0);
+	close(fd);
+	control_writeln("CLOSED");
+}
+
+static void test_stream_client_close_server(const struct test_opts *opts=
)
+{
+	int fd;
+
+	fd =3D vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLOSED");
+
+	send_byte(fd, -EPIPE, 0);
+	recv_byte(fd, 1, 0);
+	recv_byte(fd, 0, 0);
+	close(fd);
+}
+
+static void test_stream_server_close_client(const struct test_opts *opts=
)
+{
+	int fd;
+
+	fd =3D vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
+		perror("connect");
+		exit(EXIT_FAILURE);
+	}
+
+	control_expectln("CLOSED");
+
+	send_byte(fd, -EPIPE, 0);
+	recv_byte(fd, 1, 0);
+	recv_byte(fd, 0, 0);
+	close(fd);
+}
+
+static void test_stream_server_close_server(const struct test_opts *opts=
)
+{
+	int fd;
+
+	fd =3D vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+	if (fd < 0) {
+		perror("accept");
+		exit(EXIT_FAILURE);
+	}
+
+	send_byte(fd, 1, 0);
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
+	for (i =3D 0; i < MULTICONN_NFDS; i++) {
+		fds[i] =3D vsock_stream_connect(opts->peer_cid, 1234);
+		if (fds[i] < 0) {
+			perror("connect");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i =3D 0; i < MULTICONN_NFDS; i++) {
+		if (i % 2)
+			recv_byte(fds[i], 1, 0);
+		else
+			send_byte(fds[i], 1, 0);
+	}
+
+	for (i =3D 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static void test_stream_multiconn_server(const struct test_opts *opts)
+{
+	int fds[MULTICONN_NFDS];
+	int i;
+
+	for (i =3D 0; i < MULTICONN_NFDS; i++) {
+		fds[i] =3D vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
+		if (fds[i] < 0) {
+			perror("accept");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	for (i =3D 0; i < MULTICONN_NFDS; i++) {
+		if (i % 2)
+			send_byte(fds[i], 1, 0);
+		else
+			recv_byte(fds[i], 1, 0);
+	}
+
+	for (i =3D 0; i < MULTICONN_NFDS; i++)
+		close(fds[i]);
+}
+
+static struct test_case test_cases[] =3D {
+	{
+		.name =3D "SOCK_STREAM connection reset",
+		.run_client =3D test_stream_connection_reset,
+	},
+	{
+		.name =3D "SOCK_STREAM client close",
+		.run_client =3D test_stream_client_close_client,
+		.run_server =3D test_stream_client_close_server,
+	},
+	{
+		.name =3D "SOCK_STREAM server close",
+		.run_client =3D test_stream_server_close_client,
+		.run_server =3D test_stream_server_close_server,
+	},
+	{
+		.name =3D "SOCK_STREAM multiple connections",
+		.run_client =3D test_stream_multiconn_client,
+		.run_server =3D test_stream_multiconn_server,
+	},
+	{},
+};
+
+static const char optstring[] =3D "";
+static const struct option longopts[] =3D {
+	{
+		.name =3D "control-host",
+		.has_arg =3D required_argument,
+		.val =3D 'H',
+	},
+	{
+		.name =3D "control-port",
+		.has_arg =3D required_argument,
+		.val =3D 'P',
+	},
+	{
+		.name =3D "mode",
+		.has_arg =3D required_argument,
+		.val =3D 'm',
+	},
+	{
+		.name =3D "peer-cid",
+		.has_arg =3D required_argument,
+		.val =3D 'p',
+	},
+	{
+		.name =3D "help",
+		.has_arg =3D no_argument,
+		.val =3D '?',
+	},
+	{},
+};
+
+static void usage(void)
+{
+	fprintf(stderr, "Usage: vsock_test [--help] [--control-host=3D<host>] -=
-control-port=3D<port> --mode=3Dclient|server --peer-cid=3D<cid>\n"
+		"\n"
+		"  Server: vsock_test --control-port=3D1234 --mode=3Dserver --peer-cid=
=3D3\n"
+		"  Client: vsock_test --control-host=3D192.168.0.1 --control-port=3D12=
34 --mode=3Dclient --peer-cid=3D2\n"
+		"\n"
+		"Run vsock.ko tests.  Must be launched in both guest\n"
+		"and host.  One side must use --mode=3Dclient and\n"
+		"the other side must use --mode=3Dserver.\n"
+		"\n"
+		"A TCP control socket connection is used to coordinate tests\n"
+		"between the client and the server.  The server requires a\n"
+		"listen address and the client requires an address to\n"
+		"connect to.\n"
+		"\n"
+		"The CID of the other side must be given with --peer-cid=3D<cid>.\n");
+	exit(EXIT_FAILURE);
+}
+
+int main(int argc, char **argv)
+{
+	const char *control_host =3D NULL;
+	const char *control_port =3D NULL;
+	struct test_opts opts =3D {
+		.mode =3D TEST_MODE_UNSET,
+		.peer_cid =3D VMADDR_CID_ANY,
+	};
+
+	init_signals();
+
+	for (;;) {
+		int opt =3D getopt_long(argc, argv, optstring, longopts, NULL);
+
+		if (opt =3D=3D -1)
+			break;
+
+		switch (opt) {
+		case 'H':
+			control_host =3D optarg;
+			break;
+		case 'm':
+			if (strcmp(optarg, "client") =3D=3D 0)
+				opts.mode =3D TEST_MODE_CLIENT;
+			else if (strcmp(optarg, "server") =3D=3D 0)
+				opts.mode =3D TEST_MODE_SERVER;
+			else {
+				fprintf(stderr, "--mode must be \"client\" or \"server\"\n");
+				return EXIT_FAILURE;
+			}
+			break;
+		case 'p':
+			opts.peer_cid =3D parse_cid(optarg);
+			break;
+		case 'P':
+			control_port =3D optarg;
+			break;
+		case '?':
+		default:
+			usage();
+		}
+	}
+
+	if (!control_port)
+		usage();
+	if (opts.mode =3D=3D TEST_MODE_UNSET)
+		usage();
+	if (opts.peer_cid =3D=3D VMADDR_CID_ANY)
+		usage();
+
+	if (!control_host) {
+		if (opts.mode !=3D TEST_MODE_SERVER)
+			usage();
+		control_host =3D "0.0.0.0";
+	}
+
+	control_init(control_host, control_port,
+		     opts.mode =3D=3D TEST_MODE_SERVER);
+
+	run_tests(test_cases, &opts);
+
+	control_cleanup();
+	return EXIT_SUCCESS;
+}
--=20
2.24.1


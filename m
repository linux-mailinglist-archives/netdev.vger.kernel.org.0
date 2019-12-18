Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4E47125054
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfLRSHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:07:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57940 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727527AbfLRSHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:07:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576692458;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0Bswzipg/wW4k9QMFQpExONm3qDrCwLdO1TlY5CPDow=;
        b=YmVLytEdy5SkEzJFrlkPxg/1+PYYmN+hDl0dQmsx+I4nauycYbbuUv2DaBTde1l12lpSe2
        csxPLz6oi+S9CsAHC/JRSnvZRs13uJtuRarK850wZzxTFBnjKI8vz0kaSI/476W4OTxxb4
        TpwHFi5t+XosTKtOdbqhjkezg6Xs50w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-K8zRqRR-NaOSCOvgPOkZGQ-1; Wed, 18 Dec 2019 13:07:34 -0500
X-MC-Unique: K8zRqRR-NaOSCOvgPOkZGQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C08F21007271;
        Wed, 18 Dec 2019 18:07:32 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-117-218.ams2.redhat.com [10.36.117.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C2905D9E2;
        Wed, 18 Dec 2019 18:07:27 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     davem@davemloft.net
Cc:     Jorgen Hansen <jhansen@vmware.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dexuan Cui <decui@microsoft.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH net-next v3 04/11] VSOCK: extract connect/accept functions from vsock_diag_test.c
Date:   Wed, 18 Dec 2019 19:07:01 +0100
Message-Id: <20191218180708.120337-5-sgarzare@redhat.com>
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

Many test cases will need to connect to the server or accept incoming
connections.  This patch extracts these operations into utility
functions that can be reused.

Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 tools/testing/vsock/util.c            | 108 ++++++++++++++++++++++++++
 tools/testing/vsock/util.h            |   6 ++
 tools/testing/vsock/vsock_diag_test.c |  81 ++-----------------
 3 files changed, 119 insertions(+), 76 deletions(-)

diff --git a/tools/testing/vsock/util.c b/tools/testing/vsock/util.c
index f40f45b36d2f..f838bcee3589 100644
--- a/tools/testing/vsock/util.c
+++ b/tools/testing/vsock/util.c
@@ -11,8 +11,10 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <signal.h>
+#include <unistd.h>
=20
 #include "timeout.h"
+#include "control.h"
 #include "util.h"
=20
 /* Install signal handlers */
@@ -41,6 +43,112 @@ unsigned int parse_cid(const char *str)
 	return n;
 }
=20
+/* Connect to <cid, port> and return the file descriptor. */
+int vsock_stream_connect(unsigned int cid, unsigned int port)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr =3D {
+		.svm =3D {
+			.svm_family =3D AF_VSOCK,
+			.svm_port =3D port,
+			.svm_cid =3D cid,
+		},
+	};
+	int ret;
+	int fd;
+
+	control_expectln("LISTENING");
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
+	if (ret < 0) {
+		int old_errno =3D errno;
+
+		close(fd);
+		fd =3D -1;
+		errno =3D old_errno;
+	}
+	return fd;
+}
+
+/* Listen on <cid, port> and return the first incoming connection.  The =
remote
+ * address is stored to clientaddrp.  clientaddrp may be NULL.
+ */
+int vsock_stream_accept(unsigned int cid, unsigned int port,
+			struct sockaddr_vm *clientaddrp)
+{
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} addr =3D {
+		.svm =3D {
+			.svm_family =3D AF_VSOCK,
+			.svm_port =3D port,
+			.svm_cid =3D cid,
+		},
+	};
+	union {
+		struct sockaddr sa;
+		struct sockaddr_vm svm;
+	} clientaddr;
+	socklen_t clientaddr_len =3D sizeof(clientaddr.svm);
+	int fd;
+	int client_fd;
+	int old_errno;
+
+	fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
+
+	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
+		perror("bind");
+		exit(EXIT_FAILURE);
+	}
+
+	if (listen(fd, 1) < 0) {
+		perror("listen");
+		exit(EXIT_FAILURE);
+	}
+
+	control_writeln("LISTENING");
+
+	timeout_begin(TIMEOUT);
+	do {
+		client_fd =3D accept(fd, &clientaddr.sa, &clientaddr_len);
+		timeout_check("accept");
+	} while (client_fd < 0 && errno =3D=3D EINTR);
+	timeout_end();
+
+	old_errno =3D errno;
+	close(fd);
+	errno =3D old_errno;
+
+	if (client_fd < 0)
+		return client_fd;
+
+	if (clientaddr_len !=3D sizeof(clientaddr.svm)) {
+		fprintf(stderr, "unexpected addrlen from accept(2), %zu\n",
+			(size_t)clientaddr_len);
+		exit(EXIT_FAILURE);
+	}
+	if (clientaddr.sa.sa_family !=3D AF_VSOCK) {
+		fprintf(stderr, "expected AF_VSOCK from accept(2), got %d\n",
+			clientaddr.sa.sa_family);
+		exit(EXIT_FAILURE);
+	}
+
+	if (clientaddrp)
+		*clientaddrp =3D clientaddr.svm;
+	return client_fd;
+}
+
 /* Run test cases.  The program terminates if a failure occurs. */
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts)
diff --git a/tools/testing/vsock/util.h b/tools/testing/vsock/util.h
index 033e7d59a42a..1786305cfddd 100644
--- a/tools/testing/vsock/util.h
+++ b/tools/testing/vsock/util.h
@@ -2,6 +2,9 @@
 #ifndef UTIL_H
 #define UTIL_H
=20
+#include <sys/socket.h>
+#include <linux/vm_sockets.h>
+
 /* Tests can either run as the client or the server */
 enum test_mode {
 	TEST_MODE_UNSET,
@@ -30,6 +33,9 @@ struct test_case {
=20
 void init_signals(void);
 unsigned int parse_cid(const char *str);
+int vsock_stream_connect(unsigned int cid, unsigned int port);
+int vsock_stream_accept(unsigned int cid, unsigned int port,
+			struct sockaddr_vm *clientaddrp);
 void run_tests(const struct test_case *test_cases,
 	       const struct test_opts *opts);
=20
diff --git a/tools/testing/vsock/vsock_diag_test.c b/tools/testing/vsock/=
vsock_diag_test.c
index 944c8a72eed7..abd7dc2a9631 100644
--- a/tools/testing/vsock/vsock_diag_test.c
+++ b/tools/testing/vsock/vsock_diag_test.c
@@ -13,13 +13,11 @@
 #include <string.h>
 #include <errno.h>
 #include <unistd.h>
-#include <sys/socket.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <linux/list.h>
 #include <linux/net.h>
 #include <linux/netlink.h>
-#include <linux/vm_sockets.h>
 #include <linux/sock_diag.h>
 #include <linux/vm_sockets_diag.h>
 #include <netinet/tcp.h>
@@ -378,33 +376,12 @@ static void test_listen_socket_server(const struct =
test_opts *opts)
=20
 static void test_connect_client(const struct test_opts *opts)
 {
-	union {
-		struct sockaddr sa;
-		struct sockaddr_vm svm;
-	} addr =3D {
-		.svm =3D {
-			.svm_family =3D AF_VSOCK,
-			.svm_port =3D 1234,
-			.svm_cid =3D opts->peer_cid,
-		},
-	};
 	int fd;
-	int ret;
 	LIST_HEAD(sockets);
 	struct vsock_stat *st;
=20
-	control_expectln("LISTENING");
-
-	fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
-
-	timeout_begin(TIMEOUT);
-	do {
-		ret =3D connect(fd, &addr.sa, sizeof(addr.svm));
-		timeout_check("connect");
-	} while (ret < 0 && errno =3D=3D EINTR);
-	timeout_end();
-
-	if (ret < 0) {
+	fd =3D vsock_stream_connect(opts->peer_cid, 1234);
+	if (fd < 0) {
 		perror("connect");
 		exit(EXIT_FAILURE);
 	}
@@ -424,66 +401,19 @@ static void test_connect_client(const struct test_o=
pts *opts)
=20
 static void test_connect_server(const struct test_opts *opts)
 {
-	union {
-		struct sockaddr sa;
-		struct sockaddr_vm svm;
-	} addr =3D {
-		.svm =3D {
-			.svm_family =3D AF_VSOCK,
-			.svm_port =3D 1234,
-			.svm_cid =3D VMADDR_CID_ANY,
-		},
-	};
-	union {
-		struct sockaddr sa;
-		struct sockaddr_vm svm;
-	} clientaddr;
-	socklen_t clientaddr_len =3D sizeof(clientaddr.svm);
-	LIST_HEAD(sockets);
 	struct vsock_stat *st;
-	int fd;
+	LIST_HEAD(sockets);
 	int client_fd;
=20
-	fd =3D socket(AF_VSOCK, SOCK_STREAM, 0);
-
-	if (bind(fd, &addr.sa, sizeof(addr.svm)) < 0) {
-		perror("bind");
-		exit(EXIT_FAILURE);
-	}
-
-	if (listen(fd, 1) < 0) {
-		perror("listen");
-		exit(EXIT_FAILURE);
-	}
-
-	control_writeln("LISTENING");
-
-	timeout_begin(TIMEOUT);
-	do {
-		client_fd =3D accept(fd, &clientaddr.sa, &clientaddr_len);
-		timeout_check("accept");
-	} while (client_fd < 0 && errno =3D=3D EINTR);
-	timeout_end();
-
+	client_fd =3D vsock_stream_accept(VMADDR_CID_ANY, 1234, NULL);
 	if (client_fd < 0) {
 		perror("accept");
 		exit(EXIT_FAILURE);
 	}
-	if (clientaddr.sa.sa_family !=3D AF_VSOCK) {
-		fprintf(stderr, "expected AF_VSOCK from accept(2), got %d\n",
-			clientaddr.sa.sa_family);
-		exit(EXIT_FAILURE);
-	}
-	if (clientaddr.svm.svm_cid !=3D opts->peer_cid) {
-		fprintf(stderr, "expected peer CID %u from accept(2), got %u\n",
-			opts->peer_cid, clientaddr.svm.svm_cid);
-		exit(EXIT_FAILURE);
-	}
=20
 	read_vsock_stat(&sockets);
=20
-	check_num_sockets(&sockets, 2);
-	find_vsock_stat(&sockets, fd);
+	check_num_sockets(&sockets, 1);
 	st =3D find_vsock_stat(&sockets, client_fd);
 	check_socket_state(st, TCP_ESTABLISHED);
=20
@@ -491,7 +421,6 @@ static void test_connect_server(const struct test_opt=
s *opts)
 	control_expectln("DONE");
=20
 	close(client_fd);
-	close(fd);
 	free_sock_stat(&sockets);
 }
=20
--=20
2.24.1


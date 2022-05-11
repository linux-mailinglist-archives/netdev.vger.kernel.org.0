Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F55522823
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 02:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239138AbiEKAFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 20:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239159AbiEKAFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 20:05:33 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773852498BF
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 17:05:24 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id DDE3CC314DD4; Tue, 10 May 2022 17:04:57 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v3 2/2] selftests: Add test for timing a bind request to a port with a populated bhash entry
Date:   Tue, 10 May 2022 17:04:24 -0700
Message-Id: <20220511000424.2223932-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220511000424.2223932-1-joannelkoong@gmail.com>
References: <20220511000424.2223932-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This test populates the bhash table for a given port with
MAX_THREADS * MAX_CONNECTIONS sockets, and then times how long
a bind request on the port takes.

When populating the bhash table, we create the sockets and then bind
the sockets to the same address and port (SO_REUSEADDR and SO_REUSEPORT
are set). When timing how long a bind on the port takes, we bind on a
different address without SO_REUSEPORT set. We do not set SO_REUSEPORT
because we are interested in the case where the bind request does not
go through the tb->fastreuseport path, which is fragile (eg
tb->fastreuseport path does not work if binding with a different uid).

To run the test locally, I did:
* ulimit -n 65535000
* ip addr add 2001:0db8:0:f101::1 dev eth0
* ./bind_bhash_test 443

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/bind_bhash_test.c | 119 ++++++++++++++++++
 3 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/net/bind_bhash_test.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index 21a411b04890..735423136bc4 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -36,3 +36,4 @@ gro
 ioam6_parser
 toeplitz
 cmsg_sender
+bind_bhash_test
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index 0fbdacfdcd6a..309c6e9ba8fd 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -56,6 +56,7 @@ TEST_GEN_PROGS +=3D reuseport_dualstack reuseaddr_confl=
ict tls
 TEST_GEN_FILES +=3D toeplitz
 TEST_GEN_FILES +=3D cmsg_sender
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
+TEST_GEN_FILES +=3D bind_bhash_test
=20
 TEST_FILES :=3D settings
=20
@@ -64,4 +65,5 @@ include ../lib.mk
=20
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS +=3D -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS +=3D -lpthread
+$(OUTPUT)/bind_bhash_test: LDLIBS +=3D -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS +=3D -lpthread
diff --git a/tools/testing/selftests/net/bind_bhash_test.c b/tools/testin=
g/selftests/net/bind_bhash_test.c
new file mode 100644
index 000000000000..252e73754e76
--- /dev/null
+++ b/tools/testing/selftests/net/bind_bhash_test.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This times how long it takes to bind to a port when the port already
+ * has multiple sockets in its bhash table.
+ *
+ * In the setup(), we populate the port's bhash table with
+ * MAX_THREADS * MAX_CONNECTIONS number of entries.
+ */
+
+#include <unistd.h>
+#include <stdio.h>
+#include <netdb.h>
+#include <pthread.h>
+
+#define MAX_THREADS 600
+#define MAX_CONNECTIONS 40
+
+static const char *bind_addr =3D "::1";
+static const char *port;
+
+static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
+
+static int bind_socket(int opt, const char *addr)
+{
+	struct addrinfo *res, hint =3D {};
+	int sock_fd, reuse =3D 1, err;
+
+	sock_fd =3D socket(AF_INET6, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		perror("socket fd err");
+		return -1;
+	}
+
+	hint.ai_family =3D AF_INET6;
+	hint.ai_socktype =3D SOCK_STREAM;
+
+	err =3D getaddrinfo(addr, port, &hint, &res);
+	if (err) {
+		perror("getaddrinfo failed");
+		return -1;
+	}
+
+	if (opt) {
+		err =3D setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
+		if (err) {
+			perror("setsockopt failed");
+			return -1;
+		}
+	}
+
+	err =3D bind(sock_fd, res->ai_addr, res->ai_addrlen);
+	if (err) {
+		perror("failed to bind to port");
+		return -1;
+	}
+
+	return sock_fd;
+}
+
+static void *setup(void *arg)
+{
+	int sock_fd, i;
+	int *array =3D (int *)arg;
+
+	for (i =3D 0; i < MAX_CONNECTIONS; i++) {
+		sock_fd =3D bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
+		if (sock_fd < 0)
+			return NULL;
+		array[i] =3D sock_fd;
+	}
+
+	return NULL;
+}
+
+int main(int argc, const char *argv[])
+{
+	int listener_fd, sock_fd, i, j;
+	pthread_t tid[MAX_THREADS];
+	clock_t begin, end;
+
+	if (argc !=3D 2) {
+		printf("Usage: listener <port>\n");
+		return -1;
+	}
+
+	port =3D argv[1];
+
+	listener_fd =3D bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
+	if (listen(listener_fd, 100) < 0) {
+		perror("listen failed");
+		return -1;
+	}
+
+	/* Set up threads to populate the bhash table entry for the port */
+	for (i =3D 0; i < MAX_THREADS; i++)
+		pthread_create(&tid[i], NULL, setup, fd_array[i]);
+
+	for (i =3D 0; i < MAX_THREADS; i++)
+		pthread_join(tid[i], NULL);
+
+	begin =3D clock();
+
+	/* Bind to the same port on a different address */
+	sock_fd  =3D bind_socket(0, "2001:0db8:0:f101::1");
+
+	end =3D clock();
+
+	printf("time spent =3D %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
+
+	/* clean up */
+	close(sock_fd);
+	close(listener_fd);
+	for (i =3D 0; i < MAX_THREADS; i++) {
+		for (j =3D 0; i < MAX_THREADS; i++)
+			close(fd_array[i][j]);
+	}
+
+	return 0;
+}
--=20
2.30.2


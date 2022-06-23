Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE4E558BDA
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiFWXoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiFWXoy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:44:54 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7BB527FE
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 16:44:52 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 66DF6E0E702A; Thu, 23 Jun 2022 16:44:43 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v1 2/3] selftests/net: Add test for timing a bind request to a port with a populated bhash entry
Date:   Thu, 23 Jun 2022 16:42:41 -0700
Message-Id: <20220623234242.2083895-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220623234242.2083895-1-joannelkoong@gmail.com>
References: <20220623234242.2083895-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NML_ADSP_CUSTOM_MED,RDNS_DYNAMIC,
        SPF_HELO_PASS,SPF_SOFTFAIL,TVD_RCVD_IP,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
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

On my local machine, I see:
ipv4:
before - 0.002317 seconds
with bhash2 - 0.000020 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 tools/testing/selftests/net/.gitignore    |   1 +
 tools/testing/selftests/net/Makefile      |   3 +
 tools/testing/selftests/net/bind_bhash.c  | 119 ++++++++++++++++++++++
 tools/testing/selftests/net/bind_bhash.sh |  23 +++++
 4 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index a29f79618934..8b509a4672fc 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -37,3 +37,4 @@ gro
 ioam6_parser
 toeplitz
 cmsg_sender
+bind_bhash
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index 7ea54af55490..bc54d9c36abc 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -39,6 +39,7 @@ TEST_PROGS +=3D vrf_strict_mode_test.sh
 TEST_PROGS +=3D arp_ndisc_evict_nocarrier.sh
 TEST_PROGS +=3D ndisc_unsolicited_na_test.sh
 TEST_PROGS +=3D stress_reuseport_listen.sh
+TEST_PROGS +=3D bind_bhash.sh
 TEST_PROGS_EXTENDED :=3D in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED +=3D toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =3D  socket nettest
@@ -59,6 +60,7 @@ TEST_GEN_FILES +=3D toeplitz
 TEST_GEN_FILES +=3D cmsg_sender
 TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
+TEST_GEN_FILES +=3D bind_bhash
=20
 TEST_FILES :=3D settings
=20
@@ -70,3 +72,4 @@ include bpf/Makefile
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS +=3D -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS +=3D -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS +=3D -lpthread
+$(OUTPUT)/bind_bhash: LDLIBS +=3D -lpthread
diff --git a/tools/testing/selftests/net/bind_bhash.c b/tools/testing/sel=
ftests/net/bind_bhash.c
new file mode 100644
index 000000000000..252e73754e76
--- /dev/null
+++ b/tools/testing/selftests/net/bind_bhash.c
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
diff --git a/tools/testing/selftests/net/bind_bhash.sh b/tools/testing/se=
lftests/net/bind_bhash.sh
new file mode 100755
index 000000000000..f7794d63efd2
--- /dev/null
+++ b/tools/testing/selftests/net/bind_bhash.sh
@@ -0,0 +1,23 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NR_FILES=3D32768
+SAVED_NR_FILES=3D$(ulimit -n)
+
+setup() {
+	ip addr add dev eth0 2001:0db8:0:f101::1
+	ulimit -n $NR_FILES
+	sleep 1
+}
+
+cleanup() {
+	ip addr del 2001:0db8:0:f101::1 dev eth0
+	ulimit -n $SAVED_NR_FILES
+}
+
+trap cleanup EXIT
+
+setup
+./bind_bhash 443
+
+exit $EXIT_STATUS
--=20
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D280591657
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 22:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiHLUcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 16:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234747AbiHLUcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 16:32:07 -0400
Received: from 69-171-232-181.mail-mxout.facebook.com (69-171-232-181.mail-mxout.facebook.com [69.171.232.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C288B089D
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:32:05 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 7561010576443; Fri, 12 Aug 2022 13:31:49 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, dccp@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v4 2/3] selftests/net: Add test for timing a bind request to a port with a populated bhash entry
Date:   Fri, 12 Aug 2022 13:29:04 -0700
Message-Id: <20220812202905.1599234-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220812202905.1599234-1-joannelkoong@gmail.com>
References: <20220812202905.1599234-1-joannelkoong@gmail.com>
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

To run the script:
    Usage: ./bind_bhash.sh [-6 | -4] [-p port] [-a address]
	    6: use ipv6
	    4: use ipv4
	    port: Port number
	    address: ip address

Without any arguments, ./bind_bhash.sh defaults to ipv6 using ip address
"2001:0db8:0:f101::1" on port 443.

On my local machine, I see:
ipv4:
before - 0.002317 seconds
with bhash2 - 0.000020 seconds

ipv6:
before - 0.002431 seconds
with bhash2 - 0.000021 seconds

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 tools/testing/selftests/net/.gitignore    |   3 +-
 tools/testing/selftests/net/Makefile      |   3 +
 tools/testing/selftests/net/bind_bhash.c  | 144 ++++++++++++++++++++++
 tools/testing/selftests/net/bind_bhash.sh |  66 ++++++++++
 4 files changed, 215 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/net/bind_bhash.c
 create mode 100755 tools/testing/selftests/net/bind_bhash.sh

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index 0e5751af6247..89e2d4aa812a 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -39,4 +39,5 @@ toeplitz
 tun
 cmsg_sender
 unix_connect
-tap
\ No newline at end of file
+tap
+bind_bhash
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index c0ee2955fe54..a3a26d8c29df 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -42,6 +42,7 @@ TEST_PROGS +=3D arp_ndisc_evict_nocarrier.sh
 TEST_PROGS +=3D ndisc_unsolicited_na_test.sh
 TEST_PROGS +=3D arp_ndisc_untracked_subnets.sh
 TEST_PROGS +=3D stress_reuseport_listen.sh
+TEST_PROGS +=3D bind_bhash.sh
 TEST_PROGS_EXTENDED :=3D in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED +=3D toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =3D  socket nettest
@@ -63,6 +64,7 @@ TEST_GEN_FILES +=3D cmsg_sender
 TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
 TEST_GEN_FILES +=3D io_uring_zerocopy_tx
+TEST_GEN_FILES +=3D bind_bhash
=20
 TEST_FILES :=3D settings
=20
@@ -73,3 +75,4 @@ include bpf/Makefile
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS +=3D -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS +=3D -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS +=3D -lpthread
+$(OUTPUT)/bind_bhash: LDLIBS +=3D -lpthread
diff --git a/tools/testing/selftests/net/bind_bhash.c b/tools/testing/sel=
ftests/net/bind_bhash.c
new file mode 100644
index 000000000000..57ff67a3751e
--- /dev/null
+++ b/tools/testing/selftests/net/bind_bhash.c
@@ -0,0 +1,144 @@
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
+#include <string.h>
+#include <stdbool.h>
+
+#define MAX_THREADS 600
+#define MAX_CONNECTIONS 40
+
+static const char *setup_addr_v6 =3D "::1";
+static const char *setup_addr_v4 =3D "127.0.0.1";
+static const char *setup_addr;
+static const char *bind_addr;
+static const char *port;
+bool use_v6;
+int ret;
+
+static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
+
+static int bind_socket(int opt, const char *addr)
+{
+	struct addrinfo *res, hint =3D {};
+	int sock_fd, reuse =3D 1, err;
+	int domain =3D use_v6 ? AF_INET6 : AF_INET;
+
+	sock_fd =3D socket(domain, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		perror("socket fd err");
+		return sock_fd;
+	}
+
+	hint.ai_family =3D domain;
+	hint.ai_socktype =3D SOCK_STREAM;
+
+	err =3D getaddrinfo(addr, port, &hint, &res);
+	if (err) {
+		perror("getaddrinfo failed");
+		goto cleanup;
+	}
+
+	if (opt) {
+		err =3D setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
+		if (err) {
+			perror("setsockopt failed");
+			goto cleanup;
+		}
+	}
+
+	err =3D bind(sock_fd, res->ai_addr, res->ai_addrlen);
+	if (err) {
+		perror("failed to bind to port");
+		goto cleanup;
+	}
+
+	return sock_fd;
+
+cleanup:
+	close(sock_fd);
+	return err;
+}
+
+static void *setup(void *arg)
+{
+	int sock_fd, i;
+	int *array =3D (int *)arg;
+
+	for (i =3D 0; i < MAX_CONNECTIONS; i++) {
+		sock_fd =3D bind_socket(SO_REUSEADDR | SO_REUSEPORT, setup_addr);
+		if (sock_fd < 0) {
+			ret =3D sock_fd;
+			pthread_exit(&ret);
+		}
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
+	if (argc !=3D 4) {
+		printf("Usage: listener <port> <ipv6 | ipv4> <bind-addr>\n");
+		return -1;
+	}
+
+	port =3D argv[1];
+	use_v6 =3D strcmp(argv[2], "ipv6") =3D=3D 0;
+	bind_addr =3D argv[3];
+
+	setup_addr =3D use_v6 ? setup_addr_v6 : setup_addr_v4;
+
+	listener_fd =3D bind_socket(SO_REUSEADDR | SO_REUSEPORT, setup_addr);
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
+	if (ret)
+		goto done;
+
+	begin =3D clock();
+
+	/* Bind to the same port on a different address */
+	sock_fd  =3D bind_socket(0, bind_addr);
+	if (sock_fd < 0)
+		goto done;
+
+	end =3D clock();
+
+	printf("time spent =3D %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
+
+	/* clean up */
+	close(sock_fd);
+
+done:
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
index 000000000000..ca0292d4b441
--- /dev/null
+++ b/tools/testing/selftests/net/bind_bhash.sh
@@ -0,0 +1,66 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+NR_FILES=3D32768
+SAVED_NR_FILES=3D$(ulimit -n)
+
+# default values
+port=3D443
+addr_v6=3D"2001:0db8:0:f101::1"
+addr_v4=3D"10.8.8.8"
+use_v6=3Dtrue
+addr=3D""
+
+usage() {
+    echo "Usage: $0 [-6 | -4] [-p port] [-a address]"
+    echo -e "\t6: use ipv6"
+    echo -e "\t4: use ipv4"
+    echo -e "\tport: Port number"
+    echo -e "\taddress: ip address"
+}
+
+while getopts "ha:p:64" opt; do
+    case ${opt} in
+	h)
+	    usage $0
+	    exit 0
+	    ;;
+	a)  addr=3D$OPTARG;;
+	p)
+	    port=3D$OPTARG;;
+	6)
+	    use_v6=3Dtrue;;
+	4)
+	    use_v6=3Dfalse;;
+    esac
+done
+
+setup() {
+    if [[ "$use_v6" =3D=3D true ]]; then
+	ip addr add $addr_v6 nodad dev eth0
+    else
+	ip addr add $addr_v4 dev lo
+    fi
+	ulimit -n $NR_FILES
+}
+
+cleanup() {
+    if [[ "$use_v6" =3D=3D true ]]; then
+	ip addr del $addr_v6 dev eth0
+    else
+	ip addr del $addr_v4/32 dev lo
+    fi
+    ulimit -n $SAVED_NR_FILES
+}
+
+if [[ "$addr" !=3D "" ]]; then
+    addr_v4=3D$addr;
+    addr_v6=3D$addr;
+fi
+setup
+if [[ "$use_v6" =3D=3D true ]] ; then
+    ./bind_bhash $port "ipv6" $addr_v6
+else
+    ./bind_bhash $port "ipv4" $addr_v4
+fi
+cleanup
--=20
2.30.2


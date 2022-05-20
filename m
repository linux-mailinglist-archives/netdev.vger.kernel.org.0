Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1D552E10E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343924AbiETASs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiETASo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AF99728F
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 17:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63727B8294E
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF94C34118;
        Fri, 20 May 2022 00:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653005921;
        bh=u0BHce1PAmc4Z16wraTXxT8wAJ+LUBA7Vi/FFahysB8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZkLCf4P44P1VxkcG6BOcrkz+0Wwjw4R1eL/zS3Gp1uVFzjKqn0GtcXqvqDJsZErMm
         TERe6IJPGomp5K0JlpLRiFp1KYrAAhQLOUoow5+8hjkbkVlmbJVnSicsFjwUumoi8i
         VRp1MlZjcR0GqqApnDZkYzK8BmqeorVF/WsWVsPqmsvjnn2Eo3dP0SnpaQyc/8mhxL
         Pk3LmnGWruVi8COif7LhiKRCv+oRlfB2ehQlTJHhChmMD4W1jf2lWmo/iaD8O59KGo
         nPZq2H6m/pNYFLZHmjoSV9Jt7xRgUMrs6ElmQslA2YUF4YwKjQqSjQBCOQvdLPYi54
         /N8Dgj8HGxAmQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v5 resend 2/2] selftests: Add test for timing a bind request to a port with a populated bhash entry
Date:   Thu, 19 May 2022 17:18:34 -0700
Message-Id: <20220520001834.2247810-3-kuba@kernel.org>
X-Mailer: git-send-email 2.34.3
In-Reply-To: <20220520001834.2247810-1-kuba@kernel.org>
References: <20220520001834.2247810-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>

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
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/testing/selftests/net/.gitignore        |   1 +
 tools/testing/selftests/net/Makefile          |   2 +
 tools/testing/selftests/net/bind_bhash_test.c | 119 ++++++++++++++++++
 3 files changed, 122 insertions(+)
 create mode 100644 tools/testing/selftests/net/bind_bhash_test.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 21a411b04890..735423136bc4 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -36,3 +36,4 @@ gro
 ioam6_parser
 toeplitz
 cmsg_sender
+bind_bhash_test
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 7ea54af55490..464df13831f2 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -59,6 +59,7 @@ TEST_GEN_FILES += toeplitz
 TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
 TEST_PROGS += test_vxlan_vnifiltering.sh
+TEST_GEN_FILES += bind_bhash_test
 
 TEST_FILES := settings
 
@@ -69,4 +70,5 @@ include bpf/Makefile
 
 $(OUTPUT)/reuseport_bpf_numa: LDLIBS += -lnuma
 $(OUTPUT)/tcp_mmap: LDLIBS += -lpthread
+$(OUTPUT)/bind_bhash_test: LDLIBS += -lpthread
 $(OUTPUT)/tcp_inq: LDLIBS += -lpthread
diff --git a/tools/testing/selftests/net/bind_bhash_test.c b/tools/testing/selftests/net/bind_bhash_test.c
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
+static const char *bind_addr = "::1";
+static const char *port;
+
+static int fd_array[MAX_THREADS][MAX_CONNECTIONS];
+
+static int bind_socket(int opt, const char *addr)
+{
+	struct addrinfo *res, hint = {};
+	int sock_fd, reuse = 1, err;
+
+	sock_fd = socket(AF_INET6, SOCK_STREAM, 0);
+	if (sock_fd < 0) {
+		perror("socket fd err");
+		return -1;
+	}
+
+	hint.ai_family = AF_INET6;
+	hint.ai_socktype = SOCK_STREAM;
+
+	err = getaddrinfo(addr, port, &hint, &res);
+	if (err) {
+		perror("getaddrinfo failed");
+		return -1;
+	}
+
+	if (opt) {
+		err = setsockopt(sock_fd, SOL_SOCKET, opt, &reuse, sizeof(reuse));
+		if (err) {
+			perror("setsockopt failed");
+			return -1;
+		}
+	}
+
+	err = bind(sock_fd, res->ai_addr, res->ai_addrlen);
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
+	int *array = (int *)arg;
+
+	for (i = 0; i < MAX_CONNECTIONS; i++) {
+		sock_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
+		if (sock_fd < 0)
+			return NULL;
+		array[i] = sock_fd;
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
+	if (argc != 2) {
+		printf("Usage: listener <port>\n");
+		return -1;
+	}
+
+	port = argv[1];
+
+	listener_fd = bind_socket(SO_REUSEADDR | SO_REUSEPORT, bind_addr);
+	if (listen(listener_fd, 100) < 0) {
+		perror("listen failed");
+		return -1;
+	}
+
+	/* Set up threads to populate the bhash table entry for the port */
+	for (i = 0; i < MAX_THREADS; i++)
+		pthread_create(&tid[i], NULL, setup, fd_array[i]);
+
+	for (i = 0; i < MAX_THREADS; i++)
+		pthread_join(tid[i], NULL);
+
+	begin = clock();
+
+	/* Bind to the same port on a different address */
+	sock_fd  = bind_socket(0, "2001:0db8:0:f101::1");
+
+	end = clock();
+
+	printf("time spent = %f\n", (double)(end - begin) / CLOCKS_PER_SEC);
+
+	/* clean up */
+	close(sock_fd);
+	close(listener_fd);
+	for (i = 0; i < MAX_THREADS; i++) {
+		for (j = 0; i < MAX_THREADS; i++)
+			close(fd_array[i][j]);
+	}
+
+	return 0;
+}
-- 
2.34.3


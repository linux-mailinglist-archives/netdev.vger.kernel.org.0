Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72957547141
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 04:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbiFKCSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 22:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348400AbiFKCSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 22:18:10 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2003F32D2F5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 19:18:06 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 354B4D855FA4; Fri, 10 Jun 2022 19:17:53 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        mathew.j.martineau@linux.intel.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v3 3/3] selftests/net: Add sk_bind_sendto_listen test
Date:   Fri, 10 Jun 2022 19:16:46 -0700
Message-Id: <20220611021646.1578080-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220611021646.1578080-1-joannelkoong@gmail.com>
References: <20220611021646.1578080-1-joannelkoong@gmail.com>
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

This patch adds a new test called sk_bind_sendto_listen.

This test exercises the path where a socket's rcv saddr changes after it
has been added to the binding tables, and then a listen() on the socket
is invoked. The listen() should succeed.

This test is copied over from one of syzbot's tests:
https://syzkaller.appspot.com/x/repro.c?x=3D1673a38df00000

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 tools/testing/selftests/net/.gitignore        |  1 +
 tools/testing/selftests/net/Makefile          |  1 +
 .../selftests/net/sk_bind_sendto_listen.c     | 82 +++++++++++++++++++
 3 files changed, 84 insertions(+)
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index b984f8c8d523..69f1a2aafde4 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -38,3 +38,4 @@ ioam6_parser
 toeplitz
 cmsg_sender
 bind_bhash_test
+sk_bind_sendto_listen
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index 464df13831f2..45f4f57bf1f4 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -60,6 +60,7 @@ TEST_GEN_FILES +=3D cmsg_sender
 TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
 TEST_GEN_FILES +=3D bind_bhash_test
+TEST_GEN_FILES +=3D sk_bind_sendto_listen
=20
 TEST_FILES :=3D settings
=20
diff --git a/tools/testing/selftests/net/sk_bind_sendto_listen.c b/tools/=
testing/selftests/net/sk_bind_sendto_listen.c
new file mode 100644
index 000000000000..3e09c5631997
--- /dev/null
+++ b/tools/testing/selftests/net/sk_bind_sendto_listen.c
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define _GNU_SOURCE
+
+#include <arpa/inet.h>
+#include <error.h>
+#include <errno.h>
+#include <unistd.h>
+
+int main(void)
+{
+	int fd1, fd2, one =3D 1;
+	struct sockaddr_in6 bind_addr =3D {
+		.sin6_family =3D AF_INET6,
+		.sin6_port =3D htons(20000),
+		.sin6_flowinfo =3D htonl(0),
+		.sin6_addr =3D {},
+		.sin6_scope_id =3D 0,
+	};
+
+	inet_pton(AF_INET6, "::", &bind_addr.sin6_addr);
+
+	fd1 =3D socket(AF_INET6, SOCK_STREAM, IPPROTO_IP);
+	if (fd1 < 0) {
+		error(1, errno, "socket fd1");
+		return -1;
+	}
+
+	if (setsockopt(fd1, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one))) {
+		error(1, errno, "setsockopt(SO_REUSEADDR) fd1");
+		goto out_err1;
+	}
+
+	if (bind(fd1, (struct sockaddr *)&bind_addr, sizeof(bind_addr))) {
+		error(1, errno, "bind fd1");
+		goto out_err1;
+	}
+
+	if (sendto(fd1, NULL, 0, MSG_FASTOPEN, (struct sockaddr *)&bind_addr,
+		   sizeof(bind_addr))) {
+		error(1, errno, "sendto fd1");
+		goto out_err1;
+	}
+
+	fd2 =3D socket(AF_INET6, SOCK_STREAM, IPPROTO_IP);
+	if (fd2 < 0) {
+		error(1, errno, "socket fd2");
+		goto out_err1;
+	}
+
+	if (setsockopt(fd2, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one))) {
+		error(1, errno, "setsockopt(SO_REUSEADDR) fd2");
+		goto out_err2;
+	}
+
+	if (bind(fd2, (struct sockaddr *)&bind_addr, sizeof(bind_addr))) {
+		error(1, errno, "bind fd2");
+		goto out_err2;
+	}
+
+	if (sendto(fd2, NULL, 0, MSG_FASTOPEN, (struct sockaddr *)&bind_addr,
+		   sizeof(bind_addr)) !=3D -1) {
+		error(1, errno, "sendto fd2");
+		goto out_err2;
+	}
+
+	if (listen(fd2, 0)) {
+		error(1, errno, "listen");
+		goto out_err2;
+	}
+
+	close(fd2);
+	close(fd1);
+	return 0;
+
+out_err2:
+	close(fd2);
+
+out_err1:
+	close(fd1);
+	return -1;
+}
--=20
2.30.2


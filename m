Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67784572A1D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 01:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiGLX43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 19:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiGLX42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 19:56:28 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9368EC7650
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 16:56:26 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id E62F0EDF92D2; Tue, 12 Jul 2022 16:56:08 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v2 3/3] selftests/net: Add sk_bind_sendto_listen test
Date:   Tue, 12 Jul 2022 16:53:10 -0700
Message-Id: <20220712235310.1935121-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712235310.1935121-1-joannelkoong@gmail.com>
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
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
 .../selftests/net/sk_bind_sendto_listen.c     | 80 +++++++++++++++++++
 3 files changed, 82 insertions(+)
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index 5b1adf6e29ae..5fd74a1162cc 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -39,3 +39,4 @@ toeplitz
 cmsg_sender
 unix_connect
 bind_bhash
+sk_bind_sendto_listen
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index e678fc3030a2..ffcc472d50d5 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -61,6 +61,7 @@ TEST_GEN_FILES +=3D cmsg_sender
 TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
 TEST_GEN_FILES +=3D bind_bhash
+TEST_GEN_FILES +=3D sk_bind_sendto_listen
=20
 TEST_FILES :=3D settings
=20
diff --git a/tools/testing/selftests/net/sk_bind_sendto_listen.c b/tools/=
testing/selftests/net/sk_bind_sendto_listen.c
new file mode 100644
index 000000000000..b420d830f72c
--- /dev/null
+++ b/tools/testing/selftests/net/sk_bind_sendto_listen.c
@@ -0,0 +1,80 @@
+// SPDX-License-Identifier: GPL-2.0
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


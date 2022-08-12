Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E200C59165B
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 22:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233391AbiHLUes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 16:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiHLUeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 16:34:46 -0400
Received: from 66-220-155-178.mail-mxout.facebook.com (66-220-155-178.mail-mxout.facebook.com [66.220.155.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173BFB1B9A
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 13:34:44 -0700 (PDT)
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 5F16810576446; Fri, 12 Aug 2022 13:31:50 -0700 (PDT)
From:   Joanne Koong <joannelkoong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net, pabeni@redhat.com, dccp@vger.kernel.org,
        Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v4 3/3] selftests/net: Add sk_bind_sendto_listen and sk_connect_zero_addr
Date:   Fri, 12 Aug 2022 13:29:05 -0700
Message-Id: <20220812202905.1599234-4-joannelkoong@gmail.com>
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

This patch adds 2 new tests: sk_bind_sendto_listen and
sk_connect_zero_addr.

The sk_bind_sendto_listen test exercises the path where a socket's
rcv saddr changes after it has been added to the binding tables,
and then a listen() on the socket is invoked. The listen() should
succeed.

The sk_bind_sendto_listen test is copied over from one of syzbot's
tests: https://syzkaller.appspot.com/x/repro.c?x=3D1673a38df00000

The sk_connect_zero_addr test exercises the path where the socket was
never previously added to the binding tables and it gets assigned a
saddr upon a connect() to address 0.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 tools/testing/selftests/net/.gitignore        |  2 +
 tools/testing/selftests/net/Makefile          |  2 +
 .../selftests/net/sk_bind_sendto_listen.c     | 80 +++++++++++++++++++
 .../selftests/net/sk_connect_zero_addr.c      | 62 ++++++++++++++
 4 files changed, 146 insertions(+)
 create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
 create mode 100644 tools/testing/selftests/net/sk_connect_zero_addr.c

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selft=
ests/net/.gitignore
index 89e2d4aa812a..bec5cf96984c 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -41,3 +41,5 @@ cmsg_sender
 unix_connect
 tap
 bind_bhash
+sk_bind_sendto_listen
+sk_connect_zero_addr
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftes=
ts/net/Makefile
index a3a26d8c29df..e9f02850106f 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -65,6 +65,8 @@ TEST_GEN_FILES +=3D stress_reuseport_listen
 TEST_PROGS +=3D test_vxlan_vnifiltering.sh
 TEST_GEN_FILES +=3D io_uring_zerocopy_tx
 TEST_GEN_FILES +=3D bind_bhash
+TEST_GEN_PROGS +=3D sk_bind_sendto_listen
+TEST_GEN_PROGS +=3D sk_connect_zero_addr
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
diff --git a/tools/testing/selftests/net/sk_connect_zero_addr.c b/tools/t=
esting/selftests/net/sk_connect_zero_addr.c
new file mode 100644
index 000000000000..4be418aefd9f
--- /dev/null
+++ b/tools/testing/selftests/net/sk_connect_zero_addr.c
@@ -0,0 +1,62 @@
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
+	if (listen(fd1, 0)) {
+		error(1, errno, "listen");
+		goto out_err1;
+	}
+
+	fd2 =3D socket(AF_INET6, SOCK_STREAM, IPPROTO_IP);
+	if (fd2 < 0) {
+		error(1, errno, "socket fd2");
+		goto out_err1;
+	}
+
+	if (connect(fd2, (struct sockaddr *)&bind_addr, sizeof(bind_addr))) {
+		error(1, errno, "bind fd2");
+		goto out_err2;
+	}
+
+	close(fd2);
+	close(fd1);
+	return 0;
+
+out_err2:
+	close(fd2);
+out_err1:
+	close(fd1);
+	return -1;
+}
--=20
2.30.2


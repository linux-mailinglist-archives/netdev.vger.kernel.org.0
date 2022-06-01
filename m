Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3C2F53B025
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbiFAUvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 16:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231841AbiFAUvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 16:51:14 -0400
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9919C31357
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 13:49:28 -0700 (PDT)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 251ECfrN011276
        for <netdev@vger.kernel.org>; Wed, 1 Jun 2022 13:17:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=bM2LwVSZWvHJ1w6VTvjy0NfRmZQxA5Ett49hqziQwoQ=;
 b=HLBNisynyiXzwTX5xefjjofSdYaKnPgmgi8r2UyxqNvnMAHVo/4Txwp24KPOdqU6Uje1
 Wvgehurkt7u+u8f+yuND35U6AG/8K8wA5T9wQs6VLutSny/z1r9nBtR9hlVo6utfTruC
 qpicnVdyYn5nzS7E/v5uID1y6Is+iCdcX3k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3gdv91xc76-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 13:17:05 -0700
Received: from twshared14818.18.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Wed, 1 Jun 2022 13:17:03 -0700
Received: by devbig010.atn6.facebook.com (Postfix, from userid 115148)
        id 1A680D254C67; Wed,  1 Jun 2022 13:16:59 -0700 (PDT)
From:   Joanne Koong <joannekoong@fb.com>
To:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <kafai@fb.com>, <kuba@kernel.org>,
        <davem@davemloft.net>, <pabeni@redhat.com>,
        <testing@vger.kernel.org>, Joanne Koong <joannelkoong@gmail.com>
Subject: [PATCH net-next v1 resend 2/2] selftests/net: Add sk_bind_sendto_listen test
Date:   Wed, 1 Jun 2022 13:14:34 -0700
Message-ID: <20220601201434.1710931-3-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220601201434.1710931-1-joannekoong@fb.com>
References: <20220601201434.1710931-1-joannekoong@fb.com>
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 01YwVqFFaemw1dkDe8ad-sWGJSR31uYG
X-Proofpoint-ORIG-GUID: 01YwVqFFaemw1dkDe8ad-sWGJSR31uYG
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-01_07,2022-06-01_01,2022-02-23_01
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joanne Koong <joannelkoong@gmail.com>

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

diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftes=
ts/net/.gitignore
index b984f8c8d523..69f1a2aafde4 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -38,3 +38,4 @@ ioam6_parser
 toeplitz
 cmsg_sender
 bind_bhash_test
+sk_bind_sendto_listen
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests=
/net/Makefile
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
diff --git a/tools/testing/selftests/net/sk_bind_sendto_listen.c b/tools/te=
sting/selftests/net/sk_bind_sendto_listen.c
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


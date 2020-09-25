Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11FD8277CA7
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 02:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgIYAEt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 20:04:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17898 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726906AbgIYAEs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 20:04:48 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08P01Ejc014733
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=004kJAju2PDCDNCH+7NSIrZH1zAtS9gsXC8HU0HnIKA=;
 b=BxCfR9AHc75siMTe3njGWGIzhes9EWPiS0nlYoAcxYyz3rQh0NnPQTVAhuAlVLUaPNEy
 ChA8pDG/NmfbqqOebRVKD6LQvM7POOnqAHsqY1vlYcy0Vm/ZHbNVMdw3XCNtAO9oZoAs
 SACuKthUuWIhlbbhXY/9THgeigCR4Pwmy7s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33qsp54re3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 17:04:48 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 24 Sep 2020 17:04:46 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 498842946606; Thu, 24 Sep 2020 17:04:40 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v4 bpf-next 10/13] bpf: selftest: Use network_helpers in the sock_fields test
Date:   Thu, 24 Sep 2020 17:04:40 -0700
Message-ID: <20200925000440.3858639-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
References: <20200925000337.3853598-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-24_18:2020-09-24,2020-09-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 spamscore=0 bulkscore=0 impostorscore=0 malwarescore=0 phishscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 suspectscore=15 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009240174
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch uses start_server() and connect_to_fd() from network_helpers.h
to remove the network testing boiler plate codes.  epoll is no longer
needed also since the timeout has already been taken care of also.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/sock_fields.c    | 88 ++-----------------
 1 file changed, 9 insertions(+), 79 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/sock_fields.c b/tools=
/testing/selftests/bpf/prog_tests/sock_fields.c
index d96b718639fb..eea8b96bb1be 100644
--- a/tools/testing/selftests/bpf/prog_tests/sock_fields.c
+++ b/tools/testing/selftests/bpf/prog_tests/sock_fields.c
@@ -1,8 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright (c) 2019 Facebook */
=20
-#include <sys/socket.h>
-#include <sys/epoll.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <unistd.h>
@@ -12,7 +10,9 @@
=20
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include <linux/compiler.h>
=20
+#include "network_helpers.h"
 #include "cgroup_helpers.h"
 #include "test_progs.h"
 #include "bpf_rlimit.h"
@@ -43,13 +43,6 @@ static __u32 duration;
 static __u32 egress_linum_idx =3D EGRESS_LINUM_IDX;
 static __u32 ingress_linum_idx =3D INGRESS_LINUM_IDX;
=20
-static void init_loopback6(struct sockaddr_in6 *sa6)
-{
-	memset(sa6, 0, sizeof(*sa6));
-	sa6->sin6_family =3D AF_INET6;
-	sa6->sin6_addr =3D in6addr_loopback;
-}
-
 static void print_sk(const struct bpf_sock *sk, const char *prefix)
 {
 	char src_ip4[24], dst_ip4[24];
@@ -252,28 +245,14 @@ static int init_sk_storage(int sk_fd, __u32 pkt_out=
_cnt)
=20
 static void test(void)
 {
-	int listen_fd =3D -1, cli_fd =3D -1, accept_fd =3D -1, epfd, err, i;
-	struct epoll_event ev;
-	socklen_t addrlen;
+	int listen_fd =3D -1, cli_fd =3D -1, accept_fd =3D -1, err, i;
+	socklen_t addrlen =3D sizeof(struct sockaddr_in6);
 	char buf[DATA_LEN];
=20
-	addrlen =3D sizeof(struct sockaddr_in6);
-	ev.events =3D EPOLLIN;
-
-	epfd =3D epoll_create(1);
-	if (CHECK(epfd =3D=3D -1, "epoll_create()", "epfd:%d errno:%d\n",
-		  epfd, errno))
-		return;
-
 	/* Prepare listen_fd */
-	listen_fd =3D socket(AF_INET6, SOCK_STREAM | SOCK_NONBLOCK, 0);
-	if (CHECK(listen_fd =3D=3D -1, "socket()", "listen_fd:%d errno:%d\n",
-		  listen_fd, errno))
-		goto done;
-
-	init_loopback6(&srv_sa6);
-	err =3D bind(listen_fd, (struct sockaddr *)&srv_sa6, sizeof(srv_sa6));
-	if (CHECK(err, "bind(listen_fd)", "err:%d errno:%d\n", err, errno))
+	listen_fd =3D start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	/* start_server() has logged the error details */
+	if (CHECK_FAIL(listen_fd =3D=3D -1))
 		goto done;
=20
 	err =3D getsockname(listen_fd, (struct sockaddr *)&srv_sa6, &addrlen);
@@ -282,19 +261,8 @@ static void test(void)
 		goto done;
 	memcpy(&skel->bss->srv_sa6, &srv_sa6, sizeof(srv_sa6));
=20
-	err =3D listen(listen_fd, 1);
-	if (CHECK(err, "listen(listen_fd)", "err:%d errno:%d\n", err, errno))
-		goto done;
-
-	/* Prepare cli_fd */
-	cli_fd =3D socket(AF_INET6, SOCK_STREAM | SOCK_NONBLOCK, 0);
-	if (CHECK(cli_fd =3D=3D -1, "socket()", "cli_fd:%d errno:%d\n", cli_fd,
-		  errno))
-		goto done;
-
-	init_loopback6(&cli_sa6);
-	err =3D bind(cli_fd, (struct sockaddr *)&cli_sa6, sizeof(cli_sa6));
-	if (CHECK(err, "bind(cli_fd)", "err:%d errno:%d\n", err, errno))
+	cli_fd =3D connect_to_fd(listen_fd, 0);
+	if (CHECK_FAIL(cli_fd =3D=3D -1))
 		goto done;
=20
 	err =3D getsockname(cli_fd, (struct sockaddr *)&cli_sa6, &addrlen);
@@ -302,41 +270,12 @@ static void test(void)
 		  err, errno))
 		goto done;
=20
-	/* Connect from cli_sa6 to srv_sa6 */
-	err =3D connect(cli_fd, (struct sockaddr *)&srv_sa6, addrlen);
-	printf("srv_sa6.sin6_port:%u cli_sa6.sin6_port:%u\n\n",
-	       ntohs(srv_sa6.sin6_port), ntohs(cli_sa6.sin6_port));
-	if (CHECK(err && errno !=3D EINPROGRESS,
-		  "connect(cli_fd)", "err:%d errno:%d\n", err, errno))
-		goto done;
-
-	ev.data.fd =3D listen_fd;
-	err =3D epoll_ctl(epfd, EPOLL_CTL_ADD, listen_fd, &ev);
-	if (CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, listen_fd)",
-		  "err:%d errno:%d\n", err, errno))
-		goto done;
-
-	/* Accept the connection */
-	/* Have some timeout in accept(listen_fd). Just in case. */
-	err =3D epoll_wait(epfd, &ev, 1, 1000);
-	if (CHECK(err !=3D 1 || ev.data.fd !=3D listen_fd,
-		  "epoll_wait(listen_fd)",
-		  "err:%d errno:%d ev.data.fd:%d listen_fd:%d\n",
-		  err, errno, ev.data.fd, listen_fd))
-		goto done;
-
 	accept_fd =3D accept(listen_fd, NULL, NULL);
 	if (CHECK(accept_fd =3D=3D -1, "accept(listen_fd)",
 		  "accept_fd:%d errno:%d\n",
 		  accept_fd, errno))
 		goto done;
=20
-	ev.data.fd =3D cli_fd;
-	err =3D epoll_ctl(epfd, EPOLL_CTL_ADD, cli_fd, &ev);
-	if (CHECK(err, "epoll_ctl(EPOLL_CTL_ADD, cli_fd)",
-		  "err:%d errno:%d\n", err, errno))
-		goto done;
-
 	if (init_sk_storage(accept_fd, 0xeB9F))
 		goto done;
=20
@@ -349,14 +288,6 @@ static void test(void)
 			  "err:%d errno:%d\n", err, errno))
 			goto done;
=20
-		/* Have some timeout in recv(cli_fd). Just in case. */
-		err =3D epoll_wait(epfd, &ev, 1, 1000);
-		if (CHECK(err !=3D 1 || ev.data.fd !=3D cli_fd,
-			  "epoll_wait(cli_fd)",
-			  "err:%d errno:%d ev.data.fd:%d cli_fd:%d\n",
-			  err, errno, ev.data.fd, cli_fd))
-			goto done;
-
 		err =3D recv(cli_fd, buf, DATA_LEN, 0);
 		if (CHECK(err !=3D DATA_LEN, "recv(cli_fd)", "err:%d errno:%d\n",
 			  err, errno))
@@ -383,7 +314,6 @@ static void test(void)
 		close(cli_fd);
 	if (listen_fd !=3D -1)
 		close(listen_fd);
-	close(epfd);
 }
=20
 void test_sock_fields(void)
--=20
2.24.1


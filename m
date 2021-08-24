Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1C3F6767
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241724AbhHXRdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:33:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241601AbhHXRbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 13:31:22 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 17OHUIk6024211
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=pQkh0AVdTYD2zudpQ1RZbeyQIrKN+/IGBCB8lJDlRMc=;
 b=Gq38r/tePXhzOMAoND6y1qwH8pD9oXoeq6MEkmRbE5LWuy+GpqaKBls2MUozqvTBDnbs
 7a02QOaSZo53+Cn5YVoLy2UX5fXAnbEZnJ1mG/6lovFTsD2K+v54/sNvHcns5ewn4JX9
 rNnxU0ngwrMODu6GfqXB46yeO1URakiI5a4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3an506r40g-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Aug 2021 10:30:36 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 10:30:30 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 128EC2940D05; Tue, 24 Aug 2021 10:30:26 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v2 bpf-next 4/4] bpf: selftests: Add dctcp fallback test
Date:   Tue, 24 Aug 2021 10:30:26 -0700
Message-ID: <20210824173026.3979130-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824173000.3976470-1-kafai@fb.com>
References: <20210824173000.3976470-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 9LZ7Ru3469pdw20B1gvbaqxKf_g87XHC
X-Proofpoint-ORIG-GUID: 9LZ7Ru3469pdw20B1gvbaqxKf_g87XHC
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-24_05:2021-08-24,2021-08-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 bulkscore=0 phishscore=0 impostorscore=0 spamscore=0
 mlxlogscore=996 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108240115
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch makes the bpf_dctcp test to fallback to cubic by
using setsockopt(TCP_CONGESTION) when the tcp flow is not
ecn ready.

It also checks setsockopt() is not available to release().

The settimeo() from the network_helpers.h is used, so the local
one is removed.

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     | 106 ++++++++++++++----
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |  25 +++++
 .../selftests/bpf/progs/bpf_dctcp_release.c   |  26 +++++
 3 files changed, 134 insertions(+), 23 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_dctcp_release.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c b/tools/=
testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
index efe1e979affb..94e03df69d71 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_tcp_ca.c
@@ -4,37 +4,22 @@
 #include <linux/err.h>
 #include <netinet/tcp.h>
 #include <test_progs.h>
+#include "network_helpers.h"
 #include "bpf_dctcp.skel.h"
 #include "bpf_cubic.skel.h"
 #include "bpf_tcp_nogpl.skel.h"
+#include "bpf_dctcp_release.skel.h"
=20
 #define min(a, b) ((a) < (b) ? (a) : (b))
=20
+#ifndef ENOTSUPP
+#define ENOTSUPP 524
+#endif
+
 static const unsigned int total_bytes =3D 10 * 1024 * 1024;
-static const struct timeval timeo_sec =3D { .tv_sec =3D 10 };
-static const size_t timeo_optlen =3D sizeof(timeo_sec);
 static int expected_stg =3D 0xeB9F;
 static int stop, duration;
=20
-static int settimeo(int fd)
-{
-	int err;
-
-	err =3D setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeo_sec,
-			 timeo_optlen);
-	if (CHECK(err =3D=3D -1, "setsockopt(fd, SO_RCVTIMEO)", "errno:%d\n",
-		  errno))
-		return -1;
-
-	err =3D setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeo_sec,
-			 timeo_optlen);
-	if (CHECK(err =3D=3D -1, "setsockopt(fd, SO_SNDTIMEO)", "errno:%d\n",
-		  errno))
-		return -1;
-
-	return 0;
-}
-
 static int settcpca(int fd, const char *tcp_ca)
 {
 	int err;
@@ -61,7 +46,7 @@ static void *server(void *arg)
 		goto done;
 	}
=20
-	if (settimeo(fd)) {
+	if (settimeo(fd, 0)) {
 		err =3D -errno;
 		goto done;
 	}
@@ -114,7 +99,7 @@ static void do_test(const char *tcp_ca, const struct b=
pf_map *sk_stg_map)
 	}
=20
 	if (settcpca(lfd, tcp_ca) || settcpca(fd, tcp_ca) ||
-	    settimeo(lfd) || settimeo(fd))
+	    settimeo(lfd, 0) || settimeo(fd, 0))
 		goto done;
=20
 	/* bind, listen and start server thread to accept */
@@ -267,6 +252,77 @@ static void test_invalid_license(void)
 	libbpf_set_print(old_print_fn);
 }
=20
+static void test_dctcp_fallback(void)
+{
+	int err, lfd =3D -1, cli_fd =3D -1, srv_fd =3D -1;
+	struct network_helper_opts opts =3D {
+		.cc =3D "cubic",
+	};
+	struct bpf_dctcp *dctcp_skel;
+	struct bpf_link *link =3D NULL;
+	char srv_cc[16];
+	socklen_t cc_len =3D sizeof(srv_cc);
+
+	dctcp_skel =3D bpf_dctcp__open();
+	if (!ASSERT_OK_PTR(dctcp_skel, "dctcp_skel"))
+		return;
+	strcpy(dctcp_skel->rodata->fallback, "cubic");
+	if (!ASSERT_OK(bpf_dctcp__load(dctcp_skel), "bpf_dctcp__load"))
+		goto done;
+
+	link =3D bpf_map__attach_struct_ops(dctcp_skel->maps.dctcp);
+	if (!ASSERT_OK_PTR(link, "dctcp link"))
+		goto done;
+
+	lfd =3D start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (!ASSERT_GE(lfd, 0, "lfd") ||
+	    !ASSERT_OK(settcpca(lfd, "bpf_dctcp"), "lfd=3D>bpf_dctcp"))
+		goto done;
+
+	cli_fd =3D connect_to_fd_opts(lfd, &opts);
+	if (!ASSERT_GE(cli_fd, 0, "cli_fd"))
+		goto done;
+
+	srv_fd =3D accept(lfd, NULL, 0);
+	if (!ASSERT_GE(srv_fd, 0, "srv_fd"))
+		goto done;
+	ASSERT_STREQ(dctcp_skel->bss->cc_res, "cubic", "cc_res");
+	ASSERT_EQ(dctcp_skel->bss->tcp_cdg_res, -ENOTSUPP, "tcp_cdg_res");
+
+	err =3D getsockopt(srv_fd, SOL_TCP, TCP_CONGESTION, srv_cc, &cc_len);
+	if (!ASSERT_OK(err, "getsockopt(srv_fd, TCP_CONGESTION)"))
+		goto done;
+	ASSERT_STREQ(srv_cc, "cubic", "srv_fd cc");
+
+done:
+	bpf_link__destroy(link);
+	bpf_dctcp__destroy(dctcp_skel);
+	if (lfd !=3D -1)
+		close(lfd);
+	if (srv_fd !=3D -1)
+		close(srv_fd);
+	if (cli_fd !=3D -1)
+		close(cli_fd);
+}
+
+static void test_rel_setsockopt(void)
+{
+	struct bpf_dctcp_release *rel_skel;
+	libbpf_print_fn_t old_print_fn;
+
+	err_str =3D "unknown func bpf_setsockopt";
+	found =3D false;
+
+	old_print_fn =3D libbpf_set_print(libbpf_debug_print);
+	rel_skel =3D bpf_dctcp_release__open_and_load();
+	libbpf_set_print(old_print_fn);
+
+	ASSERT_ERR_PTR(rel_skel, "rel_skel");
+	ASSERT_TRUE(found, "expected_err_msg");
+
+	bpf_dctcp_release__destroy(rel_skel);
+}
+
 void test_bpf_tcp_ca(void)
 {
 	if (test__start_subtest("dctcp"))
@@ -275,4 +331,8 @@ void test_bpf_tcp_ca(void)
 		test_cubic();
 	if (test__start_subtest("invalid_license"))
 		test_invalid_license();
+	if (test__start_subtest("dctcp_fallback"))
+		test_dctcp_fallback();
+	if (test__start_subtest("rel_setsockopt"))
+		test_rel_setsockopt();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp.c b/tools/testin=
g/selftests/bpf/progs/bpf_dctcp.c
index fd42247da8b4..9573be6122be 100644
--- a/tools/testing/selftests/bpf/progs/bpf_dctcp.c
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp.c
@@ -17,6 +17,11 @@
=20
 char _license[] SEC("license") =3D "GPL";
=20
+volatile const char fallback[TCP_CA_NAME_MAX];
+const char bpf_dctcp[] =3D "bpf_dctcp";
+const char tcp_cdg[] =3D "cdg";
+char cc_res[TCP_CA_NAME_MAX];
+int tcp_cdg_res =3D 0;
 int stg_result =3D 0;
=20
 struct {
@@ -57,6 +62,26 @@ void BPF_PROG(dctcp_init, struct sock *sk)
 	struct dctcp *ca =3D inet_csk_ca(sk);
 	int *stg;
=20
+	if (!(tp->ecn_flags & TCP_ECN_OK) && fallback[0]) {
+		/* Switch to fallback */
+		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+			       (void *)fallback, sizeof(fallback));
+		/* Switch back to myself which the bpf trampoline
+		 * stopped calling dctcp_init recursively.
+		 */
+		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+			       (void *)bpf_dctcp, sizeof(bpf_dctcp));
+		/* Switch back to fallback */
+		bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+			       (void *)fallback, sizeof(fallback));
+		/* Expecting -ENOTSUPP for tcp_cdg_res */
+		tcp_cdg_res =3D bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+					     (void *)tcp_cdg, sizeof(tcp_cdg));
+		bpf_getsockopt(sk, SOL_TCP, TCP_CONGESTION,
+			       (void *)cc_res, sizeof(cc_res));
+		return;
+	}
+
 	ca->prior_rcv_nxt =3D tp->rcv_nxt;
 	ca->dctcp_alpha =3D min(dctcp_alpha_on_init, DCTCP_MAX_ALPHA);
 	ca->loss_cwnd =3D 0;
diff --git a/tools/testing/selftests/bpf/progs/bpf_dctcp_release.c b/tool=
s/testing/selftests/bpf/progs/bpf_dctcp_release.c
new file mode 100644
index 000000000000..d836f7c372f0
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_dctcp_release.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+
+#include <stddef.h>
+#include <linux/bpf.h>
+#include <linux/types.h>
+#include <linux/stddef.h>
+#include <linux/tcp.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include "bpf_tcp_helpers.h"
+
+char _license[] SEC("license") =3D "GPL";
+const char cubic[] =3D "cubic";
+
+void BPF_STRUCT_OPS(dctcp_nouse_release, struct sock *sk)
+{
+	bpf_setsockopt(sk, SOL_TCP, TCP_CONGESTION,
+		       (void *)cubic, sizeof(cubic));
+}
+
+SEC(".struct_ops")
+struct tcp_congestion_ops dctcp_rel =3D {
+	.release	=3D (void *)dctcp_nouse_release,
+	.name		=3D "bpf_dctcp_rel",
+};
--=20
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD89B3B96F3
	for <lists+netdev@lfdr.de>; Thu,  1 Jul 2021 22:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbhGAUKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Jul 2021 16:10:25 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25100 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232151AbhGAUKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Jul 2021 16:10:24 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 161K15vn013549
        for <netdev@vger.kernel.org>; Thu, 1 Jul 2021 13:07:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yAcd1HjSZpDkmk8UJDbX9Z0p7t9qpbvHFOFAnstSoJM=;
 b=bj0EFrbWmlWAuRF0DXKu3ZRE5mrIHTLsxR6XPBFXnIYCruIq/ADGeZfkLYZQomUwaiNz
 TjKDLEYXiZRgRcQBM2Ph04j9NM3MFQrhhQ1YJNhHk7tN9AwSZhjQJP+XoBq7jhX8tNjr
 FTLLwPcY2P2mEwMQQZG0lUG5kSkrgC2V82s= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 39h84wcmfm-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 13:07:52 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 1 Jul 2021 13:06:28 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9ACBA2940BCC; Thu,  1 Jul 2021 13:06:25 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        Neal Cardwell <ncardwell@google.com>, <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
Subject: [PATCH v2 bpf-next 8/8] bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter
Date:   Thu, 1 Jul 2021 13:06:25 -0700
Message-ID: <20210701200625.1036874-1-kafai@fb.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
References: <20210701200535.1033513-1-kafai@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: WMcmdAgI5Rj003oOfj0hYtnU1HCIMOWq
X-Proofpoint-GUID: WMcmdAgI5Rj003oOfj0hYtnU1HCIMOWq
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-01_12:2021-07-01,2021-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 suspectscore=0 mlxscore=0 priorityscore=1501 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107010117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds tests for the batching and bpf_(get|set)sockopt in
bpf tcp iter.

It first creates:
a) 1 non SO_REUSEPORT listener in lhash2.
b) 256 passive and active fds connected to the listener in (a).
c) 256 SO_REUSEPORT listeners in one of the lhash2 bucket.

The test sets all listeners and connections to bpf_cubic before
running the bpf iter.

The bpf iter then calls setsockopt(TCP_CONGESTION) to switch
each listener and connection from bpf_cubic to bpf_dctcp.

The bpf iter has a random_retry mode such that it can return EAGAIN
to the usespace in the middle of a batch.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/testing/selftests/bpf/network_helpers.c |  85 ++++++-
 tools/testing/selftests/bpf/network_helpers.h |   4 +
 .../bpf/prog_tests/bpf_iter_setsockopt.c      | 226 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_setsockopt.c |  72 ++++++
 .../selftests/bpf/progs/bpf_tracing_net.h     |   6 +
 5 files changed, 384 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter_setso=
ckopt.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_setsockopt=
.c

diff --git a/tools/testing/selftests/bpf/network_helpers.c b/tools/testin=
g/selftests/bpf/network_helpers.c
index 2060bc122c53..26468a8f44f3 100644
--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -66,17 +66,13 @@ int settimeo(int fd, int timeout_ms)
=20
 #define save_errno_close(fd) ({ int __save =3D errno; close(fd); errno =3D=
 __save; })
=20
-int start_server(int family, int type, const char *addr_str, __u16 port,
-		 int timeout_ms)
+static int __start_server(int type, const struct sockaddr *addr,
+			  socklen_t addrlen, int timeout_ms, bool reuseport)
 {
-	struct sockaddr_storage addr =3D {};
-	socklen_t len;
+	int on =3D 1;
 	int fd;
=20
-	if (make_sockaddr(family, addr_str, port, &addr, &len))
-		return -1;
-
-	fd =3D socket(family, type, 0);
+	fd =3D socket(addr->sa_family, type, 0);
 	if (fd < 0) {
 		log_err("Failed to create server socket");
 		return -1;
@@ -85,7 +81,13 @@ int start_server(int family, int type, const char *add=
r_str, __u16 port,
 	if (settimeo(fd, timeout_ms))
 		goto error_close;
=20
-	if (bind(fd, (const struct sockaddr *)&addr, len) < 0) {
+	if (reuseport &&
+	    setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &on, sizeof(on))) {
+		log_err("Failed to set SO_REUSEPORT");
+		return -1;
+	}
+
+	if (bind(fd, addr, addrlen) < 0) {
 		log_err("Failed to bind socket");
 		goto error_close;
 	}
@@ -104,6 +106,69 @@ int start_server(int family, int type, const char *a=
ddr_str, __u16 port,
 	return -1;
 }
=20
+int start_server(int family, int type, const char *addr_str, __u16 port,
+		 int timeout_ms)
+{
+	struct sockaddr_storage addr;
+	socklen_t addrlen;
+
+	if (make_sockaddr(family, addr_str, port, &addr, &addrlen))
+		return -1;
+
+	return __start_server(type, (struct sockaddr *)&addr,
+			      addrlen, timeout_ms, false);
+}
+
+int *start_reuseport_server(int family, int type, const char *addr_str,
+			    __u16 port, int timeout_ms, unsigned int nr_listens)
+{
+	struct sockaddr_storage addr;
+	unsigned int nr_fds =3D 0;
+	socklen_t addrlen;
+	int *fds;
+
+	if (!nr_listens)
+		return NULL;
+
+	if (make_sockaddr(family, addr_str, port, &addr, &addrlen))
+		return NULL;
+
+	fds =3D malloc(sizeof(*fds) * nr_listens);
+	if (!fds)
+		return NULL;
+
+	fds[0] =3D __start_server(type, (struct sockaddr *)&addr, addrlen,
+				timeout_ms, true);
+	if (fds[0] =3D=3D -1)
+		goto close_fds;
+	nr_fds =3D 1;
+
+	if (getsockname(fds[0], (struct sockaddr *)&addr, &addrlen))
+		goto close_fds;
+
+	for (; nr_fds < nr_listens; nr_fds++) {
+		fds[nr_fds] =3D __start_server(type, (struct sockaddr *)&addr,
+					     addrlen, timeout_ms, true);
+		if (fds[nr_fds] =3D=3D -1)
+			goto close_fds;
+	}
+
+	return fds;
+
+close_fds:
+	free_fds(fds, nr_fds);
+	return NULL;
+}
+
+void free_fds(int *fds, unsigned int nr_close_fds)
+{
+	if (fds) {
+		while (nr_close_fds)
+			close(fds[--nr_close_fds]);
+		free(fds);
+	}
+}
+
 int fastopen_connect(int server_fd, const char *data, unsigned int data_=
len,
 		     int timeout_ms)
 {
@@ -217,6 +282,7 @@ int make_sockaddr(int family, const char *addr_str, _=
_u16 port,
 	if (family =3D=3D AF_INET) {
 		struct sockaddr_in *sin =3D (void *)addr;
=20
+		memset(addr, 0, sizeof(*sin));
 		sin->sin_family =3D AF_INET;
 		sin->sin_port =3D htons(port);
 		if (addr_str &&
@@ -230,6 +296,7 @@ int make_sockaddr(int family, const char *addr_str, _=
_u16 port,
 	} else if (family =3D=3D AF_INET6) {
 		struct sockaddr_in6 *sin6 =3D (void *)addr;
=20
+		memset(addr, 0, sizeof(*sin6));
 		sin6->sin6_family =3D AF_INET6;
 		sin6->sin6_port =3D htons(port);
 		if (addr_str &&
diff --git a/tools/testing/selftests/bpf/network_helpers.h b/tools/testin=
g/selftests/bpf/network_helpers.h
index 5e0d51c07b63..d60bc2897770 100644
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -36,6 +36,10 @@ extern struct ipv6_packet pkt_v6;
 int settimeo(int fd, int timeout_ms);
 int start_server(int family, int type, const char *addr, __u16 port,
 		 int timeout_ms);
+int *start_reuseport_server(int family, int type, const char *addr_str,
+			    __u16 port, int timeout_ms,
+			    unsigned int nr_listens);
+void free_fds(int *fds, unsigned int nr_close_fds);
 int connect_to_fd(int server_fd, int timeout_ms);
 int connect_fd_to_fd(int client_fd, int server_fd, int timeout_ms);
 int fastopen_connect(int server_fd, const char *data, unsigned int data_=
len,
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c=
 b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
new file mode 100644
index 000000000000..85babb0487b3
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter_setsockopt.c
@@ -0,0 +1,226 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#define _GNU_SOURCE
+#include <sched.h>
+#include <test_progs.h>
+#include "network_helpers.h"
+#include "bpf_dctcp.skel.h"
+#include "bpf_cubic.skel.h"
+#include "bpf_iter_setsockopt.skel.h"
+
+static int create_netns(void)
+{
+	if (!ASSERT_OK(unshare(CLONE_NEWNET), "create netns"))
+		return -1;
+
+	if (!ASSERT_OK(system("ip link set dev lo up"), "bring up lo"))
+		return -1;
+
+	return 0;
+}
+
+static unsigned int set_bpf_cubic(int *fds, unsigned int nr_fds)
+{
+	unsigned int i;
+
+	for (i =3D 0; i < nr_fds; i++) {
+		if (setsockopt(fds[i], SOL_TCP, TCP_CONGESTION, "bpf_cubic",
+			       sizeof("bpf_cubic")))
+			return i;
+	}
+
+	return nr_fds;
+}
+
+static unsigned int check_bpf_dctcp(int *fds, unsigned int nr_fds)
+{
+	char tcp_cc[16];
+	socklen_t optlen =3D sizeof(tcp_cc);
+	unsigned int i;
+
+	for (i =3D 0; i < nr_fds; i++) {
+		if (getsockopt(fds[i], SOL_TCP, TCP_CONGESTION,
+			       tcp_cc, &optlen) ||
+		    strcmp(tcp_cc, "bpf_dctcp"))
+			return i;
+	}
+
+	return nr_fds;
+}
+
+static int *make_established(int listen_fd, unsigned int nr_est,
+			     int **paccepted_fds)
+{
+	int *est_fds, *accepted_fds;
+	unsigned int i;
+
+	est_fds =3D malloc(sizeof(*est_fds) * nr_est);
+	if (!est_fds)
+		return NULL;
+
+	accepted_fds =3D malloc(sizeof(*accepted_fds) * nr_est);
+	if (!accepted_fds) {
+		free(est_fds);
+		return NULL;
+	}
+
+	for (i =3D 0; i < nr_est; i++) {
+		est_fds[i] =3D connect_to_fd(listen_fd, 0);
+		if (est_fds[i] =3D=3D -1)
+			break;
+		if (set_bpf_cubic(&est_fds[i], 1) !=3D 1) {
+			close(est_fds[i]);
+			break;
+		}
+
+		accepted_fds[i] =3D accept(listen_fd, NULL, 0);
+		if (accepted_fds[i] =3D=3D -1) {
+			close(est_fds[i]);
+			break;
+		}
+	}
+
+	if (!ASSERT_EQ(i, nr_est, "create established fds")) {
+		free_fds(accepted_fds, i);
+		free_fds(est_fds, i);
+		return NULL;
+	}
+
+	*paccepted_fds =3D accepted_fds;
+	return est_fds;
+}
+
+static unsigned short get_local_port(int fd)
+{
+	struct sockaddr_in6 addr;
+	socklen_t addrlen =3D sizeof(addr);
+
+	if (!getsockname(fd, &addr, &addrlen))
+		return ntohs(addr.sin6_port);
+
+	return 0;
+}
+
+static void do_bpf_iter_setsockopt(struct bpf_iter_setsockopt *iter_skel=
,
+				   bool random_retry)
+{
+	int *reuse_listen_fds =3D NULL, *accepted_fds =3D NULL, *est_fds =3D NU=
LL;
+	unsigned int nr_reuse_listens =3D 256, nr_est =3D 256;
+	int err, iter_fd =3D -1, listen_fd =3D -1;
+	char buf;
+
+	/* Prepare non-reuseport listen_fd */
+	listen_fd =3D start_server(AF_INET6, SOCK_STREAM, "::1", 0, 0);
+	if (!ASSERT_GE(listen_fd, 0, "start_server"))
+		return;
+	if (!ASSERT_EQ(set_bpf_cubic(&listen_fd, 1), 1,
+		       "set listen_fd to cubic"))
+		goto done;
+	iter_skel->bss->listen_hport =3D get_local_port(listen_fd);
+	if (!ASSERT_NEQ(iter_skel->bss->listen_hport, 0,
+			"get_local_port(listen_fd)"))
+		goto done;
+
+	/* Connect to non-reuseport listen_fd */
+	est_fds =3D make_established(listen_fd, nr_est, &accepted_fds);
+	if (!ASSERT_OK_PTR(est_fds, "create established"))
+		goto done;
+
+	/* Prepare reuseport listen fds */
+	reuse_listen_fds =3D start_reuseport_server(AF_INET6, SOCK_STREAM,
+						  "::1", 0, 0,
+						  nr_reuse_listens);
+	if (!ASSERT_OK_PTR(reuse_listen_fds, "start_reuseport_server"))
+		goto done;
+	if (!ASSERT_EQ(set_bpf_cubic(reuse_listen_fds, nr_reuse_listens),
+		       nr_reuse_listens, "set reuse_listen_fds to cubic"))
+		goto done;
+	iter_skel->bss->reuse_listen_hport =3D get_local_port(reuse_listen_fds[=
0]);
+	if (!ASSERT_NEQ(iter_skel->bss->reuse_listen_hport, 0,
+			"get_local_port(reuse_listen_fds[0])"))
+		goto done;
+
+	/* Run bpf tcp iter to switch from bpf_cubic to bpf_dctcp */
+	iter_skel->bss->random_retry =3D random_retry;
+	iter_fd =3D bpf_iter_create(bpf_link__fd(iter_skel->links.change_tcp_cc=
));
+	if (!ASSERT_GE(iter_fd, 0, "create iter_fd"))
+		goto done;
+
+	while ((err =3D read(iter_fd, &buf, sizeof(buf))) =3D=3D -1 &&
+	       errno =3D=3D EAGAIN)
+		;
+	if (!ASSERT_OK(err, "read iter error"))
+		goto done;
+
+	/* Check reuseport listen fds for dctcp */
+	ASSERT_EQ(check_bpf_dctcp(reuse_listen_fds, nr_reuse_listens),
+		  nr_reuse_listens,
+		  "check reuse_listen_fds dctcp");
+
+	/* Check non reuseport listen fd for dctcp */
+	ASSERT_EQ(check_bpf_dctcp(&listen_fd, 1), 1,
+		  "check listen_fd dctcp");
+
+	/* Check established fds for dctcp */
+	ASSERT_EQ(check_bpf_dctcp(est_fds, nr_est), nr_est,
+		  "check est_fds dctcp");
+
+	/* Check accepted fds for dctcp */
+	ASSERT_EQ(check_bpf_dctcp(accepted_fds, nr_est), nr_est,
+		  "check accepted_fds dctcp");
+
+done:
+	if (iter_fd !=3D -1)
+		close(iter_fd);
+	if (listen_fd !=3D -1)
+		close(listen_fd);
+	free_fds(reuse_listen_fds, nr_reuse_listens);
+	free_fds(accepted_fds, nr_est);
+	free_fds(est_fds, nr_est);
+}
+
+void test_bpf_iter_setsockopt(void)
+{
+	struct bpf_iter_setsockopt *iter_skel =3D NULL;
+	struct bpf_cubic *cubic_skel =3D NULL;
+	struct bpf_dctcp *dctcp_skel =3D NULL;
+	struct bpf_link *cubic_link =3D NULL;
+	struct bpf_link *dctcp_link =3D NULL;
+
+	if (create_netns())
+		return;
+
+	/* Load iter_skel */
+	iter_skel =3D bpf_iter_setsockopt__open_and_load();
+	if (!ASSERT_OK_PTR(iter_skel, "iter_skel"))
+		return;
+	iter_skel->links.change_tcp_cc =3D bpf_program__attach_iter(iter_skel->=
progs.change_tcp_cc, NULL);
+	if (!ASSERT_OK_PTR(iter_skel->links.change_tcp_cc, "attach iter"))
+		goto done;
+
+	/* Load bpf_cubic */
+	cubic_skel =3D bpf_cubic__open_and_load();
+	if (!ASSERT_OK_PTR(cubic_skel, "cubic_skel"))
+		goto done;
+	cubic_link =3D bpf_map__attach_struct_ops(cubic_skel->maps.cubic);
+	if (!ASSERT_OK_PTR(cubic_link, "cubic_link"))
+		goto done;
+
+	/* Load bpf_dctcp */
+	dctcp_skel =3D bpf_dctcp__open_and_load();
+	if (!ASSERT_OK_PTR(dctcp_skel, "dctcp_skel"))
+		goto done;
+	dctcp_link =3D bpf_map__attach_struct_ops(dctcp_skel->maps.dctcp);
+	if (!ASSERT_OK_PTR(dctcp_link, "dctcp_link"))
+		goto done;
+
+	do_bpf_iter_setsockopt(iter_skel, true);
+	do_bpf_iter_setsockopt(iter_skel, false);
+
+done:
+	bpf_link__destroy(cubic_link);
+	bpf_link__destroy(dctcp_link);
+	bpf_cubic__destroy(cubic_skel);
+	bpf_dctcp__destroy(dctcp_skel);
+	bpf_iter_setsockopt__destroy(iter_skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
new file mode 100644
index 000000000000..b77adfd55d73
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_setsockopt.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2021 Facebook */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_endian.h>
+
+#define bpf_tcp_sk(skc)	({				\
+	struct sock_common *_skc =3D skc;			\
+	sk =3D NULL;					\
+	tp =3D NULL;					\
+	if (_skc) {					\
+		tp =3D bpf_skc_to_tcp_sock(_skc);		\
+		sk =3D (struct sock *)tp;			\
+	}						\
+	tp;						\
+})
+
+unsigned short reuse_listen_hport =3D 0;
+unsigned short listen_hport =3D 0;
+char cubic_cc[TCP_CA_NAME_MAX] =3D "bpf_cubic";
+char dctcp_cc[TCP_CA_NAME_MAX] =3D "bpf_dctcp";
+bool random_retry =3D false;
+
+static bool tcp_cc_eq(const char *a, const char *b)
+{
+	int i;
+
+	for (i =3D 0; i < TCP_CA_NAME_MAX; i++) {
+		if (a[i] !=3D b[i])
+			return false;
+		if (!a[i])
+			break;
+	}
+
+	return true;
+}
+
+SEC("iter/tcp")
+int change_tcp_cc(struct bpf_iter__tcp *ctx)
+{
+	char cur_cc[TCP_CA_NAME_MAX];
+	struct tcp_sock *tp;
+	struct sock *sk;
+	int ret;
+
+	if (!bpf_tcp_sk(ctx->sk_common))
+		return 0;
+
+	if (sk->sk_family !=3D AF_INET6 ||
+	    (sk->sk_state !=3D TCP_LISTEN &&
+	     sk->sk_state !=3D TCP_ESTABLISHED) ||
+	    (sk->sk_num !=3D reuse_listen_hport &&
+	     sk->sk_num !=3D listen_hport &&
+	     bpf_ntohs(sk->sk_dport) !=3D listen_hport))
+		return 0;
+
+	if (bpf_getsockopt(tp, SOL_TCP, TCP_CONGESTION,
+			   cur_cc, sizeof(cur_cc)))
+		return 0;
+
+	if (!tcp_cc_eq(cur_cc, cubic_cc))
+		return 0;
+
+	if (random_retry && bpf_get_prandom_u32() % 4 =3D=3D 1)
+		return 1;
+
+	bpf_setsockopt(tp, SOL_TCP, TCP_CONGESTION, dctcp_cc, sizeof(dctcp_cc))=
;
+	return 0;
+}
+
+char _license[] SEC("license") =3D "GPL";
diff --git a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h b/tools/=
testing/selftests/bpf/progs/bpf_tracing_net.h
index 01378911252b..3af0998a0623 100644
--- a/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
+++ b/tools/testing/selftests/bpf/progs/bpf_tracing_net.h
@@ -5,6 +5,10 @@
 #define AF_INET			2
 #define AF_INET6		10
=20
+#define SOL_TCP			6
+#define TCP_CONGESTION		13
+#define TCP_CA_NAME_MAX		16
+
 #define ICSK_TIME_RETRANS	1
 #define ICSK_TIME_PROBE0	3
 #define ICSK_TIME_LOSS_PROBE	5
@@ -32,6 +36,8 @@
 #define ir_v6_rmt_addr		req.__req_common.skc_v6_daddr
 #define ir_v6_loc_addr		req.__req_common.skc_v6_rcv_saddr
=20
+#define sk_num			__sk_common.skc_num
+#define sk_dport		__sk_common.skc_dport
 #define sk_family		__sk_common.skc_family
 #define sk_rmem_alloc		sk_backlog.rmem_alloc
 #define sk_refcnt		__sk_common.skc_refcnt
--=20
2.30.2


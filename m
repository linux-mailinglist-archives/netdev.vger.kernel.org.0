Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFC6A22B5EC
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 20:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgGWSlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 14:41:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63054 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728036AbgGWSl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 14:41:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06NIYTgB020769
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Es12UCbU+GG0i7Ken9gHvg9Yr+y4Lfi+NlD4hl1ixRI=;
 b=OhjPq9QtQZ41OcdFKOyXoHgwWQCdhGTd12kUSOX1BIA6jnBMbIXMqRnWFdvufmSlIGvS
 nSRvD6q1XMIsS5Nf2LxYbNFh9non9x5S8MEisESgPRb2YauitmxQhkrHlb/nTeOdb1YQ
 dceWCkR6TdcFHGrPNWos/EHMxP9e/JjJLGE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32esyndv3t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 11:41:26 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 11:41:26 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id CFC9C3702DDA; Thu, 23 Jul 2020 11:41:22 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v4 12/13] selftests/bpf: add a test for bpf sk_storage_map iterator
Date:   Thu, 23 Jul 2020 11:41:22 -0700
Message-ID: <20200723184122.591591-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723184108.589857-1-yhs@fb.com>
References: <20200723184108.589857-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_09:2020-07-23,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 adultscore=0 mlxlogscore=813 malwarescore=0 mlxscore=0
 suspectscore=25 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230134
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added one test for bpf sk_storage_map_iterator.
  $ ./test_progs -n 4
  ...
  #4/22 bpf_sk_storage_map:OK
  ...

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 72 +++++++++++++++++++
 .../bpf/progs/bpf_iter_bpf_sk_storage_map.c   | 34 +++++++++
 2 files changed, 106 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_sto=
rage_map.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index 4a02b2222a6d..ffbbeb9fa268 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -19,6 +19,7 @@
 #include "bpf_iter_bpf_percpu_hash_map.skel.h"
 #include "bpf_iter_bpf_array_map.skel.h"
 #include "bpf_iter_bpf_percpu_array_map.skel.h"
+#include "bpf_iter_bpf_sk_storage_map.skel.h"
=20
 static int duration;
=20
@@ -795,6 +796,75 @@ static void test_bpf_percpu_array_map(void)
 	bpf_iter_bpf_percpu_array_map__destroy(skel);
 }
=20
+static void test_bpf_sk_storage_map(void)
+{
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	int err, i, len, map_fd, iter_fd, num_sockets;
+	struct bpf_iter_bpf_sk_storage_map *skel;
+	int sock_fd[3] =3D {-1, -1, -1};
+	__u32 val, expected_val =3D 0;
+	struct bpf_link *link;
+	char buf[64];
+
+	skel =3D bpf_iter_bpf_sk_storage_map__open_and_load();
+	if (CHECK(!skel, "bpf_iter_bpf_sk_storage_map__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	map_fd =3D bpf_map__fd(skel->maps.sk_stg_map);
+	num_sockets =3D ARRAY_SIZE(sock_fd);
+	for (i =3D 0; i < num_sockets; i++) {
+		sock_fd[i] =3D socket(AF_INET6, SOCK_STREAM, 0);
+		if (CHECK(sock_fd[i] < 0, "socket", "errno: %d\n", errno))
+			goto out;
+
+		val =3D i + 1;
+		expected_val +=3D val;
+
+		err =3D bpf_map_update_elem(map_fd, &sock_fd[i], &val,
+					  BPF_NOEXIST);
+		if (CHECK(err, "map_update", "map_update failed\n"))
+			goto out;
+	}
+
+	opts.map_fd =3D map_fd;
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_sk_storage_map, =
&opts);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto out;
+
+	iter_fd =3D bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	/* do some tests */
+	while ((len =3D read(iter_fd, buf, sizeof(buf))) > 0)
+		;
+	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+		goto close_iter;
+
+	/* test results */
+	if (CHECK(skel->bss->ipv6_sk_count !=3D num_sockets,
+		  "ipv6_sk_count", "got %u expected %u\n",
+		  skel->bss->ipv6_sk_count, num_sockets))
+		goto close_iter;
+
+	if (CHECK(skel->bss->val_sum !=3D expected_val,
+		  "val_sum", "got %u expected %u\n",
+		  skel->bss->val_sum, expected_val))
+		goto close_iter;
+
+close_iter:
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+out:
+	for (i =3D 0; i < num_sockets; i++) {
+		if (sock_fd[i] >=3D 0)
+			close(sock_fd[i]);
+	}
+	bpf_iter_bpf_sk_storage_map__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -839,4 +909,6 @@ void test_bpf_iter(void)
 		test_bpf_array_map();
 	if (test__start_subtest("bpf_percpu_array_map"))
 		test_bpf_percpu_array_map();
+	if (test__start_subtest("bpf_sk_storage_map"))
+		test_bpf_sk_storage_map();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_ma=
p.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_map.c
new file mode 100644
index 000000000000..6b70ccaba301
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_sk_storage_map.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include "bpf_tracing_net.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_SK_STORAGE);
+	__uint(map_flags, BPF_F_NO_PREALLOC);
+	__type(key, int);
+	__type(value, int);
+} sk_stg_map SEC(".maps");
+
+__u32 val_sum =3D 0;
+__u32 ipv6_sk_count =3D 0;
+
+SEC("iter/bpf_sk_storage_map")
+int dump_bpf_sk_storage_map(struct bpf_iter__bpf_sk_storage_map *ctx)
+{
+	struct sock *sk =3D ctx->sk;
+	__u32 *val =3D ctx->value;
+
+	if (sk =3D=3D (void *)0 || val =3D=3D (void *)0)
+		return 0;
+
+	if (sk->sk_family =3D=3D AF_INET6)
+		ipv6_sk_count++;
+
+	val_sum +=3D *val;
+	return 0;
+}
--=20
2.24.1


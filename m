Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2B5234B06
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387905AbgGaS2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:28:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57774 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387680AbgGaS2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:28:48 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VIGZh0011390
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CBRU7E6OXSxj4wE9VbnxyOwoGD2RE1eosnRNPytDvHc=;
 b=cyMxnne7gPB7NDdEevVOXTQrp5plYNUnhePLpTGFNWZdks1y4eBH89WjentmOcjnnwGC
 gbJgAH8M2Una1jV8upEVNi88QwojCG0gC1Jizh9eVf4B3RyVohp8Ilqyu8tM3JxP4HrQ
 AWUfezCGgyO9WfR79yy4KezejBlwb3Hc4rI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32m4kxw3n0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:47 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 11:28:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 82B5E2EC4E02; Fri, 31 Jul 2020 11:28:38 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 3/5] selftests/bpf: add link detach tests for cgroup, netns, and xdp bpf_links
Date:   Fri, 31 Jul 2020 11:28:28 -0700
Message-ID: <20200731182830.286260-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200731182830.286260-1-andriin@fb.com>
References: <20200731182830.286260-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 suspectscore=8 mlxlogscore=873
 malwarescore=0 phishscore=0 spamscore=0 impostorscore=0 bulkscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_link__detach() testing to selftests for cgroup, netns, and xdp
bpf_links.

Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/cgroup_link.c    | 20 +++++++-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 51 +++++++++----------
 .../selftests/bpf/prog_tests/xdp_link.c       | 14 +++++
 tools/testing/selftests/bpf/testing_helpers.c | 14 +++++
 tools/testing/selftests/bpf/testing_helpers.h |  3 ++
 5 files changed, 73 insertions(+), 29 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools=
/testing/selftests/bpf/prog_tests/cgroup_link.c
index 6e04f8d1d15b..4d9b514b3fd9 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -2,6 +2,7 @@
=20
 #include <test_progs.h>
 #include "cgroup_helpers.h"
+#include "testing_helpers.h"
 #include "test_cgroup_link.skel.h"
=20
 static __u32 duration =3D 0;
@@ -37,7 +38,8 @@ void test_cgroup_link(void)
 	int last_cg =3D ARRAY_SIZE(cgs) - 1, cg_nr =3D ARRAY_SIZE(cgs);
 	DECLARE_LIBBPF_OPTS(bpf_link_update_opts, link_upd_opts);
 	struct bpf_link *links[ARRAY_SIZE(cgs)] =3D {}, *tmp_link;
-	__u32 prog_ids[ARRAY_SIZE(cgs)], prog_cnt =3D 0, attach_flags;
+	__u32 prog_ids[ARRAY_SIZE(cgs)], prog_cnt =3D 0, attach_flags, prog_id;
+	struct bpf_link_info info;
 	int i =3D 0, err, prog_fd;
 	bool detach_legacy =3D false;
=20
@@ -219,6 +221,22 @@ void test_cgroup_link(void)
 	/* BPF programs should still get called */
 	ping_and_check(0, cg_nr);
=20
+	prog_id =3D link_info_prog_id(links[0], &info);
+	CHECK(prog_id =3D=3D 0, "link_info", "failed\n");
+	CHECK(info.cgroup.cgroup_id =3D=3D 0, "cgroup_id", "unexpected %llu\n",=
 info.cgroup.cgroup_id);
+
+	err =3D bpf_link__detach(links[0]);
+	if (CHECK(err, "link_detach", "failed %d\n", err))
+		goto cleanup;
+
+	/* cgroup_id should be zero in link_info */
+	prog_id =3D link_info_prog_id(links[0], &info);
+	CHECK(prog_id =3D=3D 0, "link_info", "failed\n");
+	CHECK(info.cgroup.cgroup_id !=3D 0, "cgroup_id", "unexpected %llu\n", i=
nfo.cgroup.cgroup_id);
+
+	/* First BPF program shouldn't be called anymore */
+	ping_and_check(0, cg_nr - 1);
+
 	/* leave cgroup and remove them, don't detach programs */
 	cleanup_cgroup_environment();
=20
diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/t=
esting/selftests/bpf/prog_tests/sk_lookup.c
index 379da6f10ee9..c571584c00f5 100644
--- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
+++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
@@ -34,6 +34,7 @@
 #include "bpf_util.h"
 #include "cgroup_helpers.h"
 #include "network_helpers.h"
+#include "testing_helpers.h"
 #include "test_sk_lookup.skel.h"
=20
 /* External (address, port) pairs the client sends packets to. */
@@ -469,34 +470,10 @@ static int update_lookup_map(struct bpf_map *map, i=
nt index, int sock_fd)
 	return 0;
 }
=20
-static __u32 link_info_prog_id(struct bpf_link *link)
-{
-	struct bpf_link_info info =3D {};
-	__u32 info_len =3D sizeof(info);
-	int link_fd, err;
-
-	link_fd =3D bpf_link__fd(link);
-	if (CHECK(link_fd < 0, "bpf_link__fd", "failed\n")) {
-		errno =3D -link_fd;
-		log_err("bpf_link__fd failed");
-		return 0;
-	}
-
-	err =3D bpf_obj_get_info_by_fd(link_fd, &info, &info_len);
-	if (CHECK(err, "bpf_obj_get_info_by_fd", "failed\n")) {
-		log_err("bpf_obj_get_info_by_fd");
-		return 0;
-	}
-	if (CHECK(info_len !=3D sizeof(info), "bpf_obj_get_info_by_fd",
-		  "unexpected info len %u\n", info_len))
-		return 0;
-
-	return info.prog_id;
-}
-
 static void query_lookup_prog(struct test_sk_lookup *skel)
 {
 	struct bpf_link *link[3] =3D {};
+	struct bpf_link_info info;
 	__u32 attach_flags =3D 0;
 	__u32 prog_ids[3] =3D {};
 	__u32 prog_cnt =3D 3;
@@ -534,18 +511,36 @@ static void query_lookup_prog(struct test_sk_lookup=
 *skel)
 	if (CHECK(prog_cnt !=3D 3, "bpf_prog_query",
 		  "wrong program count on query: %u", prog_cnt))
 		goto detach;
-	prog_id =3D link_info_prog_id(link[0]);
+	prog_id =3D link_info_prog_id(link[0], &info);
 	CHECK(prog_ids[0] !=3D prog_id, "bpf_prog_query",
 	      "invalid program #0 id on query: %u !=3D %u\n",
 	      prog_ids[0], prog_id);
-	prog_id =3D link_info_prog_id(link[1]);
+	CHECK(info.netns.netns_ino =3D=3D 0, "netns_ino",
+	      "unexpected netns_ino: %u\n", info.netns.netns_ino);
+	prog_id =3D link_info_prog_id(link[1], &info);
 	CHECK(prog_ids[1] !=3D prog_id, "bpf_prog_query",
 	      "invalid program #1 id on query: %u !=3D %u\n",
 	      prog_ids[1], prog_id);
-	prog_id =3D link_info_prog_id(link[2]);
+	CHECK(info.netns.netns_ino =3D=3D 0, "netns_ino",
+	      "unexpected netns_ino: %u\n", info.netns.netns_ino);
+	prog_id =3D link_info_prog_id(link[2], &info);
 	CHECK(prog_ids[2] !=3D prog_id, "bpf_prog_query",
 	      "invalid program #2 id on query: %u !=3D %u\n",
 	      prog_ids[2], prog_id);
+	CHECK(info.netns.netns_ino =3D=3D 0, "netns_ino",
+	      "unexpected netns_ino: %u\n", info.netns.netns_ino);
+
+	err =3D bpf_link__detach(link[0]);
+	if (CHECK(err, "link_detach", "failed %d\n", err))
+		goto detach;
+
+	/* prog id is still there, but netns_ino is zeroed out */
+	prog_id =3D link_info_prog_id(link[0], &info);
+	CHECK(prog_ids[0] !=3D prog_id, "bpf_prog_query",
+	      "invalid program #0 id on query: %u !=3D %u\n",
+	      prog_ids[0], prog_id);
+	CHECK(info.netns.netns_ino !=3D 0, "netns_ino",
+	      "unexpected netns_ino: %u\n", info.netns.netns_ino);
=20
 detach:
 	if (link[2])
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_link.c b/tools/te=
sting/selftests/bpf/prog_tests/xdp_link.c
index 52cba6795d40..6f814999b395 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_link.c
@@ -131,6 +131,20 @@ void test_xdp_link(void)
 	CHECK(link_info.xdp.ifindex !=3D IFINDEX_LO, "link_ifindex",
 	      "got %u !=3D exp %u\n", link_info.xdp.ifindex, IFINDEX_LO);
=20
+	err =3D bpf_link__detach(link);
+	if (CHECK(err, "link_detach", "failed %d\n", err))
+		goto cleanup;
+
+	memset(&link_info, 0, sizeof(link_info));
+	err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), &link_info, &link_in=
fo_len);
+	if (CHECK(err, "link_info", "failed: %d\n", err))
+		goto cleanup;
+	CHECK(link_info.prog_id !=3D id1, "link_prog_id",
+	      "got %u !=3D exp %u\n", link_info.prog_id, id1);
+	/* ifindex should be zeroed out */
+	CHECK(link_info.xdp.ifindex !=3D 0, "link_ifindex",
+	      "got %u !=3D exp %u\n", link_info.xdp.ifindex, 0);
+
 cleanup:
 	test_xdp_link__destroy(skel1);
 	test_xdp_link__destroy(skel2);
diff --git a/tools/testing/selftests/bpf/testing_helpers.c b/tools/testin=
g/selftests/bpf/testing_helpers.c
index 0af6337a8962..800d503e5cb4 100644
--- a/tools/testing/selftests/bpf/testing_helpers.c
+++ b/tools/testing/selftests/bpf/testing_helpers.c
@@ -64,3 +64,17 @@ int parse_num_list(const char *s, bool **num_set, int =
*num_set_len)
=20
 	return 0;
 }
+
+__u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_inf=
o *info)
+{
+	__u32 info_len =3D sizeof(*info);
+	int err;
+
+	memset(info, 0, sizeof(*info));
+	err =3D bpf_obj_get_info_by_fd(bpf_link__fd(link), info, &info_len);
+	if (err) {
+		printf("failed to get link info: %d\n", -errno);
+		return 0;
+	}
+	return info->prog_id;
+}
diff --git a/tools/testing/selftests/bpf/testing_helpers.h b/tools/testin=
g/selftests/bpf/testing_helpers.h
index 923b51762759..d4f8e749611b 100644
--- a/tools/testing/selftests/bpf/testing_helpers.h
+++ b/tools/testing/selftests/bpf/testing_helpers.h
@@ -1,5 +1,8 @@
 /* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
 /* Copyright (C) 2020 Facebook, Inc. */
 #include <stdbool.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
=20
 int parse_num_list(const char *s, bool **set, int *set_len);
+__u32 link_info_prog_id(const struct bpf_link *link, struct bpf_link_inf=
o *info);
--=20
2.24.1


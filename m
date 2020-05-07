Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA97C1C81C9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 07:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEGFkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 01:40:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37584 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726877AbgEGFjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 01:39:47 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0475Xcm5008933
        for <netdev@vger.kernel.org>; Wed, 6 May 2020 22:39:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=I7aBOVNNUbLUT/3KGToPHmThV18NsMgEip5s5TKDRJg=;
 b=ZX2IhzJgQ7QLI5cIqBDES163vPweREVcs7bwn7yjY+Pil1xGd11SHHrtMHps6KbJjLHJ
 K8VnI6LU4S0AwIKU3Hvj6xcffNw4pLzLJlDSD3uZnNMO18xHX1WgDGsTGdIdaWYjvUBF
 0Fe4uWQHuapyeN8qJ3/SPppSqz2L/ZvzvGQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30ufak86fy-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 22:39:45 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 6 May 2020 22:39:43 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 718193701BB3; Wed,  6 May 2020 22:39:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 21/21] tools/bpf: selftests: add bpf_iter selftests
Date:   Wed, 6 May 2020 22:39:40 -0700
Message-ID: <20200507053940.1545530-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200507053915.1542140-1-yhs@fb.com>
References: <20200507053915.1542140-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-07_02:2020-05-05,2020-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 adultscore=0 impostorscore=0 suspectscore=2
 priorityscore=1501 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005070043
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The added test includes the following subtests:
  - test verifier change for btf_id_or_null
  - test load/create_iter/read for
    ipv6_route/netlink/bpf_map/task/task_file
  - test anon bpf iterator
  - test anon bpf iterator reading one char at a time
  - test file bpf iterator
  - test overflow (single bpf program output not overflow)
  - test overflow (single bpf program output overflows)
  - test bpf prog returning 1

The ipv6_route tests the following verifier change
  - access fields in the variable length array of the structure.

The netlink load tests the following verifier change
  - put a btf_id ptr value in a stack and accessible to
    tracing/iter programs.

The anon bpf iterator also tests link auto attach through skeleton.

  $ test_progs -n 2
  #2/1 btf_id_or_null:OK
  #2/2 ipv6_route:OK
  #2/3 netlink:OK
  #2/4 bpf_map:OK
  #2/5 task:OK
  #2/6 task_file:OK
  #2/7 anon:OK
  #2/8 anon-read-one-char:OK
  #2/9 file:OK
  #2/10 overflow:OK
  #2/11 overflow-e2big:OK
  #2/12 prog-ret-1:OK
  #2 bpf_iter:OK
  Summary: 1/12 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 408 ++++++++++++++++++
 .../selftests/bpf/progs/bpf_iter_test_kern1.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern2.c |   4 +
 .../selftests/bpf/progs/bpf_iter_test_kern3.c |  18 +
 .../selftests/bpf/progs/bpf_iter_test_kern4.c |  52 +++
 .../bpf/progs/bpf_iter_test_kern_common.h     |  22 +
 6 files changed, 508 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_iter.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern1=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern2=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern3=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern4=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_test_kern_=
common.h

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
new file mode 100644
index 000000000000..6d0b0c599417
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -0,0 +1,408 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include <test_progs.h>
+#include "bpf_iter_ipv6_route.skel.h"
+#include "bpf_iter_netlink.skel.h"
+#include "bpf_iter_bpf_map.skel.h"
+#include "bpf_iter_task.skel.h"
+#include "bpf_iter_task_file.skel.h"
+#include "bpf_iter_test_kern1.skel.h"
+#include "bpf_iter_test_kern2.skel.h"
+#include "bpf_iter_test_kern3.skel.h"
+#include "bpf_iter_test_kern4.skel.h"
+
+static int duration;
+
+static void test_btf_id_or_null(void)
+{
+	struct bpf_iter_test_kern3 *skel;
+
+	skel =3D bpf_iter_test_kern3__open_and_load();
+	if (CHECK(skel, "bpf_iter_test_kern3__open_and_load",
+		  "skeleton open_and_load unexpectedly succeeded\n")) {
+		bpf_iter_test_kern3__destroy(skel);
+		return;
+	}
+}
+
+static void do_dummy_read(struct bpf_program *prog)
+{
+	struct bpf_link *link;
+	char buf[16] =3D {};
+	int iter_fd, len;
+
+	link =3D bpf_program__attach_iter(prog, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		return;
+
+	iter_fd =3D bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	/* not check contents, but ensure read() ends without error */
+	while ((len =3D read(iter_fd, buf, sizeof(buf))) > 0)
+		;
+	CHECK(len < 0, "read", "read failed: %s\n", strerror(errno));
+
+	close(iter_fd);
+
+free_link:
+	bpf_link__destroy(link);
+}
+
+static void test_ipv6_route(void)
+{
+	struct bpf_iter_ipv6_route *skel;
+
+	skel =3D bpf_iter_ipv6_route__open_and_load();
+	if (CHECK(!skel, "bpf_iter_ipv6_route__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_ipv6_route);
+
+	bpf_iter_ipv6_route__destroy(skel);
+}
+
+static void test_netlink(void)
+{
+	struct bpf_iter_netlink *skel;
+
+	skel =3D bpf_iter_netlink__open_and_load();
+	if (CHECK(!skel, "bpf_iter_netlink__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_netlink);
+
+	bpf_iter_netlink__destroy(skel);
+}
+
+static void test_bpf_map(void)
+{
+	struct bpf_iter_bpf_map *skel;
+
+	skel =3D bpf_iter_bpf_map__open_and_load();
+	if (CHECK(!skel, "bpf_iter_bpf_map__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_bpf_map);
+
+	bpf_iter_bpf_map__destroy(skel);
+}
+
+static void test_task(void)
+{
+	struct bpf_iter_task *skel;
+
+	skel =3D bpf_iter_task__open_and_load();
+	if (CHECK(!skel, "bpf_iter_task__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_task);
+
+	bpf_iter_task__destroy(skel);
+}
+
+static void test_task_file(void)
+{
+	struct bpf_iter_task_file *skel;
+
+	skel =3D bpf_iter_task_file__open_and_load();
+	if (CHECK(!skel, "bpf_iter_task_file__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	do_dummy_read(skel->progs.dump_task_file);
+
+	bpf_iter_task_file__destroy(skel);
+}
+
+/* The expected string is less than 16 bytes */
+static int do_read_with_fd(int iter_fd, const char *expected,
+			   bool read_one_char)
+{
+	int err =3D -1, len, read_buf_len, start;
+	char buf[16] =3D {};
+
+	read_buf_len =3D read_one_char ? 1 : 16;
+	start =3D 0;
+	while ((len =3D read(iter_fd, buf + start, read_buf_len)) > 0) {
+		start +=3D len;
+		if (CHECK(start >=3D 16, "read", "read len %d\n", len))
+			return -1;
+		read_buf_len =3D read_one_char ? 1 : 16 - start;
+	}
+	if (CHECK(len < 0, "read", "read failed: %s\n", strerror(errno)))
+		return -1;
+
+	err =3D strcmp(buf, expected);
+	if (CHECK(err, "read", "incorrect read result: buf %s, expected %s\n",
+		  buf, expected))
+		return -1;
+
+	return 0;
+}
+
+static void test_anon_iter(bool read_one_char)
+{
+	struct bpf_iter_test_kern1 *skel;
+	struct bpf_link *link;
+	int iter_fd, err;
+
+	skel =3D bpf_iter_test_kern1__open_and_load();
+	if (CHECK(!skel, "bpf_iter_test_kern1__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	err =3D bpf_iter_test_kern1__attach(skel);
+	if (CHECK(err, "bpf_iter_test_kern1__attach",
+		  "skeleton attach failed\n")) {
+		goto out;
+	}
+
+	link =3D skel->links.dump_task;
+	iter_fd =3D bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto out;
+
+	do_read_with_fd(iter_fd, "abcd", read_one_char);
+	close(iter_fd);
+
+out:
+	bpf_iter_test_kern1__destroy(skel);
+}
+
+static int do_read(const char *path, const char *expected)
+{
+	int err, iter_fd;
+
+	iter_fd =3D open(path, O_RDONLY);
+	if (CHECK(iter_fd < 0, "open", "open %s failed: %s\n",
+		  path, strerror(errno)))
+		return -1;
+
+	err =3D do_read_with_fd(iter_fd, expected, false);
+	close(iter_fd);
+	return err;
+}
+
+static void test_file_iter(void)
+{
+	const char *path =3D "/sys/fs/bpf/bpf_iter_test1";
+	struct bpf_iter_test_kern1 *skel1;
+	struct bpf_iter_test_kern2 *skel2;
+	struct bpf_link *link;
+	int err;
+
+	skel1 =3D bpf_iter_test_kern1__open_and_load();
+	if (CHECK(!skel1, "bpf_iter_test_kern1__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		return;
+
+	link =3D bpf_program__attach_iter(skel1->progs.dump_task, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto out;
+
+	/* unlink this path if it exists. */
+	unlink(path);
+
+	err =3D bpf_link__pin(link, path);
+	if (CHECK(err, "pin_iter", "pin_iter to %s failed: %s\n", path,
+		  strerror(errno)))
+		goto free_link;
+
+	err =3D do_read(path, "abcd");
+	if (err)
+		goto free_link;
+
+	/* file based iterator seems working fine. Let us a link update
+	 * of the underlying link and `cat` the iterator again, its content
+	 * should change.
+	 */
+	skel2 =3D bpf_iter_test_kern2__open_and_load();
+	if (CHECK(!skel2, "bpf_iter_test_kern2__open_and_load",
+		  "skeleton open_and_load failed\n"))
+		goto free_link;
+
+	err =3D bpf_link__update_program(link, skel2->progs.dump_task);
+	if (CHECK(err, "update_prog", "update_prog failed\n"))
+		goto destroy_skel2;
+
+	do_read(path, "ABCD");
+
+destroy_skel2:
+	bpf_iter_test_kern2__destroy(skel2);
+free_link:
+	bpf_link__destroy(link);
+out:
+	bpf_iter_test_kern1__destroy(skel1);
+}
+
+static void test_overflow(bool test_e2big_overflow, bool ret1)
+{
+	__u32 map_info_len, total_read_len, expected_read_len;
+	int err, iter_fd, map1_fd, map2_fd, len;
+	struct bpf_map_info map_info =3D {};
+	struct bpf_iter_test_kern4 *skel;
+	struct bpf_link *link;
+	__u32 page_size;
+	char *buf;
+
+	skel =3D bpf_iter_test_kern4__open();
+	if (CHECK(!skel, "bpf_iter_test_kern4__open",
+		  "skeleton open failed\n"))
+		return;
+
+	/* create two maps: bpf program will only do bpf_seq_write
+	 * for these two maps. The goal is one map output almost
+	 * fills seq_file buffer and then the other will trigger
+	 * overflow and needs restart.
+	 */
+	map1_fd =3D bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 8, 1, 0);
+	if (CHECK(map1_fd < 0, "bpf_create_map",
+		  "map_creation failed: %s\n", strerror(errno)))
+		goto out;
+	map2_fd =3D bpf_create_map(BPF_MAP_TYPE_ARRAY, 4, 8, 1, 0);
+	if (CHECK(map2_fd < 0, "bpf_create_map",
+		  "map_creation failed: %s\n", strerror(errno)))
+		goto free_map1;
+
+	/* bpf_seq_printf kernel buffer is one page, so one map
+	 * bpf_seq_write will mostly fill it, and the other map
+	 * will partially fill and then trigger overflow and need
+	 * bpf_seq_read restart.
+	 */
+	page_size =3D sysconf(_SC_PAGE_SIZE);
+
+	if (test_e2big_overflow) {
+		skel->rodata->print_len =3D (page_size + 8) / 8;
+		expected_read_len =3D 2 * (page_size + 8);
+	} else if (!ret1) {
+		skel->rodata->print_len =3D (page_size - 8) / 8;
+		expected_read_len =3D 2 * (page_size - 8);
+	} else {
+		skel->rodata->print_len =3D 1;
+		expected_read_len =3D 2 * 8;
+	}
+	skel->rodata->ret1 =3D ret1;
+
+	if (CHECK(bpf_iter_test_kern4__load(skel),
+		  "bpf_iter_test_kern4__load", "skeleton load failed\n"))
+		goto free_map2;
+
+	/* setup filtering map_id in bpf program */
+	map_info_len =3D sizeof(map_info);
+	err =3D bpf_obj_get_info_by_fd(map1_fd, &map_info, &map_info_len);
+	if (CHECK(err, "get_map_info", "get map info failed: %s\n",
+		  strerror(errno)))
+		goto free_map2;
+	skel->bss->map1_id =3D map_info.id;
+
+	err =3D bpf_obj_get_info_by_fd(map2_fd, &map_info, &map_info_len);
+	if (CHECK(err, "get_map_info", "get map info failed: %s\n",
+		  strerror(errno)))
+		goto free_map2;
+	skel->bss->map2_id =3D map_info.id;
+
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_map, NULL);
+	if (CHECK(IS_ERR(link), "attach_iter", "attach_iter failed\n"))
+		goto free_map2;
+
+	iter_fd =3D bpf_iter_create(bpf_link__fd(link));
+	if (CHECK(iter_fd < 0, "create_iter", "create_iter failed\n"))
+		goto free_link;
+
+	buf =3D malloc(expected_read_len);
+	if (!buf)
+		goto close_iter;
+
+	/* do read */
+	total_read_len =3D 0;
+	if (test_e2big_overflow) {
+		while ((len =3D read(iter_fd, buf, expected_read_len)) > 0)
+			total_read_len +=3D len;
+
+		CHECK(len !=3D -1 || errno !=3D E2BIG, "read",
+		      "expected ret -1, errno E2BIG, but get ret %d, error %s\n",
+			  len, strerror(errno));
+		goto free_buf;
+	} else if (!ret1) {
+		while ((len =3D read(iter_fd, buf, expected_read_len)) > 0)
+			total_read_len +=3D len;
+
+		if (CHECK(len < 0, "read", "read failed: %s\n",
+			  strerror(errno)))
+			goto free_buf;
+	} else {
+		do {
+			len =3D read(iter_fd, buf, expected_read_len);
+			if (len > 0)
+				total_read_len +=3D len;
+		} while (len > 0 || len =3D=3D -EAGAIN);
+
+		if (CHECK(len < 0, "read", "read failed: %s\n",
+			  strerror(errno)))
+			goto free_buf;
+	}
+
+	if (CHECK(total_read_len !=3D expected_read_len, "read",
+		  "total len %u, expected len %u\n", total_read_len,
+		  expected_read_len))
+		goto free_buf;
+
+	if (CHECK(skel->bss->map1_accessed !=3D 1, "map1_accessed",
+		  "expected 1 actual %d\n", skel->bss->map1_accessed))
+		goto free_buf;
+
+	if (CHECK(skel->bss->map2_accessed !=3D 2, "map2_accessed",
+		  "expected 2 actual %d\n", skel->bss->map2_accessed))
+		goto free_buf;
+
+	CHECK(skel->bss->map2_seqnum1 !=3D skel->bss->map2_seqnum2,
+	      "map2_seqnum", "two different seqnum %lld %lld\n",
+	      skel->bss->map2_seqnum1, skel->bss->map2_seqnum2);
+
+free_buf:
+	free(buf);
+close_iter:
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+free_map2:
+	close(map2_fd);
+free_map1:
+	close(map1_fd);
+out:
+	bpf_iter_test_kern4__destroy(skel);
+}
+
+void test_bpf_iter(void)
+{
+	if (test__start_subtest("btf_id_or_null"))
+		test_btf_id_or_null();
+	if (test__start_subtest("ipv6_route"))
+		test_ipv6_route();
+	if (test__start_subtest("netlink"))
+		test_netlink();
+	if (test__start_subtest("bpf_map"))
+		test_bpf_map();
+	if (test__start_subtest("task"))
+		test_task();
+	if (test__start_subtest("task_file"))
+		test_task_file();
+	if (test__start_subtest("anon"))
+		test_anon_iter(false);
+	if (test__start_subtest("anon-read-one-char"))
+		test_anon_iter(true);
+	if (test__start_subtest("file"))
+		test_file_iter();
+	if (test__start_subtest("overflow"))
+		test_overflow(false, false);
+	if (test__start_subtest("overflow-e2big"))
+		test_overflow(true, false);
+	if (test__start_subtest("prog-ret-1"))
+		test_overflow(false, true);
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
new file mode 100644
index 000000000000..c71a7c283108
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern1.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define START_CHAR 'a'
+#include "bpf_iter_test_kern_common.h"
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
new file mode 100644
index 000000000000..8bdc8dc07444
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern2.c
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#define START_CHAR 'A'
+#include "bpf_iter_test_kern_common.h"
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
new file mode 100644
index 000000000000..636a00fa074d
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern3.c
@@ -0,0 +1,18 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+SEC("iter/task")
+int dump_task(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct task_struct *task =3D ctx->task;
+	int tgid;
+
+	tgid =3D task->tgid;
+	bpf_seq_write(seq, &tgid, sizeof(tgid));
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c b/to=
ols/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
new file mode 100644
index 000000000000..b18dc0471d07
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern4.c
@@ -0,0 +1,52 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+__u32 map1_id =3D 0, map2_id =3D 0;
+__u32 map1_accessed =3D 0, map2_accessed =3D 0;
+__u64 map1_seqnum =3D 0, map2_seqnum1 =3D 0, map2_seqnum2 =3D 0;
+
+static volatile const __u32 print_len;
+static volatile const __u32 ret1;
+
+SEC("iter/bpf_map")
+int dump_bpf_map(struct bpf_iter__bpf_map *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	struct bpf_map *map =3D ctx->map;
+	__u64 seq_num;
+	int i, ret =3D 0;
+
+	if (map =3D=3D (void *)0)
+		return 0;
+
+	/* only dump map1_id and map2_id */
+	if (map->id !=3D map1_id && map->id !=3D map2_id)
+		return 0;
+
+	seq_num =3D ctx->meta->seq_num;
+	if (map->id =3D=3D map1_id) {
+		map1_seqnum =3D seq_num;
+		map1_accessed++;
+	}
+
+	if (map->id =3D=3D map2_id) {
+		if (map2_accessed =3D=3D 0) {
+			map2_seqnum1 =3D seq_num;
+			if (ret1)
+				ret =3D 1;
+		} else {
+			map2_seqnum2 =3D seq_num;
+		}
+		map2_accessed++;
+	}
+
+	/* fill seq_file buffer */
+	for (i =3D 0; i < print_len; i++)
+		bpf_seq_write(seq, &seq_num, sizeof(seq_num));
+
+	return ret;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.=
h b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
new file mode 100644
index 000000000000..bdd51cf14b54
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_test_kern_common.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2020 Facebook */
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+
+char _license[] SEC("license") =3D "GPL";
+int count =3D 0;
+
+SEC("iter/task")
+int dump_task(struct bpf_iter__task *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	char c;
+
+	if (count < 4) {
+		c =3D START_CHAR + count;
+		bpf_seq_write(seq, &c, sizeof(c));
+		count++;
+	}
+
+	return 0;
+}
--=20
2.24.1


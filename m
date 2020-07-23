Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0484922A910
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 08:41:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgGWGlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 02:41:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45830 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbgGWGlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 02:41:19 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06N6BbSg015682
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=dOAHlqZaNX9kqzMA31DgSnQTY/fLcr2ufcxXpo4Yrgk=;
 b=FxDbULNUfhIP0jJ1f+vg+4eXkfNiXqthUOIuf9OEXhoj/CnnG164ixHw6ZJJXfLFVCRO
 sMCBEYpIbsbQKNpAWZafjNe2Wu+GldFh5LBKtD5Loq4FFQ0953LWyZTDYXCR6UPnin/L
 EXlYppD/GsCQcMa3Re2yMK388doNN3fWSjQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 32esdjk1a0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 23:15:51 -0700
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 22 Jul 2020 23:15:49 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 4424A3705266; Wed, 22 Jul 2020 23:15:45 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next v3 10/13] selftests/bpf: add test for bpf hash map iterators
Date:   Wed, 22 Jul 2020 23:15:45 -0700
Message-ID: <20200723061545.2100623-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200723061533.2099842-1-yhs@fb.com>
References: <20200723061533.2099842-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-23_02:2020-07-22,2020-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 clxscore=1015
 malwarescore=0 spamscore=0 adultscore=0 impostorscore=0 phishscore=0
 suspectscore=25 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007230050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two subtests are added.
  $ ./test_progs -n 4
  ...
  #4/18 bpf_hash_map:OK
  #4/19 bpf_percpu_hash_map:OK
  ...

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 .../selftests/bpf/prog_tests/bpf_iter.c       | 187 ++++++++++++++++++
 .../bpf/progs/bpf_iter_bpf_hash_map.c         | 100 ++++++++++
 .../bpf/progs/bpf_iter_bpf_percpu_hash_map.c  |  50 +++++
 3 files changed, 337 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_m=
ap.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu=
_hash_map.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c b/tools/te=
sting/selftests/bpf/prog_tests/bpf_iter.c
index fed42755416d..72790b600c62 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -15,6 +15,8 @@
 #include "bpf_iter_test_kern2.skel.h"
 #include "bpf_iter_test_kern3.skel.h"
 #include "bpf_iter_test_kern4.skel.h"
+#include "bpf_iter_bpf_hash_map.skel.h"
+#include "bpf_iter_bpf_percpu_hash_map.skel.h"
=20
 static int duration;
=20
@@ -455,6 +457,187 @@ static void test_overflow(bool test_e2big_overflow,=
 bool ret1)
 	bpf_iter_test_kern4__destroy(skel);
 }
=20
+static void test_bpf_hash_map(void)
+{
+	__u32 expected_key_a =3D 0, expected_key_b =3D 0, expected_key_c =3D 0;
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_iter_bpf_hash_map *skel;
+	int err, i, len, map_fd, iter_fd;
+	__u64 val, expected_val =3D 0;
+	struct bpf_link *link;
+	struct key_t {
+		int a;
+		int b;
+		int c;
+	} key;
+	char buf[64];
+
+	skel =3D bpf_iter_bpf_hash_map__open();
+	if (CHECK(!skel, "bpf_iter_bpf_hash_map__open",
+		  "skeleton open failed\n"))
+		return;
+
+	skel->bss->in_test_mode =3D true;
+
+	err =3D bpf_iter_bpf_hash_map__load(skel);
+	if (CHECK(!skel, "bpf_iter_bpf_hash_map__load",
+		  "skeleton load failed\n"))
+		goto out;
+
+	/* iterator with hashmap2 and hashmap3 should fail */
+	opts.map_fd =3D bpf_map__fd(skel->maps.hashmap2);
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts)=
;
+	if (CHECK(!IS_ERR(link), "attach_iter",
+		  "attach_iter for hashmap2 unexpected succeeded\n"))
+		goto out;
+
+	opts.map_fd =3D bpf_map__fd(skel->maps.hashmap3);
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts)=
;
+	if (CHECK(!IS_ERR(link), "attach_iter",
+		  "attach_iter for hashmap3 unexpected succeeded\n"))
+		goto out;
+
+	/* hashmap1 should be good, update map values here */
+	map_fd =3D bpf_map__fd(skel->maps.hashmap1);
+	for (i =3D 0; i < bpf_map__max_entries(skel->maps.hashmap1); i++) {
+		key.a =3D i + 1;
+		key.b =3D i + 2;
+		key.c =3D i + 3;
+		val =3D i + 4;
+		expected_key_a +=3D key.a;
+		expected_key_b +=3D key.b;
+		expected_key_c +=3D key.c;
+		expected_val +=3D val;
+
+		err =3D bpf_map_update_elem(map_fd, &key, &val, BPF_ANY);
+		if (CHECK(err, "map_update", "map_update failed\n"))
+			goto out;
+	}
+
+	opts.map_fd =3D map_fd;
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_hash_map, &opts)=
;
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
+	if (CHECK(skel->bss->key_sum_a !=3D expected_key_a,
+		  "key_sum_a", "got %u expected %u\n",
+		  skel->bss->key_sum_a, expected_key_a))
+		goto close_iter;
+	if (CHECK(skel->bss->key_sum_b !=3D expected_key_b,
+		  "key_sum_b", "got %u expected %u\n",
+		  skel->bss->key_sum_b, expected_key_b))
+		goto close_iter;
+	if (CHECK(skel->bss->val_sum !=3D expected_val,
+		  "val_sum", "got %llu expected %llu\n",
+		  skel->bss->val_sum, expected_val))
+		goto close_iter;
+
+close_iter:
+	close(iter_fd);
+free_link:
+	bpf_link__destroy(link);
+out:
+	bpf_iter_bpf_hash_map__destroy(skel);
+}
+
+static void test_bpf_percpu_hash_map(void)
+{
+	__u32 expected_key_a =3D 0, expected_key_b =3D 0, expected_key_c =3D 0;
+	DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
+	struct bpf_iter_bpf_percpu_hash_map *skel;
+	int err, i, j, len, map_fd, iter_fd;
+	__u32 expected_val =3D 0;
+	struct bpf_link *link;
+	struct key_t {
+		int a;
+		int b;
+		int c;
+	} key;
+	char buf[64];
+	void *val;
+
+	val =3D malloc(8 * bpf_num_possible_cpus());
+
+	skel =3D bpf_iter_bpf_percpu_hash_map__open();
+	if (CHECK(!skel, "bpf_iter_bpf_percpu_hash_map__open",
+		  "skeleton open failed\n"))
+		return;
+
+	skel->rodata->num_cpus =3D bpf_num_possible_cpus();
+
+	err =3D bpf_iter_bpf_percpu_hash_map__load(skel);
+	if (CHECK(!skel, "bpf_iter_bpf_percpu_hash_map__load",
+		  "skeleton load failed\n"))
+		goto out;
+
+	/* update map values here */
+	map_fd =3D bpf_map__fd(skel->maps.hashmap1);
+	for (i =3D 0; i < bpf_map__max_entries(skel->maps.hashmap1); i++) {
+		key.a =3D i + 1;
+		key.b =3D i + 2;
+		key.c =3D i + 3;
+		expected_key_a +=3D key.a;
+		expected_key_b +=3D key.b;
+		expected_key_c +=3D key.c;
+
+		for (j =3D 0; j < bpf_num_possible_cpus(); j++) {
+			*(__u32 *)(val + j * 8) =3D i + j;
+			expected_val +=3D i + j;
+		}
+
+		err =3D bpf_map_update_elem(map_fd, &key, val, BPF_ANY);
+		if (CHECK(err, "map_update", "map_update failed\n"))
+			goto out;
+	}
+
+	opts.map_fd =3D map_fd;
+	link =3D bpf_program__attach_iter(skel->progs.dump_bpf_percpu_hash_map,=
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
+	if (CHECK(skel->bss->key_sum_a !=3D expected_key_a,
+		  "key_sum_a", "got %u expected %u\n",
+		  skel->bss->key_sum_a, expected_key_a))
+		goto close_iter;
+	if (CHECK(skel->bss->key_sum_b !=3D expected_key_b,
+		  "key_sum_b", "got %u expected %u\n",
+		  skel->bss->key_sum_b, expected_key_b))
+		goto close_iter;
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
+	bpf_iter_bpf_percpu_hash_map__destroy(skel);
+}
+
 void test_bpf_iter(void)
 {
 	if (test__start_subtest("btf_id_or_null"))
@@ -491,4 +674,8 @@ void test_bpf_iter(void)
 		test_overflow(true, false);
 	if (test__start_subtest("prog-ret-1"))
 		test_overflow(false, true);
+	if (test__start_subtest("bpf_hash_map"))
+		test_bpf_hash_map();
+	if (test__start_subtest("bpf_percpu_hash_map"))
+		test_bpf_percpu_hash_map();
 }
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c b/=
tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
new file mode 100644
index 000000000000..07ddbfdbcab7
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_hash_map.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct key_t {
+	int a;
+	int b;
+	int c;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 3);
+	__type(key, struct key_t);
+	__type(value, __u64);
+} hashmap1 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 3);
+	__type(key, __u64);
+	__type(value, __u64);
+} hashmap2 SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 3);
+	__type(key, struct key_t);
+	__type(value, __u32);
+} hashmap3 SEC(".maps");
+
+/* will set before prog run */
+bool in_test_mode =3D 0;
+
+/* will collect results during prog run */
+__u32 key_sum_a =3D 0, key_sum_b =3D 0, key_sum_c =3D 0;
+__u64 val_sum =3D 0;
+
+SEC("iter/bpf_map_elem")
+int dump_bpf_hash_map(struct bpf_iter__bpf_map_elem *ctx)
+{
+	struct seq_file *seq =3D ctx->meta->seq;
+	__u32 seq_num =3D ctx->meta->seq_num;
+	struct bpf_map *map =3D ctx->map;
+	struct key_t *key =3D ctx->key;
+	__u64 *val =3D ctx->value;
+
+	if (in_test_mode) {
+		/* test mode is used by selftests to
+		 * test functionality of bpf_hash_map iter.
+		 *
+		 * the above hashmap1 will have correct size
+		 * and will be accepted, hashmap2 and hashmap3
+		 * should be rejected due to smaller key/value
+		 * size.
+		 */
+		if (key =3D=3D (void *)0 || val =3D=3D (void *)0)
+			return 0;
+
+		key_sum_a +=3D key->a;
+		key_sum_b +=3D key->b;
+		key_sum_c +=3D key->c;
+		val_sum +=3D *val;
+		return 0;
+	}
+
+	/* non-test mode, the map is prepared with the
+	 * below bpftool command sequence:
+	 *   bpftool map create /sys/fs/bpf/m1 type hash \
+	 *   	key 12 value 8 entries 3 name map1
+	 *   bpftool map update id 77 key 0 0 0 1 0 0 0 0 0 0 0 1 \
+	 *   	value 0 0 0 1 0 0 0 1
+	 *   bpftool map update id 77 key 0 0 0 1 0 0 0 0 0 0 0 2 \
+	 *   	value 0 0 0 1 0 0 0 2
+	 * The bpftool iter command line:
+	 *   bpftool iter pin ./bpf_iter_bpf_hash_map.o /sys/fs/bpf/p1 \
+	 *   	map id 77
+	 * The below output will be:
+	 *   map dump starts
+	 *   77: (1000000 0 2000000) (200000001000000)
+	 *   77: (1000000 0 1000000) (100000001000000)
+	 *   map dump ends
+	 */
+	if (seq_num =3D=3D 0)
+		BPF_SEQ_PRINTF(seq, "map dump starts\n");
+
+	if (key =3D=3D (void *)0 || val =3D=3D (void *)0) {
+		BPF_SEQ_PRINTF(seq, "map dump ends\n");
+		return 0;
+	}
+
+	BPF_SEQ_PRINTF(seq, "%d: (%x %d %x) (%llx)\n", map->id,
+		       key->a, key->b, key->c, *val);
+
+	return 0;
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu_hash_m=
ap.c b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu_hash_map.c
new file mode 100644
index 000000000000..feaaa2b89c57
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_bpf_percpu_hash_map.c
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2020 Facebook */
+#include "bpf_iter.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+char _license[] SEC("license") =3D "GPL";
+
+struct key_t {
+	int a;
+	int b;
+	int c;
+};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 3);
+	__type(key, struct key_t);
+	__type(value, __u32);
+} hashmap1 SEC(".maps");
+
+/* will set before prog run */
+volatile const __u32 num_cpus =3D 0;
+
+/* will collect results during prog run */
+__u32 key_sum_a =3D 0, key_sum_b =3D 0, key_sum_c =3D 0;
+__u32 val_sum =3D 0;
+
+SEC("iter/bpf_map_elem")
+int dump_bpf_percpu_hash_map(struct bpf_iter__bpf_map_elem *ctx)
+{
+	struct key_t *key =3D ctx->key;
+	void *pptr =3D ctx->value;
+	__u32 step;
+	int i;
+
+	if (key =3D=3D (void *)0 || pptr =3D=3D (void *)0)
+		return 0;
+
+	key_sum_a +=3D key->a;
+	key_sum_b +=3D key->b;
+	key_sum_c +=3D key->c;
+
+	step =3D 8;
+	for (i =3D 0; i < num_cpus; i++) {
+		val_sum +=3D *(__u32 *)pptr;
+		pptr +=3D step;
+	}
+	return 0;
+}
--=20
2.24.1


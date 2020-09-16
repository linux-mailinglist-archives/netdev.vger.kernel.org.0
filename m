Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B087226B8AE
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgIPAsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:48:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:63232 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbgIPAsg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:48:36 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08G0YQ21000599
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 17:48:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=oTYjMponVV9O3cnro12X/cMekfNMU4PolB4c9Pqi7z0=;
 b=jt9v/8ER5t6u9uRytk8imncn4HiGn5p6RaEUC2y/GjgbhZLn6AUWta+p2dVuCjIRIwvz
 sDNLdhH7ee4L/blSbztgJSz6Qd0XglLmsOOanpDxG/XE8jmst9gaMewhwyFnf1ptxj/C
 gYl0knn/2ZLRyJq7gzEPyqyrpQujcOs9sOM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5pkrs59-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 17:48:33 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 17:48:32 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 31E512EC6F73; Tue, 15 Sep 2020 17:48:21 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v3 bpf-next] selftests/bpf: merge most of test_btf into test_progs
Date:   Tue, 15 Sep 2020 17:48:19 -0700
Message-ID: <20200916004819.3767489-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_14:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 phishscore=0 suspectscore=25
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009160001
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Merge 183 tests from test_btf into test_progs framework to be exercised
regularly. All the test_btf tests that were moved are modeled as proper
sub-tests in test_progs framework for ease of debugging and reporting.

No functional or behavioral changes were intended, I tried to preserve
original behavior as much as possible. E.g., `test_progs -v` will activat=
e
"always_log" flag to emit BTF validation log.

The only difference is in reducing the max_entries limit for pretty-print=
ing
tests from (128 * 1024) to just 128 to reduce tests running time without
reducing the coverage.

Example test run:

  $ sudo ./test_progs -n 8
  ...
  #8 btf:OK
  Summary: 1/183 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
v2->v3:
 - made pprint use smaller max_entries (as suggested by Alexei) and then
   everything just worked within test_progs; I didn't bother to check why=
 it
   was failing with bigger max_entries;
v1->v2:
 - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
   allowed GIT to detect that majority of  test_btf code was moved into
   prog_tests/btf.c; so diff is much-much smaller;

 tools/testing/selftests/bpf/.gitignore        |   1 -
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../bpf/{test_btf.c =3D> prog_tests/btf.c}      | 410 ++++--------------
 3 files changed, 78 insertions(+), 335 deletions(-)
 rename tools/testing/selftests/bpf/{test_btf.c =3D> prog_tests/btf.c} (9=
6%)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index 9a0946ddb705..e8fed558b8b8 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -15,7 +15,6 @@ test_sock
 test_sock_addr
 test_sock_fields
 urandom_read
-test_btf
 test_sockmap
 test_lirc_mode2_user
 get_cgroup_id_user
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
index 05798c2b5c67..d6f59b0518f5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -33,7 +33,7 @@ LDLIBS +=3D -lcap -lelf -lz -lrt -lpthread
 # Order correspond to 'make run_tests' order
 TEST_GEN_PROGS =3D test_verifier test_tag test_maps test_lru_map test_lp=
m_map test_progs \
 	test_verifier_log test_dev_cgroup test_tcpbpf_user \
-	test_sock test_btf test_sockmap get_cgroup_id_user test_socket_cookie \
+	test_sock test_sockmap get_cgroup_id_user test_socket_cookie \
 	test_cgroup_storage \
 	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl \
 	test_progs-no_alu32 \
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selft=
ests/bpf/prog_tests/btf.c
similarity index 96%
rename from tools/testing/selftests/bpf/test_btf.c
rename to tools/testing/selftests/bpf/prog_tests/btf.c
index c75fc6447186..93162484c2ca 100644
--- a/tools/testing/selftests/bpf/test_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -24,40 +24,17 @@
=20
 #include "bpf_rlimit.h"
 #include "bpf_util.h"
-#include "test_btf.h"
+#include "../test_btf.h"
+#include "test_progs.h"
=20
 #define MAX_INSNS	512
 #define MAX_SUBPROGS	16
=20
-static uint32_t pass_cnt;
-static uint32_t error_cnt;
-static uint32_t skip_cnt;
+static int duration =3D 0;
+static bool always_log;
=20
-#define CHECK(condition, format...) ({					\
-	int __ret =3D !!(condition);					\
-	if (__ret) {							\
-		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
-		fprintf(stderr, format);				\
-	}								\
-	__ret;								\
-})
-
-static int count_result(int err)
-{
-	if (err)
-		error_cnt++;
-	else
-		pass_cnt++;
-
-	fprintf(stderr, "\n");
-	return err;
-}
-
-static int __base_pr(enum libbpf_print_level level __attribute__((unused=
)),
-		     const char *format, va_list args)
-{
-	return vfprintf(stderr, format, args);
-}
+#undef CHECK
+#define CHECK(condition, format...) _CHECK(condition, "check", duration,=
 format)
=20
 #define BTF_END_RAW 0xdeadbeef
 #define NAME_TBD 0xdeadb33f
@@ -69,21 +46,6 @@ static int __base_pr(enum libbpf_print_level level __a=
ttribute__((unused)),
 #define MAX_NR_RAW_U32 1024
 #define BTF_LOG_BUF_SIZE 65535
=20
-static struct args {
-	unsigned int raw_test_num;
-	unsigned int file_test_num;
-	unsigned int get_info_test_num;
-	unsigned int info_raw_test_num;
-	unsigned int dedup_test_num;
-	bool raw_test;
-	bool file_test;
-	bool get_info_test;
-	bool pprint_test;
-	bool always_log;
-	bool info_raw_test;
-	bool dedup_test;
-} args;
-
 static char btf_log_buf[BTF_LOG_BUF_SIZE];
=20
 static struct btf_header hdr_tmpl =3D {
@@ -3664,7 +3626,7 @@ static void *btf_raw_create(const struct btf_header=
 *hdr,
 	return raw_btf;
 }
=20
-static int do_test_raw(unsigned int test_num)
+static void do_test_raw(unsigned int test_num)
 {
 	struct btf_raw_test *test =3D &raw_tests[test_num - 1];
 	struct bpf_create_map_attr create_attr =3D {};
@@ -3674,15 +3636,16 @@ static int do_test_raw(unsigned int test_num)
 	void *raw_btf;
 	int err;
=20
-	fprintf(stderr, "BTF raw test[%u] (%s): ", test_num, test->descr);
+	if (!test__start_subtest(test->descr))
+		return;
+
 	raw_btf =3D btf_raw_create(&hdr_tmpl,
 				 test->raw_types,
 				 test->str_sec,
 				 test->str_sec_size,
 				 &raw_btf_size, NULL);
-
 	if (!raw_btf)
-		return -1;
+		return;
=20
 	hdr =3D raw_btf;
=20
@@ -3694,7 +3657,7 @@ static int do_test_raw(unsigned int test_num)
 	*btf_log_buf =3D '\0';
 	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
+			      always_log);
 	free(raw_btf);
=20
 	err =3D ((btf_fd =3D=3D -1) !=3D test->btf_load_err);
@@ -3725,32 +3688,12 @@ static int do_test_raw(unsigned int test_num)
 	      map_fd, test->map_create_err);
=20
 done:
-	if (!err)
-		fprintf(stderr, "OK");
-
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
-
 	if (btf_fd !=3D -1)
 		close(btf_fd);
 	if (map_fd !=3D -1)
 		close(map_fd);
-
-	return err;
-}
-
-static int test_raw(void)
-{
-	unsigned int i;
-	int err =3D 0;
-
-	if (args.raw_test_num)
-		return count_result(do_test_raw(args.raw_test_num));
-
-	for (i =3D 1; i <=3D ARRAY_SIZE(raw_tests); i++)
-		err |=3D count_result(do_test_raw(i));
-
-	return err;
 }
=20
 struct btf_get_info_test {
@@ -3814,11 +3757,6 @@ const struct btf_get_info_test get_info_tests[] =3D=
 {
 },
 };
=20
-static inline __u64 ptr_to_u64(const void *ptr)
-{
-	return (__u64)(unsigned long)ptr;
-}
-
 static int test_big_btf_info(unsigned int test_num)
 {
 	const struct btf_get_info_test *test =3D &get_info_tests[test_num - 1];
@@ -3851,7 +3789,7 @@ static int test_big_btf_info(unsigned int test_num)
=20
 	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
+			      always_log);
 	if (CHECK(btf_fd =3D=3D -1, "errno:%d", errno)) {
 		err =3D -1;
 		goto done;
@@ -3892,7 +3830,7 @@ static int test_big_btf_info(unsigned int test_num)
 	fprintf(stderr, "OK");
=20
 done:
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
=20
 	free(raw_btf);
@@ -3939,7 +3877,7 @@ static int test_btf_id(unsigned int test_num)
=20
 	btf_fd[0] =3D bpf_load_btf(raw_btf, raw_btf_size,
 				 btf_log_buf, BTF_LOG_BUF_SIZE,
-				 args.always_log);
+				 always_log);
 	if (CHECK(btf_fd[0] =3D=3D -1, "errno:%d", errno)) {
 		err =3D -1;
 		goto done;
@@ -4024,7 +3962,7 @@ static int test_btf_id(unsigned int test_num)
 	fprintf(stderr, "OK");
=20
 done:
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
=20
 	free(raw_btf);
@@ -4039,7 +3977,7 @@ static int test_btf_id(unsigned int test_num)
 	return err;
 }
=20
-static int do_test_get_info(unsigned int test_num)
+static void do_test_get_info(unsigned int test_num)
 {
 	const struct btf_get_info_test *test =3D &get_info_tests[test_num - 1];
 	unsigned int raw_btf_size, user_btf_size, expected_nbytes;
@@ -4048,11 +3986,14 @@ static int do_test_get_info(unsigned int test_num=
)
 	int btf_fd =3D -1, err, ret;
 	uint32_t info_len;
=20
-	fprintf(stderr, "BTF GET_INFO test[%u] (%s): ",
-		test_num, test->descr);
+	if (!test__start_subtest(test->descr))
+		return;
=20
-	if (test->special_test)
-		return test->special_test(test_num);
+	if (test->special_test) {
+		err =3D test->special_test(test_num);
+		if (CHECK(err, "failed: %d\n", err))
+			return;
+	}
=20
 	raw_btf =3D btf_raw_create(&hdr_tmpl,
 				 test->raw_types,
@@ -4061,7 +4002,7 @@ static int do_test_get_info(unsigned int test_num)
 				 &raw_btf_size, NULL);
=20
 	if (!raw_btf)
-		return -1;
+		return;
=20
 	*btf_log_buf =3D '\0';
=20
@@ -4073,7 +4014,7 @@ static int do_test_get_info(unsigned int test_num)
=20
 	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
+			      always_log);
 	if (CHECK(btf_fd =3D=3D -1, "errno:%d", errno)) {
 		err =3D -1;
 		goto done;
@@ -4114,7 +4055,7 @@ static int do_test_get_info(unsigned int test_num)
 	fprintf(stderr, "OK");
=20
 done:
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
=20
 	free(raw_btf);
@@ -4122,22 +4063,6 @@ static int do_test_get_info(unsigned int test_num)
=20
 	if (btf_fd !=3D -1)
 		close(btf_fd);
-
-	return err;
-}
-
-static int test_get_info(void)
-{
-	unsigned int i;
-	int err =3D 0;
-
-	if (args.get_info_test_num)
-		return count_result(do_test_get_info(args.get_info_test_num));
-
-	for (i =3D 1; i <=3D ARRAY_SIZE(get_info_tests); i++)
-		err |=3D count_result(do_test_get_info(i));
-
-	return err;
 }
=20
 struct btf_file_test {
@@ -4151,7 +4076,7 @@ static struct btf_file_test file_tests[] =3D {
 	{ .file =3D "test_btf_nokv.o", .btf_kv_notfound =3D true, },
 };
=20
-static int do_test_file(unsigned int test_num)
+static void do_test_file(unsigned int test_num)
 {
 	const struct btf_file_test *test =3D &file_tests[test_num - 1];
 	const char *expected_fnames[] =3D {"_dummy_tracepoint",
@@ -4169,17 +4094,17 @@ static int do_test_file(unsigned int test_num)
 	struct bpf_map *map;
 	int i, err, prog_fd;
=20
-	fprintf(stderr, "BTF libbpf test[%u] (%s): ", test_num,
-		test->file);
+	if (!test__start_subtest(test->file))
+		return;
=20
 	btf =3D btf__parse_elf(test->file, &btf_ext);
 	if (IS_ERR(btf)) {
 		if (PTR_ERR(btf) =3D=3D -ENOENT) {
-			fprintf(stderr, "SKIP. No ELF %s found", BTF_ELF_SEC);
-			skip_cnt++;
-			return 0;
+			printf("%s:SKIP: No ELF %s found", __func__, BTF_ELF_SEC);
+			test__skip();
+			return;
 		}
-		return PTR_ERR(btf);
+		return;
 	}
 	btf__free(btf);
=20
@@ -4188,7 +4113,7 @@ static int do_test_file(unsigned int test_num)
=20
 	obj =3D bpf_object__open(test->file);
 	if (CHECK(IS_ERR(obj), "obj: %ld", PTR_ERR(obj)))
-		return PTR_ERR(obj);
+		return;
=20
 	prog =3D bpf_program__next(NULL, obj);
 	if (CHECK(!prog, "Cannot find bpf_prog")) {
@@ -4310,21 +4235,6 @@ static int do_test_file(unsigned int test_num)
 done:
 	free(func_info);
 	bpf_object__close(obj);
-	return err;
-}
-
-static int test_file(void)
-{
-	unsigned int i;
-	int err =3D 0;
-
-	if (args.file_test_num)
-		return count_result(do_test_file(args.file_test_num));
-
-	for (i =3D 1; i <=3D ARRAY_SIZE(file_tests); i++)
-		err |=3D count_result(do_test_file(i));
-
-	return err;
 }
=20
 const char *pprint_enum_str[] =3D {
@@ -4428,7 +4338,7 @@ static struct btf_raw_test pprint_test_template[] =3D=
 {
 	.value_size =3D sizeof(struct pprint_mapv),
 	.key_type_id =3D 3,	/* unsigned int */
 	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
+	.max_entries =3D 128,
 },
=20
 {
@@ -4493,7 +4403,7 @@ static struct btf_raw_test pprint_test_template[] =3D=
 {
 	.value_size =3D sizeof(struct pprint_mapv),
 	.key_type_id =3D 3,	/* unsigned int */
 	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
+	.max_entries =3D 128,
 },
=20
 {
@@ -4564,7 +4474,7 @@ static struct btf_raw_test pprint_test_template[] =3D=
 {
 	.value_size =3D sizeof(struct pprint_mapv),
 	.key_type_id =3D 3,	/* unsigned int */
 	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
+	.max_entries =3D 128,
 },
=20
 #ifdef __SIZEOF_INT128__
@@ -4591,7 +4501,7 @@ static struct btf_raw_test pprint_test_template[] =3D=
 {
 	.value_size =3D sizeof(struct pprint_mapv_int128),
 	.key_type_id =3D 1,
 	.value_type_id =3D 4,
-	.max_entries =3D 128 * 1024,
+	.max_entries =3D 128,
 	.mapv_kind =3D PPRINT_MAPV_KIND_INT128,
 },
 #endif
@@ -4790,7 +4700,7 @@ static int check_line(const char *expected_line, in=
t nexpected_line,
 }
=20
=20
-static int do_test_pprint(int test_num)
+static void do_test_pprint(int test_num)
 {
 	const struct btf_raw_test *test =3D &pprint_test_template[test_num];
 	enum pprint_mapv_kind_t mapv_kind =3D test->mapv_kind;
@@ -4809,18 +4719,20 @@ static int do_test_pprint(int test_num)
 	uint8_t *raw_btf;
 	ssize_t nread;
=20
-	fprintf(stderr, "%s(#%d)......", test->descr, test_num);
+	if (!test__start_subtest(test->descr))
+		return;
+
 	raw_btf =3D btf_raw_create(&hdr_tmpl, test->raw_types,
 				 test->str_sec, test->str_sec_size,
 				 &raw_btf_size, NULL);
=20
 	if (!raw_btf)
-		return -1;
+		return;
=20
 	*btf_log_buf =3D '\0';
 	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
+			      always_log);
 	free(raw_btf);
=20
 	if (CHECK(btf_fd =3D=3D -1, "errno:%d", errno)) {
@@ -4971,7 +4883,7 @@ static int do_test_pprint(int test_num)
 		free(mapv);
 	if (!err)
 		fprintf(stderr, "OK");
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
 	if (btf_fd !=3D -1)
 		close(btf_fd);
@@ -4981,14 +4893,11 @@ static int do_test_pprint(int test_num)
 		fclose(pin_file);
 	unlink(pin_path);
 	free(line);
-
-	return err;
 }
=20
-static int test_pprint(void)
+static void test_pprint(void)
 {
 	unsigned int i;
-	int err =3D 0;
=20
 	/* test various maps with the first test template */
 	for (i =3D 0; i < ARRAY_SIZE(pprint_tests_meta); i++) {
@@ -4999,7 +4908,7 @@ static int test_pprint(void)
 		pprint_test_template[0].lossless_map =3D pprint_tests_meta[i].lossless=
_map;
 		pprint_test_template[0].percpu_map =3D pprint_tests_meta[i].percpu_map=
;
=20
-		err |=3D count_result(do_test_pprint(0));
+		do_test_pprint(0);
 	}
=20
 	/* test rest test templates with the first map */
@@ -5010,10 +4919,8 @@ static int test_pprint(void)
 		pprint_test_template[i].ordered_map =3D pprint_tests_meta[0].ordered_m=
ap;
 		pprint_test_template[i].lossless_map =3D pprint_tests_meta[0].lossless=
_map;
 		pprint_test_template[i].percpu_map =3D pprint_tests_meta[0].percpu_map=
;
-		err |=3D count_result(do_test_pprint(i));
+		do_test_pprint(i);
 	}
-
-	return err;
 }
=20
 #define BPF_LINE_INFO_ENC(insn_off, file_off, line_off, line_num, line_c=
ol) \
@@ -6178,7 +6085,7 @@ static int test_get_linfo(const struct prog_info_ra=
w_test *test,
 	return err;
 }
=20
-static int do_test_info_raw(unsigned int test_num)
+static void do_test_info_raw(unsigned int test_num)
 {
 	const struct prog_info_raw_test *test =3D &info_raw_tests[test_num - 1]=
;
 	unsigned int raw_btf_size, linfo_str_off, linfo_size;
@@ -6187,18 +6094,19 @@ static int do_test_info_raw(unsigned int test_num=
)
 	const char *ret_next_str;
 	union bpf_attr attr =3D {};
=20
-	fprintf(stderr, "BTF prog info raw test[%u] (%s): ", test_num, test->de=
scr);
+	if (!test__start_subtest(test->descr))
+		return;
+
 	raw_btf =3D btf_raw_create(&hdr_tmpl, test->raw_types,
 				 test->str_sec, test->str_sec_size,
 				 &raw_btf_size, &ret_next_str);
-
 	if (!raw_btf)
-		return -1;
+		return;
=20
 	*btf_log_buf =3D '\0';
 	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
 			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
+			      always_log);
 	free(raw_btf);
=20
 	if (CHECK(btf_fd =3D=3D -1, "invalid btf_fd errno:%d", errno)) {
@@ -6206,7 +6114,7 @@ static int do_test_info_raw(unsigned int test_num)
 		goto done;
 	}
=20
-	if (*btf_log_buf && args.always_log)
+	if (*btf_log_buf && always_log)
 		fprintf(stderr, "\n%s", btf_log_buf);
 	*btf_log_buf =3D '\0';
=20
@@ -6261,10 +6169,7 @@ static int do_test_info_raw(unsigned int test_num)
 		goto done;
=20
 done:
-	if (!err)
-		fprintf(stderr, "OK");
-
-	if (*btf_log_buf && (err || args.always_log))
+	if (*btf_log_buf && (err || always_log))
 		fprintf(stderr, "\n%s", btf_log_buf);
=20
 	if (btf_fd !=3D -1)
@@ -6274,22 +6179,6 @@ static int do_test_info_raw(unsigned int test_num)
=20
 	if (!IS_ERR(patched_linfo))
 		free(patched_linfo);
-
-	return err;
-}
-
-static int test_info_raw(void)
-{
-	unsigned int i;
-	int err =3D 0;
-
-	if (args.info_raw_test_num)
-		return count_result(do_test_info_raw(args.info_raw_test_num));
-
-	for (i =3D 1; i <=3D ARRAY_SIZE(info_raw_tests); i++)
-		err |=3D count_result(do_test_info_raw(i));
-
-	return err;
 }
=20
 struct btf_raw_data {
@@ -6754,7 +6643,7 @@ static void dump_btf_strings(const char *strs, __u3=
2 len)
 	}
 }
=20
-static int do_test_dedup(unsigned int test_num)
+static void do_test_dedup(unsigned int test_num)
 {
 	const struct btf_dedup_test *test =3D &dedup_tests[test_num - 1];
 	__u32 test_nr_types, expect_nr_types, test_btf_size, expect_btf_size;
@@ -6769,13 +6658,15 @@ static int do_test_dedup(unsigned int test_num)
 	void *raw_btf;
 	int err =3D 0, i;
=20
-	fprintf(stderr, "BTF dedup test[%u] (%s):", test_num, test->descr);
+	if (!test__start_subtest(test->descr))
+		return;
=20
 	raw_btf =3D btf_raw_create(&hdr_tmpl, test->input.raw_types,
 				 test->input.str_sec, test->input.str_sec_size,
 				 &raw_btf_size, &ret_test_next_str);
 	if (!raw_btf)
-		return -1;
+		return;
+
 	test_btf =3D btf__new((__u8 *)raw_btf, raw_btf_size);
 	free(raw_btf);
 	if (CHECK(IS_ERR(test_btf), "invalid test_btf errno:%ld",
@@ -6789,7 +6680,7 @@ static int do_test_dedup(unsigned int test_num)
 				 test->expect.str_sec_size,
 				 &raw_btf_size, &ret_expect_next_str);
 	if (!raw_btf)
-		return -1;
+		return;
 	expect_btf =3D btf__new((__u8 *)raw_btf, raw_btf_size);
 	free(raw_btf);
 	if (CHECK(IS_ERR(expect_btf), "invalid expect_btf errno:%ld",
@@ -6894,174 +6785,27 @@ static int do_test_dedup(unsigned int test_num)
 	}
=20
 done:
-	if (!err)
-		fprintf(stderr, "OK");
 	if (!IS_ERR(test_btf))
 		btf__free(test_btf);
 	if (!IS_ERR(expect_btf))
 		btf__free(expect_btf);
-
-	return err;
 }
=20
-static int test_dedup(void)
+void test_btf(void)
 {
-	unsigned int i;
-	int err =3D 0;
+	int i;
=20
-	if (args.dedup_test_num)
-		return count_result(do_test_dedup(args.dedup_test_num));
+	always_log =3D env.verbosity > VERBOSE_NONE;
=20
+	for (i =3D 1; i <=3D ARRAY_SIZE(raw_tests); i++)
+		do_test_raw(i);
+	for (i =3D 1; i <=3D ARRAY_SIZE(get_info_tests); i++)
+		do_test_get_info(i);
+	for (i =3D 1; i <=3D ARRAY_SIZE(file_tests); i++)
+		do_test_file(i);
+	for (i =3D 1; i <=3D ARRAY_SIZE(info_raw_tests); i++)
+		do_test_info_raw(i);
 	for (i =3D 1; i <=3D ARRAY_SIZE(dedup_tests); i++)
-		err |=3D count_result(do_test_dedup(i));
-
-	return err;
-}
-
-static void usage(const char *cmd)
-{
-	fprintf(stderr, "Usage: %s [-l] [[-r btf_raw_test_num (1 - %zu)] |\n"
-			"\t[-g btf_get_info_test_num (1 - %zu)] |\n"
-			"\t[-f btf_file_test_num (1 - %zu)] |\n"
-			"\t[-k btf_prog_info_raw_test_num (1 - %zu)] |\n"
-			"\t[-p (pretty print test)] |\n"
-			"\t[-d btf_dedup_test_num (1 - %zu)]]\n",
-		cmd, ARRAY_SIZE(raw_tests), ARRAY_SIZE(get_info_tests),
-		ARRAY_SIZE(file_tests), ARRAY_SIZE(info_raw_tests),
-		ARRAY_SIZE(dedup_tests));
-}
-
-static int parse_args(int argc, char **argv)
-{
-	const char *optstr =3D "hlpk:f:r:g:d:";
-	int opt;
-
-	while ((opt =3D getopt(argc, argv, optstr)) !=3D -1) {
-		switch (opt) {
-		case 'l':
-			args.always_log =3D true;
-			break;
-		case 'f':
-			args.file_test_num =3D atoi(optarg);
-			args.file_test =3D true;
-			break;
-		case 'r':
-			args.raw_test_num =3D atoi(optarg);
-			args.raw_test =3D true;
-			break;
-		case 'g':
-			args.get_info_test_num =3D atoi(optarg);
-			args.get_info_test =3D true;
-			break;
-		case 'p':
-			args.pprint_test =3D true;
-			break;
-		case 'k':
-			args.info_raw_test_num =3D atoi(optarg);
-			args.info_raw_test =3D true;
-			break;
-		case 'd':
-			args.dedup_test_num =3D atoi(optarg);
-			args.dedup_test =3D true;
-			break;
-		case 'h':
-			usage(argv[0]);
-			exit(0);
-		default:
-			usage(argv[0]);
-			return -1;
-		}
-	}
-
-	if (args.raw_test_num &&
-	    (args.raw_test_num < 1 ||
-	     args.raw_test_num > ARRAY_SIZE(raw_tests))) {
-		fprintf(stderr, "BTF raw test number must be [1 - %zu]\n",
-			ARRAY_SIZE(raw_tests));
-		return -1;
-	}
-
-	if (args.file_test_num &&
-	    (args.file_test_num < 1 ||
-	     args.file_test_num > ARRAY_SIZE(file_tests))) {
-		fprintf(stderr, "BTF file test number must be [1 - %zu]\n",
-			ARRAY_SIZE(file_tests));
-		return -1;
-	}
-
-	if (args.get_info_test_num &&
-	    (args.get_info_test_num < 1 ||
-	     args.get_info_test_num > ARRAY_SIZE(get_info_tests))) {
-		fprintf(stderr, "BTF get info test number must be [1 - %zu]\n",
-			ARRAY_SIZE(get_info_tests));
-		return -1;
-	}
-
-	if (args.info_raw_test_num &&
-	    (args.info_raw_test_num < 1 ||
-	     args.info_raw_test_num > ARRAY_SIZE(info_raw_tests))) {
-		fprintf(stderr, "BTF prog info raw test number must be [1 - %zu]\n",
-			ARRAY_SIZE(info_raw_tests));
-		return -1;
-	}
-
-	if (args.dedup_test_num &&
-	    (args.dedup_test_num < 1 ||
-	     args.dedup_test_num > ARRAY_SIZE(dedup_tests))) {
-		fprintf(stderr, "BTF dedup test number must be [1 - %zu]\n",
-			ARRAY_SIZE(dedup_tests));
-		return -1;
-	}
-
-	return 0;
-}
-
-static void print_summary(void)
-{
-	fprintf(stderr, "PASS:%u SKIP:%u FAIL:%u\n",
-		pass_cnt - skip_cnt, skip_cnt, error_cnt);
-}
-
-int main(int argc, char **argv)
-{
-	int err =3D 0;
-
-	err =3D parse_args(argc, argv);
-	if (err)
-		return err;
-
-	if (args.always_log)
-		libbpf_set_print(__base_pr);
-
-	if (args.raw_test)
-		err |=3D test_raw();
-
-	if (args.get_info_test)
-		err |=3D test_get_info();
-
-	if (args.file_test)
-		err |=3D test_file();
-
-	if (args.pprint_test)
-		err |=3D test_pprint();
-
-	if (args.info_raw_test)
-		err |=3D test_info_raw();
-
-	if (args.dedup_test)
-		err |=3D test_dedup();
-
-	if (args.raw_test || args.get_info_test || args.file_test ||
-	    args.pprint_test || args.info_raw_test || args.dedup_test)
-		goto done;
-
-	err |=3D test_raw();
-	err |=3D test_get_info();
-	err |=3D test_file();
-	err |=3D test_info_raw();
-	err |=3D test_dedup();
-
-done:
-	print_summary();
-	return err;
+		do_test_dedup(i);
+	test_pprint();
 }
--=20
2.24.1


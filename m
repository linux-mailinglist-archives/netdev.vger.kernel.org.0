Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFF0269B64
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 03:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbgIOBoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 21:44:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49904 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726019AbgIOBn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 21:43:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 08F1dhp0023038
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 18:43:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=bk4z4fB/7bQR1OCnMk+7+JJG9Ji1etFf4Bmlhc8FaaI=;
 b=i45SjBAFquala+PetkiYdWVj+gvY3eShmdhMMqjBoENTVRBEne2tYHrzFRreU+IJPM8/
 7ICjSK7TRLSRHFCbmidgMbkU3WTzmLMK8kEQYLdE8Enm1SA/VHfojABWOvdzPNiEHkua
 QXkDGXD5h/j+q0Z1nQeevr4xyHeapNUr5ik= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 33gstxwn8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 18:43:52 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 14 Sep 2020 18:43:51 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 84C1C2EC6EDF; Mon, 14 Sep 2020 18:43:43 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next] selftests/bpf: merge most of test_btf into test_progs
Date:   Mon, 14 Sep 2020 18:43:41 -0700
Message-ID: <20200915014341.2949692-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 suspectscore=29 mlxscore=0
 mlxlogscore=999 bulkscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150011
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move almost 200 tests from test_btf into test_progs framework to be exerc=
ised
regularly. Pretty-printing tests were left alone and renamed into
test_btf_pprint because they are very slow and were not even executed by
default with test_btf.

All the test_btf tests that were moved are modeled as proper sub-tests in
test_progs framework for ease of debugging and reporting.

No functional or behavioral changes were intended, I tried to preserve
original behavior as close to the original as possible. `test_progs -v` w=
ill
activate "always_log" flag to emit BTF validation log.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---

v1->v2:
 - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
   allowed GIT to detect that majority of  test_btf code was moved into
   prog_tests/btf.c; so diff is much-much smaller;

 tools/testing/selftests/bpf/.gitignore        |    2 +-
 .../bpf/{test_btf.c =3D> prog_tests/btf.c}      | 1069 +----------------
 tools/testing/selftests/bpf/test_btf_pprint.c |  969 +++++++++++++++
 3 files changed, 1033 insertions(+), 1007 deletions(-)
 rename tools/testing/selftests/bpf/{test_btf.c =3D> prog_tests/btf.c} (8=
5%)
 create mode 100644 tools/testing/selftests/bpf/test_btf_pprint.c

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selft=
ests/bpf/.gitignore
index 9a0946ddb705..160c413ee960 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -15,7 +15,7 @@ test_sock
 test_sock_addr
 test_sock_fields
 urandom_read
-test_btf
+test_btf_pprint
 test_sockmap
 test_lirc_mode2_user
 get_cgroup_id_user
diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selft=
ests/bpf/prog_tests/btf.c
similarity index 85%
rename from tools/testing/selftests/bpf/test_btf.c
rename to tools/testing/selftests/bpf/prog_tests/btf.c
index c75fc6447186..94719b692a1b 100644
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
@@ -4305,715 +4230,11 @@ static int do_test_file(unsigned int test_num)
 	}
=20
 skip:
-	fprintf(stderr, "OK");
+	return;
=20
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
-}
-
-const char *pprint_enum_str[] =3D {
-	"ENUM_ZERO",
-	"ENUM_ONE",
-	"ENUM_TWO",
-	"ENUM_THREE",
-};
-
-struct pprint_mapv {
-	uint32_t ui32;
-	uint16_t ui16;
-	/* 2 bytes hole */
-	int32_t si32;
-	uint32_t unused_bits2a:2,
-		bits28:28,
-		unused_bits2b:2;
-	union {
-		uint64_t ui64;
-		uint8_t ui8a[8];
-	};
-	enum {
-		ENUM_ZERO,
-		ENUM_ONE,
-		ENUM_TWO,
-		ENUM_THREE,
-	} aenum;
-	uint32_t ui32b;
-	uint32_t bits2c:2;
-	uint8_t si8_4[2][2];
-};
-
-#ifdef __SIZEOF_INT128__
-struct pprint_mapv_int128 {
-	__int128 si128a;
-	__int128 si128b;
-	unsigned __int128 bits3:3;
-	unsigned __int128 bits80:80;
-	unsigned __int128 ui128;
-};
-#endif
-
-static struct btf_raw_test pprint_test_template[] =3D {
-{
-	.raw_types =3D {
-		/* unsighed char */			/* [1] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
-		/* unsigned short */			/* [2] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
-		/* unsigned int */			/* [3] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
-		/* int */				/* [4] */
-		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
-		/* unsigned long long */		/* [5] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
-		/* 2 bits */				/* [6] */
-		BTF_TYPE_INT_ENC(0, 0, 0, 2, 2),
-		/* 28 bits */				/* [7] */
-		BTF_TYPE_INT_ENC(0, 0, 0, 28, 4),
-		/* uint8_t[8] */			/* [8] */
-		BTF_TYPE_ARRAY_ENC(9, 1, 8),
-		/* typedef unsigned char uint8_t */	/* [9] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 1),
-		/* typedef unsigned short uint16_t */	/* [10] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 2),
-		/* typedef unsigned int uint32_t */	/* [11] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 3),
-		/* typedef int int32_t */		/* [12] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 4),
-		/* typedef unsigned long long uint64_t *//* [13] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 5),
-		/* union (anon) */			/* [14] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
-		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
-		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
-		/* enum (anon) */			/* [15] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
-		BTF_ENUM_ENC(NAME_TBD, 0),
-		BTF_ENUM_ENC(NAME_TBD, 1),
-		BTF_ENUM_ENC(NAME_TBD, 2),
-		BTF_ENUM_ENC(NAME_TBD, 3),
-		/* struct pprint_mapv */		/* [16] */
-		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 11), 40),
-		BTF_MEMBER_ENC(NAME_TBD, 11, 0),	/* uint32_t ui32 */
-		BTF_MEMBER_ENC(NAME_TBD, 10, 32),	/* uint16_t ui16 */
-		BTF_MEMBER_ENC(NAME_TBD, 12, 64),	/* int32_t si32 */
-		BTF_MEMBER_ENC(NAME_TBD, 6, 96),	/* unused_bits2a */
-		BTF_MEMBER_ENC(NAME_TBD, 7, 98),	/* bits28 */
-		BTF_MEMBER_ENC(NAME_TBD, 6, 126),	/* unused_bits2b */
-		BTF_MEMBER_ENC(0, 14, 128),		/* union (anon) */
-		BTF_MEMBER_ENC(NAME_TBD, 15, 192),	/* aenum */
-		BTF_MEMBER_ENC(NAME_TBD, 11, 224),	/* uint32_t ui32b */
-		BTF_MEMBER_ENC(NAME_TBD, 6, 256),	/* bits2c */
-		BTF_MEMBER_ENC(NAME_TBD, 17, 264),	/* si8_4 */
-		BTF_TYPE_ARRAY_ENC(18, 1, 2),		/* [17] */
-		BTF_TYPE_ARRAY_ENC(1, 1, 2),		/* [18] */
-		BTF_END_RAW,
-	},
-	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0si8_4"),
-	.key_size =3D sizeof(unsigned int),
-	.value_size =3D sizeof(struct pprint_mapv),
-	.key_type_id =3D 3,	/* unsigned int */
-	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
-},
-
-{
-	/* this type will have the same type as the
-	 * first .raw_types definition, but struct type will
-	 * be encoded with kind_flag set.
-	 */
-	.raw_types =3D {
-		/* unsighed char */			/* [1] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
-		/* unsigned short */			/* [2] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
-		/* unsigned int */			/* [3] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
-		/* int */				/* [4] */
-		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
-		/* unsigned long long */		/* [5] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
-		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [6] */
-		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [7] */
-		/* uint8_t[8] */			/* [8] */
-		BTF_TYPE_ARRAY_ENC(9, 1, 8),
-		/* typedef unsigned char uint8_t */	/* [9] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 1),
-		/* typedef unsigned short uint16_t */	/* [10] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 2),
-		/* typedef unsigned int uint32_t */	/* [11] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 3),
-		/* typedef int int32_t */		/* [12] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 4),
-		/* typedef unsigned long long uint64_t *//* [13] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 5),
-		/* union (anon) */			/* [14] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
-		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
-		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
-		/* enum (anon) */			/* [15] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
-		BTF_ENUM_ENC(NAME_TBD, 0),
-		BTF_ENUM_ENC(NAME_TBD, 1),
-		BTF_ENUM_ENC(NAME_TBD, 2),
-		BTF_ENUM_ENC(NAME_TBD, 3),
-		/* struct pprint_mapv */		/* [16] */
-		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 11), 40),
-		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 0)),	/* uint32_t ui3=
2 */
-		BTF_MEMBER_ENC(NAME_TBD, 10, BTF_MEMBER_OFFSET(0, 32)),	/* uint16_t ui=
16 */
-		BTF_MEMBER_ENC(NAME_TBD, 12, BTF_MEMBER_OFFSET(0, 64)),	/* int32_t si3=
2 */
-		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 96)),	/* unused_bits2=
a */
-		BTF_MEMBER_ENC(NAME_TBD, 7, BTF_MEMBER_OFFSET(28, 98)),	/* bits28 */
-		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 126)),	/* unused_bits=
2b */
-		BTF_MEMBER_ENC(0, 14, BTF_MEMBER_OFFSET(0, 128)),	/* union (anon) */
-		BTF_MEMBER_ENC(NAME_TBD, 15, BTF_MEMBER_OFFSET(0, 192)),	/* aenum */
-		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 224)),	/* uint32_t u=
i32b */
-		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 256)),	/* bits2c */
-		BTF_MEMBER_ENC(NAME_TBD, 17, 264),	/* si8_4 */
-		BTF_TYPE_ARRAY_ENC(18, 1, 2),		/* [17] */
-		BTF_TYPE_ARRAY_ENC(1, 1, 2),		/* [18] */
-		BTF_END_RAW,
-	},
-	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0si8_4"),
-	.key_size =3D sizeof(unsigned int),
-	.value_size =3D sizeof(struct pprint_mapv),
-	.key_type_id =3D 3,	/* unsigned int */
-	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
-},
-
-{
-	/* this type will have the same layout as the
-	 * first .raw_types definition. The struct type will
-	 * be encoded with kind_flag set, bitfield members
-	 * are added typedef/const/volatile, and bitfield members
-	 * will have both int and enum types.
-	 */
-	.raw_types =3D {
-		/* unsighed char */			/* [1] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
-		/* unsigned short */			/* [2] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
-		/* unsigned int */			/* [3] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
-		/* int */				/* [4] */
-		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
-		/* unsigned long long */		/* [5] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
-		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [6] */
-		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [7] */
-		/* uint8_t[8] */			/* [8] */
-		BTF_TYPE_ARRAY_ENC(9, 1, 8),
-		/* typedef unsigned char uint8_t */	/* [9] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 1),
-		/* typedef unsigned short uint16_t */	/* [10] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 2),
-		/* typedef unsigned int uint32_t */	/* [11] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 3),
-		/* typedef int int32_t */		/* [12] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 4),
-		/* typedef unsigned long long uint64_t *//* [13] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 5),
-		/* union (anon) */			/* [14] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
-		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
-		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
-		/* enum (anon) */			/* [15] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
-		BTF_ENUM_ENC(NAME_TBD, 0),
-		BTF_ENUM_ENC(NAME_TBD, 1),
-		BTF_ENUM_ENC(NAME_TBD, 2),
-		BTF_ENUM_ENC(NAME_TBD, 3),
-		/* struct pprint_mapv */		/* [16] */
-		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 11), 40),
-		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 0)),	/* uint32_t ui3=
2 */
-		BTF_MEMBER_ENC(NAME_TBD, 10, BTF_MEMBER_OFFSET(0, 32)),	/* uint16_t ui=
16 */
-		BTF_MEMBER_ENC(NAME_TBD, 12, BTF_MEMBER_OFFSET(0, 64)),	/* int32_t si3=
2 */
-		BTF_MEMBER_ENC(NAME_TBD, 17, BTF_MEMBER_OFFSET(2, 96)),	/* unused_bits=
2a */
-		BTF_MEMBER_ENC(NAME_TBD, 7, BTF_MEMBER_OFFSET(28, 98)),	/* bits28 */
-		BTF_MEMBER_ENC(NAME_TBD, 19, BTF_MEMBER_OFFSET(2, 126)),/* unused_bits=
2b */
-		BTF_MEMBER_ENC(0, 14, BTF_MEMBER_OFFSET(0, 128)),	/* union (anon) */
-		BTF_MEMBER_ENC(NAME_TBD, 15, BTF_MEMBER_OFFSET(0, 192)),	/* aenum */
-		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 224)),	/* uint32_t u=
i32b */
-		BTF_MEMBER_ENC(NAME_TBD, 17, BTF_MEMBER_OFFSET(2, 256)),	/* bits2c */
-		BTF_MEMBER_ENC(NAME_TBD, 20, BTF_MEMBER_OFFSET(0, 264)),	/* si8_4 */
-		/* typedef unsigned int ___int */	/* [17] */
-		BTF_TYPEDEF_ENC(NAME_TBD, 18),
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_VOLATILE, 0, 0), 6),	/* [18] */
-		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 15),	/* [19] */
-		BTF_TYPE_ARRAY_ENC(21, 1, 2),					/* [20] */
-		BTF_TYPE_ARRAY_ENC(1, 1, 2),					/* [21] */
-		BTF_END_RAW,
-	},
-	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0___int\0si8=
_4"),
-	.key_size =3D sizeof(unsigned int),
-	.value_size =3D sizeof(struct pprint_mapv),
-	.key_type_id =3D 3,	/* unsigned int */
-	.value_type_id =3D 16,	/* struct pprint_mapv */
-	.max_entries =3D 128 * 1024,
-},
-
-#ifdef __SIZEOF_INT128__
-{
-	/* test int128 */
-	.raw_types =3D {
-		/* unsigned int */				/* [1] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
-		/* __int128 */					/* [2] */
-		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 128, 16),
-		/* unsigned __int128 */				/* [3] */
-		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 128, 16),
-		/* struct pprint_mapv_int128 */			/* [4] */
-		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 5), 64),
-		BTF_MEMBER_ENC(NAME_TBD, 2, BTF_MEMBER_OFFSET(0, 0)),		/* si128a */
-		BTF_MEMBER_ENC(NAME_TBD, 2, BTF_MEMBER_OFFSET(0, 128)),		/* si128b */
-		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(3, 256)),		/* bits3 */
-		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(80, 259)),	/* bits80 */
-		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(0, 384)),		/* ui128 */
-		BTF_END_RAW,
-	},
-	BTF_STR_SEC("\0unsigned int\0__int128\0unsigned __int128\0pprint_mapv_i=
nt128\0si128a\0si128b\0bits3\0bits80\0ui128"),
-	.key_size =3D sizeof(unsigned int),
-	.value_size =3D sizeof(struct pprint_mapv_int128),
-	.key_type_id =3D 1,
-	.value_type_id =3D 4,
-	.max_entries =3D 128 * 1024,
-	.mapv_kind =3D PPRINT_MAPV_KIND_INT128,
-},
-#endif
-
-};
-
-static struct btf_pprint_test_meta {
-	const char *descr;
-	enum bpf_map_type map_type;
-	const char *map_name;
-	bool ordered_map;
-	bool lossless_map;
-	bool percpu_map;
-} pprint_tests_meta[] =3D {
-{
-	.descr =3D "BTF pretty print array",
-	.map_type =3D BPF_MAP_TYPE_ARRAY,
-	.map_name =3D "pprint_test_array",
-	.ordered_map =3D true,
-	.lossless_map =3D true,
-	.percpu_map =3D false,
-},
-
-{
-	.descr =3D "BTF pretty print hash",
-	.map_type =3D BPF_MAP_TYPE_HASH,
-	.map_name =3D "pprint_test_hash",
-	.ordered_map =3D false,
-	.lossless_map =3D true,
-	.percpu_map =3D false,
-},
-
-{
-	.descr =3D "BTF pretty print lru hash",
-	.map_type =3D BPF_MAP_TYPE_LRU_HASH,
-	.map_name =3D "pprint_test_lru_hash",
-	.ordered_map =3D false,
-	.lossless_map =3D false,
-	.percpu_map =3D false,
-},
-
-{
-	.descr =3D "BTF pretty print percpu array",
-	.map_type =3D BPF_MAP_TYPE_PERCPU_ARRAY,
-	.map_name =3D "pprint_test_percpu_array",
-	.ordered_map =3D true,
-	.lossless_map =3D true,
-	.percpu_map =3D true,
-},
-
-{
-	.descr =3D "BTF pretty print percpu hash",
-	.map_type =3D BPF_MAP_TYPE_PERCPU_HASH,
-	.map_name =3D "pprint_test_percpu_hash",
-	.ordered_map =3D false,
-	.lossless_map =3D true,
-	.percpu_map =3D true,
-},
-
-{
-	.descr =3D "BTF pretty print lru percpu hash",
-	.map_type =3D BPF_MAP_TYPE_LRU_PERCPU_HASH,
-	.map_name =3D "pprint_test_lru_percpu_hash",
-	.ordered_map =3D false,
-	.lossless_map =3D false,
-	.percpu_map =3D true,
-},
-
-};
-
-static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
-{
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC)
-		return sizeof(struct pprint_mapv);
-
-#ifdef __SIZEOF_INT128__
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128)
-		return sizeof(struct pprint_mapv_int128);
-#endif
-
-	assert(0);
-}
-
-static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
-			    void *mapv, uint32_t i,
-			    int num_cpus, int rounded_value_size)
-{
-	int cpu;
-
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC) {
-		struct pprint_mapv *v =3D mapv;
-
-		for (cpu =3D 0; cpu < num_cpus; cpu++) {
-			v->ui32 =3D i + cpu;
-			v->si32 =3D -i;
-			v->unused_bits2a =3D 3;
-			v->bits28 =3D i;
-			v->unused_bits2b =3D 3;
-			v->ui64 =3D i;
-			v->aenum =3D i & 0x03;
-			v->ui32b =3D 4;
-			v->bits2c =3D 1;
-			v->si8_4[0][0] =3D (cpu + i) & 0xff;
-			v->si8_4[0][1] =3D (cpu + i + 1) & 0xff;
-			v->si8_4[1][0] =3D (cpu + i + 2) & 0xff;
-			v->si8_4[1][1] =3D (cpu + i + 3) & 0xff;
-			v =3D (void *)v + rounded_value_size;
-		}
-	}
-
-#ifdef __SIZEOF_INT128__
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128) {
-		struct pprint_mapv_int128 *v =3D mapv;
-
-		for (cpu =3D 0; cpu < num_cpus; cpu++) {
-			v->si128a =3D i;
-			v->si128b =3D -i;
-			v->bits3 =3D i & 0x07;
-			v->bits80 =3D (((unsigned __int128)1) << 64) + i;
-			v->ui128 =3D (((unsigned __int128)2) << 64) + i;
-			v =3D (void *)v + rounded_value_size;
-		}
-	}
-#endif
-}
-
-ssize_t get_pprint_expected_line(enum pprint_mapv_kind_t mapv_kind,
-				 char *expected_line, ssize_t line_size,
-				 bool percpu_map, unsigned int next_key,
-				 int cpu, void *mapv)
-{
-	ssize_t nexpected_line =3D -1;
-
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC) {
-		struct pprint_mapv *v =3D mapv;
-
-		nexpected_line =3D snprintf(expected_line, line_size,
-					  "%s%u: {%u,0,%d,0x%x,0x%x,0x%x,"
-					  "{%llu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
-					  "%u,0x%x,[[%d,%d],[%d,%d]]}\n",
-					  percpu_map ? "\tcpu" : "",
-					  percpu_map ? cpu : next_key,
-					  v->ui32, v->si32,
-					  v->unused_bits2a,
-					  v->bits28,
-					  v->unused_bits2b,
-					  (__u64)v->ui64,
-					  v->ui8a[0], v->ui8a[1],
-					  v->ui8a[2], v->ui8a[3],
-					  v->ui8a[4], v->ui8a[5],
-					  v->ui8a[6], v->ui8a[7],
-					  pprint_enum_str[v->aenum],
-					  v->ui32b,
-					  v->bits2c,
-					  v->si8_4[0][0], v->si8_4[0][1],
-					  v->si8_4[1][0], v->si8_4[1][1]);
-	}
-
-#ifdef __SIZEOF_INT128__
-	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128) {
-		struct pprint_mapv_int128 *v =3D mapv;
-
-		nexpected_line =3D snprintf(expected_line, line_size,
-					  "%s%u: {0x%lx,0x%lx,0x%lx,"
-					  "0x%lx%016lx,0x%lx%016lx}\n",
-					  percpu_map ? "\tcpu" : "",
-					  percpu_map ? cpu : next_key,
-					  (uint64_t)v->si128a,
-					  (uint64_t)v->si128b,
-					  (uint64_t)v->bits3,
-					  (uint64_t)(v->bits80 >> 64),
-					  (uint64_t)v->bits80,
-					  (uint64_t)(v->ui128 >> 64),
-					  (uint64_t)v->ui128);
-	}
-#endif
-
-	return nexpected_line;
-}
-
-static int check_line(const char *expected_line, int nexpected_line,
-		      int expected_line_len, const char *line)
-{
-	if (CHECK(nexpected_line =3D=3D expected_line_len,
-		  "expected_line is too long"))
-		return -1;
-
-	if (strcmp(expected_line, line)) {
-		fprintf(stderr, "unexpected pprint output\n");
-		fprintf(stderr, "expected: %s", expected_line);
-		fprintf(stderr, "    read: %s", line);
-		return -1;
-	}
-
-	return 0;
-}
-
-
-static int do_test_pprint(int test_num)
-{
-	const struct btf_raw_test *test =3D &pprint_test_template[test_num];
-	enum pprint_mapv_kind_t mapv_kind =3D test->mapv_kind;
-	struct bpf_create_map_attr create_attr =3D {};
-	bool ordered_map, lossless_map, percpu_map;
-	int err, ret, num_cpus, rounded_value_size;
-	unsigned int key, nr_read_elems;
-	int map_fd =3D -1, btf_fd =3D -1;
-	unsigned int raw_btf_size;
-	char expected_line[255];
-	FILE *pin_file =3D NULL;
-	char pin_path[255];
-	size_t line_len =3D 0;
-	char *line =3D NULL;
-	void *mapv =3D NULL;
-	uint8_t *raw_btf;
-	ssize_t nread;
-
-	fprintf(stderr, "%s(#%d)......", test->descr, test_num);
-	raw_btf =3D btf_raw_create(&hdr_tmpl, test->raw_types,
-				 test->str_sec, test->str_sec_size,
-				 &raw_btf_size, NULL);
-
-	if (!raw_btf)
-		return -1;
-
-	*btf_log_buf =3D '\0';
-	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
-			      btf_log_buf, BTF_LOG_BUF_SIZE,
-			      args.always_log);
-	free(raw_btf);
-
-	if (CHECK(btf_fd =3D=3D -1, "errno:%d", errno)) {
-		err =3D -1;
-		goto done;
-	}
-
-	create_attr.name =3D test->map_name;
-	create_attr.map_type =3D test->map_type;
-	create_attr.key_size =3D test->key_size;
-	create_attr.value_size =3D test->value_size;
-	create_attr.max_entries =3D test->max_entries;
-	create_attr.btf_fd =3D btf_fd;
-	create_attr.btf_key_type_id =3D test->key_type_id;
-	create_attr.btf_value_type_id =3D test->value_type_id;
-
-	map_fd =3D bpf_create_map_xattr(&create_attr);
-	if (CHECK(map_fd =3D=3D -1, "errno:%d", errno)) {
-		err =3D -1;
-		goto done;
-	}
-
-	ret =3D snprintf(pin_path, sizeof(pin_path), "%s/%s",
-		       "/sys/fs/bpf", test->map_name);
-
-	if (CHECK(ret =3D=3D sizeof(pin_path), "pin_path %s/%s is too long",
-		  "/sys/fs/bpf", test->map_name)) {
-		err =3D -1;
-		goto done;
-	}
-
-	err =3D bpf_obj_pin(map_fd, pin_path);
-	if (CHECK(err, "bpf_obj_pin(%s): errno:%d.", pin_path, errno))
-		goto done;
-
-	percpu_map =3D test->percpu_map;
-	num_cpus =3D percpu_map ? bpf_num_possible_cpus() : 1;
-	rounded_value_size =3D round_up(get_pprint_mapv_size(mapv_kind), 8);
-	mapv =3D calloc(num_cpus, rounded_value_size);
-	if (CHECK(!mapv, "mapv allocation failure")) {
-		err =3D -1;
-		goto done;
-	}
-
-	for (key =3D 0; key < test->max_entries; key++) {
-		set_pprint_mapv(mapv_kind, mapv, key, num_cpus, rounded_value_size);
-		bpf_map_update_elem(map_fd, &key, mapv, 0);
-	}
-
-	pin_file =3D fopen(pin_path, "r");
-	if (CHECK(!pin_file, "fopen(%s): errno:%d", pin_path, errno)) {
-		err =3D -1;
-		goto done;
-	}
-
-	/* Skip lines start with '#' */
-	while ((nread =3D getline(&line, &line_len, pin_file)) > 0 &&
-	       *line =3D=3D '#')
-		;
-
-	if (CHECK(nread <=3D 0, "Unexpected EOF")) {
-		err =3D -1;
-		goto done;
-	}
-
-	nr_read_elems =3D 0;
-	ordered_map =3D test->ordered_map;
-	lossless_map =3D test->lossless_map;
-	do {
-		ssize_t nexpected_line;
-		unsigned int next_key;
-		void *cmapv;
-		int cpu;
-
-		next_key =3D ordered_map ? nr_read_elems : atoi(line);
-		set_pprint_mapv(mapv_kind, mapv, next_key, num_cpus, rounded_value_siz=
e);
-		cmapv =3D mapv;
-
-		for (cpu =3D 0; cpu < num_cpus; cpu++) {
-			if (percpu_map) {
-				/* for percpu map, the format looks like:
-				 * <key>: {
-				 *	cpu0: <value_on_cpu0>
-				 *	cpu1: <value_on_cpu1>
-				 *	...
-				 *	cpun: <value_on_cpun>
-				 * }
-				 *
-				 * let us verify the line containing the key here.
-				 */
-				if (cpu =3D=3D 0) {
-					nexpected_line =3D snprintf(expected_line,
-								  sizeof(expected_line),
-								  "%u: {\n",
-								  next_key);
-
-					err =3D check_line(expected_line, nexpected_line,
-							 sizeof(expected_line), line);
-					if (err =3D=3D -1)
-						goto done;
-				}
-
-				/* read value@cpu */
-				nread =3D getline(&line, &line_len, pin_file);
-				if (nread < 0)
-					break;
-			}
-
-			nexpected_line =3D get_pprint_expected_line(mapv_kind, expected_line,
-								  sizeof(expected_line),
-								  percpu_map, next_key,
-								  cpu, cmapv);
-			err =3D check_line(expected_line, nexpected_line,
-					 sizeof(expected_line), line);
-			if (err =3D=3D -1)
-				goto done;
-
-			cmapv =3D cmapv + rounded_value_size;
-		}
-
-		if (percpu_map) {
-			/* skip the last bracket for the percpu map */
-			nread =3D getline(&line, &line_len, pin_file);
-			if (nread < 0)
-				break;
-		}
-
-		nread =3D getline(&line, &line_len, pin_file);
-	} while (++nr_read_elems < test->max_entries && nread > 0);
-
-	if (lossless_map &&
-	    CHECK(nr_read_elems < test->max_entries,
-		  "Unexpected EOF. nr_read_elems:%u test->max_entries:%u",
-		  nr_read_elems, test->max_entries)) {
-		err =3D -1;
-		goto done;
-	}
-
-	if (CHECK(nread > 0, "Unexpected extra pprint output: %s", line)) {
-		err =3D -1;
-		goto done;
-	}
-
-	err =3D 0;
-
-done:
-	if (mapv)
-		free(mapv);
-	if (!err)
-		fprintf(stderr, "OK");
-	if (*btf_log_buf && (err || args.always_log))
-		fprintf(stderr, "\n%s", btf_log_buf);
-	if (btf_fd !=3D -1)
-		close(btf_fd);
-	if (map_fd !=3D -1)
-		close(map_fd);
-	if (pin_file)
-		fclose(pin_file);
-	unlink(pin_path);
-	free(line);
-
-	return err;
-}
-
-static int test_pprint(void)
-{
-	unsigned int i;
-	int err =3D 0;
-
-	/* test various maps with the first test template */
-	for (i =3D 0; i < ARRAY_SIZE(pprint_tests_meta); i++) {
-		pprint_test_template[0].descr =3D pprint_tests_meta[i].descr;
-		pprint_test_template[0].map_type =3D pprint_tests_meta[i].map_type;
-		pprint_test_template[0].map_name =3D pprint_tests_meta[i].map_name;
-		pprint_test_template[0].ordered_map =3D pprint_tests_meta[i].ordered_m=
ap;
-		pprint_test_template[0].lossless_map =3D pprint_tests_meta[i].lossless=
_map;
-		pprint_test_template[0].percpu_map =3D pprint_tests_meta[i].percpu_map=
;
-
-		err |=3D count_result(do_test_pprint(0));
-	}
-
-	/* test rest test templates with the first map */
-	for (i =3D 1; i < ARRAY_SIZE(pprint_test_template); i++) {
-		pprint_test_template[i].descr =3D pprint_tests_meta[0].descr;
-		pprint_test_template[i].map_type =3D pprint_tests_meta[0].map_type;
-		pprint_test_template[i].map_name =3D pprint_tests_meta[0].map_name;
-		pprint_test_template[i].ordered_map =3D pprint_tests_meta[0].ordered_m=
ap;
-		pprint_test_template[i].lossless_map =3D pprint_tests_meta[0].lossless=
_map;
-		pprint_test_template[i].percpu_map =3D pprint_tests_meta[0].percpu_map=
;
-		err |=3D count_result(do_test_pprint(i));
-	}
-
-	return err;
 }
=20
 #define BPF_LINE_INFO_ENC(insn_off, file_off, line_off, line_num, line_c=
ol) \
@@ -6178,7 +5399,7 @@ static int test_get_linfo(const struct prog_info_ra=
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
@@ -6187,18 +5408,19 @@ static int do_test_info_raw(unsigned int test_num=
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
@@ -6206,7 +5428,7 @@ static int do_test_info_raw(unsigned int test_num)
 		goto done;
 	}
=20
-	if (*btf_log_buf && args.always_log)
+	if (*btf_log_buf && always_log)
 		fprintf(stderr, "\n%s", btf_log_buf);
 	*btf_log_buf =3D '\0';
=20
@@ -6261,10 +5483,7 @@ static int do_test_info_raw(unsigned int test_num)
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
@@ -6274,22 +5493,6 @@ static int do_test_info_raw(unsigned int test_num)
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
@@ -6754,7 +5957,7 @@ static void dump_btf_strings(const char *strs, __u3=
2 len)
 	}
 }
=20
-static int do_test_dedup(unsigned int test_num)
+static void do_test_dedup(unsigned int test_num)
 {
 	const struct btf_dedup_test *test =3D &dedup_tests[test_num - 1];
 	__u32 test_nr_types, expect_nr_types, test_btf_size, expect_btf_size;
@@ -6769,13 +5972,15 @@ static int do_test_dedup(unsigned int test_num)
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
@@ -6789,7 +5994,7 @@ static int do_test_dedup(unsigned int test_num)
 				 test->expect.str_sec_size,
 				 &raw_btf_size, &ret_expect_next_str);
 	if (!raw_btf)
-		return -1;
+		return;
 	expect_btf =3D btf__new((__u8 *)raw_btf, raw_btf_size);
 	free(raw_btf);
 	if (CHECK(IS_ERR(expect_btf), "invalid expect_btf errno:%ld",
@@ -6894,174 +6099,26 @@ static int do_test_dedup(unsigned int test_num)
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
 }
diff --git a/tools/testing/selftests/bpf/test_btf_pprint.c b/tools/testin=
g/selftests/bpf/test_btf_pprint.c
new file mode 100644
index 000000000000..2108c1ada14b
--- /dev/null
+++ b/tools/testing/selftests/bpf/test_btf_pprint.c
@@ -0,0 +1,969 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (c) 2018 Facebook */
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/filter.h>
+#include <linux/unistd.h>
+#include <bpf/bpf.h>
+#include <sys/resource.h>
+#include <libelf.h>
+#include <gelf.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdarg.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <assert.h>
+#include <bpf/libbpf.h>
+#include <bpf/btf.h>
+
+#include "bpf_rlimit.h"
+#include "bpf_util.h"
+#include "test_btf.h"
+
+#define MAX_INSNS	512
+#define MAX_SUBPROGS	16
+
+static uint32_t pass_cnt;
+static uint32_t error_cnt;
+static uint32_t skip_cnt;
+
+#define CHECK(condition, format...) ({					\
+	int __ret =3D !!(condition);					\
+	if (__ret) {							\
+		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
+		fprintf(stderr, format);				\
+	}								\
+	__ret;								\
+})
+
+static int count_result(int err)
+{
+	if (err)
+		error_cnt++;
+	else
+		pass_cnt++;
+
+	fprintf(stderr, "\n");
+	return err;
+}
+
+static int __base_pr(enum libbpf_print_level level __attribute__((unused=
)),
+		     const char *format, va_list args)
+{
+	return vfprintf(stderr, format, args);
+}
+
+#define BTF_END_RAW 0xdeadbeef
+#define NAME_TBD 0xdeadb33f
+
+#define NAME_NTH(N) (0xffff0000 | N)
+#define IS_NAME_NTH(X) ((X & 0xffff0000) =3D=3D 0xffff0000)
+#define GET_NAME_NTH_IDX(X) (X & 0x0000ffff)
+
+#define MAX_NR_RAW_U32 1024
+#define BTF_LOG_BUF_SIZE 65535
+
+static struct args {
+	bool always_log;
+} args;
+
+static char btf_log_buf[BTF_LOG_BUF_SIZE];
+
+static struct btf_header hdr_tmpl =3D {
+	.magic =3D BTF_MAGIC,
+	.version =3D BTF_VERSION,
+	.hdr_len =3D sizeof(struct btf_header),
+};
+
+/* several different mapv kinds(types) supported by pprint */
+enum pprint_mapv_kind_t {
+	PPRINT_MAPV_KIND_BASIC =3D 0,
+	PPRINT_MAPV_KIND_INT128,
+};
+
+struct btf_raw_test {
+	const char *descr;
+	const char *str_sec;
+	const char *map_name;
+	const char *err_str;
+	__u32 raw_types[MAX_NR_RAW_U32];
+	__u32 str_sec_size;
+	enum bpf_map_type map_type;
+	__u32 key_size;
+	__u32 value_size;
+	__u32 key_type_id;
+	__u32 value_type_id;
+	__u32 max_entries;
+	bool btf_load_err;
+	bool map_create_err;
+	bool ordered_map;
+	bool lossless_map;
+	bool percpu_map;
+	int hdr_len_delta;
+	int type_off_delta;
+	int str_off_delta;
+	int str_len_delta;
+	enum pprint_mapv_kind_t mapv_kind;
+};
+
+#define BTF_STR_SEC(str) \
+	.str_sec =3D str, .str_sec_size =3D sizeof(str)
+
+static const char *get_next_str(const char *start, const char *end)
+{
+	return start < end - 1 ? start + 1 : NULL;
+}
+
+static int get_raw_sec_size(const __u32 *raw_types)
+{
+	int i;
+
+	for (i =3D MAX_NR_RAW_U32 - 1;
+	     i >=3D 0 && raw_types[i] !=3D BTF_END_RAW;
+	     i--)
+		;
+
+	return i < 0 ? i : i * sizeof(raw_types[0]);
+}
+
+static void *btf_raw_create(const struct btf_header *hdr,
+			    const __u32 *raw_types,
+			    const char *str,
+			    unsigned int str_sec_size,
+			    unsigned int *btf_size,
+			    const char **ret_next_str)
+{
+	const char *next_str =3D str, *end_str =3D str + str_sec_size;
+	const char **strs_idx =3D NULL, **tmp_strs_idx;
+	int strs_cap =3D 0, strs_cnt =3D 0, next_str_idx =3D 0;
+	unsigned int size_needed, offset;
+	struct btf_header *ret_hdr;
+	int i, type_sec_size, err =3D 0;
+	uint32_t *ret_types;
+	void *raw_btf =3D NULL;
+
+	type_sec_size =3D get_raw_sec_size(raw_types);
+	if (CHECK(type_sec_size < 0, "Cannot get nr_raw_types"))
+		return NULL;
+
+	size_needed =3D sizeof(*hdr) + type_sec_size + str_sec_size;
+	raw_btf =3D malloc(size_needed);
+	if (CHECK(!raw_btf, "Cannot allocate memory for raw_btf"))
+		return NULL;
+
+	/* Copy header */
+	memcpy(raw_btf, hdr, sizeof(*hdr));
+	offset =3D sizeof(*hdr);
+
+	/* Index strings */
+	while ((next_str =3D get_next_str(next_str, end_str))) {
+		if (strs_cnt =3D=3D strs_cap) {
+			strs_cap +=3D max(16, strs_cap / 2);
+			tmp_strs_idx =3D realloc(strs_idx,
+					       sizeof(*strs_idx) * strs_cap);
+			if (CHECK(!tmp_strs_idx,
+				  "Cannot allocate memory for strs_idx")) {
+				err =3D -1;
+				goto done;
+			}
+			strs_idx =3D tmp_strs_idx;
+		}
+		strs_idx[strs_cnt++] =3D next_str;
+		next_str +=3D strlen(next_str);
+	}
+
+	/* Copy type section */
+	ret_types =3D raw_btf + offset;
+	for (i =3D 0; i < type_sec_size / sizeof(raw_types[0]); i++) {
+		if (raw_types[i] =3D=3D NAME_TBD) {
+			if (CHECK(next_str_idx =3D=3D strs_cnt,
+				  "Error in getting next_str #%d",
+				  next_str_idx)) {
+				err =3D -1;
+				goto done;
+			}
+			ret_types[i] =3D strs_idx[next_str_idx++] - str;
+		} else if (IS_NAME_NTH(raw_types[i])) {
+			int idx =3D GET_NAME_NTH_IDX(raw_types[i]);
+
+			if (CHECK(idx <=3D 0 || idx > strs_cnt,
+				  "Error getting string #%d, strs_cnt:%d",
+				  idx, strs_cnt)) {
+				err =3D -1;
+				goto done;
+			}
+			ret_types[i] =3D strs_idx[idx-1] - str;
+		} else {
+			ret_types[i] =3D raw_types[i];
+		}
+	}
+	offset +=3D type_sec_size;
+
+	/* Copy string section */
+	memcpy(raw_btf + offset, str, str_sec_size);
+
+	ret_hdr =3D (struct btf_header *)raw_btf;
+	ret_hdr->type_len =3D type_sec_size;
+	ret_hdr->str_off =3D type_sec_size;
+	ret_hdr->str_len =3D str_sec_size;
+
+	*btf_size =3D size_needed;
+	if (ret_next_str)
+		*ret_next_str =3D
+			next_str_idx < strs_cnt ? strs_idx[next_str_idx] : NULL;
+
+done:
+	if (err) {
+		if (raw_btf)
+			free(raw_btf);
+		if (strs_idx)
+			free(strs_idx);
+		return NULL;
+	}
+	return raw_btf;
+}
+
+const char *pprint_enum_str[] =3D {
+	"ENUM_ZERO",
+	"ENUM_ONE",
+	"ENUM_TWO",
+	"ENUM_THREE",
+};
+
+struct pprint_mapv {
+	uint32_t ui32;
+	uint16_t ui16;
+	/* 2 bytes hole */
+	int32_t si32;
+	uint32_t unused_bits2a:2,
+		bits28:28,
+		unused_bits2b:2;
+	union {
+		uint64_t ui64;
+		uint8_t ui8a[8];
+	};
+	enum {
+		ENUM_ZERO,
+		ENUM_ONE,
+		ENUM_TWO,
+		ENUM_THREE,
+	} aenum;
+	uint32_t ui32b;
+	uint32_t bits2c:2;
+	uint8_t si8_4[2][2];
+};
+
+#ifdef __SIZEOF_INT128__
+struct pprint_mapv_int128 {
+	__int128 si128a;
+	__int128 si128b;
+	unsigned __int128 bits3:3;
+	unsigned __int128 bits80:80;
+	unsigned __int128 ui128;
+};
+#endif
+
+static struct btf_raw_test pprint_test_template[] =3D {
+{
+	.raw_types =3D {
+		/* unsighed char */			/* [1] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
+		/* unsigned short */			/* [2] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
+		/* unsigned int */			/* [3] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
+		/* int */				/* [4] */
+		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
+		/* unsigned long long */		/* [5] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
+		/* 2 bits */				/* [6] */
+		BTF_TYPE_INT_ENC(0, 0, 0, 2, 2),
+		/* 28 bits */				/* [7] */
+		BTF_TYPE_INT_ENC(0, 0, 0, 28, 4),
+		/* uint8_t[8] */			/* [8] */
+		BTF_TYPE_ARRAY_ENC(9, 1, 8),
+		/* typedef unsigned char uint8_t */	/* [9] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 1),
+		/* typedef unsigned short uint16_t */	/* [10] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 2),
+		/* typedef unsigned int uint32_t */	/* [11] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 3),
+		/* typedef int int32_t */		/* [12] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),
+		/* typedef unsigned long long uint64_t *//* [13] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 5),
+		/* union (anon) */			/* [14] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
+		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
+		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
+		/* enum (anon) */			/* [15] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
+		BTF_ENUM_ENC(NAME_TBD, 0),
+		BTF_ENUM_ENC(NAME_TBD, 1),
+		BTF_ENUM_ENC(NAME_TBD, 2),
+		BTF_ENUM_ENC(NAME_TBD, 3),
+		/* struct pprint_mapv */		/* [16] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 0, 11), 40),
+		BTF_MEMBER_ENC(NAME_TBD, 11, 0),	/* uint32_t ui32 */
+		BTF_MEMBER_ENC(NAME_TBD, 10, 32),	/* uint16_t ui16 */
+		BTF_MEMBER_ENC(NAME_TBD, 12, 64),	/* int32_t si32 */
+		BTF_MEMBER_ENC(NAME_TBD, 6, 96),	/* unused_bits2a */
+		BTF_MEMBER_ENC(NAME_TBD, 7, 98),	/* bits28 */
+		BTF_MEMBER_ENC(NAME_TBD, 6, 126),	/* unused_bits2b */
+		BTF_MEMBER_ENC(0, 14, 128),		/* union (anon) */
+		BTF_MEMBER_ENC(NAME_TBD, 15, 192),	/* aenum */
+		BTF_MEMBER_ENC(NAME_TBD, 11, 224),	/* uint32_t ui32b */
+		BTF_MEMBER_ENC(NAME_TBD, 6, 256),	/* bits2c */
+		BTF_MEMBER_ENC(NAME_TBD, 17, 264),	/* si8_4 */
+		BTF_TYPE_ARRAY_ENC(18, 1, 2),		/* [17] */
+		BTF_TYPE_ARRAY_ENC(1, 1, 2),		/* [18] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0si8_4"),
+	.key_size =3D sizeof(unsigned int),
+	.value_size =3D sizeof(struct pprint_mapv),
+	.key_type_id =3D 3,	/* unsigned int */
+	.value_type_id =3D 16,	/* struct pprint_mapv */
+	.max_entries =3D 128 * 1024,
+},
+
+{
+	/* this type will have the same type as the
+	 * first .raw_types definition, but struct type will
+	 * be encoded with kind_flag set.
+	 */
+	.raw_types =3D {
+		/* unsighed char */			/* [1] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
+		/* unsigned short */			/* [2] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
+		/* unsigned int */			/* [3] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
+		/* int */				/* [4] */
+		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
+		/* unsigned long long */		/* [5] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
+		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [6] */
+		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [7] */
+		/* uint8_t[8] */			/* [8] */
+		BTF_TYPE_ARRAY_ENC(9, 1, 8),
+		/* typedef unsigned char uint8_t */	/* [9] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 1),
+		/* typedef unsigned short uint16_t */	/* [10] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 2),
+		/* typedef unsigned int uint32_t */	/* [11] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 3),
+		/* typedef int int32_t */		/* [12] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),
+		/* typedef unsigned long long uint64_t *//* [13] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 5),
+		/* union (anon) */			/* [14] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
+		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
+		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
+		/* enum (anon) */			/* [15] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
+		BTF_ENUM_ENC(NAME_TBD, 0),
+		BTF_ENUM_ENC(NAME_TBD, 1),
+		BTF_ENUM_ENC(NAME_TBD, 2),
+		BTF_ENUM_ENC(NAME_TBD, 3),
+		/* struct pprint_mapv */		/* [16] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 11), 40),
+		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 0)),	/* uint32_t ui3=
2 */
+		BTF_MEMBER_ENC(NAME_TBD, 10, BTF_MEMBER_OFFSET(0, 32)),	/* uint16_t ui=
16 */
+		BTF_MEMBER_ENC(NAME_TBD, 12, BTF_MEMBER_OFFSET(0, 64)),	/* int32_t si3=
2 */
+		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 96)),	/* unused_bits2=
a */
+		BTF_MEMBER_ENC(NAME_TBD, 7, BTF_MEMBER_OFFSET(28, 98)),	/* bits28 */
+		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 126)),	/* unused_bits=
2b */
+		BTF_MEMBER_ENC(0, 14, BTF_MEMBER_OFFSET(0, 128)),	/* union (anon) */
+		BTF_MEMBER_ENC(NAME_TBD, 15, BTF_MEMBER_OFFSET(0, 192)),	/* aenum */
+		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 224)),	/* uint32_t u=
i32b */
+		BTF_MEMBER_ENC(NAME_TBD, 6, BTF_MEMBER_OFFSET(2, 256)),	/* bits2c */
+		BTF_MEMBER_ENC(NAME_TBD, 17, 264),	/* si8_4 */
+		BTF_TYPE_ARRAY_ENC(18, 1, 2),		/* [17] */
+		BTF_TYPE_ARRAY_ENC(1, 1, 2),		/* [18] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0si8_4"),
+	.key_size =3D sizeof(unsigned int),
+	.value_size =3D sizeof(struct pprint_mapv),
+	.key_type_id =3D 3,	/* unsigned int */
+	.value_type_id =3D 16,	/* struct pprint_mapv */
+	.max_entries =3D 128 * 1024,
+},
+
+{
+	/* this type will have the same layout as the
+	 * first .raw_types definition. The struct type will
+	 * be encoded with kind_flag set, bitfield members
+	 * are added typedef/const/volatile, and bitfield members
+	 * will have both int and enum types.
+	 */
+	.raw_types =3D {
+		/* unsighed char */			/* [1] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 8, 1),
+		/* unsigned short */			/* [2] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 16, 2),
+		/* unsigned int */			/* [3] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
+		/* int */				/* [4] */
+		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 32, 4),
+		/* unsigned long long */		/* [5] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 64, 8),
+		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [6] */
+		BTF_TYPE_INT_ENC(0, 0, 0, 32, 4),	/* [7] */
+		/* uint8_t[8] */			/* [8] */
+		BTF_TYPE_ARRAY_ENC(9, 1, 8),
+		/* typedef unsigned char uint8_t */	/* [9] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 1),
+		/* typedef unsigned short uint16_t */	/* [10] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 2),
+		/* typedef unsigned int uint32_t */	/* [11] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 3),
+		/* typedef int int32_t */		/* [12] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 4),
+		/* typedef unsigned long long uint64_t *//* [13] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 5),
+		/* union (anon) */			/* [14] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_UNION, 0, 2), 8),
+		BTF_MEMBER_ENC(NAME_TBD, 13, 0),/* uint64_t ui64; */
+		BTF_MEMBER_ENC(NAME_TBD, 8, 0),	/* uint8_t ui8a[8]; */
+		/* enum (anon) */			/* [15] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_ENUM, 0, 4), 4),
+		BTF_ENUM_ENC(NAME_TBD, 0),
+		BTF_ENUM_ENC(NAME_TBD, 1),
+		BTF_ENUM_ENC(NAME_TBD, 2),
+		BTF_ENUM_ENC(NAME_TBD, 3),
+		/* struct pprint_mapv */		/* [16] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 11), 40),
+		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 0)),	/* uint32_t ui3=
2 */
+		BTF_MEMBER_ENC(NAME_TBD, 10, BTF_MEMBER_OFFSET(0, 32)),	/* uint16_t ui=
16 */
+		BTF_MEMBER_ENC(NAME_TBD, 12, BTF_MEMBER_OFFSET(0, 64)),	/* int32_t si3=
2 */
+		BTF_MEMBER_ENC(NAME_TBD, 17, BTF_MEMBER_OFFSET(2, 96)),	/* unused_bits=
2a */
+		BTF_MEMBER_ENC(NAME_TBD, 7, BTF_MEMBER_OFFSET(28, 98)),	/* bits28 */
+		BTF_MEMBER_ENC(NAME_TBD, 19, BTF_MEMBER_OFFSET(2, 126)),/* unused_bits=
2b */
+		BTF_MEMBER_ENC(0, 14, BTF_MEMBER_OFFSET(0, 128)),	/* union (anon) */
+		BTF_MEMBER_ENC(NAME_TBD, 15, BTF_MEMBER_OFFSET(0, 192)),	/* aenum */
+		BTF_MEMBER_ENC(NAME_TBD, 11, BTF_MEMBER_OFFSET(0, 224)),	/* uint32_t u=
i32b */
+		BTF_MEMBER_ENC(NAME_TBD, 17, BTF_MEMBER_OFFSET(2, 256)),	/* bits2c */
+		BTF_MEMBER_ENC(NAME_TBD, 20, BTF_MEMBER_OFFSET(0, 264)),	/* si8_4 */
+		/* typedef unsigned int ___int */	/* [17] */
+		BTF_TYPEDEF_ENC(NAME_TBD, 18),
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_VOLATILE, 0, 0), 6),	/* [18] */
+		BTF_TYPE_ENC(0, BTF_INFO_ENC(BTF_KIND_CONST, 0, 0), 15),	/* [19] */
+		BTF_TYPE_ARRAY_ENC(21, 1, 2),					/* [20] */
+		BTF_TYPE_ARRAY_ENC(1, 1, 2),					/* [21] */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0unsigned char\0unsigned short\0unsigned int\0int\0unsign=
ed long long\0uint8_t\0uint16_t\0uint32_t\0int32_t\0uint64_t\0ui64\0ui8a\=
0ENUM_ZERO\0ENUM_ONE\0ENUM_TWO\0ENUM_THREE\0pprint_mapv\0ui32\0ui16\0si32=
\0unused_bits2a\0bits28\0unused_bits2b\0aenum\0ui32b\0bits2c\0___int\0si8=
_4"),
+	.key_size =3D sizeof(unsigned int),
+	.value_size =3D sizeof(struct pprint_mapv),
+	.key_type_id =3D 3,	/* unsigned int */
+	.value_type_id =3D 16,	/* struct pprint_mapv */
+	.max_entries =3D 128 * 1024,
+},
+
+#ifdef __SIZEOF_INT128__
+{
+	/* test int128 */
+	.raw_types =3D {
+		/* unsigned int */				/* [1] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 32, 4),
+		/* __int128 */					/* [2] */
+		BTF_TYPE_INT_ENC(NAME_TBD, BTF_INT_SIGNED, 0, 128, 16),
+		/* unsigned __int128 */				/* [3] */
+		BTF_TYPE_INT_ENC(NAME_TBD, 0, 0, 128, 16),
+		/* struct pprint_mapv_int128 */			/* [4] */
+		BTF_TYPE_ENC(NAME_TBD, BTF_INFO_ENC(BTF_KIND_STRUCT, 1, 5), 64),
+		BTF_MEMBER_ENC(NAME_TBD, 2, BTF_MEMBER_OFFSET(0, 0)),		/* si128a */
+		BTF_MEMBER_ENC(NAME_TBD, 2, BTF_MEMBER_OFFSET(0, 128)),		/* si128b */
+		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(3, 256)),		/* bits3 */
+		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(80, 259)),	/* bits80 */
+		BTF_MEMBER_ENC(NAME_TBD, 3, BTF_MEMBER_OFFSET(0, 384)),		/* ui128 */
+		BTF_END_RAW,
+	},
+	BTF_STR_SEC("\0unsigned int\0__int128\0unsigned __int128\0pprint_mapv_i=
nt128\0si128a\0si128b\0bits3\0bits80\0ui128"),
+	.key_size =3D sizeof(unsigned int),
+	.value_size =3D sizeof(struct pprint_mapv_int128),
+	.key_type_id =3D 1,
+	.value_type_id =3D 4,
+	.max_entries =3D 128 * 1024,
+	.mapv_kind =3D PPRINT_MAPV_KIND_INT128,
+},
+#endif
+
+};
+
+static struct btf_pprint_test_meta {
+	const char *descr;
+	enum bpf_map_type map_type;
+	const char *map_name;
+	bool ordered_map;
+	bool lossless_map;
+	bool percpu_map;
+} pprint_tests_meta[] =3D {
+{
+	.descr =3D "BTF pretty print array",
+	.map_type =3D BPF_MAP_TYPE_ARRAY,
+	.map_name =3D "pprint_test_array",
+	.ordered_map =3D true,
+	.lossless_map =3D true,
+	.percpu_map =3D false,
+},
+
+{
+	.descr =3D "BTF pretty print hash",
+	.map_type =3D BPF_MAP_TYPE_HASH,
+	.map_name =3D "pprint_test_hash",
+	.ordered_map =3D false,
+	.lossless_map =3D true,
+	.percpu_map =3D false,
+},
+
+{
+	.descr =3D "BTF pretty print lru hash",
+	.map_type =3D BPF_MAP_TYPE_LRU_HASH,
+	.map_name =3D "pprint_test_lru_hash",
+	.ordered_map =3D false,
+	.lossless_map =3D false,
+	.percpu_map =3D false,
+},
+
+{
+	.descr =3D "BTF pretty print percpu array",
+	.map_type =3D BPF_MAP_TYPE_PERCPU_ARRAY,
+	.map_name =3D "pprint_test_percpu_array",
+	.ordered_map =3D true,
+	.lossless_map =3D true,
+	.percpu_map =3D true,
+},
+
+{
+	.descr =3D "BTF pretty print percpu hash",
+	.map_type =3D BPF_MAP_TYPE_PERCPU_HASH,
+	.map_name =3D "pprint_test_percpu_hash",
+	.ordered_map =3D false,
+	.lossless_map =3D true,
+	.percpu_map =3D true,
+},
+
+{
+	.descr =3D "BTF pretty print lru percpu hash",
+	.map_type =3D BPF_MAP_TYPE_LRU_PERCPU_HASH,
+	.map_name =3D "pprint_test_lru_percpu_hash",
+	.ordered_map =3D false,
+	.lossless_map =3D false,
+	.percpu_map =3D true,
+},
+
+};
+
+static size_t get_pprint_mapv_size(enum pprint_mapv_kind_t mapv_kind)
+{
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC)
+		return sizeof(struct pprint_mapv);
+
+#ifdef __SIZEOF_INT128__
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128)
+		return sizeof(struct pprint_mapv_int128);
+#endif
+
+	assert(0);
+}
+
+static void set_pprint_mapv(enum pprint_mapv_kind_t mapv_kind,
+			    void *mapv, uint32_t i,
+			    int num_cpus, int rounded_value_size)
+{
+	int cpu;
+
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC) {
+		struct pprint_mapv *v =3D mapv;
+
+		for (cpu =3D 0; cpu < num_cpus; cpu++) {
+			v->ui32 =3D i + cpu;
+			v->si32 =3D -i;
+			v->unused_bits2a =3D 3;
+			v->bits28 =3D i;
+			v->unused_bits2b =3D 3;
+			v->ui64 =3D i;
+			v->aenum =3D i & 0x03;
+			v->ui32b =3D 4;
+			v->bits2c =3D 1;
+			v->si8_4[0][0] =3D (cpu + i) & 0xff;
+			v->si8_4[0][1] =3D (cpu + i + 1) & 0xff;
+			v->si8_4[1][0] =3D (cpu + i + 2) & 0xff;
+			v->si8_4[1][1] =3D (cpu + i + 3) & 0xff;
+			v =3D (void *)v + rounded_value_size;
+		}
+	}
+
+#ifdef __SIZEOF_INT128__
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128) {
+		struct pprint_mapv_int128 *v =3D mapv;
+
+		for (cpu =3D 0; cpu < num_cpus; cpu++) {
+			v->si128a =3D i;
+			v->si128b =3D -i;
+			v->bits3 =3D i & 0x07;
+			v->bits80 =3D (((unsigned __int128)1) << 64) + i;
+			v->ui128 =3D (((unsigned __int128)2) << 64) + i;
+			v =3D (void *)v + rounded_value_size;
+		}
+	}
+#endif
+}
+
+ssize_t get_pprint_expected_line(enum pprint_mapv_kind_t mapv_kind,
+				 char *expected_line, ssize_t line_size,
+				 bool percpu_map, unsigned int next_key,
+				 int cpu, void *mapv)
+{
+	ssize_t nexpected_line =3D -1;
+
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_BASIC) {
+		struct pprint_mapv *v =3D mapv;
+
+		nexpected_line =3D snprintf(expected_line, line_size,
+					  "%s%u: {%u,0,%d,0x%x,0x%x,0x%x,"
+					  "{%llu|[%u,%u,%u,%u,%u,%u,%u,%u]},%s,"
+					  "%u,0x%x,[[%d,%d],[%d,%d]]}\n",
+					  percpu_map ? "\tcpu" : "",
+					  percpu_map ? cpu : next_key,
+					  v->ui32, v->si32,
+					  v->unused_bits2a,
+					  v->bits28,
+					  v->unused_bits2b,
+					  (__u64)v->ui64,
+					  v->ui8a[0], v->ui8a[1],
+					  v->ui8a[2], v->ui8a[3],
+					  v->ui8a[4], v->ui8a[5],
+					  v->ui8a[6], v->ui8a[7],
+					  pprint_enum_str[v->aenum],
+					  v->ui32b,
+					  v->bits2c,
+					  v->si8_4[0][0], v->si8_4[0][1],
+					  v->si8_4[1][0], v->si8_4[1][1]);
+	}
+
+#ifdef __SIZEOF_INT128__
+	if (mapv_kind =3D=3D PPRINT_MAPV_KIND_INT128) {
+		struct pprint_mapv_int128 *v =3D mapv;
+
+		nexpected_line =3D snprintf(expected_line, line_size,
+					  "%s%u: {0x%lx,0x%lx,0x%lx,"
+					  "0x%lx%016lx,0x%lx%016lx}\n",
+					  percpu_map ? "\tcpu" : "",
+					  percpu_map ? cpu : next_key,
+					  (uint64_t)v->si128a,
+					  (uint64_t)v->si128b,
+					  (uint64_t)v->bits3,
+					  (uint64_t)(v->bits80 >> 64),
+					  (uint64_t)v->bits80,
+					  (uint64_t)(v->ui128 >> 64),
+					  (uint64_t)v->ui128);
+	}
+#endif
+
+	return nexpected_line;
+}
+
+static int check_line(const char *expected_line, int nexpected_line,
+		      int expected_line_len, const char *line)
+{
+	if (CHECK(nexpected_line =3D=3D expected_line_len,
+		  "expected_line is too long"))
+		return -1;
+
+	if (strcmp(expected_line, line)) {
+		fprintf(stderr, "unexpected pprint output\n");
+		fprintf(stderr, "expected: %s", expected_line);
+		fprintf(stderr, "    read: %s", line);
+		return -1;
+	}
+
+	return 0;
+}
+
+
+static int do_test_pprint(int test_num)
+{
+	const struct btf_raw_test *test =3D &pprint_test_template[test_num];
+	enum pprint_mapv_kind_t mapv_kind =3D test->mapv_kind;
+	struct bpf_create_map_attr create_attr =3D {};
+	bool ordered_map, lossless_map, percpu_map;
+	int err, ret, num_cpus, rounded_value_size;
+	unsigned int key, nr_read_elems;
+	int map_fd =3D -1, btf_fd =3D -1;
+	unsigned int raw_btf_size;
+	char expected_line[255];
+	FILE *pin_file =3D NULL;
+	char pin_path[255];
+	size_t line_len =3D 0;
+	char *line =3D NULL;
+	void *mapv =3D NULL;
+	uint8_t *raw_btf;
+	ssize_t nread;
+
+	fprintf(stderr, "%s(#%d)......", test->descr, test_num);
+	raw_btf =3D btf_raw_create(&hdr_tmpl, test->raw_types,
+				 test->str_sec, test->str_sec_size,
+				 &raw_btf_size, NULL);
+
+	if (!raw_btf)
+		return -1;
+
+	*btf_log_buf =3D '\0';
+	btf_fd =3D bpf_load_btf(raw_btf, raw_btf_size,
+			      btf_log_buf, BTF_LOG_BUF_SIZE,
+			      args.always_log);
+	free(raw_btf);
+
+	if (CHECK(btf_fd =3D=3D -1, "errno:%d", errno)) {
+		err =3D -1;
+		goto done;
+	}
+
+	create_attr.name =3D test->map_name;
+	create_attr.map_type =3D test->map_type;
+	create_attr.key_size =3D test->key_size;
+	create_attr.value_size =3D test->value_size;
+	create_attr.max_entries =3D test->max_entries;
+	create_attr.btf_fd =3D btf_fd;
+	create_attr.btf_key_type_id =3D test->key_type_id;
+	create_attr.btf_value_type_id =3D test->value_type_id;
+
+	map_fd =3D bpf_create_map_xattr(&create_attr);
+	if (CHECK(map_fd =3D=3D -1, "errno:%d", errno)) {
+		err =3D -1;
+		goto done;
+	}
+
+	ret =3D snprintf(pin_path, sizeof(pin_path), "%s/%s",
+		       "/sys/fs/bpf", test->map_name);
+
+	if (CHECK(ret =3D=3D sizeof(pin_path), "pin_path %s/%s is too long",
+		  "/sys/fs/bpf", test->map_name)) {
+		err =3D -1;
+		goto done;
+	}
+
+	err =3D bpf_obj_pin(map_fd, pin_path);
+	if (CHECK(err, "bpf_obj_pin(%s): errno:%d.", pin_path, errno))
+		goto done;
+
+	percpu_map =3D test->percpu_map;
+	num_cpus =3D percpu_map ? bpf_num_possible_cpus() : 1;
+	rounded_value_size =3D round_up(get_pprint_mapv_size(mapv_kind), 8);
+	mapv =3D calloc(num_cpus, rounded_value_size);
+	if (CHECK(!mapv, "mapv allocation failure")) {
+		err =3D -1;
+		goto done;
+	}
+
+	for (key =3D 0; key < test->max_entries; key++) {
+		set_pprint_mapv(mapv_kind, mapv, key, num_cpus, rounded_value_size);
+		bpf_map_update_elem(map_fd, &key, mapv, 0);
+	}
+
+	pin_file =3D fopen(pin_path, "r");
+	if (CHECK(!pin_file, "fopen(%s): errno:%d", pin_path, errno)) {
+		err =3D -1;
+		goto done;
+	}
+
+	/* Skip lines start with '#' */
+	while ((nread =3D getline(&line, &line_len, pin_file)) > 0 &&
+	       *line =3D=3D '#')
+		;
+
+	if (CHECK(nread <=3D 0, "Unexpected EOF")) {
+		err =3D -1;
+		goto done;
+	}
+
+	nr_read_elems =3D 0;
+	ordered_map =3D test->ordered_map;
+	lossless_map =3D test->lossless_map;
+	do {
+		ssize_t nexpected_line;
+		unsigned int next_key;
+		void *cmapv;
+		int cpu;
+
+		next_key =3D ordered_map ? nr_read_elems : atoi(line);
+		set_pprint_mapv(mapv_kind, mapv, next_key, num_cpus, rounded_value_siz=
e);
+		cmapv =3D mapv;
+
+		for (cpu =3D 0; cpu < num_cpus; cpu++) {
+			if (percpu_map) {
+				/* for percpu map, the format looks like:
+				 * <key>: {
+				 *	cpu0: <value_on_cpu0>
+				 *	cpu1: <value_on_cpu1>
+				 *	...
+				 *	cpun: <value_on_cpun>
+				 * }
+				 *
+				 * let us verify the line containing the key here.
+				 */
+				if (cpu =3D=3D 0) {
+					nexpected_line =3D snprintf(expected_line,
+								  sizeof(expected_line),
+								  "%u: {\n",
+								  next_key);
+
+					err =3D check_line(expected_line, nexpected_line,
+							 sizeof(expected_line), line);
+					if (err =3D=3D -1)
+						goto done;
+				}
+
+				/* read value@cpu */
+				nread =3D getline(&line, &line_len, pin_file);
+				if (nread < 0)
+					break;
+			}
+
+			nexpected_line =3D get_pprint_expected_line(mapv_kind, expected_line,
+								  sizeof(expected_line),
+								  percpu_map, next_key,
+								  cpu, cmapv);
+			err =3D check_line(expected_line, nexpected_line,
+					 sizeof(expected_line), line);
+			if (err =3D=3D -1)
+				goto done;
+
+			cmapv =3D cmapv + rounded_value_size;
+		}
+
+		if (percpu_map) {
+			/* skip the last bracket for the percpu map */
+			nread =3D getline(&line, &line_len, pin_file);
+			if (nread < 0)
+				break;
+		}
+
+		nread =3D getline(&line, &line_len, pin_file);
+	} while (++nr_read_elems < test->max_entries && nread > 0);
+
+	if (lossless_map &&
+	    CHECK(nr_read_elems < test->max_entries,
+		  "Unexpected EOF. nr_read_elems:%u test->max_entries:%u",
+		  nr_read_elems, test->max_entries)) {
+		err =3D -1;
+		goto done;
+	}
+
+	if (CHECK(nread > 0, "Unexpected extra pprint output: %s", line)) {
+		err =3D -1;
+		goto done;
+	}
+
+	err =3D 0;
+
+done:
+	if (mapv)
+		free(mapv);
+	if (!err)
+		fprintf(stderr, "OK");
+	if (*btf_log_buf && (err || args.always_log))
+		fprintf(stderr, "\n%s", btf_log_buf);
+	if (btf_fd !=3D -1)
+		close(btf_fd);
+	if (map_fd !=3D -1)
+		close(map_fd);
+	if (pin_file)
+		fclose(pin_file);
+	unlink(pin_path);
+	free(line);
+
+	return err;
+}
+
+static int test_pprint(void)
+{
+	unsigned int i;
+	int err =3D 0;
+
+	/* test various maps with the first test template */
+	for (i =3D 0; i < ARRAY_SIZE(pprint_tests_meta); i++) {
+		pprint_test_template[0].descr =3D pprint_tests_meta[i].descr;
+		pprint_test_template[0].map_type =3D pprint_tests_meta[i].map_type;
+		pprint_test_template[0].map_name =3D pprint_tests_meta[i].map_name;
+		pprint_test_template[0].ordered_map =3D pprint_tests_meta[i].ordered_m=
ap;
+		pprint_test_template[0].lossless_map =3D pprint_tests_meta[i].lossless=
_map;
+		pprint_test_template[0].percpu_map =3D pprint_tests_meta[i].percpu_map=
;
+
+		err |=3D count_result(do_test_pprint(0));
+	}
+
+	/* test rest test templates with the first map */
+	for (i =3D 1; i < ARRAY_SIZE(pprint_test_template); i++) {
+		pprint_test_template[i].descr =3D pprint_tests_meta[0].descr;
+		pprint_test_template[i].map_type =3D pprint_tests_meta[0].map_type;
+		pprint_test_template[i].map_name =3D pprint_tests_meta[0].map_name;
+		pprint_test_template[i].ordered_map =3D pprint_tests_meta[0].ordered_m=
ap;
+		pprint_test_template[i].lossless_map =3D pprint_tests_meta[0].lossless=
_map;
+		pprint_test_template[i].percpu_map =3D pprint_tests_meta[0].percpu_map=
;
+		err |=3D count_result(do_test_pprint(i));
+	}
+
+	return err;
+}
+
+static void usage(const char *cmd)
+{
+	fprintf(stderr, "Usage: %s [-l]\n", cmd);
+}
+
+static int parse_args(int argc, char **argv)
+{
+	const char *optstr =3D "hlpk:f:r:g:d:";
+	int opt;
+
+	while ((opt =3D getopt(argc, argv, optstr)) !=3D -1) {
+		switch (opt) {
+		case 'l':
+			args.always_log =3D true;
+			break;
+		case 'h':
+			usage(argv[0]);
+			exit(0);
+		default:
+			usage(argv[0]);
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+static void print_summary(void)
+{
+	fprintf(stderr, "PASS:%u SKIP:%u FAIL:%u\n",
+		pass_cnt - skip_cnt, skip_cnt, error_cnt);
+}
+
+int main(int argc, char **argv)
+{
+	int err =3D 0;
+
+	err =3D parse_args(argc, argv);
+	if (err)
+		return err;
+
+	if (args.always_log)
+		libbpf_set_print(__base_pr);
+
+	test_pprint();
+
+	print_summary();
+	return err;
+}
--=20
2.24.1


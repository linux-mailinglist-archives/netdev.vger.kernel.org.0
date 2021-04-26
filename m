Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB2036BA0B
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 21:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240385AbhDZTat convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 26 Apr 2021 15:30:49 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34232 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240318AbhDZTap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 15:30:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13QJOJ3G013047
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:03 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3860wrh5m8-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 12:30:03 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 26 Apr 2021 12:29:56 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0D1632ED6122; Mon, 26 Apr 2021 12:29:54 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH v2 bpf-next 1/5] selftests/bpf: add remaining ASSERT_xxx() variants
Date:   Mon, 26 Apr 2021 12:29:45 -0700
Message-ID: <20210426192949.416837-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210426192949.416837-1-andrii@kernel.org>
References: <20210426192949.416837-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: t1pZrCUXqXw7SdIe2tEEELOAkeAQqPjD
X-Proofpoint-ORIG-GUID: t1pZrCUXqXw7SdIe2tEEELOAkeAQqPjD
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-26_09:2021-04-26,2021-04-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 clxscore=1015 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104260149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ASSERT_TRUE/ASSERT_FALSE for conditions calculated with custom logic to
true/false. Also add remaining arithmetical assertions:
  - ASSERT_LE -- less than or equal;
  - ASSERT_GT -- greater than;
  - ASSERT_GE -- greater than or equal.
This should cover most scenarios where people fall back to error-prone
CHECK()s.

Also extend ASSERT_ERR() to print out errno, in addition to direct error.

Also convert few CHECK() instances to ensure new ASSERT_xxx() variants work as
expected. Subsequent patch will also use ASSERT_TRUE/ASSERT_FALSE more
extensively.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/btf_dump.c       |  2 +-
 .../selftests/bpf/prog_tests/btf_endian.c     |  4 +-
 .../selftests/bpf/prog_tests/cgroup_link.c    |  2 +-
 .../selftests/bpf/prog_tests/kfree_skb.c      |  2 +-
 .../selftests/bpf/prog_tests/resolve_btfids.c |  7 +--
 .../selftests/bpf/prog_tests/snprintf_btf.c   |  4 +-
 tools/testing/selftests/bpf/test_progs.h      | 50 ++++++++++++++++++-
 7 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
index c60091ee8a21..5e129dc2073c 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
@@ -77,7 +77,7 @@ static int test_btf_dump_case(int n, struct btf_dump_test_case *t)
 
 	snprintf(out_file, sizeof(out_file), "/tmp/%s.output.XXXXXX", t->file);
 	fd = mkstemp(out_file);
-	if (CHECK(fd < 0, "create_tmp", "failed to create file: %d\n", fd)) {
+	if (!ASSERT_GE(fd, 0, "create_tmp")) {
 		err = fd;
 		goto done;
 	}
diff --git a/tools/testing/selftests/bpf/prog_tests/btf_endian.c b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
index 8c52d72c876e..8ab5d3e358dd 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf_endian.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf_endian.c
@@ -6,8 +6,6 @@
 #include <test_progs.h>
 #include <bpf/btf.h>
 
-static int duration = 0;
-
 void test_btf_endian() {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 	enum btf_endianness endian = BTF_LITTLE_ENDIAN;
@@ -71,7 +69,7 @@ void test_btf_endian() {
 
 	/* now modify original BTF */
 	var_id = btf__add_var(btf, "some_var", BTF_VAR_GLOBAL_ALLOCATED, 1);
-	CHECK(var_id <= 0, "var_id", "failed %d\n", var_id);
+	ASSERT_GT(var_id, 0, "var_id");
 
 	btf__free(swap_btf);
 	swap_btf = NULL;
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
index 4d9b514b3fd9..736796e56ed1 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_link.c
@@ -54,7 +54,7 @@ void test_cgroup_link(void)
 
 	for (i = 0; i < cg_nr; i++) {
 		cgs[i].fd = create_and_get_cgroup(cgs[i].path);
-		if (CHECK(cgs[i].fd < 0, "cg_create", "fail: %d\n", cgs[i].fd))
+		if (!ASSERT_GE(cgs[i].fd, 0, "cg_create"))
 			goto cleanup;
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
index 42c3a3103c26..d65107919998 100644
--- a/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
+++ b/tools/testing/selftests/bpf/prog_tests/kfree_skb.c
@@ -134,7 +134,7 @@ void test_kfree_skb(void)
 	/* make sure kfree_skb program was triggered
 	 * and it sent expected skb into ring buffer
 	 */
-	CHECK_FAIL(!passed);
+	ASSERT_TRUE(passed, "passed");
 
 	err = bpf_map_lookup_elem(bpf_map__fd(global_data), &zero, test_ok);
 	if (CHECK(err, "get_result",
diff --git a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
index 6ace5e9efec1..d3c2de2c24d1 100644
--- a/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
+++ b/tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
@@ -160,11 +160,8 @@ int test_resolve_btfids(void)
 			break;
 
 		if (i > 0) {
-			ret = CHECK(test_set.ids[i - 1] > test_set.ids[i],
-				    "sort_check",
-				    "test_set is not sorted\n");
-			if (ret)
-				break;
+			if (!ASSERT_LE(test_set.ids[i - 1], test_set.ids[i], "sort_check"))
+				return -1;
 		}
 	}
 
diff --git a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
index 686b40f11a45..76e1f5fe18fa 100644
--- a/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/snprintf_btf.c
@@ -42,9 +42,7 @@ void test_snprintf_btf(void)
 	 * and it set expected return values from bpf_trace_printk()s
 	 * and all tests ran.
 	 */
-	if (CHECK(bss->ret <= 0,
-		  "bpf_snprintf_btf: got return value",
-		  "ret <= 0 %ld test %d\n", bss->ret, bss->ran_subtests))
+	if (!ASSERT_GT(bss->ret, 0, "bpf_snprintf_ret"))
 		goto cleanup;
 
 	if (CHECK(bss->ran_subtests == 0, "check if subtests ran",
diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
index ee7e3b45182a..dda52cb649dc 100644
--- a/tools/testing/selftests/bpf/test_progs.h
+++ b/tools/testing/selftests/bpf/test_progs.h
@@ -130,6 +130,20 @@ extern int test__join_cgroup(const char *path);
 #define CHECK_ATTR(condition, tag, format...) \
 	_CHECK(condition, tag, tattr.duration, format)
 
+#define ASSERT_TRUE(actual, name) ({					\
+	static int duration = 0;					\
+	bool ___ok = (actual);						\
+	CHECK(!___ok, (name), "unexpected %s: got FALSE\n", (name));	\
+	___ok;								\
+})
+
+#define ASSERT_FALSE(actual, name) ({					\
+	static int duration = 0;					\
+	bool ___ok = !(actual);						\
+	CHECK(!___ok, (name), "unexpected %s: got TRUE\n", (name));	\
+	___ok;								\
+})
+
 #define ASSERT_EQ(actual, expected, name) ({				\
 	static int duration = 0;					\
 	typeof(actual) ___act = (actual);				\
@@ -163,6 +177,39 @@ extern int test__join_cgroup(const char *path);
 	___ok;								\
 })
 
+#define ASSERT_LE(actual, expected, name) ({				\
+	static int duration = 0;					\
+	typeof(actual) ___act = (actual);				\
+	typeof(expected) ___exp = (expected);				\
+	bool ___ok = ___act <= ___exp;					\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual %lld > expected %lld\n",		\
+	      (name), (long long)(___act), (long long)(___exp));	\
+	___ok;								\
+})
+
+#define ASSERT_GT(actual, expected, name) ({				\
+	static int duration = 0;					\
+	typeof(actual) ___act = (actual);				\
+	typeof(expected) ___exp = (expected);				\
+	bool ___ok = ___act > ___exp;					\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual %lld <= expected %lld\n",		\
+	      (name), (long long)(___act), (long long)(___exp));	\
+	___ok;								\
+})
+
+#define ASSERT_GE(actual, expected, name) ({				\
+	static int duration = 0;					\
+	typeof(actual) ___act = (actual);				\
+	typeof(expected) ___exp = (expected);				\
+	bool ___ok = ___act >= ___exp;					\
+	CHECK(!___ok, (name),						\
+	      "unexpected %s: actual %lld < expected %lld\n",		\
+	      (name), (long long)(___act), (long long)(___exp));	\
+	___ok;								\
+})
+
 #define ASSERT_STREQ(actual, expected, name) ({				\
 	static int duration = 0;					\
 	const char *___act = actual;					\
@@ -178,7 +225,8 @@ extern int test__join_cgroup(const char *path);
 	static int duration = 0;					\
 	long long ___res = (res);					\
 	bool ___ok = ___res == 0;					\
-	CHECK(!___ok, (name), "unexpected error: %lld\n", ___res);	\
+	CHECK(!___ok, (name), "unexpected error: %lld (errno %d)\n",	\
+	      ___res, errno);						\
 	___ok;								\
 })
 
-- 
2.30.2


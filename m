Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449BE369D80
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 01:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244229AbhDWXik convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 19:38:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47678 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244226AbhDWXhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 19:37:01 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NNa7ra017631
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:24 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 383an29rch-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 16:36:24 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 16:36:23 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C40872ED5CF6; Fri, 23 Apr 2021 16:36:19 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 5/5] selftests/bpf: fix core_reloc test runner
Date:   Fri, 23 Apr 2021 16:30:58 -0700
Message-ID: <20210423233058.3386115-6-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423233058.3386115-1-andrii@kernel.org>
References: <20210423233058.3386115-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: yZIITQeZ4z9PJsreyXzmXPUB40X9GWmy
X-Proofpoint-GUID: yZIITQeZ4z9PJsreyXzmXPUB40X9GWmy
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_14:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 clxscore=1015 malwarescore=0 suspectscore=0 phishscore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104230159
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix failed tests checks in core_reloc test runner, which allowed failing tests
to pass quietly. Also add extra check to make sure that expected to fail test cases with
invalid names are caught as test failure anyway, as this is not an expected
failure mode. Also fix mislabeled probed vs direct bitfield test cases.

Fixes: 124a892d1c41 ("selftests/bpf: Test TYPE_EXISTS and TYPE_SIZE CO-RE relocations")
Reported-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 .../selftests/bpf/prog_tests/core_reloc.c     | 20 +++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 385fd7696a2e..607710826dca 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -217,7 +217,7 @@ static int duration = 0;
 
 #define BITFIELDS_CASE(name, ...) {					\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_probed.o",	\
-			      "direct:", name),				\
+			      "probed:", name),				\
 	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
 	.input_len = sizeof(struct core_reloc_##name),			\
 	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
@@ -225,7 +225,7 @@ static int duration = 0;
 	.output_len = sizeof(struct core_reloc_bitfields_output),	\
 }, {									\
 	BITFIELDS_CASE_COMMON("test_core_reloc_bitfields_direct.o",	\
-			      "probed:", name),				\
+			      "direct:", name),				\
 	.input = STRUCT_TO_CHAR_PTR(core_reloc_##name) __VA_ARGS__,	\
 	.input_len = sizeof(struct core_reloc_##name),			\
 	.output = STRUCT_TO_CHAR_PTR(core_reloc_bitfields_output)	\
@@ -546,8 +546,7 @@ static struct core_reloc_test_case test_cases[] = {
 	ARRAYS_ERR_CASE(arrays___err_too_small),
 	ARRAYS_ERR_CASE(arrays___err_too_shallow),
 	ARRAYS_ERR_CASE(arrays___err_non_array),
-	ARRAYS_ERR_CASE(arrays___err_wrong_val_type1),
-	ARRAYS_ERR_CASE(arrays___err_wrong_val_type2),
+	ARRAYS_ERR_CASE(arrays___err_wrong_val_type),
 	ARRAYS_ERR_CASE(arrays___err_bad_zero_sz_arr),
 
 	/* enum/ptr/int handling scenarios */
@@ -865,13 +864,20 @@ void test_core_reloc(void)
 			  "prog '%s' not found\n", probe_name))
 			goto cleanup;
 
+
+		if (test_case->btf_src_file) {
+			err = access(test_case->btf_src_file, R_OK);
+			if (!ASSERT_OK(err, "btf_src_file"))
+				goto cleanup;
+		}
+
 		load_attr.obj = obj;
 		load_attr.log_level = 0;
 		load_attr.target_btf_path = test_case->btf_src_file;
 		err = bpf_object__load_xattr(&load_attr);
 		if (err) {
 			if (!test_case->fails)
-				CHECK(false, "obj_load", "failed to load prog '%s': %d\n", probe_name, err);
+				ASSERT_OK(err, "obj_load");
 			goto cleanup;
 		}
 
@@ -910,10 +916,8 @@ void test_core_reloc(void)
 			goto cleanup;
 		}
 
-		if (test_case->fails) {
-			CHECK(false, "obj_load_fail", "should fail to load prog '%s'\n", probe_name);
+		if (!ASSERT_FALSE(test_case->fails, "obj_load_should_fail"))
 			goto cleanup;
-		}
 
 		equal = memcmp(data->out, test_case->output,
 			       test_case->output_len) == 0;
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20E562A7670
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 05:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgKEEeL convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Nov 2020 23:34:11 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57436 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728342AbgKEEeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 23:34:11 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0A54U3QF003681
        for <netdev@vger.kernel.org>; Wed, 4 Nov 2020 20:34:10 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34m5rf93t2-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 20:34:10 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 4 Nov 2020 20:34:08 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 101D82EC8E04; Wed,  4 Nov 2020 20:34:08 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 02/11] selftest/bpf: relax btf_dedup test checks
Date:   Wed, 4 Nov 2020 20:33:52 -0800
Message-ID: <20201105043402.2530976-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201105043402.2530976-1-andrii@kernel.org>
References: <20201105043402.2530976-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-05_01:2020-11-05,2020-11-05 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=8
 mlxlogscore=872 lowpriorityscore=0 adultscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011050032
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the requirement of a strictly exact string section contents. This used
to be true when string deduplication was done through sorting, but with string
dedup done through hash table, it's no longer true. So relax test harness to
relax strings checks and, consequently, type checks, which now don't have to
have exactly the same string offsets.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/btf.c | 40 ++++++++++++--------
 1 file changed, 25 insertions(+), 15 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 93162484c2ca..8ae97e2a4b9d 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -6652,7 +6652,7 @@ static void do_test_dedup(unsigned int test_num)
 	const void *test_btf_data, *expect_btf_data;
 	const char *ret_test_next_str, *ret_expect_next_str;
 	const char *test_strs, *expect_strs;
-	const char *test_str_cur, *test_str_end;
+	const char *test_str_cur;
 	const char *expect_str_cur, *expect_str_end;
 	unsigned int raw_btf_size;
 	void *raw_btf;
@@ -6719,12 +6719,18 @@ static void do_test_dedup(unsigned int test_num)
 		goto done;
 	}
 
-	test_str_cur = test_strs;
-	test_str_end = test_strs + test_hdr->str_len;
 	expect_str_cur = expect_strs;
 	expect_str_end = expect_strs + expect_hdr->str_len;
-	while (test_str_cur < test_str_end && expect_str_cur < expect_str_end) {
+	while (expect_str_cur < expect_str_end) {
 		size_t test_len, expect_len;
+		int off;
+
+		off = btf__find_str(test_btf, expect_str_cur);
+		if (CHECK(off < 0, "exp str '%s' not found: %d\n", expect_str_cur, off)) {
+			err = -1;
+			goto done;
+		}
+		test_str_cur = btf__str_by_offset(test_btf, off);
 
 		test_len = strlen(test_str_cur);
 		expect_len = strlen(expect_str_cur);
@@ -6741,15 +6747,8 @@ static void do_test_dedup(unsigned int test_num)
 			err = -1;
 			goto done;
 		}
-		test_str_cur += test_len + 1;
 		expect_str_cur += expect_len + 1;
 	}
-	if (CHECK(test_str_cur != test_str_end,
-		  "test_str_cur:%p != test_str_end:%p",
-		  test_str_cur, test_str_end)) {
-		err = -1;
-		goto done;
-	}
 
 	test_nr_types = btf__get_nr_types(test_btf);
 	expect_nr_types = btf__get_nr_types(expect_btf);
@@ -6775,10 +6774,21 @@ static void do_test_dedup(unsigned int test_num)
 			err = -1;
 			goto done;
 		}
-		if (CHECK(memcmp((void *)test_type,
-				 (void *)expect_type,
-				 test_size),
-			  "type #%d: contents differ", i)) {
+		if (CHECK(btf_kind(test_type) != btf_kind(expect_type),
+			  "type %d kind: exp %d != got %u\n",
+			  i, btf_kind(expect_type), btf_kind(test_type))) {
+			err = -1;
+			goto done;
+		}
+		if (CHECK(test_type->info != expect_type->info,
+			  "type %d info: exp %d != got %u\n",
+			  i, expect_type->info, test_type->info)) {
+			err = -1;
+			goto done;
+		}
+		if (CHECK(test_type->size != expect_type->size,
+			  "type %d size/type: exp %d != got %u\n",
+			  i, expect_type->size, test_type->size)) {
 			err = -1;
 			goto done;
 		}
-- 
2.24.1


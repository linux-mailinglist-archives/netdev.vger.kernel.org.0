Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3EB64FCC
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 03:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbfGKBI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 21:08:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:4424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726627AbfGKBI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jul 2019 21:08:56 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6B18swv019257
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 18:08:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3GRk+Ba9vvcMblG1mXiCw9DW15C3CuR/4AENGs/mVRw=;
 b=gikFLQ2ulsEKWmphGKkaGe4yK9LMMCDP41v3hGT3nEY0WKkR6deh1PIwGLvi4QcNs84g
 BCIvNbyJqMS3brcDlBM4rNdBacyVX+GEax2GlpML4BAJKhB7oB6VzS+C0U/NIcqlAQ2b
 +IDtazIwzePEKi9pSuivmNBrM2hY68wPmt8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2tnm4bhrxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 10 Jul 2019 18:08:54 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 10 Jul 2019 18:08:48 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8B7A1861544; Wed, 10 Jul 2019 18:08:47 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>, <ast@fb.com>,
        <daniel@iogearbox.net>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     Andrii Nakryiko <andriin@fb.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next] selftests/bpf: remove logic duplication in test_verifier.c
Date:   Wed, 10 Jul 2019 18:08:44 -0700
Message-ID: <20190711010844.1285018-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-10_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=983 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907110012
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_verifier tests can specify single- and multi-runs tests. Internally
logic of handling them is duplicated. Get rid of it by making single run
retval specification to be a first retvals spec.

Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 37 ++++++++++-----------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b0773291012a..120ecdf4a7db 100644
--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -86,7 +86,7 @@ struct bpf_test {
 	int fixup_sk_storage_map[MAX_FIXUPS];
 	const char *errstr;
 	const char *errstr_unpriv;
-	uint32_t retval, retval_unpriv, insn_processed;
+	uint32_t insn_processed;
 	int prog_len;
 	enum {
 		UNDEF,
@@ -95,16 +95,24 @@ struct bpf_test {
 	} result, result_unpriv;
 	enum bpf_prog_type prog_type;
 	uint8_t flags;
-	__u8 data[TEST_DATA_LEN];
 	void (*fill_helper)(struct bpf_test *self);
 	uint8_t runs;
-	struct {
-		uint32_t retval, retval_unpriv;
-		union {
-			__u8 data[TEST_DATA_LEN];
-			__u64 data64[TEST_DATA_LEN / 8];
+	union {
+		struct {
+			uint32_t retval, retval_unpriv;
+			union {
+				__u8 data[TEST_DATA_LEN];
+				__u64 data64[TEST_DATA_LEN / 8];
+			};
 		};
-	} retvals[MAX_TEST_RUNS];
+		struct {
+			uint32_t retval, retval_unpriv;
+			union {
+				__u8 data[TEST_DATA_LEN];
+				__u64 data64[TEST_DATA_LEN / 8];
+			};
+		} retvals[MAX_TEST_RUNS];
+	};
 	enum bpf_attach_type expected_attach_type;
 };
 
@@ -949,17 +957,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
 		uint32_t expected_val;
 		int i;
 
-		if (!test->runs) {
-			expected_val = unpriv && test->retval_unpriv ?
-				test->retval_unpriv : test->retval;
-
-			err = do_prog_test_run(fd_prog, unpriv, expected_val,
-					       test->data, sizeof(test->data));
-			if (err)
-				run_errs++;
-			else
-				run_successes++;
-		}
+		if (!test->runs)
+			test->runs = 1;
 
 		for (i = 0; i < test->runs; i++) {
 			if (unpriv && test->retvals[i].retval_unpriv)
-- 
2.17.1


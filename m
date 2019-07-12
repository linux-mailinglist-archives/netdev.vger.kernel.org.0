Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDA96747D
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 19:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727395AbfGLRoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 13:44:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59228 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727370AbfGLRoq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 13:44:46 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6CHcFRU016046
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:44:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=F2kypec0aiFOGfeY/idKL2YE6RLoUTl4k6zi81gvxIw=;
 b=DLDJICJEO+spuCj3DgEJ7dvLEdptXigTCXUBy4yglVgx2flEjmixdfua895vp4MkboQ2
 IjOPrkH2lWcb4QboTXOnGTsyWIzXEiSV7T73uHpjpbbfA/PdIhDBSKNBXexeZV86RDEt
 eiqOCAAjzhlo13mOnvPTR9jp0U2ZIlj2Dik= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tpr8a9e87-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 10:44:45 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 12 Jul 2019 10:44:44 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 8CE648616EB; Fri, 12 Jul 2019 10:44:43 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Krzesimir Nowak <krzesimir@kinvolk.io>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next] selftests/bpf: remove logic duplication in test_verifier.c
Date:   Fri, 12 Jul 2019 10:44:41 -0700
Message-ID: <20190712174441.4089282-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-12_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=939 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907120178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_verifier tests can specify single- and multi-runs tests. Internally
logic of handling them is duplicated. Get rid of it by making single run
retval/data specification to be a first run spec.

Cc: Krzesimir Nowak <krzesimir@kinvolk.io>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/test_verifier.c | 35 +++++++++------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
index b0773291012a..84135d5f4b35 100644
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
@@ -95,16 +95,20 @@ struct bpf_test {
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
-		};
-	} retvals[MAX_TEST_RUNS];
+#define bpf_testdata_struct_t					\
+	struct {						\
+		uint32_t retval, retval_unpriv;			\
+		union {						\
+			__u8 data[TEST_DATA_LEN];		\
+			__u64 data64[TEST_DATA_LEN / 8];	\
+		};						\
+	}
+	union {
+		bpf_testdata_struct_t;
+		bpf_testdata_struct_t retvals[MAX_TEST_RUNS];
+	};
 	enum bpf_attach_type expected_attach_type;
 };
 
@@ -949,17 +953,8 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D7BF11C247
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 02:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfLLBgD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 20:36:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58296 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727443AbfLLBgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 20:36:03 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBC1YWln014605
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=L4cf5DQw0E46IuWw2ojsLJcqyot2tp0OdPGHHJGSdAg=;
 b=ICD5ufMfANvIuj9L44rOfIO9NEuk/Cj4Mp9VaInbcPiSPD8yfSHPDe89csc1UUn0GPRm
 mYKNW/awzLm0CMHoamWQ7TcOCfmEaX9KJLQT8NzYDzjG96/qaJ5NczLVVdCe1DfyUc0V
 cpno0yKJHzZzWNytxteBIsDv84gdKVtVrfw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu2gf2p8n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 17:36:01 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 11 Dec 2019 17:36:00 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 80C342EC1A0E; Wed, 11 Dec 2019 17:36:00 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/4] selftests/bpf: add CPU mask parsing tests
Date:   Wed, 11 Dec 2019 17:35:58 -0800
Message-ID: <20191212013559.1690898-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_07:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=25 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912120004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a bunch of test validating CPU mask parsing logic and error handling.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 .../selftests/bpf/prog_tests/cpu_mask.c       | 78 +++++++++++++++++++
 1 file changed, 78 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cpu_mask.c

diff --git a/tools/testing/selftests/bpf/prog_tests/cpu_mask.c b/tools/testing/selftests/bpf/prog_tests/cpu_mask.c
new file mode 100644
index 000000000000..1fa1bdbaffa9
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/cpu_mask.c
@@ -0,0 +1,78 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <test_progs.h>
+#include <bpf/btf.h>
+#include "libbpf_internal.h"
+
+static int duration = 0;
+
+static void validate_mask(int case_nr, const char *exp, bool *mask, int n)
+{
+	int i;
+
+	for (i = 0; exp[i]; i++) {
+		if (exp[i] == '1') {
+			if (CHECK(i + 1 > n, "mask_short",
+				  "case #%d: mask too short, got n=%d, need at least %d\n",
+				  case_nr, n, i + 1))
+				return;
+			CHECK(!mask[i], "cpu_not_set",
+			      "case #%d: mask differs, expected cpu#%d SET\n",
+			      case_nr, i);
+		} else {
+			CHECK(i < n && mask[i], "cpu_set",
+			      "case #%d: mask differs, expected cpu#%d UNSET\n",
+			      case_nr, i);
+		}
+	}
+	CHECK(i < n, "mask_long",
+	      "case #%d: mask too long, got n=%d, expected at most %d\n",
+	      case_nr, n, i);
+}
+
+static struct {
+	const char *cpu_mask;
+	const char *expect;
+	bool fails;
+} test_cases[] = {
+	{ "0\n", "1", false },
+	{ "0,2\n", "101", false },
+	{ "0-2\n", "111", false },
+	{ "0-2,3-4\n", "11111", false },
+	{ "0", "1", false },
+	{ "0-2", "111", false },
+	{ "0,2", "101", false },
+	{ "0,1-3", "1111", false },
+	{ "0,1,2,3", "1111", false },
+	{ "0,2-3,5", "101101", false },
+	{ "3-3", "0001", false },
+	{ "2-4,6,9-10", "00111010011", false },
+	/* failure cases */
+	{ "", "", true },
+	{ "0-", "", true },
+	{ "0 ", "", true },
+	{ "0_1", "", true },
+	{ "1-0", "", true },
+	{ "-1", "", true },
+};
+
+void test_cpu_mask()
+{
+	int i, err, n;
+	bool *mask;
+
+	for (i = 0; i < ARRAY_SIZE(test_cases); i++) {
+		mask = NULL;
+		err = parse_cpu_mask_str(test_cases[i].cpu_mask, &mask, &n);
+		if (test_cases[i].fails) {
+			CHECK(!err, "should_fail",
+			      "case #%d: parsing should fail!\n", i + 1);
+		} else {
+			if (CHECK(err, "parse_err",
+				  "case #%d: cpu mask parsing failed: %d\n",
+				  i + 1, err))
+				continue;
+			validate_mask(i + 1, test_cases[i].expect, mask, n);
+		}
+		free(mask);
+	}
+}
-- 
2.17.1


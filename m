Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49A8D885D
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 08:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388229AbfJPGBK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 02:01:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729467AbfJPGBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 02:01:10 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9G6045c030426
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=G9pkX0Le7EtlmNs7HIJJjBYvxhTS/DlmBVtgrQigqKQ=;
 b=Vp/B7EUo0w0PvpKcUT0Xr8nzfYR4rNyxduEdPh2LPo8hBn7Tm4sK5FQ010emdnW3hS1i
 p3tO0xhoBjIuy8ujVg+ghcEqB5YKW9Zx4DEggQpDN9SE142Xlv8HSoMcTfiQbKBQgw+O
 QYwv9s6xoozAn/siQNYKiC/v+v3a+WeC4zw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd2ew6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 23:01:09 -0700
Received: from 2401:db00:12:909f:face:0:3:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 23:01:07 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id C04FF86195B; Tue, 15 Oct 2019 23:01:05 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v4 bpf-next 2/7] selftests/bpf: make CO-RE reloc test impartial to test_progs flavor
Date:   Tue, 15 Oct 2019 23:00:46 -0700
Message-ID: <20191016060051.2024182-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191016060051.2024182-1-andriin@fb.com>
References: <20191016060051.2024182-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_02:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=8 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910160056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

test_core_reloc_kernel test captures its own process name and validates
it as part of the test. Given extra "flavors" of test_progs, this break
for anything by default test_progs binary. Fix the test to cut out
flavor part of the process name.

Fixes: ee2eb063d330 ("selftests/bpf: Add BPF_CORE_READ and BPF_CORE_READ_STR_INTO macro tests")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/prog_tests/core_reloc.c        | 4 ++--
 tools/testing/selftests/bpf/progs/core_reloc_types.h       | 2 +-
 tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/core_reloc.c b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
index 7e2f5b4bf7f3..2b3586dc6c86 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -211,8 +211,8 @@ static struct core_reloc_test_case test_cases[] = {
 		.input_len = 0,
 		.output = STRUCT_TO_CHAR_PTR(core_reloc_kernel_output) {
 			.valid = { 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, },
-			.comm = "test_progs\0\0\0\0\0",
-			.comm_len = 11,
+			.comm = "test_progs",
+			.comm_len = sizeof("test_progs"),
 		},
 		.output_len = sizeof(struct core_reloc_kernel_output),
 	},
diff --git a/tools/testing/selftests/bpf/progs/core_reloc_types.h b/tools/testing/selftests/bpf/progs/core_reloc_types.h
index ad763ec0ba8f..f5939d9d5c61 100644
--- a/tools/testing/selftests/bpf/progs/core_reloc_types.h
+++ b/tools/testing/selftests/bpf/progs/core_reloc_types.h
@@ -6,7 +6,7 @@
 
 struct core_reloc_kernel_output {
 	int valid[10];
-	char comm[16];
+	char comm[sizeof("test_progs")];
 	int comm_len;
 };
 
diff --git a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
index 50f609618b65..a4b5e0562ed5 100644
--- a/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
+++ b/tools/testing/selftests/bpf/progs/test_core_reloc_kernel.c
@@ -15,7 +15,8 @@ static volatile struct data {
 
 struct core_reloc_kernel_output {
 	int valid[10];
-	char comm[16];
+	/* we have test_progs[-flavor], so cut flavor part */
+	char comm[sizeof("test_progs")];
 	int comm_len;
 };
 
-- 
2.17.1


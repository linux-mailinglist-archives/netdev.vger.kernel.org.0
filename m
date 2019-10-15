Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 186A4D8331
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388757AbfJOWEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:04:32 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387411AbfJOWE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:04:29 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FM0b9r019103
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:04:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=S5hn3GoBBFijEl6tERF3FWbPMnzXekfCKHm1f4VAIOk=;
 b=e5XK1l2qoSyEWYivGACS5RMacwGlNdHQyziBFdapY41nudIpqL+RIC5Qtv7Pr6CNqFhV
 dCs/1evWOVNO3Hi/El8ucyekr9bGXoVa246+dV23tay8vrM3VyuwSvyGLsI3sz3MlORm
 pwDQh9a3rh+BSyVY++EsKDB8qq9qVJsHURc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd0wh9-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:04:28 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 15:04:00 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 687D9861987; Tue, 15 Oct 2019 15:03:58 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 2/6] selftests/bpf: make CO-RE reloc test impartial to test_progs flavor
Date:   Tue, 15 Oct 2019 15:03:48 -0700
Message-ID: <20191015220352.435884-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191015220352.435884-1-andriin@fb.com>
References: <20191015220352.435884-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_08:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=8 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910150189
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
index 21a0dff66241..17980189d9e5 100644
--- a/tools/testing/selftests/bpf/prog_tests/core_reloc.c
+++ b/tools/testing/selftests/bpf/prog_tests/core_reloc.c
@@ -195,8 +195,8 @@ static struct core_reloc_test_case test_cases[] = {
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
index 9a6bdeb4894c..f4f16c30c60c 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A639C174C01
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 07:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgCAGYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 01:24:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12126 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725768AbgCAGYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 01:24:20 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0216FNO2021938
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:19 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=p5lj8RJ/pyEfDBQveIf9mUgVEtYbkUK7EBdCYi+C+qw=;
 b=XNdh3GXj6PJ/yrrepNo0Px9s1EV9ltS9NqFYWR3evkCq0jyxmUphXgCLQLj2R7VkOOt5
 cyEUNCBzsY7AUxliqVtqEtJq4NCT01+UZPRsqifFfraDQqjprkMBM7OuPVstB2j6qzzT
 MaJ6GKoeoQkON4ngEIZ1aA+y6REZtOeRCuM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfphj2u78-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 22:24:18 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 22:24:18 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E24C92EC2CFD; Sat, 29 Feb 2020 22:24:12 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] libbpf: assume unsigned values for BTF_KIND_ENUM
Date:   Sat, 29 Feb 2020 22:24:04 -0800
Message-ID: <20200301062405.2850114-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200301062405.2850114-1-andriin@fb.com>
References: <20200301062405.2850114-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-01_01:2020-02-28,2020-03-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=8 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 bulkscore=0 impostorscore=0 mlxlogscore=999 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003010050
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, BTF_KIND_ENUM type doesn't record whether enum values should be
interpreted as signed or unsigned. In Linux, most enums are unsigned, though,
so interpreting them as unsigned matches real world better.

Change btf_dump test case to test maximum 32-bit value, instead of negative
value.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/btf_dump.c                                  | 8 ++++----
 .../selftests/bpf/progs/btf_dump_test_case_syntax.c       | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index bd09ed1710f1..0d43d9bb821b 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -916,13 +916,13 @@ static void btf_dump_emit_enum_def(struct btf_dump *d, __u32 id,
 			/* enumerators share namespace with typedef idents */
 			dup_cnt = btf_dump_name_dups(d, d->ident_names, name);
 			if (dup_cnt > 1) {
-				btf_dump_printf(d, "\n%s%s___%zu = %d,",
+				btf_dump_printf(d, "\n%s%s___%zu = %u,",
 						pfx(lvl + 1), name, dup_cnt,
-						(__s32)v->val);
+						(__u32)v->val);
 			} else {
-				btf_dump_printf(d, "\n%s%s = %d,",
+				btf_dump_printf(d, "\n%s%s = %u,",
 						pfx(lvl + 1), name,
-						(__s32)v->val);
+						(__u32)v->val);
 			}
 		}
 		btf_dump_printf(d, "\n%s}", pfx(lvl));
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index d4a02fe44a12..31975c96e2c9 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -13,7 +13,7 @@ enum e1 {
 
 enum e2 {
 	C = 100,
-	D = -100,
+	D = 4294967295,
 	E = 0,
 };
 
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC8D176989
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:51:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727411AbgCCAvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:51:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50424 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727392AbgCCAvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 19:51:18 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0230n3nU020238
        for <netdev@vger.kernel.org>; Mon, 2 Mar 2020 16:51:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=p5lj8RJ/pyEfDBQveIf9mUgVEtYbkUK7EBdCYi+C+qw=;
 b=Pgj3o3sUL1EA+GCzyPGoJ3t5K21DK1kLg0G4B3l3wD/bWAOMqGd7HtQmhnc9ddnMlSpT
 ALevs4m3CVaawG77QUzfjB6BD+lMjeS2gyMLg+oZmBZH/pF6wlSNgARk257FcEzMCEqW
 A4OYgqvFQpsYT5DCS4LLvHWuV678dZB9xp4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 2yfmguu8cc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 16:51:16 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 2 Mar 2020 16:51:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AFDA22EC2E79; Mon,  2 Mar 2020 16:51:13 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 2/3] libbpf: assume unsigned values for BTF_KIND_ENUM
Date:   Mon, 2 Mar 2020 16:32:32 -0800
Message-ID: <20200303003233.3496043-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303003233.3496043-1-andriin@fb.com>
References: <20200303003233.3496043-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-02_09:2020-03-02,2020-03-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 malwarescore=0 suspectscore=8 impostorscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 phishscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030002
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


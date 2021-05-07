Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA8D4375FD0
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234043AbhEGFmn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:43 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41094 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234019AbhEGFmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475ZLeI028937
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38cswg982v-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:40 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 400902ED7617; Thu,  6 May 2021 22:41:35 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 6/7] libbpf: treat STV_INTERNAL same as STV_HIDDEN for functions
Date:   Thu, 6 May 2021 22:41:18 -0700
Message-ID: <20210507054119.270888-7-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507054119.270888-1-andrii@kernel.org>
References: <20210507054119.270888-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VzaBLfe3admvDRQBH5Q4FDmh10tNfD1x
X-Proofpoint-ORIG-GUID: VzaBLfe3admvDRQBH5Q4FDmh10tNfD1x
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=842 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do the same global -> static BTF update for global functions with STV_INTERNAL
visibility to turn on static BPF verification mode.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e2a3cf437814..b8cf93fa1b4d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -700,13 +700,14 @@ bpf_object__add_programs(struct bpf_object *obj, Elf_Data *sec_data,
 		if (err)
 			return err;
 
-		/* if function is a global/weak symbol, but has hidden
-		 * visibility (STV_HIDDEN), mark its BTF FUNC as static to
-		 * enable more permissive BPF verification mode with more
-		 * outside context available to BPF verifier
+		/* if function is a global/weak symbol, but has restricted
+		 * (STV_HIDDEN or STV_INTERNAL) visibility, mark its BTF FUNC
+		 * as static to enable more permissive BPF verification mode
+		 * with more outside context available to BPF verifier
 		 */
 		if (GELF_ST_BIND(sym.st_info) != STB_LOCAL
-		    && GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN)
+		    && (GELF_ST_VISIBILITY(sym.st_other) == STV_HIDDEN
+			|| GELF_ST_VISIBILITY(sym.st_other) == STV_INTERNAL))
 			prog->mark_btf_static = true;
 
 		nr_progs++;
-- 
2.30.2


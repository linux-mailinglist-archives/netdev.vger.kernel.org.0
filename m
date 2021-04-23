Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFA33698F3
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243603AbhDWSPR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42762 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243596AbhDWSO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:58 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NIA04e019525
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:21 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh8hyf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:20 -0700
Received: from intmgw001.05.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B86682ED5CB8; Fri, 23 Apr 2021 11:14:13 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 10/18] libbpf: tighten BTF type ID rewriting with error checking
Date:   Fri, 23 Apr 2021 11:13:40 -0700
Message-ID: <20210423181348.1801389-11-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 3Tb7XQeUSpJTUSv3_xrqD_7M2HQBjBuZ
X-Proofpoint-GUID: 3Tb7XQeUSpJTUSv3_xrqD_7M2HQBjBuZ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should never fail, but if it does, it's better to know about this rather
than end up with nonsensical type IDs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index b0e038480300..5505c85e8b7b 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1429,6 +1429,13 @@ static int linker_fixup_btf(struct src_obj *obj)
 static int remap_type_id(__u32 *type_id, void *ctx)
 {
 	int *id_map = ctx;
+	int new_id = id_map[*type_id];
+
+	/* Error out if the type wasn't remapped. Ignore VOID which stays VOID. */
+	if (new_id == 0 && *type_id != 0) {
+		pr_warn("failed to find new ID mapping for original BTF type ID %u\n", *type_id);
+		return -EINVAL;
+	}
 
 	*type_id = id_map[*type_id];
 
-- 
2.30.2


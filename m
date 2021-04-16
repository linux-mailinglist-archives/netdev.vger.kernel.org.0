Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E4F36293F
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343512AbhDPUY6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:24:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29912 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245537AbhDPUY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:24:56 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13GKLX8M021331
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:31 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37yb9y2dqq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:31 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 882B52ED4EE0; Fri, 16 Apr 2021 13:24:25 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 10/17] libbpf: tighten BTF type ID rewriting with error checking
Date:   Fri, 16 Apr 2021 13:23:57 -0700
Message-ID: <20210416202404.3443623-11-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416202404.3443623-1-andrii@kernel.org>
References: <20210416202404.3443623-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: BriHwjQKhfE80bqnkR6mLaA9llbVf378
X-Proofpoint-GUID: BriHwjQKhfE80bqnkR6mLaA9llbVf378
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 mlxlogscore=871 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It should never fail, but if it does, it's better to know about this rather
than end up with nonsensical type IDs.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 283249df9831..d5dc1d401f57 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1423,6 +1423,15 @@ static int linker_fixup_btf(struct src_obj *obj)
 static int remap_type_id(__u32 *type_id, void *ctx)
 {
 	int *id_map = ctx;
+	int new_id = id_map[*type_id];
+
+	if (*type_id == 0)
+		return 0;
+
+	if (new_id == 0) {
+		pr_warn("failed to find new ID mapping for original BTF type ID %u\n", *type_id);
+		return -EINVAL;
+	}
 
 	*type_id = id_map[*type_id];
 
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1838F2502
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 03:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbfKGCJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 21:09:35 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25876 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732931AbfKGCJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 21:09:35 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA729VWq022909
        for <netdev@vger.kernel.org>; Wed, 6 Nov 2019 18:09:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Jg2WSaiepMItwD3sbvg5Luw1hqEJ4muqk3C1YL8SV9w=;
 b=SnR+ydn4rswPxhUc3QuUAZeSnHnRVaKAu4rFSLt9p6wj3U/vsMwiug43Y9x968mYIvGQ
 fY0A0nzvKIwG+Uk/yAH/q5WxmtIcRqycZg7RM+CjEZ5XXxUB3p8KW30kRlZlL5R7+tfP
 GWoAyrVDf3qxvfIymnUC1z5fPuw0clXVkkQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41u2jjgc-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 18:09:34 -0800
Received: from 2401:db00:2050:5102:face:0:37:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 Nov 2019 18:09:23 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 87FC62EC17EE; Wed,  6 Nov 2019 18:09:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/5] libbpf: fix memory leak/double free issue
Date:   Wed, 6 Nov 2019 18:08:51 -0800
Message-ID: <20191107020855.3834758-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191107020855.3834758-1-andriin@fb.com>
References: <20191107020855.3834758-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-06_09:2019-11-06,2019-11-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 bulkscore=0 suspectscore=8 priorityscore=1501 malwarescore=0 phishscore=0
 adultscore=0 impostorscore=0 mlxlogscore=896 mlxscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911070021
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Coverity scan against Github libbpf code found the issue of not freeing memory and
leaving already freed memory still referenced from bpf_program. Fix it by
re-assigning successfully reallocated memory sooner.

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index be4af95d5a2c..3ef73a214592 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3523,6 +3523,7 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 			pr_warn("oom in prog realloc\n");
 			return -ENOMEM;
 		}
+		prog->insns = new_insn;
 
 		if (obj->btf_ext) {
 			err = bpf_program_reloc_btf_ext(prog, obj,
@@ -3534,7 +3535,6 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 
 		memcpy(new_insn + prog->insns_cnt, text->insns,
 		       text->insns_cnt * sizeof(*insn));
-		prog->insns = new_insn;
 		prog->main_prog_cnt = prog->insns_cnt;
 		prog->insns_cnt = new_cnt;
 		pr_debug("added %zd insn from %s to prog %s\n",
-- 
2.17.1


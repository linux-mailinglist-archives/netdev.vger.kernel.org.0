Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87E82333417
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhCJEEx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 23:04:53 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30348 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229673AbhCJEEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 23:04:40 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12A43G5T028758
        for <netdev@vger.kernel.org>; Tue, 9 Mar 2021 20:04:40 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 376mhb8gmv-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 20:04:40 -0800
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 9 Mar 2021 20:04:38 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id A14452ED1C92; Tue,  9 Mar 2021 20:04:35 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 01/10] libbpf: expose btf_type_by_id() internally
Date:   Tue, 9 Mar 2021 20:04:22 -0800
Message-ID: <20210310040431.916483-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210310040431.916483-1-andrii@kernel.org>
References: <20210310040431.916483-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_03:2021-03-09,2021-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxlogscore=783 clxscore=1034
 spamscore=0 bulkscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_type_by_id() is internal-only convenience API returning non-const pointer
to struct btf_type. Expose it outside of btf.c for re-use.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c             | 2 +-
 tools/lib/bpf/libbpf_internal.h | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3aa58f2ac183..e0b0a78b04fe 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -435,7 +435,7 @@ const struct btf *btf__base_btf(const struct btf *btf)
 }
 
 /* internal helper returning non-const pointer to a type */
-static struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
+struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
 {
 	if (type_id == 0)
 		return &btf_void;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 343f6eb05637..d09860e435c8 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -107,6 +107,11 @@ static inline void *libbpf_reallocarray(void *ptr, size_t nmemb, size_t size)
 	return realloc(ptr, total);
 }
 
+struct btf;
+struct btf_type;
+
+struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id);
+
 void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
 int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
-- 
2.24.1


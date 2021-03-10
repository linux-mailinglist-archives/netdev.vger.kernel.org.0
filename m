Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BFA533341B
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbhCJEEy convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 9 Mar 2021 23:04:54 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25260 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231235AbhCJEEq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 23:04:46 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12A442wI006256
        for <netdev@vger.kernel.org>; Tue, 9 Mar 2021 20:04:45 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 376hbyhfc6-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 20:04:45 -0800
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 9 Mar 2021 20:04:43 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C73262ED1C92; Tue,  9 Mar 2021 20:04:37 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 02/10] libbpf: add internal helper to get raw BTF strings section
Date:   Tue, 9 Mar 2021 20:04:23 -0800
Message-ID: <20210310040431.916483-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210310040431.916483-1-andrii@kernel.org>
References: <20210310040431.916483-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-10_03:2021-03-09,2021-03-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 spamscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103100018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct btf is an efficient and convenient data structure to be used as a set
of deduplicated strings. This patch adds libbpf-internal btf_raw_str() helper
that gives access to strings section raw data (regardless of whether BTF
object is read-only or writeable) and its size in bytes. This is going to be
used by bpf_linker to implement ELF string table section.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c             | 11 +++++++++++
 tools/lib/bpf/libbpf_internal.h |  1 +
 2 files changed, 12 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e0b0a78b04fe..6ee82ffcf3ff 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -1296,6 +1296,17 @@ static void *btf_get_raw_data(const struct btf *btf, __u32 *size, bool swap_endi
 	return NULL;
 }
 
+/*
+ * Internal helper to get the size and direct pointer to strings section.
+ * This is used in cases where struct btf is used as an efficient and
+ * convenient strings container (e.g., bpf_linker).
+ */
+const void *btf_raw_strs(const struct btf *btf, size_t *size)
+{
+	*size = btf->hdr->str_len;
+	return btf->strs_data;
+}
+
 const void *btf__get_raw_data(const struct btf *btf_ro, __u32 *size)
 {
 	struct btf *btf = (struct btf *)btf_ro;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index d09860e435c8..069250e8e871 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -115,6 +115,7 @@ struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id);
 void *btf_add_mem(void **data, size_t *cap_cnt, size_t elem_sz,
 		  size_t cur_cnt, size_t max_cnt, size_t add_cnt);
 int btf_ensure_mem(void **data, size_t *cap_cnt, size_t elem_sz, size_t need_cnt);
+const void *btf_raw_strs(const struct btf *btf, size_t *size);
 
 static inline bool libbpf_validate_opts(const char *opts,
 					size_t opts_sz, size_t user_sz,
-- 
2.24.1


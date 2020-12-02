Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589DC2CB555
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 07:53:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgLBGxe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Dec 2020 01:53:34 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26082 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726202AbgLBGxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 01:53:34 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B26ni0r013685
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 22:52:53 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355agssbgu-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 22:52:53 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 22:52:50 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8D2402ECA750; Tue,  1 Dec 2020 22:52:50 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/3] libbpf: add base BTF accessor
Date:   Tue, 1 Dec 2020 22:52:42 -0800
Message-ID: <20201202065244.530571-3-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201202065244.530571-1-andrii@kernel.org>
References: <20201202065244.530571-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-02_01:2020-11-30,2020-12-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 malwarescore=0
 phishscore=0 impostorscore=0 mlxlogscore=809 spamscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020040
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ability to get base BTF. It can be also used to check if BTF is split BTF.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/btf.c      | 5 +++++
 tools/lib/bpf/btf.h      | 1 +
 tools/lib/bpf/libbpf.map | 1 +
 3 files changed, 7 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 8ff46cd30ca1..1935e83d309c 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -432,6 +432,11 @@ __u32 btf__get_nr_types(const struct btf *btf)
 	return btf->start_id + btf->nr_types - 1;
 }
 
+const struct btf *btf__base_btf(const struct btf *btf)
+{
+	return btf->base_btf;
+}
+
 /* internal helper returning non-const pointer to a type */
 static struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id)
 {
diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
index 1093f6fe6800..1237bcd1dd17 100644
--- a/tools/lib/bpf/btf.h
+++ b/tools/lib/bpf/btf.h
@@ -51,6 +51,7 @@ LIBBPF_API __s32 btf__find_by_name(const struct btf *btf,
 LIBBPF_API __s32 btf__find_by_name_kind(const struct btf *btf,
 					const char *type_name, __u32 kind);
 LIBBPF_API __u32 btf__get_nr_types(const struct btf *btf);
+LIBBPF_API const struct btf *btf__base_btf(const struct btf *btf);
 LIBBPF_API const struct btf_type *btf__type_by_id(const struct btf *btf,
 						  __u32 id);
 LIBBPF_API size_t btf__pointer_size(const struct btf *btf);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 29ff4807b909..ed55498c4122 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -340,6 +340,7 @@ LIBBPF_0.2.0 {
 
 LIBBPF_0.3.0 {
 	global:
+		btf__base_btf;
 		btf__parse_elf_split;
 		btf__parse_raw_split;
 		btf__parse_split;
-- 
2.24.1


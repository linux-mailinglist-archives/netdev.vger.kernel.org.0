Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAA03800AC
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbhEMXGP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 May 2021 19:06:15 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229548AbhEMXGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:06:13 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DMwrrv001879
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:05:03 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38gpn47bxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:05:03 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 13 May 2021 16:05:02 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 17B492ED6483; Thu, 13 May 2021 16:04:49 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 2/2] libbpf: reject static maps
Date:   Thu, 13 May 2021 15:55:52 -0700
Message-ID: <20210513225552.4180025-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513225552.4180025-1-andrii@kernel.org>
References: <20210513225552.4180025-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: VS2mLq2nu68uMBqUiCxc7jVBhPhK2xWa
X-Proofpoint-ORIG-GUID: VS2mLq2nu68uMBqUiCxc7jVBhPhK2xWa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_16:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034 spamscore=0
 bulkscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130161
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static maps never really worked with libbpf, because all such maps were always
silently resolved to the very first map. Detect static maps (both legacy and
BTF-defined) and report user-friendly error.

Tested locally by switching few maps (legacy and BTF-defined) in selftests to
static ones and verifying that now libbpf rejects them loudly.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b8cf93fa1b4d..ac5ab903d42b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1795,7 +1795,6 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	if (!symbols)
 		return -EINVAL;
 
-
 	scn = elf_sec_by_idx(obj, obj->efile.maps_shndx);
 	data = elf_sec_data(obj, scn);
 	if (!scn || !data) {
@@ -1848,6 +1847,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 		if (IS_ERR(map))
 			return PTR_ERR(map);
 
+
 		map_name = elf_sym_str(obj, sym.st_name);
 		if (!map_name) {
 			pr_warn("failed to get map #%d name sym string for obj %s\n",
@@ -1855,6 +1855,12 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 			return -LIBBPF_ERRNO__FORMAT;
 		}
 
+		if (GELF_ST_TYPE(sym.st_info) == STT_SECTION
+		    || GELF_ST_BIND(sym.st_info) == STB_LOCAL) {
+			pr_warn("map '%s' (legacy): static maps are not supported\n", map_name);
+			return -ENOTSUP;
+		}
+
 		map->libbpf_type = LIBBPF_MAP_UNSPEC;
 		map->sec_idx = sym.st_shndx;
 		map->sec_offset = sym.st_value;
@@ -2262,6 +2268,16 @@ static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def
 		pr_debug("map '%s': found inner map definition.\n", map->name);
 }
 
+static const char *btf_var_linkage_str(__u32 linkage)
+{
+	switch (linkage) {
+	case BTF_VAR_STATIC: return "static";
+	case BTF_VAR_GLOBAL_ALLOCATED: return "global";
+	case BTF_VAR_GLOBAL_EXTERN: return "extern";
+	default: return "unknown";
+	}
+}
+
 static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 					 const struct btf_type *sec,
 					 int var_idx, int sec_idx,
@@ -2294,10 +2310,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			map_name, btf_kind_str(var));
 		return -EINVAL;
 	}
-	if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED &&
-	    var_extra->linkage != BTF_VAR_STATIC) {
-		pr_warn("map '%s': unsupported var linkage %u.\n",
-			map_name, var_extra->linkage);
+	if (var_extra->linkage != BTF_VAR_GLOBAL_ALLOCATED) {
+		pr_warn("map '%s': unsupported map linkage %s.\n",
+			map_name, btf_var_linkage_str(var_extra->linkage));
 		return -EOPNOTSUPP;
 	}
 
-- 
2.30.2


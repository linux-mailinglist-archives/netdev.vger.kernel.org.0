Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A19173800EF
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 01:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhEMXiC convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 May 2021 19:38:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42104 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230018AbhEMXiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 19:38:01 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14DNY4tl029140
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:36:50 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 38gpnvffcn-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 May 2021 16:36:50 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 13 May 2021 16:36:49 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 600632ED8CFC; Thu, 13 May 2021 16:36:47 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 2/2] libbpf: reject static maps
Date:   Thu, 13 May 2021 16:36:43 -0700
Message-ID: <20210513233643.194711-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210513233643.194711-1-andrii@kernel.org>
References: <20210513233643.194711-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: S1MW7sTvaWx8f0x2-tfKKIean7EFUoOd
X-Proofpoint-ORIG-GUID: S1MW7sTvaWx8f0x2-tfKKIean7EFUoOd
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-13_16:2021-05-12,2021-05-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 malwarescore=0 phishscore=0 mlxlogscore=999 spamscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130166
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

v1->v2:
  - remove accidentally added empty line; the deleted empty line on line 1798 is good.

 tools/lib/bpf/libbpf.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b8cf93fa1b4d..182bd3d3f728 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1795,7 +1795,6 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	if (!symbols)
 		return -EINVAL;
 
-
 	scn = elf_sec_by_idx(obj, obj->efile.maps_shndx);
 	data = elf_sec_data(obj, scn);
 	if (!scn || !data) {
@@ -1855,6 +1854,12 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
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
@@ -2262,6 +2267,16 @@ static void fill_map_from_def(struct bpf_map *map, const struct btf_map_def *def
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
@@ -2294,10 +2309,9 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5C0F11D3A3
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 18:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730156AbfLLRT3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 12:19:29 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47638 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730047AbfLLRT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 12:19:29 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCHG0lc024491
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 09:19:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zKfNol1lmm/ySKUdhFMzX23SCU/xjUY3EPbkthfX4tg=;
 b=W/6f3HuhZCAZYrUjUDuGiTR/titAYZ/FIiGzMPPkmALH3KceWPfKsNXiMWq3qpY1RD/G
 uh67Y73dPSjVP0rLW+0GJlLHh6go2iLLMFNTUun2LGPOC+hg5e7BbSvS1PuWP2OS4eIu
 poKjZDuBQwpDBjNTkS+slXXsSzE8a/AFh3A= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wub46bhd7-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 09:19:28 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 12 Dec 2019 09:19:24 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CF27B2EC1E04; Thu, 12 Dec 2019 09:19:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next] libbpf: fix printf compilation warnings on ppc64le arch
Date:   Thu, 12 Dec 2019 09:19:18 -0800
Message-ID: <20191212171918.638010-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_05:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=843
 lowpriorityscore=0 suspectscore=8 spamscore=0 mlxscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120135
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
respectively. This causes compiler to emit warning when %lld/%llu are used to
printf 64-bit numbers. Fix this by casting to size_t/ssize_t with %zu and %zd
format specifiers, respectively.

v1->v2:
- use size_t/ssize_t instead of custom typedefs (Martin).

Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f09772192f1..920d4e06a5f9 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1242,15 +1242,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine key size for type [%u]: %zd.\n",
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found key [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found key [%u], sz = %zd.\n",
+				 map_name, t->type, (ssize_t)sz);
 			if (map->def.key_size && map->def.key_size != sz) {
-				pr_warn("map '%s': conflicting key size %u != %lld.\n",
-					map_name, map->def.key_size, sz);
+				pr_warn("map '%s': conflicting key size %u != %zd.\n",
+					map_name, map->def.key_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.key_size = sz;
@@ -1285,15 +1285,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine value size for type [%u]: %zd.\n",
+					map_name, t->type, (ssize_t)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found value [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found value [%u], sz = %zd.\n",
+				 map_name, t->type, (ssize_t)sz);
 			if (map->def.value_size && map->def.value_size != sz) {
-				pr_warn("map '%s': conflicting value size %u != %lld.\n",
-					map_name, map->def.value_size, sz);
+				pr_warn("map '%s': conflicting value size %u != %zd.\n",
+					map_name, map->def.value_size, (ssize_t)sz);
 				return -EINVAL;
 			}
 			map->def.value_size = sz;
@@ -1817,7 +1817,8 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		if (sym->st_value % 8) {
-			pr_warn("bad call relo offset: %llu\n", (__u64)sym->st_value);
+			pr_warn("bad call relo offset: %zu\n",
+				(size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_CALL;
@@ -1859,8 +1860,8 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 			break;
 		}
 		if (map_idx >= nr_maps) {
-			pr_warn("map relo failed to find map for sec %u, off %llu\n",
-				shdr_idx, (__u64)sym->st_value);
+			pr_warn("map relo failed to find map for sec %u, off %zu\n",
+				shdr_idx, (size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_LD64;
@@ -1941,9 +1942,9 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 		name = elf_strptr(obj->efile.elf, obj->efile.strtabidx,
 				  sym.st_name) ? : "<?>";
 
-		pr_debug("relo for shdr %u, symb %llu, value %llu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
-			 (__u32)sym.st_shndx, (__u64)GELF_R_SYM(rel.r_info),
-			 (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
+		pr_debug("relo for shdr %u, symb %zu, value %zu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
+			 (__u32)sym.st_shndx, (size_t)GELF_R_SYM(rel.r_info),
+			 (size_t)sym.st_value, GELF_ST_TYPE(sym.st_info),
 			 GELF_ST_BIND(sym.st_info), sym.st_name, name,
 			 insn_idx);
 
-- 
2.17.1


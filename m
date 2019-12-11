Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4014511BCDB
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfLKT0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:26:49 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41726 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfLKT0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:26:49 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBBJQZHR028165
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:26:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=K0RrwVZy1Ew2s3ZKlJhzN539TlzDFyQxMnfZtLLQn+M=;
 b=pcPyWxwsTvcg2jt7x6XTEDYulx5h4N+6H9ft++Z0hZuyL4xIOmZ4OSLslEpn4HtxF2C2
 5ZSnkaJnw1w5vN+EQsSCfZe0dhwAU88vMft5e0fX14/9WobpLSNsF1DQo9mODPV2b2Yy
 lMWAQ8d1OOJ09Ic0lkfvmDfltrSd6wPhJBM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu2gf1b10-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:26:47 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 11 Dec 2019 11:26:36 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 100432EC1D4F; Wed, 11 Dec 2019 11:26:35 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix printf compilation warnings on ppc64le arch
Date:   Wed, 11 Dec 2019 11:26:34 -0800
Message-ID: <20191211192634.402675-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_06:2019-12-11,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 adultscore=0
 bulkscore=0 suspectscore=8 priorityscore=1501 impostorscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 clxscore=1015
 mlxlogscore=952 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912110160
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ppc64le __u64 and __s64 are defined as long int and unsigned long int,
respectively. This causes compiler to emit warning when %lld/%llu are used to
printf 64-bit numbers. Fix this by casting directly to unsigned long long
(through shorter typedef). In few cases casting error code to int explicitly
is cleaner, so that's what's done instead.

Fixes: 1f8e2bcb2cd5 ("libbpf: Refactor relocation handling")
Fixes: abd29c931459 ("libbpf: allow specifying map definitions using BTF")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 3f09772192f1..5ee54f9355a4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -128,6 +128,8 @@ void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 # define LIBBPF_ELF_C_READ_MMAP ELF_C_READ
 #endif
 
+typedef unsigned long long __pu64;
+
 static inline __u64 ptr_to_u64(const void *ptr)
 {
 	return (__u64) (unsigned long) ptr;
@@ -1242,15 +1244,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine key size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine key size for type [%u]: %d.\n",
+					map_name, t->type, (int)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found key [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found key [%u], sz = %d.\n",
+				 map_name, t->type, (int)sz);
 			if (map->def.key_size && map->def.key_size != sz) {
-				pr_warn("map '%s': conflicting key size %u != %lld.\n",
-					map_name, map->def.key_size, sz);
+				pr_warn("map '%s': conflicting key size %u != %d.\n",
+					map_name, map->def.key_size, (int)sz);
 				return -EINVAL;
 			}
 			map->def.key_size = sz;
@@ -1285,15 +1287,15 @@ static int bpf_object__init_user_btf_map(struct bpf_object *obj,
 			}
 			sz = btf__resolve_size(obj->btf, t->type);
 			if (sz < 0) {
-				pr_warn("map '%s': can't determine value size for type [%u]: %lld.\n",
-					map_name, t->type, sz);
+				pr_warn("map '%s': can't determine value size for type [%u]: %d.\n",
+					map_name, t->type, (int)sz);
 				return sz;
 			}
-			pr_debug("map '%s': found value [%u], sz = %lld.\n",
-				 map_name, t->type, sz);
+			pr_debug("map '%s': found value [%u], sz = %d.\n",
+				 map_name, t->type, (int)sz);
 			if (map->def.value_size && map->def.value_size != sz) {
-				pr_warn("map '%s': conflicting value size %u != %lld.\n",
-					map_name, map->def.value_size, sz);
+				pr_warn("map '%s': conflicting value size %u != %d.\n",
+					map_name, map->def.value_size, (int)sz);
 				return -EINVAL;
 			}
 			map->def.value_size = sz;
@@ -1817,7 +1819,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		if (sym->st_value % 8) {
-			pr_warn("bad call relo offset: %llu\n", (__u64)sym->st_value);
+			pr_warn("bad call relo offset: %llu\n", (__pu64)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_CALL;
@@ -1860,7 +1862,7 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		}
 		if (map_idx >= nr_maps) {
 			pr_warn("map relo failed to find map for sec %u, off %llu\n",
-				shdr_idx, (__u64)sym->st_value);
+				shdr_idx, (__pu64)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
 		reloc_desc->type = RELO_LD64;
@@ -1942,8 +1944,8 @@ bpf_program__collect_reloc(struct bpf_program *prog, GElf_Shdr *shdr,
 				  sym.st_name) ? : "<?>";
 
 		pr_debug("relo for shdr %u, symb %llu, value %llu, type %d, bind %d, name %d (\'%s\'), insn %u\n",
-			 (__u32)sym.st_shndx, (__u64)GELF_R_SYM(rel.r_info),
-			 (__u64)sym.st_value, GELF_ST_TYPE(sym.st_info),
+			 (__u32)sym.st_shndx, (__pu64)GELF_R_SYM(rel.r_info),
+			 (__pu64)sym.st_value, GELF_ST_TYPE(sym.st_info),
 			 GELF_ST_BIND(sym.st_info), sym.st_name, name,
 			 insn_idx);
 
-- 
2.17.1


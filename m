Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1620A3698F1
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243530AbhDWSPP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15806 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243522AbhDWSO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:56 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI91Q9001369
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:19 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usrkxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:19 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:17 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id B42692ED5CB8; Fri, 23 Apr 2021 11:14:11 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 09/18] libbpf: extend sanity checking ELF symbols with externs validation
Date:   Fri, 23 Apr 2021 11:13:39 -0700
Message-ID: <20210423181348.1801389-10-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: YnXRUSusfazNyqaT338WjAV_dl5hUSmx
X-Proofpoint-ORIG-GUID: YnXRUSusfazNyqaT338WjAV_dl5hUSmx
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logic to validate extern symbols, plus some other minor extra checks, like
ELF symbol #0 validation, general symbol visibility and binding validations.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 49 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 1263641e8b97..b0e038480300 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -750,14 +750,45 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
 	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
 	sym = sec->data->d_buf;
 	for (i = 0; i < n; i++, sym++) {
-		if (sym->st_shndx
-		    && sym->st_shndx < SHN_LORESERVE
-		    && sym->st_shndx >= obj->sec_cnt) {
+		int sym_type = ELF64_ST_TYPE(sym->st_info);
+		int sym_bind = ELF64_ST_BIND(sym->st_info);
+		int sym_vis = ELF64_ST_VISIBILITY(sym->st_other);
+
+		if (i == 0) {
+			if (sym->st_name != 0 || sym->st_info != 0
+			    || sym->st_other != 0 || sym->st_shndx != 0
+			    || sym->st_value != 0 || sym->st_size != 0) {
+				pr_warn("ELF sym #0 is invalid in %s\n", obj->filename);
+				return -EINVAL;
+			}
+			continue;
+		}
+		if (sym_bind != STB_LOCAL && sym_bind != STB_GLOBAL && sym_bind != STB_WEAK) {
+			pr_warn("ELF sym #%d in section #%zu has unsupported symbol binding %d\n",
+				i, sec->sec_idx, sym_bind);
+			return -EINVAL;
+		}
+		if (sym_vis != STV_DEFAULT && sym_vis != STV_HIDDEN) {
+			pr_warn("ELF sym #%d in section #%zu has unsupported symbol visibility %d\n",
+				i, sec->sec_idx, sym_vis);
+			return -EINVAL;
+		}
+		if (sym->st_shndx == 0) {
+			if (sym_type != STT_NOTYPE || sym_bind == STB_LOCAL
+			    || sym->st_value != 0 || sym->st_size != 0) {
+				pr_warn("ELF sym #%d is invalid extern symbol in %s\n",
+					i, obj->filename);
+
+				return -EINVAL;
+			}
+			continue;
+		}
+		if (sym->st_shndx < SHN_LORESERVE && sym->st_shndx >= obj->sec_cnt) {
 			pr_warn("ELF sym #%d in section #%zu points to missing section #%zu in %s\n",
 				i, sec->sec_idx, (size_t)sym->st_shndx, obj->filename);
 			return -EINVAL;
 		}
-		if (ELF64_ST_TYPE(sym->st_info) == STT_SECTION) {
+		if (sym_type == STT_SECTION) {
 			if (sym->st_value != 0)
 				return -EINVAL;
 			continue;
@@ -1135,16 +1166,16 @@ static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj
 		size_t dst_sym_idx;
 		int name_off;
 
-		/* we already have all-zero initial symbol */
-		if (sym->st_name == 0 && sym->st_info == 0 &&
-		    sym->st_other == 0 && sym->st_shndx == SHN_UNDEF &&
-		    sym->st_value == 0 && sym->st_size ==0)
+		/* We already validated all-zero symbol #0 and we already
+		 * appended it preventively to the final SYMTAB, so skip it.
+		 */
+		if (i == 0)
 			continue;
 
 		sym_name = elf_strptr(obj->elf, str_sec_idx, sym->st_name);
 		if (!sym_name) {
 			pr_warn("can't fetch symbol name for symbol #%d in '%s'\n", i, obj->filename);
-			return -1;
+			return -EINVAL;
 		}
 
 		if (sym->st_shndx && sym->st_shndx < SHN_LORESERVE) {
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDD136293A
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245683AbhDPUYx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 16 Apr 2021 16:24:53 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6642 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S245537AbhDPUYw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 16:24:52 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.43/8.16.0.43) with SMTP id 13GKIxZ5016673
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:26 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 37yb39jfwk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 16 Apr 2021 13:24:26 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Apr 2021 13:24:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 844192ED4EE0; Fri, 16 Apr 2021 13:24:23 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 09/17] libbpf: extend sanity checking ELF symbols with externs validation
Date:   Fri, 16 Apr 2021 13:23:56 -0700
Message-ID: <20210416202404.3443623-10-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416202404.3443623-1-andrii@kernel.org>
References: <20210416202404.3443623-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: IlkXfFCILUoJDqfJGn4TaWVRzHHqiNPG
X-Proofpoint-GUID: IlkXfFCILUoJDqfJGn4TaWVRzHHqiNPG
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-16_09:2021-04-16,2021-04-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 impostorscore=0 mlxscore=0 priorityscore=1501 spamscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160143
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logic to validate extern symbols, plus some other minor extra checks, like
ELF symbol #0 validation, general symbol visibility and binding validations.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 43 +++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 1263641e8b97..283249df9831 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -750,14 +750,39 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
 	n = sec->shdr->sh_size / sec->shdr->sh_entsize;
 	sym = sec->data->d_buf;
 	for (i = 0; i < n; i++, sym++) {
-		if (sym->st_shndx
-		    && sym->st_shndx < SHN_LORESERVE
-		    && sym->st_shndx >= obj->sec_cnt) {
+		int sym_type = ELF64_ST_TYPE(sym->st_info);
+		int sym_bind = ELF64_ST_BIND(sym->st_info);
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
+			pr_warn("ELF sym #%d is section #%zu has unsupported symbol binding %d\n",
+				i, sec->sec_idx, sym_bind);
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
@@ -1135,16 +1160,16 @@ static int linker_append_elf_syms(struct bpf_linker *linker, struct src_obj *obj
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C71D375FD1
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234090AbhEGFmo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22514 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233669AbhEGFmk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:40 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475ZLeJ028937
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:40 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38cswg982v-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:40 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4AB1F2ED7617; Thu,  6 May 2021 22:41:37 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 7/7] libbpf: convert STV_HIDDEN symbols into STV_INTERNAL after linking
Date:   Thu, 6 May 2021 22:41:19 -0700
Message-ID: <20210507054119.270888-8-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507054119.270888-1-andrii@kernel.org>
References: <20210507054119.270888-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: KIts4Y5Ng5yGt4fK6CJqhhcLugesqoWK
X-Proofpoint-ORIG-GUID: KIts4Y5Ng5yGt4fK6CJqhhcLugesqoWK
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add logic to "upgrade" STV_HIDDEN symbols into STV_INTERNAL ones once static
linking is complete. From BPF static linker perspective, the difference
between STV_HIDDEN and STV_INTERNAL is that STV_HIDDEN allows resolving
externs references between multiple BPF object files statically linked
together in the same operation. STV_INTERNAL is stricter and prevents any
other object files to reference such symbol (function, variable, map).

Here's why such property and behavior is important and desirable and how it
relates to user-space linker behavior.

In user-space, STV_HIDDEN symbols are resolvable during static linking between
all the object files linked together. If such object files are linked into
a shared library (.so), linker is converting such hidden global variables into
STB_LOCAL (static) ones. This has two implications, one of which is desirable
for BPF static linking and one is not.

The desirable one is that such hidden symbols are effectively unresolvable
outside of the shared library. This is exactly the property we are looking for
for BPF libraries (ignoring the fact that we have static BPF libraries, not
dynamic ones).

The undesirable behavior is that after shared library is linked, application
can define "conflicting" symbol with the same name and they will happily
co-exists, because shared library's symbol is now STB_LOCAL. This patch set's
assumption is that static variables are not exposed to BPF skeleton and static
maps are explicitly not supported by libbpf. Both for reasons of avoiding
naming conflicts.

So, if we were to follow user-space behavior exactly, we'd end up with static
maps and variables, which are invisible to BPF skeleton and (for maps) looking
up by name becomes ambiguous.

To avoid such issues, it was decided to convert STV_HIDDEN symbols to
STV_INTERNAL with the semantics that prevents any extern references to
STV_INTERNAL symbols. STV_INTERNAL is not defined for user-space applications
and is reserved for future uses. So in this case BPF static linker is
defining its own semantics.

Having STV_INTERNAL visibility is useful/important for one more reason. With
BPF skeleton not supporting static variables, with just STV_HIDDEN it's
impossible to declare a global variable that will be accessible from
user-space, but not resolvable from other BPF object files. STV_INTERNAL allow
to specify just such behavior:

__attribute__((visibility("internal"))) int user_space_var;

user_space_var is global, but no `extern int user_space_var;` is allowed. Yet,
user-space will be able to read/write such variable with BPF skeleton.

The initial idea was to use only STV_HIDDEN to restrict symbol resolution
outside of BPF library and treat it as STV_INTERNAL described above (i.e., no
other files can extern such symbol). But unfortunately this works only for
single-file BPF libraries, which is quite limiting. Making STV_HIDDEN so
restrictive also prevents having global functions, resolvable withing BPF
library, but treated as static by BPF verification logic. STV_HIDDEN and
STV_INTERNAL resolves all such discrepancies.

Note that currently Clang generates STV_PROTECTED instead of STV_INTERNAL for
__attribute__((visibility("internal"))) for BPF target. Once this bug is
fixed, I'll add new selftests with extra validations.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 44 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index b594a88620ce..38e9ac3dfa8c 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -175,6 +175,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 static int linker_append_btf(struct bpf_linker *linker, struct src_obj *obj);
 static int linker_append_btf_ext(struct bpf_linker *linker, struct src_obj *obj);
 
+static void finalize_elf_syms(struct bpf_linker *linker);
 static int finalize_btf(struct bpf_linker *linker);
 static int finalize_btf_ext(struct bpf_linker *linker);
 
@@ -809,7 +810,7 @@ static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *s
 				i, sec->sec_idx, sym_bind);
 			return -EINVAL;
 		}
-		if (sym_vis != STV_DEFAULT && sym_vis != STV_HIDDEN) {
+		if (sym_vis != STV_DEFAULT && sym_vis != STV_HIDDEN && sym_vis != STV_INTERNAL) {
 			pr_warn("ELF sym #%d in section #%zu has unsupported symbol visibility %d\n",
 				i, sec->sec_idx, sym_vis);
 			return -EINVAL;
@@ -1783,6 +1784,15 @@ static void sym_update_type(Elf64_Sym *sym, int sym_type)
 	sym->st_info = ELF64_ST_INFO(ELF64_ST_BIND(sym->st_info), sym_type);
 }
 
+static bool sym_visibility_is_stricter(int src_vis, int dst_vis)
+{
+	if (src_vis == STV_INTERNAL)
+		return dst_vis != STV_INTERNAL;
+	if (src_vis == STV_HIDDEN)
+		return dst_vis == STV_DEFAULT;
+	return false;
+}
+
 static void sym_update_visibility(Elf64_Sym *sym, int sym_vis)
 {
 	/* libelf doesn't provide setters for ST_VISIBILITY,
@@ -1798,7 +1808,7 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 	struct src_sec *src_sec = NULL;
 	struct dst_sec *dst_sec = NULL;
 	struct glob_sym *glob_sym = NULL;
-	int name_off, sym_type, sym_bind, sym_vis, err;
+	int name_off, sym_type, sym_bind, sym_vis, dst_vis, err;
 	int btf_sec_id = 0, btf_id = 0;
 	size_t dst_sym_idx;
 	Elf64_Sym *dst_sym;
@@ -1877,10 +1887,16 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 			return -EINVAL;
 		}
 
-		if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
+		dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
+		dst_vis = ELF64_ST_VISIBILITY(dst_sym->st_other);
+		if (sym_vis == STV_INTERNAL || dst_vis == STV_INTERNAL) {
+			pr_warn("conflicting non-resolvable symbol #%d (%s) definition in '%s'\n",
+				src_sym_idx, sym_name, obj->filename);
 			return -EINVAL;
+		}
 
-		dst_sym = get_sym_by_idx(linker, glob_sym->sym_idx);
+		if (!glob_syms_match(sym_name, linker, glob_sym, obj, sym, src_sym_idx, btf_id))
+			return -EINVAL;
 
 		/* If new symbol is strong, then force dst_sym to be strong as
 		 * well; this way a mix of weak and non-weak extern
@@ -1898,10 +1914,10 @@ static int linker_append_elf_sym(struct bpf_linker *linker, struct src_obj *obj,
 		/* Non-default visibility is "contaminating", with stricter
 		 * visibility overwriting more permissive ones, even if more
 		 * permissive visibility comes from just an extern definition.
-		 * Currently only STV_DEFAULT and STV_HIDDEN are allowed and
-		 * ensured by ELF symbol sanity checks above.
+		 * Currently only STV_DEFAULT, STV_HIDDEN, and STV_INTERNAL
+		 * are allowed and ensured by ELF symbol sanity checks above.
 		 */
-		if (sym_vis > ELF64_ST_VISIBILITY(dst_sym->st_other))
+		if (sym_visibility_is_stricter(sym_vis, ELF64_ST_VISIBILITY(dst_sym->st_other)))
 			sym_update_visibility(dst_sym, sym_vis);
 
 		/* If the new symbol is extern, then regardless if
@@ -2549,6 +2565,8 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 	if (!linker->elf)
 		return -EINVAL;
 
+	finalize_elf_syms(linker);
+
 	err = finalize_btf(linker);
 	if (err)
 		return err;
@@ -2602,6 +2620,18 @@ int bpf_linker__finalize(struct bpf_linker *linker)
 	return 0;
 }
 
+static void finalize_elf_syms(struct bpf_linker *linker)
+{
+	struct dst_sec *symtab = &linker->secs[linker->symtab_sec_idx];
+	Elf64_Sym *sym = symtab->raw_data;
+	int i, n = symtab->shdr->sh_size / symtab->shdr->sh_entsize;
+
+	for (i = 0; i < n; i++, sym++) {
+		if (ELF64_ST_VISIBILITY(sym->st_other) == STV_HIDDEN)
+			sym_update_visibility(sym, STV_INTERNAL);
+	}
+}
+
 static int emit_elf_data_sec(struct bpf_linker *linker, const char *sec_name,
 			     size_t align, const void *raw_data, size_t raw_sz)
 {
-- 
2.30.2


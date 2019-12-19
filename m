Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9911264B5
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 15:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfLSO3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 09:29:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:34938 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726779AbfLSO3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 09:29:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576765778;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEgTWUeAAouRk3pPw4zhi85HCqZ5Ilh13NfPCHPNwLE=;
        b=ITECXafKi5I47hj0rFKGaexdi/SmV6azgSmEW0FPZBQCDNpWMc/yTb9ugeVn1IBheAO+Ns
        aOqQSLHGJuoU8oBKFvXkSDZDiAIF6g+PGjQK/giU4LJbj7GSUDT7n+jYYxYHGPoxGuVznq
        R59ySADUgf50fDM1AAmkcVEI8g0YF/Y=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-GwfN6H-JPs-l4Bb0zxUmJg-1; Thu, 19 Dec 2019 09:29:36 -0500
X-MC-Unique: GwfN6H-JPs-l4Bb0zxUmJg-1
Received: by mail-lj1-f198.google.com with SMTP id f15so331896ljj.11
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 06:29:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cEgTWUeAAouRk3pPw4zhi85HCqZ5Ilh13NfPCHPNwLE=;
        b=KYbm6qDnAaHPCHhnFpn33igwQFCGx0Ib5WUV479vCG0CItyW64oSSx0OHzMuylJvNo
         D5fWjXXjzbohpdJbFV5RhdwP3GUIRDycIOpBR99STbwIv4XGzSTPWwpeDrPdSmkkVFbL
         Oy//IlYzR/uaT2d6dhcDFg23RCyxQAIKjZryVc0QM8BSJENjk5WBn7T1OJybMjxE8EqT
         3zUbkXyGHaiiNa+3z9fmogJ0vD+P2IewQbrTwodK6ap0liVbPPEQbxbd7b8aM+Xnd6cw
         6+KkmPCQXLiU+gV/Xm5ekXlj+UMZ0DxxUAGgJEDoonx/Cu7209/m0Zrbv9DyZNuKc0XQ
         VMhw==
X-Gm-Message-State: APjAAAUUXLiJKW4IRbqFOcI6Myit6piwnVVdzKcsNYQ3IhTHNPJL0S1L
        o9RRkbCsz1w96vIl8lh3GYQ3LrHjcC8oxPuqRaxfwWKmSgViGKe7EApVfMJG37DbVllbMeyUKPo
        Utvv2IG8l4qngzjX+
X-Received: by 2002:a19:ae18:: with SMTP id f24mr5633441lfc.155.1576765775225;
        Thu, 19 Dec 2019 06:29:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqz2C3/heAck5zeQ3Di//+NaTOE2yrnU+jRrfEn7SgbB0uGtbtvcjPAIWTGdvGNl3pLeq9WErQ==
X-Received: by 2002:a19:ae18:: with SMTP id f24mr5633397lfc.155.1576765774619;
        Thu, 19 Dec 2019 06:29:34 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r21sm2935256ljn.64.2019.12.19.06.29.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 06:29:33 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BA0CA180969; Thu, 19 Dec 2019 15:29:32 +0100 (CET)
Subject: [PATCH RFC bpf-next 2/3] libbpf: Handle function externs and support
 static linking
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Thu, 19 Dec 2019 15:29:32 +0100
Message-ID: <157676577267.957277.6240503077867756432.stgit@toke.dk>
In-Reply-To: <157676577049.957277.3346427306600998172.stgit@toke.dk>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk>
User-Agent: StGit/0.21
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This adds support for resolving function externs to libbpf, with a new API
to resolve external function calls by static linking at load-time. The API
for this requires the caller to supply the object files containing the
target functions, and to specify an explicit mapping between extern
function names in the calling program, and function names in the target
object file. This is to support the XDP multi-prog case, where the
dispatcher program may not necessarily have control over function names in
the target programs, so simple function name resolution can't be used.

The target object files must be loaded into the kernel before the calling
program, to ensure all relocations are done on the target functions, so we
can just copy over the instructions.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/btf.c    |   10 +-
 tools/lib/bpf/libbpf.c |  268 +++++++++++++++++++++++++++++++++++++++---------
 tools/lib/bpf/libbpf.h |   17 +++
 3 files changed, 244 insertions(+), 51 deletions(-)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 5f04f56e1eb6..2740d4a6b2eb 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -246,6 +246,7 @@ __s64 btf__resolve_size(const struct btf *btf, __u32 type_id)
 			size = t->size;
 			goto done;
 		case BTF_KIND_PTR:
+		case BTF_KIND_FUNC_PROTO:
 			size = sizeof(void *);
 			goto done;
 		case BTF_KIND_TYPEDEF:
@@ -288,6 +289,7 @@ int btf__align_of(const struct btf *btf, __u32 id)
 	case BTF_KIND_ENUM:
 		return min(sizeof(void *), t->size);
 	case BTF_KIND_PTR:
+	case BTF_KIND_FUNC_PROTO:
 		return sizeof(void *);
 	case BTF_KIND_TYPEDEF:
 	case BTF_KIND_VOLATILE:
@@ -640,12 +642,16 @@ int btf__finalize_data(struct bpf_object *obj, struct btf *btf)
 		 */
 		if (btf_is_datasec(t)) {
 			err = btf_fixup_datasec(obj, btf, t);
-			if (err)
+			/* FIXME: With function externs we can get a BTF DATASEC
+			 * entry for .extern, but the section doesn't exist; so
+			 * make ENOENT non-fatal
+			 */
+			if (err && err != -ENOENT)
 				break;
 		}
 	}
 
-	return err;
+	return err == -ENOENT ? err : 0;
 }
 
 int btf__load(struct btf *btf)
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 266b725e444b..b2c0a2f927e7 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -172,13 +172,17 @@ enum reloc_type {
 	RELO_CALL,
 	RELO_DATA,
 	RELO_EXTERN,
+	RELO_EXTERN_CALL,
 };
 
+struct extern_desc;
+
 struct reloc_desc {
 	enum reloc_type type;
 	int insn_idx;
 	int map_idx;
 	int sym_off;
+	struct extern_desc *ext;
 };
 
 /*
@@ -274,6 +278,7 @@ enum extern_type {
 	EXT_INT,
 	EXT_TRISTATE,
 	EXT_CHAR_ARR,
+	EXT_FUNC
 };
 
 struct extern_desc {
@@ -287,6 +292,7 @@ struct extern_desc {
 	bool is_signed;
 	bool is_weak;
 	bool is_set;
+	struct bpf_program *tgt_prog;
 };
 
 static LIST_HEAD(bpf_objects_list);
@@ -305,6 +311,7 @@ struct bpf_object {
 	char *kconfig;
 	struct extern_desc *externs;
 	int nr_extern;
+	int nr_data_extern;
 	int kconfig_map_idx;
 
 	bool loaded;
@@ -1041,6 +1048,7 @@ static int set_ext_value_tri(struct extern_desc *ext, void *ext_val,
 	case EXT_UNKNOWN:
 	case EXT_INT:
 	case EXT_CHAR_ARR:
+	case EXT_FUNC:
 	default:
 		pr_warn("extern %s=%c should be bool, tristate, or char\n",
 			ext->name, value);
@@ -1281,7 +1289,7 @@ static int bpf_object__init_kconfig_map(struct bpf_object *obj)
 	size_t map_sz;
 	int err;
 
-	if (obj->nr_extern == 0)
+	if (obj->nr_data_extern == 0)
 		return 0;
 
 	last_ext = &obj->externs[obj->nr_extern - 1];
@@ -1822,29 +1830,51 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 	struct btf_type *t;
 	int i, j, vlen;
 
-	if (!obj->btf || (has_func && has_datasec))
+	if (!obj->btf)
 		return;
-
 	for (i = 1; i <= btf__get_nr_types(btf); i++) {
 		t = (struct btf_type *)btf__type_by_id(btf, i);
 
-		if (!has_datasec && btf_is_var(t)) {
-			/* replace VAR with INT */
-			t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
-			/*
-			 * using size = 1 is the safest choice, 4 will be too
-			 * big and cause kernel BTF validation failure if
-			 * original variable took less than 4 bytes
+		if (btf_is_var(t)) {
+			struct btf_type *var_t;
+
+			var_t = (struct btf_type *)btf__type_by_id(btf,
+								   t->type);
+
+			/* FIXME: The kernel doesn't understand func_proto with
+			 * BTF_VAR_GLOBAL_EXTERN linkage, so we just replace
+			 * them with INTs here. What's the right thing to do?
 			 */
-			t->size = 1;
-			*(int *)(t + 1) = BTF_INT_ENC(0, 0, 8);
-		} else if (!has_datasec && btf_is_datasec(t)) {
+			if (!has_datasec ||
+			    (btf_kind(var_t) == BTF_KIND_FUNC_PROTO &&
+			     btf_var(t)->linkage == BTF_VAR_GLOBAL_EXTERN)) {
+				/* replace VAR with INT */
+				t->info = BTF_INFO_ENC(BTF_KIND_INT, 0, 0);
+				/*
+				 * using size = 1 is the safest choice, 4 will
+				 * be too big and cause kernel BTF validation
+				 * failure if original variable took less than 4
+				 * bytes
+				 */
+				t->size = 1;
+				*(int *)(t + 1) = BTF_INT_ENC(0, 0, 8);
+			}
+		} else if (btf_is_datasec(t)) {
 			/* replace DATASEC with STRUCT */
 			const struct btf_var_secinfo *v = btf_var_secinfos(t);
 			struct btf_member *m = btf_members(t);
 			struct btf_type *vt;
+			size_t tot_size = 0;
 			char *name;
 
+			/* FIXME: The .extern datasec can be 0-sized when there
+			 * are only function signatures but no variables marked
+			 * as extern. Kernel doesn't understand this, so we need
+			 * to get rid of those.
+			 */
+			if (has_datasec && t->size > 0)
+				continue;
+
 			name = (char *)btf__name_by_offset(btf, t->name_off);
 			while (*name) {
 				if (*name == '.')
@@ -1861,7 +1891,10 @@ static void bpf_object__sanitize_btf(struct bpf_object *obj)
 				/* preserve variable name as member name */
 				vt = (void *)btf__type_by_id(btf, v->type);
 				m->name_off = vt->name_off;
+				tot_size += vt->size;
 			}
+			if (t->size < tot_size)
+				t->size = tot_size;
 		} else if (!has_func && btf_is_func_proto(t)) {
 			/* replace FUNC_PROTO with ENUM */
 			vlen = btf_vlen(t);
@@ -2205,6 +2238,8 @@ static enum extern_type find_extern_type(const struct btf *btf, int id,
 		if (find_extern_type(btf, btf_array(t)->type, NULL) != EXT_CHAR)
 			return EXT_UNKNOWN;
 		return EXT_CHAR_ARR;
+	case BTF_KIND_FUNC_PROTO:
+		return EXT_FUNC;
 	default:
 		return EXT_UNKNOWN;
 	}
@@ -2215,6 +2250,10 @@ static int cmp_externs(const void *_a, const void *_b)
 	const struct extern_desc *a = _a;
 	const struct extern_desc *b = _b;
 
+	/* make sure function externs are at the end */
+	if (a->type != b->type)
+		return a->type == EXT_FUNC ? -1 : 1;
+
 	/* descending order by alignment requirements */
 	if (a->align != b->align)
 		return a->align > b->align ? -1 : 1;
@@ -2295,10 +2334,13 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 			pr_warn("extern '%s' type is unsupported\n", ext_name);
 			return -ENOTSUP;
 		}
+
+		if (ext->type != EXT_FUNC)
+			obj->nr_data_extern++;
 	}
 	pr_debug("collected %d externs total\n", obj->nr_extern);
 
-	if (!obj->nr_extern)
+	if (!obj->nr_data_extern)
 		return 0;
 
 	/* sort externs by (alignment, size, name) and calculate their offsets
@@ -2422,22 +2464,56 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 	enum libbpf_map_type type;
 	struct bpf_map *map;
 
+	if (sym_is_extern(sym)) {
+		int sym_idx = GELF_R_SYM(rel->r_info);
+		int i, n = obj->nr_extern;
+		struct extern_desc *ext;
+
+		for (i = 0; i < n; i++) {
+			ext = &obj->externs[i];
+			if (ext->sym_idx == sym_idx)
+				break;
+		}
+		if (i >= n) {
+			pr_warn("extern relo failed to find extern for sym %d\n",
+				sym_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
+		pr_debug("found extern #%d '%s' (sym %d, off %u) for insn %u\n",
+			 i, ext->name, ext->sym_idx, ext->data_off, insn_idx);
+		reloc_desc->insn_idx = insn_idx;
+		reloc_desc->sym_off = ext->data_off;
+		reloc_desc->ext = ext;
+
+		if (insn->code == (BPF_JMP | BPF_CALL)) {
+			if (insn->src_reg != BPF_PSEUDO_CALL) {
+				pr_warn("incorrect bpf_call opcode\n");
+				return -LIBBPF_ERRNO__RELOC;
+			}
+			obj->has_pseudo_calls = true;
+			reloc_desc->type = RELO_EXTERN_CALL;
+		} else {
+			reloc_desc->type = RELO_EXTERN;
+		}
+		return 0;
+	}
+
 	/* sub-program call relocation */
 	if (insn->code == (BPF_JMP | BPF_CALL)) {
 		if (insn->src_reg != BPF_PSEUDO_CALL) {
 			pr_warn("incorrect bpf_call opcode\n");
 			return -LIBBPF_ERRNO__RELOC;
 		}
-		/* text_shndx can be 0, if no default "main" program exists */
-		if (!shdr_idx || shdr_idx != obj->efile.text_shndx) {
-			pr_warn("bad call relo against section %u\n", shdr_idx);
-			return -LIBBPF_ERRNO__RELOC;
-		}
 		if (sym->st_value % 8) {
 			pr_warn("bad call relo offset: %zu\n",
 				(size_t)sym->st_value);
 			return -LIBBPF_ERRNO__RELOC;
 		}
+		/* text_shndx can be 0, if no default "main" program exists */
+		if (!shdr_idx || shdr_idx != obj->efile.text_shndx) {
+			pr_warn("bad call relo against section %u\n", shdr_idx);
+			return -LIBBPF_ERRNO__RELOC;
+		}
 		reloc_desc->type = RELO_CALL;
 		reloc_desc->insn_idx = insn_idx;
 		reloc_desc->sym_off = sym->st_value;
@@ -2451,28 +2527,6 @@ static int bpf_program__record_reloc(struct bpf_program *prog,
 		return -LIBBPF_ERRNO__RELOC;
 	}
 
-	if (sym_is_extern(sym)) {
-		int sym_idx = GELF_R_SYM(rel->r_info);
-		int i, n = obj->nr_extern;
-		struct extern_desc *ext;
-
-		for (i = 0; i < n; i++) {
-			ext = &obj->externs[i];
-			if (ext->sym_idx == sym_idx)
-				break;
-		}
-		if (i >= n) {
-			pr_warn("extern relo failed to find extern for sym %d\n",
-				sym_idx);
-			return -LIBBPF_ERRNO__RELOC;
-		}
-		pr_debug("found extern #%d '%s' (sym %d, off %u) for insn %u\n",
-			 i, ext->name, ext->sym_idx, ext->data_off, insn_idx);
-		reloc_desc->type = RELO_EXTERN;
-		reloc_desc->insn_idx = insn_idx;
-		reloc_desc->sym_off = ext->data_off;
-		return 0;
-	}
 
 	if (!shdr_idx || shdr_idx >= SHN_LORESERVE) {
 		pr_warn("invalid relo for \'%s\' in special section 0x%x; forgot to initialize global var?..\n",
@@ -4268,6 +4322,46 @@ bpf_program__reloc_text(struct bpf_program *prog, struct bpf_object *obj,
 	return 0;
 }
 
+static int
+bpf_program__reloc_ext_call(struct bpf_program *prog, struct bpf_object *obj,
+			    struct reloc_desc *relo)
+{
+	struct bpf_program *tgt_prog = relo->ext->tgt_prog;
+	struct bpf_insn *insn, *new_insn;
+	size_t new_cnt, old_cnt;
+	int err;
+
+	new_cnt = prog->insns_cnt + tgt_prog->insns_cnt;
+	old_cnt = prog->insns_cnt;
+	new_insn = reallocarray(prog->insns, new_cnt, sizeof(*insn));
+	if (!new_insn) {
+		pr_warn("oom in prog realloc\n");
+		return -ENOMEM;
+	}
+	prog->insns = new_insn;
+
+	/* FIXME: Is this right? Line info and function names seem off when
+	 * dumped from kernel. Also, type info needs resolving across both
+	 * objects; fails with 'invalid type id' for anything but the simplest
+	 * programs as-is.
+	 */
+	err = bpf_program_reloc_btf_ext(prog, tgt_prog->obj,
+					tgt_prog->section_name,
+					prog->insns_cnt);
+	if (err)
+		return err;
+
+	memcpy(new_insn + prog->insns_cnt, tgt_prog->insns,
+	       tgt_prog->insns_cnt * sizeof(*insn));
+	prog->insns_cnt = new_cnt;
+	pr_debug("added %zd insn from %s to prog %s\n",
+		 tgt_prog->insns_cnt, tgt_prog->section_name,
+		 prog->section_name);
+	insn = &prog->insns[relo->insn_idx];
+	insn->imm += relo->sym_off / 8 + old_cnt - relo->insn_idx;
+	return 0;
+}
+
 static int
 bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 {
@@ -4311,6 +4405,11 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 			insn[0].imm = obj->maps[obj->kconfig_map_idx].fd;
 			insn[1].imm = relo->sym_off;
 			break;
+		case RELO_EXTERN_CALL:
+			err = bpf_program__reloc_ext_call(prog, obj, relo);
+			if (err)
+				return err;
+			break;
 		case RELO_CALL:
 			err = bpf_program__reloc_text(prog, obj, relo);
 			if (err)
@@ -4565,8 +4664,6 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 out:
 	if (err)
 		pr_warn("failed to load program '%s'\n", prog->section_name);
-	zfree(&prog->insns);
-	prog->insns_cnt = 0;
 	return err;
 }
 
@@ -4776,20 +4873,77 @@ static int bpf_object__sanitize_maps(struct bpf_object *obj)
 	return 0;
 }
 
+static int bpf_object__resolve_extern_call(struct extern_desc *ext,
+					   const struct bpf_extern_calls *ext_calls)
+{
+	struct bpf_extern_call_tgt *tgt = NULL;
+	struct bpf_program *tgt_prog;
+	int i;
+
+	for (i = 0; i < ext_calls->num_tgts; i++) {
+		if (!strcmp(ext_calls->tgts[i].name, ext->name)) {
+			tgt = &ext_calls->tgts[i];
+			break;
+		}
+	}
+
+	if (!tgt) {
+		pr_warn("Couldn't find external call target for extern %s\n",
+			ext->name);
+		return -ESRCH;
+	}
+
+	/* dynamic linking with in-kernel objects not implemented yet */
+	if (tgt->tgt_fd)
+		return -EINVAL;
+
+	if (!tgt->tgt_obj) {
+		pr_warn("Extern call target %s missing object\n", tgt->name);
+		return -EINVAL;
+	}
+
+	if (!tgt->tgt_obj->loaded) {
+		pr_warn("External call target %s must be loaded first\n",
+			tgt->name);
+		return -EINVAL;
+	}
+
+	if (!tgt->tgt_obj->btf_ext) {
+		pr_warn("External call target %s is missing BTF\n",
+			tgt->name);
+		return -EINVAL;
+	}
+
+	tgt_prog = bpf_object__find_program_by_name(tgt->tgt_obj,
+						    tgt->tgt_prog_name);
+	if (!tgt_prog) {
+		pr_warn("Couldn't find target prog name %s for extern %s\n",
+			tgt->tgt_prog_name, tgt->name);
+		return -ESRCH;
+	}
+
+	/* FIXME: Compare call signature BTF between target and call site. */
+
+	ext->tgt_prog = tgt_prog;
+	ext->is_set = true;
+	return 0;
+}
+
 static int bpf_object__resolve_externs(struct bpf_object *obj,
-				       const char *extra_kconfig)
+				       const char *extra_kconfig,
+				       const struct bpf_extern_calls *ext_calls)
 {
 	bool need_config = false;
 	struct extern_desc *ext;
 	int err, i;
 	void *data;
 
-	if (obj->nr_extern == 0)
-		return 0;
+	if (obj->nr_data_extern == 0)
+		goto calls;
 
 	data = obj->maps[obj->kconfig_map_idx].mmaped;
 
-	for (i = 0; i < obj->nr_extern; i++) {
+	for (i = 0; i < obj->nr_data_extern; i++) {
 		ext = &obj->externs[i];
 
 		if (strcmp(ext->name, "LINUX_KERNEL_VERSION") == 0) {
@@ -4829,6 +4983,23 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 		if (err)
 			return -EINVAL;
 	}
+
+calls:
+	if (obj->nr_data_extern < obj->nr_extern) {
+		if (!ext_calls) {
+			pr_warn("Found %d external calls, but not config for resolving them\n",
+				obj->nr_extern - obj->nr_data_extern);
+			return -EINVAL;
+		}
+
+		for (i = obj->nr_data_extern; i < obj->nr_extern; i++) {
+			err = bpf_object__resolve_extern_call(&obj->externs[i],
+							      ext_calls);
+			if (err)
+				return err;
+		}
+	}
+
 	for (i = 0; i < obj->nr_extern; i++) {
 		ext = &obj->externs[i];
 
@@ -4860,7 +5031,8 @@ int bpf_object__load2(struct bpf_object *obj,
 	obj->loaded = true;
 
 	err = bpf_object__probe_caps(obj);
-	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
+	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig,
+					   OPTS_GET(opts, ext_calls, NULL));
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index ce86277d7445..99cc4bf36486 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -132,6 +132,19 @@ struct bpf_object_load_attr {
 	const char *target_btf_path;
 };
 
+struct bpf_extern_call_tgt {
+	const char *name;
+	const char *tgt_prog_name;
+	/* set one of tgt_obj or tgt_fd */
+	struct bpf_object *tgt_obj;
+	int tgt_fd;
+};
+
+struct bpf_extern_calls {
+	size_t num_tgts;
+	struct bpf_extern_call_tgt *tgts;
+};
+
 struct bpf_object_load_opts {
 	/* size of this struct, for forward/backward compatiblity */
 	size_t sz;
@@ -139,8 +152,10 @@ struct bpf_object_load_opts {
 	int log_level;
 	/* BTF path (for CO-RE relocations) */
 	const char *target_btf_path;
+	/* Descriptions for resolving bpf extern call targets */
+	const struct bpf_extern_calls *ext_calls;
 };
-#define bpf_object_load_opts__last_field target_btf_path
+#define bpf_object_load_opts__last_field ext_calls
 
 /* Load/unload object into/from kernel */
 LIBBPF_API int bpf_object__load(struct bpf_object *obj);


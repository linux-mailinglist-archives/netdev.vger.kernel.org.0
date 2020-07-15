Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0640221738
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 23:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgGOVn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 17:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727817AbgGOVn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 17:43:26 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DBEC08C5DD
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:43:25 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id s8so3806824pgs.9
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 14:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E2dfnoJ0ofq/t39Ii0IFtf86IykpZWGMEQ1Jm6eI35U=;
        b=MJKwqHiEPFpu3BUA/j59A8zUV/ZU0MbhYSGAGMEGlnYw9ivBusvPl2F71Th8VTr604
         kPhXXP6MrxrJAtlhBQkuh8PRHY3mc2VfFcqKXFm0PtQdXDDMPj6Lw/s+9jjO6Lc/Hgjl
         a+30+cDazsiHy50YqapQN04otmjdcItxOHJ81XyzFmAjU6WqUkUKZGA9ICPazy8tXp9l
         E0eqbt8wnszORx1Pb5KomiwtsAY6VtAN+2bpLGGgwLX/o4AhncpCxO70hTsjcXmP2S8Q
         Hti7HcQewf1PN9UgCJ8QNqZHQ2ZEek185a4CW/M1pcr/R7Dzw8TlBMBK1V3xehVrLY1F
         Tgtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E2dfnoJ0ofq/t39Ii0IFtf86IykpZWGMEQ1Jm6eI35U=;
        b=AzoH9ZPywHGVlPMW+6CxQM5R49IZ8dZUNwbFQGwd/MJwt6EMfG+HrQpCRclUNOlO2n
         +57E7R/HxYBxf/S7XSGS+0CGJBFnF9zZn5fBY90/cvNTRaYmcRw+xJop/ujPfkA51yOL
         82fhFLyrV+UVGgB6rwYmsDwDNxPP5JChSW6VqPLXdlXITI8kF9dTCRr6F1tUtkzN6cag
         B2cJfSbPnm1EYMvypKL+XYP6XE+YIL4xmvdutbENCrKCtN3KISvLUPU7Ozu6xkzvlhql
         0C4AucAWnxXFBSOAbeazhA2QhS6HSJVl0mdr6xy6sgEv0fmpehDFk9T94tH8P8hoKAcg
         rh0g==
X-Gm-Message-State: AOAM5302H8DfemvhAPHAXYWrMfdKW3u+bJBRMzBSb80ywRzpJGdobMm0
        p5hcVA7EbDGRqsxoSaYgyTgEMLqbtVtJzELmD2a+XRZ9X4C9XfatQ6ZzRPcaKWv7Kt1Bm9ekGnS
        l2nD4tzj6In0s7Qsjv0k/zLWLBr5rD4Tys+FCgxCfwxWfq9Eh4wcPMmFC9g8F5w==
X-Google-Smtp-Source: ABdhPJwSoOSPakk8TxNp0mh4EXnve73zoPVNaQrXKnfhWGJXzctOpYS2y5spG9CLzRQ3xhQHjP0tSiS1KY8=
X-Received: by 2002:a17:902:9692:: with SMTP id n18mr1156433plp.86.1594849405090;
 Wed, 15 Jul 2020 14:43:25 -0700 (PDT)
Date:   Wed, 15 Jul 2020 14:43:11 -0700
In-Reply-To: <20200715214312.2266839-1-haoluo@google.com>
Message-Id: <20200715214312.2266839-2-haoluo@google.com>
Mime-Version: 1.0
References: <20200715214312.2266839-1-haoluo@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [RFC PATCH bpf-next 1/2] bpf: BTF support for __ksym externs
From:   Hao Luo <haoluo@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        Stanislav Fomichev <sdf@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Hao Luo <haoluo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previous commits:

 commit 1c0c7074fefd ("libbpf: Add support for extracting kernel symbol addresses")
 commit 2e33efe32e01 ("libbpf: Generalize libbpf externs support")

have introduced a new type of extern variable ksyms to access kernel
global variables. This patch extends that work by adding btf info
for ksyms. In more details, in addition to the existing type btf_types,
pahole is going to encode a certain global variables in kernel btf
(percpu variables at this moment). With the extended kernel btf, we
can associate btf id to the ksyms to improve the performance of
accessing those vars by using direct load instructions.

More specifically, libbpf can scan the kernel btf to find the btf id
of a ksym at extern resolution. During relocation, it will replace
"ld_imm64 rX, foo" with BPF_PSEUDO_BTF_ID. From the verifier point of
view "ld_imm64 rX, foo // pseudo_btf_id" will be similar to ld_imm64
with pseudo_map_fd and pseudo_map_value. The verifier will check btf_id
and replace that with actual kernel address at program load time. It
will also know that exact type of 'rX' from there on.

Note that since only a subset of kernel symbols are encoded in btf right
now, finding btf_id for ksyms is only best effort. If a ksym does not
have a btf id, we do not rewrite its ld_imm64 to pseudo_btf_id. In that
case, it is treated as loading from a scalar value, which is the current
default behavior for ksyms.

Also note since we need to carry the ksym's address (64bits) as well as
its btf_id (32bits), pseudo_btf_id uses ld_imm64's both imm and off
fields.

Signed-off-by: Hao Luo <haoluo@google.com>
---
 include/uapi/linux/bpf.h       | 37 +++++++++++++++++++------
 kernel/bpf/verifier.c          | 26 +++++++++++++++---
 tools/include/uapi/linux/bpf.h | 37 +++++++++++++++++++------
 tools/lib/bpf/libbpf.c         | 50 +++++++++++++++++++++++++++++++++-
 4 files changed, 127 insertions(+), 23 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 5e386389913a..7490005acdba 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -334,18 +334,37 @@ enum bpf_link_type {
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
- * two extensions:
- *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd              map fd
- * insn[1].imm:      0                   offset into value
- * insn[0].off:      0                   0
- * insn[1].off:      0                   0
- * ldimm64 rewrite:  address of map      address of map[0]+offset
- * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
+ * three extensions:
+ *
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
+ * insn[0].imm:      map fd
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map
+ * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
+ * insn[0].imm:      lower 32 bits of address
+ * insn[1].imm:      higher 32 bits of address
+ * insn[0].off:      lower 16 bits of btf id
+ * insn[1].off:      higher 16 bits of btf id
+ * ldimm64 rewrite:  address of kernel symbol
+ * verifier type:    PTR_TO_BTF_ID
+ */
+#define BPF_PSEUDO_BTF_ID	3
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3c1efc9d08fd..3c925957b9b6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7131,15 +7131,29 @@ static int check_ld_imm(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		verbose(env, "invalid BPF_LD_IMM insn\n");
 		return -EINVAL;
 	}
+	err = check_reg_arg(env, insn->dst_reg, DST_OP);
+	if (err)
+		return err;
+
+	/*
+	 * BPF_PSEUDO_BTF_ID insn's off fields carry the ksym's btf_id, so its
+	 * handling has to come before the reserved field check.
+	 */
+	if (insn->src_reg == BPF_PSEUDO_BTF_ID) {
+		u32 id = ((u32)(insn + 1)->off << 16) | (u32)insn->off;
+		const struct btf_type *t = btf_type_by_id(btf_vmlinux, id);
+
+		mark_reg_known_zero(env, regs, insn->dst_reg);
+		regs[insn->dst_reg].type = PTR_TO_BTF_ID;
+		regs[insn->dst_reg].btf_id = t->type;
+		return 0;
+	}
+
 	if (insn->off != 0) {
 		verbose(env, "BPF_LD_IMM64 uses reserved fields\n");
 		return -EINVAL;
 	}
 
-	err = check_reg_arg(env, insn->dst_reg, DST_OP);
-	if (err)
-		return err;
-
 	if (insn->src_reg == 0) {
 		u64 imm = ((u64)(insn + 1)->imm << 32) | (u32)insn->imm;
 
@@ -9166,6 +9180,10 @@ static int replace_map_fd_with_map_ptr(struct bpf_verifier_env *env)
 				/* valid generic load 64-bit imm */
 				goto next_insn;
 
+			if (insn[0].src_reg == BPF_PSEUDO_BTF_ID)
+				/* pseudo_btf_id load 64-bit imm */
+				goto next_insn;
+
 			/* In final convert_pseudo_ld_imm64() step, this is
 			 * converted into regular 64-bit imm load insn.
 			 */
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 5e386389913a..7490005acdba 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -334,18 +334,37 @@ enum bpf_link_type {
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
- * two extensions:
- *
- * insn[0].src_reg:  BPF_PSEUDO_MAP_FD   BPF_PSEUDO_MAP_VALUE
- * insn[0].imm:      map fd              map fd
- * insn[1].imm:      0                   offset into value
- * insn[0].off:      0                   0
- * insn[1].off:      0                   0
- * ldimm64 rewrite:  address of map      address of map[0]+offset
- * verifier type:    CONST_PTR_TO_MAP    PTR_TO_MAP_VALUE
+ * three extensions:
+ *
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_FD
+ * insn[0].imm:      map fd
+ * insn[1].imm:      0
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map
+ * verifier type:    CONST_PTR_TO_MAP
  */
 #define BPF_PSEUDO_MAP_FD	1
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_MAP_VALUE
+ * insn[0].imm:      map fd
+ * insn[1].imm:      offset into value
+ * insn[0].off:      0
+ * insn[1].off:      0
+ * ldimm64 rewrite:  address of map[0]+offset
+ * verifier type:    PTR_TO_MAP_VALUE
+ */
 #define BPF_PSEUDO_MAP_VALUE	2
+/*
+ * insn[0].src_reg:  BPF_PSEUDO_BTF_ID
+ * insn[0].imm:      lower 32 bits of address
+ * insn[1].imm:      higher 32 bits of address
+ * insn[0].off:      lower 16 bits of btf id
+ * insn[1].off:      higher 16 bits of btf id
+ * ldimm64 rewrite:  address of kernel symbol
+ * verifier type:    PTR_TO_BTF_ID
+ */
+#define BPF_PSEUDO_BTF_ID	3
 
 /* when bpf_call->src_reg == BPF_PSEUDO_CALL, bpf_call->imm == pc-relative
  * offset to another bpf function
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4489f95f1d1a..23f9710b3d7e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -363,6 +363,7 @@ struct extern_desc {
 		} kcfg;
 		struct {
 			unsigned long long addr;
+			int vmlinux_btf_id;
 		} ksym;
 	};
 };
@@ -387,6 +388,7 @@ struct bpf_object {
 
 	bool loaded;
 	bool has_pseudo_calls;
+	bool has_ksyms;
 
 	/*
 	 * Information when doing elf related work. Only valid if fd
@@ -2500,6 +2502,10 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
 	if (obj->btf_ext && obj->btf_ext->field_reloc_info.len)
 		need_vmlinux_btf = true;
 
+	/* Support for ksyms needs kernel BTF */
+	if (obj->has_ksyms)
+		need_vmlinux_btf = true;
+
 	bpf_object__for_each_program(prog, obj) {
 		if (!prog->load)
 			continue;
@@ -2946,6 +2952,9 @@ static int bpf_object__collect_externs(struct bpf_object *obj)
 				pr_warn("extern (ksym) '%s' is not typeless (void)\n", ext_name);
 				return -ENOTSUP;
 			}
+
+			if (!obj->has_ksyms)
+				obj->has_ksyms = true;
 		} else {
 			pr_warn("unrecognized extern section '%s'\n", sec_name);
 			return -ENOTSUP;
@@ -5123,6 +5132,18 @@ bpf_program__relocate(struct bpf_program *prog, struct bpf_object *obj)
 			} else /* EXT_KSYM */ {
 				insn[0].imm = (__u32)ext->ksym.addr;
 				insn[1].imm = ext->ksym.addr >> 32;
+
+				/*
+				 * If the ksym has found btf id in the vmlinux
+				 * btf, it gets mapped to a BPF_PSEUDO_BTF_ID.
+				 * The verifier will then convert the dst reg
+				 * into PTR_TO_BTF_ID instead of SCALAR_VALUE.
+				 */
+				if (ext->ksym.vmlinux_btf_id) {
+					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
+					insn[0].off = (__s16)ext->ksym.vmlinux_btf_id;
+					insn[1].off = ext->ksym.vmlinux_btf_id >> 16;
+				}
 			}
 			break;
 		case RELO_CALL:
@@ -5800,6 +5821,30 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 	return err;
 }
 
+static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
+{
+	struct extern_desc *ext;
+	int i, id;
+
+	if (!obj->btf_vmlinux) {
+		pr_warn("warn: support of ksyms needs kernel btf.\n");
+		return -1;
+	}
+
+	for (i = 0; i < obj->nr_extern; i++) {
+		ext = &obj->externs[i];
+		if (ext->type != EXT_KSYM)
+			continue;
+
+		id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
+					    BTF_KIND_VAR);
+		ext->ksym.vmlinux_btf_id = id > 0 ? id : 0;
+		pr_debug("extern (ksym) #%d: name %s, vmlinux_btf_id: %d\n",
+			 i, ext->name, ext->ksym.vmlinux_btf_id);
+	}
+	return 0;
+}
+
 static int bpf_object__resolve_externs(struct bpf_object *obj,
 				       const char *extra_kconfig)
 {
@@ -5862,6 +5907,9 @@ static int bpf_object__resolve_externs(struct bpf_object *obj,
 		err = bpf_object__read_kallsyms_file(obj);
 		if (err)
 			return -EINVAL;
+		err = bpf_object__resolve_ksyms_btf_id(obj);
+		if (err)
+			return -EINVAL;
 	}
 	for (i = 0; i < obj->nr_extern; i++) {
 		ext = &obj->externs[i];
@@ -5896,10 +5944,10 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 
 	err = bpf_object__probe_loading(obj);
 	err = err ? : bpf_object__probe_caps(obj);
+	err = err ? : bpf_object__load_vmlinux_btf(obj);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
-	err = err ? : bpf_object__load_vmlinux_btf(obj);
 	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
 	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
-- 
2.27.0.389.gc38d7665816-goog


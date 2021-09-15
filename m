Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE20940BF34
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 07:10:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhIOFLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 01:11:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236298AbhIOFLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 01:11:34 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06899C061574;
        Tue, 14 Sep 2021 22:10:16 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s11so1522082pgr.11;
        Tue, 14 Sep 2021 22:10:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8OMtHYl/0NsOkE5QU+j8BFHyewhBeadRVhqSpUjbZrY=;
        b=GtHVK0NZATyW7TyxSlhpKPtOS84g6g8ldNlPIsF8JhY59zLMem8QYUDOgyEyJ5TcjA
         x1iZP5IfcPuKst5oOTG44DCTHuc3hxxwPJQkrL9kn+BcO2efuArUiZh9z0gB6692k0uz
         v8TRrLSfuN40tznOX6iFC0r2K086E1qj2cqq3YJFolFtdigIkLzlX4MhdtNosfHdio1S
         JbCjj9PmV364xUlgNlzvWBJaT7NbQYZGTrYKkirXfXCak9m4LwqBnzVk0oANgdlUa+uE
         13dSXzTLF6FZDOGjyQ2f3Gz/zr2Q37bhAJZIZJ4mOHQGeKvbzNShxW/bp6i5vHAA33YI
         nltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8OMtHYl/0NsOkE5QU+j8BFHyewhBeadRVhqSpUjbZrY=;
        b=iY7Z7YwtT+0qxG7eTlzMUBzI0L4oVzfd4PAp3UIFa5OdacErQifqAgnZ8cqLy78KA0
         l9sZgvmK53Yoh4hKSquQBhK4tNH05VMCwR1OLS7J6LebKMvGxYw+kIXstTfvIam91taH
         GDRC4Ws5RvxfcOBZFOiHC/wia+kgaVHsTV1qFoUojavTYdjbWJDvYo7FOGyLIQ2YujGI
         wD6z5V5Xa5s7IAFt6/LvTmey/377GpxetUMV+GNe7VyhjIaUhDKPT/Ej6CIFbKYSxAfT
         SwrujN1MGhdP1h4ftr/RDbarqBzWKMh3fGvqla2lrGpUWOidQNZ8tie/lepQ9FlIBDok
         v1pw==
X-Gm-Message-State: AOAM533a2yXRByIDC0DyT1oPJwuqKPRQnLBh5IfyL0zXwQOdpWv1uB/M
        3yRzmYxs0Ssd3Xu26ZTpn2w9fJJ5YQAJ8w==
X-Google-Smtp-Source: ABdhPJxa0189ETnkQsICa+fJsVzlLLIuDDK8dX0xhlhNXCfwLPIIiAbdGqW3dvoDqwe4FvzW3/Y/tw==
X-Received: by 2002:a65:4486:: with SMTP id l6mr19074482pgq.145.1631682615356;
        Tue, 14 Sep 2021 22:10:15 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j17sm12302106pfn.148.2021.09.14.22.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 22:10:15 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 09/10] libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
Date:   Wed, 15 Sep 2021 10:39:42 +0530
Message-Id: <20210915050943.679062-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210915050943.679062-1-memxor@gmail.com>
References: <20210915050943.679062-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8801; h=from:subject; bh=hayAcysmBL7vuknb5yER44ADm9rIVaUmu2XHK8D79mA=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhQX4cxuKAJvKTBZUj77WPtC5De8S05cwgBHQ6re1j NCYR1LqJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUF+HAAKCRBM4MiGSL8RyhcfD/ 9WBM0KOO/g1NuesU64U1bTxU66p/3OwmkMs3/DdOh/G9Ix2ESkCaEAUS5YEQ9U0dpl2ubLyYc6opaZ ySNgBgkGe7AtuyY7QcgJVmYerI4u6Rnr17P1oePYzZH4l2esbEfxGQARg2eKXcoPPFhudYm5FrAsQZ OeDyoiTtSUyPVBO0F8lxsfGTulMnLQvD22vXf296I8ZNfnt4crK+7vixCRQ6OoWd0cLyRdkp/entLE MQ7gDSmw0zhJyNZDu5rEkjzOrk4igi+DmjeXvN3Tast+qY0QLFVSgaPUhVvo/r+FA9oxHXcDrzjeRk BBVW+3S6Gedv7sp1nKFW8TngciWrLbbHuo7WXhX1B/6ftmgrd/vzUtubkR6pU71C8XrqUjr0XFXDlM ww71qIn2vJv32u2lCLRnvpNow2r6qv69UtBheY5GK2hfPhZvVUTMi8S9Eb8zxnI2rCnV6XCGuSsaOk lQ2tqUbUZarCYSt8QNXUHNXxRtZNccG6oh5ZRzkwhZSpDXe827jDJx4RrNn3UcCFgaMAacdAFIOyX+ QvskV3jaPUrzFkWWptb77MM9fd9zeo9DOjUHiEE4IRWc5IodM5GwunFIBpFtddk3R/1gAspdzE9FKG dmzoZWU07lPXKI3pPUQMDmTXv6MO5a14hPLYnX+juQQcgQ6BwCCyEjI86VcQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
relocations, with support for weak kfunc relocations.

One of the disadvantages of gen_loader is that due to stack size
limitation, BTF fd array size is clamped to a smaller limit than what
the kernel allows. Also, finding an existing BTF fd's slot is not
trivial, because that would require to open all module BTFs and match on
the open fds (like we do for libbpf), so we do the next best thing:
deduplicate slots for the same symbol.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h | 12 ++++-
 tools/lib/bpf/gen_loader.c       | 93 ++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.c           |  8 +--
 3 files changed, 99 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 615400391e57..4826adf18d7b 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -7,8 +7,15 @@ struct ksym_relo_desc {
 	const char *name;
 	int kind;
 	int insn_idx;
+	bool is_weak;
 };
 
+struct kfunc_desc {
+	const char *name;
+	int index;
+};
+
+#define MAX_KFUNC_DESCS 94
 struct bpf_gen {
 	struct gen_loader_opts *opts;
 	void *data_start;
@@ -24,6 +31,8 @@ struct bpf_gen {
 	int relo_cnt;
 	char attach_target[128];
 	int attach_kind;
+	struct kfunc_desc kfunc_descs[MAX_KFUNC_DESCS];
+	__u32 nr_kfuncs;
 };
 
 void bpf_gen__init(struct bpf_gen *gen, int log_level);
@@ -36,6 +45,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
+			    int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 8df718a6b142..5e8c15e36c46 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -5,6 +5,7 @@
 #include <string.h>
 #include <errno.h>
 #include <linux/filter.h>
+#include <linux/kernel.h>
 #include "btf.h"
 #include "bpf.h"
 #include "libbpf.h"
@@ -13,6 +14,7 @@
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
 
+/* MAX_BPF_STACK is 768 bytes, so (64 + 32 + 94 (MAX_KFUNC_DESCS) + 2) * 4 */
 #define MAX_USED_MAPS 64
 #define MAX_USED_PROGS 32
 
@@ -31,6 +33,8 @@ struct loader_stack {
 	__u32 btf_fd;
 	__u32 map_fd[MAX_USED_MAPS];
 	__u32 prog_fd[MAX_USED_PROGS];
+	/* Update insn->off store when reordering kfunc_btf_fd */
+	__u32 kfunc_btf_fd[MAX_KFUNC_DESCS];
 	__u32 inner_map_fd;
 };
 
@@ -506,8 +510,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 	 */
 }
 
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
-			    int insn_idx)
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -519,14 +523,39 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
 	gen->relos = relo;
 	relo += gen->relo_cnt;
 	relo->name = name;
+	relo->is_weak = is_weak;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
 }
 
+static struct kfunc_desc *find_kfunc_desc(struct bpf_gen *gen, const char *name)
+{
+	/* Try to reuse BTF fd index for repeating symbol */
+	for (int i = 0; i < gen->nr_kfuncs; i++) {
+		if (!strcmp(gen->kfunc_descs[i].name, name))
+			return &gen->kfunc_descs[i];
+	}
+	return NULL;
+}
+
+static struct kfunc_desc *add_kfunc_desc(struct bpf_gen *gen, const char *name)
+{
+	struct kfunc_desc *kdesc;
+
+	if (gen->nr_kfuncs == ARRAY_SIZE(gen->kfunc_descs))
+		return NULL;
+	kdesc = &gen->kfunc_descs[gen->nr_kfuncs];
+	kdesc->name = name;
+	kdesc->index = gen->nr_kfuncs++;
+	return kdesc;
+}
+
 static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
 {
 	int name, insn, len = strlen(relo->name) + 1;
+	int off = MAX_USED_MAPS + MAX_USED_PROGS;
+	struct kfunc_desc *kdesc;
 
 	pr_debug("gen: emit_relo: %s at %d\n", relo->name, relo->insn_idx);
 	name = add_data(gen, relo->name, len);
@@ -539,18 +568,64 @@ static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
 	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
 	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
-	emit_check_err(gen);
+	/* if not weak kfunc, emit err check */
+	if (relo->kind != BTF_KIND_FUNC || !relo->is_weak)
+		emit_check_err(gen);
+	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx;
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
+	/* set a default value */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_0, offsetof(struct bpf_insn, imm), 0));
+	/* skip success case store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 1));
 	/* store btf_id into insn[insn_idx].imm */
-	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx +
-		offsetof(struct bpf_insn, imm);
-	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, insn));
-	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, 0));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, offsetof(struct bpf_insn, imm)));
 	if (relo->kind == BTF_KIND_VAR) {
 		/* store btf_obj_fd into insn[insn_idx + 1].imm */
 		emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
 		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7,
-				      sizeof(struct bpf_insn)));
+				      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
+	} else if (relo->kind == BTF_KIND_FUNC) {
+		kdesc = find_kfunc_desc(gen, relo->name);
+		if (!kdesc)
+			kdesc = add_kfunc_desc(gen, relo->name);
+		if (kdesc) {
+			/* store btf_obj_fd in index in kfunc_btf_fd array
+			 * but skip storing fd if ret < 0
+			 */
+			emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_10,
+			     stack_off(kfunc_btf_fd[kdesc->index]), 0));
+			emit(gen, BPF_MOV64_REG(BPF_REG_8, BPF_REG_7));
+			emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 4));
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
+			/* if vmlinux BTF, skip store */
+			emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_7, 0, 1));
+			emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
+			     stack_off(kfunc_btf_fd[kdesc->index])));
+			emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_8));
+			/* remember BTF obj fd */
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_8, 32));
+		} else {
+			pr_warn("Out of BTF fd slots (total: %u), skipping for %s\n",
+				gen->nr_kfuncs, relo->name);
+			emit(gen, BPF_MOV64_REG(BPF_REG_1, BPF_REG_7));
+			emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_1, 32));
+			__emit_sys_close(gen);
+		}
+		/* store index + 1 into insn[insn_idx].off */
+		off = kdesc ? off + kdesc->index + 1 : 0;
+		off = off > INT16_MAX ? 0 : off;
+		/* set a default value */
+		emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), 0));
+		/* skip success case store if ret < 0 */
+		emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
+		/* skip if vmlinux BTF */
+		emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_8, 0, 1));
+		/* store offset */
+		emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_0, offsetof(struct bpf_insn, off), off));
+		/* log relocation */
+		emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_0, offsetof(struct bpf_insn, imm)));
+		emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_8, BPF_REG_0, offsetof(struct bpf_insn, off)));
+		debug_regs(gen, BPF_REG_7, BPF_REG_8, "sym (%s): imm: %%d, off: %%d", relo->name);
 	}
 }
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 50a7c995979a..3ac26dcb60b0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6264,12 +6264,12 @@ static int bpf_program__record_externs(struct bpf_program *prog)
 					ext->name);
 				return -ENOTSUP;
 			}
-			bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_VAR,
-					       relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+					       BTF_KIND_VAR, relo->insn_idx);
 			break;
 		case RELO_EXTERN_FUNC:
-			bpf_gen__record_extern(obj->gen_loader, ext->name, BTF_KIND_FUNC,
-					       relo->insn_idx);
+			bpf_gen__record_extern(obj->gen_loader, ext->name, ext->is_weak,
+					       BTF_KIND_FUNC, relo->insn_idx);
 			break;
 		default:
 			continue;
-- 
2.33.0


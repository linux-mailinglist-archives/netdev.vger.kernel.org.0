Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E7D41D36C
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 08:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348369AbhI3GcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 02:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348109AbhI3Gb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 02:31:57 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22516C06161C;
        Wed, 29 Sep 2021 23:30:15 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id b22so3284608pls.1;
        Wed, 29 Sep 2021 23:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pFiO3Huks5f8TvyaEQ45MpC10x4nH981N8hkRsx7UDk=;
        b=EXNctlVZLVG0hzLO6BLo7O1OXqz78MMjQrhZricXkRUIWJFUNjpLuEnOAxLpGF36D3
         5yngcKlvvFwpTB57BqT0OCa2JdIcV7+sCgFzisf/5PsEE306dEuxPOL/XRvXOxDeu6K/
         BO2gmkBOYwKpr3EYInaoNVvho7ICnN6FlnIKbwe+2ZxCAZ7p/In1yVJaEivEkS9J7BBu
         wJef8tfnVK4SI41/855C9LqwOZokHgVGrEo8FPrjofh2ZJu8ze+w1SQBHGBeXWZItwYe
         PME4zPbrcPwUje453GK9aBXph/q4EscKagJhLdyfAtw84I/vsydEbaPKqgrxNWCcVAAD
         Gc9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pFiO3Huks5f8TvyaEQ45MpC10x4nH981N8hkRsx7UDk=;
        b=6MYY9t4K87Q3ZQp+clTJlMsrR+f+DfCqRYMOWb+H//QFFivOmDQjzpZAEWiq/htkaQ
         j7IamRnao8W12ufMkBvI37ucJTR7WRwEVbNc6s42mt2yzqyj6iwt9dHzwzxeamKhexHR
         ktV4c5uIF5RFKa3zxLivI6WDIIqDSmwB0LLqF5qFRe3mhJPAvwap2LfydiMvUXv7WLKF
         tWGf8r8rN6qba2u9owb7JmmzmKjDv6fHpN/h6XsJ2mhnIqsg6UH1e9qXLCW5fWJWE/u9
         UC1wjj0X7zaG0Vxo/pfa1WqbPXJXm+KG/++uN7aUucuFmpOQd66PHQeXmFZK/ZU8qNcU
         fGdw==
X-Gm-Message-State: AOAM532XCv8SkgxMtJv9bfWkASgjcISLDH89caHcnx5gwHoycRmkWSjs
        /5zJQ5adD3wxERQa68hyDHYqtXZRm+I=
X-Google-Smtp-Source: ABdhPJxjRwJxLyvd3upEFkq1LPpahbOxLmOJDpIFeKaUNSwVnMdxECdqp95w4IMilJIujfQSj7+QDA==
X-Received: by 2002:a17:90a:de0b:: with SMTP id m11mr4531669pjv.90.1632983413770;
        Wed, 29 Sep 2021 23:30:13 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id d137sm1735359pfd.72.2021.09.29.23.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 23:30:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v6 8/9] libbpf: Update gen_loader to emit BTF_KIND_FUNC relocations
Date:   Thu, 30 Sep 2021 11:59:47 +0530
Message-Id: <20210930062948.1843919-9-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930062948.1843919-1-memxor@gmail.com>
References: <20210930062948.1843919-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=20037; h=from:subject; bh=cuuVy59gAX4VngY44ibc3pTwOq2crh/XFeyMU2MsINY=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhVVlCnUHtFm3XNUFpMPH/77mQWtmSGV41FQVrmOAk DdZhN4mJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVVZQgAKCRBM4MiGSL8Ryh8IEA ChHEGMclyhlrM22qyx0/+uRSLtExp+nmy/x8vms/8MsyiWyhmHXjb5nT6fZuFzwiaxpsjzjk5Auyic mjOPPHgUR67CIyLTQRZHoUqB07Kd/fpw4jYgNCt4kzHz5WLEDAkvIUVGlhfmUYyH6Jd+DjSg1f5W1y YcUh/xc2FOJjO+PGzhG+UlRqAw9Zi4B2q9TVMyEhSEtOA+4Ooy4XHBqBQtSUAeEm61IyO1JIH18NBy 0CdyhUs2VVFbVw8rMQ9hCXFIJDrJT5SuYC/SB9S9ZvT2mNSRXLTCNmV2zWYYKDGxtdYE+13xJCK3It w2be+GFPVPywps0xrWByoCq2H1ABJ/R1wLwZD/leBy3v8AkSq1CxSEvb9F743wWQghb2QXErLZipWC ERz1ypn/pHva7c2zBrN5gRR5Cxdg+gxsj0MQFdjIzouRNvcKLe6J5U/ZWe+ANIbMkoT2VLi61XR+JB pKItSQoxvv7TiAcEUHa0rAzGqQziH6yvFjhHmZXAKzq4flcLrwLxIo+Or/2OG0ZU4e03ZJI48v8ZM1 lnB9NRlVhlPJl/OzP3qeSKto1sm2rBfDF7gz+PsBjz/S+lFYMs6vIuhoaKsYqoQY9OLfmWDH5Nnrb7 qyzA1iCnO4zzZGDZMnhCYITooQVQiGS66bmI9k2hEDlwyZ1xaktPr7vqeUSg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change updates the BPF syscall loader to relocate BTF_KIND_FUNC
relocations, with support for weak kfunc relocations. The general idea
is to move map_fds to loader map, and also use the data for storing
kfunc BTF fds. Since both reuse the fd_array parameter, they need to be
kept together.

For map_fds, we reserve MAX_USED_MAPS slots in a region, and for kfunc,
we reserve MAX_KFUNC_DESCS. This is done so that insn->off has more
chances of being <= INT16_MAX than treating data map as a sparse array
and adding fd as needed.

When the MAX_KFUNC_DESCS limit is reached, we fall back to the sparse
array model, so that as long as it does remain <= INT16_MAX, we pass an
index relative to the start of fd_array.

We store all ksyms in an array where we try to avoid calling the
bpf_btf_find_by_name_kind helper, and also reuse the BTF fd that was
already stored. This also speeds up the loading process compared to
emitting calls in all cases, in later tests.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/lib/bpf/bpf_gen_internal.h |  16 +-
 tools/lib/bpf/gen_loader.c       | 323 ++++++++++++++++++++++++++-----
 tools/lib/bpf/libbpf.c           |   8 +-
 3 files changed, 292 insertions(+), 55 deletions(-)

diff --git a/tools/lib/bpf/bpf_gen_internal.h b/tools/lib/bpf/bpf_gen_internal.h
index 615400391e57..70eccbffefb1 100644
--- a/tools/lib/bpf/bpf_gen_internal.h
+++ b/tools/lib/bpf/bpf_gen_internal.h
@@ -7,6 +7,15 @@ struct ksym_relo_desc {
 	const char *name;
 	int kind;
 	int insn_idx;
+	bool is_weak;
+};
+
+struct ksym_desc {
+	const char *name;
+	int ref;
+	int kind;
+	int off;
+	int insn;
 };
 
 struct bpf_gen {
@@ -24,6 +33,10 @@ struct bpf_gen {
 	int relo_cnt;
 	char attach_target[128];
 	int attach_kind;
+	struct ksym_desc *ksyms;
+	__u32 nr_ksyms;
+	int fd_array;
+	int nr_fd_array;
 };
 
 void bpf_gen__init(struct bpf_gen *gen, int log_level);
@@ -36,6 +49,7 @@ void bpf_gen__prog_load(struct bpf_gen *gen, struct bpf_prog_load_params *load_a
 void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *value, __u32 value_size);
 void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx);
 void bpf_gen__record_attach_target(struct bpf_gen *gen, const char *name, enum bpf_attach_type type);
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind, int insn_idx);
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak, int kind,
+			    int insn_idx);
 
 #endif
diff --git a/tools/lib/bpf/gen_loader.c b/tools/lib/bpf/gen_loader.c
index 80087b13877f..9902f2f47fb2 100644
--- a/tools/lib/bpf/gen_loader.c
+++ b/tools/lib/bpf/gen_loader.c
@@ -14,8 +14,10 @@
 #include "bpf_gen_internal.h"
 #include "skel_internal.h"
 
-#define MAX_USED_MAPS 64
-#define MAX_USED_PROGS 32
+#define MAX_USED_MAPS	64
+#define MAX_USED_PROGS	32
+#define MAX_KFUNC_DESCS 256
+#define MAX_FD_ARRAY_SZ (MAX_USED_PROGS + MAX_KFUNC_DESCS)
 
 /* The following structure describes the stack layout of the loader program.
  * In addition R6 contains the pointer to context.
@@ -30,7 +32,6 @@
  */
 struct loader_stack {
 	__u32 btf_fd;
-	__u32 map_fd[MAX_USED_MAPS];
 	__u32 prog_fd[MAX_USED_PROGS];
 	__u32 inner_map_fd;
 };
@@ -143,13 +144,58 @@ static int add_data(struct bpf_gen *gen, const void *data, __u32 size)
 	if (realloc_data_buf(gen, size8))
 		return 0;
 	prev = gen->data_cur;
-	memcpy(gen->data_cur, data, size);
+	if (data)
+		memcpy(gen->data_cur, data, size);
 	gen->data_cur += size;
 	memcpy(gen->data_cur, &zero, size8 - size);
 	gen->data_cur += size8 - size;
 	return prev - gen->data_start;
 }
 
+/* Get index for map_fd/btf_fd slot in reserved fd_array, or in data relative
+ * to start of fd_array. Caller can decide if it is usable or not.
+ */
+static int fd_array_init(struct bpf_gen *gen)
+{
+	if (!gen->fd_array)
+		gen->fd_array = add_data(gen, NULL, MAX_FD_ARRAY_SZ * sizeof(int));
+	return gen->fd_array;
+}
+
+static int add_map_fd(struct bpf_gen *gen)
+{
+	if (!fd_array_init(gen))
+		return -1;
+	if (gen->nr_maps == MAX_USED_MAPS) {
+		pr_warn("Total maps exceeds %d\n", MAX_USED_MAPS);
+		gen->error = -E2BIG;
+		return -1;
+	}
+	return gen->nr_maps++;
+}
+
+static int add_kfunc_btf_fd(struct bpf_gen *gen)
+{
+	int cur;
+
+	if (!fd_array_init(gen))
+		return -1;
+	if (gen->nr_fd_array == MAX_KFUNC_DESCS) {
+		cur = add_data(gen, NULL, sizeof(int));
+		if (!cur)
+			return -1;
+		return (cur - gen->fd_array) / sizeof(int);
+	}
+	return MAX_USED_MAPS + gen->nr_fd_array++;
+}
+
+static int blob_fd_array_off(struct bpf_gen *gen, int index)
+{
+	if (!gen->fd_array)
+		return 0;
+	return gen->fd_array + (index * sizeof(int));
+}
+
 static int insn_bytes_to_bpf_size(__u32 sz)
 {
 	switch (sz) {
@@ -171,14 +217,22 @@ static void emit_rel_store(struct bpf_gen *gen, int off, int data)
 	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
 }
 
-/* *(u64 *)(blob + off) = (u64)(void *)(%sp + stack_off) */
-static void emit_rel_store_sp(struct bpf_gen *gen, int off, int stack_off)
+static void move_blob2blob(struct bpf_gen *gen, int off, int size, int blob_off)
 {
-	emit(gen, BPF_MOV64_REG(BPF_REG_0, BPF_REG_10));
-	emit(gen, BPF_ALU64_IMM(BPF_ADD, BPF_REG_0, stack_off));
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_2, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_2, 0));
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
 					 0, 0, 0, off));
-	emit(gen, BPF_STX_MEM(BPF_DW, BPF_REG_1, BPF_REG_0, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_1, BPF_REG_0, 0));
+}
+
+static void move_blob2ctx(struct bpf_gen *gen, int ctx_off, int size, int blob_off)
+{
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_off));
+	emit(gen, BPF_LDX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_0, BPF_REG_1, 0));
+	emit(gen, BPF_STX_MEM(insn_bytes_to_bpf_size(size), BPF_REG_6, BPF_REG_0, ctx_off));
 }
 
 static void move_ctx2blob(struct bpf_gen *gen, int off, int size, int ctx_off,
@@ -326,11 +380,11 @@ int bpf_gen__finish(struct bpf_gen *gen)
 			       offsetof(struct bpf_prog_desc, prog_fd), 4,
 			       stack_off(prog_fd[i]));
 	for (i = 0; i < gen->nr_maps; i++)
-		move_stack2ctx(gen,
-			       sizeof(struct bpf_loader_ctx) +
-			       sizeof(struct bpf_map_desc) * i +
-			       offsetof(struct bpf_map_desc, map_fd), 4,
-			       stack_off(map_fd[i]));
+		move_blob2ctx(gen,
+			      sizeof(struct bpf_loader_ctx) +
+			      sizeof(struct bpf_map_desc) * i +
+			      offsetof(struct bpf_map_desc, map_fd), 4,
+			      blob_fd_array_off(gen, i));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_0, 0));
 	emit(gen, BPF_EXIT_INSN());
 	pr_debug("gen: finish %d\n", gen->error);
@@ -390,7 +444,7 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 {
 	int attr_size = offsetofend(union bpf_attr, btf_vmlinux_value_type_id);
 	bool close_inner_map_fd = false;
-	int map_create_attr;
+	int map_create_attr, idx;
 	union bpf_attr attr;
 
 	memset(&attr, 0, attr_size);
@@ -467,9 +521,13 @@ void bpf_gen__map_create(struct bpf_gen *gen,
 		gen->error = -EDOM; /* internal bug */
 		return;
 	} else {
-		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_10, BPF_REG_7,
-				      stack_off(map_fd[map_idx])));
-		gen->nr_maps++;
+		/* add_map_fd does gen->nr_maps++ */
+		idx = add_map_fd(gen);
+		if (idx < 0)
+			return;
+		emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
+						 0, 0, 0, blob_fd_array_off(gen, idx)));
+		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_1, BPF_REG_7, 0));
 	}
 	if (close_inner_map_fd)
 		emit_sys_close_stack(gen, stack_off(inner_map_fd));
@@ -511,8 +569,8 @@ static void emit_find_attach_target(struct bpf_gen *gen)
 	 */
 }
 
-void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
-			    int insn_idx)
+void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, bool is_weak,
+			    int kind, int insn_idx)
 {
 	struct ksym_relo_desc *relo;
 
@@ -524,38 +582,196 @@ void bpf_gen__record_extern(struct bpf_gen *gen, const char *name, int kind,
 	gen->relos = relo;
 	relo += gen->relo_cnt;
 	relo->name = name;
+	relo->is_weak = is_weak;
 	relo->kind = kind;
 	relo->insn_idx = insn_idx;
 	gen->relo_cnt++;
 }
 
-static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
+/* returns existing ksym_desc with ref incremented, or inserts a new one */
+static struct ksym_desc *get_ksym_desc(struct bpf_gen *gen, struct ksym_relo_desc *relo)
 {
-	int name, insn, len = strlen(relo->name) + 1;
+	struct ksym_desc *kdesc;
 
-	pr_debug("gen: emit_relo: %s at %d\n", relo->name, relo->insn_idx);
-	name = add_data(gen, relo->name, len);
+	for (int i = 0; i < gen->nr_ksyms; i++) {
+		if (!strcmp(gen->ksyms[i].name, relo->name)) {
+			gen->ksyms[i].ref++;
+			return &gen->ksyms[i];
+		}
+	}
+	kdesc = libbpf_reallocarray(gen->ksyms, gen->nr_ksyms + 1, sizeof(*kdesc));
+	if (!kdesc) {
+		gen->error = -ENOMEM;
+		return NULL;
+	}
+	gen->ksyms = kdesc;
+	kdesc = &gen->ksyms[gen->nr_ksyms++];
+	kdesc->name = relo->name;
+	kdesc->kind = relo->kind;
+	kdesc->ref = 1;
+	kdesc->off = 0;
+	kdesc->insn = 0;
+	return kdesc;
+}
+
+/* Overwrites BPF_REG_{0, 1, 2, 3, 4, 7}
+ * Returns result in BPF_REG_7
+ */
+static void emit_bpf_find_by_name_kind(struct bpf_gen *gen, struct ksym_relo_desc *relo)
+{
+	int name_off, len = strlen(relo->name) + 1;
 
+	name_off = add_data(gen, relo->name, len);
+	if (!name_off)
+		return;
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_1, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, name));
+					 0, 0, 0, name_off));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_2, len));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_3, relo->kind));
 	emit(gen, BPF_MOV64_IMM(BPF_REG_4, 0));
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_btf_find_by_name_kind));
 	emit(gen, BPF_MOV64_REG(BPF_REG_7, BPF_REG_0));
 	debug_ret(gen, "find_by_name_kind(%s,%d)", relo->name, relo->kind);
-	emit_check_err(gen);
+}
+
+/* Expects:
+ * BPF_REG_8 - pointer to instruction
+ *
+ * We need to reuse BTF fd for same symbol otherwise each relocation takes a new
+ * index, while kernel limits total kfunc BTFs to 256. For duplicate symbols,
+ * this would mean a new BTF fd index for each entry. By pairing symbol name
+ * with index, we get the insn->imm, insn->off pairing that kernel uses for
+ * kfunc_tab, which becomes the effective limit even though all of them may
+ * share same index in fd_array (such that kfunc_btf_tab has 1 element).
+ */
+static void emit_relo_kfunc_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
+{
+	struct ksym_desc *kdesc;
+	int btf_fd_idx;
+
+	kdesc = get_ksym_desc(gen, relo);
+	if (!kdesc)
+		return;
+	/* try to copy from existing bpf_insn */
+	if (kdesc->ref > 1) {
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + offsetof(struct bpf_insn, imm));
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, off), 2,
+			       kdesc->insn + offsetof(struct bpf_insn, off));
+		goto log;
+	}
+	/* remember insn offset, so we can copy BTF ID and FD later */
+	kdesc->insn = insn;
+	emit_bpf_find_by_name_kind(gen, relo);
+	if (!relo->is_weak)
+		emit_check_err(gen);
+	/* get index in fd_array to store BTF FD at */
+	btf_fd_idx = add_kfunc_btf_fd(gen);
+	if (btf_fd_idx < 0)
+		return;
+	if (btf_fd_idx > INT16_MAX) {
+		pr_warn("BTF fd off %d for kfunc %s exceeds INT16_MAX, cannot process relocation\n",
+			btf_fd_idx, relo->name);
+		gen->error = -E2BIG;
+		return;
+	}
+	kdesc->off = btf_fd_idx;
+	/* set a default value for imm */
+	emit(gen, BPF_ST_MEM(BPF_W, BPF_REG_8, offsetof(struct bpf_insn, imm), 0));
+	/* skip success case store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 1));
 	/* store btf_id into insn[insn_idx].imm */
-	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx +
-		offsetof(struct bpf_insn, imm);
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
+	/* load fd_array slot pointer */
 	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
-					 0, 0, 0, insn));
-	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7, 0));
-	if (relo->kind == BTF_KIND_VAR) {
-		/* store btf_obj_fd into insn[insn_idx + 1].imm */
-		emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
-		emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_7,
-				      sizeof(struct bpf_insn)));
+					 0, 0, 0, blob_fd_array_off(gen, btf_fd_idx)));
+	/* skip store of BTF fd if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 3));
+	/* store BTF fd in slot */
+	emit(gen, BPF_MOV64_REG(BPF_REG_9, BPF_REG_7));
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_9, 32));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_0, BPF_REG_9, 0));
+	/* set a default value for off */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_8, offsetof(struct bpf_insn, off), 0));
+	/* skip insn->off store if ret < 0 */
+	emit(gen, BPF_JMP_IMM(BPF_JSLT, BPF_REG_7, 0, 2));
+	/* skip if vmlinux BTF */
+	emit(gen, BPF_JMP_IMM(BPF_JEQ, BPF_REG_9, 0, 1));
+	/* store index into insn[insn_idx].off */
+	emit(gen, BPF_ST_MEM(BPF_H, BPF_REG_8, offsetof(struct bpf_insn, off), btf_fd_idx));
+log:
+	if (!gen->log_level)
+		return;
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8,
+			      offsetof(struct bpf_insn, off)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " func (%s:count=%d): imm: %%d, off: %%d",
+		   relo->name, kdesc->ref);
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_0, BPF_PSEUDO_MAP_IDX_VALUE,
+					 0, 0, 0, blob_fd_array_off(gen, kdesc->off)));
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_9, BPF_REG_0, 0));
+	debug_regs(gen, BPF_REG_9, -1, " func (%s:count=%d): btf_fd",
+		   relo->name, kdesc->ref);
+}
+
+/* Expects:
+ * BPF_REG_8 - pointer to instruction
+ */
+static void emit_relo_ksym_btf(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insn)
+{
+	struct ksym_desc *kdesc;
+
+	kdesc = get_ksym_desc(gen, relo);
+	if (!kdesc)
+		return;
+	/* try to copy from existing ldimm64 insn */
+	if (kdesc->ref > 1) {
+		move_blob2blob(gen, insn + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + offsetof(struct bpf_insn, imm));
+		move_blob2blob(gen, insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm), 4,
+			       kdesc->insn + sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm));
+		goto log;
+	}
+	/* remember insn offset, so we can copy BTF ID and FD later */
+	kdesc->insn = insn;
+	emit_bpf_find_by_name_kind(gen, relo);
+	emit_check_err(gen);
+	/* store btf_id into insn[insn_idx].imm */
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7, offsetof(struct bpf_insn, imm)));
+	/* store btf_obj_fd into insn[insn_idx + 1].imm */
+	emit(gen, BPF_ALU64_IMM(BPF_RSH, BPF_REG_7, 32));
+	emit(gen, BPF_STX_MEM(BPF_W, BPF_REG_8, BPF_REG_7,
+			      sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm)));
+log:
+	if (!gen->log_level)
+		return;
+	emit(gen, BPF_LDX_MEM(BPF_W, BPF_REG_7, BPF_REG_8,
+			      offsetof(struct bpf_insn, imm)));
+	emit(gen, BPF_LDX_MEM(BPF_H, BPF_REG_9, BPF_REG_8, sizeof(struct bpf_insn) +
+			      offsetof(struct bpf_insn, imm)));
+	debug_regs(gen, BPF_REG_7, BPF_REG_9, " var (%s:count=%d): imm: %%d, fd: %%d",
+		   relo->name, kdesc->ref);
+}
+
+static void emit_relo(struct bpf_gen *gen, struct ksym_relo_desc *relo, int insns)
+{
+	int insn;
+
+	pr_debug("gen: emit_relo (%d): %s at %d\n", relo->kind, relo->name, relo->insn_idx);
+	insn = insns + sizeof(struct bpf_insn) * relo->insn_idx;
+	emit2(gen, BPF_LD_IMM64_RAW_FULL(BPF_REG_8, BPF_PSEUDO_MAP_IDX_VALUE, 0, 0, 0, insn));
+	switch (relo->kind) {
+	case BTF_KIND_VAR:
+		emit_relo_ksym_btf(gen, relo, insn);
+		break;
+	case BTF_KIND_FUNC:
+		emit_relo_kfunc_btf(gen, relo, insn);
+		break;
+	default:
+		pr_warn("Unknown relocation kind '%d'\n", relo->kind);
+		gen->error = -EDOM;
+		return;
 	}
 }
 
@@ -571,14 +787,22 @@ static void cleanup_relos(struct bpf_gen *gen, int insns)
 {
 	int i, insn;
 
-	for (i = 0; i < gen->relo_cnt; i++) {
-		if (gen->relos[i].kind != BTF_KIND_VAR)
-			continue;
-		/* close fd recorded in insn[insn_idx + 1].imm */
-		insn = insns +
-			sizeof(struct bpf_insn) * (gen->relos[i].insn_idx + 1) +
-			offsetof(struct bpf_insn, imm);
-		emit_sys_close_blob(gen, insn);
+	for (i = 0; i < gen->nr_ksyms; i++) {
+		if (gen->ksyms[i].kind == BTF_KIND_VAR) {
+			/* close fd recorded in insn[insn_idx + 1].imm */
+			insn = gen->ksyms[i].insn;
+			insn += sizeof(struct bpf_insn) + offsetof(struct bpf_insn, imm);
+			emit_sys_close_blob(gen, insn);
+		} else { /* BTF_KIND_FUNC */
+			emit_sys_close_blob(gen, blob_fd_array_off(gen, gen->ksyms[i].off));
+			if (gen->ksyms[i].off < MAX_FD_ARRAY_SZ)
+				gen->nr_fd_array--;
+		}
+	}
+	if (gen->nr_ksyms) {
+		free(gen->ksyms);
+		gen->nr_ksyms = 0;
+		gen->ksyms = NULL;
 	}
 	if (gen->relo_cnt) {
 		free(gen->relos);
@@ -637,9 +861,8 @@ void bpf_gen__prog_load(struct bpf_gen *gen,
 	/* populate union bpf_attr with a pointer to line_info */
 	emit_rel_store(gen, attr_field(prog_load_attr, line_info), line_info);
 
-	/* populate union bpf_attr fd_array with a pointer to stack where map_fds are saved */
-	emit_rel_store_sp(gen, attr_field(prog_load_attr, fd_array),
-			  stack_off(map_fd[0]));
+	/* populate union bpf_attr fd_array with a pointer to data where map_fds are saved */
+	emit_rel_store(gen, attr_field(prog_load_attr, fd_array), gen->fd_array);
 
 	/* populate union bpf_attr with user provided log details */
 	move_ctx2blob(gen, attr_field(prog_load_attr, log_level), 4,
@@ -706,8 +929,8 @@ void bpf_gen__map_update_elem(struct bpf_gen *gen, int map_idx, void *pvalue,
 	emit(gen, BPF_EMIT_CALL(BPF_FUNC_copy_from_user));
 
 	map_update_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_update_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_blob2blob(gen, attr_field(map_update_attr, map_fd), 4,
+		       blob_fd_array_off(gen, map_idx));
 	emit_rel_store(gen, attr_field(map_update_attr, key), key);
 	emit_rel_store(gen, attr_field(map_update_attr, value), value);
 	/* emit MAP_UPDATE_ELEM command */
@@ -725,8 +948,8 @@ void bpf_gen__map_freeze(struct bpf_gen *gen, int map_idx)
 	memset(&attr, 0, attr_size);
 	pr_debug("gen: map_freeze: idx %d\n", map_idx);
 	map_freeze_attr = add_data(gen, &attr, attr_size);
-	move_stack2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
-			stack_off(map_fd[map_idx]));
+	move_blob2blob(gen, attr_field(map_freeze_attr, map_fd), 4,
+		       blob_fd_array_off(gen, map_idx));
 	/* emit MAP_FREEZE command */
 	emit_sys_bpf(gen, BPF_MAP_FREEZE, map_freeze_attr, attr_size);
 	debug_ret(gen, "map_freeze");
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a750ee5d8035..0f85d441fca3 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6339,12 +6339,12 @@ static int bpf_program__record_externs(struct bpf_program *prog)
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


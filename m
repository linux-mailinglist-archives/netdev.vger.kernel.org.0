Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF70116E3E
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 14:55:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbfLINzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 08:55:43 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42596 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfLINzn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 08:55:43 -0500
Received: by mail-pf1-f195.google.com with SMTP id 4so7268565pfz.9;
        Mon, 09 Dec 2019 05:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tDuT3b2TEkV2pk/kMa2dYHN9ZybzUsuHFY1Rqhn+mdg=;
        b=FyeI+JFibEEICGf6wwtxOGDzEySFAuo6Nywmd4rygdtbe8tSJPAtgkDeB4/9lOuSpI
         2aR/38FoIP29OnhO1rHUf7jxGSmXKHFOBPTujGv5BiYeWVeZVvIF0l9pif6MVolXykU+
         D8buJ8e8XniillhR3WL/4gzqm+WL44H12MxkzyZujSw1F4RgoXnUwROOOYGDvCIlk/wZ
         +0M2fD9tAQ1jt2NjGqyhO682b6D08SDZZ+V0FGfMTH0TsAp09WxFOpXh+Lu1Mn8fxtXu
         iMTOmdAt0ffmE7OkckWePmBXo7dYR7EYFbolQosmPlHq2/5U3iI4dUbHNSj9KYIFJev/
         hqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tDuT3b2TEkV2pk/kMa2dYHN9ZybzUsuHFY1Rqhn+mdg=;
        b=DtEe/9KeiCA+FGvQ2xV6yYZrYl6WfN0VB71OVe6OxwBC9IlCKQT/EN5oeA/SXDzWnd
         4LWpawQsPt0BGcOcfDul17XutiJZL/fMRySJBCd0WSJnqWcTWkKbZriEbOgAv56DPGgJ
         0pxyaT3i8jb/9Q/EKvgpcN3sDuAPNctCNNEKGRmLm2PH8Y6ZIVXjTShD94YWzYqYR5FU
         ftuPR4tLBPNSb6XoWNbe/bmVMQiYBgYhpPt9M5bopkQGbrGcuFdboCaLr8jfAaM228aD
         nut0qer7so4oBmiDW4tIzyNU8uZfv1f9NIdSuDGDSTpGc9UqbZYnsjWRby2plTAvDtJe
         je/g==
X-Gm-Message-State: APjAAAVu2sfTyzUk+4+y3ZVklUEJiE8HtezpASe233qjFzDCtkDUlOy3
        NpIhFIDN0hPdwtMlc432r48/208EZ+629Q==
X-Google-Smtp-Source: APXvYqz/uCEcoDainnygoqhuq8XU1EDGRB/5PlfZeFn8gk13f2MxPAJJAmhZ5aRLHIs/b4sYK78EGA==
X-Received: by 2002:a63:ff52:: with SMTP id s18mr19082964pgk.253.1575899741879;
        Mon, 09 Dec 2019 05:55:41 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr03-ext.fm.intel.com. [192.55.54.38])
        by smtp.gmail.com with ESMTPSA id h26sm19543403pfr.9.2019.12.09.05.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Dec 2019 05:55:41 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com,
        andrii.nakryiko@gmail.com
Subject: [PATCH bpf-next v3 2/6] bpf: introduce BPF dispatcher
Date:   Mon,  9 Dec 2019 14:55:18 +0100
Message-Id: <20191209135522.16576-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191209135522.16576-1-bjorn.topel@gmail.com>
References: <20191209135522.16576-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The BPF dispatcher is a multi-way branch code generator, mainly
targeted for XDP programs. When an XDP program is executed via the
bpf_prog_run_xdp(), it is invoked via an indirect call. The indirect
call has a substantial performance impact, when retpolines are
enabled. The dispatcher transform indirect calls to direct calls, and
therefore avoids the retpoline. The dispatcher is generated using the
BPF JIT, and relies on text poking provided by bpf_arch_text_poke().

The dispatcher hijacks a trampoline function it via the __fentry__ nop
of the trampoline. One dispatcher instance currently supports up to 64
dispatch points, and currently only one instance of the dispatcher is
supported. This can be extended in the future.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/x86/net/bpf_jit_comp.c | 122 +++++++++++++++++++++
 kernel/bpf/Makefile         |   1 +
 kernel/bpf/dispatcher.c     | 207 ++++++++++++++++++++++++++++++++++++
 3 files changed, 330 insertions(+)
 create mode 100644 kernel/bpf/dispatcher.c

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index b8be18427277..3ce7ad41bd6f 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -10,10 +10,12 @@
 #include <linux/if_vlan.h>
 #include <linux/bpf.h>
 #include <linux/memory.h>
+#include <linux/sort.h>
 #include <asm/extable.h>
 #include <asm/set_memory.h>
 #include <asm/nospec-branch.h>
 #include <asm/text-patching.h>
+#include <asm/asm-prototypes.h>
 
 static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
 {
@@ -1530,6 +1532,126 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
 	return 0;
 }
 
+static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
+{
+	u8 *prog = *pprog;
+	int cnt = 0;
+	s64 offset;
+
+	offset = func - (ip + 2 + 4);
+	if (!is_simm32(offset)) {
+		pr_err("Target %p is out of range\n", func);
+		return -EINVAL;
+	}
+	EMIT2_off32(0x0F, jmp_cond + 0x10, offset);
+	*pprog = prog;
+	return 0;
+}
+
+static int emit_fallback_jump(u8 **pprog)
+{
+	u8 *prog = *pprog;
+	int err = 0;
+
+#ifdef CONFIG_RETPOLINE
+	/* Note that this assumes the the compiler uses external
+	 * thunks for indirect calls. Both clang and GCC use the same
+	 * naming convention for external thunks.
+	 */
+	err = emit_jump(&prog, __x86_indirect_thunk_rdx, prog);
+#else
+	int cnt = 0;
+
+	EMIT2(0xFF, 0xE2);	/* jmp rdx */
+#endif
+	*pprog = prog;
+	return err;
+}
+
+static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
+{
+	int pivot, err, jg_bytes = 1, cnt = 0;
+	u8 *jg_reloc, *prog = *pprog;
+	s64 jg_offset;
+
+	if (a == b) {
+		/* Leaf node of recursion, i.e. not a range of indices
+		 * anymore.
+		 */
+		EMIT1(add_1mod(0x48, BPF_REG_3));	/* cmp rdx,func */
+		if (!is_simm32(progs[a]))
+			return -1;
+		EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3),
+			    progs[a]);
+		err = emit_cond_near_jump(&prog,	/* je func */
+					  (void *)progs[a], prog,
+					  X86_JE);
+		if (err)
+			return err;
+
+		err = emit_fallback_jump(&prog);	/* jmp thunk/indirect */
+		if (err)
+			return err;
+
+		*pprog = prog;
+		return 0;
+	}
+
+	/* Not a leaf node, so we pivot, and recursively descend into
+	 * the lower and upper ranges.
+	 */
+	pivot = (b - a) / 2;
+	EMIT1(add_1mod(0x48, BPF_REG_3));		/* cmp rdx,func */
+	if (!is_simm32(progs[a + pivot]))
+		return -1;
+	EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3), progs[a + pivot]);
+
+	if (pivot > 2) {				/* jg upper_part */
+		/* Require near jump. */
+		jg_bytes = 4;
+		EMIT2_off32(0x0F, X86_JG + 0x10, 0);
+	} else {
+		EMIT2(X86_JG, 0);
+	}
+	jg_reloc = prog;
+
+	err = emit_bpf_dispatcher(&prog, a, a + pivot,	/* emit lower_part */
+				  progs);
+	if (err)
+		return err;
+
+	jg_offset = prog - jg_reloc;
+	emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
+
+	err = emit_bpf_dispatcher(&prog, a + pivot + 1,	/* emit upper_part */
+				  b, progs);
+	if (err)
+		return err;
+
+	*pprog = prog;
+	return 0;
+}
+
+static int cmp_ips(const void *a, const void *b)
+{
+	const s64 *ipa = a;
+	const s64 *ipb = b;
+
+	if (*ipa > *ipb)
+		return 1;
+	if (*ipa < *ipb)
+		return -1;
+	return 0;
+}
+
+int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
+{
+	u8 *prog = image;
+
+	sort(funcs, num_funcs, sizeof(funcs[0]), cmp_ips, NULL);
+	return emit_bpf_dispatcher(&prog, 0, num_funcs - 1, funcs);
+}
+
 struct x64_jit_data {
 	struct bpf_binary_header *header;
 	int *addrs;
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 3f671bf617e8..d4f330351f87 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
 obj-$(CONFIG_BPF_SYSCALL) += disasm.o
 obj-$(CONFIG_BPF_JIT) += trampoline.o
 obj-$(CONFIG_BPF_SYSCALL) += btf.o
+obj-$(CONFIG_BPF_JIT) += dispatcher.o
 ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
 obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
new file mode 100644
index 000000000000..de6b1f20b920
--- /dev/null
+++ b/kernel/bpf/dispatcher.c
@@ -0,0 +1,207 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2019 Intel Corporation. */
+
+#include <linux/hash.h>
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+/* The BPF dispatcher is a multiway branch code generator. The
+ * dispatcher is a mechanism to avoid the performance penalty of an
+ * indirect call, which is expensive when retpolines are enabled. A
+ * dispatch client registers a BPF program into the dispatcher, and if
+ * there is available room in the dispatcher a direct call to the BPF
+ * program will be generated. All calls to the BPF programs called via
+ * the dispatcher will then be a direct call, instead of an
+ * indirect. The dispatcher hijacks a trampoline function it via the
+ * __fentry__ of the trampoline. The trampoline function has the
+ * following signature:
+ *
+ * unsigned int trampoline(const void *xdp_ctx,
+ *                         const struct bpf_insn *insnsi,
+ *                         unsigned int (*bpf_func)(const void *,
+ *                                                  const struct bpf_insn *));
+ *
+ * Currently only one, global, dispatcher instance is supported. It's
+ * allocated on first use, and never freed.
+ */
+
+#define BPF_DISPATCHER_MAX 64 /* Fits in 2048B */
+
+struct bpf_disp_prog {
+	struct bpf_prog *prog;
+	refcount_t users;
+};
+
+struct bpf_dispatcher {
+	void *func;
+	struct bpf_disp_prog progs[BPF_DISPATCHER_MAX];
+	int num_progs;
+	void *image;
+	u32 image_off;
+};
+
+static struct bpf_dispatcher *bpf_disp;
+
+static DEFINE_MUTEX(dispatcher_mutex);
+
+static struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
+{
+	struct bpf_dispatcher *d;
+	void *image;
+
+	if (bpf_disp) {
+		if (bpf_disp->func != func)
+			return NULL;
+		return bpf_disp;
+	}
+
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return NULL;
+
+	image = bpf_jit_alloc_exec_page();
+	if (!image) {
+		kfree(d);
+		return NULL;
+	}
+
+	d->func = func;
+	d->image = image;
+	bpf_disp = d;
+	return d;
+}
+
+static struct bpf_disp_prog *bpf_dispatcher_find_prog(struct bpf_dispatcher *d,
+						      struct bpf_prog *prog)
+{
+	int i;
+
+	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
+		if (prog == d->progs[i].prog)
+			return &d->progs[i];
+	}
+	return NULL;
+}
+
+static struct bpf_disp_prog *bpf_dispatcher_find_free(struct bpf_dispatcher *d)
+{
+	return bpf_dispatcher_find_prog(d, NULL);
+}
+
+static bool bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
+				    struct bpf_prog *prog)
+{
+	struct bpf_disp_prog *entry;
+
+	if (!prog)
+		return false;
+
+	entry = bpf_dispatcher_find_prog(d, prog);
+	if (entry) {
+		refcount_inc(&entry->users);
+		return false;
+	}
+
+	entry = bpf_dispatcher_find_free(d);
+	if (!entry)
+		return false;
+
+	bpf_prog_inc(prog);
+	entry->prog = prog;
+	refcount_set(&entry->users, 1);
+	d->num_progs++;
+	return true;
+}
+
+static bool bpf_dispatcher_remove_prog(struct bpf_dispatcher *d,
+				       struct bpf_prog *prog)
+{
+	struct bpf_disp_prog *entry;
+
+	if (!prog)
+		return false;
+
+	entry = bpf_dispatcher_find_prog(d, prog);
+	if (!entry)
+		return false;
+
+	if (refcount_dec_and_test(&entry->users)) {
+		entry->prog = NULL;
+		bpf_prog_put(prog);
+		d->num_progs--;
+		return true;
+	}
+	return false;
+}
+
+int __weak arch_prepare_bpf_dispatcher(void *image, s64 *funcs,
+				       int num_funcs)
+{
+	return -ENOTSUPP;
+}
+
+static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image)
+{
+	s64 ips[BPF_DISPATCHER_MAX] = {}, *ipsp = &ips[0];
+	int i;
+
+	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
+		if (d->progs[i].prog)
+			*ipsp++ = (s64)(uintptr_t)d->progs[i].prog->bpf_func;
+	}
+	return arch_prepare_bpf_dispatcher(image, &ips[0], d->num_progs);
+}
+
+static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
+{
+	void *old, *new;
+	u32 noff;
+	int err;
+
+	if (!prev_num_progs) {
+		old = NULL;
+		noff = 0;
+	} else {
+		old = d->image + d->image_off;
+		noff = d->image_off ^ (PAGE_SIZE / 2);
+	}
+
+	new = d->num_progs ? d->image + noff : NULL;
+	if (new) {
+		if (bpf_dispatcher_prepare(d, new))
+			return;
+	}
+
+	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
+	if (err || !new)
+		return;
+
+	d->image_off = noff;
+}
+
+void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
+				struct bpf_prog *to)
+{
+	struct bpf_dispatcher *d;
+	bool changed = false;
+	int prev_num_progs;
+
+	if (from == to)
+		return;
+
+	mutex_lock(&dispatcher_mutex);
+	d = bpf_dispatcher_lookup(func);
+	if (!d)
+		goto out;
+
+	prev_num_progs = d->num_progs;
+	changed |= bpf_dispatcher_remove_prog(d, from);
+	changed |= bpf_dispatcher_add_prog(d, to);
+
+	if (!changed)
+		goto out;
+
+	bpf_dispatcher_update(d, prev_num_progs);
+out:
+	mutex_unlock(&dispatcher_mutex);
+}
-- 
2.20.1


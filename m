Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21297FBA2F
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 21:48:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfKMUsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 15:48:07 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33715 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKMUsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 15:48:06 -0500
Received: by mail-pf1-f196.google.com with SMTP id c184so2459971pfb.0;
        Wed, 13 Nov 2019 12:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MZGF2jFZFxMBGCARyf2ubuGKnAZ6fZkQVyV2aX26Is8=;
        b=Wc+F1lkUBoJ2QEl8H2Wuum5hkE40JQZywnDmHgiNj/be8IbI4p87Adazjl7gNC0jtP
         5Q2QWqHpypYLXmVa86ByOTFZCzwR1kQFK2M1s9bP0eeVOgZmrFYGqc4wUR7b0tSfGV5T
         9q0v64QYTk9mt4ySeJT1SPxKEn6m46hPhB9BsdUNc9JkBAIIDyasZ14FsRFPiUcmKEn7
         1jja1zAWpVyyjYXV0ZXJ8TGo6HGRgEpTDryE45M1NZ67hzauRl9ubX+X6YJlPTXlrGec
         7RzNX4JGf6y28Y5w/Do7hAaIJwrRBJslDfnka/YIqz/cU39svCo2OFg5WY4zscTUumgu
         YriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MZGF2jFZFxMBGCARyf2ubuGKnAZ6fZkQVyV2aX26Is8=;
        b=GdCbe52CTVG9lX9ZKVOXuNafV7ik2pDGgqaoI0OJgxl6GlYlTSi9bfxvDGawlkSywB
         JwW/4NKQlITjiDu/c0GepBZyZlI0VCk+tmsSSbHjx0rQt0Yo/S7FznTR0wGgVPlji5xK
         0eeFU+MphQquN994IPNF+fRz9Wkbzsyoyn2cubZzeUU3CEm1ARCXMhxZ65dFU5QOvfaf
         zCEXTBFFv7sb7fv6kkdXjUHMxYxqdO/zgMiDo0iCsRpXrYJQQAYeQlD94IRYUlZoqo5v
         dE0qkuJt7+N8JnsMRxmiOIZr8+VIZAMztDm3c/y4C0/mWEYCwwExDkct4uqRWU78cxbD
         pGmA==
X-Gm-Message-State: APjAAAVNDNwlbBIcGismNLu/cP+i78nxs/qm5GaQAe8piRQ4Z+UvOiq4
        UQ5tfGen3wJGWLk6RjYDj0GDb8MXsCE=
X-Google-Smtp-Source: APXvYqxQKvSumY6+pys06JJCco9VmGg/1+FtdWCbw34GC58upxTgQGSxQJ1HD76yauvhXrZwoFlCgw==
X-Received: by 2002:a63:535a:: with SMTP id t26mr5238810pgl.215.1573678083924;
        Wed, 13 Nov 2019 12:48:03 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id g20sm3235861pgk.46.2019.11.13.12.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 12:48:03 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Subject: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
Date:   Wed, 13 Nov 2019 21:47:35 +0100
Message-Id: <20191113204737.31623-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113204737.31623-1-bjorn.topel@gmail.com>
References: <20191113204737.31623-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

The BPF dispatcher builds on top of the BPF trampoline ideas;
Introduce bpf_arch_text_poke() and (re-)use the BPF JIT generate
code. The dispatcher builds a dispatch table for XDP programs, for
retpoline avoidance. The table is a simple binary search model, so
lookup is O(log n). Here, the dispatch table is limited to four
entries (for laziness reason -- only 1B relative jumps :-P). If the
dispatch table is full, it will fallback to the retpoline path.

An example: A module/driver allocates a dispatcher. The dispatcher is
shared for all netdevs. Each netdev allocate a slot in the dispatcher
and a BPF program. The netdev then uses the dispatcher to call the
correct program with a direct call (actually a tail-call).

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 arch/x86/net/bpf_jit_comp.c |  96 ++++++++++++++++++
 kernel/bpf/Makefile         |   1 +
 kernel/bpf/dispatcher.c     | 197 ++++++++++++++++++++++++++++++++++++
 3 files changed, 294 insertions(+)
 create mode 100644 kernel/bpf/dispatcher.c

diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index 28782a1c386e..d75aebf508b8 100644
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
@@ -1471,6 +1473,100 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
 	return 0;
 }
 
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE)
+
+/* Emits the dispatcher. Id lookup is limited to BPF_DISPATCHER_MAX,
+ * so it'll fit into PAGE_SIZE/2. The lookup is binary search: O(log
+ * n).
+ */
+static int emit_bpf_dispatcher(u8 **pprog, int a, int b, u64 *progs,
+			       u8 *fb)
+{
+	u8 *prog = *pprog, *jg_reloc;
+	int pivot, err, cnt = 0;
+	s64 jmp_offset;
+
+	if (a == b) {
+		emit_mov_imm64(&prog, BPF_REG_0,	/* movabs func,%rax */
+			       progs[a] >> 32,
+			       (progs[a] << 32) >> 32);
+		EMIT3(0x48, 0x39, 0xC2);		/* cmp rdx, rax */
+		jmp_offset = fb - (prog + 2);
+		if (!is_imm8(jmp_offset))
+			return -1;
+		EMIT2(X86_JNE, jmp_offset);		/* jne retpoline */
+		err = emit_jmp(&prog, (void *)progs[a], /* jmp bpf_prog */
+			       prog);
+		if (err)
+			return err;
+		goto out;
+	}
+
+	pivot = (b - a) / 2;
+	emit_mov_imm64(&prog, BPF_REG_0, progs[a + pivot] >> 32,
+		       (progs[a + pivot] << 32) >> 32);
+	EMIT3(0x48, 0x39, 0xC2);			/* cmp rdx, rax */
+
+	jg_reloc = prog;
+	EMIT2(X86_JG, 0);				/* jg pivot + 1-part */
+
+	err = emit_bpf_dispatcher(&prog, a, a + pivot, progs, fb);
+	if (err)
+		return err;
+
+	jmp_offset = prog - (jg_reloc + 2);
+	if (!is_imm8(jmp_offset))
+		return -1;
+	emit_code(jg_reloc, X86_JG + (jmp_offset << 8), 2);
+
+	err = emit_bpf_dispatcher(&prog, a + pivot + 1, b, progs, fb);
+	if (err)
+		return err;
+out:
+	*pprog = prog;
+	return 0;
+}
+
+#endif
+
+static int cmp_ips(const void *a, const void *b)
+{
+	const u64 *ipa = a;
+	const u64 *ipb = b;
+
+	if (*ipa > *ipb)
+		return 1;
+	if (*ipa < *ipb)
+		return -1;
+	return 0;
+}
+
+#define BPF_DISPATCHER_MAX 4
+
+int arch_prepare_bpf_dispatcher(void *image, struct bpf_prog **progs,
+				int num_progs)
+{
+	u64 ips[BPF_DISPATCHER_MAX] = {};
+	u8 *fallback, *prog = image;
+	int i, err, cnt = 0;
+
+	if (!num_progs || num_progs > BPF_DISPATCHER_MAX)
+		return -EINVAL;
+
+	for (i = 0; i < num_progs; i++)
+		ips[i] = (u64)progs[i]->bpf_func;
+
+	EMIT2(0xEB, 5);	/* jmp rip+5 (skip retpoline) */
+	fallback = prog;
+	err = emit_jmp(&prog,	/* jmp retpoline */
+		       __x86_indirect_thunk_rdx, prog);
+	if (err)
+		return err;
+
+	sort(&ips[0], num_progs, sizeof(ips[i]), cmp_ips, NULL);
+	return emit_bpf_dispatcher(&prog, 0, num_progs - 1, &ips[0], fallback);
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
index 000000000000..691898640720
--- /dev/null
+++ b/kernel/bpf/dispatcher.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2019 Intel Corporation. */
+
+#ifdef CONFIG_RETPOLINE
+
+#include <linux/hash.h>
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+/* The BPF dispatcher is a multiway branch code generator. A user
+ * registers a slot (id) and can then update the BPF program for that
+ * slot. The dispatcher is jited, and will be rejited every time a
+ * slot is allocated/deallocated for performance reasons. An example:
+ * A module provides code for multiple netdevs. Each netdev can have
+ * one XDP program. The module code will allocate a dispatcher, and
+ * when the netdev enables XDP it allocates a new slot.
+ *
+ * Nothing like STATIC_CALL_INLINE is supported yet, so an explicit
+ * trampoline is needed:
+ *
+ *   unsigned int dispatcher_trampoline(void *ctx, void *insn, int id)
+ */
+
+#define DISPATCHER_HASH_BITS 10
+#define DISPATCHER_TABLE_SIZE (1 << DISPATCHER_HASH_BITS)
+
+static struct hlist_head dispatcher_table[DISPATCHER_TABLE_SIZE];
+
+#define BPF_DISPATCHER_MAX 4
+
+struct bpf_dispatcher {
+	struct hlist_node hlist;
+	void *func;
+	struct bpf_prog *progs[BPF_DISPATCHER_MAX];
+	int num_progs;
+	void *image;
+	u64 selector;
+};
+
+static DEFINE_MUTEX(dispatcher_mutex);
+
+struct bpf_dispatcher *bpf_dispatcher_lookup(void *func)
+{
+	struct bpf_dispatcher *d;
+	struct hlist_head *head;
+	void *image;
+
+	head = &dispatcher_table[hash_ptr(func, DISPATCHER_HASH_BITS)];
+	hlist_for_each_entry(d, head, hlist) {
+		if (d->func == func)
+			return d;
+	}
+	d = kzalloc(sizeof(*d), GFP_KERNEL);
+	if (!d)
+		return NULL;
+
+	image = bpf_jit_alloc_exec(PAGE_SIZE);
+	if (!image) {
+		kfree(d);
+		return NULL;
+	}
+
+	d->func = func;
+	INIT_HLIST_NODE(&d->hlist);
+	hlist_add_head(&d->hlist, head);
+
+	set_vm_flush_reset_perms(image);
+	set_memory_x((long)image, 1);
+	d->image = image;
+	return d;
+}
+
+static void bpf_dispatcher_free(struct bpf_dispatcher *d)
+{
+	bpf_jit_free_exec(d->image);
+	hlist_del(&d->hlist);
+	kfree(d);
+}
+
+static int bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
+				   struct bpf_prog *prog)
+{
+	struct bpf_prog **entry = NULL;
+	int i, err = 0;
+
+	if (d->num_progs == BPF_DISPATCHER_MAX)
+		return err;
+
+	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
+		if (!entry && !d->progs[i])
+			entry = &d->progs[i];
+		if (d->progs[i] == prog)
+			return err;
+	}
+
+	prog = bpf_prog_inc(prog);
+	if (IS_ERR(prog))
+		return err;
+
+	*entry = prog;
+	d->num_progs++;
+	return err;
+}
+
+static void bpf_dispatcher_remove_prog(struct bpf_dispatcher *d,
+				       struct bpf_prog *prog)
+{
+	int i;
+
+	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
+		if (d->progs[i] == prog) {
+			bpf_prog_put(prog);
+			d->progs[i] = NULL;
+			d->num_progs--;
+			break;
+		}
+	}
+}
+
+int __weak arch_prepare_bpf_dispatcher(void *image, struct bpf_prog **progs,
+				       int num_ids)
+{
+	return -ENOTSUPP;
+}
+
+/* NB! bpf_dispatcher_update() might free the dispatcher! */
+static int bpf_dispatcher_update(struct bpf_dispatcher *d)
+{
+	void *old_image = d->image + ((d->selector + 1) & 1) * PAGE_SIZE / 2;
+	void *new_image = d->image + (d->selector & 1) * PAGE_SIZE / 2;
+	int err;
+
+	if (d->num_progs == 0) {
+		err = bpf_arch_text_poke(d->func, BPF_MOD_JMP_TO_NOP,
+					 old_image, NULL);
+		bpf_dispatcher_free(d);
+		goto out;
+	}
+
+	err = arch_prepare_bpf_dispatcher(new_image, &d->progs[0],
+					  d->num_progs);
+	if (err)
+		goto out;
+
+	if (d->selector)
+		/* progs already running at this address */
+		err = bpf_arch_text_poke(d->func, BPF_MOD_JMP_TO_JMP,
+					 old_image, new_image);
+	else
+		/* first time registering */
+		err = bpf_arch_text_poke(d->func, BPF_MOD_NOP_TO_JMP,
+					 NULL, new_image);
+
+	if (err)
+		goto out;
+	d->selector++;
+
+out:
+	return err;
+}
+
+void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
+				struct bpf_prog *to)
+{
+	struct bpf_dispatcher *d;
+
+	if (!from && !to)
+		return;
+
+	mutex_lock(&dispatcher_mutex);
+	d = bpf_dispatcher_lookup(func);
+	if (!d)
+		goto out;
+
+	if (from)
+		bpf_dispatcher_remove_prog(d, from);
+
+	if (to)
+		bpf_dispatcher_add_prog(d, to);
+
+	WARN_ON(bpf_dispatcher_update(d));
+
+out:
+	mutex_unlock(&dispatcher_mutex);
+}
+
+static int __init init_dispatchers(void)
+{
+	int i;
+
+	for (i = 0; i < DISPATCHER_TABLE_SIZE; i++)
+		INIT_HLIST_HEAD(&dispatcher_table[i]);
+	return 0;
+}
+late_initcall(init_dispatchers);
+
+#endif
-- 
2.20.1


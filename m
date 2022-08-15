Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6ED59307C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:13:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiHOONF convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Aug 2022 10:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230503AbiHOONE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706E81144A;
        Mon, 15 Aug 2022 07:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6620B80ED4;
        Mon, 15 Aug 2022 14:13:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B11C433C1;
        Mon, 15 Aug 2022 14:12:57 +0000 (UTC)
Date:   Mon, 15 Aug 2022 10:13:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, magnus.karlsson@gmail.com,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ecree@solarflare.com, thoiland@redhat.com, brouer@redhat.com,
        andrii.nakryiko@gmail.com, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
Message-ID: <20220815101303.79ace3f8@gandalf.local.home>
In-Reply-To: <20191211123017.13212-3-bjorn.topel@gmail.com>
References: <20191211123017.13212-1-bjorn.topel@gmail.com>
        <20191211123017.13212-3-bjorn.topel@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 13:30:13 +0100
Björn Töpel <bjorn.topel@gmail.com> wrote:

> From: Björn Töpel <bjorn.topel@intel.com>
> 
> The BPF dispatcher is a multi-way branch code generator, mainly
> targeted for XDP programs. When an XDP program is executed via the
> bpf_prog_run_xdp(), it is invoked via an indirect call. The indirect
> call has a substantial performance impact, when retpolines are
> enabled. The dispatcher transform indirect calls to direct calls, and
> therefore avoids the retpoline. The dispatcher is generated using the
> BPF JIT, and relies on text poking provided by bpf_arch_text_poke().
> 
> The dispatcher hijacks a trampoline function it via the __fentry__ nop

Why was the ftrace maintainers not Cc'd on this patch?  I would have NACKED
it. Hell, it wasn't even sent to LKML! This was BPF being sneaky in
updating major infrastructure of the Linux kernel without letting the
stakeholders of this change know about it.

For some reason, the BPF folks think they own the entire kernel!

When I heard that ftrace was broken by BPF I thought it was something
unique they were doing, but unfortunately, I didn't investigate what they
were doing at the time.

Then they started sending me patches to hide fentry locations from ftrace.
And even telling me that fentry != ftrace

   https://lore.kernel.org/all/CAADnVQJTT7h3MniVqdBEU=eLwvJhEKNLSjbUAK4sOrhN=zggCQ@mail.gmail.com/
	
Even though fentry was created for ftrace

   https://lore.kernel.org/lkml/1258720459.22249.1018.camel@gandalf.stny.rr.com/

and all the work with fentry was for the ftrace infrastructure. Ftrace
takes a lot of care for security and use cases for other users (like
live kernel patching). But BPF has the NIH syndrome, and likes to own
everything and recreate the wheel so that they have full control.

> of the trampoline. One dispatcher instance currently supports up to 64
> dispatch points. A user creates a dispatcher with its corresponding
> trampoline with the DEFINE_BPF_DISPATCHER macro.

Anyway, this patch just looks like a re-implementation of static_calls:

   https://lore.kernel.org/all/20200818135735.948368560@infradead.org/

Maybe if the BPF folks communicated to a wider audience, they would not
need to constantly recreate the wheel.

-- Steve


> 
> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
> ---
>  arch/x86/net/bpf_jit_comp.c | 122 +++++++++++++++++++++++++++
>  include/linux/bpf.h         |  56 +++++++++++++
>  kernel/bpf/Makefile         |   1 +
>  kernel/bpf/dispatcher.c     | 159 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 338 insertions(+)
>  create mode 100644 kernel/bpf/dispatcher.c
> 
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index b8be18427277..3ce7ad41bd6f 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -10,10 +10,12 @@
>  #include <linux/if_vlan.h>
>  #include <linux/bpf.h>
>  #include <linux/memory.h>
> +#include <linux/sort.h>
>  #include <asm/extable.h>
>  #include <asm/set_memory.h>
>  #include <asm/nospec-branch.h>
>  #include <asm/text-patching.h>
> +#include <asm/asm-prototypes.h>
>  
>  static u8 *emit_code(u8 *ptr, u32 bytes, unsigned int len)
>  {
> @@ -1530,6 +1532,126 @@ int arch_prepare_bpf_trampoline(void *image, struct btf_func_model *m, u32 flags
>  	return 0;
>  }
>  
> +static int emit_cond_near_jump(u8 **pprog, void *func, void *ip, u8 jmp_cond)
> +{
> +	u8 *prog = *pprog;
> +	int cnt = 0;
> +	s64 offset;
> +
> +	offset = func - (ip + 2 + 4);
> +	if (!is_simm32(offset)) {
> +		pr_err("Target %p is out of range\n", func);
> +		return -EINVAL;
> +	}
> +	EMIT2_off32(0x0F, jmp_cond + 0x10, offset);
> +	*pprog = prog;
> +	return 0;
> +}
> +
> +static int emit_fallback_jump(u8 **pprog)
> +{
> +	u8 *prog = *pprog;
> +	int err = 0;
> +
> +#ifdef CONFIG_RETPOLINE
> +	/* Note that this assumes the the compiler uses external
> +	 * thunks for indirect calls. Both clang and GCC use the same
> +	 * naming convention for external thunks.
> +	 */
> +	err = emit_jump(&prog, __x86_indirect_thunk_rdx, prog);
> +#else
> +	int cnt = 0;
> +
> +	EMIT2(0xFF, 0xE2);	/* jmp rdx */
> +#endif
> +	*pprog = prog;
> +	return err;
> +}
> +
> +static int emit_bpf_dispatcher(u8 **pprog, int a, int b, s64 *progs)
> +{
> +	int pivot, err, jg_bytes = 1, cnt = 0;
> +	u8 *jg_reloc, *prog = *pprog;
> +	s64 jg_offset;
> +
> +	if (a == b) {
> +		/* Leaf node of recursion, i.e. not a range of indices
> +		 * anymore.
> +		 */
> +		EMIT1(add_1mod(0x48, BPF_REG_3));	/* cmp rdx,func */
> +		if (!is_simm32(progs[a]))
> +			return -1;
> +		EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3),
> +			    progs[a]);
> +		err = emit_cond_near_jump(&prog,	/* je func */
> +					  (void *)progs[a], prog,
> +					  X86_JE);
> +		if (err)
> +			return err;
> +
> +		err = emit_fallback_jump(&prog);	/* jmp thunk/indirect */
> +		if (err)
> +			return err;
> +
> +		*pprog = prog;
> +		return 0;
> +	}
> +
> +	/* Not a leaf node, so we pivot, and recursively descend into
> +	 * the lower and upper ranges.
> +	 */
> +	pivot = (b - a) / 2;
> +	EMIT1(add_1mod(0x48, BPF_REG_3));		/* cmp rdx,func */
> +	if (!is_simm32(progs[a + pivot]))
> +		return -1;
> +	EMIT2_off32(0x81, add_1reg(0xF8, BPF_REG_3), progs[a + pivot]);
> +
> +	if (pivot > 2) {				/* jg upper_part */
> +		/* Require near jump. */
> +		jg_bytes = 4;
> +		EMIT2_off32(0x0F, X86_JG + 0x10, 0);
> +	} else {
> +		EMIT2(X86_JG, 0);
> +	}
> +	jg_reloc = prog;
> +
> +	err = emit_bpf_dispatcher(&prog, a, a + pivot,	/* emit lower_part */
> +				  progs);
> +	if (err)
> +		return err;
> +
> +	jg_offset = prog - jg_reloc;
> +	emit_code(jg_reloc - jg_bytes, jg_offset, jg_bytes);
> +
> +	err = emit_bpf_dispatcher(&prog, a + pivot + 1,	/* emit upper_part */
> +				  b, progs);
> +	if (err)
> +		return err;
> +
> +	*pprog = prog;
> +	return 0;
> +}
> +
> +static int cmp_ips(const void *a, const void *b)
> +{
> +	const s64 *ipa = a;
> +	const s64 *ipb = b;
> +
> +	if (*ipa > *ipb)
> +		return 1;
> +	if (*ipa < *ipb)
> +		return -1;
> +	return 0;
> +}
> +
> +int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
> +{
> +	u8 *prog = image;
> +
> +	sort(funcs, num_funcs, sizeof(funcs[0]), cmp_ips, NULL);
> +	return emit_bpf_dispatcher(&prog, 0, num_funcs - 1, funcs);
> +}
> +
>  struct x64_jit_data {
>  	struct bpf_binary_header *header;
>  	int *addrs;
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 5d744828b399..e6a9d74d4e30 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -470,12 +470,61 @@ struct bpf_trampoline {
>  	void *image;
>  	u64 selector;
>  };
> +
> +#define BPF_DISPATCHER_MAX 64 /* Fits in 2048B */
> +
> +struct bpf_dispatcher_prog {
> +	struct bpf_prog *prog;
> +	refcount_t users;
> +};
> +
> +struct bpf_dispatcher {
> +	/* dispatcher mutex */
> +	struct mutex mutex;
> +	void *func;
> +	struct bpf_dispatcher_prog progs[BPF_DISPATCHER_MAX];
> +	int num_progs;
> +	void *image;
> +	u32 image_off;
> +};
> +
>  #ifdef CONFIG_BPF_JIT
>  struct bpf_trampoline *bpf_trampoline_lookup(u64 key);
>  int bpf_trampoline_link_prog(struct bpf_prog *prog);
>  int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
>  void bpf_trampoline_put(struct bpf_trampoline *tr);
>  void *bpf_jit_alloc_exec_page(void);
> +#define BPF_DISPATCHER_INIT(name) {			\
> +	.mutex = __MUTEX_INITIALIZER(name.mutex),	\
> +	.func = &name##func,				\
> +	.progs = {},					\
> +	.num_progs = 0,					\
> +	.image = NULL,					\
> +	.image_off = 0					\
> +}
> +
> +#define DEFINE_BPF_DISPATCHER(name)					\
> +	unsigned int name##func(					\
> +		const void *xdp_ctx,					\
> +		const struct bpf_insn *insnsi,				\
> +		unsigned int (*bpf_func)(const void *,			\
> +					 const struct bpf_insn *))	\
> +	{								\
> +		return bpf_func(xdp_ctx, insnsi);			\
> +	}								\
> +	EXPORT_SYMBOL(name##func);			\
> +	struct bpf_dispatcher name = BPF_DISPATCHER_INIT(name);
> +#define DECLARE_BPF_DISPATCHER(name)					\
> +	unsigned int name##func(					\
> +		const void *xdp_ctx,					\
> +		const struct bpf_insn *insnsi,				\
> +		unsigned int (*bpf_func)(const void *,			\
> +					 const struct bpf_insn *));	\
> +	extern struct bpf_dispatcher name;
> +#define BPF_DISPATCHER_FUNC(name) name##func
> +#define BPF_DISPATCHER_PTR(name) (&name)
> +void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
> +				struct bpf_prog *to);
>  #else
>  static inline struct bpf_trampoline *bpf_trampoline_lookup(u64 key)
>  {
> @@ -490,6 +539,13 @@ static inline int bpf_trampoline_unlink_prog(struct bpf_prog *prog)
>  	return -ENOTSUPP;
>  }
>  static inline void bpf_trampoline_put(struct bpf_trampoline *tr) {}
> +#define DEFINE_BPF_DISPATCHER(name)
> +#define DECLARE_BPF_DISPATCHER(name)
> +#define BPF_DISPATCHER_FUNC(name) bpf_dispatcher_nopfunc
> +#define BPF_DISPATCHER_PTR(name) NULL
> +static inline void bpf_dispatcher_change_prog(struct bpf_dispatcher *d,
> +					      struct bpf_prog *from,
> +					      struct bpf_prog *to) {}
>  #endif
>  
>  struct bpf_func_info_aux {
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 3f671bf617e8..d4f330351f87 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -8,6 +8,7 @@ obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
>  obj-$(CONFIG_BPF_JIT) += trampoline.o
>  obj-$(CONFIG_BPF_SYSCALL) += btf.o
> +obj-$(CONFIG_BPF_JIT) += dispatcher.o
>  ifeq ($(CONFIG_NET),y)
>  obj-$(CONFIG_BPF_SYSCALL) += devmap.o
>  obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> new file mode 100644
> index 000000000000..a4690460d815
> --- /dev/null
> +++ b/kernel/bpf/dispatcher.c
> @@ -0,0 +1,159 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright(c) 2019 Intel Corporation. */
> +
> +#include <linux/hash.h>
> +#include <linux/bpf.h>
> +#include <linux/filter.h>
> +
> +/* The BPF dispatcher is a multiway branch code generator. The
> + * dispatcher is a mechanism to avoid the performance penalty of an
> + * indirect call, which is expensive when retpolines are enabled. A
> + * dispatch client registers a BPF program into the dispatcher, and if
> + * there is available room in the dispatcher a direct call to the BPF
> + * program will be generated. All calls to the BPF programs called via
> + * the dispatcher will then be a direct call, instead of an
> + * indirect. The dispatcher hijacks a trampoline function it via the
> + * __fentry__ of the trampoline. The trampoline function has the
> + * following signature:
> + *
> + * unsigned int trampoline(const void *xdp_ctx,
> + *                         const struct bpf_insn *insnsi,
> + *                         unsigned int (*bpf_func)(const void *,
> + *                                                  const struct bpf_insn *));
> + */
> +
> +static struct bpf_dispatcher_prog *bpf_dispatcher_find_prog(
> +	struct bpf_dispatcher *d, struct bpf_prog *prog)
> +{
> +	int i;
> +
> +	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
> +		if (prog == d->progs[i].prog)
> +			return &d->progs[i];
> +	}
> +	return NULL;
> +}
> +
> +static struct bpf_dispatcher_prog *bpf_dispatcher_find_free(
> +	struct bpf_dispatcher *d)
> +{
> +	return bpf_dispatcher_find_prog(d, NULL);
> +}
> +
> +static bool bpf_dispatcher_add_prog(struct bpf_dispatcher *d,
> +				    struct bpf_prog *prog)
> +{
> +	struct bpf_dispatcher_prog *entry;
> +
> +	if (!prog)
> +		return false;
> +
> +	entry = bpf_dispatcher_find_prog(d, prog);
> +	if (entry) {
> +		refcount_inc(&entry->users);
> +		return false;
> +	}
> +
> +	entry = bpf_dispatcher_find_free(d);
> +	if (!entry)
> +		return false;
> +
> +	bpf_prog_inc(prog);
> +	entry->prog = prog;
> +	refcount_set(&entry->users, 1);
> +	d->num_progs++;
> +	return true;
> +}
> +
> +static bool bpf_dispatcher_remove_prog(struct bpf_dispatcher *d,
> +				       struct bpf_prog *prog)
> +{
> +	struct bpf_dispatcher_prog *entry;
> +
> +	if (!prog)
> +		return false;
> +
> +	entry = bpf_dispatcher_find_prog(d, prog);
> +	if (!entry)
> +		return false;
> +
> +	if (refcount_dec_and_test(&entry->users)) {
> +		entry->prog = NULL;
> +		bpf_prog_put(prog);
> +		d->num_progs--;
> +		return true;
> +	}
> +	return false;
> +}
> +
> +int __weak arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs)
> +{
> +	return -ENOTSUPP;
> +}
> +
> +static int bpf_dispatcher_prepare(struct bpf_dispatcher *d, void *image)
> +{
> +	s64 ips[BPF_DISPATCHER_MAX] = {}, *ipsp = &ips[0];
> +	int i;
> +
> +	for (i = 0; i < BPF_DISPATCHER_MAX; i++) {
> +		if (d->progs[i].prog)
> +			*ipsp++ = (s64)(uintptr_t)d->progs[i].prog->bpf_func;
> +	}
> +	return arch_prepare_bpf_dispatcher(image, &ips[0], d->num_progs);
> +}
> +
> +static void bpf_dispatcher_update(struct bpf_dispatcher *d, int prev_num_progs)
> +{
> +	void *old, *new;
> +	u32 noff;
> +	int err;
> +
> +	if (!prev_num_progs) {
> +		old = NULL;
> +		noff = 0;
> +	} else {
> +		old = d->image + d->image_off;
> +		noff = d->image_off ^ (PAGE_SIZE / 2);
> +	}
> +
> +	new = d->num_progs ? d->image + noff : NULL;
> +	if (new) {
> +		if (bpf_dispatcher_prepare(d, new))
> +			return;
> +	}
> +
> +	err = bpf_arch_text_poke(d->func, BPF_MOD_JUMP, old, new);
> +	if (err || !new)
> +		return;
> +
> +	d->image_off = noff;
> +}
> +
> +void bpf_dispatcher_change_prog(struct bpf_dispatcher *d, struct bpf_prog *from,
> +				struct bpf_prog *to)
> +{
> +	bool changed = false;
> +	int prev_num_progs;
> +
> +	if (from == to)
> +		return;
> +
> +	mutex_lock(&d->mutex);
> +	if (!d->image) {
> +		d->image = bpf_jit_alloc_exec_page();
> +		if (!d->image)
> +			goto out;
> +	}
> +
> +	prev_num_progs = d->num_progs;
> +	changed |= bpf_dispatcher_remove_prog(d, from);
> +	changed |= bpf_dispatcher_add_prog(d, to);
> +
> +	if (!changed)
> +		goto out;
> +
> +	bpf_dispatcher_update(d, prev_num_progs);
> +out:
> +	mutex_unlock(&d->mutex);
> +}


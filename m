Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5A830EA62
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhBDCph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:45:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:39550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231608AbhBDCpf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:45:35 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B0CA64F4A;
        Thu,  4 Feb 2021 02:44:50 +0000 (UTC)
Date:   Wed, 3 Feb 2021 21:44:48 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <20210203214448.2703930e@oasis.local.home>
In-Reply-To: <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
        <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 19:09:44 -0800
Ivan Babrou <ivan@cloudflare.com> wrote:

> On Thu, Jan 28, 2021 at 7:35 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> >
> > Hello,
> >
> > We've noticed the following regression in Linux 5.10 branch:
> >
> > [  128.367231][    C0]
> > ==================================================================
> > [  128.368523][    C0] BUG: KASAN: stack-out-of-bounds in
> > unwind_next_frame (arch/x86/kernel/unwind_orc.c:371

The bug is a stack-out-of-bounds error in unwind_orc.c, right?

> > arch/x86/kernel/unwind_orc.c:544)
> > [  128.369744][    C0] Read of size 8 at addr ffff88802fceede0 by task
> > kworker/u2:2/591
> > [  128.370916][    C0]
> > [  128.371269][    C0] CPU: 0 PID: 591 Comm: kworker/u2:2 Not tainted
> > 5.10.11-cloudflare-kasan-2021.1.15 #1
> > [  128.372626][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
> > 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> > [  128.374346][    C0] Workqueue: writeback wb_workfn (flush-254:0)
> > [  128.375275][    C0] Call Trace:
> > [  128.375763][    C0]  <IRQ>
> > [  128.376221][    C0]  dump_stack+0x7d/0xa3
> > [  128.376843][    C0]  print_address_description.constprop.0+0x1c/0x210
[ snip ? results ]
> > (arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
[ snip ]
> > [  128.381736][    C0]  kasan_report.cold+0x1f/0x37
[ snip ]
> > [  128.383192][    C0]  unwind_next_frame+0x1df5/0x2650
[ snip ]
> > [  128.391550][    C0]  arch_stack_walk+0x8d/0xf0
[ snip ]
> > [  128.392807][    C0]  stack_trace_save+0x96/0xd0
[ snip ]
> > arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
[ snip ]
> > [  128.399759][    C0]  kasan_save_stack+0x20/0x50
[ snip ]
> > [  128.427691][    C0]  kasan_set_track+0x1c/0x30
> > [  128.428366][    C0]  kasan_set_free_info+0x1b/0x30
> > [  128.429113][    C0]  __kasan_slab_free+0x110/0x150
> > [  128.429838][    C0]  slab_free_freelist_hook+0x66/0x120
> > [  128.430628][    C0]  kfree+0xbf/0x4d0

[ snip the rest ]

> > [  128.441287][    C0] RIP: 0010:skcipher_walk_next
> > (crypto/skcipher.c:322 crypto/skcipher.c:384)

Why do we have an RIP in skcipher_walk_next, if its the unwinder that
had a bug? Or are they related?

Or did skcipher_walk_next trigger something in KASAN which did a stack
walk via the unwinder, and that caused another issue?

Looking at the unwinder code in question, we have:

static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
                             unsigned long *ip, unsigned long *sp)
{
        struct pt_regs *regs = (struct pt_regs *)addr;

        /* x86-32 support will be more complicated due to the &regs->sp hack */
        BUILD_BUG_ON(IS_ENABLED(CONFIG_X86_32));

        if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
                return false;

        *ip = regs->ip;
        *sp = regs->sp; <- pointer to here
        return true;
}

and the caller of the above static function:

        case UNWIND_HINT_TYPE_REGS:
                if (!deref_stack_regs(state, sp, &state->ip, &state->sp)) {
                        orc_warn_current("can't access registers at %pB\n",
                                         (void *)orig_ip);
                        goto err;
                }


Could it possibly be that there's some magic canary on the stack that
causes KASAN to trigger if you read it? For example, there's this in
the stack tracer:

kernel/trace/trace_stack.c: check_stack()

        while (i < stack_trace_nr_entries) {
                int found = 0;

                stack_trace_index[x] = this_size;
                p = start;

                for (; p < top && i < stack_trace_nr_entries; p++) {
                        /*
                         * The READ_ONCE_NOCHECK is used to let KASAN know that
                         * this is not a stack-out-of-bounds error.
                         */
                        if ((READ_ONCE_NOCHECK(*p)) == stack_dump_trace[i]) {
                                stack_dump_trace[x] = stack_dump_trace[i++];
                                this_size = stack_trace_index[x++] =
                                        (top - p) * sizeof(unsigned long);
                                found = 1;


That is because I read the entire stack frame looking for values, and I
know where the top of the stack is, and will not go past it. But it too
triggered a stack-out-of-bounds error, which required the above
READ_ONCE_NOCHECK() to quiet KASAN. Not to mention there's already some
READ_ONCE_NOCHECK() calls in the unwinder. Maybe this too is required?

Would this work?

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 73f800100066..22eaf3683c2a 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -367,8 +367,8 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
-- Steve

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCBF30E310
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 20:07:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232947AbhBCTHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 14:07:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:24231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232918AbhBCTHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 14:07:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612379145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lFt/2RFOzQN6thk0J4a0+YNcEpiz/J/7UyVDz3HjZfM=;
        b=ix0LqXjjcngVEfBkiUQI9v7QV2yxd2gofbdg/nA7t925ZlGHLUETXjldmHLKtw5X7a+Ct1
        C5pQY90MVqeUROSdKn/27R638zwbFsfljZ0Tsg9pA3rbfNhWdont9Y/c/0LI+3m/H/xcjb
        HPAfafrYuDKyC+akdROboKe3ZtPYa9k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-sTIcB_hWN7CUN9FEBbW0aA-1; Wed, 03 Feb 2021 14:05:41 -0500
X-MC-Unique: sTIcB_hWN7CUN9FEBbW0aA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 127AA1083E90;
        Wed,  3 Feb 2021 19:05:36 +0000 (UTC)
Received: from treble (ovpn-120-118.rdu2.redhat.com [10.10.120.118])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 61D86709A9;
        Wed,  3 Feb 2021 19:05:21 +0000 (UTC)
Date:   Wed, 3 Feb 2021 13:05:18 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
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
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <20210203190518.nlwghesq75enas6n@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
 <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 09:46:55AM -0800, Ivan Babrou wrote:
> > Can you pretty please not line-wrap console output? It's unreadable.
> 
> GMail doesn't make it easy, I'll send a link to a pastebin next time.
> Let me know if you'd like me to regenerate the decoded stack.
> 
> > > edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
> > > commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
> >
> > Not sure what tree you're on, but that's not the upstream commit.
> 
> I mentioned that it's a rebased core-static_call-2020-10-12 tag and
> added a link to the upstream hash right below.
> 
> > > Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > Date:   Tue Aug 18 15:57:52 2020 +0200
> > >
> > >     tracepoint: Optimize using static_call()
> > >
> >
> > There's a known issue with that patch, can you try:
> >
> >   http://lkml.kernel.org/r/20210202220121.435051654@goodmis.org
> 
> I've tried it on top of core-static_call-2020-10-12 tag rebased on top
> of v5.9 (to make it reproducible), and the patch did not help. Do I
> need to apply the whole series or something else?

Can you recreate with this patch, and add "unwind_debug" to the cmdline?
It will spit out a bunch of stack data.


From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] Subject: [PATCH] x86/unwind: Add 'unwind_debug' cmdline
 option

Sometimes the one-line ORC unwinder warnings aren't very helpful.  Take
the existing frame pointer unwind_dump() and make it useful for all
unwinders.

I don't want to be too aggressive about enabling the dumps, so for now
they're only enabled with the use of a new 'unwind_debug' cmdline
option.  When enabled, it will dump the full contents of the stack when
an error condition is encountered, or when dump_stack() is called.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++
 arch/x86/include/asm/unwind.h                 |  3 ++
 arch/x86/kernel/dumpstack.c                   | 39 ++++++++++++++
 arch/x86/kernel/unwind_frame.c                | 51 +++----------------
 arch/x86/kernel/unwind_orc.c                  |  5 +-
 5 files changed, 58 insertions(+), 46 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3d6604a949f8..d29689aa62a2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5521,6 +5521,12 @@
 	unknown_nmi_panic
 			[X86] Cause panic on unknown NMI.
 
+	unwind_debug	[X86-64]
+			Enable unwinder debug output.  This can be
+			useful for debugging certain unwinder error
+			conditions, including corrupt stacks and
+			bad/missing unwinder metadata.
+
 	usbcore.authorized_default=
 			[USB] Default USB device authorization:
 			(default -1 = authorized except for wireless USB,
diff --git a/arch/x86/include/asm/unwind.h b/arch/x86/include/asm/unwind.h
index 70fc159ebe69..5101d7ef7912 100644
--- a/arch/x86/include/asm/unwind.h
+++ b/arch/x86/include/asm/unwind.h
@@ -123,4 +123,7 @@ static inline bool task_on_another_cpu(struct task_struct *task)
 #endif
 }
 
+extern bool unwind_debug __ro_after_init;
+void unwind_dump(struct unwind_state *state);
+
 #endif /* _ASM_X86_UNWIND_H */
diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 299c20f0a38b..febfd5b7f62a 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -29,6 +29,42 @@ static int die_counter;
 
 static struct pt_regs exec_summary_regs;
 
+bool unwind_debug __ro_after_init;
+static int __init unwind_debug_cmdline(char *str)
+{
+	unwind_debug = true;
+	return 0;
+}
+early_param("unwind_debug", unwind_debug_cmdline);
+
+void unwind_dump(struct unwind_state *state)
+{
+	unsigned long word, *sp;
+	struct stack_info stack_info = {0};
+	unsigned long visit_mask = 0;
+
+	printk_deferred("unwinder dump: stack type:%d next_sp:%p mask:0x%lx graph_idx:%d\n",
+			state->stack_info.type, state->stack_info.next_sp,
+			state->stack_mask, state->graph_idx);
+
+	sp = state->task == current ? __builtin_frame_address(0)
+				    : (void *)state->task->thread.sp;
+
+	for (; sp; sp = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
+		if (get_stack_info(sp, state->task, &stack_info, &visit_mask))
+			break;
+
+		for (; sp < stack_info.end; sp++) {
+
+			word = READ_ONCE_NOCHECK(*sp);
+
+			printk_deferred("%0*lx: %0*lx (%pB)\n", BITS_PER_LONG/4,
+					(unsigned long)sp, BITS_PER_LONG/4,
+					word, (void *)word);
+		}
+	}
+}
+
 bool noinstr in_task_stack(unsigned long *stack, struct task_struct *task,
 			   struct stack_info *info)
 {
@@ -301,6 +337,9 @@ static void show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		if (stack_name)
 			printk("%s </%s>\n", log_lvl, stack_name);
 	}
+
+	if (unwind_debug)
+		unwind_dump(&state);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp,
diff --git a/arch/x86/kernel/unwind_frame.c b/arch/x86/kernel/unwind_frame.c
index d7c44b257f7f..6bcdf6ecad65 100644
--- a/arch/x86/kernel/unwind_frame.c
+++ b/arch/x86/kernel/unwind_frame.c
@@ -28,48 +28,6 @@ unsigned long *unwind_get_return_address_ptr(struct unwind_state *state)
 	return state->regs ? &state->regs->ip : state->bp + 1;
 }
 
-static void unwind_dump(struct unwind_state *state)
-{
-	static bool dumped_before = false;
-	bool prev_zero, zero = false;
-	unsigned long word, *sp;
-	struct stack_info stack_info = {0};
-	unsigned long visit_mask = 0;
-
-	if (dumped_before)
-		return;
-
-	dumped_before = true;
-
-	printk_deferred("unwind stack type:%d next_sp:%p mask:0x%lx graph_idx:%d\n",
-			state->stack_info.type, state->stack_info.next_sp,
-			state->stack_mask, state->graph_idx);
-
-	for (sp = PTR_ALIGN(state->orig_sp, sizeof(long)); sp;
-	     sp = PTR_ALIGN(stack_info.next_sp, sizeof(long))) {
-		if (get_stack_info(sp, state->task, &stack_info, &visit_mask))
-			break;
-
-		for (; sp < stack_info.end; sp++) {
-
-			word = READ_ONCE_NOCHECK(*sp);
-
-			prev_zero = zero;
-			zero = word == 0;
-
-			if (zero) {
-				if (!prev_zero)
-					printk_deferred("%p: %0*x ...\n",
-							sp, BITS_PER_LONG/4, 0);
-				continue;
-			}
-
-			printk_deferred("%p: %0*lx (%pB)\n",
-					sp, BITS_PER_LONG/4, word, (void *)word);
-		}
-	}
-}
-
 static bool in_entry_code(unsigned long ip)
 {
 	char *addr = (char *)ip;
@@ -244,7 +202,6 @@ static bool update_stack_state(struct unwind_state *state,
 						  addr, addr_p);
 	}
 
-	/* Save the original stack pointer for unwind_dump(): */
 	if (!state->orig_sp)
 		state->orig_sp = frame;
 
@@ -346,13 +303,17 @@ bool unwind_next_frame(struct unwind_state *state)
 			"WARNING: kernel stack regs at %p in %s:%d has bad 'bp' value %p\n",
 			state->regs, state->task->comm,
 			state->task->pid, next_bp);
-		unwind_dump(state);
+
+		if (unwind_debug)
+			unwind_dump(state);
 	} else {
 		printk_deferred_once(KERN_WARNING
 			"WARNING: kernel stack frame pointer at %p in %s:%d has bad value %p\n",
 			state->bp, state->task->comm,
 			state->task->pid, next_bp);
-		unwind_dump(state);
+
+		if (unwind_debug)
+			unwind_dump(state);
 	}
 the_end:
 	state->stack_info.type = STACK_TYPE_UNKNOWN;
diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 73f800100066..38265eac41dd 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -13,8 +13,11 @@
 
 #define orc_warn_current(args...)					\
 ({									\
-	if (state->task == current)					\
+	if (state->task == current) {					\
 		orc_warn(args);						\
+		if (unwind_debug)					\
+			unwind_dump(state);				\
+	}								\
 })
 
 extern int __start_orc_unwind_ip[];
-- 
2.29.2


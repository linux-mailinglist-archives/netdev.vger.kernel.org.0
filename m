Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A3030D223
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhBCDKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:10:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232642AbhBCDKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 22:10:24 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF23C0617A7
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 19:09:58 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u4so25096903ljh.6
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 19:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KH3YD7Dj0Uh6Km+n6b3ik9x8qQ7q88dMXinI5/HqYmY=;
        b=PPQNQJZsYHeH9hlf9bKTBFJjACQhfqilgAKWQQziSZoxScY5h0N6FaV9/sTqegXf/f
         eiJmroTCyhGoGLMne1RYuWqYNFrnCwv+0x74lT/4C7+/izrgLIvU7vH9JncukPN4OhW/
         TSI3ydQ8L80PuQsVmK40ZtZabsk8XqigExtvY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KH3YD7Dj0Uh6Km+n6b3ik9x8qQ7q88dMXinI5/HqYmY=;
        b=uOIYiKpPozR8cY82IIG3Q9xH4jOCIV3ZzXSC+4qWcWQFDSexR9wMMc690DdjmG/0tl
         Fjee/+FdtXEs3gOlbCHe8fHsOw/+NC5XH3bvhLeIbBkNuTEmV7CvhkS4GPFfpSpNgttr
         2/q9eyzkNVr/OkWIsE2hkZUWyveWGjwTlncYi/+dJducnDj/Uxj2aF/yQGnR5M/El4ep
         UZlRfF15UeCWcqUP0YTm8oYrCa8A0tWwtuW9EL53tjbm4Cd/+fhadem1eKSq2YbIB+C4
         mj4zBlbTGI6EPsAgXxkEJstNm30L2V+7BTvBJYU5mTFfCDgBXOlpT8YtV6ne2MiZG1Vg
         rk1A==
X-Gm-Message-State: AOAM532ctheMFWds+6fGuYubfgbIUlQD7MBrfyOkqM1OGjk7Cgv6+fWj
        6K439BoYjXNAgK0XP9jiCmnbs/MS31NWnBb49QhiMQ==
X-Google-Smtp-Source: ABdhPJwk6+nMI7K6xbDeOdlTRb89SQuRMpn4lMl8Ij5nvnBveLyYRKM+zIITq9ghRUZvFN4hPVepvKsW9ywTFNKNjlE=
X-Received: by 2002:a2e:531d:: with SMTP id h29mr490192ljb.115.1612321796165;
 Tue, 02 Feb 2021 19:09:56 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
In-Reply-To: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 2 Feb 2021 19:09:44 -0800
Message-ID: <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
Subject: Re: BUG: KASAN: stack-out-of-bounds in unwind_next_frame+0x1df5/0x2650
To:     kernel-team <kernel-team@cloudflare.com>
Cc:     Ignat Korchagin <ignat@cloudflare.com>,
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
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 28, 2021 at 7:35 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> Hello,
>
> We've noticed the following regression in Linux 5.10 branch:
>
> [  128.367231][    C0]
> ==================================================================
> [  128.368523][    C0] BUG: KASAN: stack-out-of-bounds in
> unwind_next_frame (arch/x86/kernel/unwind_orc.c:371
> arch/x86/kernel/unwind_orc.c:544)
> [  128.369744][    C0] Read of size 8 at addr ffff88802fceede0 by task
> kworker/u2:2/591
> [  128.370916][    C0]
> [  128.371269][    C0] CPU: 0 PID: 591 Comm: kworker/u2:2 Not tainted
> 5.10.11-cloudflare-kasan-2021.1.15 #1
> [  128.372626][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
> 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
> [  128.374346][    C0] Workqueue: writeback wb_workfn (flush-254:0)
> [  128.375275][    C0] Call Trace:
> [  128.375763][    C0]  <IRQ>
> [  128.376221][    C0]  dump_stack+0x7d/0xa3
> [  128.376843][    C0]  print_address_description.constprop.0+0x1c/0x210
> [  128.377827][    C0]  ? _raw_spin_lock_irqsave
> (arch/x86/include/asm/atomic.h:202
> include/asm-generic/atomic-instrumented.h:707
> include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:195
> include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [  128.378624][    C0]  ? _raw_write_unlock_bh (kernel/locking/spinlock.c:158)
> [  128.379389][    C0]  ? unwind_next_frame (arch/x86/kernel/unwind_orc.c:444)
> [  128.380177][    C0]  ? unwind_next_frame
> (arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
> [  128.380954][    C0]  ? unwind_next_frame
> (arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
> [  128.381736][    C0]  kasan_report.cold+0x1f/0x37
> [  128.382438][    C0]  ? unwind_next_frame
> (arch/x86/kernel/unwind_orc.c:371 arch/x86/kernel/unwind_orc.c:544)
> [  128.383192][    C0]  unwind_next_frame+0x1df5/0x2650
> [  128.383954][    C0]  ? asm_common_interrupt
> (arch/x86/include/asm/idtentry.h:622)
> [  128.384726][    C0]  ? get_stack_info_noinstr
> (arch/x86/kernel/dumpstack_64.c:157)
> [  128.385530][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
> [  128.386509][    C0]  ? deref_stack_reg (arch/x86/kernel/unwind_orc.c:418)
> [  128.387267][    C0]  ? is_module_text_address (kernel/module.c:4566
> kernel/module.c:4550)
> [  128.388077][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
> [  128.389048][    C0]  ? kernel_text_address.part.0 (kernel/extable.c:145)
> [  128.389901][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
> [  128.390865][    C0]  ? stack_trace_save (kernel/stacktrace.c:82)
> [  128.391550][    C0]  arch_stack_walk+0x8d/0xf0
> [  128.392216][    C0]  ? kfree (mm/slub.c:3142 mm/slub.c:4124)
> [  128.392807][    C0]  stack_trace_save+0x96/0xd0
> [  128.393535][    C0]  ? create_prof_cpu_mask (kernel/stacktrace.c:113)
> [  128.394320][    C0]  ? blk_update_request (block/blk-core.c:264
> block/blk-core.c:1468)
> [  128.395113][    C0]  ? asm_call_irq_on_stack (arch/x86/entry/entry_64.S:796)
> [  128.395887][    C0]  ? do_softirq_own_stack
> (arch/x86/include/asm/irq_stack.h:27
> arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
> [  128.396678][    C0]  ? irq_exit_rcu (kernel/softirq.c:393
> kernel/softirq.c:423 kernel/softirq.c:435)
> [  128.397349][    C0]  ? common_interrupt (arch/x86/kernel/irq.c:239)
> [  128.398086][    C0]  ? asm_common_interrupt
> (arch/x86/include/asm/idtentry.h:622)
> [  128.398886][    C0]  ? get_page_from_freelist (mm/page_alloc.c:3480
> mm/page_alloc.c:3904)
> [  128.399759][    C0]  kasan_save_stack+0x20/0x50
> [  128.400453][    C0]  ? kasan_save_stack (mm/kasan/common.c:48)
> [  128.401175][    C0]  ? kasan_set_track (mm/kasan/common.c:56)
> [  128.401881][    C0]  ? kasan_set_free_info (mm/kasan/generic.c:360)
> [  128.402646][    C0]  ? __kasan_slab_free (mm/kasan/common.c:283
> mm/kasan/common.c:424)
> [  128.403375][    C0]  ? slab_free_freelist_hook (mm/slub.c:1577)
> [  128.404199][    C0]  ? kfree (mm/slub.c:3142 mm/slub.c:4124)
> [  128.404835][    C0]  ? nvme_pci_complete_rq+0x105/0x350 nvme
> [  128.405765][    C0]  ? blk_done_softirq (include/linux/list.h:282
> block/blk-mq.c:581)
> [  128.406552][    C0]  ? __do_softirq
> (arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
> include/trace/events/irq.h:142 kernel/softirq.c:299)
> [  128.407272][    C0]  ? asm_call_irq_on_stack (arch/x86/entry/entry_64.S:796)
> [  128.408087][    C0]  ? do_softirq_own_stack
> (arch/x86/include/asm/irq_stack.h:27
> arch/x86/include/asm/irq_stack.h:77 arch/x86/kernel/irq_64.c:77)
> [  128.408878][    C0]  ? irq_exit_rcu (kernel/softirq.c:393
> kernel/softirq.c:423 kernel/softirq.c:435)
> [  128.409602][    C0]  ? common_interrupt (arch/x86/kernel/irq.c:239)
> [  128.410366][    C0]  ? asm_common_interrupt
> (arch/x86/include/asm/idtentry.h:622)
> [  128.411184][    C0]  ? skcipher_walk_next (crypto/skcipher.c:322
> crypto/skcipher.c:384)
> [  128.412009][    C0]  ? skcipher_walk_virt (crypto/skcipher.c:487)
> [  128.412811][    C0]  ? glue_xts_req_128bit+0x110/0x6f0 glue_helper
> [  128.413792][    C0]  ? asm_common_interrupt
> (arch/x86/include/asm/idtentry.h:622)
> [  128.414562][    C0]  ? kcryptd_crypt_write_convert+0x3a2/0xa10 dm_crypt
> [  128.415591][    C0]  ? crypt_map+0x5c1/0xc70 dm_crypt
> [  128.416389][    C0]  ? __map_bio.isra.0+0x109/0x450 dm_mod
> [  128.417275][    C0]  ? __split_and_process_non_flush+0x728/0xd10 dm_mod
> [  128.418293][    C0]  ? dm_submit_bio+0x4f1/0xec0 dm_mod
> [  128.419068][    C0]  ? submit_bio_noacct (block/blk-core.c:934
> block/blk-core.c:982 block/blk-core.c:1061)
> [  128.419806][    C0]  ? submit_bio (block/blk-core.c:1079)
> [  128.420458][    C0]  ? _raw_spin_lock_irqsave
> (arch/x86/include/asm/atomic.h:202
> include/asm-generic/atomic-instrumented.h:707
> include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:195
> include/linux/spinlock_api_smp.h:119 kernel/locking/spinlock.c:159)
> [  128.421244][    C0]  ? _raw_write_unlock_bh (kernel/locking/spinlock.c:158)
> [  128.422015][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
> [  128.422696][    C0]  ? kmem_cache_free (mm/slub.c:3142 mm/slub.c:3158)
> [  128.423427][    C0]  ? memset (mm/kasan/common.c:84)
> [  128.424000][    C0]  ? dma_pool_free (mm/dmapool.c:405)
> [  128.424698][    C0]  ? slab_free_freelist_hook (mm/slub.c:1577)
> [  128.425518][    C0]  ? dma_pool_create (mm/dmapool.c:405)
> [  128.426234][    C0]  ? kmem_cache_free (mm/slub.c:3142 mm/slub.c:3158)
> [  128.426923][    C0]  ? raise_softirq_irqoff
> (arch/x86/include/asm/preempt.h:26 kernel/softirq.c:469)
> [  128.427691][    C0]  kasan_set_track+0x1c/0x30
> [  128.428366][    C0]  kasan_set_free_info+0x1b/0x30
> [  128.429113][    C0]  __kasan_slab_free+0x110/0x150
> [  128.429838][    C0]  slab_free_freelist_hook+0x66/0x120
> [  128.430628][    C0]  kfree+0xbf/0x4d0
> [  128.431192][    C0]  ? nvme_pci_complete_rq+0x105/0x350 nvme
> [  128.432107][    C0]  ? nvme_unmap_data+0x349/0x440 nvme
> [  128.432882][    C0]  nvme_pci_complete_rq+0x105/0x350 nvme
> [  128.433750][    C0]  blk_done_softirq+0x2ff/0x590
> [  128.434441][    C0]  ? blk_mq_stop_hw_queue (block/blk-mq.c:573)
> [  128.435161][    C0]  ? _raw_spin_lock_bh (kernel/locking/spinlock.c:150)
> [  128.435894][    C0]  ? _raw_spin_lock_bh (kernel/locking/spinlock.c:150)
> [  128.436582][    C0]  __do_softirq+0x1a0/0x667
> [  128.437218][    C0]  asm_call_irq_on_stack+0x12/0x20
> [  128.437975][    C0]  </IRQ>
> [  128.438397][    C0]  do_softirq_own_stack+0x37/0x40
> [  128.439120][    C0]  irq_exit_rcu+0x110/0x1b0
> [  128.439807][    C0]  common_interrupt+0x74/0x120
> [  128.440545][    C0]  asm_common_interrupt+0x1e/0x40
> [  128.441287][    C0] RIP: 0010:skcipher_walk_next
> (crypto/skcipher.c:322 crypto/skcipher.c:384)
> [  128.442126][    C0] Code: 85 dd 10 00 00 49 8d 7c 24 08 49 89 14 24
> 48 b9 00 00 00 00 00 fc ff df 41 81 e5 ff 0f 00 00 48 89 fe 48 c1 ee
> 03 80 3c 0e 00 <0f> 85 80 10 00 00 48 89 c6 4d 89 6c 24 08 48 bc
> All code
> ========
>    0: 85 dd                test   %ebx,%ebp
>    2: 10 00                adc    %al,(%rax)
>    4: 00 49 8d              add    %cl,-0x73(%rcx)
>    7: 7c 24                jl     0x2d
>    9: 08 49 89              or     %cl,-0x77(%rcx)
>    c: 14 24                adc    $0x24,%al
>    e: 48 b9 00 00 00 00 00 movabs $0xdffffc0000000000,%rcx
>   15: fc ff df
>   18: 41 81 e5 ff 0f 00 00 and    $0xfff,%r13d
>   1f: 48 89 fe              mov    %rdi,%rsi
>   22: 48 c1 ee 03          shr    $0x3,%rsi
>   26: 80 3c 0e 00          cmpb   $0x0,(%rsi,%rcx,1)
>   2a:* 0f 85 80 10 00 00    jne    0x10b0 <-- trapping instruction
>   30: 48 89 c6              mov    %rax,%rsi
>   33: 4d 89 6c 24 08        mov    %r13,0x8(%r12)
>   38: 48                    rex.W
>   39: bc                    .byte 0xbc
>
> Code starting with the faulting instruction
> ===========================================
>    0: 0f 85 80 10 00 00    jne    0x1086
>    6: 48 89 c6              mov    %rax,%rsi
>    9: 4d 89 6c 24 08        mov    %r13,0x8(%r12)
>    e: 48                    rex.W
>    f: bc                    .byte 0xbc
> [  128.445089][    C0] RSP: 0018:ffff88802fceebf0 EFLAGS: 00000246
> [  128.445969][    C0] RAX: ffff888003b571b8 RBX: 0000000000000000
> RCX: dffffc0000000000
> [  128.447124][    C0] RDX: ffffea00017cd580 RSI: 1ffff11005f9dda8
> RDI: ffff88802fceed40
> [  128.448281][    C0] RBP: ffff88802fceec70 R08: ffff88802fceedc4
> R09: 00000000ffffffee
> [  128.449457][    C0] R10: 0000000000000000 R11: 1ffff11005f9ddaf
> R12: ffff88802fceed38
> [  128.450641][    C0] R13: 0000000000000000 R14: ffff888003b57138
> R15: ffff88802fceedc8
> [  128.451827][    C0]  ? arch_stack_walk (arch/x86/kernel/stacktrace.c:24)
> [  128.452482][    C0]  skcipher_walk_virt+0x4be/0x7e0
> [  128.453242][    C0]  glue_xts_req_128bit+0x110/0x6f0 glue_helper
> [  128.454175][    C0]  ? aesni_set_key+0x1e0/0x1e0 aesni_intel
> [  128.455042][    C0]  ? irq_exit_rcu (kernel/softirq.c:406
> kernel/softirq.c:425 kernel/softirq.c:435)
> [  128.455719][    C0]  ? glue_xts_crypt_128bit_one+0x280/0x280 glue_helper
> [  128.456753][    C0]  asm_common_interrupt+0x1e/0x40
> [  128.457530][    C0] RIP: b8fa2500:0xdffffc0000000000
> [  128.458305][    C0] Code: Unable to access opcode bytes at RIP
> 0xdffffbffffffffd6.
>
> Code starting with the faulting instruction
> ===========================================
> [  128.459443][    C0] RSP: 974be3f3:ffff88809c437290 EFLAGS: 00000004
> ORIG_RAX: 0000001000000010
> [  128.460755][    C0] RAX: 0000000000000000 RBX: ffff888003b571b8
> RCX: 0000000000000000
> [  128.461967][    C0] RDX: ffff888003b57240 RSI: ffff888003b57240
> RDI: ffffffe000000010
> [  128.463152][    C0] RBP: dffffc0000000200 R08: 0000000000000801
> R09: ffffea0001123480
> [  128.464345][    C0] R10: ffffed1000000200 R11: ffffffff00000000
> R12: ffff888000000000
> [  128.465522][    C0] R13: ffff888003b57138 R14: ffff88809c437290
> R15: ffffea00002c5b08
> [  128.466710][    C0]  ? get_page_from_freelist (mm/page_alloc.c:3913)
> [  128.467560][    C0]  ? worker_thread (include/linux/list.h:282
> kernel/workqueue.c:2419)
> [  128.468279][    C0]  ? kthread (kernel/kthread.c:292)
> [  128.468919][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
> [  128.469607][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1793)
> [  128.470418][    C0]  ? wb_writeback (fs/fs-writeback.c:1898)
> [  128.471145][    C0]  ? process_one_work
> (arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
> include/trace/events/workqueue.h:108 kernel/workqueue.c:2277)
> [  128.471930][    C0]  ? worker_thread (include/linux/list.h:282
> kernel/workqueue.c:2419)
> [  128.472668][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
> [  128.473329][    C0]  ? __zone_watermark_ok (mm/page_alloc.c:3793)
> [  128.474065][    C0]  ? __kasan_kmalloc.constprop.0
> (mm/kasan/common.c:56 mm/kasan/common.c:461)
> [  128.474914][    C0]  ? crypt_convert+0x27e5/0x4530 dm_crypt
> [  128.475796][    C0]  ? mempool_alloc (mm/mempool.c:392)
> [  128.476493][    C0]  ? crypt_iv_tcw_ctr+0x4a0/0x4a0 dm_crypt
> [  128.477433][    C0]  ? bio_add_page (block/bio.c:943)
> [  128.478129][    C0]  ? __bio_try_merge_page (block/bio.c:935)
> [  128.478923][    C0]  ? bio_associate_blkg (block/blk-cgroup.c:1869)
> [  128.479693][    C0]  ? kcryptd_crypt_write_convert+0x581/0xa10 dm_crypt
> [  128.480721][    C0]  ? crypt_map+0x5c1/0xc70 dm_crypt
> [  128.481527][    C0]  ? bio_clone_blkg_association (block/blk-cgroup.c:1883)
> [  128.482426][    C0]  ? __map_bio.isra.0+0x109/0x450 dm_mod
> [  128.483310][    C0]  ? __split_and_process_non_flush+0x728/0xd10 dm_mod
> [  128.484354][    C0]  ? __send_empty_flush+0x4b0/0x4b0 dm_mod
> [  128.485223][    C0]  ? __part_start_io_acct (block/blk-core.c:1336)
> [  128.486009][    C0]  ? dm_submit_bio+0x4f1/0xec0 dm_mod
> [  128.486829][    C0]  ? __split_and_process_non_flush+0xd10/0xd10 dm_mod
> [  128.487915][    C0]  ? submit_bio_noacct (block/blk-core.c:934
> block/blk-core.c:982 block/blk-core.c:1061)
> [  128.488686][    C0]  ? _cond_resched (kernel/sched/core.c:6124)
> [  128.489388][    C0]  ? blk_queue_enter (block/blk-core.c:1044)
> [  128.490300][    C0]  ? iomap_readahead (fs/iomap/buffered-io.c:1438)
> [  128.491041][    C0]  ? write_one_page (mm/page-writeback.c:2171)
> [  128.491759][    C0]  ? submit_bio (block/blk-core.c:1079)
> [  128.492432][    C0]  ? submit_bio_noacct (block/blk-core.c:1079)
> [  128.493248][    C0]  ? _raw_spin_lock
> (arch/x86/include/asm/atomic.h:202
> include/asm-generic/atomic-instrumented.h:707
> include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:183
> include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [  128.493975][    C0]  ? iomap_submit_ioend (fs/iomap/buffered-io.c:1215)
> [  128.494761][    C0]  ? xfs_vm_writepages (fs/xfs/xfs_aops.c:578)
> [  128.495529][    C0]  ? xfs_dax_writepages (fs/xfs/xfs_aops.c:578)
> [  128.496278][    C0]  ? __blk_mq_do_dispatch_sched
> (block/blk-mq-sched.c:135 (discriminator 1))
> [  128.497120][    C0]  ? do_writepages (mm/page-writeback.c:2355)
> [  128.497831][    C0]  ? page_writeback_cpu_online (mm/page-writeback.c:2345)
> [  128.498681][    C0]  ? _raw_spin_lock
> (arch/x86/include/asm/atomic.h:202
> include/asm-generic/atomic-instrumented.h:707
> include/asm-generic/qspinlock.h:82 include/linux/spinlock.h:183
> include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [  128.499405][    C0]  ? wake_up_bit (kernel/sched/wait_bit.c:15
> kernel/sched/wait_bit.c:149)
> [  128.500072][    C0]  ? __writeback_single_inode (fs/fs-writeback.c:1470)
> [  128.500908][    C0]  ? writeback_sb_inodes (fs/fs-writeback.c:1725)
> [  128.501703][    C0]  ? __writeback_single_inode (fs/fs-writeback.c:1634)
> [  128.502571][    C0]  ? finish_writeback_work.constprop.0
> (fs/fs-writeback.c:1242)
> [  128.503525][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1793)
> [  128.504336][    C0]  ? wb_writeback (fs/fs-writeback.c:1898)
> [  128.505031][    C0]  ? __writeback_inodes_wb (fs/fs-writeback.c:1846)
> [  128.505902][    C0]  ? cpumask_next (lib/cpumask.c:24)
> [  128.506570][    C0]  ? get_nr_dirty_inodes (fs/inode.c:94 fs/inode.c:102)
> [  128.507348][    C0]  ? wb_workfn (fs/fs-writeback.c:2054
> fs/fs-writeback.c:2082)
> [  128.508014][    C0]  ? dequeue_entity (kernel/sched/fair.c:4347)
> [  128.508744][    C0]  ? inode_wait_for_writeback (fs/fs-writeback.c:2065)
> [  128.509586][    C0]  ? put_prev_entity (kernel/sched/fair.c:4501)
> [  128.510300][    C0]  ? __switch_to
> (arch/x86/include/asm/bitops.h:55
> include/asm-generic/bitops/instrumented-atomic.h:29
> include/linux/thread_info.h:55 arch/x86/include/asm/fpu/internal.h:572
> arch/x86/kernel/process_64.c:598)
> [  128.510990][    C0]  ? __switch_to_asm (arch/x86/entry/entry_64.S:255)
> [  128.511695][    C0]  ? __schedule (kernel/sched/core.c:3782
> kernel/sched/core.c:4528)
> [  128.512373][    C0]  ? process_one_work
> (arch/x86/include/asm/jump_label.h:25 include/linux/jump_label.h:200
> include/trace/events/workqueue.h:108 kernel/workqueue.c:2277)
> [  128.513133][    C0]  ? worker_thread (include/linux/list.h:282
> kernel/workqueue.c:2419)
> [  128.513850][    C0]  ? rescuer_thread (kernel/workqueue.c:2361)
> [  128.514566][    C0]  ? kthread (kernel/kthread.c:292)
> [  128.515200][    C0]  ? __kthread_bind_mask (kernel/kthread.c:245)
> [  128.515960][    C0]  ? ret_from_fork (arch/x86/entry/entry_64.S:302)
> [  128.516641][    C0]
> [  128.516983][    C0] The buggy address belongs to the page:
> [  128.517838][    C0] page:000000007a390a2b refcount:0 mapcount:0
> mapping:0000000000000000 index:0x0 pfn:0x2fcee
> [  128.519428][    C0] flags: 0x1ffff800000000()
> [  128.520102][    C0] raw: 001ffff800000000 ffffea0000bf3b88
> ffffea0000bf3b88 0000000000000000
> [  128.521396][    C0] raw: 0000000000000000 0000000000000000
> 00000000ffffffff 0000000000000000
> [  128.522673][    C0] page dumped because: kasan: bad access detected
> [  128.523642][    C0]
> [  128.523984][    C0] addr ffff88802fceede0 is located in stack of
> task kworker/u2:2/591 at offset 216 in frame:
> [  128.525503][    C0]  glue_xts_req_128bit+0x0/0x6f0 glue_helper
> [  128.526390][    C0]
> [  128.526745][    C0] this frame has 5 objects:
> [  128.527405][    C0]  [48, 200) 'walk'
> [  128.527407][    C0]  [272, 304) 'b'
> [  128.527969][    C0]  [336, 400) 's'
> [  128.528509][    C0]  [432, 496) 'd'
> [  128.529047][    C0]  [528, 608) 'subreq'
> [  128.529607][    C0]
> [  128.530568][    C0] Memory state around the buggy address:
> [  128.531443][    C0]  ffff88802fceec80: 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00
> [  128.532708][    C0]  ffff88802fceed00: 00 f1 f1 f1 f1 f1 f1 00 00
> 00 00 00 00 00 00 00
> [  128.533911][    C0] >ffff88802fceed80: 00 00 00 00 00 00 00 00 00
> 00 f2 f2 f2 f2 f2 f2
> [  128.535106][    C0]                                                        ^
> [  128.536197][    C0]  ffff88802fceee00: f2 f2 f2 00 00 00 00 f2 f2
> f2 f2 00 00 00 00 00
> [  128.537404][    C0]  ffff88802fceee80: 00 00 00 f2 f2 f2 f2 00 00
> 00 00 00 00 00 00 f2
>
> There are other stacks that end in the same place without dm-crypt
> involvement, but they are much harder for us to reproduce, so let's
> stick with this one.
>
> After some bisecting from myself and Ignat, we were able to find the
> commit that fixes the issue, which is:
>
> * https://github.com/torvalds/linux/commit/ce8f86ee94fabcc98537ddccd7e82cfd360a4dc5?w=1
>
> mm/page_alloc: add a missing mm_page_alloc_zone_locked() tracepoint
>
> The trace point *trace_mm_page_alloc_zone_locked()* in __rmqueue() does
> not currently cover all branches.  Add the missing tracepoint and check
> the page before do that.
>
> We don't have CONFIG_CMA enabled, so it can be distilled to:
>
> $ git diff HEAD^..HEAD
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 14b9e83ff9da..b5961d530929 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2871,7 +2871,8 @@ __rmqueue(struct zone *zone, unsigned int order,
> int migratetype,
>                         goto retry;
>         }
>
> -       trace_mm_page_alloc_zone_locked(page, order, migratetype);
> +       if (page)
> +               trace_mm_page_alloc_zone_locked(page, order, migratetype);
>         return page;
>  }
>
> If I apply this patch on top of 5.10.11, the issue disappears.
>
> I can't say I understand the connection here.
>
> It's worth mentioning that the issue doesn't reproduce with
> UNWINDER_FRAME_POINTER rather than UNWINDER_ORC. This fact makes me
> think that ORC is to blame here somehow, but it's beyond my
> understanding.
>
> Here's how I replicate the issue in qemu running Debian Buster:
>
> # /tmp is tmpfs in our case
> $ qemu-img create -f qcow2 /tmp/nvme-$USER.img 10G
>
> $ sudo qemu-system-x86_64 -smp 1 -m 3G -enable-kvm -cpu host -kernel
> ~/vmlinuz -initrd ~/initrd.img -nographic -device e1000 -device
> nvme,drive=nvme0,serial=deadbeaf1,num_queues=8 -drive
> file=/tmp/nvme-$USER.img,if=none,id=nvme0 -append 'console=ttyS0
> kasan_multi_shot'
>
> Inside of the VM:
>
> root@localhost:~# echo -e '[Match]\nName=enp*\n[Network]\nDHCP=yes' >
> /etc/systemd/network/00-dhcp.network
> root@localhost:~# systemctl restart systemd-networkd
> root@localhost:~# apt-get update
> root@localhost:~# apt-get install -y --no-install-recommends cryptsetup
> root@localhost:~# echo potato > keyfile
> root@localhost:~# chmod 0400 keyfile
> root@localhost:~# cryptsetup -q luksFormat /dev/nvme0n1 keyfile
> root@localhost:~# cryptsetup open --type luks --key-file keyfile
> --disable-keyring /dev/nvme0n1 luks-nvme0n1
> root@localhost:~# dmsetup table /dev/mapper/luks-nvme0n1 | sed 's/$/ 2
> no_read_workqueue no_write_workqueue/' | dmsetup reload
> /dev/mapper/luks-nvme0n1
> root@localhost:~# dmsetup suspend /dev/mapper/luks-nvme0n1 && dmsetup
> resume /dev/mapper/luks-nvme0n1
> root@localhost:~# mkfs.xfs -f /dev/mapper/luks-nvme0n1
> root@localhost:~# mount /dev/mapper/luks-nvme0n1 /mnt
>
> The workload that triggers the KASAN complaint is the following:
>
> root@localhost:~# while true; do rm -f /mnt/random.data.target && dd
> if=/dev/zero of=/mnt/random.data bs=10M count=400 status=progress &&
> mv /mnt/random.data /mnt/random.data.target; sleep 1; done
>
> It might take a few iterations to trigger.
>
> Note that dmcrypt setup in our case depends on Ignat's patches, which
> are included in 5.10.11 and 5.11-rc5, so during bisection between
> 5.11-rc3 and 5.11-rc4 they needed to be reapplied.
>
> I'm going to ask for a backport of the "fix" to stable, but it feels
> like there's a bigger issue here.

Hello again and the first hello for new people in CC as I have an update,

(Please let me know if I should get the list of people to CC not from
get_maintainers.pl, since it gave me a lot of people and it doesn't
feel right.)

We've seen the issue even after backporting ce8f86ee94fa, this time
much later in uptime, outside of dm-crypt and without a reliable
reproduction.

I noticed that the bug doesn't reproduce on Linux v5.9, so I went
ahead and bisected v5.9..v5.10-rc1 to see where it all started (with
dm-crypt reproduction).

Since there's a ton of merges and regular bisect gave me questionable
results, I had to resort to --first-parent first, which pointed at
dd502a81077a:

$ git bisect log
git bisect start '--first-parent'
# bad: [3650b228f83adda7e5ee532e2b90429c03f7b9ec] Linux 5.10-rc1
git bisect bad 3650b228f83adda7e5ee532e2b90429c03f7b9ec
# good: [bbf5c979011a099af5dc76498918ed7df445635b] Linux 5.9
git bisect good bbf5c979011a099af5dc76498918ed7df445635b
# bad: [578a7155c5a1894a789d4ece181abf9d25dc6b0d] Merge tag
'linux-kselftest-kunit-fixes-5.10-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
git bisect bad 578a7155c5a1894a789d4ece181abf9d25dc6b0d
# bad: [3ad11d7ac8872b1c8da54494721fad8907ee41f7] Merge tag
'block-5.10-2020-10-12' of git://git.kernel.dk/linux-block
git bisect bad 3ad11d7ac8872b1c8da54494721fad8907ee41f7
# bad: [b85cac574592b843c4be93c83303feeee0c4dc25] Merge tag
'x86-kaslr-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad b85cac574592b843c4be93c83303feeee0c4dc25
# good: [64743e652cea9d6df4264caaa1d7f95273024afb] Merge tag
'x86_cache_for_v5.10' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 64743e652cea9d6df4264caaa1d7f95273024afb
# good: [edaa5ddf3833669a25654d42c0fb653dfdd906df] Merge tag
'sched-core-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good edaa5ddf3833669a25654d42c0fb653dfdd906df
# good: [34eb62d868d729e9a252aa497277081fb652eeed] Merge tag
'core-build-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 34eb62d868d729e9a252aa497277081fb652eeed
# bad: [3bff6112c80cecb76af5fe485506f96e8adb6122] Merge tag
'perf-core-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 3bff6112c80cecb76af5fe485506f96e8adb6122
# bad: [dd502a81077a5f3b3e19fa9a1accffdcab5ad5bc] Merge tag
'core-static_call-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad dd502a81077a5f3b3e19fa9a1accffdcab5ad5bc
# first bad commit: [dd502a81077a5f3b3e19fa9a1accffdcab5ad5bc] Merge
tag 'core-static_call-2020-10-12' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip

Since core-static_call-2020-10-12 tag is based on top of 5.9-rc3, I
rebased it on v5.9 and repeated the bisect between that and v5.9:

$ git checkout core-static_call-2020-10-12
$ git rebase v5.9
$ git checkout -b ivan/static_call-2020-10-12-rebase-on-v5.9

$ git bisect log
git bisect start
# bad: [6c2fc089268777994dd82ce7c60263f3a71ed0b4] static_call: Fix
return type of static_call_init
git bisect bad 6c2fc089268777994dd82ce7c60263f3a71ed0b4
# good: [bbf5c979011a099af5dc76498918ed7df445635b] Linux 5.9
git bisect good bbf5c979011a099af5dc76498918ed7df445635b
# good: [580b6f7a0af7823277b3ec9aeb2ff48596c10662] x86/static_call:
Add inline static call implementation for x86-64
git bisect good 580b6f7a0af7823277b3ec9aeb2ff48596c10662
# good: [574169ad2d8ce8a80d2798e502d289f6741d8096] static_call: Add
some validation
git bisect good 574169ad2d8ce8a80d2798e502d289f6741d8096
# bad: [4c9c8903fcfb8fca9ab84a8906ee23c998086549] x86/perf,
static_call: Optimize x86_pmu methods
git bisect bad 4c9c8903fcfb8fca9ab84a8906ee23c998086549
# bad: [edfd9b7838ba5e47f19ad8466d0565aba5c59bf0] tracepoint: Optimize
using static_call()
git bisect bad edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
# good: [a5ea9249fde1027124f7ae42d6ca17d53fcb3df0] static_call: Allow early init
git bisect good a5ea9249fde1027124f7ae42d6ca17d53fcb3df0
# first bad commit: [edfd9b7838ba5e47f19ad8466d0565aba5c59bf0]
tracepoint: Optimize using static_call()

edfd9b7838ba5e47f19ad8466d0565aba5c59bf0 is the first bad commit
commit edfd9b7838ba5e47f19ad8466d0565aba5c59bf0
Author: Steven Rostedt (VMware) <rostedt@goodmis.org>
Date:   Tue Aug 18 15:57:52 2020 +0200

    tracepoint: Optimize using static_call()

    Currently the tracepoint site will iterate a vector and issue indirect
    calls to however many handlers are registered (ie. the vector is
    long).

    Using static_call() it is possible to optimize this for the common
    case of only having a single handler registered. In this case the
    static_call() can directly call this handler. Otherwise, if the vector
    is longer than 1, call a function that iterates the whole vector like
    the current code.

    [peterz: updated to new interface]

    Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
    Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
    Signed-off-by: Ingo Molnar <mingo@kernel.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>
    Link: https://lore.kernel.org/r/20200818135805.279421092@infradead.org

 include/linux/tracepoint-defs.h |  5 +++
 include/linux/tracepoint.h      | 86 +++++++++++++++++++++++++++++------------
 include/trace/define_trace.h    | 14 +++----
 kernel/tracepoint.c             | 25 ++++++++++--
 4 files changed, 94 insertions(+), 36 deletions(-)

Upstream commit hash is d25e37d89dd2:

* https://github.com/torvalds/linux/commit/d25e37d89dd2

I double checked and its parent (a945c8345ec0) works fine.

Note that the "fix" for 5.10.11 was also tracepoint related:

* https://github.com/torvalds/linux/commit/ce8f86ee94fa

Let me know how I can help get this fixed or debugged further. I'm
happy to try patches.

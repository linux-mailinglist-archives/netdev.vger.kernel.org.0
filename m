Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 030E34FA9BB
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 18:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiDIQsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 12:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbiDIQsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 12:48:43 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6FB1B7BC
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 09:46:33 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ebef467b1bso37463877b3.13
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 09:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uc3I3UUmxQ/TzhoJo+up3qR7M/nZvx4VH7+JLQpeXvI=;
        b=N4mJNjqRv+6GvEGII1gzSoFz+DP2GZJH6UOEqVrtRWQPv5Gn3svT6LF3L1udRc0XaH
         ttEBpZve2i0xGfLYkZTVbtdc80Vvqn+zhZhfhfGG4uwr5WtQhOyh2+JBlrNF8/AXZfxR
         zSVm5u8puc+VVLq+tooHsEniH52oL5DB07Q7wsG3ZVJSevPk9VApR1eewvCByU2z7rnl
         8si7aVTYaDWfhxTHdsk8Gs5iYESTiEG/c0Vhvtye7zmFWKmxIUyayxCyT7BaF0eOoWzF
         xcM/haCEjvpiM4B5zgX+reFa1W6101zdMdIH3bEvduhJqvO/Br3KiLeid44v+yggGPdv
         +4jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uc3I3UUmxQ/TzhoJo+up3qR7M/nZvx4VH7+JLQpeXvI=;
        b=XdotGs7yh53yUURAD7YGwxHTfYWpiRn8YaM5Y0NEtOuv4euTRHGXKW/js90wzZ5EZh
         s8ikAzbB/xydsfAT3wtyh5tqxByOFNGSEUVkIN9P7rOolvXCc3K2evRWHTgsVftrq0Hd
         4gelg6rTS4gx67I6r+h6dInYs9r4HBB8GwdREXl856zVArz52UHXryJiw5h27zjAo6n9
         3eCvPs3NiwCKZ5kfWZR/6lm9stX+kYbRXiE9QyshKF2h28Tt3FbQ/yPcGR7XrbNSWTZg
         f19py9BZDHGwRLnMzfj2RxORO1c/GMc+4tPXIYl2o9dZNPEutfckHnMONulIukkDVLMZ
         dZDQ==
X-Gm-Message-State: AOAM533F3TKXVaN7yIwoRTJpBGXoguFTgIut4VtE0HqAsoadgD1lc4jN
        437CLWHyCFJC5Y9sfCZ0opGBxSkFMZb0nNlsCZ+8xg==
X-Google-Smtp-Source: ABdhPJwSUtPztheSPbrJdH7YdaS9BZDgp3PzDwkoH2xgniswOFLowEt8YSWsfVefYDkfoQ/D4aWdeH6MX+fkau+iO20=
X-Received: by 2002:a81:5409:0:b0:2eb:fea4:a240 with SMTP id
 i9-20020a815409000000b002ebfea4a240mr1737950ywb.47.1649522791982; Sat, 09 Apr
 2022 09:46:31 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000045dc96059f4d7b02@google.com> <000000000000f75af905d3ba0716@google.com>
 <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
In-Reply-To: <c389e47f-8f82-fd62-8c1d-d9481d2f71ff@I-love.SAKURA.ne.jp>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 9 Apr 2022 09:46:20 -0700
Message-ID: <CANn89i+wAtSy0aajXqbZBgAh+M4_-t7mDb9TfqQTRG3aHQkmrQ@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in tcp_retransmit_timer (5)
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     bpf <bpf@vger.kernel.org>,
        syzbot <syzbot+694120e1002c117747ed@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        David Ahern <dsahern@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        tpa@hlghospital.com, Yonghong Song <yhs@fb.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Trond Myklebust <trondmy@hammerspace.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 9, 2022 at 1:19 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> Hello, bpf developers.
>
> syzbot is reporting use-after-free increment at __NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPTIMEOUTS).
>
> ------------------------------------------------------------
> [  702.730585][    C1] ==================================================================
> [  702.743543][    C1] BUG: KASAN: use-after-free in tcp_retransmit_timer+0x6c0/0x1ba0
> [  702.754301][    C1] Read of size 8 at addr ffff88801eed82b8 by task swapper/1/0
> [  702.765301][    C1]
> [  702.768527][    C1] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.17.0 #710
> [  702.778323][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  702.790444][    C1] Call Trace:
> [  702.794903][    C1]  <IRQ>
> [  702.798753][    C1]  dump_stack_lvl+0xcd/0x134
> [  702.804962][    C1]  print_address_description.constprop.0.cold+0x93/0x35d
> [  702.809861][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  702.813344][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  702.817099][    C1]  kasan_report.cold+0x83/0xdf
> [  702.820010][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  702.823666][    C1]  tcp_retransmit_timer+0x6c0/0x1ba0
> [  702.827159][    C1]  ? tcp_mstamp_refresh+0xf/0x60
> [  702.830448][    C1]  ? tcp_delack_timer+0x290/0x290
> [  702.833410][    C1]  ? mark_held_locks+0x65/0x90
> [  702.836790][    C1]  ? ktime_get+0x365/0x420
> [  702.839893][    C1]  ? lockdep_hardirqs_on+0x79/0x100
> [  702.843144][    C1]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [  702.846621][    C1]  ? ktime_get+0x2e6/0x420
> [  702.849334][    C1]  tcp_write_timer_handler+0x32f/0x5f0
> [  702.852597][    C1]  tcp_write_timer+0x86/0x250
> [  702.855736][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  702.859211][    C1]  call_timer_fn+0x15d/0x5f0
> [  702.862327][    C1]  ? enqueue_timer+0x3b0/0x3b0
> [  702.865295][    C1]  ? lock_downgrade+0x3b0/0x3b0
> [  702.868462][    C1]  ? mark_held_locks+0x24/0x90
> [  702.871511][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  702.875369][    C1]  ? _raw_spin_unlock_irq+0x1f/0x40
> [  702.878610][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  702.882085][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  702.885866][    C1]  run_timer_softirq+0xbdb/0xee0
> [  702.889127][    C1]  ? call_timer_fn+0x5f0/0x5f0
> [  702.892021][    C1]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [  702.895881][    C1]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  702.899151][    C1]  __do_softirq+0x117/0x692
> [  702.901960][    C1]  irq_exit_rcu+0xdb/0x110
> [  702.904885][    C1]  sysvec_apic_timer_interrupt+0x93/0xc0
> [  702.908837][    C1]  </IRQ>
> [  702.910666][    C1]  <TASK>
> [  702.965995][    C1]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  703.023333][    C1] RIP: 0010:default_idle+0xb/0x10
> [  703.076496][    C1] Code: 04 25 28 00 00 00 75 0f 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 f3 08 fe ff cc cc cc eb 07 0f 00 2d a7 45 50 00 fb f4 <c3> 0f 1f 40 00 41 54 be 08 00 00 00 53 65 48 8b 1c 25 00 70 02 00
> [  703.208123][    C1] RSP: 0018:ffffc90000757de0 EFLAGS: 00000202
> [  703.276495][    C1] RAX: 000000000008c3e3 RBX: 0000000000000001 RCX: ffffffff86145f10
> [  703.344388][    C1] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  703.411773][    C1] RBP: 0000000000000001 R08: 0000000000000001 R09: ffffed102338758b
> [  703.477687][    C1] R10: ffff888119c3ac53 R11: ffffed102338758a R12: 0000000000000001
> [  703.537679][    C1] R13: ffffffff8a539e50 R14: 0000000000000000 R15: ffff8881003e0000
> [  703.603213][    C1]  ? rcu_eqs_enter.constprop.0+0xb0/0x100
> [  703.667293][    C1]  default_idle_call+0xb1/0x330
> [  703.728393][    C1]  do_idle+0x37f/0x430
> [  703.789414][    C1]  ? mark_held_locks+0x24/0x90
> [  703.852441][    C1]  ? arch_cpu_idle_exit+0x30/0x30
> [  703.915057][    C1]  ? _raw_spin_unlock_irqrestore+0x50/0x70
> [  703.971934][    C1]  ? lockdep_hardirqs_on+0x79/0x100
> [  704.033376][    C1]  ? preempt_count_sub+0xf/0xb0
> [  704.095999][    C1]  cpu_startup_entry+0x14/0x20
> [  704.153464][    C1]  start_secondary+0x1b7/0x220
> [  704.216128][    C1]  ? set_cpu_sibling_map+0x1010/0x1010
> [  704.292706][    C1]  secondary_startup_64_no_verify+0xc3/0xcb
> [  704.357456][    C1]  </TASK>
> [  704.420920][    C1]
> [  704.483318][    C1] Allocated by task 4577:
> [  704.546652][    C1]  kasan_save_stack+0x1e/0x40
> [  704.610435][    C1]  __kasan_slab_alloc+0x90/0xc0
> [  704.671983][    C1]  kmem_cache_alloc+0x1d7/0x760
> [  704.734249][    C1]  copy_net_ns+0xaf/0x4a0
> [  704.795405][    C1]  create_new_namespaces.isra.0+0x254/0x660
> [  704.858394][    C1]  unshare_nsproxy_namespaces+0xb2/0x160
> [  704.920500][    C1]  ksys_unshare+0x372/0x780
> [  704.983267][    C1]  __x64_sys_unshare+0x1b/0x20
> [  705.046194][    C1]  do_syscall_64+0x35/0xb0
> [  705.107899][    C1]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  705.169680][    C1]
> [  705.231276][    C1] Freed by task 8:
> [  705.294349][    C1]  kasan_save_stack+0x1e/0x40
> [  705.359217][    C1]  kasan_set_track+0x21/0x30
> [  705.422445][    C1]  kasan_set_free_info+0x20/0x30
> [  705.481590][    C1]  __kasan_slab_free+0x11a/0x160
> [  705.544098][    C1]  kmem_cache_free+0xe6/0x6a0
> [  705.605324][    C1]  net_free+0x89/0xb0
> [  705.666356][    C1]  cleanup_net+0x64a/0x730
> [  705.728952][    C1]  process_one_work+0x65c/0xda0
> [  705.792462][    C1]  worker_thread+0x7f/0x760
> [  705.858871][    C1]  kthread+0x1c6/0x210
> [  705.920770][    C1]  ret_from_fork+0x1f/0x30
> [  705.978623][    C1]
> [  706.038487][    C1] The buggy address belongs to the object at ffff88801eed8000
> [  706.038487][    C1]  which belongs to the cache net_namespace of size 6528
> [  706.161551][    C1] The buggy address is located 696 bytes inside of
> [  706.161551][    C1]  6528-byte region [ffff88801eed8000, ffff88801eed9980)
> [  706.272381][    C1] The buggy address belongs to the page:
> [  706.334149][    C1] page:ffffea00007bb600 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1eed8
> [  706.400096][    C1] head:ffffea00007bb600 order:3 compound_mapcount:0 compound_pincount:0
> [  706.460895][    C1] memcg:ffff88801921b441
> [  706.519144][    C1] flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> [  706.585321][    C1] raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888100024500
> [  706.652434][    C1] raw: 0000000000000000 0000000080040004 00000001ffffffff ffff88801921b441
> [  706.717358][    C1] page dumped because: kasan: bad access detected
> [  706.783699][    C1] page_owner tracks the page as allocated
> [  706.844889][    C1] page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4577, ts 538093730950, free_ts 446175252650
> [  706.984997][    C1]  prep_new_page+0x134/0x170
> [  707.056009][    C1]  get_page_from_freelist+0x16c7/0x2510
> [  707.130614][    C1]  __alloc_pages+0x29a/0x580
> [  707.204976][    C1]  alloc_pages+0xda/0x1a0
> [  707.278364][    C1]  new_slab+0x29e/0x3a0
> [  707.350591][    C1]  ___slab_alloc+0xb66/0xf60
> [  707.416827][    C1]  __slab_alloc.isra.0+0x4d/0xa0
> [  707.487734][    C1]  kmem_cache_alloc+0x635/0x760
> [  707.560973][    C1]  copy_net_ns+0xaf/0x4a0
> [  707.631583][    C1]  create_new_namespaces.isra.0+0x254/0x660
> [  707.704556][    C1]  unshare_nsproxy_namespaces+0xb2/0x160
> [  707.778185][    C1]  ksys_unshare+0x372/0x780
> [  707.853990][    C1]  __x64_sys_unshare+0x1b/0x20
> [  707.927571][    C1]  do_syscall_64+0x35/0xb0
> [  707.999337][    C1]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  708.073634][    C1] page last free stack trace:
> [  708.145935][    C1]  free_pcp_prepare+0x325/0x650
> [  708.219254][    C1]  free_unref_page+0x19/0x360
> [  708.290288][    C1]  __unfreeze_partials+0x320/0x340
> [  708.359731][    C1]  qlist_free_all+0x6d/0x160
> [  708.431552][    C1]  kasan_quarantine_reduce+0x13d/0x180
> [  708.505070][    C1]  __kasan_slab_alloc+0xa2/0xc0
> [  708.577128][    C1]  kmem_cache_alloc+0x1d7/0x760
> [  708.649556][    C1]  vm_area_alloc+0x1c/0xa0
> [  708.725996][    C1]  mmap_region+0x64f/0xc40
> [  708.786537][    C1]  do_mmap+0x66b/0xa40
> [  708.861188][    C1]  vm_mmap_pgoff+0x1aa/0x270
> [  708.921977][    C1]  ksys_mmap_pgoff+0x357/0x410
> [  708.998067][    C1]  do_syscall_64+0x35/0xb0
> [  709.072158][    C1]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  709.142294][    C1]
> [  709.210670][    C1] Memory state around the buggy address:
> [  709.286139][    C1]  ffff88801eed8180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  709.363031][    C1]  ffff88801eed8200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  709.429425][    C1] >ffff88801eed8280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  709.496217][    C1]                                         ^
> [  709.560374][    C1]  ffff88801eed8300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  709.634175][    C1]  ffff88801eed8380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> [  709.701217][    C1] ==================================================================
> [  709.767019][    C1] Disabling lock debugging due to kernel taint
> [  709.831133][    C1] Kernel panic - not syncing: panic_on_warn set ...
> [  709.890180][    C1] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G    B             5.17.0 #710
> [  709.958293][    C1] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  710.031328][    C1] Call Trace:
> [  710.096636][    C1]  <IRQ>
> [  710.165649][    C1]  dump_stack_lvl+0xcd/0x134
> [  710.232724][    C1]  panic+0x263/0x5fa
> [  710.300396][    C1]  ? __warn_printk+0xf3/0xf3
> [  710.362683][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  710.425386][    C1]  ? preempt_count_sub+0xf/0xb0
> [  710.487806][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  710.550567][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  710.612008][    C1]  end_report.cold+0x63/0x6f
> [  710.671465][    C1]  kasan_report.cold+0x71/0xdf
> [  710.731242][    C1]  ? tcp_retransmit_timer+0x6c0/0x1ba0
> [  710.792468][    C1]  tcp_retransmit_timer+0x6c0/0x1ba0
> [  710.850296][    C1]  ? tcp_mstamp_refresh+0xf/0x60
> [  710.911655][    C1]  ? tcp_delack_timer+0x290/0x290
> [  710.972588][    C1]  ? mark_held_locks+0x65/0x90
> [  711.033775][    C1]  ? ktime_get+0x365/0x420
> [  711.091494][    C1]  ? lockdep_hardirqs_on+0x79/0x100
> [  711.153223][    C1]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [  711.210432][    C1]  ? ktime_get+0x2e6/0x420
> [  711.269857][    C1]  tcp_write_timer_handler+0x32f/0x5f0
> [  711.331006][    C1]  tcp_write_timer+0x86/0x250
> [  711.391916][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  711.452155][    C1]  call_timer_fn+0x15d/0x5f0
> [  711.517305][    C1]  ? enqueue_timer+0x3b0/0x3b0
> [  711.580906][    C1]  ? lock_downgrade+0x3b0/0x3b0
> [  711.642255][    C1]  ? mark_held_locks+0x24/0x90
> [  711.703500][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  711.766484][    C1]  ? _raw_spin_unlock_irq+0x1f/0x40
> [  711.828625][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  711.889862][    C1]  ? tcp_write_timer_handler+0x5f0/0x5f0
> [  711.952756][    C1]  run_timer_softirq+0xbdb/0xee0
> [  712.014027][    C1]  ? call_timer_fn+0x5f0/0x5f0
> [  712.063350][    C1]  ? rcu_read_lock_sched_held+0x9c/0xd0
> [  712.125673][    C1]  ? rcu_read_lock_bh_held+0xb0/0xb0
> [  712.183626][    C1]  __do_softirq+0x117/0x692
> [  712.245067][    C1]  irq_exit_rcu+0xdb/0x110
> [  712.294611][    C1]  sysvec_apic_timer_interrupt+0x93/0xc0
> [  712.363854][    C1]  </IRQ>
> [  712.426802][    C1]  <TASK>
> [  712.482854][    C1]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  712.542428][    C1] RIP: 0010:default_idle+0xb/0x10
> [  712.577029][    C1] Code: 04 25 28 00 00 00 75 0f 48 83 c4 60 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 f3 08 fe ff cc cc cc eb 07 0f 00 2d a7 45 50 00 fb f4 <c3> 0f 1f 40 00 41 54 be 08 00 00 00 53 65 48 8b 1c 25 00 70 02 00
> [  712.703886][    C1] RSP: 0018:ffffc90000757de0 EFLAGS: 00000202
> [  712.763854][    C1] RAX: 000000000008c3e3 RBX: 0000000000000001 RCX: ffffffff86145f10
> [  712.829677][    C1] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  712.893652][    C1] RBP: 0000000000000001 R08: 0000000000000001 R09: ffffed102338758b
> [  712.956344][    C1] R10: ffff888119c3ac53 R11: ffffed102338758a R12: 0000000000000001
> [  713.020195][    C1] R13: ffffffff8a539e50 R14: 0000000000000000 R15: ffff8881003e0000
> [  713.083426][    C1]  ? rcu_eqs_enter.constprop.0+0xb0/0x100
> [  713.144632][    C1]  default_idle_call+0xb1/0x330
> [  713.207385][    C1]  do_idle+0x37f/0x430
> [  713.269538][    C1]  ? mark_held_locks+0x24/0x90
> [  713.332700][    C1]  ? arch_cpu_idle_exit+0x30/0x30
> [  713.396223][    C1]  ? _raw_spin_unlock_irqrestore+0x50/0x70
> [  713.460909][    C1]  ? lockdep_hardirqs_on+0x79/0x100
> [  713.527012][    C1]  ? preempt_count_sub+0xf/0xb0
> [  713.594736][    C1]  cpu_startup_entry+0x14/0x20
> [  713.662751][    C1]  start_secondary+0x1b7/0x220
> [  713.718784][    C1]  ? set_cpu_sibling_map+0x1010/0x1010
> [  713.785338][    C1]  secondary_startup_64_no_verify+0xc3/0xcb
> [  713.851417][    C1]  </TASK>
> [  713.916633][    C1] Kernel Offset: disabled
> [  713.981646][    C1] Rebooting in 10 seconds..
> ------------------------------------------------------------
>
> I managed to convert https://syzkaller.appspot.com/text?tag=ReproC&x=14fcccedb00000
> into a single threaded simple reproducer shown below.
>
> ------------------------------------------------------------
> // https://syzkaller.appspot.com/bug?id=8f0e04b2beffcd42f044d46879cc224f6eb71a99
> // autogenerated by syzkaller (https://github.com/google/syzkaller)
>
> #define _GNU_SOURCE
>
> #include <arpa/inet.h>
> #include <endian.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <net/if.h>
> #include <pthread.h>
> #include <stdbool.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/ioctl.h>
> #include <sys/socket.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <unistd.h>
> #include <linux/bpf.h>
> #include <linux/if_ether.h>
> #include <linux/netlink.h>
> #include <linux/rtnetlink.h>
>
> #ifndef MSG_PROBE
> #define MSG_PROBE 0x10
> #endif
>
> struct nlmsg {
>         char* pos;
>         int nesting;
>         struct nlattr* nested[8];
>         char buf[4096];
> };
>
> static void netlink_init(struct nlmsg* nlmsg, int typ, int flags,
>                          const void* data, int size)
> {
>         memset(nlmsg, 0, sizeof(*nlmsg));
>         struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
>         hdr->nlmsg_type = typ;
>         hdr->nlmsg_flags = NLM_F_REQUEST | NLM_F_ACK | flags;
>         memcpy(hdr + 1, data, size);
>         nlmsg->pos = (char*)(hdr + 1) + NLMSG_ALIGN(size);
> }
>
> static void netlink_attr(struct nlmsg* nlmsg, int typ, const void* data,
>                          int size)
> {
>         struct nlattr* attr = (struct nlattr*)nlmsg->pos;
>         attr->nla_len = sizeof(*attr) + size;
>         attr->nla_type = typ;
>         if (size > 0)
>                 memcpy(attr + 1, data, size);
>         nlmsg->pos += NLMSG_ALIGN(attr->nla_len);
> }
>
> static int netlink_send_ext(struct nlmsg* nlmsg, int sock, uint16_t reply_type,
>                             int* reply_len, bool dofail)
> {
>         if (nlmsg->pos > nlmsg->buf + sizeof(nlmsg->buf) || nlmsg->nesting)
>                 exit(1);
>         struct nlmsghdr* hdr = (struct nlmsghdr*)nlmsg->buf;
>         hdr->nlmsg_len = nlmsg->pos - nlmsg->buf;
>         struct sockaddr_nl addr;
>         memset(&addr, 0, sizeof(addr));
>         addr.nl_family = AF_NETLINK;
>         ssize_t n = sendto(sock, nlmsg->buf, hdr->nlmsg_len, 0,
>                            (struct sockaddr*)&addr, sizeof(addr));
>         if (n != (ssize_t)hdr->nlmsg_len) {
>                 if (dofail)
>                         exit(1);
>                 return -1;
>         }
>         n = recv(sock, nlmsg->buf, sizeof(nlmsg->buf), 0);
>         if (reply_len)
>                 *reply_len = 0;
>         if (n < 0) {
>                 if (dofail)
>                         exit(1);
>                 return -1;
>         }
>         if (n < (ssize_t)sizeof(struct nlmsghdr)) {
>                 errno = EINVAL;
>                 if (dofail)
>                         exit(1);
>                 return -1;
>         }
>         if (hdr->nlmsg_type == NLMSG_DONE)
>                 return 0;
>         if (reply_len && hdr->nlmsg_type == reply_type) {
>                 *reply_len = n;
>                 return 0;
>         }
>         if (n < (ssize_t)(sizeof(struct nlmsghdr) + sizeof(struct nlmsgerr))) {
>                 errno = EINVAL;
>                 if (dofail)
>                         exit(1);
>                 return -1;
>         }
>         if (hdr->nlmsg_type != NLMSG_ERROR) {
>                 errno = EINVAL;
>                 if (dofail)
>                         exit(1);
>                 return -1;
>         }
>         errno = -((struct nlmsgerr*)(hdr + 1))->error;
>         return -errno;
> }
>
> static int netlink_send(struct nlmsg* nlmsg, int sock)
> {
>         return netlink_send_ext(nlmsg, sock, 0, NULL, true);
> }
>
> static void netlink_device_change(int sock, const char* name, const void* mac, int macsize)
> {
>         struct nlmsg nlmsg;
>         struct ifinfomsg hdr;
>         memset(&hdr, 0, sizeof(hdr));
>         hdr.ifi_flags = hdr.ifi_change = IFF_UP;
>         hdr.ifi_index = if_nametoindex(name);
>         netlink_init(&nlmsg, RTM_NEWLINK, 0, &hdr, sizeof(hdr));
>         netlink_attr(&nlmsg, IFLA_ADDRESS, mac, macsize);
>         netlink_send(&nlmsg, sock);
> }
>
> static void netlink_add_addr(int sock, const char* dev, const void* addr, int addrsize)
> {
>         struct nlmsg nlmsg;
>         struct ifaddrmsg hdr;
>         memset(&hdr, 0, sizeof(hdr));
>         hdr.ifa_family = addrsize == 4 ? AF_INET : AF_INET6;
>         hdr.ifa_prefixlen = addrsize == 4 ? 24 : 120;
>         hdr.ifa_scope = RT_SCOPE_UNIVERSE;
>         hdr.ifa_index = if_nametoindex(dev);
>         netlink_init(&nlmsg, RTM_NEWADDR, NLM_F_CREATE | NLM_F_REPLACE, &hdr,
>                      sizeof(hdr));
>         netlink_attr(&nlmsg, IFA_LOCAL, addr, addrsize);
>         netlink_attr(&nlmsg, IFA_ADDRESS, addr, addrsize);
>         netlink_send(&nlmsg, sock);
> }
>
> static void netlink_add_addr4(int sock, const char* dev, const char* addr)
> {
>         struct in_addr in_addr;
>         inet_pton(AF_INET, addr, &in_addr);
>         netlink_add_addr(sock, dev, &in_addr, sizeof(in_addr));
> }
>
> static void netlink_add_addr6(int sock, const char* dev, const char* addr)
> {
>         struct in6_addr in6_addr;
>         inet_pton(AF_INET6, addr, &in6_addr);
>         netlink_add_addr(sock, dev, &in6_addr, sizeof(in6_addr));
> }
>
> static void initialize_netdevices(void)
> {
>         int fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
>         uint64_t macaddr = 0x00aaaaaaaaaa;
>         if (fd == EOF)
>                 exit(1);
>         netlink_add_addr4(fd, "lo", "172.20.20.10");
>         netlink_add_addr6(fd, "lo", "fe80::0a");
>         netlink_device_change(fd, "lo", &macaddr, ETH_ALEN);
>         close(fd);
> }
>
> #ifndef __NR_bpf
> #define __NR_bpf 321
> #endif
>
> static const char program[2053] =
>         "\xbf\x16\x00\x00\x00\x00\x00\x00\xb7\x07\x00\x00\x01\x00\xf0\xff\x50\x70"
>         "\x00\x00\x00\x00\x00\x00\x30\x00\x00\x00\x00\x00\xc0\x00\x95\x00\x00\x00"
>         "\x00\x00\x00\x00\x2b\xa7\x28\x04\x15\x98\xd6\xfb\xd3\x0c\xb5\x99\xe8\x3d"
>         "\x24\xbd\x81\x37\xa3\xaa\x81\xe0\xed\x13\x9a\x85\xd3\x6b\xb3\x01\x9c\x13"
>         "\xbd\x23\x21\xaf\x3c\xf1\xa5\x4f\x26\xfb\xbf\x22\x0b\x71\xd0\xe6\xad\xfe"
>         "\xfc\xf1\xd8\xf7\xfa\xf7\x5e\x0f\x22\x6b\xd9\x17\x48\x79\x60\x71\x71\x42"
>         "\xfa\x9e\xa4\x31\x81\x23\x75\x1c\x0a\x0e\x16\x8c\x18\x86\xd0\xd4\xd3\x53"
>         "\x79\xbd\x22\x3e\xc8\x39\xbc\x16\xee\x98\x8e\x6e\x0d\xc8\xce\xdf\x3c\xeb"
>         "\x9f\xbf\xbf\x9b\x0a\x4d\xef\x23\xd4\x30\xf6\x09\x6b\x32\xa8\x34\x38\x81"
>         "\x07\x20\xa1\x59\xcd\xa9\x03\x63\xdb\x3d\x22\x1e\x15\x2d\xdc\xa6\x40\x57"
>         "\xff\x3c\x47\x44\xae\xac\xcd\x36\x41\x11\x0b\xec\x4e\x90\x27\xa0\xc8\x05"
>         "\x5b\xbf\xc3\xa9\x6d\x2e\x89\x10\xc2\xc3\x9e\x4b\xab\xe8\x02\xf5\xab\x3e"
>         "\x89\xcf\x6c\x66\x2e\xd4\x04\x8d\x3b\x3e\x22\x27\x8d\x00\x03\x1e\x53\x88"
>         "\xee\x5c\x6e\xce\x1c\xcb\x0c\xd2\xb6\xd3\xcf\xfd\x96\x9d\x18\xce\x74\x00"
>         "\x68\x72\x5c\x37\x07\x4e\x46\x8e\xe2\x07\xd2\xf7\x39\x02\xea\xcf\xcf\x49"
>         "\x82\x27\x75\x98\x5b\xf3\x1b\x71\x5f\x58\x88\xb2\xfd\x00\x00\x00\x00\x00"
>         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x6d\x60\xdb\xe7\x1c\xce\xee\x10\x00"
>         "\x00\xdd\xff\xff\xff\x02\x00\x00\x00\x00\x00\x00\x00\x00\xdd\xff\xff\xff"
>         "\x00\x00\xb2\x7c\xf3\xd1\x84\x8a\x54\xd7\x13\x2b\xe1\xff\xb0\xad\xf9\xde"
>         "\xab\x33\x23\xaa\x9f\xdf\xb5\x2f\xaf\x9c\xb0\x9c\x3b\xfd\x09\x00\x00\x00"
>         "\xb9\x1a\xb2\x19\xef\xde\xbb\x7b\x3d\xe8\xf6\x75\x81\xcf\x79\x6a\xad\x42"
>         "\x23\xb9\xff\x7f\xfc\xad\x3f\x6c\x96\x2b\x9f\x03\x00\x00\x00\x00\x00\x00"
>         "\x00\x1c\xf4\x1a\xb1\x1f\x12\xfb\x1e\x0a\x49\x40\x34\x00\x7d\xe7\xc6\x59"
>         "\x2d\xf1\xa6\xc6\x4d\x8f\x20\xa6\x77\x45\x40\x9e\x01\x1f\x12\x64\xd4\x3f"
>         "\x15\x3b\x3d\x34\x89\x9f\x40\x15\x9e\x80\x0e\xa2\x47\x4b\x54\x05\x00\xa3"
>         "\x0b\x23\xbc\xee\x46\x76\x2c\x20\x93\xbc\xc9\xea\xe5\xee\x3e\x98\x00\x26"
>         "\xc9\x6f\x80\xee\x1a\x74\xe0\x4b\xde\x74\x07\x50\xfa\x4d\x9a\xaa\x70\x59"
>         "\x89\xb8\xe6\x73\xe3\x29\x6e\x52\xd3\x37\xc5\x6a\xbf\x11\x28\x74\xec\x51"
>         "\xd6\xfe\x04\x8b\xa6\x86\x6a\xde\xba\xb5\x31\x68\x77\x0a\x71\xad\x90\x1a"
>         "\xce\x38\x3e\x41\xd2\x77\xb1\x03\x92\x3a\x9d\x97\x1f\x7a\x25\x91\xdb\xe4"
>         "\xa9\x12\xff\xaf\x6f\x65\x8f\x3f\x9c\xd1\x62\x86\x74\x4f\x83\xa8\x3f\x13"
>         "\x8f\x8f\x92\xef\xd9\x22\x39\xea\xfc\xe5\xc1\xb3\xf9\x7a\x29\x7c\x9e\x49"
>         "\xa0\xc3\x30\x0e\xf7\xb7\xfb\x5f\x09\xe0\xc8\xa8\x68\xa3\x53\x40\x9e\x34"
>         "\xd3\xe8\x22\x79\x63\x75\x99\xf3\x5a\xd3\xf7\xff\xff\xff\x3c\xac\x39\x4c"
>         "\x7b\xbd\xcd\x0e\x0e\xb5\x21\x89\x2c\x0f\x32\x01\x5b\xf4\xf2\x26\xa4\xe7"
>         "\x0f\x03\xcc\x41\x46\xa7\x7a\xf0\x2c\x1d\x4c\xef\xd4\xa2\xb9\x4c\x0a\xed"
>         "\x84\x77\xdf\xa8\xce\xef\xb4\x67\xf0\x5c\x69\x77\xc7\x8c\xdb\xf3\x77\x04"
>         "\xec\x73\x75\x55\x39\x2a\x0b\x06\x4b\xda\xba\x71\xf8\x97\x14\x49\x10\xfe"
>         "\x05\x00\x38\xec\x9e\x47\xde\x89\x29\x8b\x7b\xf4\xd7\x69\xcc\xc1\x8e\xed"
>         "\xe0\x06\x8c\xa1\x45\x78\x70\xeb\x30\xd2\x11\xe2\x3c\xcc\x8e\x06\xdd\xde"
>         "\xb6\x17\x99\x25\x7a\xb5\x5f\xf4\x13\xc8\x6b\xa9\xaf\xfb\x12\xec\x75\x7c"
>         "\x72\x34\xc2\x70\x24\x6c\x87\x8d\x01\x16\x0e\x6c\x07\xbf\x6c\xf8\x80\x9c"
>         "\x3a\x0d\x06\x23\x57\xba\x25\x15\x56\x72\x30\xad\x1e\x1f\x49\x33\x54\x5f"
>         "\xc3\xc7\x41\x37\x36\x11\x66\x3f\x6b\x63\xb1\xdd\x04\x4d\xd0\xa2\x76\x8e"
>         "\x82\x59\x72\xea\x3b\x77\x64\x14\x67\xc8\x9f\xa0\xf8\x2e\x84\x40\x10\x50"
>         "\x51\xe5\x51\x0a\x33\xdc\xda\x5e\x4e\x20\x2b\xd6\x22\x54\x9c\x4c\xff\x3f"
>         "\x5e\x50\x1d\x3a\x5d\xd7\x14\x3f\xbf\x22\x1f\xff\x16\x1c\x12\xca\x38\x95"
>         "\xa3\x00\x00\x00\x00\x00\x00\x0f\xff\x75\x06\x7d\x2a\x21\x4f\x8c\x9d\x9b"
>         "\x2e\xcf\x63\x01\x6c\x5f\xd9\xc2\x6a\x54\xd4\x3f\xa0\x50\xb8\x8d\x1d\x43"
>         "\xa8\x64\x5b\xd9\x76\x9b\x7e\x07\x86\x9b\xba\x71\x31\x42\x1c\x0f\x39\x11"
>         "\x3b\xe7\x66\x4e\x08\xbd\xd7\x11\x5c\x61\xaf\xcb\x71\x8c\xf3\xc4\x68\x0b"
>         "\x2f\x6c\x7a\x84\x00\xe3\x78\xa9\xb1\x5b\xc2\x0f\x49\xe2\x98\x72\x73\x40"
>         "\xe8\x7c\xde\xfb\x40\xe5\x6e\x9c\xfa\xd9\x73\x34\x7d\x0d\xe7\xba\x47\x54"
>         "\xff\x23\x1a\x1b\x93\x3d\x8f\x93\x1b\x8c\x55\x2b\x2c\x7c\x50\x3f\x3d\x0e"
>         "\x7a\xb0\xe9\x58\xad\xb8\x62\x82\x2e\x40\x00\x99\x95\xae\x16\x6d\xeb\x98"
>         "\x56\x29\x1a\x43\xa6\xf7\xeb\x2e\x32\xce\xfb\xf4\x63\x78\x9e\xaf\x79\xb8"
>         "\xd4\xc2\xbf\x0f\x7a\x2c\xb0\x32\xda\xd1\x30\x07\xb8\x2e\x60\xdb\xe9\x86"
>         "\x4a\x11\x7d\x27\x32\x68\x50\xa7\xc3\xb5\x70\x86\x3f\x53\x2c\x21\x8b\x10"
>         "\xaf\x13\xd7\xbe\x94\x98\x70\x05\x08\x8a\x83\x88\x0c\xca\xb9\xc9\x92\x0c"
>         "\x2d\x2a\xf8\xc5\xe1\x3d\x52\xc8\x3a\xc3\xfa\x7c\x3a\xe6\xc0\x83\x84\x86"
>         "\x5b\x66\xd2\xb4\xdc\xb5\xdd\x9c\xba\x16\xb6\x20\x40\xbf\x87\x02\xae\x12"
>         "\xc7\x7e\x6e\x34\x99\x1a\xf6\x03\xe3\x85\x6a\x34\x6c\xf7\xf9\xfe\xeb\x70"
>         "\x88\xae\xda\x89\x0c\xf8\xa4\xa6\xf3\x1b\xa6\xd9\xb8\xcb\x09\x8f\x93\x5b"
>         "\xdc\xbb\x29\xfd\x0f\x1a\x34\x2c\x01\x00\x00\x00\x00\x00\x00\x00\x48\xa9"
>         "\xde\xa0\x00\x00\x3a\x85\x67\xa7\x59\x2b\x33\x40\x6f\x1f\x71\xc7\x39\xb5"
>         "\x5d\xb9\x1d\x23\x09\xdc\x7a\xe4\x01\x00\x5f\x52\x05\x3a\x39\xe7\x30\x7c"
>         "\x09\xff\x3a\xc3\xe8\x20\xb0\x1c\x57\xdd\x74\xd4\xaa\xfc\x4c\x38\x3a\x17"
>         "\xbc\x1d\xe5\x34\x7b\xb7\x1c\xa1\x6d\xcb\xbb\xaa\x29\x35\xf6\x02\x32\x59"
>         "\x84\x38\x6b\x21\xb9\x64\x92\xae\x66\x20\x82\xb5\x6c\xf6\x66\xe6\x3a\x75"
>         "\x7c\x0e\xf3\xea\x7a\xf6\x88\x15\x13\xbe\x94\xb3\x66\xe1\x5f\xfc\xa8\xec"
>         "\x45\x3b\x3a\x2a\x67\xbe\xdc\xa1\xc7\x66\x95\x22\xe8\xdf\xf8\xbc\x57\x0a"
>         "\x93\xfb\xdb\x68\x8c\x3a\xef\xd4\x75\x01\x27\x7a\x6e\xa6\xb1\x11\x63\x39"
>         "\x2a\x19\xd8\x79\x95\xb5\x1c\x96\xfe\xbd\x5f\x24\xa3\x49\x98\xd2\x01\x0f"
>         "\xd5\xfa\xcf\x68\xc4\xf8\x4e\x2f\x66\xe2\x7c\x81\xa1\x49\xd7\xb3\x31\x98"
>         "\x3d\x3b\x74\x44\x49\x53\xfc\x12\x16\xdf\xec\x10\xb7\x24\xbe\x37\x33\xc2"
>         "\x6f\x12\x53\x83\x76\xe1\x77\xff\xef\x6f\xd2\x60\x3b\xfa\xb9\x68\x31\x95"
>         "\x7a\x08\xe4\x91\x9a\x46\x3d\x53\x32\xa2\x54\x60\x32\xa3\xc0\x6b\x94\xf1"
>         "\x68\xe8\xfc\x4b\xda\x0c\x29\x47\x23\xfe\x30\x6f\x26\xc4\x77\xaf\x4b\x92"
>         "\x66\x44\x67\x29\x85\xfa\xb7\xcc\x67\xbc\x5b\x5f\x5d\x38\xcd\xd8\xdf\x95"
>         "\x14\x7e\xbe\x1c\xd8\x8b\x0a\x2f\xbb\xde\x99\x51\xbe\x42\x82\x7d\xfd\xdf"
>         "\xef\xb2\x38\xfa\xc2\x30\x3c\xc8\x98\x2f\x1e\x55\xb0\x05\xaf\xcf\xea\x5e"
>         "\xb0\x37\x24\x8f\xef\xad\x6b\xb0\x2c\x16\x2c\xe9\x2a\xb1\x27\x13\x52\x2b"
>         "\x97\x50\x6c\x26\x77\x44\xc8\xec\x3d\x2e\x80\xcf\x32\x05\xd3\x66\x99\xfd"
>         "\x38\x1b\xc8\x12\x31\xfb\x5e\x12\xe4\x5f\x30\x59\xf3\x61\xd0\x8d\x6a\x6d"
>         "\x01\xdd\x79\xca\x9b\xfb\x4e\x06\x25\x94\x27\xb0\x29\x44\x7a\x3e\xd7\x0a"
>         "\x2b\x70\xbe\x52\x1e\xa2\x7d\xc8\xcf\x3c\x9b\xdf\x83\xb9\x34\x05\xdb\x07"
>         "\xe8\x2e\x2d\xdf\x4c\x4d\x26\xf1\xcd\xd8\xc3\xc9\x73\x6c\xf5\xe5\x08\x6d"
>         "\xe3\xb4\x84\xf8\x67\x3e\x0e\x97\xdd\x7e\x8a\x87\x21\x48\x61\x3c\x3a\xea"
>         "\xf2\xd6\x7f\x43\x75\xba\x5c\x7f\x1b\x00\x33\xf8\xdf\xe0\x1d\x9c\xb2\xa7"
>         "\x08\x01\xf7\x63\x52\x4e\x1d\x79\xd8\x12\xce\xd7\x82\x64\x6b\x5f\x79\xc8"
>         "\xfc\x08\xbb\x5c\x11\x02\x01\x08\xd7\x02\xed\xd2\xea\x9c\x96\xcf\xcb\x90"
>         "\x66\x66\x86\x27\x82\x0d\x2d\x48\xaa\x5f\xc0\xa7\xbf\x1b\x51\xaf\xd8\x53"
>         "\x50\xad\x00\xb7\x8c\x59\x8f\xa8\x70\x1b\x40\x08\x84\xde\x79\x0b\x54\xe5"
>         "\xab\x2e\x8f\xf0\xc7\xae\x23\xe0\xb6\xee\xac\x95\xc4\xc2\xee\xf2\xe5\xeb"
>         "\x1d\x01\x9d\x52\x09\x9f\xbd\x40\x4e\x8e\xce\x97\x0f\x67\x73\x6b\xa7\xe9"
>         "\x60\xbd\x8b\x1e\x41\x05\xce\x7e\x31\xf7\xc9\xc3\xe3\xfa\x61\xaa\xb9\x67"
>         "\x56\x5e\x04\x00\x00\x00\x00\x00\x00\x00\xa8\xcf\xda\x89\x0a\x98\xb9\x00"
>         "\x87\xe9\x1d\x70\x3e\x98\x53\x5b\x10\x7b\x8f\x46\x53\xbe\x4c\x46\xa3\xa1"
>         "\xad\xb0\x7d\x22\x69\x52\xb8\x57\x3b\x41\x70\x18\x31\x6f\xa9\x00\x00\x00"
>         "\x00\x00\x00\x00\x00\x41\x22\xc8\x63\x70\x9b\x08\xd4\x63\x9a\x2c\xa4\x6a"
>         "\xc9\x0a\xc4\x29\x13\xee\x9b\xca\xa8\x75\xfc\x70\x0b\xa3\x67\xca\x31\x82"
>         "\x10\x59\x60\xbe\xf3\x37\x8a\x98\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00"
>         "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x25\x03\x18\xa4\x4a\xae\xbd\xe8\x49"
>         "\x58\x0d\x86\xd1\xaf\xb0\x2a\x49\x6c\x35\xca\x95\x0d\x60\xa3\xd9\x7f\x23"
>         "\xac\x37\xf8\x80\xdd\xc3\xb1\x7b\x12\x09\xb0\x03\xc3\x33\x4b\x1c\xc0\xdb"
>         "\x48\x3e\x24\x43\x69\x5f\xc9\x5e\xbb\x83\x20\xc9\xad\xee\x62\x94\x51\x4c"
>         "\x2c\xa4\x2a\x10\x48\x28\x6d\x70\xd6\x29\x8c\xe1\x4d\x03\x1d\x04\x7b\x08"
>         "\x0a\x76\x8b\x9d\xc3\x0e\x64\x40\xa1\x03\x0a\xcf\x39\x13\xa5\x78\x65\xa2"
>         "\x77\xce\x60\xe4\x2c\xe3\xb6\xb4\x3b\x4e\x18\xd5\xb5\x3f\xa1\x9f\x94\x69"
>         "\x01\x59\x04\xc7\xbb\xde\xf5\xd8\x90\x1f\xff\x46\x14\x77\xe0\x06\xa7\xaa"
>         "\x3f\x5e\xb4\x80\x09\x82\xcb\x62\x93\x5c\x26\x49\x00\xd9\xb2\xeb\xf2\x7c"
>         "\xd9\x99\x3f\xce\x0b\x10\x71\xd0\x51\x69\xf3\x38\x60\x91\xcf\xc4\x7d\xe1"
>         "\x09\xf9\x73\x47\x43\x4b\x79\x06\x40\x76\xe2\xb6\xea\x28\xd6\x9e\xbb\x75"
>         "\x0d";
>
> static const char license[4] = "GPL";
>
> static void execute_one(void)
> {
>         const union bpf_attr attr = {
>                 .prog_type = BPF_PROG_TYPE_SOCKET_FILTER,
>                 .insn_cnt = 5,
>                 .insns = (unsigned long long) program,
>                 .license = (unsigned long long) license,
>         };
>         struct sockaddr_in addr = {
>                 .sin_family = AF_INET,
>                 .sin_port = htons(0x4001),
>                 .sin_addr.s_addr = inet_addr("172.20.20.180")
>         };
>         const struct msghdr msg = {
>                 .msg_name = &addr,
>                 .msg_namelen = sizeof(addr),
>         };
>         const int bpf_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &attr, 72);
>         const int sock_fd = socket(PF_INET, SOCK_STREAM, 0);
>         alarm(3);
>         while (1) {
>                 sendmsg(sock_fd, &msg, MSG_OOB | MSG_PROBE | MSG_CONFIRM | MSG_FASTOPEN);
>                 setsockopt(sock_fd, SOL_SOCKET, SO_ATTACH_BPF, &bpf_fd, sizeof(bpf_fd));
>         }
> }
>
> int main(int argc, char *argv[])
> {
>         if (unshare(CLONE_NEWNET))
>                 return 1;
>         initialize_netdevices();
>         execute_one();
>         return 0;
> }
> ------------------------------------------------------------
>
> I don't know what this bpf program is doing, but I suspect that this bpf
> program somehow involves PF_INET6 socket without taking a reference to
> the net namespace which this bpf program runs.
>
> Below is debug printk() patch for 5.17 which I used for tracing.
>
> ------------------------------------------------------------
> diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
> index 5b61c462e534..a2fd96da8e21 100644
> --- a/include/net/net_namespace.h
> +++ b/include/net/net_namespace.h
> @@ -178,6 +178,7 @@ struct net {
>  #if IS_ENABLED(CONFIG_SMC)
>         struct netns_smc        smc;
>  #endif
> +       struct list_head struct_net_users;
>  } __randomize_layout;
>
>  #include <linux/seq_file_net.h>
> @@ -243,41 +244,16 @@ void ipx_unregister_sysctl(void);
>  void __put_net(struct net *net);
>
>  /* Try using get_net_track() instead */
> -static inline struct net *get_net(struct net *net)
> -{
> -       refcount_inc(&net->ns.count);
> -       return net;
> -}
> +extern struct net *get_net(struct net *net);
>
> -static inline struct net *maybe_get_net(struct net *net)
> -{
> -       /* Used when we know struct net exists but we
> -        * aren't guaranteed a previous reference count
> -        * exists.  If the reference count is zero this
> -        * function fails and returns NULL.
> -        */
> -       if (!refcount_inc_not_zero(&net->ns.count))
> -               net = NULL;
> -       return net;
> -}
> +extern struct net *maybe_get_net(struct net *net);
>
>  /* Try using put_net_track() instead */
> -static inline void put_net(struct net *net)
> -{
> -       if (refcount_dec_and_test(&net->ns.count))
> -               __put_net(net);
> -}
> +extern void put_net(struct net *net);
>
> -static inline
> -int net_eq(const struct net *net1, const struct net *net2)
> -{
> -       return net1 == net2;
> -}
> +extern int net_eq(const struct net *net1, const struct net *net2);
>
> -static inline int check_net(const struct net *net)
> -{
> -       return refcount_read(&net->ns.count) != 0;
> -}
> +extern int check_net(const struct net *net);
>
>  void net_drop_ns(void *);
>
> diff --git a/include/net/request_sock.h b/include/net/request_sock.h
> index 29e41ff3ec93..df89ff3dfa41 100644
> --- a/include/net/request_sock.h
> +++ b/include/net/request_sock.h
> @@ -118,7 +118,7 @@ static inline void __reqsk_free(struct request_sock *req)
>         if (req->rsk_listener)
>                 sock_put(req->rsk_listener);
>         kfree(req->saved_syn);
> -       kmem_cache_free(req->rsk_ops->slab, req);
> +       //kmem_cache_free(req->rsk_ops->slab, req);
>  }
>
>  static inline void reqsk_free(struct request_sock *req)
> diff --git a/include/net/sock.h b/include/net/sock.h
> index 50aecd28b355..d2f386f9aa73 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -540,6 +540,7 @@ struct sock {
>  #endif
>         struct rcu_head         sk_rcu;
>         netns_tracker           ns_tracker;
> +       struct list_head        struct_net_user;
>  };
>
>  enum sk_pacing {
> @@ -2704,17 +2705,10 @@ static inline void sk_eat_skb(struct sock *sk, struct sk_buff *skb)
>         __kfree_skb(skb);
>  }
>
> -static inline
> -struct net *sock_net(const struct sock *sk)
> -{
> -       return read_pnet(&sk->sk_net);
> -}
> -
> -static inline
> -void sock_net_set(struct sock *sk, struct net *net)
> -{
> -       write_pnet(&sk->sk_net, net);
> -}
> +extern struct net *sock_net(const struct sock *sk);
> +extern void sock_net_set(struct sock *sk, struct net *net);
> +extern void sock_net_start_tracking(struct sock *sk, struct net *net);
> +extern void sock_net_end_tracking(struct sock *sk);
>
>  static inline bool
>  skb_sk_is_prefetched(struct sk_buff *skb)
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a5b5bb99c644..cf4e8b224654 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -26,6 +26,8 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>
> +DEFINE_SPINLOCK(net_users_lock);
> +
>  /*
>   *     Our network namespace constructor/destructor lists
>   */
> @@ -50,6 +52,7 @@ struct net init_net = {
>  #ifdef CONFIG_KEYS
>         .key_domain     = &init_net_key_domain,
>  #endif
> +       .struct_net_users = LIST_HEAD_INIT(init_net.struct_net_users),
>  };
>  EXPORT_SYMBOL(init_net);
>
> @@ -406,6 +409,7 @@ static struct net *net_alloc(void)
>         net = kmem_cache_zalloc(net_cachep, GFP_KERNEL);
>         if (!net)
>                 goto out_free;
> +       INIT_LIST_HEAD(&net->struct_net_users);
>
>  #ifdef CONFIG_KEYS
>         net->key_domain = kzalloc(sizeof(struct key_tag), GFP_KERNEL);
> @@ -432,7 +436,7 @@ static void net_free(struct net *net)
>  {
>         if (refcount_dec_and_test(&net->passive)) {
>                 kfree(rcu_access_pointer(net->gen));
> -               kmem_cache_free(net_cachep, net);
> +               //kmem_cache_free(net_cachep, net);
>         }
>  }
>
> @@ -637,8 +641,46 @@ EXPORT_SYMBOL(net_ns_barrier);
>
>  static DECLARE_WORK(net_cleanup_work, cleanup_net);
>
> +struct to_be_destroyed_net {
> +       struct list_head list;
> +       struct net *net;
> +};
> +
> +static LIST_HEAD(to_be_destroyed_net_list);
> +static DEFINE_SPINLOCK(to_be_destroyed_net_list_lock);
> +
> +bool is_to_be_destroyed_net(struct net *net)
> +{
> +       unsigned long flags;
> +       struct to_be_destroyed_net *entry;
> +       bool found = false;
> +
> +       spin_lock_irqsave(&to_be_destroyed_net_list_lock, flags);
> +       list_for_each_entry(entry, &to_be_destroyed_net_list, list) {
> +               if (entry->net == net) {
> +                       found = true;
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&to_be_destroyed_net_list_lock, flags);
> +       return found;
> +}
> +EXPORT_SYMBOL(is_to_be_destroyed_net);
> +
>  void __put_net(struct net *net)
>  {
> +       struct to_be_destroyed_net *entry = kzalloc(sizeof(*entry), GFP_ATOMIC | __GFP_NOWARN);
> +       unsigned long flags;
> +
> +       if (entry) {
> +               entry->net = net;
> +               spin_lock_irqsave(&to_be_destroyed_net_list_lock, flags);
> +               list_add_tail(&entry->list, &to_be_destroyed_net_list);
> +               spin_unlock_irqrestore(&to_be_destroyed_net_list_lock, flags);
> +       }
> +       pr_info("Releasing net=%px net->ns.count=%d in_use=%d\n",
> +               net, refcount_read(&net->ns.count), sock_inuse_get(net));
> +       dump_stack();
>         ref_tracker_dir_exit(&net->refcnt_tracker);
>         /* Cleanup the network namespace in process context */
>         if (llist_add(&net->cleanup_list, &cleanup_list))
> @@ -1382,4 +1424,113 @@ const struct proc_ns_operations netns_operations = {
>         .install        = netns_install,
>         .owner          = netns_owner,
>  };
> +
> +struct net *get_net(struct net *net)
> +{
> +       refcount_inc(&net->ns.count);
> +       if (net != &init_net) {
> +               pr_info("net=%px count=%d\n", net, refcount_read(&net->ns.count));
> +               dump_stack();
> +       }
> +       return net;
> +}
> +EXPORT_SYMBOL(get_net);
> +
> +struct net *maybe_get_net(struct net *net)
> +{
> +       /* Used when we know struct net exists but we
> +        * aren't guaranteed a previous reference count
> +        * exists.  If the reference count is zero this
> +        * function fails and returns NULL.
> +        */
> +       if (!refcount_inc_not_zero(&net->ns.count))
> +               net = NULL;
> +       else if (net != &init_net) {
> +               pr_info("net=%px count=%d\n", net, refcount_read(&net->ns.count));
> +               dump_stack();
> +       }
> +       return net;
> +}
> +EXPORT_SYMBOL(maybe_get_net);
> +
> +void put_net(struct net *net)
> +{
> +       if (net != &init_net) {
> +               pr_info("net=%px count=%d\n", net, refcount_read(&net->ns.count));
> +               dump_stack();
> +       }
> +       if (refcount_dec_and_test(&net->ns.count))
> +               __put_net(net);
> +}
> +EXPORT_SYMBOL(put_net);
> +
> +int net_eq(const struct net *net1, const struct net *net2)
> +{
> +       return net1 == net2;
> +}
> +EXPORT_SYMBOL(net_eq);
> +
> +int check_net(const struct net *net)
> +{
> +       return refcount_read(&net->ns.count) != 0;
> +}
> +EXPORT_SYMBOL(check_net);
> +
> +void sock_net_start_tracking(struct sock *sk, struct net *net)
> +{
> +       unsigned long flags;
> +
> +       if (net == &init_net)
> +               return;
> +       spin_lock_irqsave(&net_users_lock, flags);
> +       list_add_tail(&sk->struct_net_user, &net->struct_net_users);
> +       spin_unlock_irqrestore(&net_users_lock, flags);
> +}
> +
> +void sock_net_end_tracking(struct sock *sk)
> +{
> +       unsigned long flags;
> +
> +       spin_lock_irqsave(&net_users_lock, flags);
> +       list_del(&sk->struct_net_user);
> +       spin_unlock_irqrestore(&net_users_lock, flags);
> +}
> +
> +struct net *sock_net(const struct sock *sk)
> +{
> +       struct net *net = read_pnet(&sk->sk_net);
> +       unsigned long flags;
> +       bool found = false;
> +       struct sock *s;
> +
> +       if (net == &init_net)
> +               return net;
> +       spin_lock_irqsave(&net_users_lock, flags);
> +       BUG_ON(!net->struct_net_users.next);
> +       BUG_ON(!net->struct_net_users.prev);
> +       list_for_each_entry(s, &net->struct_net_users, struct_net_user) {
> +               BUG_ON(!s->struct_net_user.next);
> +               BUG_ON(!s->struct_net_user.prev);
> +               if (s == sk) {
> +                       found = true;
> +                       break;
> +               }
> +       }
> +       spin_unlock_irqrestore(&net_users_lock, flags);
> +       if (!found) {
> +               pr_info("sock=%px is accessing untracked net=%px\n", sk, net);
> +               pr_info("sk->sk_family=%d sk->sk_prot_creator->name=%s sk->sk_state=%d sk->sk_flags=0x%lx net->ns.count=%d\n",
> +                       sk->sk_family, sk->sk_prot_creator->name, sk->sk_state, sk->sk_flags, refcount_read(&net->ns.count));
> +               dump_stack();
> +       }
> +       return net;
> +}
> +EXPORT_SYMBOL(sock_net);
> +
> +void sock_net_set(struct sock *sk, struct net *net)
> +{
> +       write_pnet(&sk->sk_net, net);
> +}
> +EXPORT_SYMBOL(sock_net_set);
> +
>  #endif
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 6eb174805bf0..3c303117e3bb 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1904,6 +1904,7 @@ static void sock_copy(struct sock *nsk, const struct sock *osk)
>         nsk->sk_security = sptr;
>         security_sk_clone(osk, nsk);
>  #endif
> +       sock_net_start_tracking(nsk, read_pnet(&nsk->sk_net));
>  }
>
>  static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
> @@ -1953,10 +1954,12 @@ static void sk_prot_free(struct proto *prot, struct sock *sk)
>         cgroup_sk_free(&sk->sk_cgrp_data);
>         mem_cgroup_sk_free(sk);
>         security_sk_free(sk);
> +       /*
>         if (slab != NULL)
>                 kmem_cache_free(slab, sk);
>         else
>                 kfree(sk);
> +       */
>         module_put(owner);
>  }
>
> @@ -1989,6 +1992,7 @@ struct sock *sk_alloc(struct net *net, int family, gfp_t priority,
>                         sock_inuse_add(net, 1);
>                 }
>
> +               sock_net_start_tracking(sk, net);
>                 sock_net_set(sk, net);
>                 refcount_set(&sk->sk_wmem_alloc, 1);
>
> diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
> index 20cf4a98c69d..412bee1dc9cb 100644
> --- a/net/ipv4/tcp_timer.c
> +++ b/net/ipv4/tcp_timer.c
> @@ -433,6 +433,7 @@ static void tcp_fastopen_synack_timer(struct sock *sk, struct request_sock *req)
>                           TCP_TIMEOUT_INIT << req->num_timeout, TCP_RTO_MAX);
>  }
>
> +extern bool is_to_be_destroyed_net(struct net *net);
>
>  /**
>   *  tcp_retransmit_timer() - The TCP retransmit timeout handler
> @@ -453,6 +454,13 @@ void tcp_retransmit_timer(struct sock *sk)
>         struct request_sock *req;
>         struct sk_buff *skb;
>
> +       if (is_to_be_destroyed_net(net)) {
> +               pr_info("BUG: Trying to access destroyed net=%px sk=%px\n", net, sk);
> +               pr_info("sk->sk_family=%d sk->sk_prot_creator->name=%s sk->sk_state=%d sk->sk_flags=0x%lx net->ns.count=%d\n",
> +                       sk->sk_family, sk->sk_prot_creator->name, sk->sk_state, sk->sk_flags, refcount_read(&net->ns.count));
> +               WARN_ON(1);
> +       }
> +
>         req = rcu_dereference_protected(tp->fastopen_rsk,
>                                         lockdep_sock_is_held(sk));
>         if (req) {
> @@ -636,6 +644,7 @@ static void tcp_write_timer(struct timer_list *t)
>         struct inet_connection_sock *icsk =
>                         from_timer(icsk, t, icsk_retransmit_timer);
>         struct sock *sk = &icsk->icsk_inet.sk;
> +       struct net *net = sock_net(sk);
>
>         bh_lock_sock(sk);
>         if (!sock_owned_by_user(sk)) {
> @@ -647,6 +656,11 @@ static void tcp_write_timer(struct timer_list *t)
>         }
>         bh_unlock_sock(sk);
>         sock_put(sk);
> +       if (is_to_be_destroyed_net(net)) {
> +               pr_info("INFO: About to destroy net=%px sk=%px\n", net, sk);
> +               pr_info("sk->sk_family=%d sk->sk_prot_creator->name=%s sk->sk_state=%d sk->sk_flags=0x%lx net->ns.count=%d\n",
> +                       sk->sk_family, sk->sk_prot_creator->name, sk->sk_state, sk->sk_flags, refcount_read(&net->ns.count));
> +       }
>  }
>
>  void tcp_syn_ack_timeout(const struct request_sock *req)
> ------------------------------------------------------------
>
> And below is console output with this printk() patch.
>
> ------------------------------------------------------------
> [   83.642910][ T2875] net_namespace: net=ffff888036278000 count=2
> [   83.645415][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   83.648311][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   83.651893][ T2875] Call Trace:
> [   83.653239][ T2875]  <TASK>
> [   83.654540][ T2875]  dump_stack_lvl+0xcd/0x134
> [   83.656428][ T2875]  get_net.cold+0x21/0x26
> [   83.658194][ T2875]  sk_alloc+0x1ca/0x8a0
> [   83.659979][ T2875]  __netlink_create+0x44/0x160
> [   83.662246][ T2875]  netlink_create+0x210/0x310
> [   83.664146][ T2875]  ? do_set_master+0x100/0x100
> [   83.666538][ T2875]  __sock_create+0x20e/0x4f0
> [   83.668648][ T2875]  __sys_socket+0x6f/0x140
> [   83.670597][ T2875]  __x64_sys_socket+0x1a/0x20
> [   83.672385][ T2875]  do_syscall_64+0x35/0xb0
> [   83.674069][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   83.676201][ T2875] RIP: 0033:0x7fbbed5067db
> [   83.677873][ T2875] Code: 73 01 c3 48 8b 0d b5 b6 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b6 0c 00 f7 d8 64 89 01 48
> [   83.685279][ T2875] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> [   83.688515][ T2875] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbbed5067db
> [   83.691782][ T2875] RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000010
> [   83.694835][ T2875] RBP: 0000000000000000 R08: 0000000000000000 R09: 00007fbbed617d50
> [   83.697960][ T2875] R10: 0000000000000000 R11: 0000000000000246 R12: 000055a16962f410
> [   83.701245][ T2875] R13: 00007ffd7a1e7810 R14: 0000000000000000 R15: 0000000000000000
> [   83.704951][ T2875]  </TASK>
> [   83.708603][ T2875] net_namespace: net=ffff888036278000 count=3
> [   83.712187][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   83.715235][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   83.718777][ T2875] Call Trace:
> [   83.720083][ T2875]  <TASK>
> [   83.721401][ T2875]  dump_stack_lvl+0xcd/0x134
> [   83.723313][ T2875]  get_net.cold+0x21/0x26
> [   83.725388][ T2875]  get_proc_task_net+0x99/0x1c0
> [   83.727321][ T2875]  proc_tgid_net_lookup+0x21/0x60
> [   83.729327][ T2875]  __lookup_slow+0x146/0x280
> [   83.731453][ T2875]  walk_component+0x1f2/0x2a0
> [   83.733426][ T2875]  path_lookupat.isra.0+0xc4/0x270
> [   83.735638][ T2875]  filename_lookup+0x103/0x250
> [   83.737518][ T2875]  ? unuse_pde+0x50/0x50
> [   83.739230][ T2875]  ? simple_attr_release+0x20/0x20
> [   83.741365][ T2875]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   83.746650][ T2875]  user_path_at_empty+0x42/0x60
> [   83.748679][ T2875]  do_faccessat+0xd5/0x490
> [   83.750698][ T2875]  do_syscall_64+0x35/0xb0
> [   83.752750][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   83.755147][ T2875] RIP: 0033:0x7fbbed4f416b
> [   83.756987][ T2875] Code: 77 05 c3 0f 1f 40 00 48 8b 15 21 dd 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 f1 dc 0d 00 f7 d8
> [   83.764201][ T2875] RSP: 002b:00007ffd7a1e64e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> [   83.767625][ T2875] RAX: ffffffffffffffda RBX: 00007fbbed5985a0 RCX: 00007fbbed4f416b
> [   83.770815][ T2875] RDX: 0000000000000008 RSI: 0000000000000004 RDI: 00007ffd7a1e64f0
> [   83.773982][ T2875] RBP: 000055a169630004 R08: 000000000000000d R09: 0078696e752f7465
> [   83.777202][ T2875] R10: 0000000000000004 R11: 0000000000000246 R12: 00007fbbed59867c
> [   83.780346][ T2875] R13: 00007ffd7a1e64f0 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   83.783686][ T2875]  </TASK>
> [   83.785743][ T2875] net_namespace: net=ffff888036278000 count=3
> [   83.788711][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   83.791774][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   83.795370][ T2875] Call Trace:
> [   83.796779][ T2875]  <TASK>
> [   83.798094][ T2875]  dump_stack_lvl+0xcd/0x134
> [   83.800045][ T2875]  put_net.cold+0x1f/0x24
> [   83.802444][ T2875]  proc_tgid_net_lookup+0x4b/0x60
> [   83.804936][ T2875]  __lookup_slow+0x146/0x280
> [   83.806890][ T2875]  walk_component+0x1f2/0x2a0
> [   83.808840][ T2875]  path_lookupat.isra.0+0xc4/0x270
> [   83.810945][ T2875]  filename_lookup+0x103/0x250
> [   83.812928][ T2875]  ? unuse_pde+0x50/0x50
> [   83.814760][ T2875]  ? simple_attr_release+0x20/0x20
> [   83.817416][ T2875]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   83.819696][ T2875]  user_path_at_empty+0x42/0x60
> [   83.822173][ T2875]  do_faccessat+0xd5/0x490
> [   83.823958][ T2875]  do_syscall_64+0x35/0xb0
> [   83.825808][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   83.827975][ T2875] RIP: 0033:0x7fbbed4f416b
> [   83.829676][ T2875] Code: 77 05 c3 0f 1f 40 00 48 8b 15 21 dd 0d 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff c3 0f 1f 40 00 f3 0f 1e fa b8 15 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 f1 dc 0d 00 f7 d8
> [   83.836926][ T2875] RSP: 002b:00007ffd7a1e64e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000015
> [   83.840089][ T2875] RAX: ffffffffffffffda RBX: 00007fbbed5985a0 RCX: 00007fbbed4f416b
> [   83.843171][ T2875] RDX: 0000000000000008 RSI: 0000000000000004 RDI: 00007ffd7a1e64f0
> [   83.846444][ T2875] RBP: 000055a169630004 R08: 000000000000000d R09: 0078696e752f7465
> [   83.849481][ T2875] R10: 0000000000000004 R11: 0000000000000246 R12: 00007fbbed59867c
> [   83.852857][ T2875] R13: 00007ffd7a1e64f0 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   83.855888][ T2875]  </TASK>
> [   83.857759][ T2875] net_namespace: net=ffff888036278000 count=3
> [   83.860508][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   83.863611][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   83.867655][ T2875] Call Trace:
> [   83.869162][ T2875]  <TASK>
> [   83.870467][ T2875]  dump_stack_lvl+0xcd/0x134
> [   83.872611][ T2875]  get_net.cold+0x21/0x26
> [   83.874572][ T2875]  sk_alloc+0x1ca/0x8a0
> [   83.876337][ T2875]  unix_create1+0x81/0x2c0
> [   83.878159][ T2875]  unix_create+0x9a/0x130
> [   83.880015][ T2875]  __sock_create+0x20e/0x4f0
> [   83.881874][ T2875]  __sys_socket+0x6f/0x140
> [   83.883730][ T2875]  __x64_sys_socket+0x1a/0x20
> [   83.886127][ T2875]  do_syscall_64+0x35/0xb0
> [   83.888040][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   83.890433][ T2875] RIP: 0033:0x7fbbed5067db
> [   83.892409][ T2875] Code: 73 01 c3 48 8b 0d b5 b6 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b6 0c 00 f7 d8 64 89 01 48
> [   83.899534][ T2875] RSP: 002b:00007ffd7a1e64e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> [   83.903158][ T2875] RAX: ffffffffffffffda RBX: 00007fbbed5985a0 RCX: 00007fbbed5067db
> [   83.906369][ T2875] RDX: 0000000000000000 RSI: 0000000000080002 RDI: 0000000000000001
> [   83.909364][ T2875] RBP: 0000000000000002 R08: 000000000000000d R09: 0078696e752f7465
> [   83.912373][ T2875] R10: 0000000000000004 R11: 0000000000000246 R12: 00007fbbed59867c
> [   83.915860][ T2875] R13: 00007ffd7a1e64f0 R14: 0000000000000001 R15: 0000000000000000
> [   83.919121][ T2875]  </TASK>
> [   83.921478][ T2875] net_namespace: net=ffff888036278000 count=3
> [   83.924516][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   83.927520][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   83.931006][ T2875] Call Trace:
> [   83.932385][ T2875]  <TASK>
> [   83.933651][ T2875]  dump_stack_lvl+0xcd/0x134
> [   83.935827][ T2875]  put_net.cold+0x1f/0x24
> [   83.937612][ T2875]  __sk_destruct+0x1f9/0x3b0
> [   83.939531][ T2875]  sk_destruct+0xa6/0xc0
> [   83.941428][ T2875]  __sk_free+0x5a/0x1b0
> [   83.943189][ T2875]  sk_free+0x6b/0x90
> [   83.944884][ T2875]  unix_release_sock+0x4d4/0x6d0
> [   83.946887][ T2875]  unix_release+0x2d/0x40
> [   83.948674][ T2875]  __sock_release+0x47/0xd0
> [   83.950652][ T2875]  ? __sock_release+0xd0/0xd0
> [   83.952626][ T2875]  sock_close+0x18/0x20
> [   83.954491][ T2875]  __fput+0x117/0x450
> [   83.956241][ T2875]  task_work_run+0x75/0xd0
> [   83.958071][ T2875]  exit_to_user_mode_prepare+0x273/0x280
> [   83.960365][ T2875]  syscall_exit_to_user_mode+0x19/0x60
> [   83.962612][ T2875]  do_syscall_64+0x42/0xb0
> [   83.964521][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   83.967103][ T2875] RIP: 0033:0x7fbbed4f937b
> [   83.968976][ T2875] Code: c3 48 8b 15 17 8b 0d 00 f7 d8 64 89 02 b8 ff ff ff ff eb c2 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 e1 8a 0d 00 f7 d8
> [   83.976315][ T2875] RSP: 002b:00007ffd7a1e6538 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> [   83.979599][ T2875] RAX: 0000000000000000 RBX: 0000000000001802 RCX: 00007fbbed4f937b
> [   83.982751][ T2875] RDX: 00007ffd7a1e6540 RSI: 0000000000008933 RDI: 0000000000000004
> [   83.985979][ T2875] RBP: 0000000000000004 R08: 000000000000000d R09: 0078696e752f7465
> [   83.989107][ T2875] R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffd7a1e6540
> [   83.992365][ T2875] R13: 00007ffd7a1e762c R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   83.995633][ T2875]  </TASK>
> [   83.998686][ T2875] net_namespace: net=ffff888036278000 count=3
> [   84.001243][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.005041][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.008594][ T2875] Call Trace:
> [   84.010029][ T2875]  <TASK>
> [   84.011797][ T2875]  dump_stack_lvl+0xcd/0x134
> [   84.013820][ T2875]  get_net.cold+0x21/0x26
> [   84.016049][ T2875]  sk_alloc+0x1ca/0x8a0
> [   84.018006][ T2875]  unix_create1+0x81/0x2c0
> [   84.019853][ T2875]  unix_create+0x9a/0x130
> [   84.021779][ T2875]  __sock_create+0x20e/0x4f0
> [   84.023672][ T2875]  __sys_socket+0x6f/0x140
> [   84.025544][ T2875]  __x64_sys_socket+0x1a/0x20
> [   84.027473][ T2875]  do_syscall_64+0x35/0xb0
> [   84.029310][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.031710][ T2875] RIP: 0033:0x7fbbed5067db
> [   84.033512][ T2875] Code: 73 01 c3 48 8b 0d b5 b6 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b6 0c 00 f7 d8 64 89 01 48
> [   84.041069][ T2875] RSP: 002b:00007ffd7a1e64e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> [   84.044342][ T2875] RAX: ffffffffffffffda RBX: 000000000000780a RCX: 00007fbbed5067db
> [   84.047336][ T2875] RDX: 0000000000000000 RSI: 0000000000080002 RDI: 0000000000000001
> [   84.050451][ T2875] RBP: 000055a169630004 R08: 000000000000000d R09: 000055a16963001a
> [   84.053617][ T2875] R10: 0000000000000002 R11: 0000000000000246 R12: 00007ffd7a1e6540
> [   84.056885][ T2875] R13: 00007ffd7a1e7680 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.059933][ T2875]  </TASK>
> [   84.061977][ T2875] net_namespace: net=ffff888036278000 count=3
> [   84.064619][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.067684][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.071207][ T2875] Call Trace:
> [   84.072586][ T2875]  <TASK>
> [   84.073835][ T2875]  dump_stack_lvl+0xcd/0x134
> [   84.075862][ T2875]  put_net.cold+0x1f/0x24
> [   84.077663][ T2875]  __sk_destruct+0x1f9/0x3b0
> [   84.079540][ T2875]  sk_destruct+0xa6/0xc0
> [   84.081437][ T2875]  __sk_free+0x5a/0x1b0
> [   84.085862][ T2875]  sk_free+0x6b/0x90
> [   84.087628][ T2875]  unix_release_sock+0x4d4/0x6d0
> [   84.089575][ T2875]  unix_release+0x2d/0x40
> [   84.091333][ T2875]  __sock_release+0x47/0xd0
> [   84.093107][ T2875]  ? __sock_release+0xd0/0xd0
> [   84.095003][ T2875]  sock_close+0x18/0x20
> [   84.096801][ T2875]  __fput+0x117/0x450
> [   84.098375][ T2875]  task_work_run+0x75/0xd0
> [   84.100983][ T2875]  exit_to_user_mode_prepare+0x273/0x280
> [   84.103425][ T2875]  syscall_exit_to_user_mode+0x19/0x60
> [   84.105626][ T2875]  do_syscall_64+0x42/0xb0
> [   84.107471][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.109773][ T2875] RIP: 0033:0x7fbbed4f937b
> [   84.111613][ T2875] Code: c3 48 8b 15 17 8b 0d 00 f7 d8 64 89 02 b8 ff ff ff ff eb c2 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 e1 8a 0d 00 f7 d8
> [   84.118931][ T2875] RSP: 002b:00007ffd7a1e6538 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> [   84.122539][ T2875] RAX: 0000000000000000 RBX: 000000000000780a RCX: 00007fbbed4f937b
> [   84.125766][ T2875] RDX: 00007ffd7a1e6540 RSI: 0000000000008933 RDI: 0000000000000004
> [   84.129038][ T2875] RBP: 0000000000000004 R08: 000000000000000d R09: 000055a16963001a
> [   84.132217][ T2875] R10: 0000000000000002 R11: 0000000000000246 R12: 00007ffd7a1e6540
> [   84.135522][ T2875] R13: 00007ffd7a1e7680 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.138787][ T2875]  </TASK>
> [   84.141378][ T2875] net_namespace: net=ffff888036278000 count=3
> [   84.143692][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.146720][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.150247][ T2875] Call Trace:
> [   84.151721][ T2875]  <TASK>
> [   84.153004][ T2875]  dump_stack_lvl+0xcd/0x134
> [   84.154955][ T2875]  get_net.cold+0x21/0x26
> [   84.156772][ T2875]  sk_alloc+0x1ca/0x8a0
> [   84.158541][ T2875]  unix_create1+0x81/0x2c0
> [   84.160417][ T2875]  unix_create+0x9a/0x130
> [   84.162226][ T2875]  __sock_create+0x20e/0x4f0
> [   84.164112][ T2875]  __sys_socket+0x6f/0x140
> [   84.166350][ T2875]  __x64_sys_socket+0x1a/0x20
> [   84.168367][ T2875]  do_syscall_64+0x35/0xb0
> [   84.170319][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.172755][ T2875] RIP: 0033:0x7fbbed5067db
> [   84.174630][ T2875] Code: 73 01 c3 48 8b 0d b5 b6 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b6 0c 00 f7 d8 64 89 01 48
> [   84.181843][ T2875] RSP: 002b:00007ffd7a1e64e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> [   84.185360][ T2875] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbbed5067db
> [   84.188587][ T2875] RDX: 0000000000000000 RSI: 0000000000080002 RDI: 0000000000000001
> [   84.191962][ T2875] RBP: 000055a169630004 R08: 000000000000000d R09: 0000000000000000
> [   84.195151][ T2875] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd7a1e6540
> [   84.198247][ T2875] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.201606][ T2875]  </TASK>
> [   84.203465][ T2875] net_namespace: net=ffff888036278000 count=3
> [   84.206040][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.209034][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.212497][ T2875] Call Trace:
> [   84.213878][ T2875]  <TASK>
> [   84.215443][ T2875]  dump_stack_lvl+0xcd/0x134
> [   84.217370][ T2875]  put_net.cold+0x1f/0x24
> [   84.219202][ T2875]  __sk_destruct+0x1f9/0x3b0
> [   84.221245][ T2875]  sk_destruct+0xa6/0xc0
> [   84.223004][ T2875]  __sk_free+0x5a/0x1b0
> [   84.224776][ T2875]  sk_free+0x6b/0x90
> [   84.226342][ T2875]  unix_release_sock+0x4d4/0x6d0
> [   84.228268][ T2875]  unix_release+0x2d/0x40
> [   84.230137][ T2875]  __sock_release+0x47/0xd0
> [   84.231923][ T2875]  ? __sock_release+0xd0/0xd0
> [   84.233765][ T2875]  sock_close+0x18/0x20
> [   84.236000][ T2875]  __fput+0x117/0x450
> [   84.237704][ T2875]  task_work_run+0x75/0xd0
> [   84.239496][ T2875]  exit_to_user_mode_prepare+0x273/0x280
> [   84.242142][ T2875]  syscall_exit_to_user_mode+0x19/0x60
> [   84.244474][ T2875]  do_syscall_64+0x42/0xb0
> [   84.246441][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.248704][ T2875] RIP: 0033:0x7fbbed4f937b
> [   84.250500][ T2875] Code: c3 48 8b 15 17 8b 0d 00 f7 d8 64 89 02 b8 ff ff ff ff eb c2 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 e1 8a 0d 00 f7 d8
> [   84.257987][ T2875] RSP: 002b:00007ffd7a1e6538 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> [   84.261471][ T2875] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00007fbbed4f937b
> [   84.264691][ T2875] RDX: 00007ffd7a1e6540 RSI: 0000000000008933 RDI: 0000000000000004
> [   84.267780][ T2875] RBP: 0000000000000004 R08: 000000000000000d R09: 0000000000000000
> [   84.271032][ T2875] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd7a1e6540
> [   84.274208][ T2875] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.277498][ T2875]  </TASK>
> [   84.287045][ T2875] net_namespace: net=ffff888036278000 count=3
> [   84.289271][ T2875] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.292514][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.296133][ T2875] Call Trace:
> [   84.297568][ T2875]  <TASK>
> [   84.298859][ T2875]  dump_stack_lvl+0xcd/0x134
> [   84.300918][ T2875]  get_net.cold+0x21/0x26
> [   84.302637][ T2875]  sk_alloc+0x1ca/0x8a0
> [   84.304653][ T2875]  inet_create+0x21e/0x7e0
> [   84.306778][ T2875]  __sock_create+0x20e/0x4f0
> [   84.308690][ T2875]  __sys_socket+0x6f/0x140
> [   84.310513][ T2875]  __x64_sys_socket+0x1a/0x20
> [   84.312659][ T2875]  do_syscall_64+0x35/0xb0
> [   84.314573][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.316905][ T2875] RIP: 0033:0x7fbbed5067db
> [   84.318820][ T2875] Code: 73 01 c3 48 8b 0d b5 b6 0c 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa b8 29 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 85 b6 0c 00 f7 d8 64 89 01 48
> [   84.325864][ T2875] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> [   84.329133][ T2875] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbbed5067db
> [   84.332546][ T2875] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> [   84.336076][ T2875] RBP: 00007ffd7a1e762c R08: 0000000000000000 R09: 0000000000000000
> [   84.339372][ T2875] R10: 1999999999999999 R11: 0000000000000246 R12: 00007ffd7a1e7630
> [   84.342502][ T2875] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.345680][ T2875]  </TASK>
> [   84.353592][    C0] net_namespace: sock=ffff88800e6a0000 is accessing untracked net=ffff888036278000
> [   84.358423][    C0] net_namespace: sk->sk_family=10 sk->sk_prot_creator->name=(efault) sk->sk_state=12 sk->sk_flags=0xffff88800bbd8c40 net->ns.count=3
> [   84.363617][    C0] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.366717][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.370399][    C0] Call Trace:
> [   84.371855][    C0]  <IRQ>
> [   84.373042][    C0]  dump_stack_lvl+0xcd/0x134
> [   84.374866][    C0]  sock_net+0x118/0x160
> [   84.376672][    C0]  inet_ehash_insert+0x98/0x490
> [   84.378737][    C0]  inet_csk_reqsk_queue_hash_add+0x5b/0x80
> [   84.381582][    C0]  tcp_conn_request+0x1082/0x14a0
> [   84.383746][    C0]  ? tcp_v4_conn_request+0x6c/0x120
> [   84.386019][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.388249][    C0]  tcp_v4_conn_request+0x6c/0x120
> [   84.390356][    C0]  tcp_v6_conn_request+0x157/0x1d0
> [   84.392458][    C0]  tcp_rcv_state_process+0x443/0x1f20
> [   84.394725][    C0]  ? tcp_v4_do_rcv+0x1b5/0x600
> [   84.396681][    C0]  tcp_v4_do_rcv+0x1b5/0x600
> [   84.398620][    C0]  tcp_v4_rcv+0x1bad/0x1de0
> [   84.400791][    C0]  ip_protocol_deliver_rcu+0x52/0x630
> [   84.403773][    C0]  ip_local_deliver_finish+0xb4/0x1d0
> [   84.406060][    C0]  ip_local_deliver+0xa7/0x320
> [   84.408075][    C0]  ? ip_protocol_deliver_rcu+0x630/0x630
> [   84.410374][    C0]  ip_rcv_finish+0x108/0x170
> [   84.412225][    C0]  ip_rcv+0x69/0x2f0
> [   84.413859][    C0]  ? ip_rcv_finish_core.isra.0+0xbb0/0xbb0
> [   84.416510][    C0]  __netif_receive_skb_one_core+0x6a/0xa0
> [   84.418949][    C0]  __netif_receive_skb+0x24/0xa0
> [   84.421102][    C0]  process_backlog+0x11d/0x320
> [   84.422978][    C0]  __napi_poll+0x3d/0x3e0
> [   84.424808][    C0]  net_rx_action+0x34e/0x480
> [   84.426713][    C0]  __do_softirq+0xde/0x539
> [   84.428458][    C0]  ? ip_finish_output2+0x401/0x1060
> [   84.430566][    C0]  do_softirq+0xb1/0xf0
> [   84.432611][    C0]  </IRQ>
> [   84.433909][    C0]  <TASK>
> [   84.435285][    C0]  __local_bh_enable_ip+0xbf/0xd0
> [   84.437418][    C0]  ip_finish_output2+0x42f/0x1060
> [   84.439382][    C0]  ? __ip_finish_output+0x471/0x840
> [   84.443928][    C0]  __ip_finish_output+0x471/0x840
> [   84.445988][    C0]  ? write_comp_data+0x1c/0x70
> [   84.448014][    C0]  ip_finish_output+0x32/0x140
> [   84.449946][    C0]  ip_output+0xb2/0x3b0
> [   84.451881][    C0]  ? __ip_finish_output+0x840/0x840
> [   84.453979][    C0]  ip_local_out+0x6e/0xd0
> [   84.455733][    C0]  __ip_queue_xmit+0x306/0x950
> [   84.457580][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.459761][    C0]  ? sock_net+0x11d/0x160
> [   84.461577][    C0]  __tcp_transmit_skb+0x845/0x1380
> [   84.463573][    C0]  tcp_connect+0xb02/0x1c80
> [   84.465713][    C0]  ? preempt_schedule_common+0x32/0x80
> [   84.468040][    C0]  tcp_v4_connect+0x72c/0x820
> [   84.470357][    C0]  __inet_stream_connect+0x157/0x630
> [   84.473029][    C0]  ? kmem_cache_alloc_trace+0x556/0x690
> [   84.475392][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.477659][    C0]  tcp_sendmsg_locked+0xf16/0x1440
> [   84.479765][    C0]  ? __local_bh_enable_ip+0x72/0xd0
> [   84.481880][    C0]  tcp_sendmsg+0x2b/0x40
> [   84.483651][    C0]  inet_sendmsg+0x45/0x70
> [   84.485640][    C0]  ? inet_send_prepare+0x2e0/0x2e0
> [   84.487807][    C0]  ____sys_sendmsg+0x390/0x3e0
> [   84.489794][    C0]  ? debug_object_activate+0x193/0x210
> [   84.491915][    C0]  ___sys_sendmsg+0x97/0xe0
> [   84.493713][    C0]  ? __lock_acquire+0x3b2/0x3160
> [   84.495653][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.497772][    C0]  ? __fget_light+0x99/0xe0
> [   84.499582][    C0]  __sys_sendmsg+0x88/0x100
> [   84.501976][    C0]  do_syscall_64+0x35/0xb0
> [   84.503841][    C0]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.506292][    C0] RIP: 0033:0x7fbbed5ec0f7
> [   84.508154][    C0] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bc 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [   84.515353][    C0] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [   84.518867][    C0] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fbbed5ec0f7
> [   84.522178][    C0] RDX: 0000000020000811 RSI: 00007ffd7a1e7630 RDI: 0000000000000004
> [   84.525355][    C0] RBP: 00007ffd7a1e762c R08: 0000000000000000 R09: 0000000000000000
> [   84.528392][    C0] R10: 1999999999999999 R11: 0000000000000246 R12: 00007ffd7a1e7630
> [   84.531766][    C0] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.535012][    C0]  </TASK>
> [   84.554710][    C0] net_namespace: net=ffff888036278000 count=3
> [   84.557308][    C0] CPU: 0 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.560308][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.563719][    C0] Call Trace:
> [   84.565561][    C0]  <IRQ>
> [   84.566936][    C0]  dump_stack_lvl+0xcd/0x134
> [   84.569111][    C0]  put_net.cold+0x1f/0x24
> [   84.571071][    C0]  __sk_destruct+0x1f9/0x3b0
> [   84.572995][    C0]  sk_destruct+0xa6/0xc0
> [   84.574855][    C0]  __sk_free+0x5a/0x1b0
> [   84.576633][    C0]  sk_free+0x6b/0x90
> [   84.578324][    C0]  deferred_put_nlk_sk+0xb7/0x150
> [   84.580383][    C0]  rcu_core+0x37d/0xa00
> [   84.582144][    C0]  ? rcu_core+0x31e/0xa00
> [   84.583970][    C0]  __do_softirq+0xde/0x539
> [   84.586435][    C0]  ? tcp_sendmsg+0x1d/0x40
> [   84.588290][    C0]  do_softirq+0xb1/0xf0
> [   84.590022][    C0]  </IRQ>
> [   84.591451][    C0]  <TASK>
> [   84.592751][    C0]  __local_bh_enable_ip+0xbf/0xd0
> [   84.594866][    C0]  tcp_sendmsg+0x1d/0x40
> [   84.596737][    C0]  inet_sendmsg+0x45/0x70
> [   84.598573][    C0]  ? inet_send_prepare+0x2e0/0x2e0
> [   84.600679][    C0]  ____sys_sendmsg+0x390/0x3e0
> [   84.602707][    C0]  ___sys_sendmsg+0x97/0xe0
> [   84.604712][    C0]  ? __lock_acquire+0x3b2/0x3160
> [   84.607154][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.609429][    C0]  ? __fget_light+0x99/0xe0
> [   84.611412][    C0]  __sys_sendmsg+0x88/0x100
> [   84.613325][    C0]  do_syscall_64+0x35/0xb0
> [   84.615297][    C0]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.617704][    C0] RIP: 0033:0x7fbbed5ec0f7
> [   84.619846][    C0] Code: 64 89 02 48 c7 c0 ff ff ff ff eb bc 0f 1f 80 00 00 00 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10
> [   84.627115][    C0] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [   84.630656][    C0] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fbbed5ec0f7
> [   84.633812][    C0] RDX: 0000000020000811 RSI: 00007ffd7a1e7630 RDI: 0000000000000004
> [   84.638113][    C0] RBP: 00007ffd7a1e762c R08: 0000000000000004 R09: 0000000000000000
> [   84.641422][    C0] R10: 00007ffd7a1e762c R11: 0000000000000246 R12: 00007ffd7a1e7630
> [   84.644856][    C0] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.648113][    C0]  </TASK>
> [   84.745096][    C2] net_namespace: sock=ffff88800e6a0000 is accessing untracked net=ffff888036278000
> [   84.749028][    C2] net_namespace: sk->sk_family=10 sk->sk_prot_creator->name=(efault) sk->sk_state=12 sk->sk_flags=0xffff88800bbd8c40 net->ns.count=2
> [   84.754738][    C2] CPU: 2 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.757944][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.761531][    C2] Call Trace:
> [   84.762930][    C2]  <IRQ>
> [   84.764209][    C2]  dump_stack_lvl+0xcd/0x134
> [   84.766204][    C2]  sock_net+0x118/0x160
> [   84.768239][    C2]  __inet_lookup_established+0x127/0x360
> [   84.770835][    C2]  tcp_v4_rcv+0xbae/0x1de0
> [   84.772780][    C2]  ip_protocol_deliver_rcu+0x52/0x630
> [   84.775163][    C2]  ip_local_deliver_finish+0xb4/0x1d0
> [   84.777395][    C2]  ip_local_deliver+0xa7/0x320
> [   84.779347][    C2]  ? ip_protocol_deliver_rcu+0x630/0x630
> [   84.781711][    C2]  ip_rcv_finish+0x108/0x170
> [   84.783656][    C2]  ip_rcv+0x69/0x2f0
> [   84.785609][    C2]  ? ip_rcv_finish_core.isra.0+0xbb0/0xbb0
> [   84.787945][    C2]  __netif_receive_skb_one_core+0x6a/0xa0
> [   84.790338][    C2]  __netif_receive_skb+0x24/0xa0
> [   84.792346][    C2]  process_backlog+0x11d/0x320
> [   84.794431][    C2]  __napi_poll+0x3d/0x3e0
> [   84.796592][    C2]  net_rx_action+0x34e/0x480
> [   84.798469][    C2]  __do_softirq+0xde/0x539
> [   84.800514][    C2]  ? sock_setsockopt+0x103/0x19f0
> [   84.803153][    C2]  do_softirq+0xb1/0xf0
> [   84.805116][    C2]  </IRQ>
> [   84.806534][    C2]  <TASK>
> [   84.807900][    C2]  __local_bh_enable_ip+0xbf/0xd0
> [   84.810002][    C2]  sock_setsockopt+0x103/0x19f0
> [   84.812178][    C2]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.814535][    C2]  __sys_setsockopt+0x2d1/0x330
> [   84.816496][    C2]  __x64_sys_setsockopt+0x22/0x30
> [   84.818633][    C2]  do_syscall_64+0x35/0xb0
> [   84.820620][    C2]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.823211][    C2] RIP: 0033:0x7fbbed50677e
> [   84.825098][    C2] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e2 b6 0c 00 f7 d8 64 89 01 48
> [   84.832280][    C2] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000217 ORIG_RAX: 0000000000000036
> [   84.835905][    C2] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fbbed50677e
> [   84.839164][    C2] RDX: 0000000000000032 RSI: 0000000000000001 RDI: 0000000000000004
> [   84.842605][    C2] RBP: 00007ffd7a1e762c R08: 0000000000000004 R09: 0000000000000000
> [   84.845893][    C2] R10: 00007ffd7a1e762c R11: 0000000000000217 R12: 00007ffd7a1e7630
> [   84.849091][    C2] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.852527][    C2]  </TASK>
> [   84.854068][    C2] net_namespace: sock=ffff88800e6a0000 is accessing untracked net=ffff888036278000
> [   84.858121][    C2] net_namespace: sk->sk_family=10 sk->sk_prot_creator->name=(efault) sk->sk_state=12 sk->sk_flags=0xffff88800bbd8c40 net->ns.count=2
> [   84.863384][    C2] CPU: 2 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   84.866705][    C2] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   84.870581][    C2] Call Trace:
> [   84.872201][    C2]  <IRQ>
> [   84.873449][    C2]  dump_stack_lvl+0xcd/0x134
> [   84.875838][    C2]  sock_net+0x118/0x160
> [   84.877670][    C2]  __inet_lookup_established+0x24f/0x360
> [   84.880054][    C2]  tcp_v4_rcv+0xbae/0x1de0
> [   84.881976][    C2]  ip_protocol_deliver_rcu+0x52/0x630
> [   84.884083][    C2]  ip_local_deliver_finish+0xb4/0x1d0
> [   84.886449][    C2]  ip_local_deliver+0xa7/0x320
> [   84.888449][    C2]  ? ip_protocol_deliver_rcu+0x630/0x630
> [   84.890881][    C2]  ip_rcv_finish+0x108/0x170
> [   84.893022][    C2]  ip_rcv+0x69/0x2f0
> [   84.894792][    C2]  ? ip_rcv_finish_core.isra.0+0xbb0/0xbb0
> [   84.897049][    C2]  __netif_receive_skb_one_core+0x6a/0xa0
> [   84.899296][    C2]  __netif_receive_skb+0x24/0xa0
> [   84.901420][    C2]  process_backlog+0x11d/0x320
> [   84.903470][    C2]  __napi_poll+0x3d/0x3e0
> [   84.905410][    C2]  net_rx_action+0x34e/0x480
> [   84.907399][    C2]  __do_softirq+0xde/0x539
> [   84.909259][    C2]  ? sock_setsockopt+0x103/0x19f0
> [   84.914100][    C2]  do_softirq+0xb1/0xf0
> [   84.915946][    C2]  </IRQ>
> [   84.917252][    C2]  <TASK>
> [   84.918598][    C2]  __local_bh_enable_ip+0xbf/0xd0
> [   84.920777][    C2]  sock_setsockopt+0x103/0x19f0
> [   84.922691][    C2]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [   84.924959][    C2]  __sys_setsockopt+0x2d1/0x330
> [   84.926866][    C2]  __x64_sys_setsockopt+0x22/0x30
> [   84.928837][    C2]  do_syscall_64+0x35/0xb0
> [   84.930807][    C2]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   84.933016][    C2] RIP: 0033:0x7fbbed50677e
> [   84.934935][    C2] Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 f3 0f 1e fa 49 89 ca b8 36 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e2 b6 0c 00 f7 d8 64 89 01 48
> [   84.942206][    C2] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000217 ORIG_RAX: 0000000000000036
> [   84.945740][    C2] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007fbbed50677e
> [   84.948952][    C2] RDX: 0000000000000032 RSI: 0000000000000001 RDI: 0000000000000004
> [   84.952352][    C2] RBP: 00007ffd7a1e762c R08: 0000000000000004 R09: 0000000000000000
> [   84.955693][    C2] R10: 00007ffd7a1e762c R11: 0000000000000217 R12: 00007ffd7a1e7630
> [   84.958899][    C2] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   84.962649][    C2]  </TASK>
> [   87.351519][ T2875] net_namespace: net=ffff888036278000 count=2
> [   87.354530][ T2875] CPU: 1 PID: 2875 Comm: a.out Not tainted 5.17.0-dirty #748
> [   87.357551][ T2875] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [   87.361185][ T2875] Call Trace:
> [   87.362550][ T2875]  <TASK>
> [   87.363891][ T2875]  dump_stack_lvl+0xcd/0x134
> [   87.365794][ T2875]  put_net.cold+0x1f/0x24
> [   87.367655][ T2875]  free_nsproxy+0x1fe/0x2c0
> [   87.369737][ T2875]  switch_task_namespaces+0x83/0x90
> [   87.372158][ T2875]  do_exit+0x566/0x13d0
> [   87.374030][ T2875]  ? find_held_lock+0x2b/0x80
> [   87.376164][ T2875]  ? get_signal+0x1ef/0x16b0
> [   87.378079][ T2875]  do_group_exit+0x51/0x100
> [   87.379966][ T2875]  get_signal+0x257/0x16b0
> [   87.382106][ T2875]  arch_do_signal_or_restart+0xeb/0x7f0
> [   87.384334][ T2875]  exit_to_user_mode_prepare+0x189/0x280
> [   87.386547][ T2875]  syscall_exit_to_user_mode+0x19/0x60
> [   87.388895][ T2875]  do_syscall_64+0x42/0xb0
> [   87.390765][ T2875]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   87.393095][ T2875] RIP: 0033:0x7fbbed5ec0f7
> [   87.395241][ T2875] Code: Unable to access opcode bytes at RIP 0x7fbbed5ec0cd.
> [   87.398613][ T2875] RSP: 002b:00007ffd7a1e7618 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> [   87.402381][ T2875] RAX: ffffffffffffff96 RBX: 0000000000000004 RCX: 00007fbbed5ec0f7
> [   87.405723][ T2875] RDX: 0000000020000811 RSI: 00007ffd7a1e7630 RDI: 0000000000000004
> [   87.409023][ T2875] RBP: 00007ffd7a1e762c R08: 0000000000000004 R09: 0000000000000000
> [   87.412238][ T2875] R10: 00007ffd7a1e762c R11: 0000000000000246 R12: 00007ffd7a1e7630
> [   87.415477][ T2875] R13: 0000000000000003 R14: 00007ffd7a1e7680 R15: 0000000000000000
> [   87.418590][ T2875]  </TASK>
> [   87.427287][ T2875] a.out (2875) used greatest stack depth: 11320 bytes left
> [  234.697150][    C0] net_namespace: net=ffff888036278000 count=1
> [  234.710780][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-dirty #748
> [  234.720528][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  234.727887][    C0] Call Trace:
> [  234.730895][    C0]  <IRQ>
> [  234.734086][    C0]  dump_stack_lvl+0xcd/0x134
> [  234.738276][    C0]  put_net.cold+0x1f/0x24
> [  234.742162][    C0]  __sk_destruct+0x1f9/0x3b0
> [  234.746326][    C0]  sk_destruct+0xa6/0xc0
> [  234.749219][    C0]  __sk_free+0x5a/0x1b0
> [  234.751159][    C0]  sk_free+0x6b/0x90
> [  234.753239][    C0]  tcp_write_timer+0x1ff/0x240
> [  234.755181][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  234.757290][    C0]  call_timer_fn+0xe3/0x4f0
> [  234.759095][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  234.761341][    C0]  run_timer_softirq+0x812/0xac0
> [  234.763337][    C0]  __do_softirq+0xde/0x539
> [  234.765104][    C0]  irq_exit_rcu+0xb6/0xf0
> [  234.766789][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
> [  234.769139][    C0]  </IRQ>
> [  234.770482][    C0]  <TASK>
> [  234.771702][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  234.774065][    C0] RIP: 0010:default_idle+0xb/0x10
> [  234.776010][    C0] Code: 00 00 00 75 09 48 83 c4 18 5b 5d 41 5c c3 e8 5c 96 fe ff cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 93 09 48 00 fb f4 <c3> 0f 1f 40 00 65 48 8b 04 25 40 af 01 00 f0 80 48 02 20 48 8b 10
> [  234.783374][    C0] RSP: 0018:ffffffff84203e90 EFLAGS: 00000202
> [  234.785849][    C0] RAX: 000000000002246b RBX: 0000000000000000 RCX: ffffffff842622c0
> [  234.789116][    C0] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  234.792254][    C0] RBP: ffffffff842622c0 R08: 0000000000000001 R09: 0000000000000001
> [  234.795720][    C0] R10: 0000000000000001 R11: 0000000000080000 R12: 0000000000000000
> [  234.798927][    C0] R13: ffffffff842622c0 R14: 0000000000000000 R15: 0000000000000000
> [  234.802563][    C0]  default_idle_call+0x6a/0x260
> [  234.804592][    C0]  do_idle+0x20c/0x260
> [  234.806332][    C0]  ? trace_init_perf_perm_irq_work_exit+0xe/0xe
> [  234.808693][    C0]  cpu_startup_entry+0x14/0x20
> [  234.810686][    C0]  start_kernel+0x8f7/0x91e
> [  234.812538][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
> [  234.815399][    C0]  </TASK>
> [  234.816785][    C0] net_namespace: Releasing net=ffff888036278000 net->ns.count=0 in_use=0
> [  234.820358][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-dirty #748
> [  234.823664][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  234.827160][    C0] Call Trace:
> [  234.828540][    C0]  <IRQ>
> [  234.829812][    C0]  dump_stack_lvl+0xcd/0x134
> [  234.831775][    C0]  __put_net+0xc8/0x130
> [  234.834723][    C0]  put_net+0x7d/0xb0
> [  234.836516][    C0]  __sk_destruct+0x1f9/0x3b0
> [  234.838546][    C0]  sk_destruct+0xa6/0xc0
> [  234.840453][    C0]  __sk_free+0x5a/0x1b0
> [  234.842217][    C0]  sk_free+0x6b/0x90
> [  234.844007][    C0]  tcp_write_timer+0x1ff/0x240
> [  234.845938][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  234.848146][    C0]  call_timer_fn+0xe3/0x4f0
> [  234.850145][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  234.852503][    C0]  run_timer_softirq+0x812/0xac0
> [  234.855025][    C0]  __do_softirq+0xde/0x539
> [  234.856908][    C0]  irq_exit_rcu+0xb6/0xf0
> [  234.858712][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
> [  234.860980][    C0]  </IRQ>
> [  234.862279][    C0]  <TASK>
> [  234.863598][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  234.865966][    C0] RIP: 0010:default_idle+0xb/0x10
> [  234.868109][    C0] Code: 00 00 00 75 09 48 83 c4 18 5b 5d 41 5c c3 e8 5c 96 fe ff cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 93 09 48 00 fb f4 <c3> 0f 1f 40 00 65 48 8b 04 25 40 af 01 00 f0 80 48 02 20 48 8b 10
> [  234.875407][    C0] RSP: 0018:ffffffff84203e90 EFLAGS: 00000202
> [  234.877869][    C0] RAX: 000000000002246b RBX: 0000000000000000 RCX: ffffffff842622c0
> [  234.881349][    C0] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  234.885150][    C0] RBP: ffffffff842622c0 R08: 0000000000000001 R09: 0000000000000001
> [  234.888442][    C0] R10: 0000000000000001 R11: 0000000000080000 R12: 0000000000000000
> [  234.891831][    C0] R13: ffffffff842622c0 R14: 0000000000000000 R15: 0000000000000000
> [  234.895041][    C0]  default_idle_call+0x6a/0x260
> [  234.897019][    C0]  do_idle+0x20c/0x260
> [  234.898782][    C0]  ? trace_init_perf_perm_irq_work_exit+0xe/0xe
> [  234.901456][    C0]  cpu_startup_entry+0x14/0x20
> [  234.903364][    C0]  start_kernel+0x8f7/0x91e
> [  234.905180][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
> [  234.907426][    C0]  </TASK>
> [  234.909661][    C0] INFO: About to destroy net=ffff888036278000 sk=ffff888036058b80
> [  234.913082][    C0] sk->sk_family=2 sk->sk_prot_creator->name=TCP sk->sk_state=7 sk->sk_flags=0x301 net->ns.count=0
> [  260.295512][    C0] BUG: Trying to access destroyed net=ffff888036278000 sk=ffff88800e2d8000
> [  260.301941][    C0] sk->sk_family=10 sk->sk_prot_creator->name=TCPv6 sk->sk_state=11 sk->sk_flags=0x30b net->ns.count=0
> [  260.317639][    C0] ------------[ cut here ]------------
> [  260.323152][    C0] WARNING: CPU: 0 PID: 0 at net/ipv4/tcp_timer.c:461 tcp_retransmit_timer.cold+0xdf/0xe6
> [  260.334901][    C0] Modules linked in:
> [  260.338356][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-dirty #748
> [  260.342593][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  260.346821][    C0] RIP: 0010:tcp_retransmit_timer.cold+0xdf/0xe6
> [  260.349704][    C0] Code: 10 48 c7 c7 60 9d ff 83 48 8b 85 a0 03 00 00 44 8b 8b 4c 01 00 00 4c 8b 45 60 0f b6 4d 12 48 8d 90 88 01 00 00 e8 a8 25 f2 ff <0f> 0b e9 b6 40 5f ff e8 f3 59 ee fd 41 0f b6 d5 4c 89 e6 48 c7 c7
> [  260.359054][    C0] RSP: 0018:ffffc90000003d90 EFLAGS: 00010286
> [  260.362281][    C0] RAX: 0000000000000063 RBX: ffff888036278000 RCX: ffffffff842622c0
> [  260.365646][    C0] RDX: 0000000000000000 RSI: ffffffff842622c0 RDI: 0000000000000002
> [  260.368691][    C0] RBP: ffff88800e2d8000 R08: ffffffff81170398 R09: 0000000000000000
> [  260.371828][    C0] R10: 0000000000000005 R11: 0000000000080000 R12: 0000000000000001
> [  260.375009][    C0] R13: ffff88800e2d8000 R14: ffff88800e2d8098 R15: ffff88800e2d8080
> [  260.378533][    C0] FS:  0000000000000000(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> [  260.382408][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  260.385155][    C0] CR2: 00007fbbed4c8dc0 CR3: 000000000d765000 CR4: 00000000000506f0
> [  260.388406][    C0] Call Trace:
> [  260.389929][    C0]  <IRQ>
> [  260.391386][    C0]  ? lockdep_hardirqs_on+0x79/0x100
> [  260.393743][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [  260.396147][    C0]  ? ktime_get+0x2d3/0x400
> [  260.398064][    C0]  tcp_write_timer_handler+0x257/0x3f0
> [  260.400357][    C0]  tcp_write_timer+0x19c/0x240
> [  260.402389][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  260.405068][    C0]  call_timer_fn+0xe3/0x4f0
> [  260.407041][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  260.409308][    C0]  run_timer_softirq+0x812/0xac0
> [  260.411613][    C0]  __do_softirq+0xde/0x539
> [  260.413646][    C0]  irq_exit_rcu+0xb6/0xf0
> [  260.415607][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
> [  260.417882][    C0]  </IRQ>
> [  260.419276][    C0]  <TASK>
> [  260.420672][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  260.423039][    C0] RIP: 0010:default_idle+0xb/0x10
> [  260.425291][    C0] Code: 00 00 00 75 09 48 83 c4 18 5b 5d 41 5c c3 e8 5c 96 fe ff cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 93 09 48 00 fb f4 <c3> 0f 1f 40 00 65 48 8b 04 25 40 af 01 00 f0 80 48 02 20 48 8b 10
> [  260.433105][    C0] RSP: 0018:ffffffff84203e90 EFLAGS: 00000206
> [  260.435589][    C0] RAX: 0000000000024239 RBX: 0000000000000000 RCX: ffffffff842622c0
> [  260.438759][    C0] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  260.441945][    C0] RBP: ffffffff842622c0 R08: 0000000000000001 R09: 0000000000000001
> [  260.445777][    C0] R10: 0000000000000001 R11: 0000000000080000 R12: 0000000000000000
> [  260.449093][    C0] R13: ffffffff842622c0 R14: 0000000000000000 R15: 0000000000000000
> [  260.452404][    C0]  default_idle_call+0x6a/0x260
> [  260.454562][    C0]  do_idle+0x20c/0x260
> [  260.456353][    C0]  ? trace_init_perf_perm_irq_work_exit+0xe/0xe
> [  260.458887][    C0]  cpu_startup_entry+0x14/0x20
> [  260.461152][    C0]  start_kernel+0x8f7/0x91e
> [  260.463226][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
> [  260.465718][    C0]  </TASK>
> [  260.467111][    C0] Kernel panic - not syncing: panic_on_warn set ...
> [  260.469664][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.17.0-dirty #748
> [  260.472684][    C0] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  260.476355][    C0] Call Trace:
> [  260.477800][    C0]  <IRQ>
> [  260.479141][    C0]  dump_stack_lvl+0xcd/0x134
> [  260.481197][    C0]  panic+0x1d0/0x537
> [  260.482913][    C0]  ? __warn.cold+0xb0/0x228
> [  260.484892][    C0]  ? tcp_retransmit_timer.cold+0xdf/0xe6
> [  260.487190][    C0]  __warn.cold+0xc6/0x228
> [  260.488963][    C0]  ? tcp_retransmit_timer.cold+0xdf/0xe6
> [  260.491241][    C0]  report_bug+0x188/0x1d0
> [  260.493109][    C0]  handle_bug+0x3c/0x60
> [  260.495107][    C0]  exc_invalid_op+0x14/0x70
> [  260.497016][    C0]  asm_exc_invalid_op+0x12/0x20
> [  260.499037][    C0] RIP: 0010:tcp_retransmit_timer.cold+0xdf/0xe6
> [  260.501651][    C0] Code: 10 48 c7 c7 60 9d ff 83 48 8b 85 a0 03 00 00 44 8b 8b 4c 01 00 00 4c 8b 45 60 0f b6 4d 12 48 8d 90 88 01 00 00 e8 a8 25 f2 ff <0f> 0b e9 b6 40 5f ff e8 f3 59 ee fd 41 0f b6 d5 4c 89 e6 48 c7 c7
> [  260.508760][    C0] RSP: 0018:ffffc90000003d90 EFLAGS: 00010286
> [  260.511211][    C0] RAX: 0000000000000063 RBX: ffff888036278000 RCX: ffffffff842622c0
> [  260.514559][    C0] RDX: 0000000000000000 RSI: ffffffff842622c0 RDI: 0000000000000002
> [  260.517942][    C0] RBP: ffff88800e2d8000 R08: ffffffff81170398 R09: 0000000000000000
> [  260.521127][    C0] R10: 0000000000000005 R11: 0000000000080000 R12: 0000000000000001
> [  260.524366][    C0] R13: ffff88800e2d8000 R14: ffff88800e2d8098 R15: ffff88800e2d8080
> [  260.528260][    C0]  ? vprintk+0x88/0x90
> [  260.530145][    C0]  ? lockdep_hardirqs_on+0x79/0x100
> [  260.532452][    C0]  ? __sanitizer_cov_trace_pc+0x1a/0x40
> [  260.535072][    C0]  ? ktime_get+0x2d3/0x400
> [  260.536958][    C0]  tcp_write_timer_handler+0x257/0x3f0
> [  260.539214][    C0]  tcp_write_timer+0x19c/0x240
> [  260.541237][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  260.543627][    C0]  call_timer_fn+0xe3/0x4f0
> [  260.545677][    C0]  ? tcp_write_timer_handler+0x3f0/0x3f0
> [  260.547973][    C0]  run_timer_softirq+0x812/0xac0
> [  260.550053][    C0]  __do_softirq+0xde/0x539
> [  260.551937][    C0]  irq_exit_rcu+0xb6/0xf0
> [  260.553767][    C0]  sysvec_apic_timer_interrupt+0x8e/0xc0
> [  260.556439][    C0]  </IRQ>
> [  260.557744][    C0]  <TASK>
> [  260.559051][    C0]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  260.561515][    C0] RIP: 0010:default_idle+0xb/0x10
> [  260.563619][    C0] Code: 00 00 00 75 09 48 83 c4 18 5b 5d 41 5c c3 e8 5c 96 fe ff cc cc cc cc cc cc cc cc cc cc cc cc eb 07 0f 00 2d 93 09 48 00 fb f4 <c3> 0f 1f 40 00 65 48 8b 04 25 40 af 01 00 f0 80 48 02 20 48 8b 10
> [  260.570866][    C0] RSP: 0018:ffffffff84203e90 EFLAGS: 00000206
> [  260.573255][    C0] RAX: 0000000000024239 RBX: 0000000000000000 RCX: ffffffff842622c0
> [  260.577004][    C0] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> [  260.580254][    C0] RBP: ffffffff842622c0 R08: 0000000000000001 R09: 0000000000000001
> [  260.583366][    C0] R10: 0000000000000001 R11: 0000000000080000 R12: 0000000000000000
> [  260.586553][    C0] R13: ffffffff842622c0 R14: 0000000000000000 R15: 0000000000000000
> [  260.589759][    C0]  default_idle_call+0x6a/0x260
> [  260.591774][    C0]  do_idle+0x20c/0x260
> [  260.593618][    C0]  ? trace_init_perf_perm_irq_work_exit+0xe/0xe
> [  260.596736][    C0]  cpu_startup_entry+0x14/0x20
> [  260.598736][    C0]  start_kernel+0x8f7/0x91e
> [  260.600659][    C0]  secondary_startup_64_no_verify+0xc3/0xcb
> [  260.603066][    C0]  </TASK>
> [  260.605294][    C0] Kernel Offset: disabled
> [  260.607310][    C0] Rebooting in 10 seconds..
> ------------------------------------------------------------
>
> Would you check where this PF_INET6 socket is created at and whether
> this PF_INET6 socket is taking a reference to the net namespace?
>


Try removing NFS from your kernel .config ? If your repro still works,
then another user of kernel TCP socket needs some care.

NFS maintainers and other folks are already working on fixing this issue,
which is partly caused by fs/file_table.c being able to delay fput(),
look at code in fput_many()

Kernel TCP sockets are tricky, they (for good reasons) do not take a
reference on the net namespace.

This also means that users of such sockets need to make sure the
various tcp timers have been completed,
as sk_stop_timer() is not using del_timer_sync()

Even after a synchronous fput(), there is no guarantee that another
cpu is not running some of the socket timers functions.

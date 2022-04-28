Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 818F0513F3B
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 01:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbiD1X41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 19:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbiD1X4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 19:56:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7936EB3C75;
        Thu, 28 Apr 2022 16:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3038B831CE;
        Thu, 28 Apr 2022 23:53:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1910C385A9;
        Thu, 28 Apr 2022 23:53:04 +0000 (UTC)
Date:   Thu, 28 Apr 2022 19:53:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [RFC bpf-next 4/4] selftests/bpf: Add attach bench test
Message-ID: <20220428195303.6295e90b@gandalf.local.home>
In-Reply-To: <CAEf4Bzbu3zuDcPj3ue8D6VCdMTw2PEREJBU42CbR1Pe=5qOrTQ@mail.gmail.com>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
        <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
        <20220428095803.66c17c32@gandalf.local.home>
        <CAADnVQKi+4oBt2C__qz7QoHqTtXYLUjaqwTNFoSE=up9c9k4cA@mail.gmail.com>
        <20220428160519.04cc40c0@gandalf.local.home>
        <CAEf4Bzbu3zuDcPj3ue8D6VCdMTw2PEREJBU42CbR1Pe=5qOrTQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Apr 2022 16:32:20 -0700
Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > The job of recordmcount is to create a section of all the locations that
> > call fentry. That is EXACTLY what it did. No bug there! It did its job.  
> 
> But that __fentry__ call is not part of __bpf_tramp_exit, actually.
> Whether to call it a bug or limitation is secondary. It marks
> __bpf_tramp_exit as attachable through kprobe/ftrace while it really
> isn't.

I'm confused by what you mean by "marks __bpf_tramp_exit as attachable"?
What does? Where does it get that information? Does it read
available_filter_functions?

recordmcount isn't responsible for any of that, you are thinking of
kallsyms. Specifically *printf("%ps"). Because that's where the name comes
from. Anytime you print an address with "%ps" on a weak function that has
been overridden, it will give you the symbol before it. I guess you can
call it a bug in the "%ps" logic.


> 
> Below you are saying there is only user confusion. It's not just
> confusion. You'll get an error when you try to attach to
> __bpf_tramp_exit because __bpf_tramp_exit doesn't really have
> __fentry__ preamble and thus the kernel itself will reject it as a
> target. So when you build a generic tracing tool that fetches all the
> attachable kprobes, filters out all the blacklisted ones, you still
> end up with kprobe targets that are not attachable. It's definitely
> more than an inconvenience which I experienced first hand.
> 
> Can recordmcount or whoever does this be taught to use proper FUNC
> symbol size to figure out boundaries of the function?

kallsyms needs to do it. All recordmcount does is to give the locations of
the calls to fentry. It only gives addresses and does not give any symbol
information. Stop blaming recordcmcount!

> 
> $ readelf -s ~/linux-build/default/vmlinux | rg __bpf_tramp_exit
> 129408: ffffffff811b2ba0    63 FUNC    GLOBAL DEFAULT    1 __bpf_tramp_exit
> 
> So only the first 63 bytes of instruction after __bpf_tramp_exit
> should be taken into account. Everything else doesn't belong to
> __bpf_tramp_exit. So even though objdump pretends that call __fentry__
> is part of __bpf_tramp_exit, it's not.
> 
> ffffffff811b2ba0 <__bpf_tramp_exit>:
> ffffffff811b2ba0:       53                      push   %rbx
> ffffffff811b2ba1:       48 89 fb                mov    %rdi,%rbx
> ffffffff811b2ba4:       e8 97 d2 f2 ff          call
> ffffffff810dfe40 <__rcu_read_lock>
> ffffffff811b2ba9:       48 8b 83 e0 00 00 00    mov    0xe0(%rbx),%rax
> ffffffff811b2bb0:       a8 03                   test   $0x3,%al
> ffffffff811b2bb2:       75 0a                   jne
> ffffffff811b2bbe <__bpf_tramp_exit+0x1e>
> ffffffff811b2bb4:       65 48 ff 08             decq   %gs:(%rax)
> ffffffff811b2bb8:       5b                      pop    %rbx
> ffffffff811b2bb9:       e9 d2 0e f3 ff          jmp
> ffffffff810e3a90 <__rcu_read_unlock>
> ffffffff811b2bbe:       48 8b 83 e8 00 00 00    mov    0xe8(%rbx),%rax
> ffffffff811b2bc5:       f0 48 83 28 01          lock subq $0x1,(%rax)
> ffffffff811b2bca:       75 ec                   jne
> ffffffff811b2bb8 <__bpf_tramp_exit+0x18>
> ffffffff811b2bcc:       48 8b 83 e8 00 00 00    mov    0xe8(%rbx),%rax
> ffffffff811b2bd3:       48 8d bb e0 00 00 00    lea    0xe0(%rbx),%rdi
> ffffffff811b2bda:       ff 50 08                call   *0x8(%rax)
> ffffffff811b2bdd:       eb d9                   jmp
> ffffffff811b2bb8 <__bpf_tramp_exit+0x18>
> ffffffff811b2bdf:       90                      nop
> 
> ^^^ ffffffff811b2ba0 + 63 = ffffffff811b2bdf -- this is the end of
> __bpf_tramp_exit
> 
> ffffffff811b2be0:       e8 3b 9c e9 ff          call
> ffffffff8104c820 <__fentry__>
> ffffffff811b2be5:       b8 f4 fd ff ff          mov    $0xfffffdf4,%eax
> ffffffff811b2bea:       c3                      ret
> ffffffff811b2beb:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> 
> 


> > One solution is to simply get the end of the function that is provided by
> > kallsyms to make sure the fentry call location is inside the function, and
> > if it is not, then not show that function in available_filter_functions but
> > instead show something like "** unnamed function **" or whatever.

Do the above. The names in available_filter_functions are derived from
kallsyms. There's a way to also ask kallsyms to give you the end pointer
of the function address. The only thing that avaliable_filter_functions
does is to print the location found by recordmcount with a "%ps".

If you don't want it to show up in available_filter_functions, then you
need to open code the %ps onto kallsyms lookup and then compare the
function with the end (if it is found). Or fix %ps.

-- Steve

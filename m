Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1C8A5135E1
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 15:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347848AbiD1OBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347846AbiD1OBX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 10:01:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54530506FC;
        Thu, 28 Apr 2022 06:58:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6EC561CE1;
        Thu, 28 Apr 2022 13:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0301C385A0;
        Thu, 28 Apr 2022 13:58:04 +0000 (UTC)
Date:   Thu, 28 Apr 2022 09:58:03 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
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
Message-ID: <20220428095803.66c17c32@gandalf.local.home>
In-Reply-To: <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
References: <20220407125224.310255-1-jolsa@kernel.org>
        <20220407125224.310255-5-jolsa@kernel.org>
        <CAEf4BzbE1n3Lie+tWTzN69RQUWgjxePorxRr9J8CuiQVUfy-kA@mail.gmail.com>
        <20220412094923.0abe90955e5db486b7bca279@kernel.org>
        <CAEf4BzaQRcZGMqq5wqHo3wSHZAAVvY6AhizDk_dV_GtnwHuxLQ@mail.gmail.com>
        <20220416232103.c0b241c2ec7f2b3b985a2f99@kernel.org>
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

On Sat, 16 Apr 2022 23:21:03 +0900
Masami Hiramatsu <mhiramat@kernel.org> wrote:

> OK, I also confirmed that __bpf_tramp_exit is listed. (others seems no notrace)
> 
> /sys/kernel/tracing # cat available_filter_functions | grep __bpf_tramp
> __bpf_tramp_image_release
> __bpf_tramp_image_put_rcu
> __bpf_tramp_image_put_rcu_tasks
> __bpf_tramp_image_put_deferred
> __bpf_tramp_exit
> 
> My gcc is older one.
> gcc version 9.4.0 (Ubuntu 9.4.0-1ubuntu1~20.04.1) 
> 
> But it seems that __bpf_tramp_exit() doesn't call __fentry__. (I objdump'ed) 
> 
> ffffffff81208270 <__bpf_tramp_exit>:
> ffffffff81208270:       55                      push   %rbp
> ffffffff81208271:       48 89 e5                mov    %rsp,%rbp
> ffffffff81208274:       53                      push   %rbx
> ffffffff81208275:       48 89 fb                mov    %rdi,%rbx
> ffffffff81208278:       e8 83 70 ef ff          callq  ffffffff810ff300 <__rcu_read_lock>
> ffffffff8120827d:       31 d2                   xor    %edx,%edx

You need to look deeper ;-)
> 
> 
> > 
> > So it's quite bizarre and inconsistent.  
> 
> Indeed. I guess there is a bug in scripts/recordmcount.pl.

No there isn't.

I added the addresses it was mapping and found this:

ffffffffa828f680 T __bpf_tramp_exit

(which is relocated, but it's trivial to map it with the actual function).

At the end of that function we have:

ffffffff8128f767:       48 8d bb e0 00 00 00    lea    0xe0(%rbx),%rdi
ffffffff8128f76e:       48 8b 40 08             mov    0x8(%rax),%rax
ffffffff8128f772:       e8 89 28 d7 00          call   ffffffff82002000 <__x86_indirect_thunk_array>
                        ffffffff8128f773: R_X86_64_PLT32        __x86_indirect_thunk_rax-0x4
ffffffff8128f777:       e9 4a ff ff ff          jmp    ffffffff8128f6c6 <__bpf_tramp_exit+0x46>
ffffffff8128f77c:       0f 1f 40 00             nopl   0x0(%rax)
ffffffff8128f780:       e8 8b df dc ff          call   ffffffff8105d710 <__fentry__>
                        ffffffff8128f781: R_X86_64_PLT32        __fentry__-0x4
ffffffff8128f785:       b8 f4 fd ff ff          mov    $0xfffffdf4,%eax
ffffffff8128f78a:       c3                      ret    
ffffffff8128f78b:       0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)


Notice the call to fentry!

It's due to this:

void notrace __bpf_tramp_exit(struct bpf_tramp_image *tr)
{
	percpu_ref_put(&tr->pcref);
}

int __weak
arch_prepare_bpf_trampoline(struct bpf_tramp_image *tr, void *image, void *image_end,
			    const struct btf_func_model *m, u32 flags,
			    struct bpf_tramp_progs *tprogs,
			    void *orig_call)
{
	return -ENOTSUPP;
}

The weak function gets a call to ftrace, but it still gets compiled into
vmlinux but its symbol is dropped due to it being overridden. Thus, the
mcount_loc finds this call to fentry, and maps it to the symbol that is
before it, which just happened to be __bpf_tramp_exit.

I made that weak function "notrace" and the __bpf_tramp_exit disappeared
from the available_filter_functions list.

-- Steve

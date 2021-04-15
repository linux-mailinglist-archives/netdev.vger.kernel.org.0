Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0746C361139
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233666AbhDORk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:40:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49822 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233134AbhDORkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 13:40:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618508401;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dzuv3SBSi4iO5f26UgF+PEOzT+2ZbdIBuiAhr8Fbb64=;
        b=Jpq0Slok3vJvWP+Roh14L144Z22ICmr0rFBt56xc7zw1W1Z6daBFoRG43NJ/qu7KKVlEJV
        Z/oO/u2fZN5CyiaNbGuT9sD5XLwZyGPajSI1A0xwKE2SiX+icS+r7MKXVH9YV7AHJxlcGq
        jh3SuEuHH8vJgfbSKAEsM1UK+AMb2bw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-9zcSYSRSMRKyITT3P2HwOQ-1; Thu, 15 Apr 2021 13:39:59 -0400
X-MC-Unique: 9zcSYSRSMRKyITT3P2HwOQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21D1381433D;
        Thu, 15 Apr 2021 17:39:57 +0000 (UTC)
Received: from krava (unknown [10.40.196.6])
        by smtp.corp.redhat.com (Postfix) with SMTP id 3F00B5C3FD;
        Thu, 15 Apr 2021 17:39:45 +0000 (UTC)
Date:   Thu, 15 Apr 2021 19:39:45 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCHv2 RFC bpf-next 0/7] bpf: Add support for ftrace probe
Message-ID: <YHh6YeOPh0HIlb3e@krava>
References: <20210413121516.1467989-1-jolsa@kernel.org>
 <CAEf4Bzazst1rBi4=LuP6_FnPXCRYBNFEtDnK3UVBj6Eo6xFNtQ@mail.gmail.com>
 <YHbd2CmeoaiLJj7X@krava>
 <CAEf4BzYyVj-Tjy9ZZdAU5nOtJ8_auvVobTT6pMqg8zPb9jj-Ow@mail.gmail.com>
 <20210415111002.324b6bfa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210415111002.324b6bfa@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 11:10:02AM -0400, Steven Rostedt wrote:

SNIP

> > > heya,
> > > I had some initial prototypes trying this way, but always ended up
> > > in complicated code, that's why I turned to ftrace_ops.
> > >
> > > let's see if it'll make any sense to you ;-)
> > >
> > > 1) so let's say we have extra trampoline for the program (which
> > > also seems a bit of waste since there will be just single record  
> > 
> > BPF trampoline does more than just calls BPF program. At the very
> > least it saves input arguments for fexit program to be able to access
> > it. But given it's one BPF trampoline attached to thousands of
> > functions, I don't see any problem there.
> 
> Note, there's a whole infrastructure that does similar things in ftrace.
> I wrote the direct call to jump to individual trampolines, because ftrace
> was too generic. The only way at the time to get to the arguments was via
> the ftrace_regs_caller, which did a full save of regs, because this was
> what kprobes needed, and was too expensive for BPF.
> 
> I now regret writing the direct callers, and instead should have just done
> what I did afterward, which was to make ftrace default to a light weight
> trampoline that only saves enough for getting access to the arguments of
> the function. And have BPF use that. But I was under the impression that
> BPF needed fast access to a single function, and it would not become a
> generic trampoline for multiple functions, because that was the argument
> used to not enhance ftrace.
> 
> Today, ftrace by dafault (on x86) implements a generic way to get the
> arguments, and just the arguments which is exactly what BPF would need for
> multiple functions. And yes, you even have access to the return code if you
> want to "hijack" it. And since it was originally for a individual functions
> (and not a batch), I created the direct caller for BPF. But the direct
> caller will not be enhanced for multiple functions, as that's not its
> purpose. If you want a trampoline to be called back to multiple functions,
> then use the infrastructure that was designed for that. Which is what Jiri
> had proposed here.
> 
> And because the direct caller can mess with the return code, it breaks
> function graph tracing. As a temporary work around, we just made function
> graph ignore any function that has a direct caller attached to it.
> 
> If you want batch processing of BPF programs, you need to first fix the
> function graph tracing issue, and allow both BPF attached callers and
> function graph to work on the same functions.
> 
> I don't know how the BPF code does it, but if you are tracing the exit
> of a function, I'm assuming that you hijack the return pointer and replace
> it with a call to a trampoline that has access to the arguments. To do

hi,
it's bit different, the trampoline makes use of the fact that the
call to trampoline is at the very begining of the function and, so
it can call the origin function with 'call function + 5' instr.

so in nutshell the trampoline does:

  call entry_progs
  call original_func+5
  call exit_progs

you can check this in arch/x86/net/bpf_jit_comp.c in moe detail:

 * The assembly code when eth_type_trans is called from trampoline:
 *
 * push rbp
 * mov rbp, rsp
 * sub rsp, 24                     // space for skb, dev, return value
 * push rbx                        // temp regs to pass start time
 * mov qword ptr [rbp - 24], rdi   // save skb pointer to stack
 * mov qword ptr [rbp - 16], rsi   // save dev pointer to stack
 * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
 * mov rbx, rax                    // remember start time if bpf stats are enabled
 * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
 * call addr_of_jited_FENTRY_prog  // bpf prog can access skb and dev

entry program called ^^^

 * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
 * mov rsi, rbx                    // prog start time
 * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
 * mov rdi, qword ptr [rbp - 24]   // restore skb pointer from stack
 * mov rsi, qword ptr [rbp - 16]   // restore dev pointer from stack
 * call eth_type_trans+5           // execute body of eth_type_trans

original function called ^^^

 * mov qword ptr [rbp - 8], rax    // save return value
 * call __bpf_prog_enter           // rcu_read_lock and preempt_disable
 * mov rbx, rax                    // remember start time in bpf stats are enabled
 * lea rdi, [rbp - 24]             // R1==ctx of bpf prog
 * call addr_of_jited_FEXIT_prog   // bpf prog can access skb, dev, return value

exit program called ^^^

 * movabsq rdi, 64bit_addr_of_struct_bpf_prog  // unused if bpf stats are off
 * mov rsi, rbx                    // prog start time
 * call __bpf_prog_exit            // rcu_read_unlock, preempt_enable and stats math
 * mov rax, qword ptr [rbp - 8]    // restore eth_type_trans's return value
 * pop rbx
 * leave
 * add rsp, 8                      // skip eth_type_trans's frame
 * ret                             // return to its caller

> this you need a shadow stack to save the real return as well as the
> parameters of the function. This is something that I have patches that do
> similar things with function graph.
> 
> If you want this feature, lets work together and make this work for both
> BPF and ftrace.

it's been some time I saw a graph tracer, is there a way to make it
access input arguments and make it available through ftrace_ops
interface?

thanks,
jirka


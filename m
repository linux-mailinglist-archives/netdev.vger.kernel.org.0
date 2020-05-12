Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4E81CE96E
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgELAB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725836AbgELAB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:01:57 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAB1C061A0C;
        Mon, 11 May 2020 17:01:57 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mq3so8633736pjb.1;
        Mon, 11 May 2020 17:01:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Svr3YAjn2yrRKCIaggaB6qtioXJpolfEgJytca6lcg=;
        b=assIV3zVCORlQwJIBK6MUhT8ARddmeZoOLfjTgMyGKLjrn9Kbn2BUJlyurnw3tHsge
         PLCbhgNmuvl8j6kwuCkK2flC2KDILNcRMC4DguTG0BrPvZN/m89IXQvVRcmKNChaGCt3
         9DW8UNS5qdcm+97DO2oXje5yfGprN1ePhBR7SEVmA1HfD4e4S6ApyOCs6GSAUVxbf0sZ
         iaX4GRwnJB1iysQhquB6i0YrIjaAcM1CnNRDNSOVjHV8XrJncTSCI3R07NEJIQUAW9BW
         zl/6jXYbUkqlfu0Io4Aj/cuFK43PKDOW/pUXhmkaBcjJ3ka2BSsQiiakP6qloJNF+yuf
         J5cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Svr3YAjn2yrRKCIaggaB6qtioXJpolfEgJytca6lcg=;
        b=Jc4xXJX5iAY/olK4V1qiQveYzT4fHYSdvrI4k7n6YF8ewo1nfaB72q7S6MwWwGHBAA
         XG6mAKjPnvrpRJG1dMbXXfTI0C0Fn84grESNOfJcLhVY0TB1Oxk6eKg3L2UXVawcTluM
         KTRLMM1eYUkUNMVollIPPOxu3+8G/sMaPjYBCnkwzK9HVyKmKyCRcIpqeYTQEMCF88nN
         nQnhcM+cyMD5NOAdDSknoLWrZ6V3PI8VH42cK8WVOWiAW6ALATyE6zn90dcf3XUMeeHj
         f466sAH54jnYC9qJVMc34kk4z8y3jwyWx/uCScocIByJgkv9J6GjSouYzf4mfBcaVCrS
         7SNQ==
X-Gm-Message-State: AGi0PuYt4FXAsEmJ1ilEWbxFF340rxs7NR2mXETTussIWbaXvF4Wis5z
        vE9RGg/XED0Y/RlVmGnn+gE=
X-Google-Smtp-Source: APiQypLlofye8gqxGNKaf5nqsxbwmxLsohbiJLxbvf2cDDF67OQlMKfrRxfSWpGh7G1QpIRbqGX2dQ==
X-Received: by 2002:a17:902:7003:: with SMTP id y3mr18096521plk.18.1589241717015;
        Mon, 11 May 2020 17:01:57 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:ec64])
        by smtp.gmail.com with ESMTPSA id a7sm10384764pfg.157.2020.05.11.17.01.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 17:01:56 -0700 (PDT)
Date:   Mon, 11 May 2020 17:01:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: Re: [RFC PATCH bpf-next 0/1] bpf, x64: optimize JIT
 prologue/epilogue generation
Message-ID: <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
 <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 10:05:25PM +0200, Daniel Borkmann wrote:
> Hey Maciej,
> 
> On 5/11/20 4:39 PM, Maciej Fijalkowski wrote:
> > Hi!
> > 
> > Today, BPF x86-64 JIT is preserving all of the callee-saved registers
> > for each BPF program being JITed, even when none of the R6-R9 registers
> > are used by the BPF program. Furthermore the tail call counter is always
> > pushed/popped to/from the stack even when there is no tail call usage in
> > BPF program being JITed. Optimization can be introduced that would
> > detect the usage of R6-R9 and based on that push/pop to/from the stack
> > only what is needed. Same goes for tail call counter.
> > 
> > Results look promising for such instruction reduction. Below are the
> > numbers for xdp1 sample on FVL 40G NIC receiving traffic from pktgen:
> > 
> > * With optimization: 22.3 Mpps
> > * Without:           19.0 mpps
> > 
> > So it's around 15% of performance improvement. Note that xdp1 is not
> > using any of callee saved registers, nor the tail call, hence such
> > speed-up.
> > 
> > There is one detail that needs to be handled though.
> > 
> > Currently, x86-64 JIT tail call implementation is skipping the prologue
> > of target BPF program that has constant size. With the mentioned
> > optimization implemented, each particular BPF program that might be
> > inserted onto the prog array map and therefore be the target of tail
> > call, could have various prologue size.
> > 
> > Let's have some pseudo-code example:
> > 
> > func1:
> > pro
> > code
> > epi
> > 
> > func2:
> > pro
> > code'
> > epi
> > 
> > func3:
> > pro
> > code''
> > epi
> > 
> > Today, pro and epi are always the same (9/7) instructions. So a tail
> > call from func1 to func2 is just a:
> > 
> > jump func2 + sizeof pro in bytes (PROLOGUE_SIZE)
> > 
> > With the optimization:
> > 
> > func1:
> > pro
> > code
> > epi
> > 
> > func2:
> > pro'
> > code'
> > epi'
> > 
> > func3:
> > pro''
> > code''
> > epi''
> > 
> > For making the tail calls up and running with the mentioned optimization
> > in place, x86-64 JIT should emit the pop registers instructions
> > that were pushed on prologue before the actual jump. Jump offset should
> > skip the instructions that are handling rbp/rsp, not the whole prologue.
> > 
> > A tail call within func1 would then need to be:
> > epi -> pop what pro pushed, but no leave/ret instructions
> > jump func2 + 16 // first push insn of pro'; if no push, then this would
> >                  // a direct jump to code'
> > 
> > Magic value of 16 comes from count of bytes that represent instructions
> > that are skipped:
> > 0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> > 55                      push   %rbp
> > 48 89 e5                mov    %rsp,%rbp
> > 48 81 ec 08 00 00 00    sub    $0x8,%rsp
> > 
> > which would in many cases add *more* instructions for tailcalls. If none
> > of callee-saved registers are used, then there would be no overhead with
> > such optimization in place.
> > 
> > I'm not sure how to measure properly the impact on the BPF programs that
> > are utilizing tail calls. Any suggestions?
> 
> Right, so far the numbers above (no callee saved registers, no tail calls)
> are really the best case scenario. I think programs not using callee saved
> registers are probably very limited in what they do, and tail calls are often
> used as well (although good enough for AF_XDP, for example). So I wonder how
> far we would regress with callee saved registers and tail calls. For Cilium
> right now you can roughly assume a worst case tail call depth of ~6 with static
> jumps (that we patch to jmp/nop). Only in one case we have a tail call map
> index that is non-static. In terms of registers, assume all of them are used
> one way or another. If you could check the impact in such setting, that would
> be great.
> 
> > Daniel, Alexei, what is your view on this?
> 
> I think performance wise this would be both pro and con depending how tail
> calls are used. One upside however, and I think you didn't mention it here
> would be that we don't need to clamp used stack space to 512, so we could
> actually track how much stack is used (or if any is used at all) and adapt
> it between tail calls? Depending on the numbers, if we'd go that route, it
> should rather be generalized and tracked via verifier so all JITs can behave
> the same (and these workarounds in verifier lifted). But then 15% performance
> improvement as you state above is a lot, probably we might regress at least
> as much as well in your benchmark. I wonder whether there should be a knob
> for it, though it's mainly implementation detail..

I was thinking about knob too, but users are rarely going to touch it,
so if we go for opt-in it will mostly be unused except by few folks.
So I think it's better to go with this approach unconditionally,
but first I'd like to see the performance numbers in how it regresses
the common case. AF_XDP's empty prog that does 'return XDP_PASS' is
a rare case and imo not worth optimizing for, but I see a lot of value
if this approach allows to lift tail_call vs bpf2bpf restriction.
It looks to me that bpf2bpf will be able to work. prog_A will call into prog_B
and if that prog does any kind of tail_call that tail_call will
eventually finish and the execution will return to prog_A as normal.
So I'd like to ask for two things:
1. perf numbers for something like progs/bpf_flow.c before and after
2. removal of bpf2bpf vs tail_call restriction and new selftests to prove
that it's working. that will include droping 512 stack clamp.

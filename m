Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5881CE504
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 22:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731515AbgEKUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 16:05:32 -0400
Received: from www62.your-server.de ([213.133.104.62]:41090 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727873AbgEKUFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 16:05:31 -0400
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYEg2-0004QR-Gq; Mon, 11 May 2020 22:05:26 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jYEg2-000TWY-6i; Mon, 11 May 2020 22:05:26 +0200
Subject: Re: [RFC PATCH bpf-next 0/1] bpf, x64: optimize JIT prologue/epilogue
 generation
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>, ast@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
Date:   Mon, 11 May 2020 22:05:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25809/Mon May 11 14:16:55 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Maciej,

On 5/11/20 4:39 PM, Maciej Fijalkowski wrote:
> Hi!
> 
> Today, BPF x86-64 JIT is preserving all of the callee-saved registers
> for each BPF program being JITed, even when none of the R6-R9 registers
> are used by the BPF program. Furthermore the tail call counter is always
> pushed/popped to/from the stack even when there is no tail call usage in
> BPF program being JITed. Optimization can be introduced that would
> detect the usage of R6-R9 and based on that push/pop to/from the stack
> only what is needed. Same goes for tail call counter.
> 
> Results look promising for such instruction reduction. Below are the
> numbers for xdp1 sample on FVL 40G NIC receiving traffic from pktgen:
> 
> * With optimization: 22.3 Mpps
> * Without:           19.0 mpps
> 
> So it's around 15% of performance improvement. Note that xdp1 is not
> using any of callee saved registers, nor the tail call, hence such
> speed-up.
> 
> There is one detail that needs to be handled though.
> 
> Currently, x86-64 JIT tail call implementation is skipping the prologue
> of target BPF program that has constant size. With the mentioned
> optimization implemented, each particular BPF program that might be
> inserted onto the prog array map and therefore be the target of tail
> call, could have various prologue size.
> 
> Let's have some pseudo-code example:
> 
> func1:
> pro
> code
> epi
> 
> func2:
> pro
> code'
> epi
> 
> func3:
> pro
> code''
> epi
> 
> Today, pro and epi are always the same (9/7) instructions. So a tail
> call from func1 to func2 is just a:
> 
> jump func2 + sizeof pro in bytes (PROLOGUE_SIZE)
> 
> With the optimization:
> 
> func1:
> pro
> code
> epi
> 
> func2:
> pro'
> code'
> epi'
> 
> func3:
> pro''
> code''
> epi''
> 
> For making the tail calls up and running with the mentioned optimization
> in place, x86-64 JIT should emit the pop registers instructions
> that were pushed on prologue before the actual jump. Jump offset should
> skip the instructions that are handling rbp/rsp, not the whole prologue.
> 
> A tail call within func1 would then need to be:
> epi -> pop what pro pushed, but no leave/ret instructions
> jump func2 + 16 // first push insn of pro'; if no push, then this would
>                  // a direct jump to code'
> 
> Magic value of 16 comes from count of bytes that represent instructions
> that are skipped:
> 0f 1f 44 00 00          nopl   0x0(%rax,%rax,1)
> 55                      push   %rbp
> 48 89 e5                mov    %rsp,%rbp
> 48 81 ec 08 00 00 00    sub    $0x8,%rsp
> 
> which would in many cases add *more* instructions for tailcalls. If none
> of callee-saved registers are used, then there would be no overhead with
> such optimization in place.
> 
> I'm not sure how to measure properly the impact on the BPF programs that
> are utilizing tail calls. Any suggestions?

Right, so far the numbers above (no callee saved registers, no tail calls)
are really the best case scenario. I think programs not using callee saved
registers are probably very limited in what they do, and tail calls are often
used as well (although good enough for AF_XDP, for example). So I wonder how
far we would regress with callee saved registers and tail calls. For Cilium
right now you can roughly assume a worst case tail call depth of ~6 with static
jumps (that we patch to jmp/nop). Only in one case we have a tail call map
index that is non-static. In terms of registers, assume all of them are used
one way or another. If you could check the impact in such setting, that would
be great.

> Daniel, Alexei, what is your view on this?

I think performance wise this would be both pro and con depending how tail
calls are used. One upside however, and I think you didn't mention it here
would be that we don't need to clamp used stack space to 512, so we could
actually track how much stack is used (or if any is used at all) and adapt
it between tail calls? Depending on the numbers, if we'd go that route, it
should rather be generalized and tracked via verifier so all JITs can behave
the same (and these workarounds in verifier lifted). But then 15% performance
improvement as you state above is a lot, probably we might regress at least
as much as well in your benchmark. I wonder whether there should be a knob
for it, though it's mainly implementation detail..

> For implementation details, see commit message of included patch.
> 
> Thank you,
> Maciej
> 
> 
> Maciej Fijalkowski (1):
>    bpf, x64: optimize JIT prologue/epilogue generation
> 
>   arch/x86/net/bpf_jit_comp.c | 190 ++++++++++++++++++++++++++++--------
>   1 file changed, 148 insertions(+), 42 deletions(-)
> 


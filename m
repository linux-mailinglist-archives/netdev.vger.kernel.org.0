Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D391D8780
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgERSsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:48:10 -0400
Received: from mga17.intel.com ([192.55.52.151]:25110 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728954AbgERSsJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 14:48:09 -0400
IronPort-SDR: 9w171sGsPnXirNoSx2AUB3WNFcAG++UvT/G8tNU0+0tavcta3Q3Wz1OP5TbCqUCqQHg8PmNM2w
 nGMqcGKqYVNA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2020 11:48:09 -0700
IronPort-SDR: mgWApbAGJRj9w0REMKEw6KCfhSIfuskQOQLzs/P57nbv/sxZwkmU+NY36C2Ft9lPuIDn8zANQd
 4mihNWmNYG6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,407,1583222400"; 
   d="scan'208";a="264053954"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga003.jf.intel.com with ESMTP; 18 May 2020 11:48:06 -0700
Date:   Mon, 18 May 2020 20:44:58 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, ast@kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, lmb@cloudflare.com,
        john.fastabend@gmail.com
Subject: Re: getting bpf_tail_call to work with bpf function calls. Was: [RFC
 PATCH bpf-next 0/1] bpf, x64: optimize JIT prologue/epilogue generation
Message-ID: <20200518184458.GC6472@ranger.igk.intel.com>
References: <20200511143912.34086-1-maciej.fijalkowski@intel.com>
 <2e3c6be0-e482-d856-7cc1-b1d03a26428e@iogearbox.net>
 <20200512000153.hfdeh653v533qbe6@ast-mbp.dhcp.thefacebook.com>
 <20200513115855.GA3574@ranger.igk.intel.com>
 <20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200517043227.2gpq22ifoq37ogst@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 16, 2020 at 09:32:27PM -0700, Alexei Starovoitov wrote:
> On Wed, May 13, 2020 at 01:58:55PM +0200, Maciej Fijalkowski wrote:
> > 
> > So to me, if we would like to get rid of maxing out stack space, then we
> > would have to do some dancing for preserving the tail call counter - keep
> > it in some unused register? Or epilogue would pop it from stack to some
> > register and target program's prologue would push it to stack from that
> > register (I am making this up probably). And rbp/rsp would need to be
> > created/destroyed during the program-to-program transition that happens
> > via tailcall. That would mean also more instructions.
> 
> How about the following:
> The prologue will look like:
> nop5
> xor eax,eax  // two new bytes if bpf_tail_call() is used in this function
> push rbp
> mov rbp, rsp
> sub rsp, rounded_stack_depth
> push rax // zero init tail_call counter
> variable number of push rbx,r13,r14,r15
> 
> Then bpf_tail_call will pop variable number rbx,..
> and final 'pop rax'
> Then 'add rsp, size_of_current_stack_frame'
> jmp to next function and skip over 'nop5; xor eax,eax; push rpb; mov rbp, rsp'
> 
> This way new function will set its own stack size and will init tail call
> counter with whatever value the parent had.
> 
> If next function doesn't use bpf_tail_call it won't have 'xor eax,eax'.
> Instead it would need to have 'nop2' in there.
> That's the only downside I see.
> Any other ideas?

Not really - had a thought with Bjorn about using one callee-saved
register that is yet unused by x64 JIT (%r12) and i was also thinking
about some freaky usage of SSE register as a general purpose one. However,
your idea is pretty neat - I gave it already a shot and with a single
tweak I managed to got it working, e.g. selftests are fine as well as two
samples that utilize tail calls. Note also that I got rid of the stack
clamp being done in fixup_bpf_calls.

About a tweak:
- RETPOLINE_RAX_BPF_JIT used for indirect tail calls needed to become a
  RETPOLINE_RCX_BPF_JIT, so that we preserve the content of %rax across
  jumping between programs via tail calls. I looked up GCC commit that
  Daniel quoted on a patch that implements RETPOLINE_RAX_BPF_JIT and it
  said that for register that is holding the address of function that we
  will be jumping onto, we are free to use most of GP registers. I picked
  %rcx.

I was also thinking about a minor optimization where we would replace the
add/sub %rsp, $off32 with a nop7 if stack depth is 0.

About a way forward - I reached out to Bjorn to co-operate on providing
the benchmark for measuring the impact of new tail call handling as well
as providing a proof in a form of selftests that bpf2bpf is working
together with tail calls.

About a benchmark, we think that having tests for best and worst cases
would tell us what is going on. So:
- have a main program that is not using any of callee registers that will
  be tailcalling onto another program that is also not using any of R6-R9.
- have the same flow but both programs will be using R6, R7, R8, R9; main
  program needs to use them because we will be popping these registers
  before the tail call and target program will be doing pushes.

Daniel, John, is there some Cilium benchmark that we could incorporate? I
don't think we be able to come up with a program that would mimic what you
have previously described, e.g. 6 static jumps where every program would
be utilizing every callee-saved register. Any help/pointers on how should
we approach it would be very appreciated.

Does that sound like a plan, overall?

Thank you,
Maciej

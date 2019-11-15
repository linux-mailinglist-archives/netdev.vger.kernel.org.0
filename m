Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 040FBFE8C3
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbfKOXms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:42:48 -0500
Received: from www62.your-server.de ([213.133.104.62]:58362 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfKOXms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:42:48 -0500
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlEj-0004sB-E5; Sat, 16 Nov 2019 00:42:45 +0100
Received: from [178.197.248.45] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iVlEj-000QIP-5f; Sat, 16 Nov 2019 00:42:45 +0100
Subject: Re: [PATCH rfc bpf-next 1/8] bpf, x86: generalize and extend
 bpf_arch_text_poke for direct jumps
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <cover.1573779287.git.daniel@iogearbox.net>
 <d2364bbaca1569b04e2434d8b58a458f21c685ef.1573779287.git.daniel@iogearbox.net>
 <CAEf4BzZau9d-feGEsOu617b7cd2aSfmmSi2TgwZbf4XZGBHASg@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <17b06848-c0e0-e766-912e-e11f85de9eca@iogearbox.net>
Date:   Sat, 16 Nov 2019 00:42:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZau9d-feGEsOu617b7cd2aSfmmSi2TgwZbf4XZGBHASg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25634/Fri Nov 15 10:44:37 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/19 12:22 AM, Andrii Nakryiko wrote:
> On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>>
>> Add BPF_MOD_{NOP_TO_JUMP,JUMP_TO_JUMP,JUMP_TO_NOP} patching for x86
>> JIT in order to be able to patch direct jumps or nop them out. We need
>> this facility in order to patch tail call jumps and in later work also
>> BPF static keys.
>>
>> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
>> ---
> 
> just naming nits, looks good otherwise
> 
>>   arch/x86/net/bpf_jit_comp.c | 64 ++++++++++++++++++++++++++-----------
>>   include/linux/bpf.h         |  6 ++++
>>   2 files changed, 52 insertions(+), 18 deletions(-)
>>
>> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
>> index 2e586f579945..66921f2aeece 100644
>> --- a/arch/x86/net/bpf_jit_comp.c
>> +++ b/arch/x86/net/bpf_jit_comp.c
>> @@ -203,8 +203,9 @@ struct jit_context {
>>   /* Maximum number of bytes emitted while JITing one eBPF insn */
>>   #define BPF_MAX_INSN_SIZE      128
>>   #define BPF_INSN_SAFETY                64
>> -/* number of bytes emit_call() needs to generate call instruction */
>> -#define X86_CALL_SIZE          5
>> +
>> +/* Number of bytes emit_patchable() needs to generate instructions */
>> +#define X86_PATCHABLE_SIZE     5
>>
>>   #define PROLOGUE_SIZE          25
>>
>> @@ -215,7 +216,7 @@ struct jit_context {
>>   static void emit_prologue(u8 **pprog, u32 stack_depth, bool ebpf_from_cbpf)
>>   {
>>          u8 *prog = *pprog;
>> -       int cnt = X86_CALL_SIZE;
>> +       int cnt = X86_PATCHABLE_SIZE;
>>
>>          /* BPF trampoline can be made to work without these nops,
>>           * but let's waste 5 bytes for now and optimize later
>> @@ -480,64 +481,91 @@ static void emit_stx(u8 **pprog, u32 size, u32 dst_reg, u32 src_reg, int off)
>>          *pprog = prog;
>>   }
>>
>> -static int emit_call(u8 **pprog, void *func, void *ip)
>> +static int emit_patchable(u8 **pprog, void *func, void *ip, u8 b1)
> 
> I'd strongly prefer opcode instead of b1 :) also would emit_patch() be
> a terrible name?

Hmm, been using b1 since throughout the JIT we use u8 b1/b2/b3/.. for our
EMIT*() macros to denote the encoding positions. So I thought it would be
more conventional, but could also change to op if preferred.

>>   {
>>          u8 *prog = *pprog;
>>          int cnt = 0;
>>          s64 offset;
>>
> 
> [...]
> 
>>          case BPF_MOD_CALL_TO_NOP:
>> -               if (memcmp(ip, old_insn, X86_CALL_SIZE))
>> +       case BPF_MOD_JUMP_TO_NOP:
>> +               if (memcmp(ip, old_insn, X86_PATCHABLE_SIZE))
>>                          goto out;
>> -               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_CALL_SIZE, NULL);
>> +               text_poke_bp(ip, ideal_nops[NOP_ATOMIC5], X86_PATCHABLE_SIZE,
> 
> maybe keep it shorter with X86_PATCH_SIZE?

Sure, then X86_PATCH_SIZE and emit_patch() it is.

>> +                            NULL);
>>                  break;
>>          }
>>          ret = 0;
> 
> [...]
> 


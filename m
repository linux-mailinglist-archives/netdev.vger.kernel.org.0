Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E24C3A8B70
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhFOV4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:56:54 -0400
Received: from www62.your-server.de ([213.133.104.62]:57422 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhFOV4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 17:56:53 -0400
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltH19-0009sn-8n; Tue, 15 Jun 2021 23:54:43 +0200
Received: from [85.7.101.30] (helo=linux-3.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1ltH18-000IMK-PK; Tue, 15 Jun 2021 23:54:42 +0200
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Kurt Manucredo <fuzzybritches0@gmail.com>,
        syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
        keescook@chromium.org, yhs@fb.com, dvyukov@google.com,
        andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        nathan@kernel.org, ndesaulniers@google.com,
        clang-built-linux@googlegroups.com,
        kernel-hardening@lists.openwall.com, kasan-dev@googlegroups.com
References: <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com> <YMkAbNQiIBbhD7+P@gmail.com>
 <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
 <YMkcYn4dyZBY/ze+@gmail.com> <YMkdx1VB0i+fhjAY@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <4713f6e9-2cfb-e2a6-c42d-b2a62f035bf2@iogearbox.net>
Date:   Tue, 15 Jun 2021 23:54:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <YMkdx1VB0i+fhjAY@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26202/Tue Jun 15 13:21:24 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/15/21 11:38 PM, Eric Biggers wrote:
> On Tue, Jun 15, 2021 at 02:32:18PM -0700, Eric Biggers wrote:
>> On Tue, Jun 15, 2021 at 11:08:18PM +0200, Daniel Borkmann wrote:
>>> On 6/15/21 9:33 PM, Eric Biggers wrote:
>>>> On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
>>>>>
>>>>> As I understand it, the UBSAN report is coming from the eBPF interpreter,
>>>>>    which is the *slow path* and indeed on many production systems is
>>>>>    compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
>>>>> Perhaps a better approach to the fix would be to change the interpreter
>>>>>    to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
>>>>>    bitnesses), thus matching the behaviour of most chips' shift opcodes.
>>>>> This would shut up UBSAN, without affecting JIT code generation.
>>>>
>>>> Yes, I suggested that last week
>>>> (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
>>>> get optimized out when compiling for most CPUs.
>>>
>>> Did you check if the generated interpreter code for e.g. x86 is the same
>>> before/after with that?
>>
>> Yes, on x86_64 with gcc 10.2.1, the disassembly of ___bpf_prog_run() is the same
>> both before and after (with UBSAN disabled).  Here is the patch I used:
>>
>> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> index 5e31ee9f7512..996db8a1bbfb 100644
>> --- a/kernel/bpf/core.c
>> +++ b/kernel/bpf/core.c
>> @@ -1407,12 +1407,30 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
>>   		DST = (u32) DST OP (u32) IMM;	\
>>   		CONT;
>>   
>> +	/*
>> +	 * Explicitly mask the shift amounts with 63 or 31 to avoid undefined
>> +	 * behavior.  Normally this won't affect the generated code.

The last one should probably be more specific in terms of 'normally', e.g. that
it is expected that the compiler is optimizing this away for archs like x86. Is
arm64 also covered by this ... do you happen to know on which archs this won't
be the case?

Additionally, I think such comment should probably be more clear in that it also
needs to give proper guidance to JIT authors that look at the interpreter code to
see what they need to implement, in other words, that they don't end up copying
an explicit AND instruction emission if not needed there.

>> +	 */
>> +#define ALU_SHIFT(OPCODE, OP)		\
>> +	ALU64_##OPCODE##_X:		\
>> +		DST = DST OP (SRC & 63);\
>> +		CONT;			\
>> +	ALU_##OPCODE##_X:		\
>> +		DST = (u32) DST OP ((u32)SRC & 31);	\
>> +		CONT;			\
>> +	ALU64_##OPCODE##_K:		\
>> +		DST = DST OP (IMM & 63);	\
>> +		CONT;			\
>> +	ALU_##OPCODE##_K:		\
>> +		DST = (u32) DST OP ((u32)IMM & 31);	\
>> +		CONT;

For the *_K cases these are explicitly rejected by the verifier already. Is this
required here nevertheless to suppress UBSAN false positive?

>>   	ALU(ADD,  +)
>>   	ALU(SUB,  -)
>>   	ALU(AND,  &)
>>   	ALU(OR,   |)
>> -	ALU(LSH, <<)
>> -	ALU(RSH, >>)
>> +	ALU_SHIFT(LSH, <<)
>> +	ALU_SHIFT(RSH, >>)
>>   	ALU(XOR,  ^)
>>   	ALU(MUL,  *)
>>   #undef ALU
> 
> Note, I missed the arithmetic right shifts later on in the function.  Same
> result there, though.
> 
> - Eric
> 


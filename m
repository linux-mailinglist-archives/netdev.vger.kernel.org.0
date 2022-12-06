Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57E41644BEA
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiLFSix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLFSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:38:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54901303C3;
        Tue,  6 Dec 2022 10:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 88233CE1930;
        Tue,  6 Dec 2022 18:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D807C433D7;
        Tue,  6 Dec 2022 18:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670351921;
        bh=SPe/vIOGKve9pGxoOhlXGkyCNGXdFzI5bv2oZeZRU84=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=iDHy4D0ZqrdamW0gWdhyqIssOMIL8qWKkEfYy1fJCksoBgnFTFCyRda8/MnAHNmDo
         YQQDaZzsQEnii84oRkdx/ehoBCFC0aZT3dA0fOufyfYE0biLzLPxz/Wrut8/XN9jNg
         vTPMQ0/OoPN3OemB0hzizojtfxWWHAT5OYnzP3Ig4GDsr0Koqkmfj+wlZv+H0/7NE0
         p/uPJir/pAy9G/PQYI9AfZ2E15d4t9me+oIbIwXV+Kyo15Bb1qFo0vus2CZog+fF1F
         Mm7dY9+d2jl3xAnXdRx8skObznCmoYOvVEEYtaTkUit+0X3he3RPzEExuGDRJgaeS0
         1AV14k9Si/Lyw==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Yonghong Song <yhs@meta.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
In-Reply-To: <9af1b919-ea15-e44c-b9cc-765c743dd617@meta.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
 <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
 <9af1b919-ea15-e44c-b9cc-765c743dd617@meta.com>
Date:   Tue, 06 Dec 2022 19:38:39 +0100
Message-ID: <87v8mos7gw.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Yonghong Song <yhs@meta.com> writes:

> On 12/6/22 9:47 AM, Yonghong Song wrote:
>>=20
>>=20
>> On 12/6/22 5:21 AM, Ilya Leoshkevich wrote:
>>> On Fri, 2022-12-02 at 11:36 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>>>>
>>>> A BPF call instruction can be, correctly, marked with zext_dst set to
>>>> true. An example of this can be found in the BPF selftests
>>>> progs/bpf_cubic.c:
>>>>
>>>> =C2=A0=C2=A0 ...
>>>> =C2=A0=C2=A0 extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>>>
>>>> =C2=A0=C2=A0 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>>> =C2=A0=C2=A0 {
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tc=
p_reno_undo_cwnd(sk);
>>>> =C2=A0=C2=A0 }
>>>> =C2=A0=C2=A0 ...
>>>>
>>>> which compiles to:
>>>> =C2=A0=C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>>>> =C2=A0=C2=A0 1:=C2=A0 call -0x1
>>>> =C2=A0=C2=A0 2:=C2=A0 exit
>>>>
>>>> The call will be marked as zext_dst set to true, and for some
>>>> backends
>>>> (bpf_jit_needs_zext() returns true) expanded to:
>>>> =C2=A0=C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>>>> =C2=A0=C2=A0 1:=C2=A0 call -0x1
>>>> =C2=A0=C2=A0 2:=C2=A0 w0 =3D w0
>>>> =C2=A0=C2=A0 3:=C2=A0 exit
>>>
>>> In the verifier, the marking is done by check_kfunc_call() (added in
>>> e6ac2450d6de), right? So the problem occurs only for kfuncs?
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* Check return type */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 t =3D btf_type_skip_mo=
difiers(desc_btf, func_proto->type, NULL);
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
>>>
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (btf_type_is_scalar=
(t)) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 mark_reg_unknown(env, regs, BPF_REG_0);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>>>
>>> I tried to find some official information whether the eBPF calling
>>> convention requires sign- or zero- extending return values and
>>> arguments, but unfortunately [1] doesn't mention this.
>>>
>>> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
>>> registers, but since assigning to W* leads to zero-extension, it seems
>>> to me that this is the case.
>>=20
>> We actually follow the clang convention, the zero-extension is either
>> done in caller or callee, but not both. See=20
>> https://reviews.llvm.org/D131598=C2=A0 how the convention could be chang=
ed.
>>=20
>> The following is an example.
>>=20
>> $ cat t.c
>> extern unsigned foo(void);
>> unsigned bar1(void) {
>>  =C2=A0=C2=A0=C2=A0 return foo();
>> }
>> unsigned bar2(void) {
>>  =C2=A0=C2=A0=C2=A0 if (foo()) return 10; else return 20;
>> }
>> $ clang -target bpf -mcpu=3Dv3 -O2 -c t.c && llvm-objdump -d t.o
>>=20
>> t.o:=C2=A0=C2=A0=C2=A0 file format elf64-bpf
>>=20
>> Disassembly of section .text:
>>=20
>> 0000000000000000 <bar1>:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 0:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 85 10 00 00 ff ff ff ff call -0x1
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 1:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 95 00 00 00 00 00 00 00 exit
>>=20
>> 0000000000000010 <bar2>:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 2:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 85 10 00 00 ff ff ff ff call -0x1
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 3:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 bc 01 00 00 00 00 00 00 w1 =3D w0
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 4:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 b4 00 00 00 14 00 00 00 w0 =3D 0x14
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 5:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 16 01 01 00 00 00 00 00 if w1 =3D=3D 0x0 goto +0x1 <LBB1_2>
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 6:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 b4 00 00 00 0a 00 00 00 w0 =3D 0xa
>>=20
>> 0000000000000038 <LBB1_2>:
>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 7:=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 95 00 00 00 00 00 00 00 exit
>> $
>>=20
>> If the return value of 'foo()' is actually used in the bpf program, the
>> proper zero extension will be done. Otherwise, it is not done.
>>=20
>> This is with latest llvm16. I guess we need to check llvm whether
>> we could enforce to add a w0 =3D w0 in bar1().
>>=20
>> Otherwise, with this patch, it will add w0 =3D w0 in all cases which
>> is not necessary in most of practical cases.
>>=20
>>>
>>> If the above is correct, then shouldn't we rather use sizeof(void *) in
>>> the mark_btf_func_reg_size() call above?
>>>
>>>> The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
>>>> the zext patching, relies on insn_def_regno() to fetch the register
>>>> to
>>>> zero-extend. However, this function does not handle call instructions
>>>> correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the
>>>> verification.
>>>>
>>>> Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
>>>> instructions.
>>>>
>>>> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in
>>>> insn_has_def32()")
>>>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>>>> ---
>>>> I'm not super happy about the additional special case -- first
>>>> cmpxchg, and now call. :-( A more elegant/generic solution is
>>>> welcome!
>>>> ---
>>>> =C2=A0=C2=A0kernel/bpf/verifier.c | 3 +++
>>>> =C2=A0=C2=A01 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>> index 264b3dc714cc..4f9660eafc72 100644
>>>> --- a/kernel/bpf/verifier.c
>>>> +++ b/kernel/bpf/verifier.c
>>>> @@ -13386,6 +13386,9 @@ static int
>>>> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!bpf_jit_needs_zext() && !is_cmpxchg_i=
nsn(&insn))
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0continue;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0if (insn.code =3D=3D (BPF_JMP | BPF_CALL))
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0load_r=
eg =3D BPF_REG_0;
>
> Want to double check. Do we actually have a problem here?
> For example, on x64, we probably won't have this issue.

The "problem" is that I hit this:
		if (WARN_ON(load_reg =3D=3D -1)) {
			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n");
			return -EFAULT;
		}

This path is only taken for archs which have bpf_jit_needs_zext() =3D=3D
true. In my case it's riscv64, but it should hit i386, sparc, s390, ppc,
mips, and arm.

My reading of this thread has been that "marking the call has
zext_dst=3Dtrue, is incorrect", i.e. that LLVM will insert the correct
zext instructions.

So, on way of not hitting this path, is what Ilya suggest -- in
check_kfunc_call():

  if (btf_type_is_scalar(t)) {
  	mark_reg_unknown(env, regs, BPF_REG_0);
  	mark_btf_func_reg_size(env, BPF_REG_0, t->size);
  }

change t->size to sizeof(u64). Then the call wont be marked.

>  >>>    ...
>  >>>    extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>  >>>
>  >>>    __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>  >>>    {
>  >>>            return tcp_reno_undo_cwnd(sk);
>  >>>    }
>
> The native code will return a 32-bit subreg to bpf program,
> and bpf didn't do anything and return r0 to the kernel func.
> In the kernel func, the kernel will take 32-bit subreg by
> x86_64 convention. This applies to some other return types
> like u8/s8/u16/s16/u32/s32.
>
> Which architecture you actually see the issue?

This is riscv64, but the nature of the problem is more of an assertion
failure, than codegen AFAIK.

I hit is when I load progs/bpf_cubic.o from the selftest. Nightly clang
from apt.llvm.org: clang version 16.0.0
(++20221204034339+7a194cfb327a-1~exp1~20221204154444.167)


Bj=C3=B6rn

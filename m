Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50538644AC1
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiLFSDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiLFSDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:03:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433F72BB11;
        Tue,  6 Dec 2022 10:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3D81B81AFB;
        Tue,  6 Dec 2022 18:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1058EC433D6;
        Tue,  6 Dec 2022 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670349781;
        bh=2JAY0I8Yke92H0rl3Spq8SaFxazboLLiSf1FZUBkq1k=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hytW3HmfSV2cBVl/7D54hGAYVAsAqrDfCRdP8K6+UpzYdzLcoMtZDaJcF3wPXIjUe
         uHAmTEyboirA+vVbP37Twq6whqRoIOQf5h0YElpIWYIIxQEMfSRpmnr1WIYM8i77mp
         Czzik94S1ja0g/vi/7CufNV78/EZ65XI2MTHmxwX/L7AzkXEDE299CXjCA8bNCOB4/
         jsuop4hFgUHjmGZXFLSRH3R9p8+AdBDJwZPkdFUEK0S4ObpCzP4Jn75WWLL3UqsaMW
         aiviUcUERrqP/RuUjzXDrMzrkHnQ3ORp+pVmOvBZGURjQc2DdIjblim4fung/ib9hQ
         5v0mkLnG/dFKg==
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
In-Reply-To: <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
 <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
Date:   Tue, 06 Dec 2022 19:02:58 +0100
Message-ID: <87o7sg1kbx.fsf@all.your.base.are.belong.to.us>
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

> On 12/6/22 5:21 AM, Ilya Leoshkevich wrote:
>> On Fri, 2022-12-02 at 11:36 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>>> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>>>
>>> A BPF call instruction can be, correctly, marked with zext_dst set to
>>> true. An example of this can be found in the BPF selftests
>>> progs/bpf_cubic.c:
>>>
>>>  =C2=A0 ...
>>>  =C2=A0 extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>>
>>>  =C2=A0 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>>  =C2=A0 {
>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tcp_reno=
_undo_cwnd(sk);
>>>  =C2=A0 }
>>>  =C2=A0 ...
>>>
>>> which compiles to:
>>>  =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>>>  =C2=A0 1:=C2=A0 call -0x1
>>>  =C2=A0 2:=C2=A0 exit
>>>
>>> The call will be marked as zext_dst set to true, and for some
>>> backends
>>> (bpf_jit_needs_zext() returns true) expanded to:
>>>  =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>>>  =C2=A0 1:=C2=A0 call -0x1
>>>  =C2=A0 2:=C2=A0 w0 =3D w0
>>>  =C2=A0 3:=C2=A0 exit
>>=20
>> In the verifier, the marking is done by check_kfunc_call() (added in
>> e6ac2450d6de), right? So the problem occurs only for kfuncs?
>>=20
>>          /* Check return type */
>>          t =3D btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
>>=20
>>          ...
>>=20
>>          if (btf_type_is_scalar(t)) {
>>                  mark_reg_unknown(env, regs, BPF_REG_0);
>>                  mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>>=20
>> I tried to find some official information whether the eBPF calling
>> convention requires sign- or zero- extending return values and
>> arguments, but unfortunately [1] doesn't mention this.
>>=20
>> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
>> registers, but since assigning to W* leads to zero-extension, it seems
>> to me that this is the case.
>
> We actually follow the clang convention, the zero-extension is either
> done in caller or callee, but not both. See=20
> https://reviews.llvm.org/D131598 how the convention could be changed.
>
> The following is an example.
>
> $ cat t.c
> extern unsigned foo(void);
> unsigned bar1(void) {
>      return foo();
> }
> unsigned bar2(void) {
>      if (foo()) return 10; else return 20;
> }
> $ clang -target bpf -mcpu=3Dv3 -O2 -c t.c && llvm-objdump -d t.o
>
> t.o:    file format elf64-bpf
>
> Disassembly of section .text:
>
> 0000000000000000 <bar1>:
>         0:       85 10 00 00 ff ff ff ff call -0x1
>         1:       95 00 00 00 00 00 00 00 exit
>
> 0000000000000010 <bar2>:
>         2:       85 10 00 00 ff ff ff ff call -0x1
>         3:       bc 01 00 00 00 00 00 00 w1 =3D w0
>         4:       b4 00 00 00 14 00 00 00 w0 =3D 0x14
>         5:       16 01 01 00 00 00 00 00 if w1 =3D=3D 0x0 goto +0x1 <LBB1=
_2>
>         6:       b4 00 00 00 0a 00 00 00 w0 =3D 0xa
>
> 0000000000000038 <LBB1_2>:
>         7:       95 00 00 00 00 00 00 00 exit
> $
>
> If the return value of 'foo()' is actually used in the bpf program, the
> proper zero extension will be done. Otherwise, it is not done.
>
> This is with latest llvm16. I guess we need to check llvm whether
> we could enforce to add a w0 =3D w0 in bar1().
>
> Otherwise, with this patch, it will add w0 =3D w0 in all cases which
> is not necessary in most of practical cases.

Thanks, Yonghong! So, what would the correct fix be? We don't want the
verifier to mark the call for zext_dst in my commit message example,
since the zext will be properly done by LLVM.

Wdyt about Ilya's suggestion marking R0 as 64b? That avoids hitting my
"verifier bug", but I'm not well versed enough in verifier land to say
whether that breaks something else... I.e. is setting reg->subreg_def to
DEF_NOT_SUBREG for R0 correct?

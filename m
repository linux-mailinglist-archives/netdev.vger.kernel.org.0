Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 768046444E9
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 14:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbiLFNtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 08:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232511AbiLFNtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 08:49:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4F1BCB1;
        Tue,  6 Dec 2022 05:49:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 36F676176D;
        Tue,  6 Dec 2022 13:49:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25883C433D6;
        Tue,  6 Dec 2022 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670334565;
        bh=qu2NW/pCbqvdSkQpAYjtcD2GsCPpzDNkBsC1GiYTkl8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ntGP+GW4w9vbKvqxWryIO/T4a7B4oqrqdwN4FxFZRlYKIqPpL35ikAOuzNKlBkCkc
         9+R8uRGBpcmgG2vc19rT4qo1qFxGLyA34afE6ELnfbXfTYPT1EnT1K7TmfC362Yd5k
         vGvPGmvyEq/bgUs0qzpTMCxR4oYONSYH0wPTQyBAezReNYeGd6KwKgaMzmfssqFERV
         8nVS5Z3L+OBqpDWr36cVk8NGk7ebq91y7MlUm6fwcU5j/KmQAbnxitirRDrFT8YgFK
         Vu6qZHF7NbM+vFyT2C0f/HYOnblvCPpf/H7W8OIL3Uq9hZdyvBc9wagVzzCdNLhfO1
         ybVVNOsvFE65g==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
In-Reply-To: <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
Date:   Tue, 06 Dec 2022 14:49:22 +0100
Message-ID: <87sfhs3an1.fsf@all.your.base.are.belong.to.us>
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

Ilya Leoshkevich <iii@linux.ibm.com> writes:

> On Fri, 2022-12-02 at 11:36 +0100, Bj=C3=B6rn T=C3=B6pel wrote:
>> From: Bj=C3=B6rn T=C3=B6pel <bjorn@rivosinc.com>
>>=20
>> A BPF call instruction can be, correctly, marked with zext_dst set to
>> true. An example of this can be found in the BPF selftests
>> progs/bpf_cubic.c:
>>=20
>> =C2=A0 ...
>> =C2=A0 extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>=20
>> =C2=A0 __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>> =C2=A0 {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return tcp_reno_u=
ndo_cwnd(sk);
>> =C2=A0 }
>> =C2=A0 ...
>>=20
>> which compiles to:
>> =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>> =C2=A0 1:=C2=A0 call -0x1
>> =C2=A0 2:=C2=A0 exit
>>=20
>> The call will be marked as zext_dst set to true, and for some
>> backends
>> (bpf_jit_needs_zext() returns true) expanded to:
>> =C2=A0 0:=C2=A0 r1 =3D *(u64 *)(r1 + 0x0)
>> =C2=A0 1:=C2=A0 call -0x1
>> =C2=A0 2:=C2=A0 w0 =3D w0
>> =C2=A0 3:=C2=A0 exit
>
> In the verifier, the marking is done by check_kfunc_call() (added in
> e6ac2450d6de), right? So the problem occurs only for kfuncs?

I've only seen it for kfuncs, yes.

>
>         /* Check return type */
>         t =3D btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
>
>         ...
>
>         if (btf_type_is_scalar(t)) {
>                 mark_reg_unknown(env, regs, BPF_REG_0);
>                 mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>
> I tried to find some official information whether the eBPF calling
> convention requires sign- or zero- extending return values and
> arguments, but unfortunately [1] doesn't mention this.
>
> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
> registers, but since assigning to W* leads to zero-extension, it seems
> to me that this is the case.
>
> If the above is correct, then shouldn't we rather use sizeof(void *) in
> the mark_btf_func_reg_size() call above?

Hmm, or rather sizeof(u64) if I'm reading you correctly?


Thanks for having a look!
Bj=C3=B6rn

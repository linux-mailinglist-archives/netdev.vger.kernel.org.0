Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8920645466
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 08:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229661AbiLGHLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 02:11:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiLGHK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 02:10:57 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2E42A25C;
        Tue,  6 Dec 2022 23:10:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 836D9CE0E76;
        Wed,  7 Dec 2022 07:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3558CC433C1;
        Wed,  7 Dec 2022 07:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670397052;
        bh=amS9oEo0HeTqK7LmZ7Ty216uHQ4HJbHJB3WpUsAOqQc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OiFq9hyIg+TeoBIFZaZm5kAo8OxNK5FiPjVZ1VAFUxhC0FyfpxyEpeclnOz6RukkS
         x/yqSNAGCQPYTTVJT6voDR/cxZagzGp8JRV/z0mlJFrYVWXHELqNuelTQO6uxUbudV
         66MwSbMB5AsH3j8nGfjiHhc2ZkiZ4NG3Yw2gs1n7hVAoDpUX/YwCboUMa55hglV3xZ
         xHaeSqu3Ol7seyyrQRoiAawSK/oMevZFVreip5G0DOpxRYJzaWs/kW2jr1WDRFIbWu
         8Gt2lzgBno+xm4cGpTGLaImZk5o6C6Kw1yIaNjXd3rtgH5L4bEp/rYvDm43Vri6gwG
         H2Niq0fyUWfDA==
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
In-Reply-To: <cd7a6e8d-2de1-d5a0-cf4a-09188f01fa7e@meta.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
 <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
 <9af1b919-ea15-e44c-b9cc-765c743dd617@meta.com>
 <87v8mos7gw.fsf@all.your.base.are.belong.to.us>
 <cd7a6e8d-2de1-d5a0-cf4a-09188f01fa7e@meta.com>
Date:   Wed, 07 Dec 2022 08:10:49 +0100
Message-ID: <878rjjn0xy.fsf@all.your.base.are.belong.to.us>
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

>>>>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>>>>> index 264b3dc714cc..4f9660eafc72 100644
>>>>>> --- a/kernel/bpf/verifier.c
>>>>>> +++ b/kernel/bpf/verifier.c
>>>>>> @@ -13386,6 +13386,9 @@ static int
>>>>>> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!bpf_jit_needs_zext() && !is_cmpxch=
g_insn(&insn))
>>>>>>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0continue;
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0if (insn.code =3D=3D (BPF_JMP | BPF_CALL))
>>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0loa=
d_reg =3D BPF_REG_0;
>>>
>>> Want to double check. Do we actually have a problem here?
>>> For example, on x64, we probably won't have this issue.
>>=20
>> The "problem" is that I hit this:
>> 		if (WARN_ON(load_reg =3D=3D -1)) {
>> 			verbose(env, "verifier bug. zext_dst is set, but no reg is defined\n"=
);
>> 			return -EFAULT;
>> 		}
>>=20
>> This path is only taken for archs which have bpf_jit_needs_zext() =3D=3D
>> true. In my case it's riscv64, but it should hit i386, sparc, s390, ppc,
>> mips, and arm.
>>=20
>> My reading of this thread has been that "marking the call has
>> zext_dst=3Dtrue, is incorrect", i.e. that LLVM will insert the correct
>> zext instructions.
>
> Your interpretation is correct. Yes, for func return values, the
> llvm will insert correct zext/sext instructions if the return
> value is used. Otherwise, if the return value simply passes
> through, the caller call site should handle that properly.
>
> So, yes changing t->size to sizeof(u64) in below code in
> check_kfunc_call() should work. But the fix sounds like a hack
> and we might have some side effect during verification, now
> or future.
>
> Maybe we could check BPF_PSEUDO_KFUNC_CALL in appropriate place to=20
> prevent zext.

Thanks for all the input! I'll digest it, and get back with a v2.

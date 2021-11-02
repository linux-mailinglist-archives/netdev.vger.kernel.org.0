Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA374442F4F
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 14:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhKBNuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 09:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbhKBNun (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 09:50:43 -0400
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE26C061714;
        Tue,  2 Nov 2021 06:48:08 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HkB796FKqz4xbd;
        Wed,  3 Nov 2021 00:48:05 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1635860886;
        bh=BXsWrBorknGmHfDZYTQq6a8lqYf7TkEi2iiyehPn3Q4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LY2Qlq49JuSlQEWtKEO0vu6ZSVqEzq2uEGfLAJfHz94UdsNi5LaKp1eXCtoQ8p51Z
         8CyEccP/WN2VLSRPzFYzfqdw+YEsW4zPPKbIpXN1JpBNREdwoqdYDhDVbgtXSiAcCE
         1o6qP3TuH5bR4AzwJCPjAnKqT/tTcg8EMJLW8GV7wy3pdJhDeENInI8nS4K08Y+3Yu
         l1yZBjRtup3I9D/TIimuMz+fWP8UaMptjzPaiT4mV+ZuKlbChiIcQv5sO/1AqVVWxS
         scxhuLolZpHNsYFN0etrP/QORG0pFm4znGV5JvnwtFSMXnzz78eUJXkHj/P4T7URHG
         PVnmDdxc2HxUw==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, ast@kernel.org,
        christophe.leroy@csgroup.eu,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hari Bathini <hbathini@linux.ibm.com>, jniethe5@gmail.com
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        stable@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
In-Reply-To: <1635854227.x13v13l6az.naveen@linux.ibm.com>
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
 <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
 <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
 <87zgqs8upq.fsf@mpe.ellerman.id.au>
 <1635854227.x13v13l6az.naveen@linux.ibm.com>
Date:   Wed, 03 Nov 2021 00:48:03 +1100
Message-ID: <87h7cu8y98.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Naveen N. Rao" <naveen.n.rao@linux.ibm.com> writes:
> Michael Ellerman wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 10/25/21 8:15 AM, Naveen N. Rao wrote:
>>>> Hari Bathini wrote:
>>>>> Running program with bpf-to-bpf function calls results in data access
>>>>> exception (0x300) with the below call trace:
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0 [c000000000113f28] bpf_int_jit_compile+0x238/0x750=
 (unreliable)
>>>>> =C2=A0=C2=A0=C2=A0 [c00000000037d2f8] bpf_check+0x2008/0x2710
>>>>> =C2=A0=C2=A0=C2=A0 [c000000000360050] bpf_prog_load+0xb00/0x13a0
>>>>> =C2=A0=C2=A0=C2=A0 [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>>>>> =C2=A0=C2=A0=C2=A0 [c000000000363f0c] sys_bpf+0x2c/0x40
>>>>> =C2=A0=C2=A0=C2=A0 [c000000000032434] system_call_exception+0x164/0x3=
30
>>>>> =C2=A0=C2=A0=C2=A0 [c00000000000c1e8] system_call_vectored_common+0xe=
8/0x278
>>>>>
>>>>> as bpf_int_jit_compile() tries writing to write protected JIT code
>>>>> location during the extra pass.
>>>>>
>>>>> Fix it by holding off write protection of JIT code until the extra
>>>>> pass, where branch target addresses fixup happens.
>>>>>
>>>>> Cc: stable@vger.kernel.org
>>>>> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
>>>>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>>>>> ---
>>>>> =C2=A0arch/powerpc/net/bpf_jit_comp.c | 2 +-
>>>>> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>> Thanks for the fix!
>>>>=20
>>>> Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>>>
>>> LGTM, I presume this fix will be routed via Michael.
>>=20
>> Thanks for reviewing, I've picked it up.
>>=20
>>> BPF selftests have plenty of BPF-to-BPF calls in there, too bad this was
>>> caught so late. :/
>>=20
>> Yeah :/
>>=20
>> STRICT_KERNEL_RWX is not on by default in all our defconfigs, so that's
>> probably why no one caught it.
>
> Yeah, sorry - we should have caught this sooner.
>
>>=20
>> I used to run the BPF selftests but they stopped building for me a while
>> back, I'll see if I can get them going again.
>
> Ravi had started looking into getting the selftests working well before=20
> he left. I will take a look at this.

Thanks.

I got them building with something like:

 - turning on DEBUG_INFO and DEBUG_INFO_BTF and rebuilding vmlinux
 - grabbing clang 13 from:=20
   https://github.com/llvm/llvm-project/releases/download/llvmorg-13.0.0/cl=
ang+llvm-13.0.0-powerpc64le-linux-ubuntu-18.04.tar.xz
 - PATH=3D$HOME/clang+llvm-13.0.0-powerpc64le-linux-ubuntu-18.04/bin/:$PATH
 - apt install:
   - libelf-dev
   - dwarves
   - python-docutils
   - libcap-dev


The DEBUG_INFO requirement is a bit of a pain for me. I generally don't
build with that enabled, because the resulting kernels are stupidly
large. I'm not sure if that's a hard requirement, or if the vmlinux has
to match the running kernel exactly?

There is logic in tools/testing/bpf/Makefile to use VMLINUX_H instead of
extracting the BTF from the vmlinux (line 247), but AFAICS that's
unreachable since 1a3449c19407 ("selftests/bpf: Clarify build error if
no vmlinux"), which makes it a hard error to not have a VMLINUX_BTF.

cheers

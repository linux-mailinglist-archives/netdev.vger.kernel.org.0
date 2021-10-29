Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D9D43F4A3
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhJ2Bxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:53:33 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:57019 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231468AbhJ2Bxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 21:53:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HgQPd6QCNz4xYy;
        Fri, 29 Oct 2021 12:51:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1635472263;
        bh=wmANmsRuASHCQHaz7QWRHhQxlaXvm3wDVWXitsA8xxU=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=k7nE+Vbr2pEF9UfeAQQyh6z/iW03s/mt4EHnKSFFZz+hBUwgB7/+sPbL+UUzYvwXL
         4CYAcfWnYSocPoFgg9P7z6JzggGChqSkAQPC+K32pOqPYoWhLSTFkPL6GjnSr+mnfz
         mS5crCCfBHTU6SJu4PYXO/lfxwq3ULO/dkgV2gF8VtVR4fDzIGx/FDwuGiiabyOHDn
         B9RQREbhSyeeLdZQpfW39tNzqBTpCztnGXaF4WqOoWB/opPbpsZOOuCRRLxgkEKwqZ
         SmNj9iAB1JPPl0zZxl3KqEOVE+9Hz/gyuerIyCTYFzMrPWwEyXdHF3mGoz82LyadCD
         EFatR9mT4aA1A==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, ast@kernel.org,
        christophe.leroy@csgroup.eu, Hari Bathini <hbathini@linux.ibm.com>,
        jniethe5@gmail.com
Cc:     andrii@kernel.org, bpf@vger.kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, paulus@samba.org, songliubraving@fb.com,
        stable@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH] powerpc/bpf: fix write protecting JIT code
In-Reply-To: <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
References: <20211025055649.114728-1-hbathini@linux.ibm.com>
 <1635142354.46h6w5c2rx.naveen@linux.ibm.com>
 <c8d7390b-c07c-75cd-e9e9-4b8f0b786cc6@iogearbox.net>
Date:   Fri, 29 Oct 2021 12:50:57 +1100
Message-ID: <87zgqs8upq.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:
> On 10/25/21 8:15 AM, Naveen N. Rao wrote:
>> Hari Bathini wrote:
>>> Running program with bpf-to-bpf function calls results in data access
>>> exception (0x300) with the below call trace:
>>>
>>> =C2=A0=C2=A0=C2=A0 [c000000000113f28] bpf_int_jit_compile+0x238/0x750 (=
unreliable)
>>> =C2=A0=C2=A0=C2=A0 [c00000000037d2f8] bpf_check+0x2008/0x2710
>>> =C2=A0=C2=A0=C2=A0 [c000000000360050] bpf_prog_load+0xb00/0x13a0
>>> =C2=A0=C2=A0=C2=A0 [c000000000361d94] __sys_bpf+0x6f4/0x27c0
>>> =C2=A0=C2=A0=C2=A0 [c000000000363f0c] sys_bpf+0x2c/0x40
>>> =C2=A0=C2=A0=C2=A0 [c000000000032434] system_call_exception+0x164/0x330
>>> =C2=A0=C2=A0=C2=A0 [c00000000000c1e8] system_call_vectored_common+0xe8/=
0x278
>>>
>>> as bpf_int_jit_compile() tries writing to write protected JIT code
>>> location during the extra pass.
>>>
>>> Fix it by holding off write protection of JIT code until the extra
>>> pass, where branch target addresses fixup happens.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 62e3d4210ac9 ("powerpc/bpf: Write protect JIT code")
>>> Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
>>> ---
>>> =C2=A0arch/powerpc/net/bpf_jit_comp.c | 2 +-
>>> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> Thanks for the fix!
>>=20
>> Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>
> LGTM, I presume this fix will be routed via Michael.

Thanks for reviewing, I've picked it up.

> BPF selftests have plenty of BPF-to-BPF calls in there, too bad this was
> caught so late. :/

Yeah :/

STRICT_KERNEL_RWX is not on by default in all our defconfigs, so that's
probably why no one caught it.

I used to run the BPF selftests but they stopped building for me a while
back, I'll see if I can get them going again.

cheers

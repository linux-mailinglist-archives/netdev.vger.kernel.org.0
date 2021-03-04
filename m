Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E1CF32C9C3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 02:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243283AbhCDBMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 20:12:08 -0500
Received: from bilbo.ozlabs.org ([203.11.71.1]:46929 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1453119AbhCDArP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 19:47:15 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DrXHX3dp2z9sSC;
        Thu,  4 Mar 2021 11:46:32 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1614818794;
        bh=OH1sKh2gaP7xqDkoSA802zvVl40HMC4Ik/IUhwyjuvA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=MK78aETaToPntuLGqvzzuER5nYs5PpfsVydxpsuYzwQB5rE41h7Atd5UUTMgT8dpm
         kV2bt9yqbuJ/U8f2sAtwMnh5rJmHIRVGfF7YMD+n1NnaDPvTZF/2BCX2nvGxFysPUp
         37zgJkXybHUr6H6JsRG4WnOO3bYGhqwxnBt5M8FJ5gndSCZU3OJA5dABo4BlacuIal
         5VSsCDbuLGnnPQ3VUqnZ4wu1VRPLuk7BbOo9JDW1cUVZUvBbkO5y2tNobJzhIFrLdD
         mIM/1tO1bwH0Gu4s/+hGBxJVnKrcq+VCKgitcJSkT2p1gYOWuuiKbjKhkSlwsWMCNT
         7FnQUwJ+IYeng==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
In-Reply-To: <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com> <YD4U1x2SbTlJF2QU@krava>
 <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
Date:   Thu, 04 Mar 2021 11:46:27 +1100
Message-ID: <87blbzsq3g.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
> On 2021/03/02 11:35AM, Jiri Olsa wrote:
>> On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
>> > 
>> > 
>> > On 3/1/21 11:04 AM, Jiri Olsa wrote:
>> > > When testing uprobes we the test gets GEP (Global Entry Point)
>> > > address from kallsyms, but then the function is called locally
>> > > so the uprobe is not triggered.
>> > > 
>> > > Fixing this by adjusting the address to LEP (Local Entry Point)
>> > > for powerpc arch.
>> > > 
>> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
>> > > ---
>> > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
>> > >   1 file changed, 17 insertions(+), 1 deletion(-)
>> > > 
>> > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>> > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
>> > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>> > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
>> > > @@ -2,6 +2,22 @@
>> > >   #include <test_progs.h>
>> > >   #include "test_attach_probe.skel.h"
>> > > +#if defined(__powerpc64__)
>
> This needs to be specific to ELF v2 ABI, so you'll need to check 
> _CALL_ELF. See commit d5c2e2c17ae1d6 ("perf probe ppc64le: Prefer symbol 
> table lookup over DWARF") for an example.
>
>> > > +/*
>> > > + * We get the GEP (Global Entry Point) address from kallsyms,
>> > > + * but then the function is called locally, so we need to adjust
>> > > + * the address to get LEP (Local Entry Point).
>> > 
>> > Any documentation in the kernel about this behavior? This will
>> > help to validate the change without trying with powerpc64 qemu...
>
> I don't think we have documented this in the kernel anywhere, but this 
> is specific to the ELF v2 ABI and is described there:
> - 2.3.2.1.  Function Prologue: 
>   http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240___RefHeading___Toc377640597.html
> - 3.4.1.  Symbol Values:
>    http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655241_95185.html

There's a comment in ppc_function_entry(), but I don't think we have any
actual "documentation".

static inline unsigned long ppc_function_entry(void *func)
{
#ifdef PPC64_ELF_ABI_v2
	u32 *insn = func;

	/*
	 * A PPC64 ABIv2 function may have a local and a global entry
	 * point. We need to use the local entry point when patching
	 * functions, so identify and step over the global entry point
	 * sequence.
	 *
	 * The global entry point sequence is always of the form:
	 *
	 * addis r2,r12,XXXX
	 * addi  r2,r2,XXXX
	 *
	 * A linker optimisation may convert the addis to lis:
	 *
	 * lis   r2,XXXX
	 * addi  r2,r2,XXXX
	 */
	if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
	     ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
	    ((*(insn+1) & OP_RT_RA_MASK) == ADDI_R2_R2))
		return (unsigned long)(insn + 2);
	else
		return (unsigned long)func;


cheers

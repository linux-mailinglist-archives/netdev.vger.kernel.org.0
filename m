Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670832D73B
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 16:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhCDP5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 10:57:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53464 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236084AbhCDP5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 10:57:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614873342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DuOB6duBWZGariFrKnkAhJfFFwD23vFUlv/jyNsccB8=;
        b=VtO5OtE9SXj3G3DrSFeIchP2Sc2NlQdJ7mfsiFLnXSYOS8Jn4zm9EItEo+Ro6NmkF+KHSb
        VD+FzYb9fRAudgONcHtp5+lcKaXFABbdhOoQKnui3PVHh/P9EkctpwrzheBzDuHwtvBpcA
        UmumSi2n/mpE/NFRqLjNCB4ZxYrNWmo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-492-oM8AeszRNmOX6Q2hZ7KUpQ-1; Thu, 04 Mar 2021 10:55:40 -0500
X-MC-Unique: oM8AeszRNmOX6Q2hZ7KUpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C124E1018F77;
        Thu,  4 Mar 2021 15:55:37 +0000 (UTC)
Received: from krava (unknown [10.40.196.20])
        by smtp.corp.redhat.com (Postfix) with SMTP id 09A6A5D71B;
        Thu,  4 Mar 2021 15:55:29 +0000 (UTC)
Date:   Thu, 4 Mar 2021 16:55:28 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Yonghong Song <yhs@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe for
 powerpc uprobes
Message-ID: <YEEC8EiOiBaFhqxF@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
 <YD4U1x2SbTlJF2QU@krava>
 <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
 <87blbzsq3g.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blbzsq3g.fsf@mpe.ellerman.id.au>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 11:46:27AM +1100, Michael Ellerman wrote:
> "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com> writes:
> > On 2021/03/02 11:35AM, Jiri Olsa wrote:
> >> On Mon, Mar 01, 2021 at 02:58:53PM -0800, Yonghong Song wrote:
> >> > 
> >> > 
> >> > On 3/1/21 11:04 AM, Jiri Olsa wrote:
> >> > > When testing uprobes we the test gets GEP (Global Entry Point)
> >> > > address from kallsyms, but then the function is called locally
> >> > > so the uprobe is not triggered.
> >> > > 
> >> > > Fixing this by adjusting the address to LEP (Local Entry Point)
> >> > > for powerpc arch.
> >> > > 
> >> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> >> > > ---
> >> > >   .../selftests/bpf/prog_tests/attach_probe.c    | 18 +++++++++++++++++-
> >> > >   1 file changed, 17 insertions(+), 1 deletion(-)
> >> > > 
> >> > > diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> >> > > index a0ee87c8e1ea..c3cfb48d3ed0 100644
> >> > > --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> >> > > +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> >> > > @@ -2,6 +2,22 @@
> >> > >   #include <test_progs.h>
> >> > >   #include "test_attach_probe.skel.h"
> >> > > +#if defined(__powerpc64__)
> >
> > This needs to be specific to ELF v2 ABI, so you'll need to check 
> > _CALL_ELF. See commit d5c2e2c17ae1d6 ("perf probe ppc64le: Prefer symbol 
> > table lookup over DWARF") for an example.
> >
> >> > > +/*
> >> > > + * We get the GEP (Global Entry Point) address from kallsyms,
> >> > > + * but then the function is called locally, so we need to adjust
> >> > > + * the address to get LEP (Local Entry Point).
> >> > 
> >> > Any documentation in the kernel about this behavior? This will
> >> > help to validate the change without trying with powerpc64 qemu...
> >
> > I don't think we have documented this in the kernel anywhere, but this 
> > is specific to the ELF v2 ABI and is described there:
> > - 2.3.2.1.  Function Prologue: 
> >   http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655240___RefHeading___Toc377640597.html
> > - 3.4.1.  Symbol Values:
> >    http://cdn.openpowerfoundation.org/wp-content/uploads/resources/leabi/content/dbdoclet.50655241_95185.html
> 
> There's a comment in ppc_function_entry(), but I don't think we have any
> actual "documentation".
> 
> static inline unsigned long ppc_function_entry(void *func)
> {
> #ifdef PPC64_ELF_ABI_v2
> 	u32 *insn = func;
> 
> 	/*
> 	 * A PPC64 ABIv2 function may have a local and a global entry
> 	 * point. We need to use the local entry point when patching
> 	 * functions, so identify and step over the global entry point
> 	 * sequence.

hm, so I need to do the instructions check below as well

> 	 *
> 	 * The global entry point sequence is always of the form:
> 	 *
> 	 * addis r2,r12,XXXX
> 	 * addi  r2,r2,XXXX
> 	 *
> 	 * A linker optimisation may convert the addis to lis:
> 	 *
> 	 * lis   r2,XXXX
> 	 * addi  r2,r2,XXXX
> 	 */
> 	if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
> 	     ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
> 	    ((*(insn+1) & OP_RT_RA_MASK) == ADDI_R2_R2))

is this check/instructions specific to kernel code?

In the test prog I see following instructions:

Dump of assembler code for function get_base_addr:
   0x0000000010034cb0 <+0>:     lis     r2,4256
   0x0000000010034cb4 <+4>:     addi    r2,r2,31488
   ...

but first instruction does not match the check in kernel code above:

	1.insn value:	0x3c4010a0
	2.insn value:	0x38427b00

the used defines are:
	#define OP_RT_RA_MASK   0xffff0000UL
	#define LIS_R2          0x3c020000UL
	#define ADDIS_R2_R12    0x3c4c0000UL
	#define ADDI_R2_R2      0x38420000UL


maybe we could skip the check, and run the test twice: first on
kallsym address and if the uprobe is not hit we will run it again
on address + 8

thanks,
jirka

> 		return (unsigned long)(insn + 2);
> 	else
> 		return (unsigned long)func;
> 
> 
> cheers
> 


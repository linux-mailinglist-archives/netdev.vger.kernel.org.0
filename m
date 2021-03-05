Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D99D32EC61
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 14:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbhCENj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 08:39:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30853 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230468AbhCENjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 08:39:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614951551;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=POZEtjl6d0SgOm6zoVhNtpERGrD7iyxEUNCPA7FIEsM=;
        b=AvHnWeHuZHlZY45okrXIO5W2CNM34zfYyytp26BV+gVcUdTtZ8O+0B8ZkCeErXPKCo/vwc
        x68SCdw+SAP4Ind23nT0AVcGu52E65shHBxR4hK3zEhg8JNUnnxWO5phD1Nzl1qIQEaXyp
        5g88wpjzSdLJRsiUb2qnC9oiZD4wV3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509--fLQ0ZTOOPyo6kgzriODtA-1; Fri, 05 Mar 2021 08:39:10 -0500
X-MC-Unique: -fLQ0ZTOOPyo6kgzriODtA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D53992686A;
        Fri,  5 Mar 2021 13:39:07 +0000 (UTC)
Received: from krava (unknown [10.40.196.10])
        by smtp.corp.redhat.com (Postfix) with SMTP id C6DE919CB0;
        Fri,  5 Mar 2021 13:38:59 +0000 (UTC)
Date:   Fri, 5 Mar 2021 14:38:58 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Michael Ellerman <mpe@ellerman.id.au>, Yonghong Song <yhs@fb.com>,
        Jiri Olsa <jolsa@kernel.org>,
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
Message-ID: <YEI0cptuDzUUOaLr@krava>
References: <20210301190416.90694-1-jolsa@kernel.org>
 <309d8d05-4bbd-56b8-6c05-12a1aa98b843@fb.com>
 <YD4U1x2SbTlJF2QU@krava>
 <20210303064043.GB1913@DESKTOP-TDPLP67.localdomain>
 <87blbzsq3g.fsf@mpe.ellerman.id.au>
 <YEEC8EiOiBaFhqxF@krava>
 <20210304013459.GG1913@DESKTOP-TDPLP67.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304013459.GG1913@DESKTOP-TDPLP67.localdomain>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 04, 2021 at 07:04:59AM +0530, Naveen N. Rao wrote:

SNIP

> > > static inline unsigned long ppc_function_entry(void *func)
> > > {
> > > #ifdef PPC64_ELF_ABI_v2
> > > 	u32 *insn = func;
> > > 
> > > 	/*
> > > 	 * A PPC64 ABIv2 function may have a local and a global entry
> > > 	 * point. We need to use the local entry point when patching
> > > 	 * functions, so identify and step over the global entry point
> > > 	 * sequence.
> > 
> > hm, so I need to do the instructions check below as well
> 
> It's a good check, but probably not necessary. In most functions, we 
> expect to be able to probe two instructions later without much of a 
> change to affect function tracing for userspace. For this reason, we 
> just probe at an offset of 8 as a reasonable fallback.
> 
> It is definetely good if we can come up with a better approach though.
> 
> > 
> > > 	 *
> > > 	 * The global entry point sequence is always of the form:
> > > 	 *
> > > 	 * addis r2,r12,XXXX
> > > 	 * addi  r2,r2,XXXX
> > > 	 *
> > > 	 * A linker optimisation may convert the addis to lis:
> > > 	 *
> > > 	 * lis   r2,XXXX
> > > 	 * addi  r2,r2,XXXX
> > > 	 */
> > > 	if ((((*insn & OP_RT_RA_MASK) == ADDIS_R2_R12) ||
> > > 	     ((*insn & OP_RT_RA_MASK) == LIS_R2)) &&
> > > 	    ((*(insn+1) & OP_RT_RA_MASK) == ADDI_R2_R2))
> > 
> > is this check/instructions specific to kernel code?
> > 
> > In the test prog I see following instructions:
> > 
> > Dump of assembler code for function get_base_addr:
> >    0x0000000010034cb0 <+0>:     lis     r2,4256
> >    0x0000000010034cb4 <+4>:     addi    r2,r2,31488
> >    ...
> > 
> > but first instruction does not match the check in kernel code above:
> > 
> > 	1.insn value:	0x3c4010a0
> > 	2.insn value:	0x38427b00
> > 
> > the used defines are:
> > 	#define OP_RT_RA_MASK   0xffff0000UL
> > 	#define LIS_R2          0x3c020000UL
> > 	#define ADDIS_R2_R12    0x3c4c0000UL
> > 	#define ADDI_R2_R2      0x38420000UL
> 
> Good catch! That's wrong, and I suspect we haven't noticed since kernel 
> almost always ends up using the addis variant. I will send a fix for 
> this.

the new macro value from your fix works for the test,
so I'll use it in v2, so we don't just blindly go to
+8 offset.. I'll send it out shortly

> 
> > 
> > 
> > maybe we could skip the check, and run the test twice: first on
> > kallsym address and if the uprobe is not hit we will run it again
> > on address + 8
> 
> Sure, like I mentioned, I'm fine with any approach. Offset'ing into the 
> function by 8 is easy and generally works. Re-trying is fine too. The 
> proper approach will requires us to consult the symbol table and check 
> st_other field [see commit 0b3c2264ae30ed ("perf symbols: Fix kallsyms 
> perf test on ppc64le")]

I think we don't want to complicate this test with symbol table
check. I'll propose the fix with the extra instructions check
for now and we can add symbol table check in future if it's not
enough

thanks for all the info,
jirka

> 
> Thanks,
> - Naveen
> 


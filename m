Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8C2E1CA9EC
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 13:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgEHLrR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 07:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgEHLrR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 07:47:17 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AF1C208DB;
        Fri,  8 May 2020 11:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588938436;
        bh=t1Iwu24XFt/a9NpFSyEL3vQir1AT95eNfYgPSI3dRXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fbr0ksTlgIL5FTsuoGevS/1Dfx/6oKLeeINEHrjnfmHHcaDmHd5vjhSs6V/18OxQl
         d87ngXBx/xymM9BE8xEn5y929HYpCE0cwOKixvFuxVhneks1P992dmKU3twX75N40j
         S/0gFC6NylCeiDyMUntAk0xuU23GFqIAXLPGpZOc=
Date:   Fri, 8 May 2020 12:47:10 +0100
From:   Will Deacon <will@kernel.org>
To:     Luke Nelson <luke.r.nels@gmail.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Luke Nelson <lukenels@cs.washington.edu>,
        bpf <bpf@vger.kernel.org>, Xi Wang <xi.wang@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Subject: Re: [RFC PATCH bpf-next 1/3] arm64: insn: Fix two bugs in encoding
 32-bit logical immediates
Message-ID: <20200508114709.GB16247@willie-the-truck>
References: <20200507010504.26352-1-luke.r.nels@gmail.com>
 <20200507010504.26352-2-luke.r.nels@gmail.com>
 <20200507082934.GA28215@willie-the-truck>
 <20200507101224.33a44d71@why>
 <CAB-e3NRCJ_4+vkFPkMN67DwBBtO=sJwR-oL4-AozVw2bBJHOzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB-e3NRCJ_4+vkFPkMN67DwBBtO=sJwR-oL4-AozVw2bBJHOzg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 02:48:07PM -0700, Luke Nelson wrote:
> Thanks for the comments! Responses below:
> 
> > It's a bit grotty spreading the checks out now. How about we tweak things
> > slightly along the lines of:
> >
> >
> > diff --git a/arch/arm64/kernel/insn.c b/arch/arm64/kernel/insn.c
> > index 4a9e773a177f..60ec788eaf33 100644
> > --- a/arch/arm64/kernel/insn.c
> > +++ b/arch/arm64/kernel/insn.c
> > [...]
> 
> Agreed; this new version looks much cleaner. I re-ran all the tests /
> verification and everything seems good. Would you like me to submit a
> v2 of this series with this new code?

Yes, please! And please include Daniel's acks on the BPF changes too. It's a
public holiday here in the UK today, but I can pick this up next week.

> >> We tested the new code against llvm-mc with all 1,302 encodable 32-bit
> >> logical immediates and all 5,334 encodable 64-bit logical immediates.
> >
> > That, on its own, is awesome information. Do you have any pointer on
> > how to set this up?
> 
> Sure! The process of running the tests is pretty involved, but I'll
> describe it below and give some links here.
> 
> We found the bugs in insn.c while adding support for logical immediates
> to the BPF JIT and verifying the changes with our tool, Serval:
> https://github.com/uw-unsat/serval-bpf. The basic idea for how we tested /
> verified logical immediates is the following:
> 
> First, we have a Python script [1] for generating every encodable
> logical immediate and the corresponding instruction fields that encode
> that immediate. The script validates the list by checking that llvm-mc
> decodes each instruction back to the expected immediate.
> 
> Next, we use the list [2] from the first step to check a Racket
> translation [3] of the logical immediate encoding function in insn.c.
> We found the second mask bug by noticing that some (encodable) 32-bit
> immediates were being rejected by the encoding function.
> 
> Last, we use the Racket translation of the encoding function to verify
> the correctness of the BPF JIT implementation [4], i.e., the JIT
> correctly compiles BPF_{AND,OR,XOR,JSET} BPF_K instructions to arm64
> instructions with equivalent semantics. We found the first bug as the
> verifier complained that the function was producing invalid encodings
> for 32-bit -1 immediates, and we were able to reproduce a kernel crash
> using the BPF tests.
> 
> We manually translated the C code to Racket because our verifier, Serval,
> currently only works on Racket code.

Nice! Two things:

(1) I really think you should give a talk on this at a Linux conference
(2) Did you look at any instruction generation functions other than the
    logical immediate encoding function?

Cheers,

Will

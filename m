Return-Path: <netdev+bounces-11689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E5F8733ED4
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 08:52:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF0701C20FBE
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 06:52:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10745231;
	Sat, 17 Jun 2023 06:51:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A002E0EA;
	Sat, 17 Jun 2023 06:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F5A2C433C0;
	Sat, 17 Jun 2023 06:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686984717;
	bh=/qKKDaoSMPytALuHQ04GytBWLf/bqmvRcK74ppFE2a8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P0RFez1EfGYRPTyev/ddBuUzPfaI7NYAV3qwPAYDnlRPd3VlORPb9LLwAJNsB7HOD
	 XaTNoL/vc3WgcVwGzmW11kDKJAUwiH+6/aq1FZDc7+GKKGRDNnH6fEazV3xviU4Xdu
	 C+/q5uFaTCGSUOqz7wG3tCyqcwsxuFowQGM9EqAXvug3eByaI82gwGU/LAA7W+0x7N
	 lIyzQgQ47UaYju+tMMa6eYibyB5m2xJlH6icNOvjTXhyI/Ih1KbRLoHwZvr/gyzXyu
	 vOgqeIZZrqb6yw/imXyF8xZATseZuyfjlfKJVafWUrfVejHNNcMI379QODomewks5q
	 shTjXZO35vEXQ==
Date: Sat, 17 Jun 2023 09:51:11 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Song Liu <song@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nadav Amit <nadav.amit@gmail.com>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Puranjay Mohan <puranjay12@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Russell King <linux@armlinux.org.uk>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 06/12] mm/execmem: introduce execmem_data_alloc()
Message-ID: <20230617065111.GR52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-7-rppt@kernel.org>
 <CAPhsuW4J+rFvh9WJVWLZxFHtcYxahYk=NoKYdU9FMibZU8986w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPhsuW4J+rFvh9WJVWLZxFHtcYxahYk=NoKYdU9FMibZU8986w@mail.gmail.com>

On Fri, Jun 16, 2023 at 01:01:08PM -0700, Song Liu wrote:
> On Fri, Jun 16, 2023 at 1:51 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> >
> > Data related to code allocations, such as module data section, need to
> > comply with architecture constraints for its placement and its
> > allocation right now was done using execmem_text_alloc().
> >
> > Create a dedicated API for allocating data related to code allocations
> > and allow architectures to define address ranges for data allocations.
> >
> > Since currently this is only relevant for powerpc variants that use the
> > VMALLOC address space for module data allocations, automatically reuse
> > address ranges defined for text unless address range for data is
> > explicitly defined by an architecture.
> >
> > With separation of code and data allocations, data sections of the
> > modules are now mapped as PAGE_KERNEL rather than PAGE_KERNEL_EXEC which
> > was a default on many architectures.
> >
> > Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> [...]
> >  static void free_mod_mem(struct module *mod)
> > diff --git a/mm/execmem.c b/mm/execmem.c
> > index a67acd75ffef..f7bf496ad4c3 100644
> > --- a/mm/execmem.c
> > +++ b/mm/execmem.c
> > @@ -63,6 +63,20 @@ void *execmem_text_alloc(size_t size)
> >                              fallback_start, fallback_end, kasan);
> >  }
> >
> > +void *execmem_data_alloc(size_t size)
> > +{
> > +       unsigned long start = execmem_params.modules.data.start;
> > +       unsigned long end = execmem_params.modules.data.end;
> > +       pgprot_t pgprot = execmem_params.modules.data.pgprot;
> > +       unsigned int align = execmem_params.modules.data.alignment;
> > +       unsigned long fallback_start = execmem_params.modules.data.fallback_start;
> > +       unsigned long fallback_end = execmem_params.modules.data.fallback_end;
> > +       bool kasan = execmem_params.modules.flags & EXECMEM_KASAN_SHADOW;
> > +
> > +       return execmem_alloc(size, start, end, align, pgprot,
> > +                            fallback_start, fallback_end, kasan);
> > +}
> > +
> >  void execmem_free(void *ptr)
> >  {
> >         /*
> > @@ -101,6 +115,28 @@ static bool execmem_validate_params(struct execmem_params *p)
> >         return true;
> >  }
> >
> > +static void execmem_init_missing(struct execmem_params *p)
> 
> Shall we call this execmem_default_init_data?

This also fills in jit.text (next patch), so _data doesn't work here :)
And it's not really a default, the defaults are set explicitly for arches
that don't have execmem_arch_params.
 
> > +{
> > +       struct execmem_modules_range *m = &p->modules;
> > +
> > +       if (!pgprot_val(execmem_params.modules.data.pgprot))
> > +               execmem_params.modules.data.pgprot = PAGE_KERNEL;
> 
> Do we really need to check each of these? IOW, can we do:
> 
> if (!pgprot_val(execmem_params.modules.data.pgprot)) {
>        execmem_params.modules.data.pgprot = PAGE_KERNEL;
>        execmem_params.modules.data.alignment = m->text.alignment;
>        execmem_params.modules.data.start = m->text.start;
>        execmem_params.modules.data.end = m->text.end;
>        execmem_params.modules.data.fallback_start = m->text.fallback_start;
>       execmem_params.modules.data.fallback_end = m->text.fallback_end;
> }

Yes, we can have a single check here.
 
> Thanks,
> Song
> 
> [...]

-- 
Sincerely yours,
Mike.


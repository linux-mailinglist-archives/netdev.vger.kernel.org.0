Return-Path: <netdev+bounces-7359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E72571FDFD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:35:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DDFA1C20C16
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1EAC17AC2;
	Fri,  2 Jun 2023 09:35:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2B217ABA;
	Fri,  2 Jun 2023 09:35:35 +0000 (UTC)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id A00EF99;
	Fri,  2 Jun 2023 02:35:20 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2ACE41063;
	Fri,  2 Jun 2023 02:36:05 -0700 (PDT)
Received: from FVFF77S0Q05N (unknown [10.57.24.167])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AF4863F7BD;
	Fri,  2 Jun 2023 02:35:14 -0700 (PDT)
Date: Fri, 2 Jun 2023 10:35:09 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
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
Subject: Re: [PATCH 00/13] mm: jit/text allocator
Message-ID: <ZHm3zUUbwqlsZBBF@FVFF77S0Q05N>
References: <20230601101257.530867-1-rppt@kernel.org>
 <ZHjDU/mxE+cugpLj@FVFF77S0Q05N.cambridge.arm.com>
 <ZHjgIH3aX9dCvVZc@moria.home.lan>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHjgIH3aX9dCvVZc@moria.home.lan>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 02:14:56PM -0400, Kent Overstreet wrote:
> On Thu, Jun 01, 2023 at 05:12:03PM +0100, Mark Rutland wrote:
> > For a while I have wanted to give kprobes its own allocator so that it can work
> > even with CONFIG_MODULES=n, and so that it doesn't have to waste VA space in
> > the modules area.
> > 
> > Given that, I think these should have their own allocator functions that can be
> > provided independently, even if those happen to use common infrastructure.
> 
> How much memory can kprobes conceivably use? I think we also want to try
> to push back on combinatorial new allocators, if we can.

That depends on who's using it, and how (e.g. via BPF).

To be clear, I'm not necessarily asking for entirely different allocators, but
I do thinkg that we want wrappers that can at least pass distinct start+end
parameters to a common allocator, and for arm64's modules code I'd expect that
we'd keep the range falblack logic out of the common allcoator, and just call
it twice.

> > > Several architectures override module_alloc() because of various
> > > constraints where the executable memory can be located and this causes
> > > additional obstacles for improvements of code allocation.
> > > 
> > > This set splits code allocation from modules by introducing
> > > jit_text_alloc(), jit_data_alloc() and jit_free() APIs, replaces call
> > > sites of module_alloc() and module_memfree() with the new APIs and
> > > implements core text and related allocation in a central place.
> > > 
> > > Instead of architecture specific overrides for module_alloc(), the
> > > architectures that require non-default behaviour for text allocation must
> > > fill jit_alloc_params structure and implement jit_alloc_arch_params() that
> > > returns a pointer to that structure. If an architecture does not implement
> > > jit_alloc_arch_params(), the defaults compatible with the current
> > > modules::module_alloc() are used.
> > 
> > As above, I suspect that each of the callsites should probably be using common
> > infrastructure, but I don't think that a single jit_alloc_arch_params() makes
> > sense, since the parameters for each case may need to be distinct.
> 
> I don't see how that follows. The whole point of function parameters is
> that they may be different :)

What I mean is that jit_alloc_arch_params() tries to aggregate common
parameters, but they aren't actually common (e.g. the actual start+end range
for allocation).

> Can you give more detail on what parameters you need? If the only extra
> parameter is just "does this allocation need to live close to kernel
> text", that's not that big of a deal.

My thinking was that we at least need the start + end for each caller. That
might be it, tbh.

Thanks,
Mark.


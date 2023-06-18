Return-Path: <netdev+bounces-11761-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54AAE734554
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 10:01:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D3B952811FA
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 08:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10AC815AF;
	Sun, 18 Jun 2023 08:01:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AA4EA2A;
	Sun, 18 Jun 2023 08:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DA1EC433C0;
	Sun, 18 Jun 2023 08:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687075275;
	bh=JOdF7gdXvqBjASqKs6SWBkQKDgB3N69nrNaZPukvaeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sRSVsUz+8qwPDTD+DbQ8ZGj3oxWbs6Q2yclpQ5oA01FgfO3x99AMq57vy9vTmKGCz
	 zxsNFAk2tsVXc2/ZMKN5WrqHKwwq7cFYa5f3HPOYIxlAVh8JcIK7E8a/4ukOQRZ4nx
	 MkY7brx+YmsqJJOWjKI+esA6758vzynczNeZM28mb8D2036W2Ac3dVaBq4RYIRm2lO
	 UwBKETxVcKwPW5jcSjXTb+3J9p7JSrJABXAw2lEoobsEXKewtbcSu8Iyl/ROefguVb
	 JB6NowqZPjsvgPvrW3+OErG+qxYX7mjk/nhQmoo1FPg/indEYGUiochf7rWuDn85yN
	 s8jpvUG70jw+A==
Date: Sun, 18 Jun 2023 11:00:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	"Russell King (Oracle)" <linux@armlinux.org.uk>,
	Song Liu <song@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org,
	the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH v2 02/12] mm: introduce execmem_text_alloc() and
 jit_text_alloc()
Message-ID: <20230618080027.GA52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-3-rppt@kernel.org>
 <f9a7eebe-d36e-4587-b99d-35d4edefdd14@app.fastmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9a7eebe-d36e-4587-b99d-35d4edefdd14@app.fastmail.com>

On Sat, Jun 17, 2023 at 01:38:29PM -0700, Andy Lutomirski wrote:
> On Fri, Jun 16, 2023, at 1:50 AM, Mike Rapoport wrote:
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> >
> > module_alloc() is used everywhere as a mean to allocate memory for code.
> >
> > Beside being semantically wrong, this unnecessarily ties all subsystems
> > that need to allocate code, such as ftrace, kprobes and BPF to modules
> > and puts the burden of code allocation to the modules code.
> >
> > Several architectures override module_alloc() because of various
> > constraints where the executable memory can be located and this causes
> > additional obstacles for improvements of code allocation.
> >
> > Start splitting code allocation from modules by introducing
> > execmem_text_alloc(), execmem_free(), jit_text_alloc(), jit_free() APIs.
> >
> > Initially, execmem_text_alloc() and jit_text_alloc() are wrappers for
> > module_alloc() and execmem_free() and jit_free() are replacements of
> > module_memfree() to allow updating all call sites to use the new APIs.
> >
> > The intention semantics for new allocation APIs:
> >
> > * execmem_text_alloc() should be used to allocate memory that must reside
> >   close to the kernel image, like loadable kernel modules and generated
> >   code that is restricted by relative addressing.
> >
> > * jit_text_alloc() should be used to allocate memory for generated code
> >   when there are no restrictions for the code placement. For
> >   architectures that require that any code is within certain distance
> >   from the kernel image, jit_text_alloc() will be essentially aliased to
> >   execmem_text_alloc().
> >
> 
> Is there anything in this series to help users do the appropriate
> synchronization when the actually populate the allocated memory with
> code?  See here, for example:

This series only factors out the executable allocations from modules and
puts them in a central place.
Anything else would go on top after this lands.
 
> https://lore.kernel.org/linux-fsdevel/cb6533c6-cea0-4f04-95cf-b8240c6ab405@app.fastmail.com/T/#u

-- 
Sincerely yours,
Mike.


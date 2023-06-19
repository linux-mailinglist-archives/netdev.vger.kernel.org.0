Return-Path: <netdev+bounces-12020-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69A73735B0F
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 17:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2463D2810D1
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 15:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4209412B80;
	Mon, 19 Jun 2023 15:24:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6092D2F8;
	Mon, 19 Jun 2023 15:24:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA4DC433C8;
	Mon, 19 Jun 2023 15:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687188257;
	bh=N4a6+AKTlpfQu+hNLgDTvYGemlpqgXPewbtXySTT2Wk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kRzjt2nDIAl4X26ojRiB8w8CJVn45eTmiPbIYkIvDYRBR/QR7IVpfAXYd9FpfNQDQ
	 OvemWMKmfnlcr5GwcS7TCX2oTJmzf2fUUsDJHf2Oq+4RHGmHWKbk0CASnuDz6Gk1Ld
	 1e26ENdIJqn1qjqL2vy8CRe3zudh+ZqjAZ7btzz+Jja4UEKxYRLaqjs+hNR8TPWi48
	 sYyUqJtdsNHbcbOzxo9zMe/AaYlu9nZhYjfHu5NSh21mKAk+otvslcioi5dkhxeNTF
	 EnxnECqDbcsPkYZvvYUeyjGiH7IzMmaAIOnWvmMc+HuAd2WDWUtK2BFwEfTtd03m+J
	 SY9K1sARFWi7g==
Date: Mon, 19 Jun 2023 18:23:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
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
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Will Deacon <will@kernel.org>, bpf@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
	linux-mm@kvack.org, linux-modules@vger.kernel.org,
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev,
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 06/12] mm/execmem: introduce execmem_data_alloc()
Message-ID: <20230619152334.GC52412@kernel.org>
References: <20230616085038.4121892-1-rppt@kernel.org>
 <20230616085038.4121892-7-rppt@kernel.org>
 <87jzw0qu3s.ffs@tglx>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzw0qu3s.ffs@tglx>

On Mon, Jun 19, 2023 at 12:32:55AM +0200, Thomas Gleixner wrote:
> Mike!
> 
> Sorry for being late on this ...
> 
> On Fri, Jun 16 2023 at 11:50, Mike Rapoport wrote:
> 
> The fact that my suggestions had a 'mod_' namespace prefix does not make
> any of my points moot.

The prefix does not matter. What matters is what we are trying to abstract.
Your suggestion is based of the memory used by modules. I'm abstracting
address spaces for different types of executable and related memory. They
are similar, yes, but they are not the same.

The TEXT, INIT_TEXT and *_DATA do not match to what we have from arch POV.
They have modules with text, rw data, ro data and ro after init data and
the memory for the generated code. The memory for modules and memory for
other users have different restrictions for their placement, so using a
single TEXT type for them is semantically wrong. BPF and kprobes do not
necessarily must be at the same address range as modules and init text does
not differ from normal text.

> Song did an extremly good job in abstracting things out, but you decided
> to ditch his ground work instead of building on it and keeping the good
> parts. That's beyond sad.

Actually not. The core idea to describe address range suitable for code
allocations with a structure and have arch code initialize this structure
at boot and be done with it is the same. But I don't think vmalloc
parameters belong there, they should be completely encapsulated in the
allocator. Having fallback range named explicitly is IMO clearer than an
array of address spaces.

I accept your point that the structures describing ranges for different
types should be unified and I've got carried away with making the wrappers
to convert that structure to parameters to the core allocation function.

I've chosen to define ranges as fields in the containing structure rather
than enum with types and an array because I strongly feel that the callers
should not care about these parameters. These parameters are defined by
architecture and the callers should not need to know how each and every
arch defines restrictions suitable for modules, bpf or kprobes.

That's also the reason to have different names for API calls, exactly to
avoid having alloc(KPROBES,...), alloc(BPF, ...), alloc(MODULES, ...) an so
on.

All in all, if I filter all the ranting, this boils down to having a
unified structure for all the address ranges and passing this structure
from the wrappers to the core alloc as is rather that translating it to
separate parameters, with which I agree.

> Thanks,
> 
>         tglx

-- 
Sincerely yours,
Mike.


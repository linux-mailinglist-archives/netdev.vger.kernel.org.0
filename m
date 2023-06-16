Return-Path: <netdev+bounces-11535-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8A2733806
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2ABB2817DC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB6071DCBB;
	Fri, 16 Jun 2023 18:18:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8C01ACD1;
	Fri, 16 Jun 2023 18:18:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE57BC4339A;
	Fri, 16 Jun 2023 18:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686939535;
	bh=JYIeppGROaSwt5RJCAxNQJPfExACzvun2YHFgIEWjL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IzPKo+jK4luEJPBN0IXaMM9NoBohQwylmyD6SOtRwX+YHgT9pt8MIqbXkSBPR6OVR
	 /VjE3RPenLmbkl9jNPpLgItztd650j/5i4Va33yoTKpPExRZlBgNWOG1So983jlXQF
	 yVTlXF+vQ1OIFfDaYs9xwGLtC0FMaZ8PTvXNpCHGP797MMhtKNhJYcskAyFP4r0ORW
	 jRQGM3yRcA+dWCLV7mIEN2p/2GyNuYsQzdtYWVtVoCRZNrnYvu2dHR+Lw2iUXJxquc
	 FLnychOVPaAoWGd242H5r7TyNYDZiDO+1rDQAW2lvEG/PSv9+R2O/6b7/dZeA4YGtc
	 +8sk6it3T0tMw==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-4f76b6db73fso2716027e87.1;
        Fri, 16 Jun 2023 11:18:55 -0700 (PDT)
X-Gm-Message-State: AC+VfDxpMFIVPiq+iE1MDwmiSrXy2usd1aeZaAGUbn8vWFTOcs2Ij2EZ
	lTgeuioJif5L5iiHg3rxPVWD/m7SAh0hKCEoCe8=
X-Google-Smtp-Source: ACHHUZ6PUs5qG5gEz0Ui+rYTOBYo1CNjp/5QXhNKC7wMrP1gtK8A+svd4/31TT3PuRRLSD+QiqJSaxjJua7jMaFtZ74=
X-Received: by 2002:ac2:4c4c:0:b0:4f6:3ef3:13e8 with SMTP id
 o12-20020ac24c4c000000b004f63ef313e8mr2671938lfk.0.1686939533810; Fri, 16 Jun
 2023 11:18:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-3-rppt@kernel.org>
 <ZIySQgafdTHk5Yet@moria.home.lan>
In-Reply-To: <ZIySQgafdTHk5Yet@moria.home.lan>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 11:18:41 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5hnH3Tq+rO1XJEAieDtr61xHBDRmp+C5zRYV5ajRcDFQ@mail.gmail.com>
Message-ID: <CAPhsuW5hnH3Tq+rO1XJEAieDtr61xHBDRmp+C5zRYV5ajRcDFQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/12] mm: introduce execmem_text_alloc() and jit_text_alloc()
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, "David S. Miller" <davem@davemloft.net>, 
	Dinh Nguyen <dinguyen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nadav Amit <nadav.amit@gmail.com>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Puranjay Mohan <puranjay12@gmail.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Russell King <linux@armlinux.org.uk>, 
	Steven Rostedt <rostedt@goodmis.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>, bpf@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 16, 2023 at 9:48=E2=80=AFAM Kent Overstreet
<kent.overstreet@linux.dev> wrote:
>
> On Fri, Jun 16, 2023 at 11:50:28AM +0300, Mike Rapoport wrote:
> > From: "Mike Rapoport (IBM)" <rppt@kernel.org>
> >
> > module_alloc() is used everywhere as a mean to allocate memory for code=
.
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
> > execmem_text_alloc(), execmem_free(), jit_text_alloc(), jit_free() APIs=
.
> >
> > Initially, execmem_text_alloc() and jit_text_alloc() are wrappers for
> > module_alloc() and execmem_free() and jit_free() are replacements of
> > module_memfree() to allow updating all call sites to use the new APIs.
> >
> > The intention semantics for new allocation APIs:
> >
> > * execmem_text_alloc() should be used to allocate memory that must resi=
de
> >   close to the kernel image, like loadable kernel modules and generated
> >   code that is restricted by relative addressing.
> >
> > * jit_text_alloc() should be used to allocate memory for generated code
> >   when there are no restrictions for the code placement. For
> >   architectures that require that any code is within certain distance
> >   from the kernel image, jit_text_alloc() will be essentially aliased t=
o
> >   execmem_text_alloc().
> >
> > The names execmem_text_alloc() and jit_text_alloc() emphasize that the
> > allocated memory is for executable code, the allocations of the
> > associated data, like data sections of a module will use
> > execmem_data_alloc() interface that will be added later.
>
> I like the API split - at the risk of further bikeshedding, perhaps
> near_text_alloc() and far_text_alloc()? Would be more explicit.
>
> Reviewed-by: Kent Overstreet <kent.overstreet@linux.dev>

Acked-by: Song Liu <song@kernel.org>


Return-Path: <netdev+bounces-11538-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6590573383B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:36:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DC1A1C2105B
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6784417750;
	Fri, 16 Jun 2023 18:36:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D670101F6;
	Fri, 16 Jun 2023 18:36:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A86C433C9;
	Fri, 16 Jun 2023 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686940606;
	bh=JGylOLwsDlnOC/7zFFXP8rSDvCyOTlCYNV6rWd4f8mw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SeXeGZ/w86KmlurMiVm4UIF69ZGzlkmxJdFe2QmV6PX8IW+hDhUbuFBav3t/B8pWZ
	 vEzDIgk/zKEW5stVwEtyb8WYKsD74Cn5N7O03rsyRz3LX2xGotPEbMmsM7IV3g9Dxd
	 h5Uh6GrvB3LrnxzUUDOGdAi+YQl7sfLX58PmPPi1I/7ju04tDqO1xvj3P1oQrQvlEn
	 mq1rf5Tcp0oheWCmaw6RaW+tUKVhYkG7a6qCHK2MLKMhdZ/TjBbzmfPfgUfEdkhdA/
	 QK30NJOharxczGBPm79t0v2LgrZqJ5TBlW/fXRzSrlgo6PvG8f6QCwr2oWnE+7+dKS
	 y4wFdRFTvaw9Q==
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4f84d70bf96so1327926e87.0;
        Fri, 16 Jun 2023 11:36:46 -0700 (PDT)
X-Gm-Message-State: AC+VfDzfimA42RcpSaF9PTQlk2nNIJUxkYTv66oTFHA3L8Ny/CEgE78U
	bF83XCPAbg+H9PPaws+Kf354lKxf0BwZ8HemavA=
X-Google-Smtp-Source: ACHHUZ7VgWfSxd734IfkdiKrgB+GJm0nBxE0sk2dQ8TAn5f7aSo4Y23dXvE8MnzKke3G84UjJ1bhxQV9PGC+v71U+NE=
X-Received: by 2002:a19:7913:0:b0:4f3:aa81:2a6e with SMTP id
 u19-20020a197913000000b004f3aa812a6emr797084lfc.19.1686940604495; Fri, 16 Jun
 2023 11:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-4-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-4-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 11:36:32 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6tDvY5G-qGMq3ymth3ip27=zAij8_UhJ-qP6Ct1U1-ZA@mail.gmail.com>
Message-ID: <CAPhsuW6tDvY5G-qGMq3ymth3ip27=zAij8_UhJ-qP6Ct1U1-ZA@mail.gmail.com>
Subject: Re: [PATCH v2 03/12] mm/execmem, arch: convert simple overrides of
 module_alloc to execmem
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
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

On Fri, Jun 16, 2023 at 1:51=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>
> Several architectures override module_alloc() only to define address
> range for code allocations different than VMALLOC address space.
>
> Provide a generic implementation in execmem that uses the parameters
> for address space ranges, required alignment and page protections
> provided by architectures.
>
> The architecures must fill execmem_params structure and implement
> execmem_arch_params() that returns a pointer to that structure. This
> way the execmem initialization won't be called from every architecure,
> but rather from a central place, namely initialization of the core
> memory management.
>
> The execmem provides execmem_text_alloc() API that wraps
> __vmalloc_node_range() with the parameters defined by the architecures.
> If an architeture does not implement execmem_arch_params(),
> execmem_text_alloc() will fall back to module_alloc().
>
> The name execmem_text_alloc() emphasizes that the allocated memory is
> for executable code, the allocations of the associated data, like data
> sections of a module will use execmem_data_alloc() interface that will
> be added later.
>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>

Acked-by: Song Liu <song@kernel.org>


Return-Path: <netdev+bounces-11606-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BCC33733AAE
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:18:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4FAE1C210CA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:18:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61C331F19B;
	Fri, 16 Jun 2023 20:18:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D913A1ACDB;
	Fri, 16 Jun 2023 20:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4CCC433C0;
	Fri, 16 Jun 2023 20:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686946692;
	bh=U5Tl9qs4B0TBI/rIx4ZZgTkRwFm5uyKz4CPReQtXH/U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=LmBJJScQlLvxsT8+Ta1tCpM4WXI6TR8l8c5jV/lF5ZOrowqAfZjtpNM41tcPHiArX
	 +YH5I9st348UgQHncZvkjv1I8uf6/B9VIYKB/ZX5ShONmWppK4Z28CmWLldHUX++Co
	 tQHCqBzRDW0rngL+0918l5A/LKDXSOHiSUfIz3m/CZC9iQ5hn0r0gJTm/FmWwj/qLn
	 mAG9TY9iKVAQprNcopRBSELs+aKCJHBbKHSrnFdxygoqMhe72Gcymvj1seoYl1ETYg
	 kF9uj767lw3HcyBO4F7SRQUsfNpsVMh+rYJU6mMVRBqQdXG9XPM9gyQIez8ST13ZvP
	 VGJY2Pv9kdJTA==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b45a71c9caso13911621fa.3;
        Fri, 16 Jun 2023 13:18:12 -0700 (PDT)
X-Gm-Message-State: AC+VfDzwqXFeWcpAfyNZDYJy/dEE3segkj31VXtM2BI04oZSYci1aCEf
	/ekDI9FrlcgdbzzOuE7aPn1PxICOrGvRVZFOatg=
X-Google-Smtp-Source: ACHHUZ4zX0CYOJSSN4FGWX93J1VUIgZYXEOYsrGR9cSML7AlHx0h0qQhMxp9jkMOVU4u0KdCA43Yux1f/ue71yfnFUk=
X-Received: by 2002:a05:651c:225:b0:2b3:4fb7:8991 with SMTP id
 z5-20020a05651c022500b002b34fb78991mr2815162ljn.43.1686946690319; Fri, 16 Jun
 2023 13:18:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-11-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-11-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 13:17:57 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4C1zm72AkHfuo6Xz4+37AG4BgX_k2fM+xw536QeDQS+w@mail.gmail.com>
Message-ID: <CAPhsuW4C1zm72AkHfuo6Xz4+37AG4BgX_k2fM+xw536QeDQS+w@mail.gmail.com>
Subject: Re: [PATCH v2 10/12] arch: make execmem setup available regardless of CONFIG_MODULES
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

On Fri, Jun 16, 2023 at 1:52=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wro=
te:
>
> From: "Mike Rapoport (IBM)" <rppt@kernel.org>
>
> execmem does not depend on modules, on the contrary modules use
> execmem.
>
> To make execmem available when CONFIG_MODULES=3Dn, for instance for
> kprobes, split execmem_params initialization out from
> arch/kernel/module.c and compile it when CONFIG_EXECMEM=3Dy
>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> ---
[...]
> +
> +struct execmem_params __init *execmem_arch_params(void)
> +{
> +       u64 module_alloc_end;
> +
> +       kaslr_init();

Aha, this addresses my comment on the earlier patch. Thanks!

Acked-by: Song Liu <song@kernel.org>


> +
> +       module_alloc_end =3D module_alloc_base + MODULES_VSIZE;
> +
> +       execmem_params.modules.text.pgprot =3D PAGE_KERNEL;
> +       execmem_params.modules.text.start =3D module_alloc_base;
> +       execmem_params.modules.text.end =3D module_alloc_end;
> +
> +       execmem_params.jit.text.pgprot =3D PAGE_KERNEL_ROX;
[...]


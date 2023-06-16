Return-Path: <netdev+bounces-11569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC0C0733A42
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 22:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A17A281816
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 20:01:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238C41ED50;
	Fri, 16 Jun 2023 20:01:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6014A1ED33;
	Fri, 16 Jun 2023 20:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E208FC433C0;
	Fri, 16 Jun 2023 20:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686945682;
	bh=NNR06pawYLcrluh/DT0ZjxTIOvEpuKGIsr6P52TLsXk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=B2x9p0bw9e1c5FEiElfS0dqOB9kBN1XvLc3rdRIjWsCJR6DEA+8/fPzx0tD0XRds9
	 xnUob2gqF2SwBz+B8m0N3hPtdbY9Zjp4OWtxr5mJ453zMkqDfQfhs3Bk0NKVLLnJ8T
	 YRFinBI4ZyqxgEMzd4FvqZ96m1iAvyUW5PzZ9IkU7jzJf2O+Uh3mAZnkJkvCh4Irzi
	 y8m2OdBztq5JFis9yBA+hEUTNF3tMD5RAOz5rdpO89Y54dunPa4NAr9k6faBzowxQk
	 AVRlbo+pV0l2tH94RtPSD4Alk/lhusm0f9qKVWPhAsHRvmHc3DaWJj06DslGvi6t1A
	 z4M//Xaki6glw==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4f766777605so1569607e87.1;
        Fri, 16 Jun 2023 13:01:22 -0700 (PDT)
X-Gm-Message-State: AC+VfDyVb1J0jxb7ByxdQPFCoN6rG5PynZqV/6xLihGaBnsDfgruhCon
	IUH8GAu3x/TSlzsgzzJMcx1NcvAGKA32lec/Nr8=
X-Google-Smtp-Source: ACHHUZ5JqRMNnpRMFCyZiMjc+UWPs6A2cx1mTw/2r3SQw3woyTfRJjaUEkhnoXK7xbHKeHI/ilSSCGbka/vlr73Fo7g=
X-Received: by 2002:a05:6512:60a:b0:4f8:5635:2ccf with SMTP id
 b10-20020a056512060a00b004f856352ccfmr2048673lfe.8.1686945680955; Fri, 16 Jun
 2023 13:01:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230616085038.4121892-1-rppt@kernel.org> <20230616085038.4121892-7-rppt@kernel.org>
In-Reply-To: <20230616085038.4121892-7-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Fri, 16 Jun 2023 13:01:08 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4J+rFvh9WJVWLZxFHtcYxahYk=NoKYdU9FMibZU8986w@mail.gmail.com>
Message-ID: <CAPhsuW4J+rFvh9WJVWLZxFHtcYxahYk=NoKYdU9FMibZU8986w@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] mm/execmem: introduce execmem_data_alloc()
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
> Data related to code allocations, such as module data section, need to
> comply with architecture constraints for its placement and its
> allocation right now was done using execmem_text_alloc().
>
> Create a dedicated API for allocating data related to code allocations
> and allow architectures to define address ranges for data allocations.
>
> Since currently this is only relevant for powerpc variants that use the
> VMALLOC address space for module data allocations, automatically reuse
> address ranges defined for text unless address range for data is
> explicitly defined by an architecture.
>
> With separation of code and data allocations, data sections of the
> modules are now mapped as PAGE_KERNEL rather than PAGE_KERNEL_EXEC which
> was a default on many architectures.
>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
[...]
>  static void free_mod_mem(struct module *mod)
> diff --git a/mm/execmem.c b/mm/execmem.c
> index a67acd75ffef..f7bf496ad4c3 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -63,6 +63,20 @@ void *execmem_text_alloc(size_t size)
>                              fallback_start, fallback_end, kasan);
>  }
>
> +void *execmem_data_alloc(size_t size)
> +{
> +       unsigned long start =3D execmem_params.modules.data.start;
> +       unsigned long end =3D execmem_params.modules.data.end;
> +       pgprot_t pgprot =3D execmem_params.modules.data.pgprot;
> +       unsigned int align =3D execmem_params.modules.data.alignment;
> +       unsigned long fallback_start =3D execmem_params.modules.data.fall=
back_start;
> +       unsigned long fallback_end =3D execmem_params.modules.data.fallba=
ck_end;
> +       bool kasan =3D execmem_params.modules.flags & EXECMEM_KASAN_SHADO=
W;
> +
> +       return execmem_alloc(size, start, end, align, pgprot,
> +                            fallback_start, fallback_end, kasan);
> +}
> +
>  void execmem_free(void *ptr)
>  {
>         /*
> @@ -101,6 +115,28 @@ static bool execmem_validate_params(struct execmem_p=
arams *p)
>         return true;
>  }
>
> +static void execmem_init_missing(struct execmem_params *p)

Shall we call this execmem_default_init_data?

> +{
> +       struct execmem_modules_range *m =3D &p->modules;
> +
> +       if (!pgprot_val(execmem_params.modules.data.pgprot))
> +               execmem_params.modules.data.pgprot =3D PAGE_KERNEL;

Do we really need to check each of these? IOW, can we do:

if (!pgprot_val(execmem_params.modules.data.pgprot)) {
       execmem_params.modules.data.pgprot =3D PAGE_KERNEL;
       execmem_params.modules.data.alignment =3D m->text.alignment;
       execmem_params.modules.data.start =3D m->text.start;
       execmem_params.modules.data.end =3D m->text.end;
       execmem_params.modules.data.fallback_start =3D m->text.fallback_star=
t;
      execmem_params.modules.data.fallback_end =3D m->text.fallback_end;
}

Thanks,
Song

[...]


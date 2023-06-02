Return-Path: <netdev+bounces-7270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E75071F6FD
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 02:02:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC87D281978
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60963EBE;
	Fri,  2 Jun 2023 00:02:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B985180;
	Fri,  2 Jun 2023 00:02:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A691CC433A8;
	Fri,  2 Jun 2023 00:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685664150;
	bh=tFm/VXuuVDtTlP6XBCrW6GQLEa1ct+xvVLB1UFiGIT0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zhe+ii4hjesHDAgMZHuwpUCJJCm75EFKG+5a6EPWjMO0HDHXPyIpavtujtLCURVSG
	 L0tPOTqlQwSkMNiUo14MQBHZXJuJsEZSF14bp35whT7uHVYa6I5+MNTZchaPm9JNIm
	 aVdr8gwENYjQkB3MGIU8IUF/E6pIAulaPIHaGpFoY73x0KGcegDzYIgthrQqKLiK0x
	 E+hZoEG+zWVfdTx59SC4n6eQIxvKqvyqdxNlYb/Bah5jcigAfqfjnA8yubrXktjB4r
	 u9EYw1FVaxQ8EYOZ1NhKvpv2x/t9dFLPXYWavNE0MV8kGpQg8ySGoyFYWjG/4fGguR
	 0BNJi8O6JG65A==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4f3edc05aa5so1930227e87.3;
        Thu, 01 Jun 2023 17:02:30 -0700 (PDT)
X-Gm-Message-State: AC+VfDx1f2WOHYh7UHw2JHakFpe2ckFEFbZuGB3OYXPFivvE1fP+VU58
	0jPezDtLPl/YbMsuEvh90TqVFocil64TxgweWLU=
X-Google-Smtp-Source: ACHHUZ5+AeCGOC7qHIq2jqRCeZpvT4cPqtj6GONlHu3ZGFgMYeuzIcV8ffuR5AKgvu/Von6c/0h12/a6PWP4XU2OyEA=
X-Received: by 2002:a05:6512:201:b0:4f2:4df1:9718 with SMTP id
 a1-20020a056512020100b004f24df19718mr780946lfo.17.1685664148535; Thu, 01 Jun
 2023 17:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <20230601101257.530867-13-rppt@kernel.org>
 <20230601103050.GT4253@hirez.programming.kicks-ass.net> <20230601110713.GE395338@kernel.org>
In-Reply-To: <20230601110713.GE395338@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 1 Jun 2023 17:02:16 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7J=4iMPQQw=V1C4MLFf=cP94gSwVx1g7M4YL0W6OLHRQ@mail.gmail.com>
Message-ID: <CAPhsuW7J=4iMPQQw=V1C4MLFf=cP94gSwVx1g7M4YL0W6OLHRQ@mail.gmail.com>
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
To: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Christophe Leroy <christophe.leroy@csgroup.eu>, "David S. Miller" <davem@davemloft.net>, 
	Dinh Nguyen <dinguyen@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Luis Chamberlain <mcgrof@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Russell King <linux@armlinux.org.uk>, Steven Rostedt <rostedt@goodmis.org>, 
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Thomas Gleixner <tglx@linutronix.de>, 
	Will Deacon <will@kernel.org>, bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, linux-modules@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, 
	netdev@vger.kernel.org, sparclinux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 4:07=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> On Thu, Jun 01, 2023 at 12:30:50PM +0200, Peter Zijlstra wrote:
> > On Thu, Jun 01, 2023 at 01:12:56PM +0300, Mike Rapoport wrote:
> >
> > > +static void __init_or_module do_text_poke(void *addr, const void *op=
code, size_t len)
> > > +{
> > > +   if (system_state < SYSTEM_RUNNING) {
> > > +           text_poke_early(addr, opcode, len);
> > > +   } else {
> > > +           mutex_lock(&text_mutex);
> > > +           text_poke(addr, opcode, len);
> > > +           mutex_unlock(&text_mutex);
> > > +   }
> > > +}
> >
> > So I don't much like do_text_poke(); why?
>
> I believe the idea was to keep memcpy for early boot before the kernel
> image is protected without going and adding if (is_module_text_address())
> all over the place.
>
> I think this can be used instead without updating all the call sites of
> text_poke_early():
>
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.=
c
> index 91057de8e6bc..f994e63e9903 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -1458,7 +1458,7 @@ void __init_or_module text_poke_early(void *addr, c=
onst void *opcode,
>                  * code cannot be running and speculative code-fetches ar=
e
>                  * prevented. Just change the code.
>                  */
> -               memcpy(addr, opcode, len);
> +               text_poke_copy(addr, opcode, len);
>         } else {
>                 local_irq_save(flags);
>                 memcpy(addr, opcode, len);
>

This alone doesn't work, as text_poke_early() is called
before addr is added to the list of module texts. So we
still use memcpy() here.

Thanks,
Song


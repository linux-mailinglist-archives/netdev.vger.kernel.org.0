Return-Path: <netdev+bounces-7263-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11CF871F63D
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:50:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5121C1C2114B
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:49:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D5B24EB0;
	Thu,  1 Jun 2023 22:49:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3BD6FBA;
	Thu,  1 Jun 2023 22:49:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266E3C433A8;
	Thu,  1 Jun 2023 22:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685659793;
	bh=s5scddDgq8SCu6I0UWPQExKWJjas9UFzehdQi3Sw4tA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K25ToaEbCp02bMG+wiJikwHyiXiwwQBkm/MmN8qlrLj5yam240H0kFAxxnFa3RlG8
	 bu4BSS/frooyZ20B2VklohnrYULCfishpBQ/wfdUaMkt+oR8gS4E1+AjfNshKja3vS
	 Rv+moH0Y5isDfBQyF8Rj722+0entBKGogJrcfr++cvzRmW73HdsIB35hoxtRn829Ae
	 fyn3i/1QAGvtS1oiJarw65vHM76zJn0jBvddq9Vcz7E6Icr7CQW2U08iG1Oryzm6d3
	 58DCK+DxQNJ2Qn/JWEej+n8GVZwut1/xKU3k6dkfSYsQUQ9uCCopruEXev0WWNFxor
	 G4HpcCwxRlB1w==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-4f5f728c4aaso1458699e87.0;
        Thu, 01 Jun 2023 15:49:52 -0700 (PDT)
X-Gm-Message-State: AC+VfDygFaQyEGlCK+cBn5k10kr0LSS4LPF8TjiwLA5nWkYlIg34T11I
	usjdwtcH1xjP2uCYF0St+hKlyfYIRh4gdi5zNt4=
X-Google-Smtp-Source: ACHHUZ4uA6ym60CkoL3kD4Xme876wGBHsdD1XRoswJZBV/GnrkgRlI3npJzU+tR131QuPJoGC+7UxG4nzuqJElDeBo4=
X-Received: by 2002:ac2:4a8b:0:b0:4f3:aa81:2a6e with SMTP id
 l11-20020ac24a8b000000b004f3aa812a6emr364328lfp.19.1685659791105; Thu, 01 Jun
 2023 15:49:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230601101257.530867-1-rppt@kernel.org> <20230601101257.530867-13-rppt@kernel.org>
In-Reply-To: <20230601101257.530867-13-rppt@kernel.org>
From: Song Liu <song@kernel.org>
Date: Thu, 1 Jun 2023 15:49:39 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Q2d7=7yBMQLgz+7Bz_q==_F+N3C8O4LStXva73ECCTg@mail.gmail.com>
Message-ID: <CAPhsuW4Q2d7=7yBMQLgz+7Bz_q==_F+N3C8O4LStXva73ECCTg@mail.gmail.com>
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Christophe Leroy <christophe.leroy@csgroup.eu>, 
	"David S. Miller" <davem@davemloft.net>, Dinh Nguyen <dinguyen@kernel.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>, Huacai Chen <chenhuacai@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Luis Chamberlain <mcgrof@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Russell King <linux@armlinux.org.uk>, 
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

On Thu, Jun 1, 2023 at 3:15=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wrot=
e:
>
> From: Song Liu <song@kernel.org>
>
> Replace direct memory writes to memory allocated for code with text pokin=
g
> to allow allocation of executable memory as ROX.
>
> The only exception is arch_prepare_bpf_trampoline() that cannot jit
> directly into module memory yet, so it uses set_memory calls to
> unprotect the memory before writing to it and to protect memory in the
> end.
>
> Signed-off-by: Song Liu <song@kernel.org>
> Co-developed-by: Mike Rapoport (IBM) <rppt@kernel.org>
> Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
> ---
>  arch/x86/kernel/alternative.c | 43 +++++++++++++++++++++++------------
>  arch/x86/kernel/ftrace.c      | 41 +++++++++++++++++++++------------
>  arch/x86/kernel/module.c      | 24 +++++--------------
>  arch/x86/kernel/static_call.c | 10 ++++----
>  arch/x86/kernel/unwind_orc.c  | 13 +++++++----
>  arch/x86/net/bpf_jit_comp.c   | 22 +++++++++++++-----

We need the following in this patch (or before this patch).
Otherwise, the system will crash at the VIRTUAL_BUG_ON()
in vmalloc_to_page().

Thanks,
Song

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index bf954d2721c1..4efa8a795ebc 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1084,7 +1084,7 @@ bpf_jit_binary_pack_alloc(unsigned int proglen,
u8 **image_ptr,
                return NULL;
        }

-       *rw_header =3D kvmalloc(size, GFP_KERNEL);
+       *rw_header =3D kvzalloc(size, GFP_KERNEL);
        if (!*rw_header) {
                bpf_arch_text_copy(&ro_header->size, &size, sizeof(size));
                bpf_prog_pack_free(ro_header);
@@ -1092,8 +1092,6 @@ bpf_jit_binary_pack_alloc(unsigned int proglen,
u8 **image_ptr,
                return NULL;
        }

-       /* Fill space with illegal/arch-dep instructions. */
-       bpf_fill_ill_insns(*rw_header, size);
        (*rw_header)->size =3D size;

        hole =3D min_t(unsigned int, size - (proglen + sizeof(*ro_header)),


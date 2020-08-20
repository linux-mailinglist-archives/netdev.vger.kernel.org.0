Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442CF24C4A2
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgHTRgn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Aug 2020 13:36:43 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:46722 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgHTRgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:36:41 -0400
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id DE21230278CD;
        Thu, 20 Aug 2020 19:36:37 +0200 (CEST)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id 8569E413CE8D; Thu, 20 Aug 2020 19:36:37 +0200 (CEST)
Message-ID: <a6f1d7be73ca5d9f767a746927e7872ddcf18244.camel@klomp.org>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
From:   Mark Wielaard <mark@klomp.org>
To:     Yonghong Song <yhs@fb.com>,
        =?UTF-8?Q?F=C4=81ng-ru=C3=AC_S=C3=B2ng?= <maskray@google.com>,
        Jiri Olsa <jolsa@kernel.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Date:   Thu, 20 Aug 2020 19:36:37 +0200
In-Reply-To: <7029ff8f-77d3-584b-2e7e-388c001cd648@fb.com>
References: <20200819092342.259004-1-jolsa@kernel.org>
         <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
         <20200819173618.GH177896@krava>
         <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
         <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
         <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
         <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
         <5ef90a283aa2f68018763258999fa66cd34cb3bb.camel@klomp.org>
         <7029ff8f-77d3-584b-2e7e-388c001cd648@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

On Thu, 2020-08-20 at 08:51 -0700, Yonghong Song wrote:
> > > Do you think we could skip these .debug_* sections somehow in elf
> > > parsing in resolve_btfids? resolve_btfids does not need to read
> > > these sections. This way, no need to change their alignment
> > > either.
> > 
> > The issue is that elfutils libelf will not allow writing out the
> > section when it notices the sh_addralign field is setup wrongly.
> 
> Maybe resolve_btfids can temporarily change sh_addralign to 4/8
> before elf manipulation (elf_write) to make libelf happy.
> After all elf_write is done, change back to whatever the
> original value (1). Does this work?

Unfortunately no, because there is no elf_write, elf_update is how you
write out the ELF image to disc.

Since the code is using ELF_F_LAYOUT this will not change the actual
layout of the ELF image if that is what you are worried about.

And the workaround to set sh_addralign correctly before calling
elf_update is precisely what the fix in elfutils libelf will do itself
in the next release. Also binutils ld has been fixed to setup
sh_addralign to 4/8 as appropriate now (in git).

Cheers,

Mark

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D779324B680
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731480AbgHTKfs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Aug 2020 06:35:48 -0400
Received: from wildebeest.demon.nl ([212.238.236.112]:39374 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731389AbgHTKSn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:18:43 -0400
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id 556A130278CD;
        Thu, 20 Aug 2020 12:18:36 +0200 (CEST)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id 05DBC413CE8D; Thu, 20 Aug 2020 12:18:36 +0200 (CEST)
Message-ID: <5ef90a283aa2f68018763258999fa66cd34cb3bb.camel@klomp.org>
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
Date:   Thu, 20 Aug 2020 12:18:35 +0200
In-Reply-To: <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
References: <20200819092342.259004-1-jolsa@kernel.org>
         <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
         <20200819173618.GH177896@krava>
         <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
         <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
         <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
         <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
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

Hi,

On Wed, 2020-08-19 at 20:23 -0700, Yonghong Song wrote:
> On 8/19/20 7:27 PM, Fāng-ruì Sòng wrote:
> > > > > 
> > I think this is resolve_btfids's bug. GNU ld and LLD are innocent.
> > These .debug_* sections work fine if their sh_addralign is 1.
> > When the section flag SHF_COMPRESSED is set, the meaningful
> > alignment
> > is Elf64_Chdr::ch_addralign, after the header is uncompressed.
> > 
> > On Wed, Aug 19, 2020 at 2:30 PM Yonghong Song <yhs@fb.com> wrote:
> Since Fangrui mentioned this is not a ld/lld bug, then changing
> alighment from 1 to 4 might have some adverse effect for the binary,
> I guess.

The bug isn't about a wrong ch_addralign, which seems to have been set
correctly. But it is a bug about incorrectly setting the sh_addralign
of the section. The sh_addralign indicates the alignment of the data in
the section, which is the Elf32/64_Chdr plus compressed data, not the
alignment of the uncompressed data. It helps the consumer make sure
they lay out the data so that the ELF data structures can be read
through their natural alignment.

In practice it often isn't a real issue, because consumers, including
libelf, will correct the data alignment before usage anyway. But that
doesn't mean it isn't a bug to set it wrongly.

> Do you think we could skip these .debug_* sections somehow in elf 
> parsing in resolve_btfids? resolve_btfids does not need to read
> these sections. This way, no need to change their alignment either.

The issue is that elfutils libelf will not allow writing out the
section when it notices the sh_addralign field is setup wrongly.

Cheers,

Mark

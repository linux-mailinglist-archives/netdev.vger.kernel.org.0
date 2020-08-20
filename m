Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE5224B693
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 12:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgHTKhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 06:37:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51932 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731234AbgHTKS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 06:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597918704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zVRgxsfepYzYkU+vpFAChRcrhAuOfHEv8LFvPPE6d28=;
        b=P+r5Gooa85xwjVB5WlCJZF7bMyjGulCXN7QTnkZ+Xrj+wLIFr3xEkTyNmoMY4Gehg8wQdQ
        Ne1Gm80yBHXOjZiX9F1vUbDTHE9UW0msF8RoosPzizsWo3HKs3VJnROmEnGcTeZivtOOTD
        0VR9hbZFeKxTV1h14GQmKZon3lYkJMw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-425-CakX2Xi6PCqH5-AxDXr1nQ-1; Thu, 20 Aug 2020 06:18:22 -0400
X-MC-Unique: CakX2Xi6PCqH5-AxDXr1nQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EB2E807332;
        Thu, 20 Aug 2020 10:18:20 +0000 (UTC)
Received: from krava (unknown [10.40.194.187])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5239319C66;
        Thu, 20 Aug 2020 10:18:11 +0000 (UTC)
Date:   Thu, 20 Aug 2020 12:18:10 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     =?utf-8?B?RsSBbmctcnXDrCBTw7JuZw==?= <maskray@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mark Wielaard <mjw@redhat.com>,
        Nick Clifton <nickc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next] tools/resolve_btfids: Fix sections with wrong
 alignment
Message-ID: <20200820101810.GA336489@krava>
References: <20200819092342.259004-1-jolsa@kernel.org>
 <254246ed-1b76-c435-a7bd-0783a29094d9@fb.com>
 <20200819173618.GH177896@krava>
 <CAKwvOdnfy4ASdeVqPjMtALXOXgMKdEB8U0UzWDPBKVqdhcPaFg@mail.gmail.com>
 <2e35cf9e-d815-5cd7-9106-7947e5b9fe3f@fb.com>
 <CAFP8O3+mqgQr_zVS9pMXSpFsCm0yp5y5Vgx1jmDc+wi-8-HOVQ@mail.gmail.com>
 <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ba7bbec7-9fb5-5f8f-131e-1e0aeff843fa@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 19, 2020 at 08:23:10PM -0700, Yonghong Song wrote:
> 
> 
> On 8/19/20 7:27 PM, Fāng-ruì Sòng wrote:
> > > > >     section(36) .comment, size 44, link 0, flags 30, type=1
> > > > >     section(37) .debug_aranges, size 45684, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 16, expected 8
> > > > >     section(38) .debug_info, size 129104957, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 1, expected 8
> > > > >     section(39) .debug_abbrev, size 1152583, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 1, expected 8
> > > > >     section(40) .debug_line, size 7374522, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 1, expected 8
> > > > >     section(41) .debug_frame, size 702463, link 0, flags 800, type=1
> > > > >     section(42) .debug_str, size 1017571, link 0, flags 830, type=1
> > > > >      - fixing wrong alignment sh_addralign 1, expected 8
> > > > >     section(43) .debug_loc, size 3019453, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 1, expected 8
> > > > >     section(44) .debug_ranges, size 1744583, link 0, flags 800, type=1
> > > > >      - fixing wrong alignment sh_addralign 16, expected 8
> > > > >     section(45) .symtab, size 2955888, link 46, flags 0, type=2
> > > > >     section(46) .strtab, size 2613072, link 0, flags 0, type=3
> > 
> > I think this is resolve_btfids's bug. GNU ld and LLD are innocent.
> > These .debug_* sections work fine if their sh_addralign is 1.
> > When the section flag SHF_COMPRESSED is set, the meaningful alignment
> > is Elf64_Chdr::ch_addralign, after the header is uncompressed.
> > 
> > On Wed, Aug 19, 2020 at 2:30 PM Yonghong Song <yhs@fb.com> wrote:
> > > 
> > > 
> > > 
> > > On 8/19/20 11:16 AM, Nick Desaulniers wrote:
> > > > On Wed, Aug 19, 2020 at 10:36 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > 
> > > > > On Wed, Aug 19, 2020 at 08:31:51AM -0700, Yonghong Song wrote:
> > > > > > 
> > > > > > 
> > > > > > On 8/19/20 2:23 AM, Jiri Olsa wrote:
> > > > > > > The data of compressed section should be aligned to 4
> > > > > > > (for 32bit) or 8 (for 64 bit) bytes.
> > > > > > > 
> > > > > > > The binutils ld sets sh_addralign to 1, which makes libelf
> > > > > > > fail with misaligned section error during the update as
> > > > > > > reported by Jesper:
> > > > > > > 
> > > > > > >       FAILED elf_update(WRITE): invalid section alignment
> 
> Jiri,
> 
> Since Fangrui mentioned this is not a ld/lld bug, then changing
> alighment from 1 to 4 might have some adverse effect for the binary,
> I guess.

not sure about that.. Mark? ;-)

> 
> Do you think we could skip these .debug_* sections somehow in elf parsing in
> resolve_btfids? resolve_btfids does not need to read
> these sections. This way, no need to change their alignment either.

I'm don't think libelf interface allows for that, will check

jirka


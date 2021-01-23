Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37408301854
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbhAWURX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 23 Jan 2021 15:17:23 -0500
Received: from wildebeest.demon.nl ([212.238.236.112]:35976 "EHLO
        gnu.wildebeest.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbhAWURT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:17:19 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jan 2021 15:17:18 EST
Received: from tarox.wildebeest.org (tarox.wildebeest.org [172.31.17.39])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gnu.wildebeest.org (Postfix) with ESMTPSA id 999A830015C3;
        Sat, 23 Jan 2021 21:08:15 +0100 (CET)
Received: by tarox.wildebeest.org (Postfix, from userid 1000)
        id 4F622400029C; Sat, 23 Jan 2021 21:08:15 +0100 (CET)
Message-ID: <d5e30947541a3571bd111e24b3a28dfb1770556c.camel@klomp.org>
Subject: Re: [PATCH 2/3] bpf_encoder: Translate SHN_XINDEX in symbol's
 st_shndx values
From:   Mark Wielaard <mark@klomp.org>
To:     Jiri Olsa <jolsa@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>
Date:   Sat, 23 Jan 2021 21:08:15 +0100
In-Reply-To: <20210123185143.GA117714@krava>
References: <20210121202203.9346-1-jolsa@kernel.org>
         <20210121202203.9346-3-jolsa@kernel.org>
         <CAEf4BzZquSn0Th7bpVuM0M4XbTPU5-9jDPPd5RJBS5AH2zqaMA@mail.gmail.com>
         <20210122204654.GB70760@krava>
         <CAEf4BzaRrMp1+2dgv_1WrkBt+=KF1BJnN_KGwZKx5gDg7t++Yg@mail.gmail.com>
         <20210123185143.GA117714@krava>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
X-Spam-Flag: NO
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.0
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on gnu.wildebeest.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

On Sat, 2021-01-23 at 19:51 +0100, Jiri Olsa wrote:
> On Fri, Jan 22, 2021 at 02:55:51PM -0800, Andrii Nakryiko wrote:
> > 
> > > I don't understand this..  gelf_getsymshndx will return both
> > > symbol and proper index, no? also sym_sec_idx is already
> > > assigned from previou call
> > 
> > Reading (some) implementation of gelf_getsymshndx() that I found
> > online, it won't set sym_sec_idx, if the symbol *doesn't* use
> > extended
> > numbering. But it will still return symbol data. So to return the
> 
> the latest upstream code seems to set it always,
> but I agree we should be careful
> 
> Mark, any insight in here? thanks

GElf_Sym *
gelf_getsymshndx (Elf_Data *symdata, Elf_Data *shndxdata, int ndx,
                  GElf_Sym *dst, Elf32_Word *dstshndx)

Will always set *dst, but only set *dstshndx if both it and shndxdata
are not NULL and no error occurred (the function returns NULL and set
libelf_error in case of error).

So as long as shndxdata != NULL you can rely on *dstshndx being set.
Otherwise you get the section index from dst->st_shndx.

Cheers,

Mark

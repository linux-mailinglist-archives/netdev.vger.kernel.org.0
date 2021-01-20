Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C82C02FCF59
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389400AbhATLXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:23:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:57938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731608AbhATLN2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Jan 2021 06:13:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5272D2250E;
        Wed, 20 Jan 2021 11:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611141134;
        bh=WirnMIqg9sdoD42HDZbb17JLEdR68OdowIbN6i1LK7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZJs5vNidFmCeW6AA+2g7IZ2O04HTHwacKOwlJzd6IUhXLPTOAVnfZOs1+rVzxKkJd
         Bjni9c0uRVTWqFtQUQslKNpXMaxEFOprFeFRjX3T/Br1eyvEQPSAMicd+okZHrAGsD
         7BGMKYxebTKHVrwro4ri2XOdK+RLD7360KOQS3amqOuJIXVbCnoPywK1RveWpCPZ5V
         4o2aIgmTPpUtmCQmmNVCqZERgAoMzyUBoApa2KiGN9ziV6syJcO6Y5818SFsa411tB
         6WhT0e6RbQMuKWXZ/6eEaMDTI70TYrUQZLnYFJGG+aPSThOfI7K2EoYXeHz9Xl22XH
         HraoRQGklJ2Sg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 0176940CE2; Wed, 20 Jan 2021 08:12:11 -0300 (-03)
Date:   Wed, 20 Jan 2021 08:12:11 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Use string table index from index
 table if needed
Message-ID: <20210120111211.GP12699@kernel.org>
References: <20210119221220.1745061-1-jolsa@kernel.org>
 <20210119221220.1745061-4-jolsa@kernel.org>
 <CAEf4BzZNPJZBfz7Ga9MGvGGYge4MCP1O16JVuFjdzu-bCEQFLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZNPJZBfz7Ga9MGvGGYge4MCP1O16JVuFjdzu-bCEQFLQ@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jan 19, 2021 at 05:22:08PM -0800, Andrii Nakryiko escreveu:
> On Tue, Jan 19, 2021 at 2:15 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > For very large ELF objects (with many sections), we could
> > get special value SHN_XINDEX (65535) for elf object's string
> > table index - e_shstrndx.
> >
> > In such case we need to call elf_getshdrstrndx to get the
> > proper string table index.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/lib/bpf/btf.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> > index 3c3f2bc6c652..4fe987846bc0 100644
> > --- a/tools/lib/bpf/btf.c
> > +++ b/tools/lib/bpf/btf.c
> > @@ -863,6 +863,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >         Elf_Scn *scn = NULL;
> >         Elf *elf = NULL;
> >         GElf_Ehdr ehdr;
> > +       size_t shstrndx;
> >
> >         if (elf_version(EV_CURRENT) == EV_NONE) {
> >                 pr_warn("failed to init libelf for %s\n", path);
> > @@ -887,7 +888,16 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >                 pr_warn("failed to get EHDR from %s\n", path);
> >                 goto done;
> >         }
> > -       if (!elf_rawdata(elf_getscn(elf, ehdr.e_shstrndx), NULL)) {
> > +
> > +       /*
> > +        * Get string table index from extended section index
> > +        * table if needed.
> > +        */
> > +       shstrndx = ehdr.e_shstrndx;
> > +       if (shstrndx == SHN_XINDEX && elf_getshdrstrndx(elf, &shstrndx))
> > +               goto done;
> 
> just use elf_getshdrstrndx() unconditionally, it works for extended
> and non-extended numbering (see libbpf.c).

Yeah, we even have this in tools/perf/util/symbol-elf.c:

#ifndef HAVE_ELF_GETSHDRSTRNDX_SUPPORT
static int elf_getshdrstrndx(Elf *elf __maybe_unused, size_t *dst __maybe_unused)
{
        pr_err("%s: update your libelf to > 0.140, this one lacks elf_getshdrstrndx().\n", __func__);
        return -1;
}
#endif

And a feature detection for that:

[acme@five perf]$ cat tools/build/feature/test-libelf-getshdrstrndx.c 
// SPDX-License-Identifier: GPL-2.0
#include <libelf.h>

int main(void)
{
	size_t dst;

	return elf_getshdrstrndx(0, &dst);
}
[acme@five perf]$ 

Your implementation would provide a good fallback tho to avoid requiring
updating to 0.140 :-)

- Arnaldo

> > +
> > +       if (!elf_rawdata(elf_getscn(elf, shstrndx), NULL)) {
> >                 pr_warn("failed to get e_shstrndx from %s\n", path);
> >                 goto done;
> >         }
> > @@ -902,7 +912,7 @@ static struct btf *btf_parse_elf(const char *path, struct btf *base_btf,
> >                                 idx, path);
> >                         goto done;
> >                 }
> > -               name = elf_strptr(elf, ehdr.e_shstrndx, sh.sh_name);
> > +               name = elf_strptr(elf, shstrndx, sh.sh_name);
> >                 if (!name) {
> >                         pr_warn("failed to get section(%d) name from %s\n",
> >                                 idx, path);
> > --
> > 2.27.0
> >

-- 

- Arnaldo

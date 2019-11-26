Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC09410A658
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfKZWFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:05:55 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:41828 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZWFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:05:55 -0500
Received: by mail-qv1-f66.google.com with SMTP id g18so8015534qvp.8;
        Tue, 26 Nov 2019 14:05:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rNAJRing75po09Z/0ejdXBvQfJUb9CnK/Uxvx5KAC40=;
        b=Q1/FLfNmv83OvdhDznuTzXLJKbrJ23JcBUnyPE1/jpG8TZdzZ0E5Oqq28DFQhqWx5A
         7eLtATT2Qyz2AAaipJINM/D35Ie8MGuVDjIGhBDTdOXQt6aurQ0P1JY3wq2cRSLWHnv0
         XaCD667SFzwY3+9uzhIkj36OQ7SqclKiZMT7uTAGG+mgpl0XrqSfXTt7iO+VwrW4xH9H
         AAXdtl2FuzSHw0uVwY4SkyK3KtI/cLTsLmWHRJcPtmq+538/AzbNJ4mODgL5cNDwvlad
         NotgJUH9X8IhlmTq0baKmmeof078eSF5sfE9xUa1hTMMvGDaM0DP15jw4Wf0Z18iPQQc
         JSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rNAJRing75po09Z/0ejdXBvQfJUb9CnK/Uxvx5KAC40=;
        b=U8Xihk8Td8xAT2MrsTvp5QQhLSevYDjr5EswU8yMDA2hl+z+JhgUtJyaoB7ey32OY7
         nuUjAXp9/eObqFsIMfWb8gmGhYOUPhAO9pvzKpwPO2z2Tfik1LWsBXQ0n7PgrkqPbb9d
         Y6YD/2Awr/09bVnBW2K9h9CyLV2EOqDCAap8PTJIb5u5PPzBWyACTjy/ErOe+HeAbDQ4
         eBPtTK7gsRn1S2oLmXrhnBXSOxkjqhTAnv/YJSqoMnSNU6n/exI8tZ502xBVskZ1Ea2l
         OPmfxQERKLgbbJLMTTYn4K4KVCjNDBxykZURsmH8Zm/FJeWsrJ+rFyP+ddzS1QXsa+cV
         5YLw==
X-Gm-Message-State: APjAAAXEBZZFy+tF+OORCQ5Vz/CF5IHIq9v4qH2oHI6OHZnBAvcZdqe7
        9a3K+s2lnNdN1YKPGhq9abmgXXfNJOc8M7joZSk=
X-Google-Smtp-Source: APXvYqxlAAM0eY3n8YOdCkAQS9DMx5KdHoRh+CWGgA8fBilgaXtdPjuBd/D+0q6Z2mP93m8TBcbyd2c7Opf24huWZdM=
X-Received: by 2002:a05:6214:90f:: with SMTP id dj15mr1177784qvb.224.1574805952752;
 Tue, 26 Nov 2019 14:05:52 -0800 (PST)
MIME-Version: 1.0
References: <20191126151045.GB19483@kernel.org> <20191126154836.GC19483@kernel.org>
 <87imn6y4n9.fsf@toke.dk> <20191126183451.GC29071@kernel.org>
 <87d0dexyij.fsf@toke.dk> <20191126190450.GD29071@kernel.org>
In-Reply-To: <20191126190450.GD29071@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 26 Nov 2019 14:05:41 -0800
Message-ID: <CAEf4Bzbq3J9g7cP=KMqR=bMFcs=qPiNZwnkvCKz3-SAp_m0GzA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 11:12 AM Arnaldo Carvalho de Melo
<arnaldo.melo@gmail.com> wrote:
>
> Em Tue, Nov 26, 2019 at 07:50:44PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n escreveu:
> > Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> >
> > > Em Tue, Nov 26, 2019 at 05:38:18PM +0100, Toke H=C3=B8iland-J=C3=B8rg=
ensen escreveu:
> > >> Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com> writes:
> > >>
> > >> > Em Tue, Nov 26, 2019 at 12:10:45PM -0300, Arnaldo Carvalho de Melo=
 escreveu:
> > >> >> Hi guys,
> > >> >>
> > >> >>    While merging perf/core with mainline I found the problem belo=
w for
> > >> >> which I'm adding this patch to my perf/core branch, that soon wil=
l go
> > >> >> Ingo's way, etc. Please let me know if you think this should be h=
andled
> > >> >> some other way,
> > >> >
> > >> > This is still not enough, fails building in a container where all =
we
> > >> > have is the tarball contents, will try to fix later.
> > >>
> > >> Wouldn't the right thing to do not be to just run the script, and th=
en
> > >> put the generated bpf_helper_defs.h into the tarball?
>
> > > I would rather continue just running tar and have the build process
> > > in-tree or outside be the same.
> >
> > Hmm, right. Well that Python script basically just parses
> > include/uapi/linux/bpf.h; and it can be given the path of that file wit=
h
> > the --filename argument. So as long as that file is present, it should
> > be possible to make it work, I guess?
>
> > However, isn't the point of the tarball to make a "stand-alone" source
> > distribution?
>
> Yes, it is, and as far as possible without any prep, just include the
> in-source tree files needed to build it.
>
> > I'd argue that it makes more sense to just include the
> > generated header, then: The point of the Python script is specifically
> > to extract the latest version of the helper definitions from the kernel
> > source tree. And if you're "freezing" a version into a tarball, doesn't
> > it make more sense to also freeze the list of BPF helpers?
>
> Your suggestion may well even be the only solution, as older systems
> don't have python3, and that script requires it :-\
>
> Some containers were showing this:
>
> /bin/sh: 1: /git/linux/scripts/bpf_helpers_doc.py: not found
> Makefile:184: recipe for target 'bpf_helper_defs.h' failed
> make[3]: *** [bpf_helper_defs.h] Error 127
> make[3]: *** Deleting file 'bpf_helper_defs.h'
> Makefile.perf:778: recipe for target '/tmp/build/perf/libbpf.a' failed
>
> That "not found" doesn't mean what it looks from staring at the above,
> its just that:
>
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$ head -1 /tmp/perf-5.4.0/scripts/bpf_=
helpers_doc.py
> #!/usr/bin/python3
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$ ls -la /usr/bin/python3
> ls: cannot access /usr/bin/python3: No such file or directory
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$
>
> So, for now, I'll keep my fix and start modifying the containers where
> this fails and disable testing libbpf/perf integration with BPF on those
> containers :-\

I don't think there is anything Python3-specific in that script. I
changed first line to

#!/usr/bin/env python

and it worked just fine. Do you mind adding this fix and make those
older containers happy(-ier?).

>
> I.e. doing:
>
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$ make NO_LIBBPF=3D1 -C /tmp/perf-5.4.=
0/tools/perf/ O=3D/tmp/build/perf
>
> which ends up with a functional perf, just one without libbpf linked in:
>
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$ /tmp/build/perf/perf -vv
> perf version 5.4.gf69779ce8f86
>                  dwarf: [ on  ]  # HAVE_DWARF_SUPPORT
>     dwarf_getlocations: [ OFF ]  # HAVE_DWARF_GETLOCATIONS_SUPPORT
>                  glibc: [ on  ]  # HAVE_GLIBC_SUPPORT
>                   gtk2: [ on  ]  # HAVE_GTK2_SUPPORT
>          syscall_table: [ on  ]  # HAVE_SYSCALL_TABLE_SUPPORT
>                 libbfd: [ on  ]  # HAVE_LIBBFD_SUPPORT
>                 libelf: [ on  ]  # HAVE_LIBELF_SUPPORT
>                libnuma: [ OFF ]  # HAVE_LIBNUMA_SUPPORT
> numa_num_possible_cpus: [ OFF ]  # HAVE_LIBNUMA_SUPPORT
>                libperl: [ on  ]  # HAVE_LIBPERL_SUPPORT
>              libpython: [ on  ]  # HAVE_LIBPYTHON_SUPPORT
>               libslang: [ on  ]  # HAVE_SLANG_SUPPORT
>              libcrypto: [ on  ]  # HAVE_LIBCRYPTO_SUPPORT
>              libunwind: [ on  ]  # HAVE_LIBUNWIND_SUPPORT
>     libdw-dwarf-unwind: [ on  ]  # HAVE_DWARF_SUPPORT
>                   zlib: [ on  ]  # HAVE_ZLIB_SUPPORT
>                   lzma: [ on  ]  # HAVE_LZMA_SUPPORT
>              get_cpuid: [ on  ]  # HAVE_AUXTRACE_SUPPORT
>                    bpf: [ OFF ]  # HAVE_LIBBPF_SUPPORT
>                    aio: [ on  ]  # HAVE_AIO_SUPPORT
>                   zstd: [ OFF ]  # HAVE_ZSTD_SUPPORT
> nobody@1fb841e33ba3:/tmp/perf-5.4.0$
>
> The the build tests for libbpf and the bpf support in perf will
> continue, but for a reduced set of containers, those with python3.
>
> People wanting to build libbpf on such older systems will hopefully find
> this discussion in google, run the script, get the output and have it
> working.
>
> - Arnaldo

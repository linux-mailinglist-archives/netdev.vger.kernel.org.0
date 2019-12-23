Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568021291C8
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 07:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbfLWGJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 01:09:37 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38619 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbfLWGJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 01:09:37 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so15088251wmc.3;
        Sun, 22 Dec 2019 22:09:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kBek2qMpkl76XzsVkCJQfX3XYSAhe9VKKtzp8ddYINw=;
        b=QLqFEjkxit+AHR2YIaqlGQBzXeEdZNYEsnovuK8u1VnQuJ9YuuMu2HHVwyzXFH4Qaa
         iEsSAIdwrDakK5vffy94ciajrYMEqezGrO7jbn8M/3W6By2TxsumAwwN5cA60BUBvXvb
         Kl4FPZXm4U6/avPEal/PbEaSps8EXzsmVxT1E3j1bpI6AZACqQ0XTfnJ44Kyiz2qo08h
         rxyy4GKRyVsMLxM+U46w+f38Wfa620SD0MP4IhxPjXVRLCcLVi3Q89PNjQIt5A2+3tHp
         63yDzFFHW+45pPCOMk7q/XQ/3rRVAZFB0fohk04ca13bW3LmN+F9W8uJ89fG2rQJoqcf
         Qh3w==
X-Gm-Message-State: APjAAAXEpXNc+5xTrfVYn7xj98rRsMLwPSRLjazkcGqN0qIGZO0HmSj0
        L2IXSNDYEl25nO0KmosF7ahO1oiFXn0VyU/PVlU=
X-Google-Smtp-Source: APXvYqzduGzxW0Eq8AtIuTC/t2Jdrao10koS+96PhhcRz3RUy8glgGTBnhBhSnilH6eoF1DYQito+ijf/Sp8rKfGPwY=
X-Received: by 2002:a7b:c5d8:: with SMTP id n24mr28455099wmk.124.1577081374906;
 Sun, 22 Dec 2019 22:09:34 -0800 (PST)
MIME-Version: 1.0
References: <20191221162158.rw6xqqktubozg6fg@ast-mbp.dhcp.thefacebook.com>
 <20191223030530.725937-1-namhyung@kernel.org> <CAEf4BzaGfsF352kWu1zZe+yXSRm4c9LQ0U57VnRq2EdtjeQutw@mail.gmail.com>
 <CAEf4BzbyBgDN5svEcfpyjoViixhn2iGBs1j+jyvNhfjPp_1E=w@mail.gmail.com>
In-Reply-To: <CAEf4BzbyBgDN5svEcfpyjoViixhn2iGBs1j+jyvNhfjPp_1E=w@mail.gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
Date:   Mon, 23 Dec 2019 15:09:23 +0900
Message-ID: <CAM9d7ch1=pmgkFbgGr2YignQwdNjke2QeOAFLCFYu8L8J-Z8vw@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Fix build on read-only filesystems
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-perf-users <linux-perf-users@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, Dec 23, 2019 at 2:55 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Dec 22, 2019 at 9:45 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > On Sun, Dec 22, 2019 at 7:05 PM Namhyung Kim <namhyung@kernel.org> wrote:
> > >
> > > I got the following error when I tried to build perf on a read-only
> > > filesystem with O=dir option.
> > >
> > >   $ cd /some/where/ro/linux/tools/perf
> > >   $ make O=$HOME/build/perf
> > >   ...
> > >     CC       /home/namhyung/build/perf/lib.o
> > >   /bin/sh: bpf_helper_defs.h: Read-only file system
> > >   make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 1
> > >   make[2]: *** [Makefile.perf:778: /home/namhyung/build/perf/libbpf.a] Error 2
> > >   make[2]: *** Waiting for unfinished jobs....
> > >     LD       /home/namhyung/build/perf/libperf-in.o
> > >     AR       /home/namhyung/build/perf/libperf.a
> > >     PERF_VERSION = 5.4.0
> > >   make[1]: *** [Makefile.perf:225: sub-make] Error 2
> > >   make: *** [Makefile:70: all] Error 2
> > >
> > > It was becaused bpf_helper_defs.h was generated in current directory.
> > > Move it to OUTPUT directory.
> > >
> > > Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> > > ---
> >
> > Looks good, thanks!
>
> just one minor thing: bpf_helper_defs.h has to be added to .gitignore
> under selftests/bpf now
>
> >
> > Tested-by: Andrii Nakryiko <andriin@fb.com>
> > Acked-by: Andrii Nakryiko <andriin@fb.com>

Thanks a lot for the review, I'll send v3 soon

Thanks
Namhyung

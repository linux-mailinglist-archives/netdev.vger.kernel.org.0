Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 650F110A281
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 17:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbfKZQyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 11:54:09 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:39380 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbfKZQyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 11:54:08 -0500
Received: by mail-lj1-f193.google.com with SMTP id e10so11893919ljj.6;
        Tue, 26 Nov 2019 08:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K8Udhqf472lBzZGhoQZMM7y7CbUcEQYl8y6SXBB09A8=;
        b=cXy/I5IypqlHmRe7XcWCQmZnLkDsUML/aT8hb9JlJps9b7W0dTyZVEm832FmmYVmIF
         WXFky6MfaJKgp5xbIldzGnmD+kSKl6Wx0uHdYq//24NjCGrhfs/4rWuI1REArv+nhLpX
         CuGSbC3wNoquk+HjXJZWmGN3hiSxa/zZoEH1OvxyTLWtxVbfU807VowgaqYmhRkRXzvN
         5E7vqqK1k8djaD7HGv2/DOORZY+sk1tB0eWgEwGx0QMGfFNPsHifWYkQ6KW5h65N+8CL
         FADRTvqwUWWJdZbAvqHtLcDmm06MyVPB0PLNA+7xYERO55bgJegg09mO7MNkdsU3wFq1
         tnaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K8Udhqf472lBzZGhoQZMM7y7CbUcEQYl8y6SXBB09A8=;
        b=fkH2Q5JUMZoakR8pZgBDed3ZMDHVWpvicn+pHeq5eJOKYdyUdAY7LKoR8MWk5gMaKf
         VH2pMMtDGIJ6tiOcUtYGudhTtnkFXGfiALaCKYqCRSc3EwnF1gUeqs1S9UDQplt4i5l1
         I9tmX5OhHX46uC6QY4SCVRcXtzNySsCsS7zMtSKJBfiFcOhobE2UZddBuDavP6f9Q/LR
         1Z9fm0sgiHnKv/eMvrIa8j4BcIjCBUSiuOdXuJ2MVxMaOZ0Or3J7utT1QmQ7tstDxEMN
         h1Rf0mhhEvtFaZtJ+vEefxf8ZG2vLD5tbMK3q0JLBsUAbjLBOP+FJxFeDL8dA3/Un+1K
         pq2Q==
X-Gm-Message-State: APjAAAUKXypCST1hk/Uj5WUDFith/AMONCro7DU8IKkaVXXABpQ484ys
        pXkNEZ/yejqqngX8oimhW+ADkmZiOoOvpKHOA0I=
X-Google-Smtp-Source: APXvYqxCksj6Q0jh/LIY76QT1NETLqc44xpSKeaEsxKH43hRYNRscEJP+gKOtzd4UuIc+rl+0QQxVc/sqXKsIPcWpMk=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr27246616ljj.243.1574787245406;
 Tue, 26 Nov 2019 08:54:05 -0800 (PST)
MIME-Version: 1.0
References: <20191126151045.GB19483@kernel.org>
In-Reply-To: <20191126151045.GB19483@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 26 Nov 2019 08:53:53 -0800
Message-ID: <CAADnVQLfyDChpDeo0VQUwZ+M6+ivAKvfqWRAieYZVco6AKugpg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix up generation of bpf_helper_defs.h
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Namhyung Kim <namhyung@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-perf-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 26, 2019 at 7:10 AM Arnaldo Carvalho de Melo
<acme@kernel.org> wrote:
>
> Hi guys,
>
>    While merging perf/core with mainline I found the problem below for
> which I'm adding this patch to my perf/core branch, that soon will go
> Ingo's way, etc. Please let me know if you think this should be handled
> some other way,
>
> Thanks,
>
> - Arnaldo
>
> commit 94b2e22463f592d2161eb491ddb0b4659e2a91b4
> Author: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date:   Tue Nov 26 11:46:08 2019 -0300
>
>     libbpf: Fix up generation of bpf_helper_defs.h
>
>     Building perf as a detached tarball, i.e. by using one of:
>
>       $ make help | grep perf
>         perf-tar-src-pkg    - Build perf-5.4.0.tar source tarball
>         perf-targz-src-pkg  - Build perf-5.4.0.tar.gz source tarball
>         perf-tarbz2-src-pkg - Build perf-5.4.0.tar.bz2 source tarball
>         perf-tarxz-src-pkg  - Build perf-5.4.0.tar.xz source tarball
>       $
>
>     And then trying to build the resulting tarball, which is the first thing
>     that running:
>
>       $ make -C tools/perf build-test
>
>     does, ends up with these two problems:
>
>       make[3]: *** No rule to make target '/tmp/tmp.zq13cHILGB/perf-5.3.0/include/uapi/linux/bpf.h', needed by 'bpf_helper_defs.h'.  Stop.
>       make[3]: *** Waiting for unfinished jobs....
>       make[2]: *** [Makefile.perf:757: /tmp/tmp.zq13cHILGB/perf-5.3.0/tools/lib/bpf/libbpf.a] Error 2
>       make[2]: *** Waiting for unfinished jobs....
>
>     Because $(srcdir) points to the /tmp/tmp.zq13cHILGB/perf-5.3.0 directory
>     and we need '/tools/ after that variable, and after fixing this then we
>     get to another problem:
>
>       /bin/sh: /home/acme/git/perf/tools/scripts/bpf_helpers_doc.py: No such file or directory
>       make[3]: *** [Makefile:184: bpf_helper_defs.h] Error 127
>       make[3]: *** Deleting file 'bpf_helper_defs.h'
>         LD       /tmp/build/perf/libapi-in.o
>       make[2]: *** [Makefile.perf:778: /tmp/build/perf/libbpf.a] Error 2
>       make[2]: *** Waiting for unfinished jobs....
>
>     Because this requires something outside the tools/ directories that gets
>     collected into perf's detached tarballs, to fix it just add it to
>     tools/perf/MANIFEST, which this patch does, now it works for that case
>     and also for all these other cases after doing a:
>
>       $ make -C tools clean
>
>     On a kernel sources directory:
>
>       $ make -C tools/bpf/bpftool/
>       make: Entering directory '/home/acme/git/perf/tools/bpf/bpftool'
>
>       Auto-detecting system features:
>       ...                        libbfd: [ on  ]
>       ...        disassembler-four-args: [ on  ]
>       ...                          zlib: [ on  ]
>
>         CC       map_perf_ring.o
>       <SNIP>
>         CC       disasm.o
>       make[1]: Entering directory '/home/acme/git/perf/tools/lib/bpf'
>
>       Auto-detecting system features:
>       ...                        libelf: [ on  ]
>       ...                           bpf: [ on  ]
>
>         MKDIR    staticobjs/
>         CC       staticobjs/libbpf.o
>       <SNIP>
>         LD       staticobjs/libbpf-in.o
>         LINK     libbpf.a
>       make[1]: Leaving directory '/home/acme/git/perf/tools/lib/bpf'
>         LINK     bpftool
>       make: Leaving directory '/home/acme/git/perf/tools/bpf/bpftool'
>       $
>
>       $ make -C tools/perf
>       <SNIP>
>       Auto-detecting system features:
>       ...                         dwarf: [ on  ]
>       ...            dwarf_getlocations: [ on  ]
>       ...                         glibc: [ on  ]
>       ...                          gtk2: [ on  ]
>       ...                      libaudit: [ on  ]
>       ...                        libbfd: [ on  ]
>       ...                        libcap: [ on  ]
>       ...                        libelf: [ on  ]
>       ...                       libnuma: [ on  ]
>       ...        numa_num_possible_cpus: [ on  ]
>       ...                       libperl: [ on  ]
>       ...                     libpython: [ on  ]
>       ...                     libcrypto: [ on  ]
>       ...                     libunwind: [ on  ]
>       ...            libdw-dwarf-unwind: [ on  ]
>       ...                          zlib: [ on  ]
>       ...                          lzma: [ on  ]
>       ...                     get_cpuid: [ on  ]
>       ...                           bpf: [ on  ]
>       ...                        libaio: [ on  ]
>       ...                       libzstd: [ on  ]
>       ...        disassembler-four-args: [ on  ]
>
>         GEN      common-cmds.h
>         CC       exec-cmd.o
>         <SNIP>
>         CC       util/pmu.o
>         CC       util/pmu-flex.o
>         LD       util/perf-in.o
>         LD       perf-in.o
>         LINK     perf
>       make: Leaving directory '/home/acme/git/perf/tools/perf'
>       $
>
>       $ make -C tools/lib/bpf
>       make: Entering directory '/home/acme/git/perf/tools/lib/bpf'
>
>       Auto-detecting system features:
>       ...                        libelf: [ on  ]
>       ...                           bpf: [ on  ]
>
>         HOSTCC   fixdep.o
>         HOSTLD   fixdep-in.o
>         LINK     fixdep
>       Parsed description of 117 helper function(s)
>         MKDIR    staticobjs/
>         CC       staticobjs/libbpf.o
>         CC       staticobjs/bpf.o
>         CC       staticobjs/nlattr.o
>         CC       staticobjs/btf.o
>         CC       staticobjs/libbpf_errno.o
>         CC       staticobjs/str_error.o
>         CC       staticobjs/netlink.o
>         CC       staticobjs/bpf_prog_linfo.o
>         CC       staticobjs/libbpf_probes.o
>         CC       staticobjs/xsk.o
>         CC       staticobjs/hashmap.o
>         CC       staticobjs/btf_dump.o
>         LD       staticobjs/libbpf-in.o
>         LINK     libbpf.a
>         MKDIR    sharedobjs/
>         CC       sharedobjs/libbpf.o
>         CC       sharedobjs/bpf.o
>         CC       sharedobjs/nlattr.o
>         CC       sharedobjs/btf.o
>         CC       sharedobjs/libbpf_errno.o
>         CC       sharedobjs/str_error.o
>         CC       sharedobjs/netlink.o
>         CC       sharedobjs/bpf_prog_linfo.o
>         CC       sharedobjs/libbpf_probes.o
>         CC       sharedobjs/xsk.o
>         CC       sharedobjs/hashmap.o
>         CC       sharedobjs/btf_dump.o
>         LD       sharedobjs/libbpf-in.o
>         LINK     libbpf.so.0.0.6
>         GEN      libbpf.pc
>         LINK     test_libbpf
>       make: Leaving directory '/home/acme/git/perf/tools/lib/bpf'
>       $
>
>     Fixes: e01a75c15969 ("libbpf: Move bpf_{helpers, helper_defs, endian, tracing}.h into libbpf")
>     Cc: Adrian Hunter <adrian.hunter@intel.com>
>     Cc: Alexei Starovoitov <ast@kernel.org>
>     Cc: Andrii Nakryiko <andriin@fb.com>
>     Cc: Daniel Borkmann <daniel@iogearbox.net>
>     Cc: Jiri Olsa <jolsa@kernel.org>
>     Cc: Martin KaFai Lau <kafai@fb.com>
>     Cc: Namhyung Kim <namhyung@kernel.org>
>     Link: https://lkml.kernel.org/n/tip-4pnkg2vmdvq5u6eivc887wen@git.kernel.org
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index 99425d0be6ff..8ec6bc4e5e46 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -180,9 +180,9 @@ $(BPF_IN_SHARED): force elfdep bpfdep bpf_helper_defs.h
>  $(BPF_IN_STATIC): force elfdep bpfdep bpf_helper_defs.h
>         $(Q)$(MAKE) $(build)=libbpf OUTPUT=$(STATIC_OBJDIR)
>
> -bpf_helper_defs.h: $(srctree)/include/uapi/linux/bpf.h
> +bpf_helper_defs.h: $(srctree)/tools/include/uapi/linux/bpf.h
>         $(Q)$(srctree)/scripts/bpf_helpers_doc.py --header              \
> -               --file $(srctree)/include/uapi/linux/bpf.h > bpf_helper_defs.h
> +               --file $(srctree)/tools/include/uapi/linux/bpf.h > bpf_helper_defs.h

fwiw. this bit looks good. Makes sense to do regardless.

>  $(OUTPUT)libbpf.so: $(OUTPUT)libbpf.so.$(LIBBPF_VERSION)
>
> diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
> index 70f1ff4e2eb4..4934edb5adfd 100644
> --- a/tools/perf/MANIFEST
> +++ b/tools/perf/MANIFEST
> @@ -19,3 +19,4 @@ tools/lib/bitmap.c
>  tools/lib/str_error_r.c
>  tools/lib/vsprintf.c
>  tools/lib/zalloc.c
> +scripts/bpf_helpers_doc.py

This one I don't understand. I couldn't find any piece that uses this file.
Some out of tree usage?

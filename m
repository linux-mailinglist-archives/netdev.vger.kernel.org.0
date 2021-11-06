Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E66B4470A6
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 22:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235136AbhKFVWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 17:22:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233912AbhKFVWz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 17:22:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16E7861139;
        Sat,  6 Nov 2021 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636233613;
        bh=En7ugPZwMj4wEOcXJ2z95aMtHtRSF4XCmNpI+QBG1nk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nib81Xv8Z6A/Gb8YlZgPUiGfIaETHFoBUvGGkBi61eSu9y6H+jz/rsF8OsjI06PCb
         akZZTjGQQc8pKXDc3Z44D3YD6/bTskMCb5OTPd3I3iylM1OX9jERjFYHWrrnqK6UT4
         PNJBQp7AqqgtaFBlXI9og0OoYG8lHBzLCI0TZGAn5HGZ9ISYvi5PdEqtBhg+01OiXk
         JkA/Ddgt+20fdHSwjhWoxw5N6V7QTe0RUoRWzNt/8EpfN4uDWuF0Va4Lj/bNYgYOJy
         nygT5z6epy3bFHLIK9WLCU/rjBK4RdXsm0axWKJmjyzOISB1Zne+wzIFEKL3UQ9rX0
         XmCCnjas/eslw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 97558410A1; Sat,  6 Nov 2021 18:20:10 -0300 (-03)
Date:   Sat, 6 Nov 2021 18:20:10 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] Re: [PATCH bpf-next] perf build: Install libbpf headers
 locally when building
Message-ID: <YYbxigLXFkomexsZ@kernel.org>
References: <20211105020244.6869-1-quentin@isovalent.com>
 <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
 <YYbXjE1aAdNjI+aY@kernel.org>
 <YYbhwPnn4OvnybzQ@kernel.org>
 <YYbuA347Y5nMJ4Xm@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYbuA347Y5nMJ4Xm@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Nov 06, 2021 at 06:05:07PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Sat, Nov 06, 2021 at 05:12:48PM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Sat, Nov 06, 2021 at 04:29:16PM -0300, Arnaldo Carvalho de Melo escreveu:
> > > Em Fri, Nov 05, 2021 at 11:38:50AM -0700, Andrii Nakryiko escreveu:
> > > > On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent.com> wrote:
> > > > >
> > > > > API headers from libbpf should not be accessed directly from the
> > > > > library's source directory. Instead, they should be exported with "make
> > > > > install_headers". Let's adjust perf's Makefile to install those headers
> > > > > locally when building libbpf.
> > > > >
> > > > > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > > > > ---
> > > > > Note: Sending to bpf-next because it's directly related to libbpf, and
> > > > > to similar patches merged through bpf-next, but maybe Arnaldo prefers to
> > > > > take it?
> > > > 
> > > > Arnaldo would know better how to thoroughly test it, so I'd prefer to
> > > > route this through perf tree. Any objections, Arnaldo?
> > > 
> > > Preliminary testing passed for 'BUILD_BPF_SKEL=1' with without
> > > LIBBPF_DYNAMIC=1 (using the system's libbpf-devel to build perf), so far
> > > so good, so I tentatively applied it, will see with the full set of
> > > containers.
> > 
> > Because all the preliminary tests used O= to have that OUTPUT variable
> > set, when we do simply:
> > 
> > 	make -C tools/perf
> 
> So I'll have to remove it now as my container builds test both O= and
> in-place builds (make -C tools/perf), I know many people (Jiri for
> instance) don't use O=.
> 
> I tried to fix this but run out of time today, visits arriving soon, so
> I'll try to come back to this tomorrow early morning, to push what I
> have in to Linus, that is blocked by this now :-\

What I have, with your patch, is at:

git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git tmp.perf/core

It has both patches, as its needed for the BUILD_BPF_SKEL=1 mode to
build correctly with/without LIBBPF_DYNAMIC=1.

- Arnaldo
 
> - Arnaldo
>  
> > it breaks:
> > 
> > ⬢[acme@toolbox perf]$ make -C tools clean > /dev/null 2>&1
> > ⬢[acme@toolbox perf]$ make JOBS=1 -C tools/perf
> > make: Entering directory '/var/home/acme/git/perf/tools/perf'
> >   BUILD:   Doing 'make -j1' parallel build
> >   HOSTCC  fixdep.o
> >   HOSTLD  fixdep-in.o
> >   LINK    fixdep
> > <SNIP ABI sync warnings>
> > 
> > Auto-detecting system features:
> > ...                         dwarf: [ on  ]
> > ...            dwarf_getlocations: [ on  ]
> > ...                         glibc: [ on  ]
> > ...                        libbfd: [ on  ]
> > ...                libbfd-buildid: [ on  ]
> > ...                        libcap: [ on  ]
> > ...                        libelf: [ on  ]
> > ...                       libnuma: [ on  ]
> > ...        numa_num_possible_cpus: [ on  ]
> > ...                       libperl: [ on  ]
> > ...                     libpython: [ on  ]
> > ...                     libcrypto: [ on  ]
> > ...                     libunwind: [ on  ]
> > ...            libdw-dwarf-unwind: [ on  ]
> > ...                          zlib: [ on  ]
> > ...                          lzma: [ on  ]
> > ...                     get_cpuid: [ on  ]
> > ...                           bpf: [ on  ]
> > ...                        libaio: [ on  ]
> > ...                       libzstd: [ on  ]
> > ...        disassembler-four-args: [ on  ]
> > 
> > 
> >   CC      fd/array.o
> >   LD      fd/libapi-in.o
> >   CC      fs/fs.o
> >   CC      fs/tracing_path.o
> >   CC      fs/cgroup.o
> >   LD      fs/libapi-in.o
> >   CC      cpu.o
> >   CC      debug.o
> >   CC      str_error_r.o
> >   LD      libapi-in.o
> >   AR      libapi.a
> >   CC      exec-cmd.o
> >   CC      help.o
> >   CC      pager.o
> >   CC      parse-options.o
> >   CC      run-command.o
> >   CC      sigchain.o
> >   CC      subcmd-config.o
> >   LD      libsubcmd-in.o
> >   AR      libsubcmd.a
> >   CC      core.o
> >   CC      cpumap.o
> >   CC      threadmap.o
> >   CC      evsel.o
> >   CC      evlist.o
> >   CC      mmap.o
> >   CC      zalloc.o
> >   CC      xyarray.o
> >   CC      lib.o
> >   LD      libperf-in.o
> >   AR      libperf.a
> > make[2]: *** No rule to make target 'libbpf', needed by 'libbpf/libbpf.a'.  Stop.
> > make[1]: *** [Makefile.perf:240: sub-make] Error 2
> > make: *** [Makefile:70: all] Error 2
> > make: Leaving directory '/var/home/acme/git/perf/tools/perf'
> > ⬢[acme@toolbox perf]$
> > 
> > Trying to fix...
> > 
> > - Arnaldo
> 
> -- 
> 
> - Arnaldo

-- 

- Arnaldo

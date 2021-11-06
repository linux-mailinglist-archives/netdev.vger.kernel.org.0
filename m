Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3532644705B
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 21:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhKFUPe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Nov 2021 16:15:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:56786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229598AbhKFUPd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 6 Nov 2021 16:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B667461058;
        Sat,  6 Nov 2021 20:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636229571;
        bh=VExLNn2H7AysruulvVY/PSyrJByHUoO+ctvfj3Yeg0s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpfWVJYmndSZxfdMLc7vMgX70OE7eQczm/sezO3uy4rNKm483WTP2zktP637sKROi
         Os8s76dB5XGZy6ePPiGhFOAaHFQFZGwv/ShwoUURVYREgOg768OmlsBnCMRU6CrMgZ
         B9wgcii/xZIUDD8KE+RcSZHW/s7VjL/5PeRBX7o6dWqPEpvuQjt15voLQXQwrghV2d
         39c2lwIZMA6qJXxCHrqgHu7ojYOYVZU/8EkDtRHRCjccl5P3dN/cvlx15kkT/yUXH0
         ZLIdHkYRBCJioikqvr8HC6XzMy8g/WrgqQHPwF+VOV4JABTCwrn6VWgHmUAgauf4Uq
         I8X3oddq3JZsA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 744E6410A1; Sat,  6 Nov 2021 17:12:48 -0300 (-03)
Date:   Sat, 6 Nov 2021 17:12:48 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next] perf build: Install libbpf headers locally when
 building
Message-ID: <YYbhwPnn4OvnybzQ@kernel.org>
References: <20211105020244.6869-1-quentin@isovalent.com>
 <CAEf4Bza_-vvOXPRZaJzi4YpU5Bfb=werLUFG=Au9DtaanbuArg@mail.gmail.com>
 <YYbXjE1aAdNjI+aY@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YYbXjE1aAdNjI+aY@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Nov 06, 2021 at 04:29:16PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Fri, Nov 05, 2021 at 11:38:50AM -0700, Andrii Nakryiko escreveu:
> > On Thu, Nov 4, 2021 at 7:02 PM Quentin Monnet <quentin@isovalent.com> wrote:
> > >
> > > API headers from libbpf should not be accessed directly from the
> > > library's source directory. Instead, they should be exported with "make
> > > install_headers". Let's adjust perf's Makefile to install those headers
> > > locally when building libbpf.
> > >
> > > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > > ---
> > > Note: Sending to bpf-next because it's directly related to libbpf, and
> > > to similar patches merged through bpf-next, but maybe Arnaldo prefers to
> > > take it?
> > 
> > Arnaldo would know better how to thoroughly test it, so I'd prefer to
> > route this through perf tree. Any objections, Arnaldo?
> 
> Preliminary testing passed for 'BUILD_BPF_SKEL=1' with without
> LIBBPF_DYNAMIC=1 (using the system's libbpf-devel to build perf), so far
> so good, so I tentatively applied it, will see with the full set of
> containers.

Because all the preliminary tests used O= to have that OUTPUT variable
set, when we do simply:

	make -C tools/perf

it breaks:

⬢[acme@toolbox perf]$ make -C tools clean > /dev/null 2>&1
⬢[acme@toolbox perf]$ make JOBS=1 -C tools/perf
make: Entering directory '/var/home/acme/git/perf/tools/perf'
  BUILD:   Doing 'make -j1' parallel build
  HOSTCC  fixdep.o
  HOSTLD  fixdep-in.o
  LINK    fixdep
<SNIP ABI sync warnings>

Auto-detecting system features:
...                         dwarf: [ on  ]
...            dwarf_getlocations: [ on  ]
...                         glibc: [ on  ]
...                        libbfd: [ on  ]
...                libbfd-buildid: [ on  ]
...                        libcap: [ on  ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...        numa_num_possible_cpus: [ on  ]
...                       libperl: [ on  ]
...                     libpython: [ on  ]
...                     libcrypto: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...                          lzma: [ on  ]
...                     get_cpuid: [ on  ]
...                           bpf: [ on  ]
...                        libaio: [ on  ]
...                       libzstd: [ on  ]
...        disassembler-four-args: [ on  ]


  CC      fd/array.o
  LD      fd/libapi-in.o
  CC      fs/fs.o
  CC      fs/tracing_path.o
  CC      fs/cgroup.o
  LD      fs/libapi-in.o
  CC      cpu.o
  CC      debug.o
  CC      str_error_r.o
  LD      libapi-in.o
  AR      libapi.a
  CC      exec-cmd.o
  CC      help.o
  CC      pager.o
  CC      parse-options.o
  CC      run-command.o
  CC      sigchain.o
  CC      subcmd-config.o
  LD      libsubcmd-in.o
  AR      libsubcmd.a
  CC      core.o
  CC      cpumap.o
  CC      threadmap.o
  CC      evsel.o
  CC      evlist.o
  CC      mmap.o
  CC      zalloc.o
  CC      xyarray.o
  CC      lib.o
  LD      libperf-in.o
  AR      libperf.a
make[2]: *** No rule to make target 'libbpf', needed by 'libbpf/libbpf.a'.  Stop.
make[1]: *** [Makefile.perf:240: sub-make] Error 2
make: *** [Makefile:70: all] Error 2
make: Leaving directory '/var/home/acme/git/perf/tools/perf'
⬢[acme@toolbox perf]$

Trying to fix...

- Arnaldo

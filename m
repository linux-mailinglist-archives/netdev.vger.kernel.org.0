Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3182E10D46D
	for <lists+netdev@lfdr.de>; Fri, 29 Nov 2019 11:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfK2Kxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Nov 2019 05:53:37 -0500
Received: from www62.your-server.de ([213.133.104.62]:48334 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbfK2Kxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Nov 2019 05:53:37 -0500
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iadRm-0002FW-5H; Fri, 29 Nov 2019 11:24:22 +0100
Received: from [2a02:1205:507e:bf80:bef8:7f66:49c8:72e5] (helo=pc-11.home)
        by sslproxy06.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iadRl-0003mh-Cc; Fri, 29 Nov 2019 11:24:21 +0100
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, kubakici@wp.pl
References: <20191128160712.1048793-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f6e8f6d2-6155-3b20-9975-81e29e460915@iogearbox.net>
Date:   Fri, 29 Nov 2019 11:24:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20191128160712.1048793-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25647/Thu Nov 28 10:49:14 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/19 5:07 PM, Toke Høiland-Jørgensen wrote:
> From: Jiri Olsa <jolsa@kernel.org>
> 
> Currently we support only static linking with kernel's libbpf
> (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
> that triggers libbpf detection and bpf dynamic linking:
> 
>    $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=1
> 
> If libbpf is not installed, build (with LIBBPF_DYNAMIC=1) stops with:
> 
>    $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=1
>      Auto-detecting system features:
>      ...                        libbfd: [ on  ]
>      ...        disassembler-four-args: [ on  ]
>      ...                          zlib: [ on  ]
>      ...                        libbpf: [ OFF ]
> 
>    Makefile:102: *** Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.
> 
> Adding LIBBPF_DIR compile variable to allow linking with
> libbpf installed into specific directory:
> 
>    $ make -C tools/lib/bpf/ prefix=/tmp/libbpf/ install_lib install_headers
>    $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=1 LIBBPF_DIR=/tmp/libbpf/
> 
> It might be needed to clean build tree first because features
> framework does not detect the change properly:
> 
>    $ make -C tools/build/feature clean
>    $ make -C tools/bpf/bpftool/ clean
> 
> Since bpftool uses bits of libbpf that are not exported as public API in
> the .so version, we also pass in libbpf.a to the linker, which allows it to
> pick up the private functions from the static library without having to
> expose them as ABI.
> 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
> v3:
>    - Keep $(LIBBPF) in $LIBS, and just add -lbpf on top
>    - Fix typo in error message
> v2:
>    - Pass .a file to linker when dynamically linking, so bpftool can use
>      private functions from libbpf without exposing them as API.
> 
>   tools/bpf/bpftool/Makefile | 34 ++++++++++++++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index 39bc6f0f4f0b..15052dcaa39b 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -1,6 +1,15 @@
>   # SPDX-License-Identifier: GPL-2.0-only
> +# LIBBPF_DYNAMIC to enable libbpf dynamic linking.
> +
>   include ../../scripts/Makefile.include
>   include ../../scripts/utilities.mak
> +include ../../scripts/Makefile.arch
> +
> +ifeq ($(LP64), 1)
> +  libdir_relative = lib64
> +else
> +  libdir_relative = lib
> +endif
>   
>   ifeq ($(srctree),)
>   srctree := $(patsubst %/,%,$(dir $(CURDIR)))
> @@ -63,6 +72,19 @@ RM ?= rm -f
>   FEATURE_USER = .bpftool
>   FEATURE_TESTS = libbfd disassembler-four-args reallocarray zlib
>   FEATURE_DISPLAY = libbfd disassembler-four-args zlib
> +ifdef LIBBPF_DYNAMIC
> +  FEATURE_TESTS   += libbpf
> +  FEATURE_DISPLAY += libbpf
> +
> +  # for linking with debug library run:
> +  # make LIBBPF_DYNAMIC=1 LIBBPF_DIR=/opt/libbpf

The Makefile already has BPF_DIR which points right now to '$(srctree)/tools/lib/bpf/'
and LIBBPF_PATH for the final one and where $(LIBBPF_PATH)libbpf.a is expected to reside.
Can't we improve the Makefile to reuse and work with these instead of adding yet another
LIBBPF_DIR var which makes future changes in this area more confusing? The libbpf build
spills out libbpf.{a,so*} by default anyway.

Was wondering whether we could drop LIBBPF_DYNAMIC altogether and have some sort of auto
detection, but given for perf the `make LIBBPF_DYNAMIC=1` option was just applied to perf
tree it's probably better to stay consistent plus static linking would stay as-is for
preferred method for bpftool, so that part seems fine.

> +  ifdef LIBBPF_DIR
> +    LIBBPF_CFLAGS  := -I$(LIBBPF_DIR)/include
> +    LIBBPF_LDFLAGS := -L$(LIBBPF_DIR)/$(libdir_relative)
> +    FEATURE_CHECK_CFLAGS-libbpf  := $(LIBBPF_CFLAGS)
> +    FEATURE_CHECK_LDFLAGS-libbpf := $(LIBBPF_LDFLAGS)
> +  endif
> +endif
>   
>   check_feat := 1
>   NON_CHECK_FEAT_TARGETS := clean uninstall doc doc-clean doc-install doc-uninstall
> @@ -88,6 +110,18 @@ ifeq ($(feature-reallocarray), 0)
>   CFLAGS += -DCOMPAT_NEED_REALLOCARRAY
>   endif
>   
> +ifdef LIBBPF_DYNAMIC
> +  ifeq ($(feature-libbpf), 1)
> +    # bpftool uses non-exported functions from libbpf, so just add the dynamic
> +    # version of libbpf and let the linker figure it out
> +    LIBS    := -lbpf $(LIBS)

Seems okay as a workaround for bpftool and avoids getting into the realm of declaring
libbpf as another half-baked netlink library if we'd have exposed these. Ideally the
netlink symbols shouldn't be needed at all from libbpf, but I presume the rationale
back then was that given it's used internally in libbpf for some of the APIs and was
needed in bpftool's net subcommand as well later on, it avoided duplicating the code
given statically linked and both are in-tree anyway.

> +    CFLAGS  += $(LIBBPF_CFLAGS)
> +    LDFLAGS += $(LIBBPF_LDFLAGS)
> +  else
> +    dummy := $(error Error: No libbpf devel library found, please install libbpf-devel or libbpf-dev.)
> +  endif
> +endif
> +
>   include $(wildcard $(OUTPUT)*.d)
>   
>   all: $(OUTPUT)bpftool
> 

Thanks,
Daniel

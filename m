Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A2355B29E
	for <lists+netdev@lfdr.de>; Sun, 26 Jun 2022 17:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiFZPSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jun 2022 11:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiFZPSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jun 2022 11:18:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316AFD1E;
        Sun, 26 Jun 2022 08:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB4F56128E;
        Sun, 26 Jun 2022 15:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D7BC34114;
        Sun, 26 Jun 2022 15:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656256726;
        bh=OfyIZ2aNwQeuhLBDMPwxc5nqF+GSkCgpyg8gVm/NQEM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NiTWeoQ+Pwq4w5SvvhHHG5XMx/B4B94NQm/vC1/y6dpDqeEuBhr3He3hxp08Sd38o
         c+8I2P6bHAHFTOBXxCWHjjcy//PgoMhgtFPqtnLD7JxAa4VMJZWOfgueW6tMLcHobs
         dapKuCJt11q/jMdeq9yLelu7Ee2hh6SxEvdJPTr7u28EZlX7187MOnS0WXWyKbhvlf
         evBOBMIioJwCipx6iC2EsXj6covjOkpw+eQ81nM66XOhnVZ/oAM0pE6bl96Qmv8FcM
         TZo21vgd8jJDaWd4GHkAkbOQaKqCHqy/pfquaXRjmEvIwKX/gt0uunJykCz3OTNuOV
         nND3rMNxnmVLg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 97AFE4096F; Sun, 26 Jun 2022 12:18:43 -0300 (-03)
Date:   Sun, 26 Jun 2022 12:18:43 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Zixuan Tan <tanzixuangg@gmail.com>, terrelln@fb.com,
        Zixuan Tan <tanzixuan.me@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH] perf build: Suppress openssl v3 deprecation warnings in
 libcrypto feature test
Message-ID: <Yrh40wCIb1zDqTt5@kernel.org>
References: <20220625153439.513559-1-tanzixuan.me@gmail.com>
 <YrhxE4s0hLvbbibp@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YrhxE4s0hLvbbibp@krava>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, Jun 26, 2022 at 04:45:39PM +0200, Jiri Olsa escreveu:
> On Sat, Jun 25, 2022 at 11:34:38PM +0800, Zixuan Tan wrote:
> > With OpenSSL v3 installed, the libcrypto feature check fails as it use the
> > deprecated MD5_* API (and is compiled with -Werror). The error message is
> > as follows.
> > 
> > $ make tools/perf
> > ```
> > Makefile.config:778: No libcrypto.h found, disables jitted code injection,
> > please install openssl-devel or libssl-dev
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
> > ...                     libcrypto: [ OFF ]
> > ...                     libunwind: [ on  ]
> > ...            libdw-dwarf-unwind: [ on  ]
> > ...                          zlib: [ on  ]
> > ...                          lzma: [ on  ]
> > ...                     get_cpuid: [ on  ]
> > ...                           bpf: [ on  ]
> > ...                        libaio: [ on  ]
> > ...                       libzstd: [ on  ]
> > ...        disassembler-four-args: [ on  ]
> > ```
> > 
> > This is very confusing because the suggested library (on my Ubuntu 20.04
> > it is libssl-dev) is already installed. As the test only checks for the
> > presence of libcrypto, this commit suppresses the deprecation warning to
> > allow the test to pass.
> > 
> > Signed-off-by: Zixuan Tan <tanzixuan.me@gmail.com>
> > ---
> >  tools/build/feature/test-libcrypto.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/tools/build/feature/test-libcrypto.c b/tools/build/feature/test-libcrypto.c
> > index a98174e0569c..31afff093d0b 100644
> > --- a/tools/build/feature/test-libcrypto.c
> > +++ b/tools/build/feature/test-libcrypto.c
> > @@ -2,6 +2,12 @@
> >  #include <openssl/sha.h>
> >  #include <openssl/md5.h>
> >  
> > +/*
> > + * The MD5_* API have been deprecated since OpenSSL 3.0, which causes the
> > + * feature test to fail silently. This is a workaround.
> > + */
> 
> then we use these deprecated MD5 calls in util/genelf.c if libcrypto is detected,
> so I wonder how come the rest of the compilation passed for you.. do you have
> CONFIG_JITDUMP disabled?

So, here, on fedora 36:

[acme@quaco perf-urgent]$ m
make: Entering directory '/home/acme/git/perf-urgent/tools/perf'
  BUILD:   Doing 'make -j8' parallel build
  HOSTCC  /tmp/build/perf-urgent/fixdep.o
  HOSTLD  /tmp/build/perf-urgent/fixdep-in.o
  LINK    /tmp/build/perf-urgent/fixdep
Warning: Kernel ABI header at 'tools/include/uapi/linux/kvm.h' differs from latest version at 'include/uapi/linux/kvm.h'
diff -u tools/include/uapi/linux/kvm.h include/uapi/linux/kvm.h
Warning: Kernel ABI header at 'tools/arch/x86/include/asm/disabled-features.h' differs from latest version at 'arch/x86/include/asm/disabled-features.h'
diff -u tools/arch/x86/include/asm/disabled-features.h arch/x86/include/asm/disabled-features.h
Warning: Kernel ABI header at 'tools/arch/arm64/include/uapi/asm/perf_regs.h' differs from latest version at 'arch/arm64/include/uapi/asm/perf_regs.h'
diff -u tools/arch/arm64/include/uapi/asm/perf_regs.h arch/arm64/include/uapi/asm/perf_regs.h
Warning: Kernel ABI header at 'tools/arch/x86/include/uapi/asm/svm.h' differs from latest version at 'arch/x86/include/uapi/asm/svm.h'
diff -u tools/arch/x86/include/uapi/asm/svm.h arch/x86/include/uapi/asm/svm.h
Warning: Kernel ABI header at 'tools/arch/arm64/include/uapi/asm/kvm.h' differs from latest version at 'arch/arm64/include/uapi/asm/kvm.h'
diff -u tools/arch/arm64/include/uapi/asm/kvm.h arch/arm64/include/uapi/asm/kvm.h
Warning: Kernel ABI header at 'tools/include/linux/coresight-pmu.h' differs from latest version at 'include/linux/coresight-pmu.h'
diff -u tools/include/linux/coresight-pmu.h include/linux/coresight-pmu.h
Makefile.config:778: No libcrypto.h found, disables jitted code injection, please install openssl-devel or libssl-dev
Makefile.config:1108: No openjdk development package found, please install JDK package, e.g. openjdk-8-jdk, java-1.8.0-openjdk-devel

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
...                     libcrypto: [ OFF ] <-------------------------------------------------------
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                          zlib: [ on  ]
...                          lzma: [ on  ]
...                     get_cpuid: [ on  ]
...                           bpf: [ on  ]
...                        libaio: [ on  ]
...                       libzstd: [ on  ]
...        disassembler-four-args: [ on  ]


  GEN     /tmp/build/perf-urgent/common-cmds.h
  MKDIR   /tmp/build/perf-urgent/fd/
  CC      /tmp/build/perf-urgent/exec-cmd.o
  CC      /tmp/build/perf-urgent/fd/array.o


But then:

⬢[acme@toolbox perf-urgent]$ perf -vv
perf version 5.19.rc3.gfbec4d8dd3a7
                 dwarf: [ on  ]  # HAVE_DWARF_SUPPORT
    dwarf_getlocations: [ on  ]  # HAVE_DWARF_GETLOCATIONS_SUPPORT
                 glibc: [ on  ]  # HAVE_GLIBC_SUPPORT
         syscall_table: [ on  ]  # HAVE_SYSCALL_TABLE_SUPPORT
                libbfd: [ on  ]  # HAVE_LIBBFD_SUPPORT
            debuginfod: [ on  ]  # HAVE_DEBUGINFOD_SUPPORT
                libelf: [ on  ]  # HAVE_LIBELF_SUPPORT
               libnuma: [ on  ]  # HAVE_LIBNUMA_SUPPORT
numa_num_possible_cpus: [ on  ]  # HAVE_LIBNUMA_SUPPORT
               libperl: [ on  ]  # HAVE_LIBPERL_SUPPORT
             libpython: [ on  ]  # HAVE_LIBPYTHON_SUPPORT
              libslang: [ on  ]  # HAVE_SLANG_SUPPORT
             libcrypto: [ OFF ]  # HAVE_LIBCRYPTO_SUPPORT
             libunwind: [ on  ]  # HAVE_LIBUNWIND_SUPPORT
    libdw-dwarf-unwind: [ on  ]  # HAVE_DWARF_SUPPORT
                  zlib: [ on  ]  # HAVE_ZLIB_SUPPORT
                  lzma: [ on  ]  # HAVE_LZMA_SUPPORT
             get_cpuid: [ on  ]  # HAVE_AUXTRACE_SUPPORT
                   bpf: [ on  ]  # HAVE_LIBBPF_SUPPORT
                   aio: [ on  ]  # HAVE_AIO_SUPPORT
                  zstd: [ on  ]  # HAVE_ZSTD_SUPPORT
               libpfm4: [ OFF ]  # HAVE_LIBPFM
⬢[acme@toolbox perf-urgent]$


But...:

⬢[acme@toolbox perf-urgent]$ ldd ~/bin/perf | grep ssl
	libssl.so.3 => /lib64/libssl.so.3 (0x00007f02dc87e000)
⬢[acme@toolbox perf-urgent]$


- Arnaldo

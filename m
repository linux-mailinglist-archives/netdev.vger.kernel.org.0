Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4FC3F356E
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 22:39:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240043AbhHTUkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 16:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:32908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229811AbhHTUkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 16:40:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6D0461004;
        Fri, 20 Aug 2021 20:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629491966;
        bh=cJx0OoR6MDdNn7IKi5Lc4H3CAFFHIy4NOfoCpJHD7Ho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pIGLTYLiQ7O6nRmGswo5d/WOdbW2npvdptF6DSh7SRWY8f91Q9Uip1/GFeDQNmyhY
         k7mgZ6scAwDBJmOQtkAH2nT3D2O+44Mfbid1Aq3edUMD4TwKHxzVZYIZe0cRU3k1Sk
         a/m+0nUYNIMlG5eYtk1s+kU2kga50xsyOFD/KDKkpgVkvxsrHJD2KtDX0BUjinMNpt
         Opoqe+rslgahQ9UsaPwduVTIrocN0Ivg/rwlzW9sXbvglrysya2HIMLfIikL4By0AL
         RmrQp6cTf/D1pAX0Rtg+HzIl5z3PnMpueyS8czOTN7rpYv7PTzmlseJe04Ndl71css
         hI3JClywhUUYg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id E0E0D4007E; Fri, 20 Aug 2021 17:39:22 -0300 (-03)
Date:   Fri, 20 Aug 2021 17:39:22 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [RFC] dwarves/pahole: Add test scripts
Message-ID: <YSAS+kg3oeCnsuyk@kernel.org>
References: <20210223132321.220570-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210223132321.220570-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Feb 23, 2021 at 02:23:21PM +0100, Jiri Olsa escreveu:
> hi,
> I cleaned up a bit my testing scripts, that I'm using for testing
> btf encoding changes. It's far from ideal and convoluted, but let's
> have discussion if this could be kicked into something useful for
> everybody.
> 
> There are 2 scripts:
>   kernel-objects-build.sh - compiles kernel for several archs and
>                             stores vmlinux and kernel modules
> 
>   kernel-objects-test.sh  - goes through objects stored by ^^^
>                             and runs tests on each of them
> 
> The general idea is that all objects are compiled already with
> BTF debuginfo with available pahole. The test script then:
>   - takes each objects and dumps its current BTF data
>   - then create new BTF data with given pahole binary
>   - dumps the new BTF data and makes the comparison
> 
> I was thinking about support for comparing 2 pahole binaries,
> but so far that did not fit into my workflow. Normally I have
> latest globally available pahole, which is used to build the
> kernel binaries and then I'm playing with new pahole binary,
> which I'm putting to the test.
> 
> Example.. prepare vmlinux and modules for all archs:
> 
>         $ ./kernel-objects-build.sh
>         output:  /tmp/pahole.test.nsQ
>         kdir:    /home/jolsa/linux
>         pahole:  /opt/dwarves/bin/pahole
>         objects: /home/jolsa/.pahole_test_objects
> 
>         cleanup /home/jolsa/linux
>         ...
> 
> All objects are stored under ~/pahole_test_objects/ directories:
> 
>         $ ls ~/.pahole_test_objects/
>         aarch64-clang
>         aarch64-gcc
>         powerpc-gcc
>         powerpcle-gcc
>         s390x-gcc
>         x86-clang
>         x86-gcc
> 
> Each containing vmlinux and modules:
> 
> 	$ ls ~/.pahole_test_objects/x86-gcc/
> 	efivarfs.ko  iptable_nat.ko  nf_log_arp.ko  nf_log_common.ko  nf_log_ipv4.ko  nf_log_ipv6.ko
> 	vmlinux  x86_pkg_temp_thermal.ko  xt_addrtype.ko  xt_LOG.ko  xt_mark.ko  xt_MASQUERADE.ko  xt_nat.ko
> 
> Run test on all of them with new './pahole' binary:
> 
>         $ ./kernel-objects-test.sh -B ~/linux/tools/bpf/bpftool/bpftool -P ./pahole
>         pahole:  /home/jolsa/pahole/build/pahole
>         bpftool: /home/jolsa/linux/tools/bpf/bpftool/bpftool
>         base:    /tmp/pahole.test.oxv
>         objects: /home/jolsa/.pahole_test_objects
>         fail:    no
>         cleanup: yes
> 
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... OK
>         test_btfdiff    on /home/jolsa/.pahole_test_objects/aarch64-clang/vmlinux ... FAIL
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/8021q.ko ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/8021q.ko ... OK
>         test_funcs      on /home/jolsa/.pahole_test_objects/aarch64-clang/act_gact.ko ... OK
>         test_format_c   on /home/jolsa/.pahole_test_objects/aarch64-clang/act_gact.ko ... OK
>         ...
> 
> There are several options that helps to set other binaries/dirs
> or stop and debug issues.
> 
> thoughts?

So far:

should look in other places for getting the kernel sources directory,
myne is at $(HOME)/git/linux/, kernel-objects-build.sh is looking at
$(HOME)/linux/

Maybe we can use this, if there is any locally built kernel:

[acme@quaco pahole]$ ls -la /lib/modules/5.10.0-rc5/source
lrwxrwxrwx. 1 root root 20 Nov 23  2020 /lib/modules/5.10.0-rc5/source -> /home/acme/git/linux
[acme@quaco pahole]$

Or look at $HOME/git/linux/ too if not finding it in $HOME/linux/

Also it is building in the source tree, would be better to create a temp
dir and use O=.

Trying it:

⬢[acme@toolbox pahole]$ ./kernel-objects-build.sh
output:  /tmp/pahole.test.0su
kdir:    /var/home/acme/git/linux
pahole:  /var/home/acme/git/pahole/build/pahole
objects: /var/home/acme/.pahole_test_objects

cleanup /var/home/acme/git/linux
make: Entering directory '/var/home/acme/git/linux'
make: Leaving directory '/var/home/acme/git/linux'
build x86-clang (/tmp/pahole.test.0su/output)
~/git/linux ~/git/pahole
~/git/pahole
build x86-gcc (/tmp/pahole.test.0su/output)
~/git/linux ~/git/pahole
rpm~/git/pahole
build aarch64-clang (/tmp/pahole.test.0su/output)
~/git/linux ~/git/pahole
⬢[acme@toolbox pahole]$

⬢[acme@toolbox pahole]$ ls -la ~/.pahole_test_objects/
total 0
drwxr-xr-x. 1 acme acme   58 Aug 20 17:24 .
drwx------. 1 acme acme 1346 Aug 20 17:31 ..
drwxr-xr-x. 1 acme acme    0 Aug 20 17:24 aarch64-clang
drwxr-xr-x. 1 acme acme  258 Aug 20 17:21 x86-clang
drwxr-xr-x. 1 acme acme  258 Aug 20 17:24 x86-gcc
⬢[acme@toolbox pahole]$

⬢[acme@toolbox pahole]$ ls -la ~/.pahole_test_objects/aarch64-clang/
total 0
drwxr-xr-x. 1 acme acme  0 Aug 20 17:24 .
drwxr-xr-x. 1 acme acme 58 Aug 20 17:24 ..
⬢[acme@toolbox pahole]$ ls -la ~/.pahole_test_objects/x86-clang/
total 592512
drwxr-xr-x. 1 acme acme       258 Aug 20 17:21 .
drwxr-xr-x. 1 acme acme        58 Aug 20 17:24 ..
-rw-r--r--. 1 acme acme    392920 Aug 20 17:21 efivarfs.ko
-rw-r--r--. 1 acme acme    388384 Aug 20 17:21 iptable_nat.ko
-rw-r--r--. 1 acme acme    471896 Aug 20 17:21 nf_log_syslog.ko
-rwxr-xr-x. 1 acme acme 603366392 Aug 20 17:21 vmlinux
-rw-r--r--. 1 acme acme    245272 Aug 20 17:21 x86_pkg_temp_thermal.ko
-rw-r--r--. 1 acme acme    397128 Aug 20 17:21 xt_addrtype.ko
-rw-r--r--. 1 acme acme    375536 Aug 20 17:21 xt_LOG.ko
-rw-r--r--. 1 acme acme    292320 Aug 20 17:21 xt_mark.ko
-rw-r--r--. 1 acme acme    383824 Aug 20 17:21 xt_MASQUERADE.ko
-rw-r--r--. 1 acme acme    401672 Aug 20 17:21 xt_nat.ko
⬢[acme@toolbox pahole]$ ls -la ~/.pahole_test_objects/x86-gcc/
total 699988
drwxr-xr-x. 1 acme acme       258 Aug 20 17:24 .
drwxr-xr-x. 1 acme acme        58 Aug 20 17:24 ..
-rw-r--r--. 1 acme acme    485112 Aug 20 17:24 efivarfs.ko
-rw-r--r--. 1 acme acme    419520 Aug 20 17:24 iptable_nat.ko
-rw-r--r--. 1 acme acme    514512 Aug 20 17:24 nf_log_syslog.ko
-rwxr-xr-x. 1 acme acme 713044328 Aug 20 17:24 vmlinux
-rw-r--r--. 1 acme acme    301256 Aug 20 17:24 x86_pkg_temp_thermal.ko
-rw-r--r--. 1 acme acme    431712 Aug 20 17:24 xt_addrtype.ko
-rw-r--r--. 1 acme acme    403384 Aug 20 17:24 xt_LOG.ko
-rw-r--r--. 1 acme acme    316528 Aug 20 17:24 xt_mark.ko
-rw-r--r--. 1 acme acme    411992 Aug 20 17:24 xt_MASQUERADE.ko
-rw-r--r--. 1 acme acme    435312 Aug 20 17:24 xt_nat.ko
⬢[acme@toolbox pahole]$

It didn't build bpftool so I have to do it now:


⬢[acme@toolbox pahole]$ cd ../linux
⬢[acme@toolbox linux]$ make -C tools/bpf/bpftool/
make: Entering directory '/var/home/acme/git/linux/tools/bpf/bpftool'

Auto-detecting system features:
...                        libbfd: [ on  ]
...        disassembler-four-args: [ on  ]
...                          zlib: [ on  ]
...                        libcap: [ on  ]
...               clang-bpf-co-re: [ on  ]


  CC      btf.o
<SNIP>
  CC      struct_ops.o
  CC      tracelog.o
  CC      xlated_dumper.o
  CC      jit_disasm.o
  CC      disasm.o
  LINK    bpftool
make: Leaving directory '/var/home/acme/git/linux/tools/bpf/bpftool'
⬢[acme@toolbox linux]$

⬢[acme@toolbox linux]$ cd -
/var/home/acme/git/pahole
⬢[acme@toolbox pahole]$

⬢[acme@toolbox pahole]$ ./kernel-objects-test.sh -B ~/git/linux/tools/bpf/bpftool/bpftool -P build/pahole
/usr/bin/which: no bpftool in (/var/home/acme/.local/bin:/var/home/acme/bin:/usr/lib64/ccache:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin)
pahole:  /var/home/acme/git/pahole/build/pahole
bpftool: /var/home/acme/git/linux/tools/bpf/bpftool/bpftool
base:    /tmp/pahole.test.4of
objects: /var/home/acme/.pahole_test_objects
fail:    no
cleanup: yes

test_funcs      on /var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux ... cp: cannot stat '/var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux': No such file or directory
Error: failed to load BTF from /tmp/pahole.test.4of/object: No such file or directory
pahole: /tmp/pahole.test.4of/object: No such file or directory
Error: failed to load BTF from /tmp/pahole.test.4of/object: No such file or directory
OK
test_format_c   on /var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux ... cp: cannot stat '/var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux': No such file or directory
Error: failed to load BTF from /tmp/pahole.test.4of/object: No such file or directory
pahole: /tmp/pahole.test.4of/object: No such file or directory
Error: failed to load BTF from /tmp/pahole.test.4of/object: No such file or directory
OK
test_btfdiff    on /var/home/acme/.pahole_test_objects/aarch64-clang/vmlinux ... OK
ls: cannot access '/var/home/acme/.pahole_test_objects/aarch64-clang/*.ko': No such file or directory
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/vmlinux ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/vmlinux ... OK
test_btfdiff    on /var/home/acme/.pahole_test_objects/x86-clang/vmlinux ... FAIL
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/efivarfs.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/efivarfs.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/iptable_nat.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/iptable_nat.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/nf_log_syslog.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/nf_log_syslog.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/x86_pkg_temp_thermal.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/x86_pkg_temp_thermal.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/xt_addrtype.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/xt_addrtype.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/xt_LOG.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/xt_LOG.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/xt_mark.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/xt_mark.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/xt_MASQUERADE.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/xt_MASQUERADE.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-clang/xt_nat.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-clang/xt_nat.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux ... Ignoring zero-sized per-CPU variable 'pagesets'...
OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux ... Ignoring zero-sized per-CPU variable 'pagesets'...
OK
test_btfdiff    on /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux ... FAIL
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/efivarfs.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/efivarfs.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/iptable_nat.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/iptable_nat.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/nf_log_syslog.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/nf_log_syslog.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/x86_pkg_temp_thermal.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/x86_pkg_temp_thermal.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/xt_addrtype.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/xt_addrtype.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/xt_LOG.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/xt_LOG.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/xt_mark.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/xt_mark.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/xt_MASQUERADE.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/xt_MASQUERADE.ko ... OK
test_funcs      on /var/home/acme/.pahole_test_objects/x86-gcc/xt_nat.ko ... OK
test_format_c   on /var/home/acme/.pahole_test_objects/x86-gcc/xt_nat.ko ... OK
⬢[acme@toolbox pahole]$

So, now looking at:

test_btfdiff    on /var/home/acme/.pahole_test_objects/x86-gcc/vmlinux ... FAIL

Overall, I like it, will add also the 'fullcircle' test for some of the
single CU kernel objects and add detached BTF tests.

- Arnaldo

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D305546C79
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 20:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349884AbiFJSek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 14:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343749AbiFJSeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 14:34:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A686F3A5D3;
        Fri, 10 Jun 2022 11:34:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C5070B836F5;
        Fri, 10 Jun 2022 18:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2799FC3411E;
        Fri, 10 Jun 2022 18:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654886067;
        bh=RmuJjtQVaC1hFAwZX3UDVyFfrGstyDnMK2vi3fG7G94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NBDEO3l9kWxI0jUmJ4O1nP+uQsMt/oGLcNEmw6LO6SR3gXVO1rULjEbGRQvsW5WZO
         /dP3JDGhtTIHMiM/l6pVC9JDhwzD/a6BxlRp5Hv1hdXwfXQEZjo84tgpfXZ4i0AhtI
         mi1FgQwKM/h/VDkV0q7DEAX6RV3ebh4aazwFK4JoRC/cUmqUzdmG72R1Dyf9rw30d8
         IKvpAPUkTLu06uZ1oGyLr5AW5iV/dNSUsO98/5g0DeAl520S1xNW49ShJQ0HgLSgIu
         SR/d+niH19QRkRuN8c7ZCjeP/6JLgO01mZpt7hI4eARHHBg6nKwcV7SwqFtcv+fV5v
         yvwnKZGma8Cgw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 386B94096F; Fri, 10 Jun 2022 15:34:24 -0300 (-03)
Date:   Fri, 10 Jun 2022 15:34:24 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-perf-use." <linux-perf-users@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv4 bpf-next 0/2] perf tools: Fix prologue generation
Message-ID: <YqOOsL8EbbO3lhmC@kernel.org>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 09, 2022 at 01:31:52PM -0700, Andrii Nakryiko escreveu:
> On Fri, Jun 3, 2022 at 1:45 PM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > sending change we discussed some time ago [1] to get rid of
> > some deprecated functions we use in perf prologue code.
> >
> > Despite the gloomy discussion I think the final code does
> > not look that bad ;-)
> >
> > This patchset removes following libbpf functions from perf:
> >   bpf_program__set_prep
> >   bpf_program__nth_fd
> >   struct bpf_prog_prep_result
> >
> > v4 changes:
> >   - fix typo [Andrii]
> >
> > v3 changes:
> >   - removed R0/R1 zero init in libbpf_prog_prepare_load_fn,
> >     because it's not needed [Andrii]
> >   - rebased/post on top of bpf-next/master which now has
> >     all the needed perf/core changes
> >
> > v2 changes:
> >   - use fallback section prog handler, so we don't need to
> >     use section prefix [Andrii]
> >   - realloc prog->insns array in bpf_program__set_insns [Andrii]
> >   - squash patch 1 from previous version with
> >     bpf_program__set_insns change [Daniel]
> >   - patch 3 already merged [Arnaldo]
> >   - added more comments
> >
> > thanks,
> > jirka
> >
> 
> Arnaldo, can I get an ack from you for this patch set? Thank you!

So, before these patches:

[acme@quaco perf-urgent]$ git log --oneline -5
22905f78d181f446 (HEAD) libperf evsel: Open shouldn't leak fd on failure
a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
785cb9e85e8ba66f perf unwind: Fix uninitialized variable
874c8ca1e60b2c56 netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
3d9f55c57bc3659f Merge tag 'fs_for_v5.19-rc2' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf -v
perf version 5.19.rc1.g22905f78d181
[root@quaco ~]# perf test 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : Ok
 42.2: BPF pinning                                                   : Ok
 42.3: BPF prologue generation                                       : Ok
[root@quaco ~]#

And after:

[acme@quaco perf-urgent]$ git log --oneline -5
f8ec656242acf2de (HEAD -> perf/urgent) perf tools: Rework prologue generation code
a750a8dd7e5d2d4b perf tools: Register fallback libbpf section handler
d28f2a8ad42af160 libperf evsel: Open shouldn't leak fd on failure
a3c6da3dbd4bdf9c perf test: Fix "perf stat CSV output linter" test on s390
785cb9e85e8ba66f perf unwind: Fix uninitialized variable
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf -v
perf version 5.19.rc1.gf8ec656242ac
[root@quaco ~]# perf test 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : FAILED!
 42.2: BPF pinning                                                   : FAILED!
 42.3: BPF prologue generation                                       : Ok
[root@quaco ~]# 

Jiri, can you try reproducing these? Do this require some other work
that is in bpf-next/master? Lemme try...

Further details:

[acme@quaco perf-urgent]$ clang -v
clang version 13.0.0 (five:git/llvm-project d667b96c98438edcc00ec85a3b151ac2dae862f3)
Target: x86_64-unknown-linux-gnu
Thread model: posix
InstalledDir: /usr/local/bin
Found candidate GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
Selected GCC installation: /usr/lib/gcc/x86_64-redhat-linux/12
Candidate multilib: .;@m64
Candidate multilib: 32;@m32
Selected multilib: .;@m64
[acme@quaco perf-urgent]$ cat /etc/fedora-release 
Fedora release 36 (Thirty Six)
[acme@quaco perf-urgent]$ gcc -v
Using built-in specs.
COLLECT_GCC=/usr/bin/gcc
COLLECT_LTO_WRAPPER=/usr/libexec/gcc/x86_64-redhat-linux/12/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none
OFFLOAD_TARGET_DEFAULT=1
Target: x86_64-redhat-linux
Configured with: ../configure --enable-bootstrap --enable-languages=c,c++,fortran,objc,obj-c++,ada,go,d,lto --prefix=/usr --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=http://bugzilla.redhat.com/bugzilla --enable-shared --enable-threads=posix --enable-checking=release --enable-multilib --with-system-zlib --enable-__cxa_atexit --disable-libunwind-exceptions --enable-gnu-unique-object --enable-linker-build-id --with-gcc-major-version-only --enable-libstdcxx-backtrace --with-linker-hash-style=gnu --enable-plugin --enable-initfini-array --with-isl=/builddir/build/BUILD/gcc-12.1.1-20220507/obj-x86_64-redhat-linux/isl-install --enable-offload-targets=nvptx-none --without-cuda-driver --enable-offload-defaulted --enable-gnu-indirect-function --enable-cet --with-tune=generic --with-arch_32=i686 --build=x86_64-redhat-linux --with-build-config=bootstrap-lto --enable-link-serialization=1
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 12.1.1 20220507 (Red Hat 12.1.1-1) (GCC) 
[acme@quaco perf-urgent]$

[root@quaco ~]# perf test -v 42
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           :
--- start ---
test child forked, pid 638881
Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
set env: KBUILD_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
unset env: KBUILD_OPTS
include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: NR_CPUS=8
set env: LINUX_VERSION_CODE=0x5110b
set env: CLANG_EXEC=/usr/lib64/ccache/clang
set env: CLANG_OPTIONS=-xc -g
set env: KERNEL_INC_OPTIONS=-nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: PERF_BPF_INC_OPTIONS=-I/home/acme/lib/perf/include/bpf
set env: WORKING_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
set env: CLANG_SOURCE=-
llvm compiling command template: echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-example.c
 * Test basic LLVM building
 */
#ifndef LINUX_VERSION_CODE
# error Need LINUX_VERSION_CODE
# error Example: for 4.2 kernel, put 'clang-opt="-DLINUX_VERSION_CODE=0x40200" into llvm section of ~/.perfconfig'
#endif
#define BPF_ANY 0
#define BPF_MAP_TYPE_ARRAY 2
#define BPF_FUNC_map_lookup_elem 1
#define BPF_FUNC_map_update_elem 2

static void *(*bpf_map_lookup_elem)(void *map, void *key) =
	(void *) BPF_FUNC_map_lookup_elem;
static void *(*bpf_map_update_elem)(void *map, void *key, void *value, int flags) =
	(void *) BPF_FUNC_map_update_elem;

struct bpf_map_def {
	unsigned int type;
	unsigned int key_size;
	unsigned int value_size;
	unsigned int max_entries;
};

#define SEC(NAME) __attribute__((section(NAME), used))
struct bpf_map_def SEC("maps") flip_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

SEC("func=do_epoll_wait")
int bpf_func__SyS_epoll_pwait(void *ctx)
{
	int ind =0;
	int *flag = bpf_map_lookup_elem(&flip_table, &ind);
	int new_flag;
	if (!flag)
		return 0;
	/* flip flag and store back */
	new_flag = !*flag;
	bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
	return new_flag;
}
char _license[] SEC("license") = "GPL";
int _version SEC("version") = LINUX_VERSION_CODE;
' | $CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS -DLINUX_VERSION_CODE=$LINUX_VERSION_CODE $CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS -Wno-unused-value -Wno-pointer-sign -working-directory $WORKING_DIR -c "$CLANG_SOURCE" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE
llvm compiling command : echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-example.c
 * Test basic LLVM building
 */
#ifndef LINUX_VERSION_CODE
# error Need LINUX_VERSION_CODE
# error Example: for 4.2 kernel, put 'clang-opt=-DLINUX_VERSION_CODE=0x40200 into llvm section of ~/.perfconfig'
#endif
#define BPF_ANY 0
#define BPF_MAP_TYPE_ARRAY 2
#define BPF_FUNC_map_lookup_elem 1
#define BPF_FUNC_map_update_elem 2

static void *(*bpf_map_lookup_elem)(void *map, void *key) =
	(void *) BPF_FUNC_map_lookup_elem;
static void *(*bpf_map_update_elem)(void *map, void *key, void *value, int flags) =
	(void *) BPF_FUNC_map_update_elem;

struct bpf_map_def {
	unsigned int type;
	unsigned int key_size;
	unsigned int value_size;
	unsigned int max_entries;
};

#define SEC(NAME) __attribute__((section(NAME), used))
struct bpf_map_def SEC(maps) flip_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

SEC(func=do_epoll_wait)
int bpf_func__SyS_epoll_pwait(void *ctx)
{
	int ind =0;
	int *flag = bpf_map_lookup_elem(&flip_table, &ind);
	int new_flag;
	if (!flag)
		return 0;
	/* flip flag and store back */
	new_flag = !*flag;
	bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
	return new_flag;
}
char _license[] SEC(license) = GPL;
int _version SEC(version) = LINUX_VERSION_CODE;
' | /usr/lib64/ccache/clang -D__KERNEL__ -D__NR_CPUS__=8 -DLINUX_VERSION_CODE=0x5110b -xc -g -I/home/acme/lib/perf/include/bpf -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h  -Wno-unused-value -Wno-pointer-sign -working-directory /lib/modules/5.17.11-300.fc36.x86_64/build -c - -target bpf  -O2 -o -
libbpf: loading object '[basic_bpf_test]' from buffer
libbpf: elf: section(3) func=do_epoll_wait, size 192, link 0, flags 6, type=1
libbpf: sec 'func=do_epoll_wait': found program 'bpf_func__SyS_epoll_pwait' at insn offset 0 (0 bytes), code size 24 insns (192 bytes)
libbpf: elf: section(4) .relfunc=do_epoll_wait, size 32, link 22, flags 0, type=9
libbpf: elf: section(5) maps, size 16, link 0, flags 3, type=1
libbpf: elf: section(6) license, size 4, link 0, flags 3, type=1
libbpf: license of [basic_bpf_test] is GPL
libbpf: elf: section(7) version, size 4, link 0, flags 3, type=1
libbpf: kernel version of [basic_bpf_test] is 5110b
libbpf: elf: section(13) .BTF, size 576, link 0, flags 0, type=1
libbpf: elf: section(15) .BTF.ext, size 256, link 0, flags 0, type=1
libbpf: elf: section(22) .symtab, size 336, link 1, flags 0, type=2
libbpf: looking for externs among 14 symbols...
libbpf: collected 0 externs total
libbpf: elf: found 1 legacy map definitions (16 bytes) in [basic_bpf_test]
libbpf: map 'flip_table' (legacy): legacy map definitions are deprecated, use BTF-defined maps instead
libbpf: map 'flip_table' (legacy): at sec_idx 5, offset 0.
libbpf: map 11 is "flip_table"
libbpf: Use of BPF_ANNOTATE_KV_PAIR is deprecated, use BTF-defined maps in .maps section instead
libbpf: map:flip_table container_name:____btf_map_flip_table cannot be found in BTF. Missing BPF_ANNOTATE_KV_PAIR?
libbpf: sec '.relfunc=do_epoll_wait': collecting relocation for section(3) 'func=do_epoll_wait'
libbpf: sec '.relfunc=do_epoll_wait': relo #0: insn #4 against 'flip_table'
libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5, off 0) for insn #4
libbpf: sec '.relfunc=do_epoll_wait': relo #1: insn #17 against 'flip_table'
libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5, off 0) for insn #17
bpf: config program 'func=do_epoll_wait'
symbol:do_epoll_wait file:(null) line:0 offset:0 return:0 lazy:(null)
bpf: config 'func=do_epoll_wait' is ok
Looking at the vmlinux_path (8 entries long)
symsrc__init: build id mismatch for vmlinux.
Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symbols
Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a0615a1e5c16783dd7.debug
Try to find probe point from debuginfo.
Matched function: do_epoll_wait [38063fb]
Probe point found: do_epoll_wait+0
Found 1 probe_trace_events.
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//README write=0
Writing event: p:perf_bpf_probe/func _text+3943040
libbpf: map 'flip_table': created successfully, fd=4
libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invalid argument
libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
Invalid insn code at line_info[11].insn_off
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: failed to load program 'bpf_func__SyS_epoll_pwait'
libbpf: failed to load object '[basic_bpf_test]'
bpf: load objects failed: err=-22: (Invalid argument)
Failed to add events selected by BPF
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+3943040
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with -1
---- end ----
BPF filter subtest 1: FAILED!
 42.2: BPF pinning                                                   :
--- start ---
test child forked, pid 639077
Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
set env: KBUILD_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
unset env: KBUILD_OPTS
include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: NR_CPUS=8
set env: LINUX_VERSION_CODE=0x5110b
set env: CLANG_EXEC=/usr/lib64/ccache/clang
set env: CLANG_OPTIONS=-xc -g
set env: KERNEL_INC_OPTIONS=-nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: PERF_BPF_INC_OPTIONS=-I/home/acme/lib/perf/include/bpf
set env: WORKING_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
set env: CLANG_SOURCE=-
llvm compiling command template: echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-example.c
 * Test basic LLVM building
 */
#ifndef LINUX_VERSION_CODE
# error Need LINUX_VERSION_CODE
# error Example: for 4.2 kernel, put 'clang-opt="-DLINUX_VERSION_CODE=0x40200" into llvm section of ~/.perfconfig'
#endif
#define BPF_ANY 0
#define BPF_MAP_TYPE_ARRAY 2
#define BPF_FUNC_map_lookup_elem 1
#define BPF_FUNC_map_update_elem 2

static void *(*bpf_map_lookup_elem)(void *map, void *key) =
	(void *) BPF_FUNC_map_lookup_elem;
static void *(*bpf_map_update_elem)(void *map, void *key, void *value, int flags) =
	(void *) BPF_FUNC_map_update_elem;

struct bpf_map_def {
	unsigned int type;
	unsigned int key_size;
	unsigned int value_size;
	unsigned int max_entries;
};

#define SEC(NAME) __attribute__((section(NAME), used))
struct bpf_map_def SEC("maps") flip_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

SEC("func=do_epoll_wait")
int bpf_func__SyS_epoll_pwait(void *ctx)
{
	int ind =0;
	int *flag = bpf_map_lookup_elem(&flip_table, &ind);
	int new_flag;
	if (!flag)
		return 0;
	/* flip flag and store back */
	new_flag = !*flag;
	bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
	return new_flag;
}
char _license[] SEC("license") = "GPL";
int _version SEC("version") = LINUX_VERSION_CODE;
' | $CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS -DLINUX_VERSION_CODE=$LINUX_VERSION_CODE $CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS -Wno-unused-value -Wno-pointer-sign -working-directory $WORKING_DIR -c "$CLANG_SOURCE" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE
llvm compiling command : echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-example.c
 * Test basic LLVM building
 */
#ifndef LINUX_VERSION_CODE
# error Need LINUX_VERSION_CODE
# error Example: for 4.2 kernel, put 'clang-opt=-DLINUX_VERSION_CODE=0x40200 into llvm section of ~/.perfconfig'
#endif
#define BPF_ANY 0
#define BPF_MAP_TYPE_ARRAY 2
#define BPF_FUNC_map_lookup_elem 1
#define BPF_FUNC_map_update_elem 2

static void *(*bpf_map_lookup_elem)(void *map, void *key) =
	(void *) BPF_FUNC_map_lookup_elem;
static void *(*bpf_map_update_elem)(void *map, void *key, void *value, int flags) =
	(void *) BPF_FUNC_map_update_elem;

struct bpf_map_def {
	unsigned int type;
	unsigned int key_size;
	unsigned int value_size;
	unsigned int max_entries;
};

#define SEC(NAME) __attribute__((section(NAME), used))
struct bpf_map_def SEC(maps) flip_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

SEC(func=do_epoll_wait)
int bpf_func__SyS_epoll_pwait(void *ctx)
{
	int ind =0;
	int *flag = bpf_map_lookup_elem(&flip_table, &ind);
	int new_flag;
	if (!flag)
		return 0;
	/* flip flag and store back */
	new_flag = !*flag;
	bpf_map_update_elem(&flip_table, &ind, &new_flag, BPF_ANY);
	return new_flag;
}
char _license[] SEC(license) = GPL;
int _version SEC(version) = LINUX_VERSION_CODE;
' | /usr/lib64/ccache/clang -D__KERNEL__ -D__NR_CPUS__=8 -DLINUX_VERSION_CODE=0x5110b -xc -g -I/home/acme/lib/perf/include/bpf -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h  -Wno-unused-value -Wno-pointer-sign -working-directory /lib/modules/5.17.11-300.fc36.x86_64/build -c - -target bpf  -O2 -o -
libbpf: loading object '[bpf_pinning]' from buffer
libbpf: elf: section(3) func=do_epoll_wait, size 192, link 0, flags 6, type=1
libbpf: sec 'func=do_epoll_wait': found program 'bpf_func__SyS_epoll_pwait' at insn offset 0 (0 bytes), code size 24 insns (192 bytes)
libbpf: elf: section(4) .relfunc=do_epoll_wait, size 32, link 22, flags 0, type=9
libbpf: elf: section(5) maps, size 16, link 0, flags 3, type=1
libbpf: elf: section(6) license, size 4, link 0, flags 3, type=1
libbpf: license of [bpf_pinning] is GPL
libbpf: elf: section(7) version, size 4, link 0, flags 3, type=1
libbpf: kernel version of [bpf_pinning] is 5110b
libbpf: elf: section(13) .BTF, size 576, link 0, flags 0, type=1
libbpf: elf: section(15) .BTF.ext, size 256, link 0, flags 0, type=1
libbpf: elf: section(22) .symtab, size 336, link 1, flags 0, type=2
libbpf: looking for externs among 14 symbols...
libbpf: collected 0 externs total
libbpf: elf: found 1 legacy map definitions (16 bytes) in [bpf_pinning]
libbpf: map 'flip_table' (legacy): legacy map definitions are deprecated, use BTF-defined maps instead
libbpf: map 'flip_table' (legacy): at sec_idx 5, offset 0.
libbpf: map 11 is "flip_table"
libbpf: Use of BPF_ANNOTATE_KV_PAIR is deprecated, use BTF-defined maps in .maps section instead
libbpf: map:flip_table container_name:____btf_map_flip_table cannot be found in BTF. Missing BPF_ANNOTATE_KV_PAIR?
libbpf: sec '.relfunc=do_epoll_wait': collecting relocation for section(3) 'func=do_epoll_wait'
libbpf: sec '.relfunc=do_epoll_wait': relo #0: insn #4 against 'flip_table'
libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5, off 0) for insn #4
libbpf: sec '.relfunc=do_epoll_wait': relo #1: insn #17 against 'flip_table'
libbpf: prog 'bpf_func__SyS_epoll_pwait': found map 0 (flip_table, sec 5, off 0) for insn #17
bpf: config program 'func=do_epoll_wait'
symbol:do_epoll_wait file:(null) line:0 offset:0 return:0 lazy:(null)
bpf: config 'func=do_epoll_wait' is ok
Looking at the vmlinux_path (8 entries long)
symsrc__init: build id mismatch for vmlinux.
Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symbols
Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a0615a1e5c16783dd7.debug
Try to find probe point from debuginfo.
Matched function: do_epoll_wait [38063fb]
Probe point found: do_epoll_wait+0
Found 1 probe_trace_events.
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//README write=0
Writing event: p:perf_bpf_probe/func _text+3943040
libbpf: map 'flip_table': created successfully, fd=4
libbpf: prog 'bpf_func__SyS_epoll_pwait': BPF program load failed: Invalid argument
libbpf: prog 'bpf_func__SyS_epoll_pwait': -- BEGIN PROG LOAD LOG --
Invalid insn code at line_info[11].insn_off
processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
-- END PROG LOAD LOG --
libbpf: failed to load program 'bpf_func__SyS_epoll_pwait'
libbpf: failed to load object '[bpf_pinning]'
bpf: load objects failed: err=-22: (Invalid argument)
Failed to add events selected by BPF
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+3943040
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with -1
---- end ----
BPF filter subtest 2: FAILED!
 42.3: BPF prologue generation                                       :
--- start ---
test child forked, pid 639274
Kernel build dir is set to /lib/modules/5.17.11-300.fc36.x86_64/build
set env: KBUILD_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
unset env: KBUILD_OPTS
include option is set to -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: NR_CPUS=8
set env: LINUX_VERSION_CODE=0x5110b
set env: CLANG_EXEC=/usr/lib64/ccache/clang
set env: CLANG_OPTIONS=-xc -g
set env: KERNEL_INC_OPTIONS=-nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h
set env: PERF_BPF_INC_OPTIONS=-I/home/acme/lib/perf/include/bpf
set env: WORKING_DIR=/lib/modules/5.17.11-300.fc36.x86_64/build
set env: CLANG_SOURCE=-
llvm compiling command template: echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-test-prologue.c
 * Test BPF prologue
 */
#ifndef LINUX_VERSION_CODE
# error Need LINUX_VERSION_CODE
# error Example: for 4.2 kernel, put 'clang-opt="-DLINUX_VERSION_CODE=0x40200" into llvm section of ~/.perfconfig'
#endif
#define SEC(NAME) __attribute__((section(NAME), used))

#include <uapi/linux/fs.h>

/*
 * If CONFIG_PROFILE_ALL_BRANCHES is selected,
 * 'if' is redefined after include kernel header.
 * Recover 'if' for BPF object code.
 */
#ifdef if
# undef if
#endif

#define FMODE_READ		0x1
#define FMODE_WRITE		0x2

static void (*bpf_trace_printk)(const char *fmt, int fmt_size, ...) =
	(void *) 6;

SEC("func=null_lseek file->f_mode offset orig")
int bpf_func__null_lseek(void *ctx, int err, unsigned long _f_mode,
			 unsigned long offset, unsigned long orig)
{
	fmode_t f_mode = (fmode_t)_f_mode;

	if (err)
		return 0;
	if (f_mode & FMODE_WRITE)
		return 0;
	if (offset & 1)
		return 0;
	if (orig == SEEK_CUR)
		return 0;
	return 1;
}

char _license[] SEC("license") = "GPL";
int _version SEC("version") = LINUX_VERSION_CODE;
' | $CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS -DLINUX_VERSION_CODE=$LINUX_VERSION_CODE $CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS -Wno-unused-value -Wno-pointer-sign -working-directory $WORKING_DIR -c "$CLANG_SOURCE" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE
llvm compiling command :
libbpf: loading object '[bpf_prologue_test]' from buffer
libbpf: elf: section(3) func=null_lseek file->f_mode offset orig, size 112, link 0, flags 6, type=1
libbpf: sec 'func=null_lseek file->f_mode offset orig': found program 'bpf_func__null_lseek' at insn offset 0 (0 bytes), code size 14 insns (112 bytes)
libbpf: elf: section(4) license, size 4, link 0, flags 3, type=1
libbpf: license of [bpf_prologue_test] is GPL
libbpf: elf: section(5) version, size 4, link 0, flags 3, type=1
libbpf: kernel version of [bpf_prologue_test] is 5110b
libbpf: elf: section(11) .BTF, size 489, link 0, flags 0, type=1
libbpf: elf: section(13) .BTF.ext, size 144, link 0, flags 0, type=1
libbpf: elf: section(20) .symtab, size 312, link 1, flags 0, type=2
libbpf: looking for externs among 13 symbols...
libbpf: collected 0 externs total
bpf: config program 'func=null_lseek file->f_mode offset orig'
symbol:null_lseek file:(null) line:0 offset:0 return:0 lazy:(null)
parsing arg: file->f_mode into file, f_mode(1)
parsing arg: offset into offset
parsing arg: orig into orig
bpf: config 'func=null_lseek file->f_mode offset orig' is ok
Looking at the vmlinux_path (8 entries long)
symsrc__init: build id mismatch for vmlinux.
Using /usr/lib/debug/lib/modules/5.17.11-300.fc36.x86_64/vmlinux for symbols
Open Debuginfo file: /usr/lib/debug/.build-id/f2/26f5d75e6842add57095a0615a1e5c16783dd7.debug
Try to find probe point from debuginfo.
Opening /sys/kernel/tracing//README write=0
Matched function: null_lseek [73f7810]
Probe point found: null_lseek+0
Searching 'file' variable in context.
Converting variable file into trace event.
converting f_mode in file
f_mode type is unsigned int.
Searching 'offset' variable in context.
Converting variable offset into trace event.
offset type is long long int.
Searching 'orig' variable in context.
Converting variable orig into trace event.
orig type is int.
Found 1 probe_trace_events.
Opening /sys/kernel/tracing//kprobe_events write=1
Writing event: p:perf_bpf_probe/func _text+8502800 f_mode=+68(%di):x32 offset=%si:s64 orig=%dx:s32
In map_prologue, ntevs=1
mapping[0]=0
prologue: pass validation
prologue: slow path
prologue: fetch arg 0, base reg is %di
prologue: arg 0: offset 68
prologue: fetch arg 1, base reg is %si
prologue: fetch arg 2, base reg is %dx
prologue: load arg 0, insn_sz is BPF_W
prologue: load arg 1, insn_sz is BPF_DW
prologue: load arg 2, insn_sz is BPF_DW
add bpf event perf_bpf_probe:func and attach bpf program 5
adding perf_bpf_probe:func
adding perf_bpf_probe:func to 0x3ffa5d0
Using CPUID GenuineIntel-6-8E-A
mmap size 1052672B
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+8502800 f_mode=+68(%di):x32 offset=%si:s64 orig=%dx:s32
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with 0
---- end ----
BPF filter subtest 3: Ok
[root@quaco ~]#
[root@quaco ~]#

> > [1] https://lore.kernel.org/bpf/CAEf4BzaiBO3_617kkXZdYJ8hS8YF--ZLgapNbgeeEJ-pY0H88g@mail.gmail.com/
> > ---
> > Jiri Olsa (2):
> >       perf tools: Register fallback libbpf section handler
> >       perf tools: Rework prologue generation code
> >
> >  tools/perf/util/bpf-loader.c | 173 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------
> >  1 file changed, 155 insertions(+), 18 deletions(-)

-- 

- Arnaldo

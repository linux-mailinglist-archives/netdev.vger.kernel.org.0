Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C9454CCEE
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 17:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349659AbiFOP3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 11:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352214AbiFOP11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 11:27:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A9645050;
        Wed, 15 Jun 2022 08:27:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF295B81F0B;
        Wed, 15 Jun 2022 15:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE57C34115;
        Wed, 15 Jun 2022 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655306826;
        bh=vsuOzE9zk8EUMxazzYnwc+GCoKeW+gBkvqC9es8C/aM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MvXVDEf/AbsyElj0UQXB4KTNElJQNwOeP+TPb+VMKibWwIKO+P6IxrIuCxQhyTeb0
         eQeBp/Qaf7dPjIbwYWeX+cQVxBDfRV5V7/wb/APU3SOsFEzB++v38LcrQpPM7MExyt
         sFKZ3NJ72ZlME3uxIVh0E6oJQDclXs6C3lTf+Sw24AAi9Id931Yt3ySpS5xIbfBKZS
         m0h/PDE9K24vaFnLFDNzio7+q/s9SR53ABd5MrogmFdfa2c/5kOEMwQaLlKKBRcF7Y
         nWqdg60NdPzRU+2rN+ADAUhtUw8zgTr5FxegXcmB5MPqHRgDenArUmOD+0NgYW7eks
         q3B0KIrvc2fUA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 3A28D4096F; Wed, 15 Jun 2022 12:27:03 -0300 (-03)
Date:   Wed, 15 Jun 2022 12:27:03 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <olsajiri@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
Message-ID: <Yqn6R2BA12U6Ftzt@kernel.org>
References: <20220603204509.15044-1-jolsa@kernel.org>
 <CAEf4BzbT4Z=B2hZxTQf1MrCp6TGiMgP+_t7p8G5A+RdVyNP+8w@mail.gmail.com>
 <YqOOsL8EbbO3lhmC@kernel.org>
 <CAEf4BzaKP8MHtGZDVSpwbCxNUD4zY9wkjEa4HKR0LWxYKW5cGQ@mail.gmail.com>
 <YqOvYo1tp32gKviM@krava>
 <YqYTZVa44Y6RQ11W@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqYTZVa44Y6RQ11W@krava>
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

Em Sun, Jun 12, 2022 at 06:25:09PM +0200, Jiri Olsa escreveu:
> so the problem is that we prepend init proglogue instructions
> for each program not just for the one that needs it, so it will
> mismatch later on.. the fix below makes it work for me

> Arnaldo,
> I squashed and pushed the change below changes to my bpf/depre
> branch, could you please retest?

Before:

[acme@quaco perf-urgent]$ git log --oneline -5
e2cf9d315f90670f (HEAD -> perf/urgent, five/perf/urgent) perf test topology: Use !strncmp(right platform) to fix guest PPC comparision check
42e4fb08ff987b50 perf test: Record only user callchains on the "Check Arm64 callgraphs are complete in fp mode" test
819d5c3cf75d0f95 perf beauty: Update copy of linux/socket.h with the kernel sources
ebdc02b3ece8238b perf test: Fix variable length array undefined behavior in bp_account
8ff58c35adb7f118 libperf evsel: Open shouldn't leak fd on failure
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf -v
perf version 5.19.rc2.ge2cf9d315f90
[root@quaco ~]# perf test bpf
 40: LLVM search and compile                                         :
 40.1: Basic BPF llvm compile                                        : Ok
 40.3: Compile source for BPF prologue generation                    : Ok
 40.4: Compile source for BPF relocation                             : Ok
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : Ok
 42.2: BPF pinning                                                   : Ok
 42.3: BPF prologue generation                                       : Ok
 63: Test libpfm4 support                                            :
 96: perf stat --bpf-counters test                                   : Ok
[root@quaco ~]#

After your first patch:

[acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
f913ad6559e337b4 libbpf: Fix is_pow_of_2
f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
[acme@quaco perf-urgent]$ git cherry-pick 4d40831f29f2c9ad
[perf/urgent ab39fb6880b57507] perf tools: Register fallback libbpf section handler
 Author: Jiri Olsa <jolsa@kernel.org>
 Date: Thu Apr 21 15:22:25 2022 +0200
 1 file changed, 65 insertions(+), 11 deletions(-)
[acme@quaco perf-urgent]$
[acme@quaco perf-urgent]$ alias m='rm -rf ~/libexec/perf-core/ ; perf stat -e cycles:u,instructions:u make -k BUILD_BPF_SKEL=1 PYTHON=python3 O=/tmp/build/perf-urgent -C tools/perf install-bin && perf test python'
[acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
<SNIP>
 19: 'import perf' in python                                         : Ok
[acme@quaco perf-urgent]$
[acme@quaco perf-urgent]$ sudo su -
[sudo] password for acme:
[root@quaco ~]# perf test bpf
 40: LLVM search and compile                                         :
 40.1: Basic BPF llvm compile                                        : Ok
 40.3: Compile source for BPF prologue generation                    : Ok
 40.4: Compile source for BPF relocation                             : Ok
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : Ok
 42.2: BPF pinning                                                   : Ok
 42.3: BPF prologue generation                                       : FAILED!
 63: Test libpfm4 support                                            :
 96: perf stat --bpf-counters test                                   : Ok
[root@quaco ~]#

perf test -v bpf later, lets see if landing the second patch fixes
things and this bisection problem is justified:

[acme@quaco perf-urgent]$ git log --oneline -5 jolsa/bpf/depre
9317b879db422632 (jolsa/bpf/depre) perf tools: Rework prologue generation code
4d40831f29f2c9ad perf tools: Register fallback libbpf section handler
f913ad6559e337b4 libbpf: Fix is_pow_of_2
f175ece2e3436748 selftests/bpf: Fix tc_redirect_dtime
7b711e721234f475 bpf, test_run: Remove unnecessary prog type checks
[acme@quaco perf-urgent]$ git remote update jolsa
Fetching jolsa
[acme@quaco perf-urgent]$ git cherry-pick 9317b879db422632
[perf/urgent 9a36c7c94e1f596d] perf tools: Rework prologue generation code
 Author: Jiri Olsa <jolsa@kernel.org>
 Date: Mon May 9 22:46:20 2022 +0200
 1 file changed, 110 insertions(+), 18 deletions(-)
[acme@quaco perf-urgent]$
[acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
<SNIP>
 19: 'import perf' in python                                         : Ok
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf test bpf
 40: LLVM search and compile                                         :
 40.1: Basic BPF llvm compile                                        : Ok
 40.3: Compile source for BPF prologue generation                    : Ok
 40.4: Compile source for BPF relocation                             : Ok
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           : Ok
 42.2: BPF pinning                                                   : Ok
 42.3: BPF prologue generation                                       : Ok
 63: Test libpfm4 support                                            :
 96: perf stat --bpf-counters test                                   : Ok
[root@quaco ~]#

So it works in the end, can it be made to work after the first step? I
didn't check that.

-v without the last patch:

[acme@quaco perf-urgent]$ git reset --hard HEAD~
HEAD is now at ab39fb6880b57507 perf tools: Register fallback libbpf section handler
[acme@quaco perf-urgent]$ rm -rf /tmp/build/perf-urgent ; mkdir -p /tmp/build/perf-urgent ; m
<SNIP>
 19: 'import perf' in python                                         : Ok
[acme@quaco perf-urgent]$ sudo su -
[root@quaco ~]# perf test -v bpf
 40: LLVM search and compile                                         :
 40.1: Basic BPF llvm compile                                        :
--- start ---
test child forked, pid 731590
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
libbpf: map 'flip_table' (legacy): legacy map definitions are deprecated, use BTF-defined maps instead
libbpf: Use of BPF_ANNOTATE_KV_PAIR is deprecated, use BTF-defined maps in .maps section instead
test child finished with 0
---- end ----
LLVM search and compile subtest 1: Ok
 40.3: Compile source for BPF prologue generation                    :
--- start ---
test child forked, pid 731783
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
test child finished with 0
---- end ----
LLVM search and compile subtest 3: Ok
 40.4: Compile source for BPF relocation                             :
--- start ---
test child forked, pid 731976
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
 * bpf-script-test-relocation.c
 * Test BPF loader checking relocation
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
struct bpf_map_def SEC("maps") my_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

int this_is_a_global_val;

SEC("func=sys_write")
int bpf_func__sys_write(void *ctx)
{
	int key = 0;
	int value = 0;

	/*
	 * Incorrect relocation. Should not allow this program be
	 * loaded into kernel.
	 */
	bpf_map_update_elem(&this_is_a_global_val, &key, &value, 0);
	return 0;
}
char _license[] SEC("license") = "GPL";
int _version SEC("version") = LINUX_VERSION_CODE;
' | $CLANG_EXEC -D__KERNEL__ -D__NR_CPUS__=$NR_CPUS -DLINUX_VERSION_CODE=$LINUX_VERSION_CODE $CLANG_OPTIONS $PERF_BPF_INC_OPTIONS $KERNEL_INC_OPTIONS -Wno-unused-value -Wno-pointer-sign -working-directory $WORKING_DIR -c "$CLANG_SOURCE" -target bpf $CLANG_EMIT_LLVM -O2 -o - $LLVM_OPTIONS_PIPE
llvm compiling command : echo '// SPDX-License-Identifier: GPL-2.0
/*
 * bpf-script-test-relocation.c
 * Test BPF loader checking relocation
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
struct bpf_map_def SEC(maps) my_table = {
	.type = BPF_MAP_TYPE_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 1,
};

int this_is_a_global_val;

SEC(func=sys_write)
int bpf_func__sys_write(void *ctx)
{
	int key = 0;
	int value = 0;

	/*
	 * Incorrect relocation. Should not allow this program be
	 * loaded into kernel.
	 */
	bpf_map_update_elem(&this_is_a_global_val, &key, &value, 0);
	return 0;
}
char _license[] SEC(license) = GPL;
int _version SEC(version) = LINUX_VERSION_CODE;
' | /usr/lib64/ccache/clang -D__KERNEL__ -D__NR_CPUS__=8 -DLINUX_VERSION_CODE=0x5110b -xc -g -I/home/acme/lib/perf/include/bpf -nostdinc -I./arch/x86/include -I./arch/x86/include/generated  -I./include -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi -I./include/uapi -I./include/generated/uapi -include ./include/linux/compiler-version.h -include ./include/linux/kconfig.h  -Wno-unused-value -Wno-pointer-sign -working-directory /lib/modules/5.17.11-300.fc36.x86_64/build -c - -target bpf  -O2 -o - 
test child finished with 0
---- end ----
LLVM search and compile subtest 4: Ok
 42: BPF filter                                                      :
 42.1: Basic BPF filtering                                           :
--- start ---
test child forked, pid 732169
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
add bpf event perf_bpf_probe:func and attach bpf program 5
adding perf_bpf_probe:func
adding perf_bpf_probe:func to 0x3017000
Using CPUID GenuineIntel-6-8E-A
mmap size 1052672B
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+3943040
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with 0
---- end ----
BPF filter subtest 1: Ok
 42.2: BPF pinning                                                   :
--- start ---
test child forked, pid 732362
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
add bpf event perf_bpf_probe:func and attach bpf program 5
adding perf_bpf_probe:func
adding perf_bpf_probe:func to 0x3017000
Using CPUID GenuineIntel-6-8E-A
mmap size 1052672B
libbpf: pinned map '/sys/fs/bpf/perf_test/flip_table'
libbpf: pinned program '/sys/fs/bpf/perf_test/func=do_epoll_wait'
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+3943040
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with 0
---- end ----
BPF filter subtest 2: Ok
 42.3: BPF prologue generation                                       :
--- start ---
test child forked, pid 732556
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
add bpf event perf_bpf_probe:func and attach bpf program 4
adding perf_bpf_probe:func
adding perf_bpf_probe:func to 0x3739570
Using CPUID GenuineIntel-6-8E-A
mmap size 1052672B
BPF filter result incorrect, expected 28, got 222 samples
Opening /sys/kernel/tracing//kprobe_events write=1
Opening /sys/kernel/tracing//uprobe_events write=1
Parsing probe_events: p:perf_bpf_probe/func _text+8502800 f_mode=+68(%di):x32 offset=%si:s64 orig=%dx:s32
Group:perf_bpf_probe Event:func probe:p
Writing event: -:perf_bpf_probe/func
test child finished with -1
---- end ----
BPF filter subtest 3: FAILED!
 63: Test libpfm4 support                                            :
 96: perf stat --bpf-counters test                                   :
--- start ---
test child forked, pid 732749
test child finished with 0
---- end ----
perf stat --bpf-counters test: Ok
[root@quaco ~]# 
[root@quaco ~]# 
[root@quaco ~]# 



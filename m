Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C626255A1C3
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 21:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiFXS72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:59:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiFXS71 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:59:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148517C53B;
        Fri, 24 Jun 2022 11:59:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95110B82B86;
        Fri, 24 Jun 2022 18:59:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B90C34114;
        Fri, 24 Jun 2022 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656097163;
        bh=9lG/oNBpocVsZWbSlBaA7xBp6sq+q5dWcKQtjzSW/J4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CqP0l0s9B6WiDpvpg3x90jCaLt78gxi5nMbSk3AsCfMNkecdyrLgV1IpnPsWTMKfj
         pXtpF02igze5un5WJW9lHkhXFldmldSzL1OBeKtEnfF6Nk9BTqFrjwv6NlUQw8C7GQ
         i5hh/9g7aPPx7MftrCLY5/8YgHv54D36CtnFRJHJ86a3s2ev+8PTJ37HPKTXP7OGE9
         bn/8cqktRSnHw9AM1hybkYzYXY4KYPQthRPXIhMl45X7Bpy95rnwNg115HBfHr69ug
         xtsd7dnxgyeicg06E6mlAqcu5TOJrTSmeCaclEHY0ex/fkLlkrIanNOg3u71HPPF+2
         vCUtN6FMj1Pqg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 1EA1B4096F; Fri, 24 Jun 2022 15:59:20 -0300 (-03)
Date:   Fri, 24 Jun 2022 15:59:20 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        linux-perf-users@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Ian Rogers <irogers@google.com>
Subject: Re: [PATCHv5 bpf-next 1/1] perf tools: Rework prologue generation
 code
Message-ID: <YrYJiELwAlufv3gA@kernel.org>
References: <20220616202214.70359-1-jolsa@kernel.org>
 <20220616202214.70359-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220616202214.70359-2-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, Jun 16, 2022 at 10:22:14PM +0200, Jiri Olsa escreveu:
> Some functions we use for bpf prologue generation are going to be
> deprecated. This change reworks current code not to use them.
> 
> We need to replace following functions/struct:
>    bpf_program__set_prep
>    bpf_program__nth_fd
>    struct bpf_prog_prep_result

So this is a combination of those two patches, ok:

Before:

[root@quaco ~]# perf -v
perf version 5.19.rc3.g3af6e6d06631
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

After:
[acme@quaco perf-urgent]$ git log --oneline -5
44d22a24d0d49588 (HEAD -> perf/urgent) perf tools: Rework prologue generation code
3af6e6d0663196e7 (five/perf/urgent) perf stat: Enable ignore_missing_thread
c3259c85b333af5e perf inject: Adjust output data offset for backward compatibility
8e6445010f7bffbb perf trace beauty: Fix generation of errno id->str table on ALT Linux
57a438eb2aef4f1f perf build-id: Fix caching files with a wrong build ID
[acme@quaco perf-urgent]$ 
[root@quaco ~]# perf -v
perf version 5.19.rc3.g44d22a24d0d4
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

And 'perf test' with the augmented_raw_syscalls.c eBPF support also
continues to work:

[root@quaco ~]# perf trace -e /home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.c,open*,connect* --max-events 20
     0.000 systemd-oomd/948 openat(dfd: CWD, filename: "/proc/meminfo", flags: RDONLY|CLOEXEC) = 12
     0.151 abrt-dump-jour/1338 openat(dfd: CWD, filename: "/var/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDONLY|CLOEXEC|NONBLOCK) = 31
     0.096 abrt-dump-jour/1336 openat(dfd: CWD, filename: "/var/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDONLY|CLOEXEC|NONBLOCK) = 31
     0.092 abrt-dump-jour/1337 openat(dfd: CWD, filename: "/var/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDONLY|CLOEXEC|NONBLOCK) = 31
     9.024 isc-net-0000/1108 connect(fd: 512, uservaddr: { .family: INET6, port: 53, addr: 2406:8600:f03f:1f8::1003 }, addrlen: 28) = -1 ENETUNREACH (Network is unreachable)
     9.728 isc-net-0000/1108 connect(fd: 513, uservaddr: { .family: INET6, port: 53, addr: 2406:2000:1d0::7961:686f:6f21 }, addrlen: 28) = -1 ENETUNREACH (Network is unreachable)
     9.811 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/comm", flags: RDONLY|CLOEXEC) ...
    10.061 isc-net-0000/1108 connect(fd: 514, uservaddr: { .family: INET6, port: 53, addr: 2001:4998:1c0::7961:686f:6f21 }, addrlen: 28) = -1 ENETUNREACH (Network is unreachable)
     9.811 systemd-journa/712  ... [continued]: openat())             = 66
    10.401 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/cmdline", flags: RDONLY|CLOEXEC|NOCTTY) = 66
    10.438 isc-net-0000/1108 connect(fd: 513, uservaddr: { .family: INET6, port: 53, addr: 2001:4998:1b0::7961:686f:6f21 }, addrlen: 28) = -1 ENETUNREACH (Network is unreachable)
    10.803 isc-net-0000/1108 connect(fd: 514, uservaddr: { .family: INET, port: 53, addr: 98.138.11.157 }, addrlen: 16) = 0
    10.851 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/status", flags: RDONLY|CLOEXEC|NOCTTY) = 66
    11.165 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/sessionid", flags: RDONLY|CLOEXEC) = 66
    11.420 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/loginuid", flags: RDONLY|CLOEXEC) = 66
    11.631 systemd-journa/712 openat(dfd: CWD, filename: "/proc/1107/cgroup", flags: RDONLY|CLOEXEC) = 66
    11.903 systemd-journa/712 openat(dfd: CWD, filename: "/run/systemd/units/log-extra-fields:named.service", flags: RDONLY|CLOEXEC) = -1 ENOENT (No such file or directory)
    12.085 systemd-journa/712 openat(dfd: CWD, filename: "/run/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDWR|CLOEXEC|NONBLOCK) = -1 ENOENT (No such file or directory)
    12.849 systemd-journa/712 openat(dfd: CWD, filename: "/run/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDWR|CLOEXEC|NONBLOCK) = -1 ENOENT (No such file or directory)
    13.141 systemd-journa/712 openat(dfd: CWD, filename: "/run/log/journal/d6a97235307247e09f13f326fb607e3c/system.journal", flags: RDWR|CLOEXEC|NONBLOCK) = -1 ENOENT (No such file or directory)
[root@quaco ~]#

[root@quaco ~]# grep -A2 SEC /home/acme/git/perf/tools/perf/examples/bpf/augmented_raw_syscalls.c
SEC("!raw_syscalls:unaugmented")
int syscall_unaugmented(struct syscall_enter_args *args)
{
--
 * These will be tail_called from SEC("raw_syscalls:sys_enter"), so will find in
 * augmented_args_tmp what was read by that raw_syscalls:sys_enter and go
 * on from there, reading the first syscall arg as a string, i.e. open's
--
SEC("!syscalls:sys_enter_connect")
int sys_enter_connect(struct syscall_enter_args *args)
{
--
SEC("!syscalls:sys_enter_sendto")
int sys_enter_sendto(struct syscall_enter_args *args)
{
--
SEC("!syscalls:sys_enter_open")
int sys_enter_open(struct syscall_enter_args *args)
{
--
SEC("!syscalls:sys_enter_openat")
int sys_enter_openat(struct syscall_enter_args *args)
{
--
SEC("!syscalls:sys_enter_rename")
int sys_enter_rename(struct syscall_enter_args *args)
{
--
SEC("!syscalls:sys_enter_renameat")
int sys_enter_renameat(struct syscall_enter_args *args)
{
--
SEC("raw_syscalls:sys_enter")
int sys_enter(struct syscall_enter_args *args)
{
--
SEC("raw_syscalls:sys_exit")
int sys_exit(struct syscall_exit_args *args)
{
[root@quaco ~]#


Thanks, you can have my:

Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>

Stronger than an:

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
 
> Currently we use bpf_program__set_prep to hook perf callback before
> program is loaded and provide new instructions with the prologue.
> 
> We replace this function/ality by taking instructions for specific
> program, attaching prologue to them and load such new ebpf programs
> with prologue using separate bpf_prog_load calls (outside libbpf
> load machinery).
> 
> Before we can take and use program instructions, we need libbpf to
> actually load it. This way we get the final shape of its instructions
> with all relocations and verifier adjustments).
> 
> There's one glitch though.. perf kprobe program already assumes
> generated prologue code with proper values in argument registers,
> so loading such program directly will fail in the verifier.
> 
> That's where the fallback pre-load handler fits in and prepends
> the initialization code to the program. Once such program is loaded
> we take its instructions, cut off the initialization code and prepend
> the prologue.
> 
> I know.. sorry ;-)
> 
> To have access to the program when loading this patch adds support to
> register 'fallback' section handler to take care of perf kprobe programs.
> The fallback means that it handles any section definition besides the
> ones that libbpf handles.
> 
> The handler serves two purposes:
>   - allows perf programs to have special arguments in section name
>   - allows perf to use pre-load callback where we can attach init
>     code (zeroing all argument registers) to each perf program
> 
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/bpf-loader.c | 204 ++++++++++++++++++++++++++++++-----
>  1 file changed, 175 insertions(+), 29 deletions(-)
> 
> diff --git a/tools/perf/util/bpf-loader.c b/tools/perf/util/bpf-loader.c
> index f8ad581ea247..6bd7c288e820 100644
> --- a/tools/perf/util/bpf-loader.c
> +++ b/tools/perf/util/bpf-loader.c
> @@ -9,6 +9,7 @@
>  #include <linux/bpf.h>
>  #include <bpf/libbpf.h>
>  #include <bpf/bpf.h>
> +#include <linux/filter.h>
>  #include <linux/err.h>
>  #include <linux/kernel.h>
>  #include <linux/string.h>
> @@ -49,6 +50,7 @@ struct bpf_prog_priv {
>  	struct bpf_insn *insns_buf;
>  	int nr_types;
>  	int *type_mapping;
> +	int *prologue_fds;
>  };
>  
>  struct bpf_perf_object {
> @@ -56,6 +58,11 @@ struct bpf_perf_object {
>  	struct bpf_object *obj;
>  };
>  
> +struct bpf_preproc_result {
> +	struct bpf_insn *new_insn_ptr;
> +	int new_insn_cnt;
> +};
> +
>  static LIST_HEAD(bpf_objects_list);
>  static struct hashmap *bpf_program_hash;
>  static struct hashmap *bpf_map_hash;
> @@ -86,6 +93,7 @@ bpf_perf_object__next(struct bpf_perf_object *prev)
>  	     (perf_obj) = (tmp), (tmp) = bpf_perf_object__next(tmp))
>  
>  static bool libbpf_initialized;
> +static int libbpf_sec_handler;
>  
>  static int bpf_perf_object__add(struct bpf_object *obj)
>  {
> @@ -99,12 +107,76 @@ static int bpf_perf_object__add(struct bpf_object *obj)
>  	return perf_obj ? 0 : -ENOMEM;
>  }
>  
> +static void *program_priv(const struct bpf_program *prog)
> +{
> +	void *priv;
> +
> +	if (IS_ERR_OR_NULL(bpf_program_hash))
> +		return NULL;
> +	if (!hashmap__find(bpf_program_hash, prog, &priv))
> +		return NULL;
> +	return priv;
> +}
> +
> +static struct bpf_insn prologue_init_insn[] = {
> +	BPF_MOV64_IMM(BPF_REG_2, 0),
> +	BPF_MOV64_IMM(BPF_REG_3, 0),
> +	BPF_MOV64_IMM(BPF_REG_4, 0),
> +	BPF_MOV64_IMM(BPF_REG_5, 0),
> +};
> +
> +static int libbpf_prog_prepare_load_fn(struct bpf_program *prog,
> +				       struct bpf_prog_load_opts *opts __maybe_unused,
> +				       long cookie __maybe_unused)
> +{
> +	size_t init_size_cnt = ARRAY_SIZE(prologue_init_insn);
> +	size_t orig_insn_cnt, insn_cnt, init_size, orig_size;
> +	struct bpf_prog_priv *priv = program_priv(prog);
> +	const struct bpf_insn *orig_insn;
> +	struct bpf_insn *insn;
> +
> +	if (IS_ERR_OR_NULL(priv)) {
> +		pr_debug("bpf: failed to get private field\n");
> +		return -BPF_LOADER_ERRNO__INTERNAL;
> +	}
> +
> +	if (!priv->need_prologue)
> +		return 0;
> +
> +	/* prepend initialization code to program instructions */
> +	orig_insn = bpf_program__insns(prog);
> +	orig_insn_cnt = bpf_program__insn_cnt(prog);
> +	init_size = init_size_cnt * sizeof(*insn);
> +	orig_size = orig_insn_cnt * sizeof(*insn);
> +
> +	insn_cnt = orig_insn_cnt + init_size_cnt;
> +	insn = malloc(insn_cnt * sizeof(*insn));
> +	if (!insn)
> +		return -ENOMEM;
> +
> +	memcpy(insn, prologue_init_insn, init_size);
> +	memcpy((char *) insn + init_size, orig_insn, orig_size);
> +	bpf_program__set_insns(prog, insn, insn_cnt);
> +	return 0;
> +}
> +
>  static int libbpf_init(void)
>  {
> +	LIBBPF_OPTS(libbpf_prog_handler_opts, handler_opts,
> +		.prog_prepare_load_fn = libbpf_prog_prepare_load_fn,
> +	);
> +
>  	if (libbpf_initialized)
>  		return 0;
>  
>  	libbpf_set_print(libbpf_perf_print);
> +	libbpf_sec_handler = libbpf_register_prog_handler(NULL, BPF_PROG_TYPE_KPROBE,
> +							  0, &handler_opts);
> +	if (libbpf_sec_handler < 0) {
> +		pr_debug("bpf: failed to register libbpf section handler: %d\n",
> +			 libbpf_sec_handler);
> +		return -BPF_LOADER_ERRNO__INTERNAL;
> +	}
>  	libbpf_initialized = true;
>  	return 0;
>  }
> @@ -188,14 +260,31 @@ struct bpf_object *bpf__prepare_load(const char *filename, bool source)
>  	return obj;
>  }
>  
> +static void close_prologue_programs(struct bpf_prog_priv *priv)
> +{
> +	struct perf_probe_event *pev;
> +	int i, fd;
> +
> +	if (!priv->need_prologue)
> +		return;
> +	pev = &priv->pev;
> +	for (i = 0; i < pev->ntevs; i++) {
> +		fd = priv->prologue_fds[i];
> +		if (fd != -1)
> +			close(fd);
> +	}
> +}
> +
>  static void
>  clear_prog_priv(const struct bpf_program *prog __maybe_unused,
>  		void *_priv)
>  {
>  	struct bpf_prog_priv *priv = _priv;
>  
> +	close_prologue_programs(priv);
>  	cleanup_perf_probe_events(&priv->pev, 1);
>  	zfree(&priv->insns_buf);
> +	zfree(&priv->prologue_fds);
>  	zfree(&priv->type_mapping);
>  	zfree(&priv->sys_name);
>  	zfree(&priv->evt_name);
> @@ -243,17 +332,6 @@ static bool ptr_equal(const void *key1, const void *key2,
>  	return key1 == key2;
>  }
>  
> -static void *program_priv(const struct bpf_program *prog)
> -{
> -	void *priv;
> -
> -	if (IS_ERR_OR_NULL(bpf_program_hash))
> -		return NULL;
> -	if (!hashmap__find(bpf_program_hash, prog, &priv))
> -		return NULL;
> -	return priv;
> -}
> -
>  static int program_set_priv(struct bpf_program *prog, void *priv)
>  {
>  	void *old_priv;
> @@ -558,8 +636,8 @@ static int bpf__prepare_probe(void)
>  
>  static int
>  preproc_gen_prologue(struct bpf_program *prog, int n,
> -		     struct bpf_insn *orig_insns, int orig_insns_cnt,
> -		     struct bpf_prog_prep_result *res)
> +		     const struct bpf_insn *orig_insns, int orig_insns_cnt,
> +		     struct bpf_preproc_result *res)
>  {
>  	struct bpf_prog_priv *priv = program_priv(prog);
>  	struct probe_trace_event *tev;
> @@ -607,7 +685,6 @@ preproc_gen_prologue(struct bpf_program *prog, int n,
>  
>  	res->new_insn_ptr = buf;
>  	res->new_insn_cnt = prologue_cnt + orig_insns_cnt;
> -	res->pfd = NULL;
>  	return 0;
>  
>  errout:
> @@ -715,7 +792,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
>  	struct bpf_prog_priv *priv = program_priv(prog);
>  	struct perf_probe_event *pev;
>  	bool need_prologue = false;
> -	int err, i;
> +	int i;
>  
>  	if (IS_ERR_OR_NULL(priv)) {
>  		pr_debug("Internal error when hook preprocessor\n");
> @@ -753,6 +830,13 @@ static int hook_load_preprocessor(struct bpf_program *prog)
>  		return -ENOMEM;
>  	}
>  
> +	priv->prologue_fds = malloc(sizeof(int) * pev->ntevs);
> +	if (!priv->prologue_fds) {
> +		pr_debug("Not enough memory: alloc prologue fds failed\n");
> +		return -ENOMEM;
> +	}
> +	memset(priv->prologue_fds, -1, sizeof(int) * pev->ntevs);
> +
>  	priv->type_mapping = malloc(sizeof(int) * pev->ntevs);
>  	if (!priv->type_mapping) {
>  		pr_debug("Not enough memory: alloc type_mapping failed\n");
> @@ -761,13 +845,7 @@ static int hook_load_preprocessor(struct bpf_program *prog)
>  	memset(priv->type_mapping, -1,
>  	       sizeof(int) * pev->ntevs);
>  
> -	err = map_prologue(pev, priv->type_mapping, &priv->nr_types);
> -	if (err)
> -		return err;
> -
> -	err = bpf_program__set_prep(prog, priv->nr_types,
> -				    preproc_gen_prologue);
> -	return err;
> +	return map_prologue(pev, priv->type_mapping, &priv->nr_types);
>  }
>  
>  int bpf__probe(struct bpf_object *obj)
> @@ -874,6 +952,77 @@ int bpf__unprobe(struct bpf_object *obj)
>  	return ret;
>  }
>  
> +static int bpf_object__load_prologue(struct bpf_object *obj)
> +{
> +	int init_cnt = ARRAY_SIZE(prologue_init_insn);
> +	const struct bpf_insn *orig_insns;
> +	struct bpf_preproc_result res;
> +	struct perf_probe_event *pev;
> +	struct bpf_program *prog;
> +	int orig_insns_cnt;
> +
> +	bpf_object__for_each_program(prog, obj) {
> +		struct bpf_prog_priv *priv = program_priv(prog);
> +		int err, i, fd;
> +
> +		if (IS_ERR_OR_NULL(priv)) {
> +			pr_debug("bpf: failed to get private field\n");
> +			return -BPF_LOADER_ERRNO__INTERNAL;
> +		}
> +
> +		if (!priv->need_prologue)
> +			continue;
> +
> +		/*
> +		 * For each program that needs prologue we do following:
> +		 *
> +		 * - take its current instructions and use them
> +		 *   to generate the new code with prologue
> +		 * - load new instructions with bpf_prog_load
> +		 *   and keep the fd in prologue_fds
> +		 * - new fd will be used in bpf__foreach_event
> +		 *   to connect this program with perf evsel
> +		 */
> +		orig_insns = bpf_program__insns(prog);
> +		orig_insns_cnt = bpf_program__insn_cnt(prog);
> +
> +		pev = &priv->pev;
> +		for (i = 0; i < pev->ntevs; i++) {
> +			/*
> +			 * Skipping artificall prologue_init_insn instructions
> +			 * (init_cnt), so the prologue can be generated instead
> +			 * of them.
> +			 */
> +			err = preproc_gen_prologue(prog, i,
> +						   orig_insns + init_cnt,
> +						   orig_insns_cnt - init_cnt,
> +						   &res);
> +			if (err)
> +				return err;
> +
> +			fd = bpf_prog_load(bpf_program__get_type(prog),
> +					   bpf_program__name(prog), "GPL",
> +					   res.new_insn_ptr,
> +					   res.new_insn_cnt, NULL);
> +			if (fd < 0) {
> +				char bf[128];
> +
> +				libbpf_strerror(-errno, bf, sizeof(bf));
> +				pr_debug("bpf: load objects with prologue failed: err=%d: (%s)\n",
> +					 -errno, bf);
> +				return -errno;
> +			}
> +			priv->prologue_fds[i] = fd;
> +		}
> +		/*
> +		 * We no longer need the original program,
> +		 * we can unload it.
> +		 */
> +		bpf_program__unload(prog);
> +	}
> +	return 0;
> +}
> +
>  int bpf__load(struct bpf_object *obj)
>  {
>  	int err;
> @@ -885,7 +1034,7 @@ int bpf__load(struct bpf_object *obj)
>  		pr_debug("bpf: load objects failed: err=%d: (%s)\n", err, bf);
>  		return err;
>  	}
> -	return 0;
> +	return bpf_object__load_prologue(obj);
>  }
>  
>  int bpf__foreach_event(struct bpf_object *obj,
> @@ -920,13 +1069,10 @@ int bpf__foreach_event(struct bpf_object *obj,
>  		for (i = 0; i < pev->ntevs; i++) {
>  			tev = &pev->tevs[i];
>  
> -			if (priv->need_prologue) {
> -				int type = priv->type_mapping[i];
> -
> -				fd = bpf_program__nth_fd(prog, type);
> -			} else {
> +			if (priv->need_prologue)
> +				fd = priv->prologue_fds[i];
> +			else
>  				fd = bpf_program__fd(prog);
> -			}
>  
>  			if (fd < 0) {
>  				pr_debug("bpf: failed to get file descriptor\n");
> -- 
> 2.35.3

-- 

- Arnaldo

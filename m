Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5933DF839
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhHCXGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:06:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:59442 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbhHCXGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 19:06:49 -0400
Received: from sslproxy02.your-server.de ([78.47.166.47])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mB3Ua-0004Ki-Hd; Wed, 04 Aug 2021 01:06:36 +0200
Received: from [85.5.47.65] (helo=linux.home)
        by sslproxy02.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1mB3Ua-000WzR-At; Wed, 04 Aug 2021 01:06:36 +0200
Subject: Re: [PATCH bpf-next v3 2/8] samples: bpf: Add common infrastructure
 for XDP samples
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
References: <20210728165552.435050-1-memxor@gmail.com>
 <20210728165552.435050-3-memxor@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6a0ba11a-d2a5-38ec-0462-58212c8a4ca7@iogearbox.net>
Date:   Wed, 4 Aug 2021 01:06:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210728165552.435050-3-memxor@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26252/Tue Aug  3 10:19:46 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/21 6:55 PM, Kumar Kartikeya Dwivedi wrote:
> This file implements some common helpers to consolidate differences in
> features and functionality between the various XDP samples and give them
> a consistent look, feel, and reporting capabilities.
> 
> Some of the key features are:
>   * A concise output format accompanied by helpful text explaining its
>     fields.
>   * An elaborate output format building upon the concise one, and folding
>     out details in case of errors and staying out of view otherwise.
>   * Extended reporting of redirect errors by capturing hits for each
>     errno and displaying them inline (ENETDOWN, EINVAL, ENOSPC, etc.)
>     to aid debugging.
>   * Reporting of each xdp_exception action for all samples that use these
>     helpers (XDP_ABORTED, etc.) to aid debugging.
>   * Capturing per ifindex pair devmap_xmit counts for decomposing the
>     total TX count per devmap redirection.
>   * Ability to jump to source locations invoking tracepoints.
>   * Faster retrieval of stats per polling interval using mmap'd eBPF
>     array map (through .bss).
>   * Printing driver names for devices redirecting packets.
>   * Printing summarized total statistics for the entire session.
>   * Ability to dynamically switch between concise and verbose mode, using
>     SIGQUIT (Ctrl + \).
> 
> The goal is sharing these helpers that most of the XDP samples implement
> in some form but differently for each, lacking in some respect compared
> to one another.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

Overall I think it's okay to try to streamline the individual XDP tools, but I
also tend to wonder whether we keep going beyond the original purpose of kernel
samples where the main goal is to provide small, easy to hack & stand-alone code
snippets (like in samples/seccomp ... no doubt we have it more complex in BPF
land, but still); things people can take away and extend for their purpose. A big
portion of the samples are still better off in selftests so they can be run in CI,
and those that are not should generally be simplified for developers to rip out,
modify, experiment, and build actual applications on top.

> ---
>   samples/bpf/Makefile            |    3 +-
>   samples/bpf/xdp_sample_shared.h |   47 +
>   samples/bpf/xdp_sample_user.c   | 1732 +++++++++++++++++++++++++++++++
>   samples/bpf/xdp_sample_user.h   |   94 ++

I would have wished that rather than a single patch to get all the boilerplate
code in at once to have incremental improvements that refactor the individual
sample tools along the way.

>   4 files changed, 1875 insertions(+), 1 deletion(-)
>   create mode 100644 samples/bpf/xdp_sample_shared.h
>   create mode 100644 samples/bpf/xdp_sample_user.c
>   create mode 100644 samples/bpf/xdp_sample_user.h
> 
> diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> index 036998d11ded..d8fc3e6930f9 100644
> --- a/samples/bpf/Makefile
> +++ b/samples/bpf/Makefile
> @@ -62,6 +62,7 @@ LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
>   
>   CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
>   TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
> +XDP_SAMPLE := xdp_sample_user.o
>   
>   fds_example-objs := fds_example.o
>   sockex1-objs := sockex1_user.o
> @@ -210,7 +211,7 @@ TPROGS_CFLAGS += --sysroot=$(SYSROOT)
>   TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
>   endif
>   
> -TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
> +TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz -lm
>   TPROGLDLIBS_tracex4		+= -lrt
>   TPROGLDLIBS_trace_output	+= -lrt
>   TPROGLDLIBS_map_perf_test	+= -lrt
> diff --git a/samples/bpf/xdp_sample_shared.h b/samples/bpf/xdp_sample_shared.h
> new file mode 100644
> index 000000000000..0eb3c2b526d4
> --- /dev/null
> +++ b/samples/bpf/xdp_sample_shared.h
> @@ -0,0 +1,47 @@
> +#ifndef _XDP_SAMPLE_SHARED_H
> +#define _XDP_SAMPLE_SHARED_H
> +
> +/*
> + * Relaxed load/store
> + * __atomic_load_n/__atomic_store_n built-in is not supported for BPF target
> + */
> +#define NO_TEAR_LOAD(var) ({ (*(volatile typeof(var) *)&(var)); })
> +#define NO_TEAR_STORE(var, val) ({ *((volatile typeof(var) *)&(var)) = (val); })

Can't we reuse READ_ONCE() / WRITE_ONCE() from tools/include/linux/compiler.h instead
of readding the same here again? We already rely on using the tooling include infra
anyway for samples.

> +/* This does a load + store instead of the expensive atomic fetch add, but store
> + * is still atomic so that userspace reading the value reads the old or the new
> + * one, but not a partial store.
> + */
> +#define NO_TEAR_ADD(var, val)                                                  \
> +	({                                                                     \
> +		typeof(val) __val = (val);                                     \
> +		if (__val)                                                     \
> +			NO_TEAR_STORE((var), (var) + __val);                   \
> +	})
> +
> +#define NO_TEAR_INC(var) NO_TEAR_ADD((var), 1)

This could likely also go there.

> +#define MAX_CPUS 64

Given this is a heavy rework of samples, can't we also fix up this assumption?

> +#define ELEMENTS_OF(x) (sizeof(x) / sizeof(*(x)))

See ARRAY_SIZE() under tools/include/linux/kernel.h .

> +struct datarec {
> +	size_t processed;
> +	size_t dropped;
> +	size_t issue;
> +	union {
> +		size_t xdp_pass;
> +		size_t info;
> +	};
> +	size_t xdp_drop;
> +	size_t xdp_redirect;

Why all size_t, can't we just use __u64 for the stats?

> +} __attribute__((aligned(64)));
> +
> +struct sample_data {
> +	struct datarec rx_cnt[MAX_CPUS];
> +	struct datarec redirect_err_cnt[7 * MAX_CPUS];
> +	struct datarec cpumap_enqueue_cnt[MAX_CPUS * MAX_CPUS];
> +	struct datarec cpumap_kthread_cnt[MAX_CPUS];
> +	struct datarec exception_cnt[6 * MAX_CPUS];
> +	struct datarec devmap_xmit_cnt[MAX_CPUS];
> +};
> +
> +#endif
> diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
> new file mode 100644
> index 000000000000..06efc2bfd84e
> --- /dev/null
> +++ b/samples/bpf/xdp_sample_user.c
> @@ -0,0 +1,1732 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +#define _GNU_SOURCE
> +
> +#include <errno.h>
> +#include <signal.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <stdbool.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <math.h>
> +#include <locale.h>
> +#include <sys/signalfd.h>
> +#include <sys/resource.h>
> +#include <sys/sysinfo.h>
> +#include <sys/timerfd.h>
> +#include <getopt.h>
> +#include <net/if.h>
> +#include <time.h>
> +#include <linux/limits.h>
> +#include <sys/ioctl.h>
> +#include <net/if.h>
> +#include <poll.h>
> +#include <linux/ethtool.h>
> +#include <linux/sockios.h>
> +#ifndef SIOCETHTOOL
> +#define SIOCETHTOOL 0x8946
> +#endif
> +#include <fcntl.h>
> +#include <arpa/inet.h>
> +#include <linux/if_link.h>
> +#include <sys/utsname.h>
> +#include <bpf/bpf.h>
> +#include <bpf/libbpf.h>
> +#include "bpf_util.h"
> +#include "xdp_sample_user.h"

nit: Pls order the above a bit better.

> +#define __sample_print(fmt, cond, printer, ...)                                \
> +	({                                                                     \
> +		if (cond)                                                      \
> +			printer(fmt, ##__VA_ARGS__);                           \
> +	})
> +
> +#define print_always(fmt, ...) __sample_print(fmt, 1, printf, ##__VA_ARGS__)
> +#define print_default(fmt, ...)                                                \
> +	__sample_print(fmt, sample.log_level & LL_DEFAULT, printf, ##__VA_ARGS__)
> +#define __print_err(err, fmt, printer, ...)                                    \
> +	({                                                                     \
> +		__sample_print(fmt, err > 0 || sample.log_level & LL_DEFAULT,  \
> +			       printer, ##__VA_ARGS__);                        \
> +		sample.err_exp = sample.err_exp ? true : err > 0;              \
> +	})
> +#define print_err(err, fmt, ...) __print_err(err, fmt, printf, ##__VA_ARGS__)
> +
> +#define print_link_err(err, str, width, type)                                  \
> +	__print_err(err, str, print_link, width, type)

Couldn't this all be more generalized so other non-XDP samples can use it as well
potentially?

> +#define __COLUMN(x) "%'10" x " %-13s"
> +#define FMT_COLUMNf __COLUMN(".0f")
> +#define FMT_COLUMNd __COLUMN("d")
> +#define FMT_COLUMNl __COLUMN("llu")
> +#define RX(rx) rx, "rx/s"
> +#define PPS(pps) pps, "pkt/s"
> +#define DROP(drop) drop, "drop/s"
> +#define ERR(err) err, "error/s"
> +#define HITS(hits) hits, "hit/s"
> +#define XMIT(xmit) xmit, "xmit/s"
> +#define PASS(pass) pass, "pass/s"
> +#define REDIR(redir) redir, "redir/s"
> +#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
> +
> +#define XDP_UNKNOWN (XDP_REDIRECT + 1)
> +#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
> +#define XDP_REDIRECT_ERR_MAX	7
> +
> +enum tp_type {
> +	TP_REDIRECT_CNT,
> +	TP_REDIRECT_MAP_CNT,
> +	TP_REDIRECT_ERR_CNT,
> +	TP_REDIRECT_MAP_ERR_CNT,
> +	TP_CPUMAP_ENQUEUE_CNT,
> +	TP_CPUMAP_KTHREAD_CNT,
> +	TP_EXCEPTION_CNT,
> +	TP_DEVMAP_XMIT_CNT,
> +	NUM_TP,
> +};
> +
> +enum map_type {
> +	MAP_DEVMAP_XMIT_MULTI,
> +	NUM_MAP,
> +};
> +
> +enum log_level {
> +	LL_DEFAULT = 1U << 0,
> +	LL_SIMPLE  = 1U << 1,
> +	LL_DEBUG   = 1U << 2,
> +};
> +
> +struct record {
> +	__u64 timestamp;
> +	struct datarec total;
> +	struct datarec *cpu;
> +};
> +
> +struct stats_record {
> +	struct record rx_cnt;
> +	struct record redir_err[XDP_REDIRECT_ERR_MAX];
> +	struct record kthread;
> +	struct record exception[XDP_ACTION_MAX];
> +	struct record devmap_xmit;
> +	struct hash_map *devmap_xmit_multi;
> +	struct record enq[];
> +};
> +
> +struct sample_output {
> +	struct {
> +		__u64 rx;
> +		__u64 redir;
> +		__u64 drop;
> +		__u64 drop_xmit;
> +		__u64 err;
> +		__u64 xmit;
> +	} totals;
> +	struct {
> +		__u64 pps;
> +		__u64 drop;
> +		__u64 err;
> +	} rx_cnt;
> +	struct {
> +		__u64 suc;
> +		__u64 err;
> +	} redir_cnt;
> +	struct {
> +		__u64 hits;
> +	} except_cnt;
> +	struct {
> +		__u64 pps;
> +		__u64 drop;
> +		__u64 err;
> +		double bavg;
> +	} xmit_cnt;
> +};
> +
> +static struct {
> +	enum log_level log_level;
> +	struct sample_output out;
> +	struct sample_data *data;
> +	unsigned long interval;
> +	int map_fd[NUM_MAP];
> +	struct xdp_desc {
> +		int ifindex;
> +		__u32 prog_id;
> +		int flags;
> +	} xdp_progs[32];
> +	bool err_exp;
> +	int xdp_cnt;
> +	int n_cpus;
> +	int sig_fd;
> +	int mask;
> +} sample;
> +
> +static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
> +	/* Key=1 keeps unknown errors */
> +	"Success", "Unknown", "EINVAL", "ENETDOWN", "EMSGSIZE",
> +	"EOPNOTSUPP", "ENOSPC",
> +};
> +
> +/* Keyed from Unknown */
> +static const char *xdp_redirect_err_help[XDP_REDIRECT_ERR_MAX - 1] = {
> +	"Unknown error",
> +	"Invalid redirection",
> +	"Device being redirected to is down",
> +	"Packet length too large for device",
> +	"Operation not supported",
> +	"No space in ptr_ring of cpumap kthread",
> +};
> +
> +static const char *xdp_action_names[XDP_ACTION_MAX] = {
> +	[XDP_ABORTED]	= "XDP_ABORTED",
> +	[XDP_DROP]	= "XDP_DROP",
> +	[XDP_PASS]	= "XDP_PASS",
> +	[XDP_TX]	= "XDP_TX",
> +	[XDP_REDIRECT]	= "XDP_REDIRECT",
> +	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
> +};
> +
> +static const char *elixir_search[NUM_TP] = {
> +	[TP_REDIRECT_CNT] = "_trace_xdp_redirect",
> +	[TP_REDIRECT_MAP_CNT] = "_trace_xdp_redirect_map",
> +	[TP_REDIRECT_ERR_CNT] = "_trace_xdp_redirect_err",
> +	[TP_REDIRECT_MAP_ERR_CNT] = "_trace_xdp_redirect_map_err",
> +	[TP_CPUMAP_ENQUEUE_CNT] = "trace_xdp_cpumap_enqueue",
> +	[TP_CPUMAP_KTHREAD_CNT] = "trace_xdp_cpumap_kthread",
> +	[TP_EXCEPTION_CNT] = "trace_xdp_exception",
> +	[TP_DEVMAP_XMIT_CNT] = "trace_xdp_devmap_xmit",
> +};

nit: inconsistent style wrt tabs on elixir_search vs xdp_action_names, generally
like the latter is preferred.

> +/* Dumb hashmap to store ifindex pairs datarec for devmap_xmit_cnt_multi */
> +#define HASH_BUCKETS (1 << 5)
> +#define HASH_MASK    (HASH_BUCKETS - 1)
> +
> +#define hash_map_for_each(entry, map)                                          \
> +	for (int __i = 0; __i < HASH_BUCKETS; __i++)                           \
> +		for (entry = map->buckets[__i]; entry; entry = entry->next)
> +
> +struct map_entry {
> +	struct map_entry *next;
> +	__u64 pair;
> +	struct record *val;
> +};
> +
> +struct hash_map {
> +	struct map_entry *buckets[HASH_BUCKETS];
> +};
> +
> +/* From tools/lib/bpf/hashmap.h */

Should this also have same license then?

> +static size_t hash_bits(size_t h, int bits)
> +{
> +	/* shuffle bits and return requested number of upper bits */
> +	if (bits == 0)
> +		return 0;
> +
> +#if (__SIZEOF_SIZE_T__ == __SIZEOF_LONG_LONG__)
> +	/* LP64 case */
> +	return (h * 11400714819323198485llu) >> (__SIZEOF_LONG_LONG__ * 8 - bits);
> +#elif (__SIZEOF_SIZE_T__ <= __SIZEOF_LONG__)
> +	return (h * 2654435769lu) >> (__SIZEOF_LONG__ * 8 - bits);
> +#else
> +#	error "Unsupported size_t size"
> +#endif
> +}
> +
> +static __u64 gettime(void)
> +{
> +	struct timespec t;
> +	int res;
> +
> +	res = clock_gettime(CLOCK_MONOTONIC, &t);
> +	if (res < 0) {
> +		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
> +		exit(EXIT_FAIL);
> +	}
> +	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
> +}
> +
> +int sample_get_cpus(void)
> +{
> +	int cpus = get_nprocs_conf();
> +	return cpus < MAX_CPUS ? cpus : MAX_CPUS;
> +}
> +
> +static int hash_map_add(struct hash_map *map, __u64 pair, struct record *val)
> +{
> +	struct map_entry *e, **b;
> +
> +	e = calloc(1, sizeof(*e));
> +	if (!e)
> +		return -ENOMEM;
> +
> +	val->timestamp = gettime();
> +
> +	e->pair = pair;
> +	e->val = val;
> +
> +	b = &map->buckets[hash_bits((size_t)pair, 5) & HASH_MASK];
> +	if (*b)
> +		e->next = *b;
> +	*b = e;
> +
> +	return 0;
> +}
> +
> +static struct map_entry *hash_map_find(struct hash_map *map, __u64 pair)
> +{
> +	struct map_entry *e;
> +
> +	e = map->buckets[hash_bits((size_t)pair, 5) & HASH_MASK];
> +	for (; e; e = e->next) {
> +		if (e->pair == pair)
> +			break;
> +	}
> +
> +	return e;
> +}
> +
> +static void hash_map_destroy(struct hash_map *map)
> +{
> +	if (!map)
> +		return;
> +
> +	for (int i = 0; i < HASH_BUCKETS; i++) {
> +		struct map_entry *e, *f;
> +
> +		e = map->buckets[i];
> +		while (e) {
> +			f = e;
> +			e = e->next;
> +			free(f->val->cpu);
> +			free(f->val);
> +			free(f);
> +		}
> +	}
> +}

There's also an existing hashtable implementation under
tools/include/linux/hashtable.h, can't we reuse that one?

> +static const char *action2str(int action)
> +{
> +	if (action < XDP_ACTION_MAX)
> +		return xdp_action_names[action];
> +	return NULL;
> +}
> +
> +static void sample_print_help(int mask)
> +{
> +	printf("Output format description\n\n"
> +	       "By default, redirect success statistics are disabled, use -s to enable.\n"
> +	       "The terse output mode is default, verbose mode can be activated using -v\n"
> +	       "Use SIGQUIT (Ctrl + \\) to switch the mode dynamically at runtime\n\n"
> +	       "Terse mode displays at most the following fields:\n"
> +	       "  rx/s        Number of packets received per second\n"
> +	       "  redir/s     Number of packets successfully redirected per second\n"
> +	       "  err,drop/s  Aggregated count of errors per second (including dropped packets)\n"
> +	       "  xmit/s      Number of packets transmitted on the output device per second\n\n"
> +	       "Output description for verbose mode:\n"
> +	       "  FIELD                 DESCRIPTION\n");
> +
> +	if (mask & SAMPLE_RX_CNT) {
> +		printf("  receive\t\tDisplays the number of packets received & errors encountered\n"
> +		       " \t\t\tWhenever an error or packet drop occurs, details of per CPU error\n"
> +		       " \t\t\tand drop statistics will be expanded inline in terse mode.\n"
> +		       " \t\t\t\tpkt/s     - Packets received per second\n"
> +		       " \t\t\t\tdrop/s    - Packets dropped per second\n"
> +		       " \t\t\t\terror/s   - Errors encountered per second\n\n");
> +	}
> +	if (mask & (SAMPLE_REDIRECT_CNT|SAMPLE_REDIRECT_ERR_CNT)) {
> +		printf("  redirect\t\tDisplays the number of packets successfully redirected\n"
> +		       "  \t\t\tErrors encountered are expanded under redirect_err field\n"
> +		       "  \t\t\tNote that passing -s to enable it has a per packet overhead\n"
> +		       "  \t\t\t\tredir/s   - Packets redirected successfully per second\n\n"
> +		       "  redirect_err\t\tDisplays the number of packets that failed redirection\n"
> +		       "  \t\t\tThe errno is expanded under this field with per CPU count\n"
> +		       "  \t\t\tThe recognized errors are:\n");
> +
> +		for (int i = 2; i < XDP_REDIRECT_ERR_MAX; i++)
> +			printf("\t\t\t  %s: %s\n", xdp_redirect_err_names[i],
> +			       xdp_redirect_err_help[i - 1]);
> +
> +		printf("  \n\t\t\t\terror/s   - Packets that failed redirection per second\n\n");
> +	}
> +
> +	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT) {
> +		printf("  enqueue to cpu N\tDisplays the number of packets enqueued to bulk queue of CPU N\n"
> +		       "  \t\t\tExpands to cpu:FROM->N to display enqueue stats for each CPU enqueuing to CPU N\n"
> +		       "  \t\t\tReceived packets can be associated with the CPU redirect program is enqueuing \n"
> +		       "  \t\t\tpackets to.\n"
> +		       "  \t\t\t\tpkt/s    - Packets enqueued per second from other CPU to CPU N\n"
> +		       "  \t\t\t\tdrop/s   - Packets dropped when trying to enqueue to CPU N\n"
> +		       "  \t\t\t\tbulk-avg - Average number of packets processed for each event\n\n");
> +	}
> +
> +	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT) {
> +		printf("  kthread\t\tDisplays the number of packets processed in CPUMAP kthread for each CPU\n"
> +		       "  \t\t\tPackets consumed from ptr_ring in kthread, and its xdp_stats (after calling \n"
> +		       "  \t\t\tCPUMAP bpf prog) are expanded below this. xdp_stats are expanded as a total and\n"
> +		       "  \t\t\tthen per-CPU to associate it to each CPU's pinned CPUMAP kthread.\n"
> +		       "  \t\t\t\tpkt/s    - Packets consumed per second from ptr_ring\n"
> +		       "  \t\t\t\tdrop/s   - Packets dropped per second in kthread\n"
> +		       "  \t\t\t\tsched    - Number of times kthread called schedule()\n\n"
> +		       "  \t\t\txdp_stats (also expands to per-CPU counts)\n"
> +		       "  \t\t\t\tpass/s  - XDP_PASS count for CPUMAP program execution\n"
> +		       "  \t\t\t\tdrop/s  - XDP_DROP count for CPUMAP program execution\n"
> +		       "  \t\t\t\tredir/s - XDP_REDIRECT count for CPUMAP program execution\n\n");
> +	}
> +
> +	if (mask & SAMPLE_EXCEPTION_CNT) {
> +		printf("  xdp_exception\t\tDisplays xdp_exception tracepoint events\n"
> +		       "  \t\t\tThis can occur due to internal driver errors, unrecognized\n"
> +		       "  \t\t\tXDP actions and due to explicit user trigger by use of XDP_ABORTED\n"
> +		       "  \t\t\tEach action is expanded below this field with its count\n"
> +		       "  \t\t\t\thit/s     - Number of times the tracepoint was hit per second\n\n");
> +	}
> +
> +	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
> +		printf("  devmap_xmit\t\tDisplays devmap_xmit tracepoint events\n"
> +		       "  \t\t\tThis tracepoint is invoked for successful transmissions on output\n"
> +		       "  \t\t\tdevice but these statistics are not available for generic XDP mode,\n"
> +		       "  \t\t\thence they will be omitted from the output when using SKB mode\n"
> +		       "  \t\t\t\txmit/s    - Number of packets that were transmitted per second\n"
> +		       "  \t\t\t\tdrop/s    - Number of packets that failed transmissions per second\n"
> +		       "  \t\t\t\tdrv_err/s - Number of internal driver errors per second\n"
> +		       "  \t\t\t\tbulk-avg  - Average number of packets processed for each event\n\n");
> +	}
> +}
[...]
> +static const char *make_url(enum tp_type i)
> +{
> +	const char *key = elixir_search[i];
> +	static struct utsname uts = {};
> +	static char url[128];
> +	static bool uts_init;
> +	int maj, min;
> +	char c[2];
> +
> +	if (!uts_init) {
> +		if (uname(&uts) < 0)
> +			return NULL;
> +		uts_init = true;
> +	}
> +
> +	if (!key || sscanf(uts.release, "%d.%d%1s", &maj, &min, c) != 3)
> +		return NULL;
> +
> +	snprintf(url, sizeof(url), "https://elixir.bootlin.com/linux/v%d.%d/C/ident/%s",
> +		 maj, min, key);
> +
> +	return url;
> +}

I don't think this whole make_url() belongs in here with the link construction to
elixir.bootlin.com, it's just confusing when you have downstream trees with custom
backports.

> +static void print_link(const char *str, int width, enum tp_type i)
> +{
> +	static int t = -1;
> +	const char *s;
> +	int fd, l;
> +
> +	if (t < 0) {
> +		fd = open("/proc/self/fd/1", O_RDONLY);
> +		if (fd < 0)
> +			return;
> +		t = isatty(fd);
> +		close(fd);
> +	}
> +
> +	s = make_url(i);
> +	if (!s || !t) {
> +		printf("  %-*s", width, str);
> +		return;
> +	}
> +
> +	l = strlen(str);
> +	width = width - l > 0 ? width - l : 0;
> +	printf("  \x1B]8;;%s\a%s\x1B]8;;\a%*c", s, str, width, ' ');
> +}

Ditto..

> +static struct datarec *alloc_record_per_cpu(void)
> +{
> +	unsigned int nr_cpus = bpf_num_possible_cpus();
> +	struct datarec *array;
> +
> +	array = calloc(nr_cpus, sizeof(struct datarec));
> +	if (!array) {
> +		fprintf(stderr, "Failed to allocate memory (nr_cpus: %u)\n", nr_cpus);
> +		return NULL;
> +	}
> +	return array;
> +}
[...]
> +static int map_collect_percpu_devmap(int map_fd, struct hash_map *map)
> +{
> +	unsigned int nr_cpus = bpf_num_possible_cpus();
> +	__u32 batch, count = 32;
> +	struct datarec *values;
> +	bool init = false;
> +	__u64 *keys;
> +	int i, ret;
> +
> +	keys = calloc(count, sizeof(__u64));
> +	if (!keys)
> +		return -ENOMEM;
> +	values = calloc(count * nr_cpus, sizeof(struct datarec));
> +	if (!values)

Leaks keys ...

> +		return -ENOMEM;
> +
[...]

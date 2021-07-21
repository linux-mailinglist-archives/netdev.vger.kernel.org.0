Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF04A3D190E
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhGUUsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhGUUsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:48:11 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3482CC061575;
        Wed, 21 Jul 2021 14:28:47 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so2581069pjb.0;
        Wed, 21 Jul 2021 14:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MVzerbGli6klnpw5XV3m99EM5Yhx5rb7oVN/1EafHak=;
        b=olXGjLa4wqcEyAhsWRfRiTrY1GHxbsuYtvhT+TVCzymJ2l71g/9d+YrA6a8AtWZ6jM
         3+sKWLOYiZV7T/FuPHqaor/FxYR2FUnfgayFwpSIMl1HJElfqhTWVdqL3XW8kVFphG+2
         rpMDTV4eVukL2HTBJeEYUTA2GT7aMqYGH7Jzm3t+JbMWz3cW0xiJ87Z4F1Oj8FLTelI6
         a/CsbMVocPJ9AgotuDSSvmvHQFd0ilJflXFQWnD700wd8oZ4Ed9tRQkxqbm2W+Qb6qdp
         839yywE4pc3T6+Hs77f7O/Tuy6kZ23grqnw73fae4Fkk5yhDucRN7CrU4p9GfD+9GvfL
         Vu6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MVzerbGli6klnpw5XV3m99EM5Yhx5rb7oVN/1EafHak=;
        b=q9G8+ue8Ogr2mNK7MJejTIRf1VbxulQ0AKQdgS+7ra/6z04ZG3aNKmGoD46YuYYX3a
         xyT3QMtWenHZ5VoPqpoyYF874A+Gf8V4L9HOfqAQ3tnqVglcS8XRgm7R/IAqKePLFkzW
         AovepjVaN7z4QJQFWqDsV90ZERkq4nsQm/2/X2vpZ8v+B+B9Epdv+khhCuNmzaSNcetc
         aZGy1KVyJ4fjAOKEhUqdv68ScdMJLeKlqyAb9TlhlCvZwpqV8Qb0vIdkhMkqMmubeSdR
         ePe4pnjBkOHpRqflWYxgibdFNDDy27w85NmxWd5y/+xDScBV2igmvxj3D1Axac5Y54JP
         AOJQ==
X-Gm-Message-State: AOAM533i8N4f3vwRKkhah9t+R9P82Lq75l7OCJ3Di17+Bi6t9E93+wV9
        V4AwzsdVnbpmYZf+MSf1bn1jArIu/I8jIA==
X-Google-Smtp-Source: ABdhPJx96gCUMV4CUKPCXtIKP/AHdSTGAQg3DjK4orimLXP63YPIoYfGI94/9kRaxHAQeK3Roq+VsQ==
X-Received: by 2002:a17:90a:2906:: with SMTP id g6mr36633469pjd.100.1626902926345;
        Wed, 21 Jul 2021 14:28:46 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id j2sm29285708pfb.53.2021.07.21.14.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:28:46 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 2/8] samples: bpf: Add common infrastructure for XDP samples
Date:   Thu, 22 Jul 2021 02:58:27 +0530
Message-Id: <20210721212833.701342-3-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721212833.701342-1-memxor@gmail.com>
References: <20210721212833.701342-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This file implements some common helpers to consolidate differences in
features and functionality between the various XDP samples and give them
a consistent look, feel, and reporting capabilities.

Some of the key features are:
 * A concise output format accompanied by helpful text explaining its
   fields.
 * An elaborate output format building upon the concise one, and folding
   out details in case of errors and staying out of view otherwise.
 * Extended reporting of redirect errors by capturing hits for each
   errno and displaying them inline (ENETDOWN, EINVAL, ENOSPC, etc.)
   to aid debugging.
 * Reporting of each xdp_exception action for all samples that use these
   helpers (XDP_ABORTED, etc.) to aid debugging.
 * Capturing per ifindex pair devmap_xmit counts for decomposing the
   total TX count per devmap redirection.
 * Ability to jump to source locations invoking tracepoints.
 * Faster retrieval of stats per polling interval using mmap'd eBPF
   array map (through .bss).
 * Printing driver names for devices redirecting packets.
 * Printing summarized total statistics for the entire session.
 * Ability to dynamically switch between concise and verbose mode, using
   SIGQUIT (Ctrl + \).

The goal is sharing these helpers that most of the XDP samples implement
in some form but differently for each, lacking in some respect compared
to one another.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile            |    6 +-
 samples/bpf/xdp_sample_shared.h |   53 ++
 samples/bpf/xdp_sample_user.c   | 1380 +++++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h   |  202 +++++
 4 files changed, 1640 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/xdp_sample_shared.h
 create mode 100644 samples/bpf/xdp_sample_user.c
 create mode 100644 samples/bpf/xdp_sample_user.h

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 036998d11ded..57ccff5ccac4 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -62,6 +62,7 @@ LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
 
 CGROUP_HELPERS := ../../tools/testing/selftests/bpf/cgroup_helpers.o
 TRACE_HELPERS := ../../tools/testing/selftests/bpf/trace_helpers.o
+XDP_SAMPLE := xdp_sample_user.o
 
 fds_example-objs := fds_example.o
 sockex1-objs := sockex1_user.o
@@ -116,6 +117,8 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_sample_user-objs := xdp_sample_user.o $(LIBBPFDIR)/hashmap.o
+
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
 always-y += sockex1_kern.o
@@ -201,6 +204,7 @@ TPROGS_CFLAGS += -Wstrict-prototypes
 TPROGS_CFLAGS += -I$(objtree)/usr/include
 TPROGS_CFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 TPROGS_CFLAGS += -I$(srctree)/tools/lib/
+TPROGS_CFLAGS += -I$(srctree)/tools/lib/bpf
 TPROGS_CFLAGS += -I$(srctree)/tools/include
 TPROGS_CFLAGS += -I$(srctree)/tools/perf
 TPROGS_CFLAGS += -DHAVE_ATTR_TEST=0
@@ -210,7 +214,7 @@ TPROGS_CFLAGS += --sysroot=$(SYSROOT)
 TPROGS_LDFLAGS := -L$(SYSROOT)/usr/lib
 endif
 
-TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz
+TPROGS_LDLIBS			+= $(LIBBPF) -lelf -lz -lm
 TPROGLDLIBS_tracex4		+= -lrt
 TPROGLDLIBS_trace_output	+= -lrt
 TPROGLDLIBS_map_perf_test	+= -lrt
diff --git a/samples/bpf/xdp_sample_shared.h b/samples/bpf/xdp_sample_shared.h
new file mode 100644
index 000000000000..b211dca233d9
--- /dev/null
+++ b/samples/bpf/xdp_sample_shared.h
@@ -0,0 +1,53 @@
+#ifndef _XDP_SAMPLE_SHARED_H
+#define _XDP_SAMPLE_SHARED_H
+
+/*
+ * Best-effort relaxed load/store
+ * __atomic_load_n/__atomic_store_n built-in is not supported for BPF target
+ */
+#define ATOMIC_LOAD(var) ({ (*(volatile typeof(var) *)&(var)); })
+#define ATOMIC_STORE(var, val) ({ *((volatile typeof(var) *)&(var)) = (val); })
+/* This does a load + store instead of the expensive atomic fetch add, but store
+ * is still atomic so that userspace reading the value reads the old or the new
+ * one, but not a partial store.
+ */
+#define ATOMIC_ADD_NORMW(var, val)                                             \
+	({                                                                     \
+		typeof(val) __val = (val);                                     \
+		if (__val)                                                     \
+			ATOMIC_STORE((var), (var) + __val);                    \
+	})
+
+#define ATOMIC_INC_NORMW(var) ATOMIC_ADD_NORMW((var), 1)
+
+#define MAX_CPUS 64
+
+/* Values being read/stored must be word sized */
+#if __LP64__
+typedef __u64 datarec_t;
+#else
+typedef __u32 datarec_t;
+#endif
+
+struct datarec {
+	datarec_t processed;
+	datarec_t dropped;
+	datarec_t issue;
+	union {
+		datarec_t xdp_pass;
+		datarec_t info;
+	};
+	datarec_t xdp_drop;
+	datarec_t xdp_redirect;
+} __attribute__((aligned(64)));
+
+struct sample_data {
+	struct datarec rx_cnt[MAX_CPUS];
+	struct datarec redirect_err_cnt[7 * MAX_CPUS];
+	struct datarec cpumap_enqueue_cnt[MAX_CPUS * MAX_CPUS];
+	struct datarec cpumap_kthread_cnt[MAX_CPUS];
+	struct datarec exception_cnt[6 * MAX_CPUS];
+	struct datarec devmap_xmit_cnt[MAX_CPUS];
+};
+
+#endif
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
new file mode 100644
index 000000000000..8180ff56b415
--- /dev/null
+++ b/samples/bpf/xdp_sample_user.c
@@ -0,0 +1,1380 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
+
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <unistd.h>
+#include <math.h>
+#include <locale.h>
+#include <sys/signalfd.h>
+#include <sys/resource.h>
+#include <sys/sysinfo.h>
+#include <sys/timerfd.h>
+#include <getopt.h>
+#include <net/if.h>
+#include <time.h>
+#include <linux/limits.h>
+#include <sys/ioctl.h>
+#include <net/if.h>
+#include <poll.h>
+#include <linux/ethtool.h>
+#include <linux/sockios.h>
+#ifndef SIOCETHTOOL
+#define SIOCETHTOOL 0x8946
+#endif
+#include <fcntl.h>
+#include <arpa/inet.h>
+#include <linux/if_link.h>
+#include <sys/utsname.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+
+static struct {
+	enum log_level log_level;
+	struct sample_output out;
+	struct sample_data *data;
+	int map_fd[NUM_MAP];
+	struct xdp_desc {
+		int ifindex;
+		__u32 prog_id;
+		int flags;
+	} xdp_progs[32];
+	int xdp_cnt;
+	bool err_exp;
+	int n_cpus;
+	int sig_fd;
+	int mask;
+} sample;
+
+#define __sample_print(fmt, cond, printer, ...)                                \
+	({                                                                     \
+		if (cond)                                                      \
+			printer(fmt, ##__VA_ARGS__);                           \
+	})
+
+#define print_always(fmt, ...) __sample_print(fmt, 1, printf, ##__VA_ARGS__)
+#define print_default(fmt, ...)                                                \
+	__sample_print(fmt, sample.log_level & LL_DEFAULT, printf, ##__VA_ARGS__)
+#define __print_err(err, fmt, printer, ...)                                    \
+	({                                                                     \
+		__sample_print(fmt, err > 0 || sample.log_level & LL_DEFAULT,  \
+			       printer, ##__VA_ARGS__);                        \
+		sample.err_exp = sample.err_exp ? true : err > 0;              \
+	})
+#define print_err(err, fmt, ...) __print_err(err, fmt, printf, ##__VA_ARGS__)
+
+#define print_link_err(err, str, width, type)                                  \
+	__print_err(err, str, print_link, width, type)
+
+#define __COLUMN(x) "%'10" x " %-13s"
+#define FMT_COLUMNf __COLUMN(".0f")
+#define FMT_COLUMNd __COLUMN("d")
+#define FMT_COLUMNl __COLUMN("llu")
+#define RX(rx) rx, "rx/s"
+#define PPS(pps) pps, "pkt/s"
+#define DROP(drop) drop, "drop/s"
+#define ERR(err) err, "error/s"
+#define HITS(hits) hits, "hit/s"
+#define XMIT(xmit) xmit, "xmit/s"
+#define PASS(pass) pass, "pass/s"
+#define REDIR(redir) redir, "redir/s"
+#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
+
+void sample_print_help(int mask)
+{
+	printf("Output format description\n\n"
+	       "By default, redirect success statistics are disabled, use -s to enable.\n"
+	       "The terse output mode is default, verbose mode can be activated using -v\n"
+	       "Use SIGQUIT (Ctrl + \\) to switch the mode dynamically at runtime\n\n"
+	       "Terse mode displays at most the following fields:\n"
+	       "  rx/s        Number of packets received per second\n"
+	       "  redir/s     Number of packets successfully redirected per second\n"
+	       "  err,drop/s  Aggregated count of errors per second (including dropped packets)\n"
+	       "  xmit/s      Number of packets transmitted on the output device per second\n\n"
+	       "Output description for verbose mode:\n"
+	       "  FIELD         DESCRIPTION\n");
+
+	if (mask & SAMPLE_RX_CNT) {
+		printf("  receive\tDisplays the number of packets received & errors encountered\n"
+		       " \t\tWhenever an error or packet drop occurs, details of per CPU error\n"
+		       " \t\tand drop statistics will be expanded inline in terse mode.\n"
+		       " \t\t\tpkt/s     - Packets received per second\n"
+		       " \t\t\tdrop/s    - Packets dropped per second\n"
+		       " \t\t\terror/s   - Errors encountered per second\n\n");
+	}
+	if (mask & (SAMPLE_REDIRECT_CNT|SAMPLE_REDIRECT_ERR_CNT)) {
+		printf("  redirect\tDisplays the number of packets successfully redirected\n"
+		       "  \t\tErrors encountered are expanded under redirect_err field\n"
+		       "  \t\tNote that passing -s to enable it has a per packet overhead\n"
+		       "  \t\t\tredir/s   - Packets redirected successfully per second\n\n"
+		       "  redirect_err\tDisplays the number of packets that failed redirection\n"
+		       "  \t\tThe errno is expanded under this field with per CPU count\n"
+		       "  \t\tThe recognized errors are EOPNOTSUPP, EINVAL, ENETDOWN and EMSGSIZE\n"
+		       "  \t\t\terror/s   - Packets that failed redirection per second\n\n");
+	}
+
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		printf("  xdp_exception\tDisplays xdp_exception tracepoint events\n"
+		       "  \t\tThis can occur due to internal driver errors, unrecognized\n"
+		       "  \t\tXDP actions and due to explicit user trigger by use of XDP_ABORTED\n"
+		       "  \t\tEach action is expanded below this field with its count\n"
+		       "  \t\t\thit/s     - Number of times the tracepoint was hit per second\n\n");
+	}
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
+		printf("  devmap_xmit\tDisplays devmap_xmit tracepoint events\n"
+		       "  \t\tThis tracepoint is invoked for successful transmissions on output\n"
+		       "  \t\tdevice but these statistics are not available for generic XDP mode,\n"
+		       "  \t\thence they will be omitted from the output when using SKB mode\n"
+		       "  \t\t\txmit/s    - Number of packets that were transmitted per second\n"
+		       "  \t\t\tdrop/s    - Number of packets that failed transmissions per second\n"
+		       "  \t\t\tdrv_err/s - Number of internal driver errors per second\n"
+		       "  \t\t\tbulk_avg  - Average number of packets processed for each event\n\n");
+	}
+}
+
+static const char *elixir_search[NUM_TP] = {
+	[TP_REDIRECT_CNT] = "_trace_xdp_redirect",
+	[TP_REDIRECT_MAP_CNT] = "_trace_xdp_redirect_map",
+	[TP_REDIRECT_ERR_CNT] = "_trace_xdp_redirect_err",
+	[TP_REDIRECT_MAP_ERR_CNT] = "_trace_xdp_redirect_map_err",
+	[TP_CPUMAP_ENQUEUE_CNT] = "trace_xdp_cpumap_enqueue",
+	[TP_CPUMAP_KTHREAD_CNT] = "trace_xdp_cpumap_kthread",
+	[TP_EXCEPTION_CNT] = "trace_xdp_exception",
+	[TP_DEVMAP_XMIT_CNT] = "trace_xdp_devmap_xmit",
+};
+
+static const char *make_url(enum tp_type i)
+{
+	const char *key = elixir_search[i];
+	static struct utsname uts = {};
+	static char url[128];
+	static bool uts_init;
+	int maj, min;
+	char c[2];
+
+	if (!uts_init) {
+		if (uname(&uts) < 0)
+			return NULL;
+		uts_init = true;
+	}
+
+	if (!key || sscanf(uts.release, "%d.%d%1s", &maj, &min, c) != 3)
+		return NULL;
+
+	snprintf(url, sizeof(url), "https://elixir.bootlin.com/linux/v%d.%d/C/ident/%s",
+		 maj, min, key);
+
+	return url;
+}
+
+static void print_link(const char *str, int width, enum tp_type i)
+{
+	static int t = -1;
+	const char *s;
+	int fd, l;
+
+	if (t < 0) {
+		fd = open("/proc/self/fd/1", O_RDONLY);
+		if (fd < 0)
+			return;
+		t = isatty(fd);
+		close(fd);
+	}
+
+	s = make_url(i);
+	if (!s || !t) {
+		printf("  %-*s", width, str);
+		return;
+	}
+
+	l = strlen(str);
+	width = width - l > 0 ? width - l : 0;
+	printf("  \x1B]8;;%s\a%s\x1B]8;;\a%*c", s, str, width, ' ');
+}
+
+static __u64 gettime(void)
+{
+	struct timespec t;
+	int res;
+
+	res = clock_gettime(CLOCK_MONOTONIC, &t);
+	if (res < 0) {
+		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
+		exit(EXIT_FAIL);
+	}
+	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
+}
+
+static struct datarec *alloc_record_per_cpu(void)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	struct datarec *array;
+
+	array = calloc(nr_cpus, sizeof(struct datarec));
+	if (!array) {
+		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
+		exit(EXIT_FAIL_MEM);
+	}
+	return array;
+}
+
+static void map_collect_percpu(struct datarec *values, struct record *rec)
+{
+	/* For percpu maps, userspace gets a value per possible CPU */
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u64 sum_xdp_redirect = 0;
+	__u64 sum_processed = 0;
+	__u64 sum_xdp_pass = 0;
+	__u64 sum_xdp_drop = 0;
+	__u64 sum_dropped = 0;
+	__u64 sum_issue = 0;
+	int i;
+
+	/* Get time as close as possible to reading map contents */
+	rec->timestamp = gettime();
+
+	/* Record and sum values from each CPU */
+	for (i = 0; i < nr_cpus; i++) {
+		rec->cpu[i].processed = ATOMIC_LOAD(values[i].processed);
+		rec->cpu[i].dropped = ATOMIC_LOAD(values[i].dropped);
+		rec->cpu[i].issue = ATOMIC_LOAD(values[i].issue);
+		rec->cpu[i].xdp_pass = ATOMIC_LOAD(values[i].xdp_pass);
+		rec->cpu[i].xdp_drop = ATOMIC_LOAD(values[i].xdp_drop);
+		rec->cpu[i].xdp_redirect = ATOMIC_LOAD(values[i].xdp_redirect);
+
+		sum_processed += rec->cpu[i].processed;
+		sum_dropped += rec->cpu[i].dropped;
+		sum_issue += rec->cpu[i].issue;
+		sum_xdp_pass += rec->cpu[i].xdp_pass;
+		sum_xdp_drop += rec->cpu[i].xdp_drop;
+		sum_xdp_redirect += rec->cpu[i].xdp_redirect;
+	}
+
+	rec->total.processed = sum_processed;
+	rec->total.dropped = sum_dropped;
+	rec->total.issue = sum_issue;
+	rec->total.xdp_pass = sum_xdp_pass;
+	rec->total.xdp_drop = sum_xdp_drop;
+	rec->total.xdp_redirect = sum_xdp_redirect;
+}
+
+static int map_collect_percpu_devmap(int map_fd, struct hashmap *map)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u32 batch, count = 8;
+	struct datarec *values;
+	bool init = false;
+	__u64 *keys;
+	int i, ret;
+
+	keys = calloc(8 * nr_cpus, sizeof(__u64));
+	if (!keys)
+		return -ENOMEM;
+	values = calloc(8 * nr_cpus, sizeof(struct datarec));
+	if (!values)
+		return -ENOMEM;
+
+	for (;;) {
+		bool exit = false;
+
+		ret = bpf_map_lookup_batch(map_fd, init ? &batch : NULL, &batch,
+					   keys, values, &count, NULL);
+		if (ret < 0 && errno != ENOENT)
+			break;
+		if (errno == ENOENT)
+			exit = true;
+
+		init = true;
+		for (i = 0; i < count; i++) {
+			__u64 pair = keys[i * nr_cpus];
+			struct datarec *arr;
+			void *ex_rec;
+
+			arr = &values[i * nr_cpus];
+			if (!hashmap__find(map, &pair, &ex_rec)) {
+				struct record *rec;
+				__u64 *key;
+
+				key = malloc(sizeof(*key));
+				if (!key)
+					goto cleanup;
+				*key = pair;
+
+				rec = malloc(sizeof(*rec));
+				if (!rec) {
+					free(key);
+					goto cleanup;
+				}
+				rec->cpu = alloc_record_per_cpu();
+				if (!rec) {
+					free(rec);
+					free(key);
+					goto cleanup;
+				}
+
+				map_collect_percpu(arr, rec);
+
+				if (hashmap__add(map, key, rec)) {
+					free(rec->cpu);
+					free(rec);
+					free(key);
+					goto cleanup;
+				}
+			} else {
+				map_collect_percpu(arr, ex_rec);
+			}
+		}
+
+		if (exit)
+			break;
+		count = 8;
+	}
+
+	free(values);
+	free(keys);
+	return 0;
+cleanup:
+	free(values);
+	free(keys);
+	return -ENOMEM;
+}
+
+static size_t u64_hash_fn(const void *key, void *ctx)
+{
+	const __u64 *k = key;
+
+	return (size_t)*k;
+}
+
+static bool u64_equal_fn(const void *key1, const void *key2, void *ctx)
+{
+	const __u64 *k1 = key1;
+	const __u64 *k2 = key2;
+
+	return *k1 == *k2;
+}
+
+static struct stats_record *alloc_stats_record(void)
+{
+	struct stats_record *rec;
+	int i;
+
+	rec = calloc(1, sizeof(*rec) + sample.n_cpus * sizeof(struct record));
+	if (!rec) {
+		fprintf(stderr, "Failed to allocate memory\n");
+		return NULL;
+	}
+
+	rec->rx_cnt.cpu = alloc_record_per_cpu();
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		rec->redir_err[i].cpu = alloc_record_per_cpu();
+	rec->kthread.cpu = alloc_record_per_cpu();
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		rec->exception[i].cpu = alloc_record_per_cpu();
+	rec->devmap_xmit.cpu = alloc_record_per_cpu();
+	for (i = 0; i < sample.n_cpus; i++)
+		rec->enq[i].cpu = alloc_record_per_cpu();
+	rec->devmap_xmit_multi = hashmap__new(u64_hash_fn, u64_equal_fn, NULL);
+	if (!rec->devmap_xmit_multi) {
+		fprintf(stderr, "Failed to allocate hashmap\n");
+		return NULL;
+	}
+
+	return rec;
+}
+
+static void free_stats_record(struct stats_record *r)
+{
+	struct hashmap_entry *tmp;
+	int i, bkt;
+
+	if (r->devmap_xmit_multi) {
+		hashmap__for_each_entry(r->devmap_xmit_multi, tmp, bkt) {
+			struct record *rec = tmp->value;
+
+			free((void *)tmp->key);
+			free(rec->cpu);
+			free(rec);
+		}
+	}
+	hashmap__free(r->devmap_xmit_multi);
+	for (i = 0; i < sample.n_cpus; i++)
+		free(r->enq[i].cpu);
+	free(r->devmap_xmit.cpu);
+	for (i = 0; i < XDP_ACTION_MAX; i++)
+		free(r->exception[i].cpu);
+	free(r->kthread.cpu);
+	for (i = 0; i < XDP_REDIRECT_ERR_MAX; i++)
+		free(r->redir_err[i].cpu);
+	free(r->rx_cnt.cpu);
+	free(r);
+}
+
+static double calc_period(struct record *r, struct record *p)
+{
+	double period_ = 0;
+	__u64 period = 0;
+
+	period = r->timestamp - p->timestamp;
+	if (period > 0)
+		period_ = ((double) period / NANOSEC_PER_SEC);
+
+	return period_;
+}
+
+static double sample_round(double val)
+{
+	if (val - floor(val) < 0.5)
+		return floor(val);
+	return ceil(val);
+}
+
+static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->processed - p->processed;
+		pps = sample_round(packets / period_);
+	}
+	return pps;
+}
+
+static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->dropped - p->dropped;
+		pps = sample_round(packets / period_);
+	}
+	return pps;
+}
+
+static __u64 calc_errs_pps(struct datarec *r,
+			    struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->issue - p->issue;
+		pps = sample_round(packets / period_);
+	}
+	return pps;
+}
+
+static __u64 calc_info_pps(struct datarec *r,
+			   struct datarec *p, double period_)
+{
+	__u64 packets = 0;
+	__u64 pps = 0;
+
+	if (period_ > 0) {
+		packets = r->info - p->info;
+		pps = sample_round(packets / period_);
+	}
+	return pps;
+}
+
+static void calc_xdp_pps(struct datarec *r, struct datarec *p,
+			 double *xdp_pass, double *xdp_drop,
+			 double *xdp_redirect, double period_)
+{
+	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
+	if (period_ > 0) {
+		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
+		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
+		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
+	}
+}
+
+static void stats_get_rx_cnt(struct stats_record *stats_rec,
+			     struct stats_record *stats_prev,
+			     unsigned int nr_cpus, struct sample_output *out)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i;
+
+	rec = &stats_rec->rx_cnt;
+	prev = &stats_prev->rx_cnt;
+	t = calc_period(rec, prev);
+
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		drop = calc_drop_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		print_default("    %-18s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PPS(pps), DROP(drop), ERR(err));
+	}
+
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		out->rx_cnt.pps = pps;
+		out->rx_cnt.drop = drop;
+		out->rx_cnt.err = err;
+		out->totals.rx += pps;
+		out->totals.drop += drop;
+		out->totals.err += err;
+	}
+}
+
+static void stats_get_cpumap_enqueue(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i, to_cpu;
+
+	/* cpumap enqueue stats */
+	for (to_cpu = 0; to_cpu < sample.n_cpus; to_cpu++) {
+		rec  =  &stats_rec->enq[to_cpu];
+		prev = &stats_prev->enq[to_cpu];
+		t = calc_period(rec, prev);
+
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		if (pps > 0) {
+			char str[64];
+
+			snprintf(str, sizeof(str), "enqueue to cpu %d", to_cpu);
+
+			if (err > 0)
+				err = pps / err; /* calc average bulk size */
+
+			print_link_err(drop, str, 20, TP_CPUMAP_ENQUEUE_CNT);
+			print_err(drop,
+				  " " FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f") "\n",
+				  PPS(pps), DROP(drop), err, "bulk_avg");
+		}
+
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+			char str[64];
+
+			pps  = calc_pps(r, p, t);
+			if (!pps)
+				continue;
+
+			snprintf(str, sizeof(str), "cpu:%d->%d", i, to_cpu);
+			drop = calc_drop_pps(r, p, t);
+			err  = calc_errs_pps(r, p, t);
+			if (err > 0)
+				err = pps / err; /* calc average bulk size */
+			print_default("    %-18s " FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f")
+				      "\n", str, PPS(pps), DROP(drop), err, "bulk_avg");
+		}
+	}
+}
+
+static void stats_get_cpumap_kthread(struct stats_record *stats_rec,
+				     struct stats_record *stats_prev,
+				     unsigned int nr_cpus)
+{
+	struct record *rec, *prev;
+	double t, pps, drop, err;
+	int i;
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+
+	pps = calc_pps(&rec->total, &prev->total, t);
+	drop = calc_drop_pps(&rec->total, &prev->total, t);
+	err = calc_errs_pps(&rec->total, &prev->total, t);
+
+	print_link_err(drop, pps ? "kthread total" : "kthread", 20, TP_CPUMAP_KTHREAD_CNT);
+	print_err(drop, " " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			  PPS(pps), DROP(drop), err, "sched");
+
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		drop = calc_drop_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		print_default("    %-18s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PPS(pps), DROP(drop), err, "sched");
+	}
+}
+
+static void stats_get_redirect_cnt(struct stats_record *stats_rec,
+				   struct stats_record *stats_prev,
+				   unsigned int nr_cpus, struct sample_output *out)
+{
+	struct record *rec, *prev;
+	double t, pps;
+	int i;
+
+	rec = &stats_rec->redir_err[0];
+	prev = &stats_prev->redir_err[0];
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("    %-18s " FMT_COLUMNf "\n", str, REDIR(pps));
+	}
+
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		out->redir_cnt.suc = pps;
+		out->totals.redir += pps;
+	}
+
+}
+
+static void stats_get_redirect_err_cnt(struct stats_record *stats_rec,
+				       struct stats_record *stats_prev,
+				       unsigned int nr_cpus, struct sample_output *out)
+{
+	struct record *rec, *prev;
+	double t, drop, sum = 0;
+	int rec_i, i;
+
+	for (rec_i = 1; rec_i < XDP_REDIRECT_ERR_MAX; rec_i++) {
+		char str[64];
+
+		rec = &stats_rec->redir_err[rec_i];
+		prev = &stats_prev->redir_err[rec_i];
+		t = calc_period(rec, prev);
+
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		if (drop > 0 && !out) {
+			snprintf(str, sizeof(str),
+				 sample.log_level & LL_DEFAULT ? "%s total" :
+				 "%s", xdp_redirect_err_names[rec_i]);
+			print_err(drop, "    %-18s " FMT_COLUMNf "\n", str, ERR(drop));
+		}
+
+		for (i = 0; i < nr_cpus; i++) {
+			struct datarec *r = &rec->cpu[i];
+			struct datarec *p = &prev->cpu[i];
+			double drop;
+
+			drop = calc_drop_pps(r, p, t);
+			if (!drop)
+				continue;
+
+			snprintf(str, sizeof(str), "cpu:%d", i);
+			print_default("       %-16s" FMT_COLUMNf "\n", str, ERR(drop));
+		}
+
+		sum += drop;
+	}
+
+	if (out) {
+		out->redir_cnt.err = sum;
+		out->totals.err += sum;
+	}
+}
+
+static void stats_get_exception_cnt(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus, struct sample_output *out)
+{
+	double t, drop, sum = 0;
+	struct record *rec, *prev;
+	int rec_i, i;
+
+
+	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
+		rec  = &stats_rec->exception[rec_i];
+		prev = &stats_prev->exception[rec_i];
+		t = calc_period(rec, prev);
+
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		/* Fold out errors after heading */
+		sum += drop;
+
+		if (drop > 0 && !out) {
+			print_always("    %-18s " FMT_COLUMNf "\n", action2str(rec_i), ERR(drop));
+
+			for (i = 0; i < nr_cpus; i++) {
+				struct datarec *r = &rec->cpu[i];
+				struct datarec *p = &prev->cpu[i];
+				char str[64];
+				double drop;
+
+				drop = calc_drop_pps(r, p, t);
+				if (!drop)
+					continue;
+
+				snprintf(str, sizeof(str), "cpu:%d", i);
+				print_default("       %-16s" FMT_COLUMNf "\n", str, ERR(drop));
+			}
+		}
+	}
+
+	if (out) {
+		out->except_cnt.hits = sum;
+		out->totals.err += sum;
+	}
+}
+
+static void stats_get_cpumap_remote(struct stats_record *stats_rec,
+				    struct stats_record *stats_prev,
+				    unsigned int nr_cpus)
+{
+	double xdp_pass, xdp_drop, xdp_redirect;
+	struct record *rec, *prev;
+	double t;
+	int i;
+
+	rec = &stats_rec->kthread;
+	prev = &stats_prev->kthread;
+	t = calc_period(rec, prev);
+
+	calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
+		     &xdp_redirect, t);
+	if (xdp_pass || xdp_drop || xdp_redirect) {
+		print_default("    %-18s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      "xdp_stats", PASS(xdp_pass), DROP(xdp_drop), REDIR(xdp_redirect));
+	}
+
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		calc_xdp_pps(r, p, &xdp_pass, &xdp_drop, &xdp_redirect, t);
+		if (!xdp_pass && !xdp_drop && !xdp_redirect)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		print_default("      %-16s " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf "\n",
+			      str, PASS(xdp_pass), DROP(xdp_drop), REDIR(xdp_redirect));
+	}
+}
+
+static void stats_get_devmap_xmit(struct stats_record *stats_rec,
+				  struct stats_record *stats_prev,
+				  unsigned int nr_cpus, struct sample_output *out)
+{
+	double pps, drop, info, err;
+	struct record *rec, *prev;
+	double t;
+	int i;
+
+	rec = &stats_rec->devmap_xmit;
+	prev = &stats_prev->devmap_xmit;
+	t = calc_period(rec, prev);
+	for (i = 0; i < nr_cpus; i++) {
+		struct datarec *r = &rec->cpu[i];
+		struct datarec *p = &prev->cpu[i];
+		char str[64];
+
+		pps = calc_pps(r, p, t);
+		drop = calc_drop_pps(r, p, t);
+
+		if (!pps)
+			continue;
+
+		snprintf(str, sizeof(str), "cpu:%d", i);
+		info = calc_info_pps(r, p, t);
+		err = calc_errs_pps(r, p, t);
+		if (info > 0)
+			info = (pps + drop) / info; /* calc avg bulk */
+		print_default("     %-18s" FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf
+			      __COLUMN(".2f") "\n", str, XMIT(pps), DROP(drop),
+			      err, "drv_err/s", info, "bulk_avg");
+	}
+	if (out) {
+		pps = calc_pps(&rec->total, &prev->total, t);
+		drop = calc_drop_pps(&rec->total, &prev->total, t);
+		info = calc_info_pps(&rec->total, &prev->total, t);
+		if (info > 0)
+			info = (pps + drop) / info; /* calc avg bulk */
+		err = calc_errs_pps(&rec->total, &prev->total, t);
+
+		out->xmit_cnt.pps = pps;
+		out->xmit_cnt.drop = drop;
+		out->xmit_cnt.bavg = info;
+		out->xmit_cnt.err = err;
+		out->totals.xmit += pps;
+		out->totals.drop_xmit += drop;
+		out->totals.err += err;
+	}
+}
+
+static void stats_get_devmap_xmit_multi(struct stats_record *stats_rec,
+					struct stats_record *stats_prev,
+					unsigned int nr_cpus,
+					struct sample_output *out)
+{
+	double pps, drop, info, err;
+	struct hashmap_entry *entry;
+	struct hashmap *cur, *prev;
+	struct record *r, *p;
+	double t;
+	int bkt;
+
+	cur = stats_rec->devmap_xmit_multi;
+	prev = stats_prev->devmap_xmit_multi;
+
+	hashmap__for_each_entry(cur, entry, bkt) {
+		const char *estr, *fstr, *tstr;
+		char ifname_from[IFNAMSIZ];
+		char ifname_to[IFNAMSIZ];
+		__u32 from_idx, to_idx;
+		char str[128];
+		__u64 pair;
+		void *val;
+
+		pair = *(__u64 *)entry->key;
+
+		from_idx = pair >> 32;
+		to_idx = pair & 0xFFFFFFFF;
+
+		r = entry->value;
+		if (!hashmap__find(prev, &pair, &val))
+			continue;
+		p = val;
+
+		t = calc_period(r, p);
+
+		pps = calc_pps(&r->total, &p->total, t);
+		drop = calc_drop_pps(&r->total, &p->total, t);
+		info = calc_info_pps(&r->total, &p->total, t);
+		if (info > 0)
+			info = (pps + drop) / info; /* calc avg bulk */
+		err = calc_errs_pps(&r->total, &p->total, t);
+
+		estr = fstr = tstr = "[error]";
+		if (if_indextoname(from_idx, ifname_from))
+			fstr = ifname_from;
+		if (if_indextoname(to_idx, ifname_to))
+			tstr = ifname_to;
+
+		if (fstr == estr || tstr == estr)
+			snprintf(str, sizeof(str), "tx %d->%d", from_idx, to_idx);
+		else
+			snprintf(str, sizeof(str), "tx %s->%s", fstr, tstr);
+		/* Handle idle streams of redirection */
+		if (pps || drop || err) {
+			printf("  ");
+			print_link_err(drop, str, 18, TP_DEVMAP_XMIT_CNT);
+			print_err(drop, " " FMT_COLUMNf FMT_COLUMNf FMT_COLUMNf __COLUMN(".2f") "\n",
+				  XMIT(pps), DROP(drop), err, "drv_err/s", info, "bulk_avg");
+		}
+	}
+}
+
+static void stats_print(const char *prefix, int mask, struct stats_record *r,
+			struct stats_record *p, struct sample_output *out)
+{
+	int nr_cpus = bpf_num_possible_cpus();
+	const char *str;
+
+	print_always("%-23s", prefix ?: "Summary");
+	if (mask & SAMPLE_RX_CNT)
+		print_always(FMT_COLUMNl, RX(out->totals.rx));
+	if (mask & SAMPLE_REDIRECT_CNT)
+		print_always(FMT_COLUMNl, REDIR(out->totals.redir));
+	printf(FMT_COLUMNl, out->totals.err + out->totals.drop +
+               out->totals.drop_xmit, "err,drop/s");
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
+		printf(FMT_COLUMNl, XMIT(out->totals.xmit));
+	printf("\n");
+
+	if (mask & SAMPLE_RX_CNT) {
+		str = (sample.log_level & LL_DEFAULT) && out->rx_cnt.pps ?
+			"receive total" : "receive";
+		print_err(
+			(out->rx_cnt.err || out->rx_cnt.drop),
+			"  %-20s " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl "\n",
+			str, PPS(out->rx_cnt.pps), DROP(out->rx_cnt.drop),
+			ERR(out->rx_cnt.err));
+
+		stats_get_rx_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		stats_get_cpumap_enqueue(r, p, nr_cpus);
+
+	if (mask & SAMPLE_CPUMAP_KTHREAD_CNT) {
+		stats_get_cpumap_kthread(r, p, nr_cpus);
+		stats_get_cpumap_remote(r, p, nr_cpus);
+	}
+
+	if (mask & SAMPLE_REDIRECT_CNT) {
+		str = out->redir_cnt.suc ? "redirect total" : "redirect";
+		print_link_err(0, str, 20, mask & _SAMPLE_REDIRECT_MAP ?
+				TP_REDIRECT_MAP_CNT : TP_REDIRECT_CNT);
+		print_default(" " FMT_COLUMNl "\n", REDIR(out->redir_cnt.suc));
+
+		stats_get_redirect_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT) {
+		str = (sample.log_level & LL_DEFAULT) && out->redir_cnt.err ?
+			"redirect_err total" : "redirect_err";
+		print_link_err(out->redir_cnt.err, str, 20, mask & _SAMPLE_REDIRECT_MAP ?
+			       TP_REDIRECT_MAP_ERR_CNT : TP_REDIRECT_ERR_CNT);
+		print_err(out->redir_cnt.err, " " FMT_COLUMNl "\n", ERR(out->redir_cnt.err));
+
+		stats_get_redirect_err_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		str = out->except_cnt.hits ? "xdp_exception total" : "xdp_exception";
+
+		print_link_err(out->except_cnt.hits, str, 20, TP_EXCEPTION_CNT);
+		print_err(out->except_cnt.hits, " " FMT_COLUMNl "\n", HITS(out->except_cnt.hits));
+
+		stats_get_exception_cnt(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
+		str = (sample.log_level & LL_DEFAULT) && out->xmit_cnt.pps ?
+			"devmap_xmit total" : "devmap_xmit";
+
+		print_link_err(out->xmit_cnt.err || out->xmit_cnt.drop, str, 20,
+			       TP_DEVMAP_XMIT_CNT);
+		print_err(out->xmit_cnt.err || out->xmit_cnt.drop,
+			  " " FMT_COLUMNl FMT_COLUMNl FMT_COLUMNl __COLUMN(".2f") "\n",
+			  XMIT(out->xmit_cnt.pps), DROP(out->xmit_cnt.drop),
+			  out->xmit_cnt.err, "drv_err/s", out->xmit_cnt.bavg,
+			  "bulk_avg");
+
+		stats_get_devmap_xmit(r, p, nr_cpus, NULL);
+	}
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT_MULTI)
+		stats_get_devmap_xmit_multi(r, p, nr_cpus, NULL);
+
+	if (sample.log_level & LL_DEFAULT || ((sample.log_level & LL_SIMPLE) && sample.err_exp)) {
+		sample.err_exp = false;
+		printf("\n");
+	}
+}
+
+int __sample_init(struct sample_data *data, int map_fd, int mask)
+{
+	sigset_t st;
+
+	sample.n_cpus = get_nprocs_conf();
+
+	sigemptyset(&st);
+	sigaddset(&st, SIGQUIT);
+	sigaddset(&st, SIGINT);
+	sigaddset(&st, SIGTERM);
+
+	if (sigprocmask(SIG_BLOCK, &st, NULL) < 0)
+		return -errno;
+
+	sample.sig_fd = signalfd(-1, &st, SFD_CLOEXEC|SFD_NONBLOCK);
+	if (sample.sig_fd < 0)
+		return -errno;
+
+	sample.map_fd[MAP_DEVMAP_XMIT_MULTI] = map_fd;
+	sample.data = data;
+	sample.mask = mask;
+
+	return 0;
+}
+
+static int __sample_remove_xdp(int ifindex, __u32 prog_id, int xdp_flags)
+{
+	__u32 cur_prog_id = 0;
+	int ret;
+
+	if (prog_id) {
+		ret = bpf_get_link_xdp_id(ifindex, &cur_prog_id, xdp_flags);
+		if (ret < 0)
+			return -errno;
+
+		if (prog_id != cur_prog_id) {
+			print_always("Program on ifindex %d does not match installed "
+				     "program, skipping unload\n", ifindex);
+			return -ENOENT;
+		}
+	}
+
+	return bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+}
+
+int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic, bool force)
+{
+	int ret, xdp_flags = 0;
+	__u32 prog_id = 0;
+
+	if (sample.xdp_cnt == 32) {
+		fprintf(stderr,
+			"Total limit for installed XDP programs in a sample reached\n");
+		return -ENOTSUP;
+	}
+
+	xdp_flags |= !force ? XDP_FLAGS_UPDATE_IF_NOEXIST : 0;
+	xdp_flags |= generic ? XDP_FLAGS_SKB_MODE : XDP_FLAGS_DRV_MODE;
+	ret = bpf_set_link_xdp_fd(ifindex, bpf_program__fd(xdp_prog), xdp_flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr, "Failed to install program \"%s\" on ifindex %d, mode = %s, "
+			"force = %s: %s\n",  bpf_program__name(xdp_prog), ifindex,
+			generic ? "skb" : "native", force ? "true" : "false", strerror(errno));
+		return ret;
+	}
+
+	ret = bpf_get_link_xdp_id(ifindex, &prog_id, xdp_flags);
+	if (ret < 0) {
+		ret = -errno;
+		fprintf(stderr,
+			"Failed to get XDP program id for ifindex %d, removing program: %s\n",
+			ifindex, strerror(errno));
+		__sample_remove_xdp(ifindex, 0, xdp_flags);
+		return ret;
+	}
+	sample.xdp_progs[sample.xdp_cnt++] = (struct xdp_desc){ ifindex, prog_id, xdp_flags };
+
+	return 0;
+}
+
+static void sample_summary_print(void)
+{
+	double period = sample.out.rx_cnt.pps;
+
+	print_always("\nTotals\n");
+	if (sample.out.totals.rx) {
+		double pkts = sample.out.totals.rx;
+
+		print_always("  Packets received    : %'-10llu\n", sample.out.totals.rx);
+		print_always("  Average packets/s   : %'-10.0f\n", sample_round(pkts/period));
+	}
+	if (sample.out.totals.redir) {
+		double pkts = sample.out.totals.redir;
+
+		print_always("  Packets redirected  : %'-10llu\n", sample.out.totals.redir);
+		print_always("  Average redir/s     : %'-10.0f\n", sample_round(pkts/period));
+	}
+	print_always("  Rx dropped          : %'-10llu\n", sample.out.totals.drop);
+	print_always("  Tx dropped          : %'-10llu\n", sample.out.totals.drop_xmit);
+	print_always("  Errors recorded     : %'-10llu\n", sample.out.totals.err);
+	if (sample.out.totals.xmit) {
+		double pkts = sample.out.totals.xmit;
+
+		print_always("  Packets transmitted : %'-10llu\n", sample.out.totals.xmit);
+		print_always("  Average transmit/s  : %'-10.0f\n", sample_round(pkts/period));
+	}
+}
+
+void sample_exit(int status)
+{
+	while (sample.xdp_cnt--) {
+		int i = sample.xdp_cnt, ifindex, xdp_flags;
+		__u32 prog_id;
+
+		prog_id = sample.xdp_progs[i].prog_id;
+		ifindex = sample.xdp_progs[i].ifindex;
+		xdp_flags = sample.xdp_progs[i].flags;
+
+		__sample_remove_xdp(ifindex, prog_id, xdp_flags);
+	}
+	sample_summary_print();
+	close(sample.sig_fd);
+	exit(status);
+}
+
+static int sample_stats_collect(struct stats_record *rec)
+{
+	int i;
+
+	if (sample.mask & SAMPLE_RX_CNT)
+		map_collect_percpu(sample.data->rx_cnt, &rec->rx_cnt);
+
+	if (sample.mask & SAMPLE_REDIRECT_CNT)
+		map_collect_percpu(sample.data->redirect_err_cnt, &rec->redir_err[0]);
+
+	if (sample.mask & SAMPLE_REDIRECT_ERR_CNT) {
+		for (i = 1; i < XDP_REDIRECT_ERR_MAX; i++)
+			map_collect_percpu(&sample.data->redirect_err_cnt[i * MAX_CPUS],
+					   &rec->redir_err[i]);
+	}
+
+	if (sample.mask & SAMPLE_CPUMAP_ENQUEUE_CNT)
+		for (i = 0; i < sample.n_cpus; i++)
+			map_collect_percpu(&sample.data->cpumap_enqueue_cnt[i * MAX_CPUS],
+					   &rec->enq[i]);
+
+	if (sample.mask & SAMPLE_CPUMAP_KTHREAD_CNT)
+		map_collect_percpu(sample.data->cpumap_kthread_cnt, &rec->kthread);
+
+	if (sample.mask & SAMPLE_EXCEPTION_CNT)
+		for (i = 0; i < XDP_ACTION_MAX; i++)
+			map_collect_percpu(&sample.data->exception_cnt[i * MAX_CPUS],
+					   &rec->exception[i]);
+
+	if (sample.mask & SAMPLE_DEVMAP_XMIT_CNT)
+		map_collect_percpu(sample.data->devmap_xmit_cnt, &rec->devmap_xmit);
+
+	if (sample.mask & SAMPLE_DEVMAP_XMIT_CNT_MULTI) {
+		if (map_collect_percpu_devmap(sample.map_fd[MAP_DEVMAP_XMIT_MULTI],
+					      rec->devmap_xmit_multi) < 0)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+static void sample_summary_update(struct sample_output *out, int interval)
+{
+	sample.out.totals.rx += out->totals.rx;
+	sample.out.totals.redir += out->totals.redir;
+	sample.out.totals.drop += out->totals.drop;
+	sample.out.totals.drop_xmit += out->totals.drop_xmit;
+	sample.out.totals.err += out->totals.err;
+	sample.out.totals.xmit += out->totals.xmit;
+	sample.out.rx_cnt.pps += interval;
+}
+
+
+static void sample_stats_print(int mask, struct stats_record *cur,
+			       struct stats_record *prev, char *prog_name,
+			       int interval)
+{
+	struct sample_output out = {};
+
+	if (mask & SAMPLE_RX_CNT)
+		stats_get_rx_cnt(cur, prev, 0, &out);
+
+	if (mask & SAMPLE_REDIRECT_CNT)
+		stats_get_redirect_cnt(cur, prev, 0, &out);
+
+	if (mask & SAMPLE_REDIRECT_ERR_CNT)
+		stats_get_redirect_err_cnt(cur, prev, 0, &out);
+
+	if (mask & SAMPLE_EXCEPTION_CNT)
+		stats_get_exception_cnt(cur, prev, 0, &out);
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT)
+		stats_get_devmap_xmit(cur, prev, 0, &out);
+
+	sample_summary_update(&out, interval);
+
+	stats_print(prog_name, mask, cur, prev, &out);
+}
+
+void sample_switch_mode(void)
+{
+	sample.log_level ^= LL_DEBUG - 1;
+}
+
+static int sample_signal_cb(void)
+{
+	struct signalfd_siginfo si;
+	int r;
+
+	r = read(sample.sig_fd, &si, sizeof(si));
+	if (r < 0)
+		return -errno;
+
+	switch (si.ssi_signo) {
+	case SIGQUIT:
+		sample_switch_mode();
+		printf("\n");
+		break;
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int sample_timer_cb(int timerfd, struct stats_record **rec,
+			   struct stats_record **prev, int interval)
+{
+	char line[64] = "Summary";
+	int ret;
+	__u64 t;
+
+	ret = read(timerfd, &t, sizeof(t));
+	if (ret < 0)
+		return -errno;
+
+	swap(prev, rec);
+	ret = sample_stats_collect(*rec);
+	if (ret < 0)
+		return ret;
+
+	if (sample.xdp_cnt == 2) {
+		char fi[IFNAMSIZ];
+		char to[IFNAMSIZ];
+		const char *f, *t;
+
+		f = t = "[error]";
+		if (if_indextoname(sample.xdp_progs[0].ifindex, fi))
+			f = fi;
+		if (if_indextoname(sample.xdp_progs[1].ifindex, to))
+			t = to;
+
+		snprintf(line, sizeof(line), "%s->%s", f, t);
+	}
+
+	sample_stats_print(sample.mask, *rec, *prev, line, interval);
+	return 0;
+}
+
+int sample_run(int interval, void (*post_cb)(void *), void *ctx)
+{
+	struct timespec ts = { interval, 0 };
+	struct itimerspec its = { ts, ts };
+	struct stats_record *rec, *prev;
+	struct pollfd pfd[2] = {};
+	int timerfd, ret;
+
+	/* Pretty print numbers */
+	setlocale(LC_NUMERIC, "en_US");
+
+	timerfd = timerfd_create(CLOCK_MONOTONIC, TFD_CLOEXEC|TFD_NONBLOCK);
+	if (timerfd < 0)
+		return -errno;
+	timerfd_settime(timerfd, 0, &its, NULL);
+
+	pfd[0].fd = sample.sig_fd;
+	pfd[0].events = POLLIN;
+
+	pfd[1].fd = timerfd;
+	pfd[1].events = POLLIN;
+
+	ret = -ENOMEM;
+	rec = alloc_stats_record();
+	if (!rec)
+		goto end;
+	prev = alloc_stats_record();
+	if (!prev)
+		goto end_rec;
+
+	ret = sample_stats_collect(rec);
+	if (ret < 0)
+		goto end_rec_prev;
+
+	for (;;) {
+		ret = poll(pfd, 2, -1);
+		if (ret < 0) {
+			if (errno == EINTR)
+				continue;
+			else
+				break;
+		}
+
+		if (pfd[0].revents & POLLIN)
+			ret = sample_signal_cb();
+		else if (pfd[1].revents & POLLIN)
+			ret = sample_timer_cb(timerfd, &rec, &prev, interval);
+
+		if (ret)
+			break;
+
+		if (post_cb)
+			post_cb(ctx);
+	}
+
+end_rec_prev:
+	free_stats_record(prev);
+end_rec:
+	free_stats_record(rec);
+end:
+	close(timerfd);
+
+	return ret;
+}
+
+const char *get_driver_name(int ifindex)
+{
+	struct ethtool_drvinfo drv = {};
+	char ifname[IF_NAMESIZE];
+	static char drvname[32];
+	struct ifreq ifr = {};
+	int fd, r = 0;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return "[error]";
+
+	if (!if_indextoname(ifindex, ifname))
+		goto end;
+
+	drv.cmd = ETHTOOL_GDRVINFO;
+	safe_strncpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
+	ifr.ifr_data = (void *)&drv;
+
+	r = ioctl(fd, SIOCETHTOOL, &ifr);
+	if (r)
+		goto end;
+
+	safe_strncpy(drvname, drv.driver, sizeof(drvname));
+
+	close(fd);
+	return drvname;
+
+end:
+	r = errno;
+	close(fd);
+	return r == EOPNOTSUPP ? "loopback" : "[error]";
+}
+
+int get_mac_addr(int ifindex, void *mac_addr)
+{
+	char ifname[IF_NAMESIZE];
+	struct ifreq ifr = {};
+	int fd, r;
+
+	fd = socket(AF_INET, SOCK_DGRAM, 0);
+	if (fd < 0)
+		return -errno;
+
+	if (!if_indextoname(ifindex, ifname)) {
+		r = -errno;
+		goto end;
+	}
+
+	safe_strncpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
+
+	r = ioctl(fd, SIOCGIFHWADDR, &ifr);
+	if (r) {
+		r = -errno;
+		goto end;
+	}
+
+	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
+
+end:
+	close(fd);
+	return r;
+}
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
new file mode 100644
index 000000000000..f22e86e89b38
--- /dev/null
+++ b/samples/bpf/xdp_sample_user.h
@@ -0,0 +1,202 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#pragma once
+
+#include <bpf/libbpf.h>
+#include <hashmap.h>
+
+#include "xdp_sample_shared.h"
+
+enum tp_type {
+	TP_REDIRECT_CNT,
+	TP_REDIRECT_MAP_CNT,
+	TP_REDIRECT_ERR_CNT,
+	TP_REDIRECT_MAP_ERR_CNT,
+	TP_CPUMAP_ENQUEUE_CNT,
+	TP_CPUMAP_KTHREAD_CNT,
+	TP_EXCEPTION_CNT,
+	TP_DEVMAP_XMIT_CNT,
+	NUM_TP,
+};
+
+enum map_type {
+	MAP_DEVMAP_XMIT_MULTI,
+	NUM_MAP,
+};
+
+enum stats_mask {
+	_SAMPLE_REDIRECT_MAP        = 1U << 0,
+	SAMPLE_RX_CNT               = 1U << 1,
+	SAMPLE_REDIRECT_ERR_CNT     = 1U << 2,
+	SAMPLE_CPUMAP_ENQUEUE_CNT   = 1U << 3,
+	SAMPLE_CPUMAP_KTHREAD_CNT   = 1U << 4,
+	SAMPLE_EXCEPTION_CNT        = 1U << 5,
+	SAMPLE_DEVMAP_XMIT_CNT      = 1U << 6,
+	SAMPLE_REDIRECT_CNT         = 1U << 7,
+	SAMPLE_REDIRECT_MAP_CNT     = SAMPLE_REDIRECT_CNT | _SAMPLE_REDIRECT_MAP,
+	SAMPLE_REDIRECT_ERR_MAP_CNT = SAMPLE_REDIRECT_ERR_CNT | _SAMPLE_REDIRECT_MAP,
+	SAMPLE_DEVMAP_XMIT_CNT_MULTI = 1U << 8,
+};
+
+enum log_level {
+	LL_DEFAULT = 1U << 0,
+	LL_SIMPLE  = 1U << 1,
+	LL_DEBUG   = 1U << 2,
+};
+
+/* Exit return codes */
+#define EXIT_OK			0
+#define EXIT_FAIL		1
+#define EXIT_FAIL_OPTION	2
+#define EXIT_FAIL_XDP		3
+#define EXIT_FAIL_BPF		4
+#define EXIT_FAIL_MEM		5
+
+#define XDP_REDIRECT_ERR_MAX	7
+
+__attribute__((unused))
+static const char *xdp_redirect_err_names[XDP_REDIRECT_ERR_MAX] = {
+	/* Key=1 keeps unknown errors */
+	"Success", "Unknown", "EINVAL", "ENETDOWN", "EMSGSIZE",
+	"EOPNOTSUPP", "ENOSPC",
+};
+
+#define XDP_UNKNOWN (XDP_REDIRECT + 1)
+#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
+
+__attribute__((unused))
+static const char *xdp_action_names[XDP_ACTION_MAX] = {
+	[XDP_ABORTED]	= "XDP_ABORTED",
+	[XDP_DROP]	= "XDP_DROP",
+	[XDP_PASS]	= "XDP_PASS",
+	[XDP_TX]	= "XDP_TX",
+	[XDP_REDIRECT]	= "XDP_REDIRECT",
+	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
+};
+
+__attribute__((unused))
+static inline const char *action2str(int action)
+{
+	if (action < XDP_ACTION_MAX)
+		return xdp_action_names[action];
+	return NULL;
+}
+
+struct record {
+	__u64 timestamp;
+	struct datarec total;
+	struct datarec *cpu;
+};
+
+struct stats_record {
+	struct record rx_cnt;
+	struct record redir_err[XDP_REDIRECT_ERR_MAX];
+	struct record kthread;
+	struct record exception[XDP_ACTION_MAX];
+	struct record devmap_xmit;
+	struct hashmap *devmap_xmit_multi;
+	struct record enq[];
+};
+
+struct sample_output {
+	struct {
+		__u64 rx;
+		__u64 redir;
+		__u64 drop;
+		__u64 drop_xmit;
+		__u64 err;
+		__u64 xmit;
+	} totals;
+	struct {
+		__u64 pps;
+		__u64 drop;
+		__u64 err;
+	} rx_cnt;
+	struct {
+		__u64 suc;
+		__u64 err;
+	} redir_cnt;
+	struct {
+		__u64 hits;
+	} except_cnt;
+	struct {
+		__u64 pps;
+		__u64 drop;
+		__u64 err;
+		double bavg;
+	} xmit_cnt;
+};
+
+int __sample_init(struct sample_data *data, int map_fd, int mask);
+void sample_exit(int status);
+int sample_run(int interval, void (*post_cb)(void *), void *ctx);
+
+void sample_switch_mode(void);
+int sample_install_xdp(struct bpf_program *xdp_prog, int ifindex, bool generic,
+		       bool force);
+void sample_print_help(int mask);
+
+const char *get_driver_name(int ifindex);
+int get_mac_addr(int ifindex, void *mac_addr);
+
+/* Pointer swap trick */
+__attribute__((unused))
+static inline void swap(struct stats_record **a, struct stats_record **b)
+{
+	struct stats_record *tmp;
+
+	tmp = *a;
+	*a = *b;
+	*b = tmp;
+}
+
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wstringop-truncation"
+__attribute__((unused))
+static inline char *safe_strncpy(char *dst, const char *src, size_t size)
+{
+	if (!size)
+		return dst;
+	strncpy(dst, src, size - 1);
+	dst[size - 1] = '\0';
+	return dst;
+}
+#pragma GCC diagnostic pop
+
+#define __attach_tp(name)                                                      \
+	({                                                                     \
+		if (!bpf_program__is_tracing(skel->progs.name))                \
+			return -EINVAL;                                        \
+		skel->links.name = bpf_program__attach(skel->progs.name);      \
+		if (!skel->links.name)                                         \
+			return -errno;                                         \
+	})
+
+#define DEFINE_SAMPLE_INIT(name)                                               \
+	static int sample_init(struct name *skel, int mask)                    \
+	{                                                                      \
+		int ret;                                                       \
+		ret = __sample_init(                                           \
+			&skel->bss->sample_data,                               \
+			bpf_map__fd(skel->maps.devmap_xmit_cnt_multi), mask);  \
+		if (ret < 0)                                                   \
+			return ret;                                            \
+		if (mask & SAMPLE_REDIRECT_MAP_CNT)                            \
+			__attach_tp(tp_xdp_redirect_map);                      \
+		if (mask & SAMPLE_REDIRECT_CNT)                                \
+			__attach_tp(tp_xdp_redirect);                          \
+		if (mask & SAMPLE_REDIRECT_ERR_MAP_CNT)                        \
+			__attach_tp(tp_xdp_redirect_map_err);                  \
+		if (mask & SAMPLE_REDIRECT_ERR_CNT)                            \
+			__attach_tp(tp_xdp_redirect_err);                      \
+		if (mask & SAMPLE_CPUMAP_ENQUEUE_CNT)                          \
+			__attach_tp(tp_xdp_cpumap_enqueue);                    \
+		if (mask & SAMPLE_CPUMAP_KTHREAD_CNT)                          \
+			__attach_tp(tp_xdp_cpumap_kthread);                    \
+		if (mask & SAMPLE_EXCEPTION_CNT)                               \
+			__attach_tp(tp_xdp_exception);                         \
+		if (mask & SAMPLE_DEVMAP_XMIT_CNT)                             \
+			__attach_tp(tp_xdp_devmap_xmit);                       \
+		if (mask & SAMPLE_DEVMAP_XMIT_CNT_MULTI)                       \
+			__attach_tp(tp_xdp_devmap_xmit_multi);                 \
+		return 0;                                                      \
+	}
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6431014C510
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 04:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgA2DzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 22:55:11 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39903 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgA2DzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 22:55:11 -0500
Received: by mail-ot1-f68.google.com with SMTP id 77so14269930oty.6
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 19:55:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sage.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SXQtMkx6+vH93n0hddpAmp70ffUksZCvZG/G6k+5pns=;
        b=PGR1PDTkNBzICSb4T05ERULUce3tlF2LJSuLpIWOe3wnW8DfobIHuPtnKQbj+IbpCg
         G2zogd/Joo1H4d9C1C1bx0yMMM3WTZXhC5T08N9GZzwDpu/GesbmL5g7penoP8DikrHO
         KRqon141B9OHji/GuhYDCU2qmCb84z4cP5tFLurZbi50zXJRtjfqJawulw0fafvBCB3P
         JNkMwlppTK9QNNzbFMhpU2pz2BmvHBZE34HrFrZsukOcxGTIFdeZ21ZmgpGiZWZmMYCl
         5A8QuD7Kfzb6MDJrpqNM2YpE83M/icdOx/SbWbSyFif73852m3wQtxTfZOnLmYDt4L4c
         2EKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SXQtMkx6+vH93n0hddpAmp70ffUksZCvZG/G6k+5pns=;
        b=ZeGq/Noh2DGVZNoMnqfNHZ+veE8EOJOVbht76+Xqi8mxvO8GzzXT7z016fm/69CB2s
         /PN8ltqItwtNyZZalV/mPR4I0yNxc7jYR/BcPIVY8ZTZ+9U69JGsxxlXoDizQdWQJYd4
         BIKgV0aFg77K4ysQllpz28kstg1ln3nlI2DgYSCGM8+xe/y7oVAfaMZR63kgrN4YlGLa
         tq2HS1nHE14deAbm22b6VnYQbA29aEsXt/Ve0RB2ePdDfSYFaTMzAwZjX1C/K4Ufh97X
         2GAT5JkjuLF+g8FRXyQoL8fp61qfRxpRFXXXGxC1aDXjUoQd6tjVztfx4Oj6vC8xCDZh
         W0Mw==
X-Gm-Message-State: APjAAAVBQk4cwdsoZWAKrvkU7V/hJOqbS/+gCORANkIov4FASrrY+ZUK
        y9Ml2WwffIfA5y3ojJEVE7HWsdbZkCiTSA==
X-Google-Smtp-Source: APXvYqzWLW7X9ELq3T6wpvpUMjI4DtwxJFfhzMqVNX+IftyvpI4rkPI+mTAgSpe+bD3PamPY7gvmJg==
X-Received: by 2002:a9d:6f0d:: with SMTP id n13mr19437861otq.165.1580270108753;
        Tue, 28 Jan 2020 19:55:08 -0800 (PST)
Received: from tower.attlocal.net ([2600:1700:4a30:fd70::14])
        by smtp.googlemail.com with ESMTPSA id x21sm289969oto.5.2020.01.28.19.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 19:55:08 -0800 (PST)
From:   Eric Sage <eric@sage.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andriin@fb.com, jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, Eric Sage <eric@sage.org>
Subject: [PATCH v3] samples/bpf: Add xdp_stat sample program
Date:   Tue, 28 Jan 2020 19:54:57 -0800
Message-Id: <20200129035457.90892-1-eric@sage.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <CAEf4BzbjXRFYkr2LCh50mLV+cQ9WrgRB+U4CbxekVVf=nfRUZw@mail.gmail.com>
References: <CAEf4BzbjXRFYkr2LCh50mLV+cQ9WrgRB+U4CbxekVVf=nfRUZw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At Facebook we use tail calls to jump between our firewall filters and
our L4LB. This is a program I wrote to estimate per program performance
by swapping out the entries in the program array with interceptors that
take measurements and then jump to the original entries.

I found the sample programs to be invaluable in understanding how to use
the libbpf API (as well as the test env from the xdp-tutorial repo for
testing), and want to return the favor. I am currently working on
my next iteration that uses fentry/fexit to be less invasive,
but I thought it was an interesting PoC of what you can do with program
arrays.

Signed-off-by: Eric Sage <eric@sage.org>
---
Changes in v3:
- Fixed typos in xdp_stat_kern.c
- Switch to using key_size, value_size for prog arrays.

 samples/bpf/Makefile          |   3 +
 samples/bpf/xdp_stat_common.h |  28 ++
 samples/bpf/xdp_stat_kern.c   | 192 +++++++++
 samples/bpf/xdp_stat_user.c   | 748 ++++++++++++++++++++++++++++++++++
 4 files changed, 971 insertions(+)
 create mode 100644 samples/bpf/xdp_stat_common.h
 create mode 100644 samples/bpf/xdp_stat_kern.c
 create mode 100644 samples/bpf/xdp_stat_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 5b89c0370f33..36469b3344b0 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += xdp_stat
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+xdp_stat-objs := xdp_stat_user.o
 
 # Tell kbuild to always build the programs
 always := $(tprogs-y)
@@ -170,6 +172,7 @@ always += ibumad_kern.o
 always += hbm_out_kern.o
 always += hbm_edt_kern.o
 always += xdpsock_kern.o
+always += xdp_stat_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/xdp_stat_common.h b/samples/bpf/xdp_stat_common.h
new file mode 100644
index 000000000000..7c0557410704
--- /dev/null
+++ b/samples/bpf/xdp_stat_common.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0
+ * Copyright (c) 2019 Facebook
+ */
+
+#ifndef __XDP_STAT_COMMON_HEADER_H
+#define __XDP_STAT_COMMON_HEADER_H
+
+/* WARNING: Must match the number of interceptors generated in
+ * xdp_stat_kern.c including xdp/interceptor_0.
+ */
+#define MAX_INTERCEPTORS 10
+
+/* prog_stats_rec contains stats specific to an intercepted BPF program.
+ */
+struct prog_stats_rec {
+	__u64 nr_terminal_runs;
+	__u64 nr_chained_runs;
+	__u64 ns_chained_runtime;
+};
+
+/* interception_info_rec contains global to all interceptors on a single CPU.
+ */
+struct interception_info_rec {
+	__u32 prev_interceptor_nr;
+	__u64 prev_ns_start;
+};
+
+#endif /* __XDP_STAT_COMMON_HEADER_H */
diff --git a/samples/bpf/xdp_stat_kern.c b/samples/bpf/xdp_stat_kern.c
new file mode 100644
index 000000000000..3d09c9876f58
--- /dev/null
+++ b/samples/bpf/xdp_stat_kern.c
@@ -0,0 +1,192 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2019 Facebook
+ */
+
+/* Conceptually interception looks like this for a single packet:
+ *
+ * interceptor_0 -> entrypoint -> interceptor_1 -> prog_1 -> ... ->
+ * interceptor_N -> prog_N -> XDP_ACTION
+ *
+ * At any point in the chain, including in the entrypoint, an XDP_ACTION can
+ * be returned. It is also not assumed that the order of jumps will not change
+ * (except that the entrypoint always comes first).
+ *
+ * Because there is no way to hook into the return of the XDP action, the
+ * entrypoint (interceptor_0) is also used to record the terminal run of the
+ * previous BPF program on the same CPU. Conceptually:
+ *
+ * ... -> prog_N -> XDP_ACTION -> interceptor_0 -> ...
+ *
+ * FIXME: A bad side effect of this is that the reported stats will always be
+ * behind in tracking terminal runs which is confusing to the user.
+ */
+
+#include <uapi/linux/bpf.h>
+#include "bpf_helpers.h"
+
+#include "xdp_stat_common.h"
+
+// The maximum size of the intercepted program array.
+#define MAX_PROG_ARRAY 64
+
+/* NR is used to map interceptors to the programs that are being intercepted. */
+#define INTERCEPTOR(INDEX)                                                     \
+	SEC("xdp/interceptor_" #INDEX)                                         \
+	int interceptor_##INDEX(struct xdp_md *ctx)                            \
+	{                                                                      \
+		return interceptor_impl(ctx, INDEX);                           \
+	}
+
+/* Required to use bpf_ktime_get_ns() */
+char _license[] SEC("license") = "GPL";
+
+/* interception_info holds a single record per CPU to pass global state between
+ * interceptor programs.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, struct interception_info_rec);
+} interception_info SEC(".maps");
+
+/* interceptor_stats maps interceptor indexes to measurements of an intercepted
+ * BPF program. Index 0 maps the interceptor entrypoint to measurements of the
+ * original entrypoint.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(max_entries, MAX_PROG_ARRAY);
+	__type(key, __u32);
+	__type(value, struct prog_stats_rec);
+} prog_stats SEC(".maps");
+
+/* interceptor_nr_to_prog_id maps the number identifying an interceptor to the
+ * index of the intercepted BPF progam in jmp_table_copy.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, MAX_PROG_ARRAY);
+	__type(key, __u32);
+	__type(value, __u32);
+} interceptor_nr_to_prog_idx SEC(".maps");
+
+/* jmp_table_entry has a single entry - the original XDP entrypoint - so that
+ * the interceptor entrypoint can jump to it.
+ */
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, 1);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table_entrypoint SEC(".maps");
+
+// jmp_table_copy contains a copy of the original jump table so it can be
+// restored once the interception is complete.
+struct {
+	__uint(type, BPF_MAP_TYPE_PROG_ARRAY);
+	__uint(max_entries, MAX_PROG_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(__u32));
+} jmp_table_copy SEC(".maps");
+
+/* interceptor_entrypoint replaces the BPF program attached to the XDP hook.
+ * The entrypoint records the terminal run on the previous BPF program before
+ * jumping back to the original entrypoint.
+ */
+SEC("xdp/interceptor_0")
+int interceptor_entrypoint(struct xdp_md *ctx)
+{
+	__u32 info_key = 0;
+
+	struct interception_info_rec *info =
+		bpf_map_lookup_elem(&interception_info, &info_key);
+	if (!info)
+		goto jmp_back;
+
+	if (info->prev_ns_start != 0) {
+		struct prog_stats_rec *stats = bpf_map_lookup_elem(
+			&prog_stats, &info->prev_interceptor_nr);
+		if (!stats)
+			goto jmp_back;
+		stats->nr_terminal_runs++;
+	}
+
+	info->prev_interceptor_nr = 0;
+	info->prev_ns_start = bpf_ktime_get_ns();
+
+jmp_back:
+	bpf_tail_call(ctx, &jmp_table_entrypoint, 0);
+	return XDP_ABORTED;
+}
+
+/* interceptor_impl records the chained run of the previous BPF program before
+ * jumping back to the intercepted BPF program in the copied jump table.
+ */
+static __always_inline int interceptor_impl(struct xdp_md *ctx, __u32 idx)
+{
+	__u32 info_key = 0;
+	__u64 ns_since_boot = bpf_ktime_get_ns();
+
+	__u32 *original_idx =
+		bpf_map_lookup_elem(&interceptor_nr_to_prog_idx, &idx);
+	if (!original_idx)
+		return XDP_ABORTED;
+
+	struct interception_info_rec *info =
+		bpf_map_lookup_elem(&interception_info, &info_key);
+	if (!info)
+		goto jmp_back;
+
+	struct prog_stats_rec *stats =
+		bpf_map_lookup_elem(&prog_stats, &info->prev_interceptor_nr);
+	if (!stats)
+		goto jmp_back;
+
+	__u64 ns_elapsed = ns_since_boot - info->prev_ns_start;
+
+	stats->nr_chained_runs++;
+	stats->ns_chained_runtime += ns_elapsed;
+
+	info->prev_interceptor_nr = idx;
+	info->prev_ns_start = bpf_ktime_get_ns();
+
+jmp_back:
+	bpf_tail_call(ctx, &jmp_table_copy, idx);
+	return XDP_ABORTED;
+}
+
+/* The number of interceptors MUST match MAX_INTERCEPTORS in
+ * xdp_stat_common.h
+ */
+INTERCEPTOR(1);
+INTERCEPTOR(2);
+INTERCEPTOR(3);
+INTERCEPTOR(4);
+INTERCEPTOR(5);
+INTERCEPTOR(6);
+INTERCEPTOR(7);
+INTERCEPTOR(8);
+INTERCEPTOR(9);
+INTERCEPTOR(10);
+INTERCEPTOR(11);
+INTERCEPTOR(12);
+INTERCEPTOR(13);
+INTERCEPTOR(14);
+INTERCEPTOR(15);
+INTERCEPTOR(16);
+INTERCEPTOR(17);
+INTERCEPTOR(18);
+INTERCEPTOR(19);
+INTERCEPTOR(20);
+INTERCEPTOR(21);
+INTERCEPTOR(22);
+INTERCEPTOR(23);
+INTERCEPTOR(24);
+INTERCEPTOR(25);
+INTERCEPTOR(26);
+INTERCEPTOR(27);
+INTERCEPTOR(28);
+INTERCEPTOR(29);
+INTERCEPTOR(30);
+INTERCEPTOR(31);
diff --git a/samples/bpf/xdp_stat_user.c b/samples/bpf/xdp_stat_user.c
new file mode 100644
index 000000000000..f3879ad289e8
--- /dev/null
+++ b/samples/bpf/xdp_stat_user.c
@@ -0,0 +1,748 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2019 Facebook
+ */
+
+static const char *__doc__ =
+	"\n"
+	"WARNING: This program intercepts the XDP hook and modifies the\n"
+	"monitored program array. USE WITH CAUTION.\n"
+	"\n"
+	"--device is the netdev the XDP program to be monitored is attached to.\n"
+	"--map is the BPF program array to intercept in /sys/fs/bpf.\n"
+	"\n"
+	"Measures performance of XDP programs using tail calls\n"
+	"\n"
+	"Measures the run count and run time of tail call XDP BPF programs.\n"
+	"Measurements are divided into chained and terminal program runs.\n"
+	"Chained runs occur when a BPF program chains with a tail call.\n"
+	"Terminal runs occur when a BPF program returns an XDP action.\n"
+	"\n"
+	"Terminal run measurements are less accurate and are only accounted\n"
+	"when the next packet is received.\n"
+	"\n"
+	"The maximum number of BPF programs that can be intercepted is 32\n";
+
+#include <unistd.h>
+#include <errno.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <sys/resource.h>
+
+#include <signal.h>
+#include <sys/resource.h>
+#include <getopt.h>
+#include <net/if.h>
+#include <linux/if_link.h>
+
+#include <time.h>
+#include <math.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stdio.h>
+
+#include "xdp_stat_common.h"
+
+#define MAX_PROGNAME 4096
+
+/* Name of the file containing BPF code.
+ */
+#define FILENAME_XDP_STAT_KERN "xdp_stat_kern.o"
+
+/* Names of maps shared by kernel and userspace.
+ */
+#define MAPNAME_PROG_STATS "prog_stats"
+#define MAPNAME_NR_TO_PROG_IDX "interceptor_nr_to_prog_idx"
+#define MAPNAME_JMP_TABLE_ENTRYPOINT "jmp_table_entrypoint"
+#define MAPNAME_JMP_TABLE_COPY "jmp_table_copy"
+
+static bool verbose;
+
+volatile sig_atomic_t keep_going = 1;
+
+static void handle_signal(int sig)
+{
+	keep_going = 0;
+	signal(SIGINT, handle_signal);
+}
+
+struct intercept_ctx {
+	int ifindex;
+	int prog_cnt;
+	struct bpf_object *bpf_obj;
+	int entry_fd;
+	int entry_copy_fd;
+	int jmp_table_fd;
+	int jmp_copy_fd;
+	int jmp_entry_fd;
+	int prog_stats_fd;
+	int nr_to_prog_idx_fd;
+	int stats_enabled_oldval;
+};
+
+struct intercept_prog {
+	char *name;
+	__u64 id;
+	struct prog_stats_rec stats;
+};
+
+struct intercept_stats {
+	__u64 timestamp;
+	__u64 run_cnt_total;
+	__u64 run_time_ns_total;
+	__u64 run_time_ns_accounted;
+	struct intercept_prog progs[MAX_INTERCEPTORS];
+};
+
+struct config {
+	char *ifname;
+	int ifindex;
+	char *mappath;
+	int count;
+	int interval;
+};
+
+static struct option long_options[] = {
+	{ "verbose", no_argument, NULL, 'v' },
+	{ "device", required_argument, NULL, 'd' },
+	{ "map", required_argument, NULL, 'm' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ 0, 0, 0, 0 },
+};
+
+static void usage(char *argv[])
+{
+	int i;
+
+	printf("\nDOCUMENTATION:\n%s\n", __doc__);
+	printf("\n");
+	printf(" Usage: %s (options-see-below)\n", argv[0]);
+	printf(" Listing options:\n");
+	for (i = 0; long_options[i].name != 0; i++) {
+		printf(" --%-15s", long_options[i].name);
+		if (long_options[i].flag != NULL)
+			printf(" flag (internal value: %d)",
+			       *long_options[i].flag);
+		else
+			printf("short-option: -%c", long_options[i].val);
+		printf("\n");
+	}
+	printf("\n");
+}
+
+static void parse_args(int argc, char **argv, struct config *cfg)
+{
+	int opt;
+
+	while ((opt = getopt_long(argc, argv, "pvabd:m:ic", long_options,
+				  NULL)) != -1) {
+		switch (opt) {
+		case 'v':
+			verbose = 1;
+			break;
+		case 'd':
+			if (strlen(optarg) >= IF_NAMESIZE) {
+				fprintf(stderr, "ERR: --dev name too long\n");
+				goto error;
+			}
+			cfg->ifname = strdup(optarg);
+			cfg->ifindex = if_nametoindex(cfg->ifname);
+			if (cfg->ifindex == 0) {
+				fprintf(stderr,
+					"ERR: --dev name unknown err(%d): %s\n",
+					errno, strerror(errno));
+				goto error;
+			}
+			break;
+		case 'm':
+			cfg->mappath = strdup(optarg);
+			break;
+		case 'i':
+			cfg->interval = atoi(optarg);
+			break;
+		case 'h':
+			usage(argv);
+			return;
+error:
+		default:
+			usage(argv);
+			exit(EXIT_FAILURE);
+		}
+	}
+}
+
+static int _update_sysctl(const char *filename, int newval)
+{
+	int err, ret;
+	FILE *f;
+	const char *fmt = "%d\n";
+
+	f = fopen(filename, "r+");
+	if (f == NULL) {
+		printf("fopen failed\n");
+		return -errno;
+	}
+
+	err = fscanf(f, fmt, &ret);
+	if (err != 1) {
+		printf("fscanf failed\n");
+		err = err == EOF ? -EIO : -errno;
+		fclose(f);
+		return err;
+	}
+
+	if (fseek(f, 0, SEEK_SET) < 0) {
+		printf("seek failed\n");
+		fclose(f);
+		return -errno;
+	}
+
+	if (fputc(newval, f) == EOF) {
+		printf("fputc failed\n");
+		fclose(f);
+		return -errno;
+	}
+
+	fclose(f);
+	return ret;
+}
+
+static int __open_prog_fd(struct bpf_object *obj, const char *progname)
+{
+	struct bpf_program *prog =
+		bpf_object__find_program_by_title(obj, progname);
+
+	if (!prog) {
+		printf("ERR: could not find bpf prog(%s)\n", progname);
+		return -1;
+	}
+
+	return bpf_program__fd(prog);
+}
+
+static int __open_map_fd(struct bpf_object *obj, const char *mapname)
+{
+	struct bpf_map *map = bpf_object__find_map_by_name(obj, mapname);
+
+	if (!map) {
+		printf("ERR: could not find bpf map(%s)\n", mapname);
+		return -1;
+	}
+
+	return bpf_map__fd(map);
+}
+
+/* Copies contents of src_fd progam array to dst_fd program array. Returns less
+ * than zero on failure.
+ */
+static int __copy_prog_array_map(int src_fd, int dst_fd)
+{
+	int prog_fd;
+	__u32 val, prev_key, key = 0;
+
+	while (bpf_map_get_next_key(src_fd, &prev_key, &key) == 0) {
+		prev_key = key;
+
+		/* Reading a BPF program array returns BPF program IDs. */
+		if (bpf_map_lookup_elem(src_fd, &key, &val) < 0)
+			continue;
+
+		if (verbose)
+			printf("copying map fd(%d)[%d]: %d to map fd(%d)\n",
+			       src_fd, key, val, dst_fd);
+
+		/* Open a fd for the BPF program ID */
+		prog_fd = bpf_prog_get_fd_by_id(val);
+		if (prog_fd < 0) {
+			printf("failed to get fd for prog id: %d", val);
+			return -1;
+		}
+
+		if (bpf_map_update_elem(dst_fd, &key, &prog_fd, BPF_ANY) != 0) {
+			printf("failed to copy map elem: %s\n",
+			       strerror(errno));
+			return -1;
+		}
+	}
+	if (errno != ENOENT) {
+		printf("bpf_get_next_key failed: %s\n", strerror(errno));
+		return -1;
+	}
+	return 0;
+}
+
+/* __swap_xdp_entrypoint swaps the BPF program attached to the XDP hook with
+ * new_entry_prog_fd. Before the swap the old program is placed into the
+ * jmp_entrypoint program array at index zero. Returns less than zero on
+ * failure.
+ */
+static int __swap_xdp_entrypoint(struct bpf_object *bpf_obj,
+				 int new_entrypoint_prog_fd, int ifindex)
+{
+	__u32 old_entrypoint_prog_id = 0;
+	__u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+	int jmp_table_entry_fd, old_entrypoint_prog_fd, idx = 0;
+	const char *jmp_table_entry_mapname = "jmp_table_entrypoint";
+
+	jmp_table_entry_fd = __open_map_fd(bpf_obj, jmp_table_entry_mapname);
+	if (jmp_table_entry_fd < 0) {
+		printf("ERR: open map(%s) failed\n", jmp_table_entry_mapname);
+		return EXIT_FAILURE;
+	}
+
+	if (verbose)
+		printf("looking up xdp prog attached to ifindex(%d)\n",
+		       ifindex);
+
+	if (bpf_get_link_xdp_id(ifindex, &old_entrypoint_prog_id, xdp_flags)) {
+		printf("ERR: bpf_get_link_xdp_id %s\n", strerror(errno));
+		return -1;
+	}
+
+	if (!old_entrypoint_prog_id) {
+		printf("ERR: bpf_get_link_xdp_id did not fill entry_prog_id\n");
+		return -1;
+	}
+
+	if (verbose)
+		printf("BPF prog(%u) attached to XDP\n",
+		       old_entrypoint_prog_id);
+
+	old_entrypoint_prog_fd = bpf_prog_get_fd_by_id(old_entrypoint_prog_id);
+	if (old_entrypoint_prog_fd < 0) {
+		printf("ERR: get fd for prog id(%u) failed\n",
+		       old_entrypoint_prog_id);
+		return -1;
+	}
+
+	if (bpf_map_update_elem(jmp_table_entry_fd, &idx,
+				&old_entrypoint_prog_fd, BPF_ANY) != 0) {
+		printf("ERR: failed to update entry table: %s\n",
+		       strerror(errno));
+		return -1;
+	}
+
+	xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+
+	if (bpf_set_link_xdp_fd(ifindex, new_entrypoint_prog_fd, xdp_flags)) {
+		printf("ERR: failed to attach intercept to XDP: %s\n",
+		       strerror(errno));
+		return -1;
+	}
+
+	if (verbose)
+		printf("attached intercept entrypoint to XDP\n");
+
+	return old_entrypoint_prog_fd;
+}
+
+/* load_interceptors replaces each fd entry in the provided jump table fd with
+ * an interceptor program. Each interceptor is named "intercept_N" starting from
+ * 1 (0 is the entrypoint which is loaded separately). The map nr_to_prog_idx
+ * is loaded with a mapping of N to the jump table index where N is located.
+ *
+ * The return value is the number of interceptors loaded or less than zero on
+ * error.
+ */
+static int __load_interceptors(struct bpf_object *intercept_bpf_obj,
+			       int jmp_table_fd, int nr_to_prog_idx_fd)
+{
+	char intercept_name[MAX_PROGNAME];
+	int prog_fd, intercept_nr = 1;
+	__u32 intercepted_prog_id, prev_idx, idx = -1;
+	const char *fmt = "xdp/interceptor_%d";
+
+	while (bpf_map_get_next_key(jmp_table_fd, &prev_idx, &idx) == 0) {
+		prev_idx = idx;
+		if (bpf_map_lookup_elem(jmp_table_fd, &idx,
+					&intercepted_prog_id) < 0)
+			continue;
+
+		sprintf(intercept_name, fmt, intercept_nr);
+
+		prog_fd = __open_prog_fd(intercept_bpf_obj, intercept_name);
+		if (prog_fd < 0)
+			return -1;
+
+		if (bpf_map_update_elem(jmp_table_fd, &idx, &prog_fd,
+					BPF_ANY) != 0) {
+			printf("ERR: insert %s into jump table: %s\n",
+			       intercept_name, strerror(errno));
+			return -1;
+		}
+		if (bpf_map_update_elem(nr_to_prog_idx_fd, &intercept_nr, &idx,
+					BPF_ANY) != 0) {
+			printf("ERR: insert %s into intercept table: %s\n",
+			       intercept_name, strerror(errno));
+			return -1;
+		}
+		if (verbose)
+			printf("success: %s placed at idx(%d)\n",
+			       intercept_name, idx);
+		intercept_nr++;
+	}
+	if (errno != ENOENT) {
+		printf("ERR: bpf_get_next_idx failed: %s\n", strerror(errno));
+		return -1;
+	}
+	return intercept_nr--;
+}
+
+static struct bpf_prog_info *__get_interceptor_info(struct intercept_ctx *ctx,
+						    int ic_nr,
+						    bool use_entry_table,
+						    bool use_entry_fd)
+{
+	__u32 info_len = sizeof(struct bpf_prog_info);
+	struct bpf_prog_info *info = calloc(1, info_len);
+	__u32 prog_id, jmp_idx;
+	int prog_fd, table_fd = ctx->jmp_copy_fd;
+
+	if (bpf_map_lookup_elem(ctx->nr_to_prog_idx_fd, &ic_nr, &jmp_idx) !=
+	    0) {
+		printf("ERR: bpf_map_lookup_elem failed key: %d\n", ic_nr);
+		return NULL;
+	}
+
+	if (use_entry_table)
+		table_fd = ctx->jmp_entry_fd;
+
+	if (bpf_map_lookup_elem(table_fd, &jmp_idx, &prog_id) != 0) {
+		fprintf(stderr, "ERR: bpf_map_lookup_elem failed key: %d\n",
+			jmp_idx);
+		return NULL;
+	}
+
+	prog_fd = bpf_prog_get_fd_by_id(prog_id);
+	if (prog_fd < 0) {
+		fprintf(stderr, "ERR: bpf_prog_get_fd_by_id(%d)\n", prog_id);
+		return NULL;
+	}
+
+	if (use_entry_fd)
+		prog_fd = ctx->entry_fd;
+
+	if (bpf_obj_get_info_by_fd(prog_fd, info, &info_len) < 0) {
+		fprintf(stderr, "ERR: bpf_obj_get_info_by_fd(%d)\n", prog_fd);
+		perror("Bleh");
+		return NULL;
+	}
+
+	return info;
+}
+
+/* intercept_setup is called to begin interception of the XDP program attached
+ * to ifindex. mappath must be a pinned BPF map that the XDP program jumps to.
+ *
+ * The system is modified as follows:
+ * 1. XDP stats are enabled via sys.kernel.bpf_stats_enabled.
+ * 2. The program array at mappath is backed up.
+ * 3. The programs in the program array are replaced with interceptors.
+ * 4. The XDP entrypoint is unhooked and an interceptor entrpoint is attached.
+ *
+ * Returns a ctx object which is used to retrieve statistics and teardown
+ * the interception.
+ *
+ * WARNING: Failing to call intercept__teardown will leave the system in an
+ * incosistent state. intercept__teardown MUST be called.
+ */
+static struct intercept_ctx *intercept__setup(char *mappath, int ifindex)
+{
+	struct intercept_ctx *ctx = malloc(sizeof(struct intercept_ctx));
+
+	ctx->ifindex = ifindex;
+
+	ctx->stats_enabled_oldval =
+		_update_sysctl("/proc/sys/kernel/bpf_stats_enabled", 1);
+	if (ctx->stats_enabled_oldval < 0)
+		perror("ERR: set bpf_stats_enabled sysctl failed\n");
+
+	if (bpf_prog_load(FILENAME_XDP_STAT_KERN, BPF_PROG_TYPE_XDP,
+			  &ctx->bpf_obj, &ctx->entry_fd)) {
+		fprintf(stderr, "ERR: failed to load %s\n",
+			FILENAME_XDP_STAT_KERN);
+		return NULL;
+	}
+
+	ctx->prog_stats_fd = __open_map_fd(ctx->bpf_obj, MAPNAME_PROG_STATS);
+	ctx->nr_to_prog_idx_fd =
+		__open_map_fd(ctx->bpf_obj, MAPNAME_NR_TO_PROG_IDX);
+	ctx->jmp_entry_fd =
+		__open_map_fd(ctx->bpf_obj, MAPNAME_JMP_TABLE_ENTRYPOINT);
+	ctx->jmp_copy_fd = __open_map_fd(ctx->bpf_obj, MAPNAME_JMP_TABLE_COPY);
+
+	if ((ctx->prog_stats_fd | ctx->nr_to_prog_idx_fd | ctx->jmp_entry_fd |
+	     ctx->jmp_copy_fd) < 0)
+		return NULL;
+
+	if (verbose)
+		printf("opening (%s)\n", mappath);
+
+	ctx->jmp_table_fd = bpf_obj_get(mappath);
+	if (ctx->jmp_table_fd < 0) {
+		fprintf(stderr, "ERR: failed to open %s\n", mappath);
+		return NULL;
+	}
+
+	if (verbose)
+		printf("copying jmp_table to jmp_table_copy\n");
+
+	if (__copy_prog_array_map(ctx->jmp_table_fd, ctx->jmp_copy_fd) < 0) {
+		fprintf(stderr, "ERR: failed to copy jump table\n");
+		return NULL;
+	}
+
+	ctx->prog_cnt = __load_interceptors(ctx->bpf_obj, ctx->jmp_table_fd,
+					    ctx->nr_to_prog_idx_fd);
+	if (ctx->prog_cnt < 0) {
+		fprintf(stderr, "ERR: failed to load intercepts\n");
+		return NULL;
+	}
+
+	if (verbose)
+		printf("%d intercepts loaded into jmp_table\n", ctx->prog_cnt);
+
+	ctx->entry_copy_fd = __swap_xdp_entrypoint(ctx->bpf_obj, ctx->entry_fd,
+						   ctx->ifindex);
+	if (ctx->entry_copy_fd < 0) {
+		fprintf(stderr, "ERR: failed to intercept entrypoint\n");
+		return NULL;
+	}
+
+	if (verbose)
+		printf("intercept attached to XDP entrypoint\n");
+
+	return ctx;
+}
+
+/* intercept__teardown does the following:
+ *
+ * 1. Restores the intercepted program array using a backup copy made during
+ *    intercept__setup.
+ * 2. The original XDP entrypoint is rehooked.
+ * 3. The previous value of sys.kernel.bpf_stats_enabled before the call to
+ *    intercept__setup is restored.
+ * 4. The context is freed.
+ *
+ * This function MUST be called ONCE after creating a context via
+ * intercept__setup.
+ */
+static int intercept__teardown(struct intercept_ctx *ctx)
+{
+	if (__copy_prog_array_map(ctx->jmp_copy_fd, ctx->jmp_table_fd) < 0) {
+		fprintf(stderr, "ERR: failed to restore jump table\n");
+		return -1;
+	}
+
+	if (__swap_xdp_entrypoint(ctx->bpf_obj, ctx->entry_copy_fd,
+				  ctx->ifindex) < 0) {
+		fprintf(stderr, "ERR: failed to restore entrypoint\n");
+		return -1;
+	}
+
+	if (_update_sysctl("/proc/sys/kernel/bpf_stats_enabled",
+			   ctx->stats_enabled_oldval) < 0) {
+		perror("ERR: failed to restore bpf_stats_enabled sysctl\n");
+		return -1;
+	}
+
+	free(ctx);
+
+	return 0;
+}
+
+static struct intercept_stats *intercept__alloc_stats(struct intercept_ctx *ctx)
+{
+	struct intercept_stats *stats;
+
+	stats = malloc(sizeof(*stats));
+	if (!stats) {
+		fprintf(stderr, "ERR: mem alloc failed\n");
+		return stats;
+	}
+
+	return stats;
+}
+
+static void intercept__free_stats(struct intercept_stats *stats)
+{
+	free(stats);
+}
+
+static int intercept__collect_stats(struct intercept_ctx *ctx,
+				    struct intercept_stats *stats)
+{
+	int nr, i;
+	unsigned int nr_cpus = libbpf_num_possible_cpus();
+	struct bpf_prog_info *info;
+
+	info = __get_interceptor_info(ctx, 0, true, true);
+	if (info == NULL)
+		return -1;
+
+	memset(stats, 0, sizeof(*stats));
+
+	stats->run_time_ns_total = info->run_time_ns;
+	stats->run_cnt_total = info->run_cnt;
+
+	for (nr = 0; nr < ctx->prog_cnt; nr++) {
+		struct prog_stats_rec values[nr_cpus];
+
+		if (bpf_map_lookup_elem(ctx->prog_stats_fd, &nr, values) != 0) {
+			fprintf(stderr, "ERR: intercept_stats_map(%d)\n", nr);
+			return -1;
+		}
+
+		info = __get_interceptor_info(ctx, nr, !nr, false);
+		if (info == NULL) {
+			fprintf(stderr, "ERR: get_intercept_info(%d)\n", nr);
+			return -1;
+		}
+
+		stats->progs[nr].name = strdup(info->name);
+		stats->progs[nr].id = info->id;
+
+		for (i = 0; i < nr_cpus; i++) {
+			stats->run_time_ns_accounted +=
+				values[i].ns_chained_runtime;
+			stats->progs[nr].stats.nr_terminal_runs +=
+				values[i].nr_terminal_runs;
+			stats->progs[nr].stats.nr_chained_runs +=
+				values[i].nr_chained_runs;
+			stats->progs[nr].stats.ns_chained_runtime +=
+				values[i].ns_chained_runtime;
+		}
+	}
+
+	free(info);
+	return 0;
+}
+
+static int intercept__print_stats(struct intercept_ctx *ctx,
+				  struct intercept_stats *stats)
+{
+	int i;
+	char timestamp[12];
+	time_t t = time(NULL);
+	struct tm *lt = localtime(&t);
+
+	if (intercept__collect_stats(ctx, stats) < 0) {
+		fprintf(stderr, "ERR: failed to get xdp stats\n");
+		return -1;
+	}
+
+	sprintf(timestamp, "%d:%d:%d", lt->tm_hour, lt->tm_min, lt->tm_sec);
+
+	/* Print header */
+	printf("%-8s %-4s %-25s ", timestamp, "Id", "Name");
+	printf("%-15s %-15s ", "chain_runs", "chain/ns");
+	printf("%-15s %-15s ", "term_runs", "term/ns");
+	printf("%-15s\n", "total/ns");
+
+	/* Print row per BPF program */
+	struct intercept_prog prog;
+
+	for (i = 0; i < ctx->prog_cnt; i++) {
+		prog = stats->progs[i];
+		printf("%-8s ", timestamp);
+		printf("%-4lld %-25s ", prog.id, prog.name);
+		printf("%-15lld %-15lld ", prog.stats.nr_chained_runs,
+		       prog.stats.ns_chained_runtime);
+
+		double terminal_weight = 0;
+		double ns_terminal_runtime = 0;
+		double ns_total_runtime = 0;
+
+		/* Calculate estimates of terminal and total runtime */
+		if (prog.stats.nr_terminal_runs != 0) {
+			terminal_weight = (stats->run_cnt_total /
+					   (double)prog.stats.nr_terminal_runs);
+			ns_terminal_runtime = terminal_weight *
+					      (stats->run_time_ns_total -
+					       stats->run_time_ns_accounted);
+		}
+		ns_total_runtime =
+			ns_terminal_runtime + prog.stats.ns_chained_runtime;
+
+		printf("%-15lld %-15.0f ", prog.stats.nr_terminal_runs,
+		       ns_terminal_runtime);
+		printf("%-15.0f\n", ns_total_runtime);
+	}
+	printf("\n");
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	struct config cfg = { 0 };
+	struct intercept_ctx *ctx;
+	struct intercept_stats *stats;
+
+	signal(SIGINT, handle_signal);
+
+	cfg.interval = 2;
+
+	parse_args(argc, argv, &cfg);
+
+	if (cfg.ifname == NULL) {
+		fprintf(stderr, "ERR: --dev is a required parameter\n");
+		usage(argv);
+		return EXIT_FAILURE;
+	}
+
+	if (cfg.mappath == NULL) {
+		fprintf(stderr, "ERR: --map is a required parameter\n");
+		usage(argv);
+		return EXIT_FAILURE;
+	}
+
+	if (verbose)
+		printf("ifname(%s) ifindex(%d) mappath(%s) interval(%d)\n",
+		       cfg.ifname, cfg.ifindex, cfg.mappath, cfg.interval);
+
+	struct rlimit r = { RLIM_INFINITY, RLIM_INFINITY };
+
+	// Remove memlock limits as BPF maps are accounted as locked kernel
+	// memory.
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	if (verbose)
+		printf("calling intercept__setup\n");
+
+	ctx = intercept__setup(cfg.mappath, cfg.ifindex);
+	if (ctx == NULL) {
+		fprintf(stderr, "ERR: failed to setup intercept\n");
+		return EXIT_FAILURE;
+	}
+
+	stats = intercept__alloc_stats(ctx);
+	if (stats == NULL)
+		goto teardown;
+
+	while (1) {
+		if (intercept__print_stats(ctx, stats) < 0)
+			goto teardown;
+
+		if (!keep_going) {
+			printf("Interrupted by user\n");
+			break;
+		}
+		sleep(cfg.interval);
+	}
+
+	intercept__free_stats(stats);
+
+	if (verbose)
+		printf("calling intercept__restore\n");
+
+teardown:
+	if (intercept__teardown(ctx) != 0) {
+		fprintf(stderr, "CRITICAL ERR: failed to restore\n");
+		EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
-- 
2.24.1


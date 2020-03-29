Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3497419710E
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 01:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC2XQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 19:16:45 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37977 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbgC2XQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 19:16:43 -0400
Received: by mail-ot1-f66.google.com with SMTP id t28so16130708ott.5
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 16:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sage.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CsBMxR9v+LPP540eGOJLkT9Zcju8zCoz3xtTREcavTQ=;
        b=C151wAMLJ4AvbI5flyc9i8myQrBtTt2pAsnsp+AYOY1nSTJzJmdv4hMccvGJuizVbY
         L7516Wny9P9Fkz61/72eQVhZrzmSDfnIv59nG4BCjoSVH43Pqm+s3TPIPb0VClN353KE
         jqMHYwu9y+hE5NaNeyndIZCKp5j8CX9qnRgZtdTlQRfYNtO1z1qFYiAt9+TGpq+Bpa8i
         6hvAKX/+l6ptARgwn5OJSQE4l6W2YKIW9fMSakTI+PXkf3yQK+9+IFyNI/Xmj6atMe6r
         BcXFFeKmm1ll3OZvY7jGCiqTHWgwJvUnRMqZ3/O1DDst8th2PZUau2y2I9Hx7jPrRam/
         nypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CsBMxR9v+LPP540eGOJLkT9Zcju8zCoz3xtTREcavTQ=;
        b=JhNj/7Xa5006DwSy8V56wAV67n3g3eYy3a21HxAxK3a1e9tfl7GthpTez/hhQ5YTy5
         dyka6doXTG9Z/HtGOxjiYNd86Ds7YGjAvk6NDOCsBc8kBpTY5Rrw+a7faYLhNJ4D5wSI
         fghfFVle3fHDs4hzHaKvqZuEcMX89N1bsabzGIiB8xasYAfqMjKoNVzkUpWXPD+IqfEJ
         ct1U2Sn8HCk5CEP90gIxVBoMuzW9KUOpwPBIgRDNPg1e5EukxjIZeFpsw+LEVEwpldZF
         xglas39E4go3DMHQdxNHnHGQGzNGGfPN75C98oN0Y55XZ7VGuPHY68a30Q5JWCVTMS4p
         /TEw==
X-Gm-Message-State: ANhLgQ2PYv1Zb6WTHq34SWjySu1bnM6DJxEBw7/gt8KDYWuXsQ7aAQoG
        w4djgOxpdnVVzNgiSkRxGJZpqg==
X-Google-Smtp-Source: ADFU+vuVJsaZCvZheGLl5kcd9A+qLOAseEepef4KH4kGFhX88qT0a0gqPJfitWJ21u+DxkCry9fIZA==
X-Received: by 2002:a9d:5a15:: with SMTP id v21mr2431207oth.86.1585523797731;
        Sun, 29 Mar 2020 16:16:37 -0700 (PDT)
Received: from tower.attlocal.net ([2600:1700:4a30:fd70::48])
        by smtp.googlemail.com with ESMTPSA id 33sm3950011otn.50.2020.03.29.16.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 16:16:36 -0700 (PDT)
From:   Eric Sage <eric@sage.org>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, yhs@fb.com,
        andriin@fb.com, hawk@kernel.org, john.fastabend@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        Eric Sage <eric@sage.org>
Subject: [PATCH v4] samples/bpf: Add xdp_stat sample program
Date:   Sun, 29 Mar 2020 16:16:30 -0700
Message-Id: <20200329231630.41950-1-eric@sage.org>
X-Mailer: git-send-email 2.25.1
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

v4:
- rebase
v3:
- Fixed typos in xdp_stat_kern.c
- Switch to using key_size, value_size for prog arrays

Signed-off-by: Eric Sage <eric@sage.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 samples/bpf/Makefile          |   3 +
 samples/bpf/xdp_stat          | Bin 0 -> 200488 bytes
 samples/bpf/xdp_stat_common.h |  28 ++
 samples/bpf/xdp_stat_kern.c   | 192 +++++++++
 samples/bpf/xdp_stat_user.c   | 748 ++++++++++++++++++++++++++++++++++
 5 files changed, 971 insertions(+)
 create mode 100755 samples/bpf/xdp_stat
 create mode 100644 samples/bpf/xdp_stat_common.h
 create mode 100644 samples/bpf/xdp_stat_kern.c
 create mode 100644 samples/bpf/xdp_stat_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 424f6fe7ce38..52ceabdca08e 100644
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
 always-y := $(tprogs-y)
@@ -170,6 +172,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += xdp_stat_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/xdp_stat b/samples/bpf/xdp_stat
new file mode 100755
index 0000000000000000000000000000000000000000..32a05e4e3f804400914d5048bfb602888af00b11
GIT binary patch
literal 200488
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
Y;p^=&akHiJuaFOja4aawP;?pmKk_KsUjP6A

literal 0
HcmV?d00001

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
index 000000000000..e8eb0091c4e8
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
+#include <bpf/bpf_helpers.h>
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
2.25.1


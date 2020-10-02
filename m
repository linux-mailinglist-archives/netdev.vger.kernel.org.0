Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886CA281580
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388215AbgJBOm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:42:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBOm5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 10:42:57 -0400
Received: from lore-desk.redhat.com (unknown [176.207.245.61])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C66F120708;
        Fri,  2 Oct 2020 14:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601649776;
        bh=lFcWqY7rLwu78iOPKE7givKvyCMBOdqm51HhVpZKRoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ut98xk9SC9/wRWzNj7wXYK6m9Gzt+FyLkNf+1IFxsI5SLtSHNsdzIbHRYScQSjsB
         fhcoRyS7Byw9S9eLAj0sSG3dwlfDjKgljb+HcngnqS597p23+Y70Zbz2qt9DJSAbMY
         +sq+Fy5klrgofErhh7YS1KGGwgfvoOQJrG/up0ek=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        john.fastabend@gmail.com, dsahern@kernel.org, brouer@redhat.com,
        lorenzo.bianconi@redhat.com, echaudro@redhat.com
Subject: [PATCH v4 bpf-next 07/13] samples/bpf: add bpf program that uses xdp mb helpers
Date:   Fri,  2 Oct 2020 16:42:05 +0200
Message-Id: <8ace573b1a8d74f1a1bd072c08283a8560bd1b48.1601648734.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601648734.git.lorenzo@kernel.org>
References: <cover.1601648734.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

The bpf program returns XDP_PASS for every packet and calculates the
total number of bytes in its linear and paged parts.

The program is executed with:
./xdp_mb [if name]

and has the following output format:
[if index]: [rx packet count] pkt/sec, [number of bytes] bytes/sec

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/Makefile      |   3 +
 samples/bpf/xdp_mb_kern.c |  68 ++++++++++++++
 samples/bpf/xdp_mb_user.c | 182 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 253 insertions(+)
 create mode 100644 samples/bpf/xdp_mb_kern.c
 create mode 100644 samples/bpf/xdp_mb_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4f1ed0e3cf9f..12e32516f02a 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -54,6 +54,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += xdp_mb
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -111,6 +112,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+xdp_mb-objs := xdp_mb_user.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -172,6 +174,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += xdp_mb_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/xdp_mb_kern.c b/samples/bpf/xdp_mb_kern.c
new file mode 100644
index 000000000000..f366bce92fc7
--- /dev/null
+++ b/samples/bpf/xdp_mb_kern.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <bpf/bpf_helpers.h>
+
+/* count RX packets */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rx_cnt SEC(".maps");
+
+/* count RX fragments */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rx_frags SEC(".maps");
+
+/* count total number of bytes */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} tot_len SEC(".maps");
+
+SEC("xdp_mb")
+int xdp_mb_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	u32 frag_offset = 0, frag_size = 0;
+	u32 key = 0, nfrags;
+	long *value;
+	int i, len;
+
+	value = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (value)
+		*value += 1;
+
+	len = data_end - data;
+	nfrags = bpf_xdp_get_frags_count(ctx);
+	len += bpf_xdp_get_frags_total_size(ctx);
+
+	value = bpf_map_lookup_elem(&tot_len, &key);
+	if (value)
+		*value += len;
+
+	value = bpf_map_lookup_elem(&rx_frags, &key);
+	if (value)
+		*value += nfrags;
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_mb_user.c b/samples/bpf/xdp_mb_user.c
new file mode 100644
index 000000000000..6f555e94b748
--- /dev/null
+++ b/samples/bpf/xdp_mb_user.c
@@ -0,0 +1,182 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/*
+ * Copyright 2020 Amazon.com, Inc. or its affiliates. All rights reserved.
+ */
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <sys/resource.h>
+#include <net/if.h>
+
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
+static __u32 prog_id;
+static int rx_cnt_fd, tot_len_fd, rx_frags_fd;
+static int ifindex;
+
+static void int_exit(int sig)
+{
+	__u32 curr_prog_id = 0;
+
+	if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
+		printf("bpf_get_link_xdp_id failed\n");
+		exit(1);
+	}
+	if (prog_id == curr_prog_id)
+		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
+	else if (!curr_prog_id)
+		printf("couldn't find a prog id on a given interface\n");
+	else
+		printf("program on interface changed, not removing\n");
+	exit(0);
+}
+
+/* count total packets and bytes per second */
+static void poll_stats(int interval)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u64 rx_frags_cnt[nr_cpus], rx_frags_cnt_prev[nr_cpus];
+	__u64 tot_len[nr_cpus], tot_len_prev[nr_cpus];
+	__u64 rx_cnt[nr_cpus], rx_cnt_prev[nr_cpus];
+	int i;
+
+	memset(rx_frags_cnt_prev, 0, sizeof(rx_frags_cnt_prev));
+	memset(tot_len_prev, 0, sizeof(tot_len_prev));
+	memset(rx_cnt_prev, 0, sizeof(rx_cnt_prev));
+
+	while (1) {
+		__u64 n_rx_pkts = 0, rx_frags = 0, rx_len = 0;
+		__u32 key = 0;
+
+		sleep(interval);
+
+		/* fetch rx cnt */
+		assert(bpf_map_lookup_elem(rx_cnt_fd, &key, rx_cnt) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			n_rx_pkts += (rx_cnt[i] - rx_cnt_prev[i]);
+		memcpy(rx_cnt_prev, rx_cnt, sizeof(rx_cnt));
+
+		/* fetch rx frags */
+		assert(bpf_map_lookup_elem(rx_frags_fd, &key, rx_frags_cnt) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			rx_frags += (rx_frags_cnt[i] - rx_frags_cnt_prev[i]);
+		memcpy(rx_frags_cnt_prev, rx_frags_cnt, sizeof(rx_frags_cnt));
+
+		/* count total bytes of packets */
+		assert(bpf_map_lookup_elem(tot_len_fd, &key, tot_len) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			rx_len += (tot_len[i] - tot_len_prev[i]);
+		memcpy(tot_len_prev, tot_len, sizeof(tot_len));
+
+		if (n_rx_pkts)
+			printf("ifindex %i: %10llu pkt/s, %10llu frags/s, %10llu bytes/s\n",
+			       ifindex, n_rx_pkts / interval, rx_frags / interval,
+			       rx_len / interval);
+	}
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"%s: %s [OPTS] IFACE\n\n"
+		"OPTS:\n"
+		"    -F    force loading prog\n",
+		__func__, prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
+	struct bpf_prog_load_attr prog_load_attr = {
+		.prog_type	= BPF_PROG_TYPE_XDP,
+	};
+	int prog_fd, opt;
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	const char *optstr = "F";
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	char filename[256];
+	int err;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (optind == argc) {
+		usage(basename(argv[0]));
+		return 1;
+	}
+
+	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
+		perror("setrlimit(RLIMIT_MEMLOCK)");
+		return 1;
+	}
+
+	ifindex = if_nametoindex(argv[optind]);
+	if (!ifindex) {
+		perror("if_nametoindex");
+		return 1;
+	}
+
+	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
+	prog_load_attr.file = filename;
+
+	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		return 1;
+
+	prog = bpf_program__next(NULL, obj);
+	if (!prog) {
+		printf("finding a prog in obj file failed\n");
+		return 1;
+	}
+
+	if (!prog_fd) {
+		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
+		return 1;
+	}
+
+	rx_cnt_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
+	rx_frags_fd = bpf_object__find_map_fd_by_name(obj, "rx_frags");
+	tot_len_fd = bpf_object__find_map_fd_by_name(obj, "tot_len");
+	if (rx_cnt_fd < 0 || rx_frags_fd < 0 || tot_len_fd < 0) {
+		printf("bpf_object__find_map_fd_by_name failed\n");
+		return 1;
+	}
+
+	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
+		printf("ERROR: link set xdp fd failed on %d\n", ifindex);
+		return 1;
+	}
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (err) {
+		printf("can't get prog info - %s\n", strerror(errno));
+		return err;
+	}
+	prog_id = info.id;
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	poll_stats(1);
+
+	return 0;
+}
-- 
2.26.2


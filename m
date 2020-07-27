Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A4722ECA5
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgG0M5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:57:15 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:9730 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbgG0M5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:57:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1595854632; x=1627390632;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=MUMMfUKzIyAxukY29GnSc5F2ykLaXcgbsXS0LvvVySY=;
  b=Ig4UpnG9NVMbQRhIKfDEvXhKPDVTjyBiMfAyblMljQp2KPS0DC2fjTbA
   okuhhklnRn/Y89NI+MF6pLhyvBjiO6On4woq9FtXh1Je1MyecM7RBIXWZ
   TzfPMoplA641S8na03ijE3o+YT/GMiIqe4WB2A2V0wFXjfWTbDHXV1VXs
   o=;
IronPort-SDR: eZt4XxneGk9dP1OSGakIM/T1LeksGngZsPnzpX1C5+rFGag7GD/pyFxoXYOpm5rUQaAedIRrS4
 MEOfevPJ0lUg==
X-IronPort-AV: E=Sophos;i="5.75,402,1589241600"; 
   d="scan'208";a="44199236"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-27fb8269.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 27 Jul 2020 12:57:11 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-27fb8269.us-east-1.amazon.com (Postfix) with ESMTPS id BC9BCA1E77;
        Mon, 27 Jul 2020 12:57:07 +0000 (UTC)
Received: from EX13d09UWC003.ant.amazon.com (10.43.162.113) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from EX13MTAUWC001.ant.amazon.com (10.43.162.135) by
 EX13d09UWC003.ant.amazon.com (10.43.162.113) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 27 Jul 2020 12:56:55 +0000
Received: from dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (172.19.82.3)
 by mail-relay.amazon.com (10.43.162.232) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 27 Jul 2020 12:56:55 +0000
Received: by dev-dsk-sameehj-1c-1edacdb5.eu-west-1.amazon.com (Postfix, from userid 9775579)
        id 2637181C5D; Mon, 27 Jul 2020 12:56:55 +0000 (UTC)
From:   <sameehj@amazon.com>
To:     <davem@davemloft.net>, <netdev@vger.kernel.org>
CC:     Sameeh Jubran <sameehj@amazon.com>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <ndagan@amazon.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@chromium.org>,
        <kuba@kernel.org>, <hawk@kernel.org>, <shayagr@amazon.com>,
        <lorenzo@kernel.org>
Subject: [PATCH RFC net-next 2/2] samples/bpf: add bpf program that uses xdp mb helpers
Date:   Mon, 27 Jul 2020 12:56:53 +0000
Message-ID: <20200727125653.31238-3-sameehj@amazon.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200727125653.31238-1-sameehj@amazon.com>
References: <20200727125653.31238-1-sameehj@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
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
---
 samples/bpf/Makefile      |   3 +
 samples/bpf/xdp_mb_kern.c |  66 ++++++++++++++++++
 samples/bpf/xdp_mb_user.c | 174 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 243 insertions(+)
 create mode 100644 samples/bpf/xdp_mb_kern.c
 create mode 100644 samples/bpf/xdp_mb_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index f87ee0207..fd21d99e5 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -53,6 +53,7 @@ tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
+tprogs-y += xdp_mb
 
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
@@ -109,6 +110,7 @@ task_fd_query-objs := bpf_load.o task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o $(TRACE_HELPERS)
 ibumad-objs := bpf_load.o ibumad_user.o $(TRACE_HELPERS)
 hbm-objs := bpf_load.o hbm.o $(CGROUP_HELPERS)
+xdp_mb-objs := xdp_mb_user.o
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -170,6 +172,7 @@ always-y += ibumad_kern.o
 always-y += hbm_out_kern.o
 always-y += hbm_edt_kern.o
 always-y += xdpsock_kern.o
+always-y += xdp_mb_kern.o
 
 ifeq ($(ARCH), arm)
 # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
diff --git a/samples/bpf/xdp_mb_kern.c b/samples/bpf/xdp_mb_kern.c
new file mode 100644
index 000000000..1dfd61b34
--- /dev/null
+++ b/samples/bpf/xdp_mb_kern.c
@@ -0,0 +1,66 @@
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
+#define MAX_FRAGS 5
+
+/* count RX packets */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} rxcnt SEC(".maps");
+
+/* count total number of bytes */
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, long);
+	__uint(max_entries, 1);
+} total_bytes SEC(".maps");
+
+SEC("xdp_mb")
+int xdp_mb_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	u32 frag_offset = 0;
+	u32 frag_size = 0;
+	u32 key = 0;
+	u32 frag_nr;
+	long *value;
+	int total;
+	int i;
+
+	value = bpf_map_lookup_elem(&rxcnt, &key);
+	if (value)
+		*value += 1;
+
+	value = bpf_map_lookup_elem(&total_bytes, &key);
+	if (value) {
+		total = data_end - data;
+
+		frag_nr = bpf_xdp_get_frag_count(ctx);
+		for (i = 0; i < MAX_FRAGS && i < frag_nr; i++) {
+			bpf_xdp_get_frag(ctx, i, &frag_size, &frag_offset);
+			total += frag_size;
+		}
+
+		*value += total;
+	}
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_mb_user.c b/samples/bpf/xdp_mb_user.c
new file mode 100644
index 000000000..ff122d1e6
--- /dev/null
+++ b/samples/bpf/xdp_mb_user.c
@@ -0,0 +1,174 @@
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
+static int ifindex;
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST | XDP_FLAGS_DRV_MODE;
+static __u32 prog_id;
+
+static int rxcnt_fd, total_bytes_fd;
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
+	__u64 rx_cnt[nr_cpus], rx_cnt_prev[nr_cpus];
+	__u64 total_bytes[nr_cpus], total_bytes_prev[nr_cpus];
+	int i;
+
+	memset(rx_cnt_prev, 0, sizeof(rx_cnt_prev));
+	memset(total_bytes_prev, 0, sizeof(total_bytes_prev));
+
+	while (1) {
+		__u64 sum = 0, mb_sum = 0;
+		__u32 key = 0;
+
+		sleep(interval);
+
+		/* fetch rx cnt */
+		assert(bpf_map_lookup_elem(rxcnt_fd, &key, rx_cnt) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			sum += (rx_cnt[i] - rx_cnt_prev[i]);
+		memcpy(rx_cnt_prev, rx_cnt, sizeof(rx_cnt));
+
+		/* count total bytes of packets */
+		assert(bpf_map_lookup_elem(total_bytes_fd, &key, total_bytes) == 0);
+		for (i = 0; i < nr_cpus; i++)
+			mb_sum += (total_bytes[i] - total_bytes_prev[i]);
+		memcpy(total_bytes_prev, total_bytes, sizeof(total_bytes));
+
+		if (sum)
+			printf("ifindex %i: %10llu pkt/s, %10llu bytes/s\n",
+			       ifindex, sum / interval, mb_sum / interval);
+	}
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] IFACE\n\n"
+		"OPTS:\n"
+		"    -F    force loading prog\n",
+		prog);
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
+	rxcnt_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
+	total_bytes_fd = bpf_object__find_map_fd_by_name(obj, "total_bytes");
+	if (rxcnt_fd < 0 || total_bytes_fd < 0) {
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
2.16.6


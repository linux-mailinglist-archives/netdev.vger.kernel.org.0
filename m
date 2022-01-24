Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1DE0498678
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 18:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244515AbiAXRVd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 12:21:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244428AbiAXRU6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 12:20:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C29FC061747;
        Mon, 24 Jan 2022 09:20:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA1D2B81193;
        Mon, 24 Jan 2022 17:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14D2C36AE2;
        Mon, 24 Jan 2022 17:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643044836;
        bh=rkXseVn1QFXcCnhlvK1TaREQozBZtgriKVAq/yfYSpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KPTgZEWkLpPbJnS6Tm9OBpAgM+mcxCldBjB2W+IKPLYVgOwZIxrknSJi+6PDvgMCD
         piUGVoxa0qza/dz52c8irysf/EDTVqsHPOEMDvn/1wnrEVLFF1ZU4Ia/rWevvMEZE1
         jAn94fVV+rB2PCUTEwv9pz9zNddy/jOLXYSiRLg9xrmXd01a/iF5pNaU+Rq7fkg0K2
         rz5h032d7Vb/YvUYeQfWgLp+WfirWsSI9sXkSWcGMNRkQz1WUt63YCwwDEbzw/D5D+
         SVlM14I0dZUAZrZoOeZW5pF+jE7K3IINAKmcz+5KlLPOVMc7D4M5fkthZddkXYwb0l
         dao3frnlza7oA==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, andrii.nakryiko@gmail.com
Subject: [RFC bpf-next 2/2] samples: bpf: add xdp fdb lookup program
Date:   Mon, 24 Jan 2022 18:20:16 +0100
Message-Id: <17db48a98b53d95db980b85704f1a42a8555f9a6.1643044381.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643044381.git.lorenzo@kernel.org>
References: <cover.1643044381.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds an example of a xdp-based bridge with the new
br_fdb_find_port_from_ifindex unstable helper.
This program simply forwards packets based on the destination address
running a fdb lookup on a bridge fdb table in the kernel.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 samples/bpf/Makefile       |   9 ++-
 samples/bpf/xdp_fdb.bpf.c  |  68 +++++++++++++++++
 samples/bpf/xdp_fdb_user.c | 152 +++++++++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 1 deletion(-)
 create mode 100644 samples/bpf/xdp_fdb.bpf.c
 create mode 100644 samples/bpf/xdp_fdb_user.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 38638845db9d..1fb4544a66a7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -59,6 +59,7 @@ tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
+tprogs-y += xdp_fdb
 
 # Libbpf dependencies
 LIBBPF_SRC = $(TOOLS_PATH)/lib/bpf
@@ -124,6 +125,7 @@ xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
+xdp_fdb-objs := xdp_fdb_user.o $(XDP_SAMPLE)
 
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
@@ -226,6 +228,7 @@ TPROGLDLIBS_map_perf_test	+= -lrt
 TPROGLDLIBS_test_overhead	+= -lrt
 TPROGLDLIBS_xdpsock		+= -pthread -lcap
 TPROGLDLIBS_xsk_fwd		+= -pthread
+TPROGLDLIBS_xdp_fdb		+= -lm
 
 # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redefine on cmdline:
 # make M=samples/bpf LLC=~/git/llvm-project/llvm/build/bin/llc CLANG=~/git/llvm-project/llvm/build/bin/clang
@@ -342,6 +345,7 @@ $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
+$(obj)/xdp_fdb_user.o: $(obj)/xdp_fdb.skel.h
 
 $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
 $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
@@ -399,6 +403,7 @@ $(obj)/xdp_redirect_map_multi.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
+$(obj)/xdp_fdb.bpf.o: $(obj)/xdp_sample.bpf.o
 
 $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/xdp_sample_shared.h
 	@echo "  CLANG-BPF " $@
@@ -409,7 +414,8 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-c $(filter %.bpf.c,$^) -o $@
 
 LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
-		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
+		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h \
+		xdp_fdb.skel.h
 clean-files += $(LINKED_SKELS)
 
 xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
@@ -417,6 +423,7 @@ xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bp
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
+xdp_fdb.skel.h-deps := xdp_fdb.bpf.o xdp_sample.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
 
diff --git a/samples/bpf/xdp_fdb.bpf.c b/samples/bpf/xdp_fdb.bpf.c
new file mode 100644
index 000000000000..7c797bfb7300
--- /dev/null
+++ b/samples/bpf/xdp_fdb.bpf.c
@@ -0,0 +1,68 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of version 2 of the GNU General Public
+ * License as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ */
+#define KBUILD_MODNAME "foo"
+
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(int));
+	__uint(max_entries, 64);
+} br_ports SEC(".maps");
+
+struct bpf_fdb_lookup {
+	__u8	addr[ETH_ALEN];
+	__u16	vid;
+	__u32	ifindex;
+};
+
+int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
+				  struct bpf_fdb_lookup *opt,
+				  u32 opt__sz) __ksym;
+
+SEC("xdp")
+int xdp_fdb_lookup(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct bpf_fdb_lookup params = {
+		.ifindex = ctx->ingress_ifindex,
+	};
+	struct ethhdr *eth = data;
+	u64 nh_off = sizeof(*eth);
+	struct datarec *rec;
+	int ret;
+
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (!rec)
+		return XDP_PASS;
+
+	NO_TEAR_INC(rec->processed);
+
+	__builtin_memcpy(params.addr, eth->h_dest, ETH_ALEN);
+	ret = br_fdb_find_port_from_ifindex(ctx, &params,
+					    sizeof(struct bpf_fdb_lookup));
+	if (ret < 0)
+		/* In cases of flooding, XDP_PASS will be returned here */
+		return XDP_PASS;
+
+	return bpf_redirect_map(&br_ports, ret, 0);
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_fdb_user.c b/samples/bpf/xdp_fdb_user.c
new file mode 100644
index 000000000000..c3bc073f273d
--- /dev/null
+++ b/samples/bpf/xdp_fdb_user.c
@@ -0,0 +1,152 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+static const char *__doc__ =
+"XDP fdb lookup tool, using BPF_MAP_TYPE_DEVMAP\n"
+"Usage: xdp_fdb <IFINDEX_0> <IFINDEX_1> ... <IFINDEX_n>\n";
+
+#include <linux/bpf.h>
+#include <linux/if_link.h>
+#include <assert.h>
+#include <errno.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <stdbool.h>
+#include <string.h>
+#include <net/if.h>
+#include <unistd.h>
+#include <libgen.h>
+#include <getopt.h>
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_fdb.skel.h"
+
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT_MULTI |
+		  SAMPLE_REDIRECT_MAP_CNT;
+
+DEFINE_SAMPLE_INIT(xdp_fdb);
+
+static const struct option long_options[] = {
+	{ "help", no_argument, NULL, 'h' },
+	{ "force", no_argument, NULL, 'F' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{}
+};
+
+#define IFINDEX_LIST_SZ	32
+static int ifindex_list[IFINDEX_LIST_SZ];
+static int ifindex_num;
+
+int main(int argc, char **argv)
+{
+	int i, opt, ret = EXIT_FAIL_OPTION;
+	bool error = true, force = false;
+	unsigned long interval = 2;
+	struct xdp_fdb *skel;
+
+	while ((opt = getopt_long(argc, argv, "hFi:v",
+				  long_options, NULL)) != -1) {
+		switch (opt) {
+		case 'F':
+			force = true;
+			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
+			break;
+		case 'v':
+			sample_switch_mode();
+			break;
+		case 'h':
+			error = false;
+		default:
+			sample_usage(argv, long_options, __doc__, mask, error);
+			return ret;
+		}
+	}
+
+	if (argc <= optind + 1) {
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
+	}
+
+	for (i = optind; i < argc && i < IFINDEX_LIST_SZ; i++) {
+		int index;
+
+		index = if_nametoindex(argv[i]);
+
+		if (!index)
+			index = strtoul(argv[i], NULL, 0);
+		if (index)
+			ifindex_list[ifindex_num++] = index;
+	}
+
+	if (!ifindex_num) {
+		fprintf(stderr, "Bad interface index or name\n");
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
+	}
+
+	skel = xdp_fdb__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_fdb__open: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
+	}
+
+	ret = sample_init_pre_load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to sample_init_pre_load: %s\n", strerror(-ret));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
+	}
+
+	ret = xdp_fdb__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to xdp_fdb__load: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
+	}
+
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
+	}
+
+	for (i = 0; i < ifindex_num; i++) {
+		if (sample_install_xdp(skel->progs.xdp_fdb_lookup,
+				       ifindex_list[i], false, force) < 0) {
+			ret = EXIT_FAIL_XDP;
+			goto end_destroy;
+		}
+
+		if (bpf_map_update_elem(bpf_map__fd(skel->maps.br_ports),
+					&ifindex_list[i],
+					&ifindex_list[i], 0) < 0) {
+			fprintf(stderr, "Failed to update devmap value: %s\n",
+				strerror(errno));
+			ret = EXIT_FAIL_BPF;
+			goto end_destroy;
+		}
+	}
+
+	ret = sample_run(interval, NULL, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
+	}
+	ret = EXIT_OK;
+
+end_destroy:
+	xdp_fdb__destroy(skel);
+end:
+	sample_exit(ret);
+}
-- 
2.34.1


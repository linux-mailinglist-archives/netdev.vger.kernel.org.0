Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9786F3D93B5
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbhG1Q5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhG1Q5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:57:07 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8F5C061799;
        Wed, 28 Jul 2021 09:57:00 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id q17-20020a17090a2e11b02901757deaf2c8so5180471pjd.0;
        Wed, 28 Jul 2021 09:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kA+Jg28xr2iMLRT5HWlNB4g8RS1kOu72HeXCjVJArmQ=;
        b=AqSJZQM8LCjo8ymNZDV8Fv9qn0S/ODiZRZXoT1e3iQLuf7S9wIg+aMT25R6n4ot1vS
         VHLToeGYUB/BmCBi9AwFgbIkrS5mmesqRbmDCK9gmqqW3oV9NbVRbvA1XvtK46HyI2Qu
         xo7uHxsJbA5higTUcJtqiLPm+OWUbbVCZW/d0RXtftZcEjUy1w859aaajMgwgS5VGaJ4
         o7TEYz1op390oN4dQ+g8GmayKzCXKOB76BULMgeraHU3jVy6hlOppzpAJxystyvdsGHU
         qDQYC2wGbDXaT9jwY7Iq7GTbX8aMcR7vz6GlOn/fDKoL1f9OUIzsvziat2WwiukOLw9P
         SDmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kA+Jg28xr2iMLRT5HWlNB4g8RS1kOu72HeXCjVJArmQ=;
        b=tVUFUg5JaQRLpA4moARftwipfa3Y2tJxOQll8Jvxvbp6jiIQZV8iLPl/rxYDLUt/rK
         dDtPnVk3xonQCxa93xsLc6T5vUw7EV8MBDhzTRqKGo29pftWB0bqJMmBkZEtqYGyv8s1
         CP/xgCF+cyGkeBQSanTO3ML8wBLEnsiMNQ0hasG7/Azpb4X1BUzyL/PmS1EXYG4gBhkf
         RIvQ0fR5ujWPYFBDs7pfwA6fWJES7tXbI4fRb1rOV1kBM+lVSRNr6UaFKqol+JrX1nRa
         Eg7LPp1lKc00JtxcB4HWk+PLd3EUvXy3PsnBfNS7g6vh/wb/rQZd9MIy2fdab3cXHYK1
         K3HA==
X-Gm-Message-State: AOAM531Ls5Cj89I22NxDkIBBh/Y1R/iAsQdlBfFJZQ3ZGdx70diTkU6y
        90R93uUEukeFuqLn9g5ZMDP4eh6+S1offw==
X-Google-Smtp-Source: ABdhPJzCwzvoTryG9/wyq9lph4mJD1hvzHqLhyudShCt0peC7eBpFZCbR/x6jP02RXUJymUj4l4Kmg==
X-Received: by 2002:a17:90a:530e:: with SMTP id x14mr737891pjh.128.1627491419906;
        Wed, 28 Jul 2021 09:56:59 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id d67sm562938pfd.81.2021.07.28.09.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:56:59 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 5/8] samples: bpf: Convert xdp_redirect to use XDP samples helper
Date:   Wed, 28 Jul 2021 22:25:49 +0530
Message-Id: <20210728165552.435050-6-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP redirect tool to use the XDP samples support
introduced in previous changes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile            |  10 +-
 samples/bpf/xdp_redirect.bpf.c  |  51 ++++++
 samples/bpf/xdp_redirect_kern.c |  90 -----------
 samples/bpf/xdp_redirect_user.c | 265 +++++++++++++-------------------
 4 files changed, 164 insertions(+), 252 deletions(-)
 create mode 100644 samples/bpf/xdp_redirect.bpf.c
 delete mode 100644 samples/bpf/xdp_redirect_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1c7e1d5830c7..53ddf63c94d6 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
-tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
@@ -56,6 +55,7 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
 # Libbpf dependencies
@@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
-xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
@@ -117,6 +116,7 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
 
 # Tell kbuild to always build the programs
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
@@ -313,6 +312,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
 
 $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
@@ -356,6 +356,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
 
 $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/xdp_sample_shared.h
@@ -366,9 +367,10 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
 
 LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
diff --git a/samples/bpf/xdp_redirect.bpf.c b/samples/bpf/xdp_redirect.bpf.c
new file mode 100644
index 000000000000..6eda23b598bc
--- /dev/null
+++ b/samples/bpf/xdp_redirect.bpf.c
@@ -0,0 +1,51 @@
+/* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
+ *
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
+const volatile int ifindex_out;
+
+SEC("xdp")
+int xdp_redirect_prog(struct xdp_md *ctx)
+{
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
+	struct ethhdr *eth = data;
+	struct datarec *rec;
+	u64 nh_off;
+
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
+
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
+
+	swap_src_dst_mac(data);
+	return bpf_redirect(ifindex_out, 0);
+}
+
+/* Redirect require an XDP bpf_prog loaded on the TX device */
+SEC("xdp")
+int xdp_redirect_dummy_prog(struct xdp_md *ctx)
+{
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_kern.c b/samples/bpf/xdp_redirect_kern.c
deleted file mode 100644
index d26ec3aa215e..000000000000
--- a/samples/bpf/xdp_redirect_kern.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of version 2 of the GNU General Public
- * License as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
- * General Public License for more details.
- */
-#define KBUILD_MODNAME "foo"
-#include <uapi/linux/bpf.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/if_vlan.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <bpf/bpf_helpers.h>
-
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, int);
-	__type(value, int);
-	__uint(max_entries, 1);
-} tx_port SEC(".maps");
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-static void swap_src_dst_mac(void *data)
-{
-	unsigned short *p = data;
-	unsigned short dst[3];
-
-	dst[0] = p[0];
-	dst[1] = p[1];
-	dst[2] = p[2];
-	p[0] = p[3];
-	p[1] = p[4];
-	p[2] = p[5];
-	p[3] = dst[0];
-	p[4] = dst[1];
-	p[5] = dst[2];
-}
-
-SEC("xdp_redirect")
-int xdp_redirect_prog(struct xdp_md *ctx)
-{
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
-	int rc = XDP_DROP;
-	int *ifindex, port = 0;
-	long *value;
-	u32 key = 0;
-	u64 nh_off;
-
-	nh_off = sizeof(*eth);
-	if (data + nh_off > data_end)
-		return rc;
-
-	ifindex = bpf_map_lookup_elem(&tx_port, &port);
-	if (!ifindex)
-		return rc;
-
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
-
-	swap_src_dst_mac(data);
-	return bpf_redirect(*ifindex, 0);
-}
-
-/* Redirect require an XDP bpf_prog loaded on the TX device */
-SEC("xdp_redirect_dummy")
-int xdp_redirect_dummy_prog(struct xdp_md *ctx)
-{
-	return XDP_PASS;
-}
-
-char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 93854e135134..bfd08e072b3b 100644
--- a/samples/bpf/xdp_redirect_user.c
+++ b/samples/bpf/xdp_redirect_user.c
@@ -1,6 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2016 John Fastabend <john.r.fastabend@intel.com>
  */
+static const char *__doc__ =
+"XDP redirect tool, using bpf_redirect helper\n"
+"Usage: xdp_redirect <IFINDEX|IFNAME>_IN <IFINDEX|IFNAME>_OUT\n";
+
 #include <linux/bpf.h>
 #include <linux/if_link.h>
 #include <assert.h>
@@ -13,126 +17,73 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
+#include <getopt.h>
 #include <sys/resource.h>
-
-#include "bpf_util.h"
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_redirect.skel.h"
 
-static int ifindex_in;
-static int ifindex_out;
-static bool ifindex_out_xdp_dummy_attached = true;
-static __u32 prog_id;
-static __u32 dummy_prog_id;
-
-static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int rxcnt_map_fd;
-
-static void int_exit(int sig)
-{
-	__u32 curr_prog_id = 0;
-
-	if (bpf_get_link_xdp_id(ifindex_in, &curr_prog_id, xdp_flags)) {
-		printf("bpf_get_link_xdp_id failed\n");
-		exit(1);
-	}
-	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(ifindex_in, -1, xdp_flags);
-	else if (!curr_prog_id)
-		printf("couldn't find a prog id on iface IN\n");
-	else
-		printf("program on iface IN changed, not removing\n");
-
-	if (ifindex_out_xdp_dummy_attached) {
-		curr_prog_id = 0;
-		if (bpf_get_link_xdp_id(ifindex_out, &curr_prog_id,
-					xdp_flags)) {
-			printf("bpf_get_link_xdp_id failed\n");
-			exit(1);
-		}
-		if (dummy_prog_id == curr_prog_id)
-			bpf_set_link_xdp_fd(ifindex_out, -1, xdp_flags);
-		else if (!curr_prog_id)
-			printf("couldn't find a prog id on iface OUT\n");
-		else
-			printf("program on iface OUT changed, not removing\n");
-	}
-	exit(0);
-}
-
-static void poll_stats(int interval, int ifindex)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	__u64 values[nr_cpus], prev[nr_cpus];
-
-	memset(prev, 0, sizeof(prev));
-
-	while (1) {
-		__u64 sum = 0;
-		__u32 key = 0;
-		int i;
-
-		sleep(interval);
-		assert(bpf_map_lookup_elem(rxcnt_map_fd, &key, values) == 0);
-		for (i = 0; i < nr_cpus; i++)
-			sum += (values[i] - prev[i]);
-		if (sum)
-			printf("ifindex %i: %10llu pkt/s\n",
-			       ifindex, sum / interval);
-		memcpy(prev, values, sizeof(values));
-	}
-}
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
+		  SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 
-static void usage(const char *prog)
-{
-	fprintf(stderr,
-		"usage: %s [OPTS] <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n\n"
-		"OPTS:\n"
-		"    -S    use skb-mode\n"
-		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n",
-		prog);
-}
+DEFINE_SAMPLE_INIT(xdp_redirect);
 
+static const struct option long_options[] = {
+	{"help",	no_argument,		NULL, 'h' },
+	{"skb-mode",	no_argument,		NULL, 'S' },
+	{"force",	no_argument,		NULL, 'F' },
+	{"stats",	no_argument,		NULL, 's' },
+	{"interval",	required_argument,	NULL, 'i' },
+	{"verbose",	no_argument,		NULL, 'v' },
+	{}
+};
 
 int main(int argc, char **argv)
 {
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_XDP,
-	};
-	struct bpf_program *prog, *dummy_prog;
-	int prog_fd, tx_port_map_fd, opt;
-	struct bpf_prog_info info = {};
-	__u32 info_len = sizeof(info);
-	const char *optstr = "FSN";
-	struct bpf_object *obj;
-	char filename[256];
-	int dummy_prog_fd;
-	int ret, key = 0;
-
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
+	int ifindex_in, ifindex_out, opt;
+	char str[2 * IF_NAMESIZE + 1];
+	char ifname_out[IF_NAMESIZE];
+	char ifname_in[IF_NAMESIZE];
+	int ret = EXIT_FAIL_OPTION;
+	unsigned long interval = 2;
+	struct xdp_redirect *skel;
+	bool generic = false;
+	bool force = false;
+	bool error = true;
+
+	while ((opt = getopt_long(argc, argv, "SFi:vs",
+				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
-			xdp_flags |= XDP_FLAGS_SKB_MODE;
-			break;
-		case 'N':
-			/* default, set below */
+			generic = true;
+			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
+				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
 		case 'F':
-			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			force = true;
+			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
+			break;
+		case 'v':
+			sample_switch_mode();
+			break;
+		case 's':
+			mask |= SAMPLE_REDIRECT_CNT;
 			break;
+		case 'h':
+			error = false;
 		default:
-			usage(basename(argv[0]));
-			return 1;
+			sample_usage(argv, long_options, __doc__, mask, error);
+			return ret;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
-		xdp_flags |= XDP_FLAGS_DRV_MODE;
-
-	if (optind + 2 != argc) {
-		printf("usage: %s <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n", argv[0]);
-		return 1;
+	if (argc <= optind + 1) {
+		sample_usage(argv, long_options, __doc__, mask, true);
+		return ret;
 	}
 
 	ifindex_in = if_nametoindex(argv[optind]);
@@ -143,75 +94,73 @@ int main(int argc, char **argv)
 	if (!ifindex_out)
 		ifindex_out = strtoul(argv[optind + 1], NULL, 0);
 
-	printf("input: %d output: %d\n", ifindex_in, ifindex_out);
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	prog_load_attr.file = filename;
-
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
-		return 1;
-
-	prog = bpf_program__next(NULL, obj);
-	dummy_prog = bpf_program__next(prog, obj);
-	if (!prog || !dummy_prog) {
-		printf("finding a prog in obj file failed\n");
-		return 1;
-	}
-	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
-	 */
-	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0) {
-		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
-		return 1;
+	if (!ifindex_in || !ifindex_out) {
+		fprintf(stderr, "Bad interface index or name\n");
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
 	}
 
-	tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port");
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_port_map_fd < 0 || rxcnt_map_fd < 0) {
-		printf("bpf_object__find_map_fd_by_name failed\n");
-		return 1;
+	skel = xdp_redirect__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect__open: %s\n", strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	if (bpf_set_link_xdp_fd(ifindex_in, prog_fd, xdp_flags) < 0) {
-		printf("ERROR: link set xdp fd failed on %d\n", ifindex_in);
-		return 1;
+	skel->rodata->from_match[0] = ifindex_in;
+	skel->rodata->to_match[0] = ifindex_out;
+	skel->rodata->ifindex_out = ifindex_out;
+
+	ret = xdp_redirect__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to xdp_redirect__load: %s\n", strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
 	}
 
-	ret = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (ret) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		return ret;
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
 	}
-	prog_id = info.id;
+
+	ret = EXIT_FAIL_XDP;
+	if (sample_install_xdp(skel->progs.xdp_redirect_prog, ifindex_in,
+			       generic, force) < 0)
+		goto end_destroy;
 
 	/* Loading dummy XDP prog on out-device */
-	if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
-			    (xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) < 0) {
-		printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
-		ifindex_out_xdp_dummy_attached = false;
+	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, ifindex_out,
+			   generic, force);
+
+	ret = EXIT_FAIL;
+	if (!if_indextoname(ifindex_in, ifname_in)) {
+		fprintf(stderr, "Failed to if_indextoname for %d: %s\n", ifindex_in,
+			strerror(errno));
+		goto end_destroy;
 	}
 
-	memset(&info, 0, sizeof(info));
-	ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
-	if (ret) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		return ret;
+	if (!if_indextoname(ifindex_out, ifname_out)) {
+		fprintf(stderr, "Failed to if_indextoname for %d: %s\n", ifindex_out,
+			strerror(errno));
+		goto end_destroy;
 	}
-	dummy_prog_id = info.id;
 
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	safe_strncpy(str, get_driver_name(ifindex_in), sizeof(str));
+	printf("Redirecting from %s (ifindex %d; driver %s) to %s (ifindex %d; driver %s)\n",
+	       ifname_in, ifindex_in, str, ifname_out, ifindex_out, get_driver_name(ifindex_out));
+	snprintf(str, sizeof(str), "%s->%s", ifname_in, ifname_out);
 
-	/* bpf redirect port */
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &ifindex_out, 0);
-	if (ret) {
-		perror("bpf_update_elem");
-		goto out;
+	ret = sample_run(interval, NULL, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
 	}
-
-	poll_stats(2, ifindex_out);
-
-out:
-	return ret;
+	ret = EXIT_OK;
+end_destroy:
+	xdp_redirect__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0


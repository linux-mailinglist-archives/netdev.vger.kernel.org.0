Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEBFD3F37A7
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241078AbhHUAV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241017AbhHUAVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:48 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD634C0612A4;
        Fri, 20 Aug 2021 17:21:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s11so10808949pgr.11;
        Fri, 20 Aug 2021 17:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n3Vps2oF1/mGCBVP5pXBg7QUi/CGy6/10w/l+hL8SbQ=;
        b=dEElm2Ahjx1gEhElCNLXrbKmBaBDkb94MZPJQyPMnFp7uw4dzxkVSt4/axzBLN6utq
         Tsf3tZ1iVaJGb8CpUfPafGlmSHzRydnHXZI6a45I5FNtQzUDuScZCCZTDDMovdf0v3ru
         ucpfZhagoIRoA5hnz0zBvMrvcPTzsmXXVi5PcDZTMQe/Z+GxF1Nrcja3qRiyEcYia++G
         PAVfCUqbFJR+Oy1EfzEaDTf1NiklxqkNQcvJaXBGpLtMH+0gjOjxlFrIrr6vvP0MXXBe
         AZRl5SLlqW5C4LGxhrtBOctBs3zpZUNKSNO8Szbp0/l8uB2m0KT8PTHxD4VOS3Gn+TWb
         //2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n3Vps2oF1/mGCBVP5pXBg7QUi/CGy6/10w/l+hL8SbQ=;
        b=DJ//I6MjMhxd15X5m+JSXpGeLaAz9Xd3XMJWUHouMtImQHaDM+oi8WzDXCVz8NiLba
         EOMMMKgaP5lbYN3h61DqmZ84eM437OkmQUNZhGkGFZP7CCwBA1ysH5RHYbMK4rUPnSSl
         aYv6crLUFeDI8bh5z8mC1X210SsUkX754jNA763MidrEJpoGkYrTCgQoEaxBznJqgUnE
         Zv5KjUytMxNQ4CSfvapXNVeaGzziUNURTtyM3A4uQ3rEZE7BPxo7pkSOZ4uOT1WOqpNU
         SENnx0MfISJtsLyepXyYBbZ/1W92bEqJw6aLsOirLEG5xnDBXxhRwvdstWSLJWy3E3rz
         MmGQ==
X-Gm-Message-State: AOAM530ztxoiil4ibZF+DmFEWXip0jRBpbFKi08xvKRlERHyqyDCHj62
        3iVbp6nzOa7zzqmJmnouGAwtyLsrb44=
X-Google-Smtp-Source: ABdhPJxgmQQw5wjOmP3LQ9ahCpzoGZZ2dyPGLmGbKDjzfrNNQVxwKAnQ8+l7gUTqdYqW2HQxp/7N2Q==
X-Received: by 2002:a63:3d4a:: with SMTP id k71mr21374995pga.276.1629505262064;
        Fri, 20 Aug 2021 17:21:02 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id l10sm7544802pjg.11.2021.08.20.17.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:21:01 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 16/22] samples: bpf: Convert xdp_redirect to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:04 +0530
Message-Id: <20210821002010.845777-17-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the libbpf skeleton facility and other utilities provided by XDP
samples helper.

One important note:
The XDP samples helper handles ownership of installed XDP programs on
devices, including responding to SIGINT and SIGTERM, so drop the code
here and use the helpers we provide going forward for all xdp_redirect*
conversions.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile            |   5 +-
 samples/bpf/xdp_redirect_user.c | 270 +++++++++++++-------------------
 2 files changed, 116 insertions(+), 159 deletions(-)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 0b94a6acb348..d05105227ec5 100644
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
@@ -312,6 +312,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
 
 $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
diff --git a/samples/bpf/xdp_redirect_user.c b/samples/bpf/xdp_redirect_user.c
index 93854e135134..7af5b07a7523 100644
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
+	while ((opt = getopt_long(argc, argv, "hSFi:vs",
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
@@ -143,75 +94,80 @@ int main(int argc, char **argv)
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
+	if (!ifindex_in || !ifindex_out) {
+		fprintf(stderr, "Bad interface index or name\n");
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
 	}
-	/* bpf_prog_load_xattr gives us the pointer to first prog's fd,
-	 * so we're missing only the fd for dummy prog
-	 */
-	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0) {
-		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
-		return 1;
+
+	skel = xdp_redirect__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect__open: %s\n", strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port");
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_port_map_fd < 0 || rxcnt_map_fd < 0) {
-		printf("bpf_object__find_map_fd_by_name failed\n");
-		return 1;
+	ret = sample_init_pre_load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to sample_init_pre_load: %s\n", strerror(-ret));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
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
2.33.0


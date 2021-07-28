Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABE023D93B6
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhG1Q5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhG1Q5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:57:09 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B172EC061757;
        Wed, 28 Jul 2021 09:57:06 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso4976396pjf.4;
        Wed, 28 Jul 2021 09:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iCbi5UQICHT8qiCAmiWlCeMVo2X0MKUJdcNvlBORFK0=;
        b=HkvOOZ5b7XC6NErIda9wqFj+mQj++Sw90ofX6OC3XazBxt7PL1Dce6sbNCGw2nKgAV
         rfm+xskgPc7E4RV1gU+6nPyauNNeN9GIo7lqn8iQn3P44jcgBNISxEaSECfwyO89qiGs
         hirDljQZbrjgKpRvhaY6mzYPohI/jSBLUUezS1gJ806R9G5mQKnJVa5F2Ofx5MFePvqc
         VHRoXrVUGtldo+Qhsn6gF4nXTgCAjpyR8OyBOfvwkpZo9d0dwgYb0gFC2Jvqh4M+JSOi
         66l3sx7kurgR67bqbLJYKnR+GaWdLGuaEBIuGRCZx0oHGebESeHvtkkROStlH5xyA8aj
         Y/Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iCbi5UQICHT8qiCAmiWlCeMVo2X0MKUJdcNvlBORFK0=;
        b=MoIFUTFTHZKCNEvidbWnc+MZrM9SVYhW0hvfxmvpDNDXvav9WkUiPFEeVPAy4+el5P
         CVJQxCu3apnXJazGm8ilepfqhPuEnS1/wzcjk+6fbd+/gjmacZChhvXiX3hY0hKLNS91
         Ov1TXDCFhLRhQXYyLrRu7GLmUzcDIM9wj0MChMb3EROIJrJWwknMMNLzITu1QxyxZ85a
         g+Fc21qdSQeDt6Z7pqWluXW5GrIFwj/QfNFZZPJhPq3s9y1B37Gz8EHvLbP8afoV2P4+
         Q+H1PGFs9NawvHIV4Snx4EhkJv6GVvOWp936t01twsrsA6162GrMB6s14GHGKNdDOXB5
         ldUA==
X-Gm-Message-State: AOAM5314eHm0cthZqCD15PLzDd1nepz/q8L4NqzHPHFAN/jkQVsluw/q
        hkFbR84vttXKFNtwwVfZ2yjTNaQTR56RiQ==
X-Google-Smtp-Source: ABdhPJxUko64yMKdlqw3OEZhCC6Es5Aw3RpT79ROTbBU6DK3VFz/JeXMut4jEPAvg90r+PyvjWxd0w==
X-Received: by 2002:a63:6602:: with SMTP id a2mr755897pgc.228.1627491426100;
        Wed, 28 Jul 2021 09:57:06 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id 85sm531310pfz.76.2021.07.28.09.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:57:05 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 7/8] samples: bpf: Convert xdp_redirect_map_multi to use XDP samples helpers
Date:   Wed, 28 Jul 2021 22:25:51 +0530
Message-Id: <20210728165552.435050-8-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP redirect_map_multi tool to use the XDP samples
support introduced in previous changes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |  11 +-
 ...ti_kern.c => xdp_redirect_map_multi.bpf.c} |  51 ++-
 samples/bpf/xdp_redirect_map_multi_user.c     | 338 +++++++-----------
 3 files changed, 161 insertions(+), 239 deletions(-)
 rename samples/bpf/{xdp_redirect_map_multi_kern.c => xdp_redirect_map_multi.bpf.c} (64%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 53046fd37b6c..e51e1105d0c7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
-tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_rxq_info
 tprogs-y += syscall_tp
@@ -54,6 +53,7 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
@@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
-xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
@@ -115,6 +114,7 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
@@ -311,6 +310,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
@@ -356,6 +356,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect_map_multi.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
@@ -368,9 +369,11 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_map_multi.skel.h xdp_redirect_map.skel.h \
+		xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bpf.o
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
diff --git a/samples/bpf/xdp_redirect_map_multi_kern.c b/samples/bpf/xdp_redirect_map_multi.bpf.c
similarity index 64%
rename from samples/bpf/xdp_redirect_map_multi_kern.c
rename to samples/bpf/xdp_redirect_map_multi.bpf.c
index 71aa23d1cb2b..e1e1f5cd7bf4 100644
--- a/samples/bpf/xdp_redirect_map_multi_kern.c
+++ b/samples/bpf/xdp_redirect_map_multi.bpf.c
@@ -1,11 +1,14 @@
 // SPDX-License-Identifier: GPL-2.0
 #define KBUILD_MODNAME "foo"
-#include <uapi/linux/bpf.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <bpf/bpf_helpers.h>
+
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
+
+enum {
+	BPF_F_BROADCAST		= (1ULL << 3),
+	BPF_F_EXCLUDE_INGRESS	= (1ULL << 4),
+};
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP_HASH);
@@ -21,50 +24,42 @@ struct {
 	__uint(max_entries, 32);
 } forward_map_native SEC(".maps");
 
+/* map to store egress interfaces mac addresses */
 struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-/* map to store egress interfaces mac addresses, set the
- * max_entries to 1 and extend it in user sapce prog.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(type, BPF_MAP_TYPE_HASH);
 	__type(key, u32);
 	__type(value, __be64);
-	__uint(max_entries, 1);
+	__uint(max_entries, 32);
 } mac_map SEC(".maps");
 
 static int xdp_redirect_map(struct xdp_md *ctx, void *forward_map)
 {
-	long *value;
-	u32 key = 0;
+	u32 key = bpf_get_smp_processor_id();
+	struct datarec *rec;
+
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
 
-	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
-	return bpf_redirect_map(forward_map, key,
+	return bpf_redirect_map(forward_map, 0,
 				BPF_F_BROADCAST | BPF_F_EXCLUDE_INGRESS);
 }
 
-SEC("xdp_redirect_general")
+SEC("xdp")
 int xdp_redirect_map_general(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &forward_map_general);
 }
 
-SEC("xdp_redirect_native")
+SEC("xdp")
 int xdp_redirect_map_native(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &forward_map_native);
 }
 
-SEC("xdp_devmap/map_prog")
+SEC("xdp_devmap/egress")
 int xdp_devmap_prog(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
diff --git a/samples/bpf/xdp_redirect_map_multi_user.c b/samples/bpf/xdp_redirect_map_multi_user.c
index 84cdbbed20b7..3ace80b3ac7e 100644
--- a/samples/bpf/xdp_redirect_map_multi_user.c
+++ b/samples/bpf/xdp_redirect_map_multi_user.c
@@ -1,7 +1,12 @@
 // SPDX-License-Identifier: GPL-2.0
+static const char *__doc__ =
+"XDP multi redirect tool, using BPF_MAP_TYPE_DEVMAP and BPF_F_BROADCAST flag for bpf_redirect_map\n"
+"Usage: xdp_redirect_map_multi <IFINDEX|IFNAME> <IFINDEX|IFNAME> ... <IFINDEX|IFNAME>\n";
+
 #include <linux/bpf.h>
 #include <linux/if_link.h>
 #include <assert.h>
+#include <getopt.h>
 #include <errno.h>
 #include <signal.h>
 #include <stdio.h>
@@ -15,106 +20,54 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
-
-#include "bpf_util.h"
+#include <linux/if_ether.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_redirect_map_multi.skel.h"
 
 #define MAX_IFACE_NUM 32
-
-static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int ifaces[MAX_IFACE_NUM] = {};
-static int rxcnt_map_fd;
 
-static void int_exit(int sig)
-{
-	__u32 prog_id = 0;
-	int i;
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT |
+		  SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 
-	for (i = 0; ifaces[i] > 0; i++) {
-		if (bpf_get_link_xdp_id(ifaces[i], &prog_id, xdp_flags)) {
-			printf("bpf_get_link_xdp_id failed\n");
-			exit(1);
-		}
-		if (prog_id)
-			bpf_set_link_xdp_fd(ifaces[i], -1, xdp_flags);
-	}
+DEFINE_SAMPLE_INIT(xdp_redirect_map_multi);
 
-	exit(0);
-}
-
-static void poll_stats(int interval)
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
-			printf("Forwarding %10llu pkt/s\n", sum / interval);
-		memcpy(prev, values, sizeof(values));
-	}
-}
+static const struct option long_options[] = {
+	{ "help", no_argument, NULL, 'h' },
+	{ "skb-mode", no_argument, NULL, 'S' },
+	{ "force", no_argument, NULL, 'F' },
+	{ "load-egress", no_argument, NULL, 'X' },
+	{ "stats", no_argument, NULL, 's' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{}
+};
 
-static int get_mac_addr(unsigned int ifindex, void *mac_addr)
+static int update_mac_map(struct bpf_map *map)
 {
-	char ifname[IF_NAMESIZE];
-	struct ifreq ifr;
-	int fd, ret = -1;
-
-	fd = socket(AF_INET, SOCK_DGRAM, 0);
-	if (fd < 0)
-		return ret;
-
-	if (!if_indextoname(ifindex, ifname))
-		goto err_out;
-
-	strcpy(ifr.ifr_name, ifname);
-
-	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
-		goto err_out;
-
-	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
-	ret = 0;
-
-err_out:
-	close(fd);
-	return ret;
-}
-
-static int update_mac_map(struct bpf_object *obj)
-{
-	int i, ret = -1, mac_map_fd;
+	int mac_map_fd = bpf_map__fd(map);
 	unsigned char mac_addr[6];
 	unsigned int ifindex;
-
-	mac_map_fd = bpf_object__find_map_fd_by_name(obj, "mac_map");
-	if (mac_map_fd < 0) {
-		printf("find mac map fd failed\n");
-		return ret;
-	}
+	int i, ret = -1;
 
 	for (i = 0; ifaces[i] > 0; i++) {
 		ifindex = ifaces[i];
 
 		ret = get_mac_addr(ifindex, mac_addr);
 		if (ret < 0) {
-			printf("get interface %d mac failed\n", ifindex);
+			fprintf(stderr, "get interface %d mac failed\n",
+				ifindex);
 			return ret;
 		}
 
 		ret = bpf_map_update_elem(mac_map_fd, &ifindex, mac_addr, 0);
-		if (ret) {
-			perror("bpf_update_elem mac_map_fd");
+		if (ret < 0) {
+			fprintf(stderr, "Failed to update mac address for ifindex %d\n",
+				ifindex);
 			return ret;
 		}
 	}
@@ -122,181 +75,152 @@ static int update_mac_map(struct bpf_object *obj)
 	return 0;
 }
 
-static void usage(const char *prog)
-{
-	fprintf(stderr,
-		"usage: %s [OPTS] <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n"
-		"OPTS:\n"
-		"    -S    use skb-mode\n"
-		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n"
-		"    -X    load xdp program on egress\n",
-		prog);
-}
-
 int main(int argc, char **argv)
 {
-	int i, ret, opt, forward_map_fd, max_ifindex = 0;
-	struct bpf_program *ingress_prog, *egress_prog;
-	int ingress_prog_fd, egress_prog_fd = 0;
-	struct bpf_devmap_val devmap_val;
-	bool attach_egress_prog = false;
+	struct bpf_devmap_val devmap_val = {};
+	struct xdp_redirect_map_multi *skel;
+	struct bpf_program *ingress_prog;
+	bool xdp_devmap_attached = false;
+	struct bpf_map *forward_map;
+	int ret = EXIT_FAIL_OPTION;
+	unsigned long interval = 2;
 	char ifname[IF_NAMESIZE];
-	struct bpf_map *mac_map;
-	struct bpf_object *obj;
 	unsigned int ifindex;
-	char filename[256];
-
-	while ((opt = getopt(argc, argv, "SNFX")) != -1) {
+	bool generic = false;
+	bool force = false;
+	bool tried = false;
+	bool error = true;
+	int i, opt;
+
+	while ((opt = getopt_long(argc, argv, "SFXi:vs",
+				  long_options, NULL)) != -1) {
 		switch (opt) {
 		case 'S':
-			xdp_flags |= XDP_FLAGS_SKB_MODE;
-			break;
-		case 'N':
-			/* default, set below */
+			generic = true;
+			/* devmap_xmit tracepoint not available */
+			mask &= ~(SAMPLE_DEVMAP_XMIT_CNT |
+				  SAMPLE_DEVMAP_XMIT_CNT_MULTI);
 			break;
 		case 'F':
-			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			force = true;
 			break;
 		case 'X':
-			attach_egress_prog = true;
+			xdp_devmap_attached = true;
 			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
+			break;
+		case 'v':
+			sample_switch_mode();
+			break;
+		case 's':
+			mask |= SAMPLE_REDIRECT_MAP_CNT;
+			break;
+		case 'h':
+			error = false;
 		default:
-			usage(basename(argv[0]));
-			return 1;
+			sample_usage(argv, long_options, __doc__, mask, error);
+			return ret;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE)) {
-		xdp_flags |= XDP_FLAGS_DRV_MODE;
-	} else if (attach_egress_prog) {
-		printf("Load xdp program on egress with SKB mode not supported yet\n");
-		return 1;
+	if (argc <= optind + 1) {
+		sample_usage(argv, long_options, __doc__, mask, error);
+		return ret;
 	}
 
-	if (optind == argc) {
-		printf("usage: %s <IFNAME|IFINDEX> <IFNAME|IFINDEX> ...\n", argv[0]);
-		return 1;
+	skel = xdp_redirect_map_multi__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect_map_multi__open: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	printf("Get interfaces");
+	ret = EXIT_FAIL_OPTION;
 	for (i = 0; i < MAX_IFACE_NUM && argv[optind + i]; i++) {
 		ifaces[i] = if_nametoindex(argv[optind + i]);
 		if (!ifaces[i])
 			ifaces[i] = strtoul(argv[optind + i], NULL, 0);
 		if (!if_indextoname(ifaces[i], ifname)) {
-			perror("Invalid interface name or i");
-			return 1;
-		}
-
-		/* Find the largest index number */
-		if (ifaces[i] > max_ifindex)
-			max_ifindex = ifaces[i];
-
-		printf(" %d", ifaces[i]);
-	}
-	printf("\n");
-
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-
-	obj = bpf_object__open(filename);
-	if (libbpf_get_error(obj)) {
-		printf("ERROR: opening BPF object file failed\n");
-		obj = NULL;
-		goto err_out;
-	}
-
-	/* Reset the map size to max ifindex + 1 */
-	if (attach_egress_prog) {
-		mac_map = bpf_object__find_map_by_name(obj, "mac_map");
-		ret = bpf_map__resize(mac_map, max_ifindex + 1);
-		if (ret < 0) {
-			printf("ERROR: reset mac map size failed\n");
-			goto err_out;
+			fprintf(stderr, "Bad interface index or name\n");
+			sample_usage(argv, long_options, __doc__, mask, true);
+			goto end_destroy;
 		}
-	}
-
-	/* load BPF program */
-	if (bpf_object__load(obj)) {
-		printf("ERROR: loading BPF object file failed\n");
-		goto err_out;
-	}
-
-	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
-		ingress_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
-		forward_map_fd = bpf_object__find_map_fd_by_name(obj, "forward_map_general");
-	} else {
-		ingress_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_native");
-		forward_map_fd = bpf_object__find_map_fd_by_name(obj, "forward_map_native");
-	}
-	if (!ingress_prog || forward_map_fd < 0) {
-		printf("finding ingress_prog/forward_map in obj file failed\n");
-		goto err_out;
-	}
 
-	ingress_prog_fd = bpf_program__fd(ingress_prog);
-	if (ingress_prog_fd < 0) {
-		printf("find ingress_prog fd failed\n");
-		goto err_out;
+		skel->rodata->from_match[i] = ifaces[i];
+		skel->rodata->to_match[i] = ifaces[i];
 	}
 
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (rxcnt_map_fd < 0) {
-		printf("bpf_object__find_map_fd_by_name failed\n");
-		goto err_out;
+	ret = xdp_redirect_map_multi__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to xdp_redirect_map_multi__load: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
 	}
 
-	if (attach_egress_prog) {
+	if (xdp_devmap_attached) {
 		/* Update mac_map with all egress interfaces' mac addr */
-		if (update_mac_map(obj) < 0) {
-			printf("Error: update mac map failed");
-			goto err_out;
+		if (update_mac_map(skel->maps.mac_map) < 0) {
+			fprintf(stderr, "Updating mac address failed\n");
+			ret = EXIT_FAIL;
+			goto end_destroy;
 		}
+	}
 
-		/* Find egress prog fd */
-		egress_prog = bpf_object__find_program_by_name(obj, "xdp_devmap_prog");
-		if (!egress_prog) {
-			printf("finding egress_prog in obj file failed\n");
-			goto err_out;
-		}
-		egress_prog_fd = bpf_program__fd(egress_prog);
-		if (egress_prog_fd < 0) {
-			printf("find egress_prog fd failed\n");
-			goto err_out;
-		}
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
 	}
 
-	/* Remove attached program when program is interrupted or killed */
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	ingress_prog = skel->progs.xdp_redirect_map_native;
+	forward_map = skel->maps.forward_map_native;
 
-	/* Init forward multicast groups */
 	for (i = 0; ifaces[i] > 0; i++) {
 		ifindex = ifaces[i];
 
+		ret = EXIT_FAIL_XDP;
+restart:
 		/* bind prog_fd to each interface */
-		ret = bpf_set_link_xdp_fd(ifindex, ingress_prog_fd, xdp_flags);
-		if (ret) {
-			printf("Set xdp fd failed on %d\n", ifindex);
-			goto err_out;
+		if (sample_install_xdp(ingress_prog, ifindex, generic, force) < 0) {
+			if (generic && !tried) {
+				fprintf(stderr,
+					"Trying fallback to sizeof(int) as value_size for devmap in generic mode\n");
+				ingress_prog = skel->progs.xdp_redirect_map_general;
+				forward_map = skel->maps.forward_map_general;
+				tried = true;
+				goto restart;
+			}
+			goto end_destroy;
 		}
 
 		/* Add all the interfaces to forward group and attach
-		 * egress devmap programe if exist
+		 * egress devmap program if exist
 		 */
 		devmap_val.ifindex = ifindex;
-		devmap_val.bpf_prog.fd = egress_prog_fd;
-		ret = bpf_map_update_elem(forward_map_fd, &ifindex, &devmap_val, 0);
-		if (ret) {
-			perror("bpf_map_update_elem forward_map");
-			goto err_out;
+		if (xdp_devmap_attached)
+			devmap_val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_devmap_prog);
+		ret = bpf_map_update_elem(bpf_map__fd(forward_map), &ifindex, &devmap_val, 0);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to update devmap value: %s\n",
+				strerror(errno));
+			ret = EXIT_FAIL_BPF;
+			goto end_destroy;
 		}
 	}
 
-	poll_stats(2);
-
-	return 0;
-
-err_out:
-	return 1;
+	ret = sample_run(interval, NULL, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
+	}
+	ret = EXIT_OK;
+end_destroy:
+	xdp_redirect_map_multi__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0


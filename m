Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F633D93B2
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbhG1Q5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbhG1Q5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:57:07 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22D7C06179A;
        Wed, 28 Jul 2021 09:57:03 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id j1so6066750pjv.3;
        Wed, 28 Jul 2021 09:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k8X14nnFP+ryP9U3NWWRMr/x1JxV9GHXhMa2zhoQiTk=;
        b=EZaVpMYNK1emjyZIKMnFzZ9ir7prZaDMC1Y2CNbdBKTfuzMEfekdglUicdsZ0uHKOn
         LQXDRoHgGgz7P2IYZZ2Hj1nBNcUhTRcy9Le4fPrpD3g0b8kV8JdKneIiTWpwriqxh4Cv
         Xfyf9AyM/WOCWaB39Y9BzrMs57Y1xf3YPj+OF93UsXsaMg7O8UnHhYeidnlijajdhSvu
         h4i1dGjD/mb/Nu30VSEiZZtv2BcEXt6k9P2zfRlznrvwwy1FAsmoxwFMHcMsVa4uXC+V
         QD5XbsnSjPGCeNg4kTMBYKxDhMKP9eehCZUw/Opw0l/WVRogxWYpWGjPJif/2/hYdSiu
         DouQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k8X14nnFP+ryP9U3NWWRMr/x1JxV9GHXhMa2zhoQiTk=;
        b=mBnLG/fVWqvfcBLrwAgpibmPzPbX82gj4oR3buJkkI+oDa2tDuLhdW+dRLYZzhZ4Sc
         ssO5mFmn+eZlAawOmej4O9iBevmddYC9BWgCSiL09mf7QILsOpRrz/v85g6t+ED0wQXk
         UKsK7M3i8rFgLmxHXxRhe3aeetPCkqtBwxqlLrcduhpQJMC9G+jKbDlrFS7OZvb33Ey9
         XW4sYVjSux3wCS9wtyW9d/Gu2uBl9EEHA5scJ6SJoMjqNy+N13tJ2LL47QSTa5rAYf1Y
         +O9noNXcGNu5CnaPdmSBy/Y5nE0yjBXDNJsTzFTqtyRFY+nMKVuaogumoHCZKecaCJMH
         /mpw==
X-Gm-Message-State: AOAM533tTkX+FHKuBANINm3GgNh7B3EA32kRDN+hYIQby8cBe9jmGsnV
        Tf7vqsyor4gOg0yM4uJ8qqd/mHHtN+DLiQ==
X-Google-Smtp-Source: ABdhPJw1Bjwuy/uLi4obcSw5EMiHa0wMaW/lXvJM5D9XOWhF0rPl9oUEMUjn2CKz5yqI7ZgvNFriOg==
X-Received: by 2002:a17:90a:5201:: with SMTP id v1mr718502pjh.46.1627491423063;
        Wed, 28 Jul 2021 09:57:03 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id x14sm521081pfq.143.2021.07.28.09.57.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:57:02 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 6/8] samples: bpf: Convert xdp_redirect_map to use XDP samples helpers
Date:   Wed, 28 Jul 2021 22:25:50 +0530
Message-Id: <20210728165552.435050-7-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP redirect_map tool to use the XDP samples
support introduced in previous changes.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |  10 +-
 ...rect_map_kern.c => xdp_redirect_map.bpf.c} |  87 +---
 samples/bpf/xdp_redirect_map_user.c           | 380 +++++++-----------
 3 files changed, 179 insertions(+), 298 deletions(-)
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (58%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 53ddf63c94d6..53046fd37b6c 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
-tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_rxq_info
@@ -55,6 +54,7 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
 tprogs-y += xdp_monitor
 
@@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
-xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
@@ -116,6 +115,7 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
 xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
 
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_rxq_info_kern.o
@@ -312,6 +311,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
 $(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
 
@@ -356,6 +356,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
 
@@ -367,9 +368,10 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
 
diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map.bpf.c
similarity index 58%
rename from samples/bpf/xdp_redirect_map_kern.c
rename to samples/bpf/xdp_redirect_map.bpf.c
index a92b8e567bdd..ba221209cee2 100644
--- a/samples/bpf/xdp_redirect_map_kern.c
+++ b/samples/bpf/xdp_redirect_map.bpf.c
@@ -10,14 +10,10 @@
  * General Public License for more details.
  */
 #define KBUILD_MODNAME "foo"
-#include <uapi/linux/bpf.h>
-#include <linux/in.h>
-#include <linux/if_ether.h>
-#include <linux/if_packet.h>
-#include <linux/if_vlan.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <bpf/bpf_helpers.h>
+
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
 
 /* The 2nd xdp prog on egress does not support skb mode, so we define two
  * maps, tx_port_general and tx_port_native.
@@ -26,114 +22,73 @@ struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
 	__uint(value_size, sizeof(int));
-	__uint(max_entries, 100);
+	__uint(max_entries, 1);
 } tx_port_general SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_DEVMAP);
 	__uint(key_size, sizeof(int));
 	__uint(value_size, sizeof(struct bpf_devmap_val));
-	__uint(max_entries, 100);
-} tx_port_native SEC(".maps");
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, long);
 	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-/* map to store egress interface mac address */
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, u32);
-	__type(value, __be64);
-	__uint(max_entries, 1);
-} tx_mac SEC(".maps");
+} tx_port_native SEC(".maps");
 
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
+/* store egress interface mac address */
+const volatile char tx_mac_addr[ETH_ALEN];
 
 static __always_inline int xdp_redirect_map(struct xdp_md *ctx, void *redirect_map)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
-	int rc = XDP_DROP;
-	long *value;
-	u32 key = 0;
+	struct datarec *rec;
 	u64 nh_off;
-	int vport;
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
-		return rc;
+		return XDP_DROP;
 
-	/* constant virtual port */
-	vport = 0;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
 
 	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
-
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 	swap_src_dst_mac(data);
-
-	/* send packet out physical port */
-	return bpf_redirect_map(redirect_map, vport, 0);
+	return bpf_redirect_map(redirect_map, 0, 0);
 }
 
-SEC("xdp_redirect_general")
+SEC("xdp")
 int xdp_redirect_map_general(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &tx_port_general);
 }
 
-SEC("xdp_redirect_native")
+SEC("xdp")
 int xdp_redirect_map_native(struct xdp_md *ctx)
 {
 	return xdp_redirect_map(ctx, &tx_port_native);
 }
 
-SEC("xdp_devmap/map_prog")
+SEC("xdp_devmap/egress")
 int xdp_redirect_map_egress(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data = (void *)(long)ctx->data;
 	struct ethhdr *eth = data;
-	__be64 *mac;
-	u32 key = 0;
 	u64 nh_off;
 
 	nh_off = sizeof(*eth);
 	if (data + nh_off > data_end)
 		return XDP_DROP;
 
-	mac = bpf_map_lookup_elem(&tx_mac, &key);
-	if (mac)
-		__builtin_memcpy(eth->h_source, mac, ETH_ALEN);
+	__builtin_memcpy(eth->h_source, (const char *)tx_mac_addr, ETH_ALEN);
 
 	return XDP_PASS;
 }
 
 /* Redirect require an XDP bpf_prog loaded on the TX device */
-SEC("xdp_redirect_dummy")
+SEC("xdp")
 int xdp_redirect_dummy_prog(struct xdp_md *ctx)
 {
 	return XDP_PASS;
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index ad3cdc4c07d3..bab3a5abfc89 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -1,6 +1,10 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2017 Covalent IO, Inc. http://covalent.io
  */
+static const char *__doc__ =
+"XDP redirect tool, using BPF_MAP_TYPE_DEVMAP\n"
+"Usage: xdp_redirect_map <IFINDEX|IFNAME>_IN <IFINDEX|IFNAME>_OUT\n";
+
 #include <linux/bpf.h>
 #include <linux/if_link.h>
 #include <assert.h>
@@ -13,165 +17,83 @@
 #include <net/if.h>
 #include <unistd.h>
 #include <libgen.h>
-#include <sys/resource.h>
-#include <sys/ioctl.h>
-#include <sys/types.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-
-#include "bpf_util.h"
+#include <getopt.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
+#include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_redirect_map.skel.h"
 
-static int ifindex_in;
-static int ifindex_out;
-static bool ifindex_out_xdp_dummy_attached = true;
-static bool xdp_devmap_attached;
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
-
-static int get_mac_addr(unsigned int ifindex_out, void *mac_addr)
-{
-	char ifname[IF_NAMESIZE];
-	struct ifreq ifr;
-	int fd, ret = -1;
-
-	fd = socket(AF_INET, SOCK_DGRAM, 0);
-	if (fd < 0)
-		return ret;
-
-	if (!if_indextoname(ifindex_out, ifname))
-		goto err_out;
-
-	strcpy(ifr.ifr_name, ifname);
-
-	if (ioctl(fd, SIOCGIFHWADDR, &ifr) != 0)
-		goto err_out;
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 
-	memcpy(mac_addr, ifr.ifr_hwaddr.sa_data, 6 * sizeof(char));
-	ret = 0;
+DEFINE_SAMPLE_INIT(xdp_redirect_map);
 
-err_out:
-	close(fd);
-	return ret;
-}
-
-static void usage(const char *prog)
-{
-	fprintf(stderr,
-		"usage: %s [OPTS] <IFNAME|IFINDEX>_IN <IFNAME|IFINDEX>_OUT\n\n"
-		"OPTS:\n"
-		"    -S    use skb-mode\n"
-		"    -N    enforce native mode\n"
-		"    -F    force loading prog\n"
-		"    -X    load xdp program on egress\n",
-		prog);
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
 
 int main(int argc, char **argv)
 {
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_UNSPEC,
-	};
-	struct bpf_program *prog, *dummy_prog, *devmap_prog;
-	int prog_fd, dummy_prog_fd, devmap_prog_fd = 0;
-	int tx_port_map_fd, tx_mac_map_fd;
-	struct bpf_devmap_val devmap_val;
-	struct bpf_prog_info info = {};
-	__u32 info_len = sizeof(info);
-	const char *optstr = "FSNX";
-	struct bpf_object *obj;
-	int ret, opt, key = 0;
-	char filename[256];
-
-	while ((opt = getopt(argc, argv, optstr)) != -1) {
+	struct bpf_devmap_val devmap_val = {};
+	bool xdp_devmap_attached = false;
+	struct xdp_redirect_map *skel;
+	char str[2 * IF_NAMESIZE + 1];
+	char ifname_out[IF_NAMESIZE];
+	struct bpf_map *tx_port_map;
+	char ifname_in[IF_NAMESIZE];
+	int ifindex_in, ifindex_out;
+	unsigned long interval = 2;
+	int ret = EXIT_FAIL_OPTION;
+	struct bpf_program *prog;
+	bool generic = false;
+	bool force = false;
+	bool tried = false;
+	bool error = true;
+	int opt, key = 0;
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
 			xdp_devmap_attached = true;
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
-	} else if (xdp_devmap_attached) {
-		printf("Load xdp program on egress with SKB mode not supported yet\n");
-		return 1;
-	}
-
 	if (argc <= optind + 1) {
-		usage(basename(argv[0]));
-		return 1;
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
 	}
 
 	ifindex_in = if_nametoindex(argv[optind]);
@@ -182,107 +104,109 @@ int main(int argc, char **argv)
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
-	if (xdp_flags & XDP_FLAGS_SKB_MODE) {
-		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_general");
-		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_general");
-	} else {
-		prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_native");
-		tx_port_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_port_native");
-	}
-	dummy_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_dummy_prog");
-	if (!prog || dummy_prog < 0 || tx_port_map_fd < 0) {
-		printf("finding prog/dummy_prog/tx_port_map in obj file failed\n");
-		goto out;
-	}
-	prog_fd = bpf_program__fd(prog);
-	dummy_prog_fd = bpf_program__fd(dummy_prog);
-	if (prog_fd < 0 || dummy_prog_fd < 0 || tx_port_map_fd < 0) {
-		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
-		return 1;
-	}
-
-	tx_mac_map_fd = bpf_object__find_map_fd_by_name(obj, "tx_mac");
-	rxcnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rxcnt");
-	if (tx_mac_map_fd < 0 || rxcnt_map_fd < 0) {
-		printf("bpf_object__find_map_fd_by_name failed\n");
-		return 1;
-	}
-
-	if (bpf_set_link_xdp_fd(ifindex_in, prog_fd, xdp_flags) < 0) {
-		printf("ERROR: link set xdp fd failed on %d\n", ifindex_in);
-		return 1;
-	}
-
-	ret = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (ret) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		return ret;
-	}
-	prog_id = info.id;
-
-	/* Loading dummy XDP prog on out-device */
-	if (bpf_set_link_xdp_fd(ifindex_out, dummy_prog_fd,
-			    (xdp_flags | XDP_FLAGS_UPDATE_IF_NOEXIST)) < 0) {
-		printf("WARN: link set xdp fd failed on %d\n", ifindex_out);
-		ifindex_out_xdp_dummy_attached = false;
+	if (!ifindex_in || !ifindex_out) {
+		fprintf(stderr, "Bad interface index or name\n");
+		sample_usage(argv, long_options, __doc__, mask, true);
+		goto end;
 	}
 
-	memset(&info, 0, sizeof(info));
-	ret = bpf_obj_get_info_by_fd(dummy_prog_fd, &info, &info_len);
-	if (ret) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		return ret;
+	skel = xdp_redirect_map__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect_map__open: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
-	dummy_prog_id = info.id;
 
 	/* Load 2nd xdp prog on egress. */
 	if (xdp_devmap_attached) {
-		unsigned char mac_addr[6];
-
-		devmap_prog = bpf_object__find_program_by_name(obj, "xdp_redirect_map_egress");
-		if (!devmap_prog) {
-			printf("finding devmap_prog in obj file failed\n");
-			goto out;
-		}
-		devmap_prog_fd = bpf_program__fd(devmap_prog);
-		if (devmap_prog_fd < 0) {
-			printf("finding devmap_prog fd failed\n");
-			goto out;
-		}
-
-		if (get_mac_addr(ifindex_out, mac_addr) < 0) {
-			printf("get interface %d mac failed\n", ifindex_out);
-			goto out;
+		ret = get_mac_addr(ifindex_out, skel->rodata->tx_mac_addr);
+		if (ret < 0) {
+			fprintf(stderr, "Failed to get interface %d mac address: %s\n",
+				ifindex_out, strerror(-ret));
+			ret = EXIT_FAIL;
+			goto end_destroy;
 		}
+	}
 
-		ret = bpf_map_update_elem(tx_mac_map_fd, &key, mac_addr, 0);
-		if (ret) {
-			perror("bpf_update_elem tx_mac_map_fd");
-			goto out;
+	skel->rodata->from_match[0] = ifindex_in;
+	skel->rodata->to_match[0] = ifindex_out;
+
+	ret = xdp_redirect_map__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to xdp_redirect_map__load: %s\n",
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
+	prog = skel->progs.xdp_redirect_map_native;
+	tx_port_map = skel->maps.tx_port_native;
+restart:
+	if (sample_install_xdp(prog, ifindex_in, generic, force) < 0) {
+		/* First try with struct bpf_devmap_val as value for generic
+		 * mode, then fallback to sizeof(int) for older kernels.
+		 */
+		fprintf(stderr,
+			"Trying fallback to sizeof(int) as value_size for devmap in generic mode\n");
+		if (generic && !tried) {
+			prog = skel->progs.xdp_redirect_map_general;
+			tx_port_map = skel->maps.tx_port_general;
+			tried = true;
+			goto restart;
 		}
+		ret = EXIT_FAIL_XDP;
+		goto end_destroy;
 	}
 
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	/* Loading dummy XDP prog on out-device */
+	sample_install_xdp(skel->progs.xdp_redirect_dummy_prog, ifindex_out, generic, force);
 
 	devmap_val.ifindex = ifindex_out;
-	devmap_val.bpf_prog.fd = devmap_prog_fd;
-	ret = bpf_map_update_elem(tx_port_map_fd, &key, &devmap_val, 0);
-	if (ret) {
-		perror("bpf_update_elem");
-		goto out;
-	}
-
-	poll_stats(2, ifindex_out);
-
-out:
-	return 0;
+	if (xdp_devmap_attached)
+		devmap_val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_redirect_map_egress);
+	ret = bpf_map_update_elem(bpf_map__fd(tx_port_map), &key, &devmap_val, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to update devmap value: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
+	}
+
+	ret = EXIT_FAIL;
+	if (!if_indextoname(ifindex_in, ifname_in)) {
+		fprintf(stderr, "Failed to if_indextoname for %d: %s\n", ifindex_in,
+			strerror(errno));
+		goto end_destroy;
+	}
+
+	if (!if_indextoname(ifindex_out, ifname_out)) {
+		fprintf(stderr, "Failed to if_indextoname for %d: %s\n", ifindex_out,
+			strerror(errno));
+		goto end_destroy;
+	}
+
+	safe_strncpy(str, get_driver_name(ifindex_in), sizeof(str));
+	printf("Redirecting from %s (ifindex %d; driver %s) to %s (ifindex %d; driver %s)\n",
+	       ifname_in, ifindex_in, str, ifname_out, ifindex_out, get_driver_name(ifindex_out));
+	snprintf(str, sizeof(str), "%s->%s", ifname_in, ifname_out);
+
+	ret = sample_run(interval, NULL, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
+	}
+	ret = EXIT_OK;
+end_destroy:
+	xdp_redirect_map__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0


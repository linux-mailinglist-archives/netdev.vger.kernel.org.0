Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5973D93B7
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbhG1Q50 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbhG1Q5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:57:12 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E0AC061757;
        Wed, 28 Jul 2021 09:57:10 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so10957467pja.5;
        Wed, 28 Jul 2021 09:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ijQPyiWjKy/C6eASq7fZTB1Dg6v27Q3yM5abckLfiwU=;
        b=cFhApCLOY73kwOV5gUHQLDs368hNqoLg5WdhIqO5nC6AArnPkZmXiaK8GPC8NbgopG
         khNSQ9icsqC2UmE/kPbyqBxmmQrUh1k5dOfAuL/bZChrCmaVe6z7LCe56Ljok1qpkvGQ
         pcvLfzZtD/ePCHJl2L8HVNdAkIXH8QCwwUFJBWjBUN/apTAlZnqIXLz2EPBJLT5YqIRM
         WqHbFMb30Cu9T6G8CCGOwfQr71xXhX5VdfMtVoEqpBurSqw6ELV5Hs1FC1TUT72Swz12
         ca+kIZODgYrf7LI7FYQZj+Ehokiwf8XNa5Dv1eCiUkDTBB3gLBk9j9QfkznPBFTEaK4h
         C9JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijQPyiWjKy/C6eASq7fZTB1Dg6v27Q3yM5abckLfiwU=;
        b=F0o47S+pCsW6fGmfqDlyhgIxZaez6ljaIiHegO4j2+goEoowh5374ZxxjG5eFXr7j9
         15kkm1SsCVDeug8GVnVmNpVzv8unTJNxWor4LTpiMWkjHycFTpYhMRocB/q7ZneCGvG3
         5dDVBkpbO1VG6jGrqoegLEqGwWTTEnVL/bRUxxwGoKdUwyofD6HEeHR3G4blrww0ELBY
         Bw4R98q8UxoxAAqHXJXBNncg+JuPXG0dgy9LyxMdZ7Zee8ph4LOSK3Ipy+JBG1l6Q0uh
         X2r6xn4jQWAPrH7AjPmhpfpfrPZriBIZmUck0iC0fQo4onGrkALP0OZxUEEMrp4sVvvu
         qf3w==
X-Gm-Message-State: AOAM531GEg/fj+pKG+PgfVNvkp6qWxX8UPm4nDRIajkAY+DsbAPLKtp6
        WPwEVZ2Mbg1sJK1AjxGNYUdVotAbNWq57g==
X-Google-Smtp-Source: ABdhPJwSceAyYyNrcT9dSuOCyfXYk1jEDtYgQj3CxkvT4d+De1DhpdPeceG4uB9QxKmXIxkWsRdmMQ==
X-Received: by 2002:a63:c058:: with SMTP id z24mr732980pgi.220.1627491429550;
        Wed, 28 Jul 2021 09:57:09 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id h30sm502151pfr.191.2021.07.28.09.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:57:09 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 8/8] samples: bpf: Convert xdp_redirect_cpu to use XDP samples helpers
Date:   Wed, 28 Jul 2021 22:25:52 +0530
Message-Id: <20210728165552.435050-9-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP redirect_cpu tool to use the XDP samples
support introduced in previous changes.

One of the notable changes is removal of options to specify a separate
eBPF program that supplies a redirection program that is attached to the
CPUMAP, so that the packet can be redirected to a device after
redirecting it to a CPU. This is replaced by a program built into the
BPF object file and now the user only needs to specify the out interface
to do the same.

The program also uses devmap to redirect XDP frames, instead of directly
redirecting with bpf_redirect, for performance reasons.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |  12 +-
 ...rect_cpu_kern.c => xdp_redirect_cpu.bpf.c} | 407 ++-----
 samples/bpf/xdp_redirect_cpu_user.c           | 992 ++++--------------
 3 files changed, 322 insertions(+), 1089 deletions(-)
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index e51e1105d0c7..ec9bb57ea77b 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -39,7 +39,6 @@ tprogs-y += lwt_len_hist
 tprogs-y += xdp_tx_iptunnel
 tprogs-y += test_map_in_map
 tprogs-y += per_socket_stats_example
-tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_rxq_info
 tprogs-y += syscall_tp
 tprogs-y += cpustat
@@ -53,6 +52,7 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_redirect_cpu
 tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect
@@ -100,7 +100,6 @@ lwt_len_hist-objs := lwt_len_hist_user.o
 xdp_tx_iptunnel-objs := xdp_tx_iptunnel_user.o
 test_map_in_map-objs := test_map_in_map_user.o
 per_socket_stats_example-objs := cookie_uid_helper_example.o
-xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
@@ -114,6 +113,7 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o $(XDP_SAMPLE)
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o $(XDP_SAMPLE)
 xdp_redirect_map-objs := xdp_redirect_map_user.o $(XDP_SAMPLE)
 xdp_redirect-objs := xdp_redirect_user.o $(XDP_SAMPLE)
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -310,6 +309,7 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_redirect_cpu_user.o: $(obj)/xdp_redirect_cpu.skel.h
 $(obj)/xdp_redirect_map_multi_user.o: $(obj)/xdp_redirect_map_multi.skel.h
 $(obj)/xdp_redirect_map_user.o: $(obj)/xdp_redirect_map.skel.h
 $(obj)/xdp_redirect_user.o: $(obj)/xdp_redirect.skel.h
@@ -356,6 +356,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect_cpu.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map_multi.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
@@ -369,10 +370,11 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect_map_multi.skel.h xdp_redirect_map.skel.h \
-		xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map_multi.skel.h \
+		xdp_redirect_map.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
 xdp_redirect_map_multi.skel.h-deps := xdp_redirect_map_multi.bpf.o xdp_sample.bpf.o
 xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu.bpf.c
similarity index 52%
rename from samples/bpf/xdp_redirect_cpu_kern.c
rename to samples/bpf/xdp_redirect_cpu.bpf.c
index 8255025dea97..fd09842b027a 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -2,21 +2,11 @@
  *
  *  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
  */
-#include <uapi/linux/if_ether.h>
-#include <uapi/linux/if_packet.h>
-#include <uapi/linux/if_vlan.h>
-#include <uapi/linux/ip.h>
-#include <uapi/linux/ipv6.h>
-#include <uapi/linux/in.h>
-#include <uapi/linux/tcp.h>
-#include <uapi/linux/udp.h>
-
-#include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
+#include "vmlinux.h"
+#include "xdp_sample.bpf.h"
+#include "xdp_sample_shared.h"
 #include "hash_func01.h"
 
-#define MAX_CPUS NR_CPUS
-
 /* Special map type that can XDP_REDIRECT frames to another CPU */
 struct {
 	__uint(type, BPF_MAP_TYPE_CPUMAP);
@@ -25,51 +15,6 @@ struct {
 	__uint(max_entries, MAX_CPUS);
 } cpu_map SEC(".maps");
 
-/* Common stats data record to keep userspace more simple */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-
-/* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
- * feedback.  Redirect TX errors can be caught via a tracepoint.
- */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} rx_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
-} redirect_err_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, MAX_CPUS);
-} cpumap_enqueue_cnt SEC(".maps");
-
-/* Used by trace point */
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} cpumap_kthread_cnt SEC(".maps");
-
 /* Set of maps controlling available CPU, and for iterating through
  * selectable redirect CPUs.
  */
@@ -79,12 +24,14 @@ struct {
 	__type(value, u32);
 	__uint(max_entries, MAX_CPUS);
 } cpus_available SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__type(key, u32);
 	__type(value, u32);
 	__uint(max_entries, 1);
 } cpus_count SEC(".maps");
+
 struct {
 	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
 	__type(key, u32);
@@ -92,24 +39,16 @@ struct {
 	__uint(max_entries, 1);
 } cpus_iterator SEC(".maps");
 
-/* Used by trace point */
 struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
+	__uint(type, BPF_MAP_TYPE_DEVMAP);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(struct bpf_devmap_val));
 	__uint(max_entries, 1);
-} exception_cnt SEC(".maps");
+} tx_port SEC(".maps");
 
-/* Helper parse functions */
+char tx_mac_addr[ETH_ALEN];
 
-/* Parse Ethernet layer 2, extract network layer 3 offset and protocol
- *
- * Returns false on error and non-supported ether-type
- */
-struct vlan_hdr {
-	__be16 h_vlan_TCI;
-	__be16 h_vlan_encapsulated_proto;
-};
+/* Helper parse functions */
 
 static __always_inline
 bool parse_eth(struct ethhdr *eth, void *data_end,
@@ -125,11 +64,12 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 	eth_type = eth->h_proto;
 
 	/* Skip non 802.3 Ethertypes */
-	if (unlikely(ntohs(eth_type) < ETH_P_802_3_MIN))
+	if (__builtin_expect(bpf_ntohs(eth_type) < ETH_P_802_3_MIN, 0))
 		return false;
 
 	/* Handle VLAN tagged packet */
-	if (eth_type == htons(ETH_P_8021Q) || eth_type == htons(ETH_P_8021AD)) {
+	if (eth_type == bpf_htons(ETH_P_8021Q) ||
+	    eth_type == bpf_htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vlan_hdr;
 
 		vlan_hdr = (void *)eth + offset;
@@ -139,7 +79,8 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
 	}
 	/* Handle double VLAN tagged packet */
-	if (eth_type == htons(ETH_P_8021Q) || eth_type == htons(ETH_P_8021AD)) {
+	if (eth_type == bpf_htons(ETH_P_8021Q) ||
+	    eth_type == bpf_htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vlan_hdr;
 
 		vlan_hdr = (void *)eth + offset;
@@ -149,7 +90,7 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
 	}
 
-	*eth_proto = ntohs(eth_type);
+	*eth_proto = bpf_ntohs(eth_type);
 	*l3_offset = offset;
 	return true;
 }
@@ -172,7 +113,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	if (udph + 1 > data_end)
 		return 0;
 
-	dport = ntohs(udph->dest);
+	dport = bpf_ntohs(udph->dest);
 	return dport;
 }
 
@@ -200,50 +141,49 @@ int get_proto_ipv6(struct xdp_md *ctx, u64 nh_off)
 	return ip6h->nexthdr;
 }
 
-SEC("xdp_cpu_map0")
+SEC("xdp")
 int  xdp_prognum0_no_touch(struct xdp_md *ctx)
 {
-	void *data_end = (void *)(long)ctx->data_end;
-	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct datarec *rec;
 	u32 *cpu_selected;
-	u32 cpu_dest;
-	u32 key = 0;
+	u32 cpu_dest = 0;
+	u32 key0 = 0;
 
 	/* Only use first entry in cpus_available */
-	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key);
+	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key0);
 	if (!cpu_selected)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_selected;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
-SEC("xdp_cpu_map1_touch_data")
+SEC("xdp")
 int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	struct datarec *rec;
 	u32 *cpu_selected;
-	u32 cpu_dest;
+	u32 cpu_dest = 0;
+	u32 key0 = 0;
 	u16 eth_type;
-	u32 key = 0;
 
 	/* Only use first entry in cpus_available */
-	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key);
+	cpu_selected = bpf_map_lookup_elem(&cpus_available, &key0);
 	if (!cpu_selected)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_selected;
@@ -252,36 +192,34 @@ int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 	if (eth + 1 > data_end)
 		return XDP_ABORTED;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
 	/* Read packet data, and use it (drop non 802.3 Ethertypes) */
 	eth_type = eth->h_proto;
-	if (ntohs(eth_type) < ETH_P_802_3_MIN) {
-		rec->dropped++;
+	if (bpf_ntohs(eth_type) < ETH_P_802_3_MIN) {
+		NO_TEAR_INC(rec->dropped);
 		return XDP_DROP;
 	}
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
-SEC("xdp_cpu_map2_round_robin")
+SEC("xdp")
 int  xdp_prognum2_round_robin(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data     = (void *)(long)ctx->data;
-	struct ethhdr *eth = data;
+	u32 key = bpf_get_smp_processor_id();
 	struct datarec *rec;
-	u32 cpu_dest;
-	u32 *cpu_lookup;
+	u32 cpu_dest = 0;
 	u32 key0 = 0;
 
 	u32 *cpu_selected;
@@ -307,40 +245,39 @@ int  xdp_prognum2_round_robin(struct xdp_md *ctx)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_selected;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key0);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
-SEC("xdp_cpu_map3_proto_separate")
+SEC("xdp")
 int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	u8 ip_proto = IPPROTO_UDP;
 	struct datarec *rec;
 	u16 eth_proto = 0;
 	u64 l3_offset = 0;
 	u32 cpu_dest = 0;
-	u32 cpu_idx = 0;
 	u32 *cpu_lookup;
-	u32 key = 0;
+	u32 cpu_idx = 0;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
 	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
 		return XDP_PASS; /* Just skip */
@@ -382,34 +319,33 @@ int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
 	cpu_dest = *cpu_lookup;
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
-SEC("xdp_cpu_map4_ddos_filter_pktgen")
+SEC("xdp")
 int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
 	u8 ip_proto = IPPROTO_UDP;
 	struct datarec *rec;
 	u16 eth_proto = 0;
 	u64 l3_offset = 0;
 	u32 cpu_dest = 0;
+	u32 *cpu_lookup;
 	u32 cpu_idx = 0;
 	u16 dest_port;
-	u32 *cpu_lookup;
-	u32 key = 0;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
 	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
 		return XDP_PASS; /* Just skip */
@@ -443,8 +379,7 @@ int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 		/* DDoS filter UDP port 9 (pktgen) */
 		dest_port = get_dest_port_ipv4_udp(ctx, l3_offset);
 		if (dest_port == 9) {
-			if (rec)
-				rec->dropped++;
+			NO_TEAR_INC(rec->dropped);
 			return XDP_DROP;
 		}
 		break;
@@ -458,10 +393,9 @@ int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 	cpu_dest = *cpu_lookup;
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
@@ -496,10 +430,10 @@ u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
 	if (ip6h + 1 > data_end)
 		return 0;
 
-	cpu_hash  = ip6h->saddr.s6_addr32[0] + ip6h->daddr.s6_addr32[0];
-	cpu_hash += ip6h->saddr.s6_addr32[1] + ip6h->daddr.s6_addr32[1];
-	cpu_hash += ip6h->saddr.s6_addr32[2] + ip6h->daddr.s6_addr32[2];
-	cpu_hash += ip6h->saddr.s6_addr32[3] + ip6h->daddr.s6_addr32[3];
+	cpu_hash  = ip6h->saddr.in6_u.u6_addr32[0] + ip6h->daddr.in6_u.u6_addr32[0];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[1] + ip6h->daddr.in6_u.u6_addr32[1];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[2] + ip6h->daddr.in6_u.u6_addr32[2];
+	cpu_hash += ip6h->saddr.in6_u.u6_addr32[3] + ip6h->daddr.in6_u.u6_addr32[3];
 	cpu_hash = SuperFastHash((char *)&cpu_hash, 4, INITVAL + ip6h->nexthdr);
 
 	return cpu_hash;
@@ -509,30 +443,30 @@ u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
  * hashing scheme is symmetric, meaning swapping IP src/dest still hit
  * same CPU.
  */
-SEC("xdp_cpu_map5_lb_hash_ip_pairs")
+SEC("xdp")
 int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 {
 	void *data_end = (void *)(long)ctx->data_end;
 	void *data     = (void *)(long)ctx->data;
+	u32 key = bpf_get_smp_processor_id();
 	struct ethhdr *eth = data;
-	u8 ip_proto = IPPROTO_UDP;
 	struct datarec *rec;
 	u16 eth_proto = 0;
 	u64 l3_offset = 0;
 	u32 cpu_dest = 0;
 	u32 cpu_idx = 0;
 	u32 *cpu_lookup;
+	u32 key0 = 0;
 	u32 *cpu_max;
 	u32 cpu_hash;
-	u32 key = 0;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key);
-	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+	if (key >= ELEMENTS_OF(sample_data.rx_cnt))
+		return XDP_PASS;
+
+	rec = &sample_data.rx_cnt[key];
+	NO_TEAR_INC(rec->processed);
 
-	cpu_max = bpf_map_lookup_elem(&cpus_count, &key);
+	cpu_max = bpf_map_lookup_elem(&cpus_count, &key0);
 	if (!cpu_max)
 		return XDP_ABORTED;
 
@@ -561,170 +495,43 @@ int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 	cpu_dest = *cpu_lookup;
 
 	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
-char _license[] SEC("license") = "GPL";
-
-/*** Trace point code ***/
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_redirect_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12  size:4; signed:0;
-	int ifindex;	//	offset:16  size:4; signed:1;
-	int err;	//	offset:20  size:4; signed:1;
-	int to_ifindex;	//	offset:24  size:4; signed:1;
-	u32 map_id;	//	offset:28  size:4; signed:0;
-	int map_index;	//	offset:32  size:4; signed:1;
-};			//	offset:36
-
-enum {
-	XDP_REDIRECT_SUCCESS = 0,
-	XDP_REDIRECT_ERROR = 1
-};
-
-static __always_inline
-int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
+SEC("xdp_cpumap/devmap")
+int xdp_redirect_cpu_devmap(struct xdp_md *ctx)
 {
-	u32 key = XDP_REDIRECT_ERROR;
-	struct datarec *rec;
-	int err = ctx->err;
-
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
-
-	rec = bpf_map_lookup_elem(&redirect_err_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->dropped += 1;
-
-	return 0; /* Indicate event was filtered (no further processing)*/
-	/*
-	 * Returning 1 here would allow e.g. a perf-record tracepoint
-	 * to see and record these events, but it doesn't work well
-	 * in-practice as stopping perf-record also unload this
-	 * bpf_prog.  Plus, there is additional overhead of doing so.
-	 */
-}
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u64 nh_off;
 
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
 
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
+	swap_src_dst_mac(data);
+	return bpf_redirect_map(&tx_port, 0, 0);
 }
 
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_exception/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_exception_ctx {
-	u64 __pad;	// First 8 bytes are not accessible by bpf code
-	int prog_id;	//	offset:8;  size:4; signed:1;
-	u32 act;	//	offset:12; size:4; signed:0;
-	int ifindex;	//	offset:16; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_exception")
-int trace_xdp_exception(struct xdp_exception_ctx *ctx)
+SEC("xdp_devmap/egress")
+int xdp_redirect_egress_prog(struct xdp_md *ctx)
 {
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&exception_cnt, &key);
-	if (!rec)
-		return 1;
-	rec->dropped += 1;
-
-	return 0;
-}
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u64 nh_off;
 
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_enqueue_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int to_cpu;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_enqueue")
-int trace_xdp_cpumap_enqueue(struct cpumap_enqueue_ctx *ctx)
-{
-	u32 to_cpu = ctx->to_cpu;
-	struct datarec *rec;
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
 
-	if (to_cpu >= MAX_CPUS)
-		return 1;
+	__builtin_memcpy(eth->h_source, (const char *)tx_mac_addr, ETH_ALEN);
 
-	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	if (ctx->processed > 0)
-		rec->issue += 1;
-
-	/* Inception: It's possible to detect overload situations, via
-	 * this tracepoint.  This can be used for creating a feedback
-	 * loop to XDP, which can take appropriate actions to mitigate
-	 * this overload situation.
-	 */
-	return 0;
+	return XDP_PASS;
 }
 
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_kthread_ctx {
-	u64 __pad;			// First 8 bytes are not accessible
-	int map_id;			//	offset:8;  size:4; signed:1;
-	u32 act;			//	offset:12; size:4; signed:0;
-	int cpu;			//	offset:16; size:4; signed:1;
-	unsigned int drops;		//	offset:20; size:4; signed:0;
-	unsigned int processed;		//	offset:24; size:4; signed:0;
-	int sched;			//	offset:28; size:4; signed:1;
-	unsigned int xdp_pass;		//	offset:32; size:4; signed:0;
-	unsigned int xdp_drop;		//	offset:36; size:4; signed:0;
-	unsigned int xdp_redirect;	//	offset:40; size:4; signed:0;
-};
-
-SEC("tracepoint/xdp/xdp_cpumap_kthread")
-int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&cpumap_kthread_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-	rec->xdp_pass  += ctx->xdp_pass;
-	rec->xdp_drop  += ctx->xdp_drop;
-	rec->xdp_redirect  += ctx->xdp_redirect;
-
-	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
-		rec->issue++;
-
-	return 0;
-}
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index d3ecdc18b9c1..3b5cead4eb65 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -2,7 +2,8 @@
 /* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
  */
 static const char *__doc__ =
-	" XDP redirect with a CPU-map type \"BPF_MAP_TYPE_CPUMAP\"";
+"XDP CPU redirect tool, using BPF_MAP_TYPE_CPUMAP\n"
+"Usage: xdp_redirect_cpu -d <IFINDEX|IFNAME> -c 0 ... -c N\n";
 
 #include <errno.h>
 #include <signal.h>
@@ -18,558 +19,59 @@ static const char *__doc__ =
 #include <net/if.h>
 #include <time.h>
 #include <linux/limits.h>
-
 #include <arpa/inet.h>
 #include <linux/if_link.h>
-
-/* How many xdp_progs are defined in _kern.c */
-#define MAX_PROG 6
-
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
-
 #include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_redirect_cpu.skel.h"
 
-static int ifindex = -1;
-static char ifname_buf[IF_NAMESIZE];
-static char *ifname;
-static __u32 prog_id;
-
-static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-static int n_cpus;
-
-enum map_type {
-	CPU_MAP,
-	RX_CNT,
-	REDIRECT_ERR_CNT,
-	CPUMAP_ENQUEUE_CNT,
-	CPUMAP_KTHREAD_CNT,
-	CPUS_AVAILABLE,
-	CPUS_COUNT,
-	CPUS_ITERATOR,
-	EXCEPTION_CNT,
-};
+static int map_fd;
+static int avail_fd;
+static int count_fd;
 
-static const char *const map_type_strings[] = {
-	[CPU_MAP] = "cpu_map",
-	[RX_CNT] = "rx_cnt",
-	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
-	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
-	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
-	[CPUS_AVAILABLE] = "cpus_available",
-	[CPUS_COUNT] = "cpus_count",
-	[CPUS_ITERATOR] = "cpus_iterator",
-	[EXCEPTION_CNT] = "exception_cnt",
-};
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_CPUMAP_ENQUEUE_CNT | SAMPLE_CPUMAP_KTHREAD_CNT |
+		  SAMPLE_EXCEPTION_CNT;
 
-#define NUM_TP 5
-#define NUM_MAP 9
-struct bpf_link *tp_links[NUM_TP] = {};
-static int map_fds[NUM_MAP];
-static int tp_cnt = 0;
-
-/* Exit return codes */
-#define EXIT_OK		0
-#define EXIT_FAIL		1
-#define EXIT_FAIL_OPTION	2
-#define EXIT_FAIL_XDP		3
-#define EXIT_FAIL_BPF		4
-#define EXIT_FAIL_MEM		5
+DEFINE_SAMPLE_INIT(xdp_redirect_cpu);
 
 static const struct option long_options[] = {
-	{"help",	no_argument,		NULL, 'h' },
-	{"dev",		required_argument,	NULL, 'd' },
-	{"skb-mode",	no_argument,		NULL, 'S' },
-	{"sec",		required_argument,	NULL, 's' },
-	{"progname",	required_argument,	NULL, 'p' },
-	{"qsize",	required_argument,	NULL, 'q' },
-	{"cpu",		required_argument,	NULL, 'c' },
-	{"stress-mode", no_argument,		NULL, 'x' },
-	{"no-separators", no_argument,		NULL, 'z' },
-	{"force",	no_argument,		NULL, 'F' },
-	{"mprog-disable", no_argument,		NULL, 'n' },
-	{"mprog-name",	required_argument,	NULL, 'e' },
-	{"mprog-filename", required_argument,	NULL, 'f' },
-	{"redirect-device", required_argument,	NULL, 'r' },
-	{"redirect-map", required_argument,	NULL, 'm' },
-	{0, 0, NULL,  0 }
+	{ "help", no_argument, NULL, 'h' },
+	{ "dev", required_argument, NULL, 'd' },
+	{ "skb-mode", no_argument, NULL, 'S' },
+	{ "progname", required_argument, NULL, 'p' },
+	{ "qsize", required_argument, NULL, 'q' },
+	{ "cpu", required_argument, NULL, 'c' },
+	{ "stress-mode", no_argument, NULL, 'x' },
+	{ "force", no_argument, NULL, 'F' },
+	{ "redirect-device", required_argument, NULL, 'r' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{ "stats", no_argument, NULL, 's' },
+	{}
 };
 
-static void int_exit(int sig)
-{
-	__u32 curr_prog_id = 0;
-
-	if (ifindex > -1) {
-		if (bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags)) {
-			printf("bpf_get_link_xdp_id failed\n");
-			exit(EXIT_FAIL);
-		}
-		if (prog_id == curr_prog_id) {
-			fprintf(stderr,
-				"Interrupted: Removing XDP program on ifindex:%d device:%s\n",
-				ifindex, ifname);
-			bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
-		} else if (!curr_prog_id) {
-			printf("couldn't find a prog id on a given iface\n");
-		} else {
-			printf("program on interface changed, not removing\n");
-		}
-	}
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
-	exit(EXIT_OK);
-}
-
 static void print_avail_progs(struct bpf_object *obj)
 {
 	struct bpf_program *pos;
 
+	printf(" Programs to be used for -p/--progname:\n");
 	bpf_object__for_each_program(pos, obj) {
-		if (bpf_program__is_xdp(pos))
-			printf(" %s\n", bpf_program__section_name(pos));
-	}
-}
-
-static void usage(char *argv[], struct bpf_object *obj)
-{
-	int i;
-
-	printf("\nDOCUMENTATION:\n%s\n", __doc__);
-	printf("\n");
-	printf(" Usage: %s (options-see-below)\n", argv[0]);
-	printf(" Listing options:\n");
-	for (i = 0; long_options[i].name != 0; i++) {
-		printf(" --%-12s", long_options[i].name);
-		if (long_options[i].flag != NULL)
-			printf(" flag (internal value:%d)",
-				*long_options[i].flag);
-		else
-			printf(" short-option: -%c",
-				long_options[i].val);
-		printf("\n");
-	}
-	printf("\n Programs to be used for --progname:\n");
-	print_avail_progs(obj);
-	printf("\n");
-}
-
-/* gettime returns the current time of day in nanoseconds.
- * Cost: clock_gettime (ns) => 26ns (CLOCK_MONOTONIC)
- *       clock_gettime (ns) =>  9ns (CLOCK_MONOTONIC_COARSE)
- */
-#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
-static __u64 gettime(void)
-{
-	struct timespec t;
-	int res;
-
-	res = clock_gettime(CLOCK_MONOTONIC, &t);
-	if (res < 0) {
-		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAIL);
-	}
-	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
-}
-
-/* Common stats data record shared with _kern.c */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 issue;
-	__u64 xdp_pass;
-	__u64 xdp_drop;
-	__u64 xdp_redirect;
-};
-struct record {
-	__u64 timestamp;
-	struct datarec total;
-	struct datarec *cpu;
-};
-struct stats_record {
-	struct record rx_cnt;
-	struct record redir_err;
-	struct record kthread;
-	struct record exception;
-	struct record enq[];
-};
-
-static bool map_collect_percpu(int fd, __u32 key, struct record *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec values[nr_cpus];
-	__u64 sum_xdp_redirect = 0;
-	__u64 sum_xdp_pass = 0;
-	__u64 sum_xdp_drop = 0;
-	__u64 sum_processed = 0;
-	__u64 sum_dropped = 0;
-	__u64 sum_issue = 0;
-	int i;
-
-	if ((bpf_map_lookup_elem(fd, &key, values)) != 0) {
-		fprintf(stderr,
-			"ERR: bpf_map_lookup_elem failed key:0x%X\n", key);
-		return false;
-	}
-	/* Get time as close as possible to reading map contents */
-	rec->timestamp = gettime();
-
-	/* Record and sum values from each CPU */
-	for (i = 0; i < nr_cpus; i++) {
-		rec->cpu[i].processed = values[i].processed;
-		sum_processed        += values[i].processed;
-		rec->cpu[i].dropped = values[i].dropped;
-		sum_dropped        += values[i].dropped;
-		rec->cpu[i].issue = values[i].issue;
-		sum_issue        += values[i].issue;
-		rec->cpu[i].xdp_pass = values[i].xdp_pass;
-		sum_xdp_pass += values[i].xdp_pass;
-		rec->cpu[i].xdp_drop = values[i].xdp_drop;
-		sum_xdp_drop += values[i].xdp_drop;
-		rec->cpu[i].xdp_redirect = values[i].xdp_redirect;
-		sum_xdp_redirect += values[i].xdp_redirect;
-	}
-	rec->total.processed = sum_processed;
-	rec->total.dropped   = sum_dropped;
-	rec->total.issue     = sum_issue;
-	rec->total.xdp_pass  = sum_xdp_pass;
-	rec->total.xdp_drop  = sum_xdp_drop;
-	rec->total.xdp_redirect = sum_xdp_redirect;
-	return true;
-}
-
-static struct datarec *alloc_record_per_cpu(void)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec *array;
-
-	array = calloc(nr_cpus, sizeof(struct datarec));
-	if (!array) {
-		fprintf(stderr, "Mem alloc error (nr_cpus:%u)\n", nr_cpus);
-		exit(EXIT_FAIL_MEM);
-	}
-	return array;
-}
-
-static struct stats_record *alloc_stats_record(void)
-{
-	struct stats_record *rec;
-	int i, size;
-
-	size = sizeof(*rec) + n_cpus * sizeof(struct record);
-	rec = malloc(size);
-	if (!rec) {
-		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
-	}
-	memset(rec, 0, size);
-	rec->rx_cnt.cpu    = alloc_record_per_cpu();
-	rec->redir_err.cpu = alloc_record_per_cpu();
-	rec->kthread.cpu   = alloc_record_per_cpu();
-	rec->exception.cpu = alloc_record_per_cpu();
-	for (i = 0; i < n_cpus; i++)
-		rec->enq[i].cpu = alloc_record_per_cpu();
-
-	return rec;
-}
-
-static void free_stats_record(struct stats_record *r)
-{
-	int i;
-
-	for (i = 0; i < n_cpus; i++)
-		free(r->enq[i].cpu);
-	free(r->exception.cpu);
-	free(r->kthread.cpu);
-	free(r->redir_err.cpu);
-	free(r->rx_cnt.cpu);
-	free(r);
-}
-
-static double calc_period(struct record *r, struct record *p)
-{
-	double period_ = 0;
-	__u64 period = 0;
-
-	period = r->timestamp - p->timestamp;
-	if (period > 0)
-		period_ = ((double) period / NANOSEC_PER_SEC);
-
-	return period_;
-}
-
-static __u64 calc_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_drop_pps(struct datarec *r, struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->dropped - p->dropped;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static __u64 calc_errs_pps(struct datarec *r,
-			    struct datarec *p, double period_)
-{
-	__u64 packets = 0;
-	__u64 pps = 0;
-
-	if (period_ > 0) {
-		packets = r->issue - p->issue;
-		pps = packets / period_;
-	}
-	return pps;
-}
-
-static void calc_xdp_pps(struct datarec *r, struct datarec *p,
-			 double *xdp_pass, double *xdp_drop,
-			 double *xdp_redirect, double period_)
-{
-	*xdp_pass = 0, *xdp_drop = 0, *xdp_redirect = 0;
-	if (period_ > 0) {
-		*xdp_redirect = (r->xdp_redirect - p->xdp_redirect) / period_;
-		*xdp_pass = (r->xdp_pass - p->xdp_pass) / period_;
-		*xdp_drop = (r->xdp_drop - p->xdp_drop) / period_;
-	}
-}
-
-static void stats_print(struct stats_record *stats_rec,
-			struct stats_record *stats_prev,
-			char *prog_name, char *mprog_name, int mprog_fd)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	double pps = 0, drop = 0, err = 0;
-	bool mprog_enabled = false;
-	struct record *rec, *prev;
-	int to_cpu;
-	double t;
-	int i;
-
-	if (mprog_fd > 0)
-		mprog_enabled = true;
-
-	/* Header */
-	printf("Running XDP/eBPF prog_name:%s\n", prog_name);
-	printf("%-15s %-7s %-14s %-11s %-9s\n",
-	       "XDP-cpumap", "CPU:to", "pps", "drop-pps", "extra-info");
-
-	/* XDP rx_cnt */
-	{
-		char *fmt_rx = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_rx = "%-15s %-7s %'-14.0f %'-11.0f\n";
-		char *errstr = "";
-
-		rec  = &stats_rec->rx_cnt;
-		prev = &stats_prev->rx_cnt;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				errstr = "cpu-dest/err";
-			if (pps > 0)
-				printf(fmt_rx, "XDP-RX",
-					i, pps, drop, err, errstr);
-		}
-		pps  = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		printf(fm2_rx, "XDP-RX", "total", pps, drop);
-	}
-
-	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < n_cpus; to_cpu++) {
-		char *fmt = "%-15s %3d:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *fm2 = "%-15s %3s:%-3d %'-14.0f %'-11.0f %'-10.2f %s\n";
-		char *errstr = "";
-
-		rec  =  &stats_rec->enq[to_cpu];
-		prev = &stats_prev->enq[to_cpu];
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			if (pps > 0)
-				printf(fmt, "cpumap-enqueue",
-				       i, to_cpu, pps, drop, err, errstr);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		if (pps > 0) {
-			drop = calc_drop_pps(&rec->total, &prev->total, t);
-			err  = calc_errs_pps(&rec->total, &prev->total, t);
-			if (err > 0) {
-				errstr = "bulk-average";
-				err = pps / err; /* calc average bulk size */
-			}
-			printf(fm2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, err, errstr);
-		}
-	}
-
-	/* cpumap kthread stats */
-	{
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f %s\n";
-		char *e_str = "";
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			err  = calc_errs_pps(r, p, t);
-			if (err > 0)
-				e_str = "sched";
-			if (pps > 0)
-				printf(fmt_k, "cpumap_kthread",
-				       i, pps, drop, err, e_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		err  = calc_errs_pps(&rec->total, &prev->total, t);
-		if (err > 0)
-			e_str = "sched-sum";
-		printf(fm2_k, "cpumap_kthread", "total", pps, drop, err, e_str);
-	}
-
-	/* XDP redirect err tracepoints (very unlikely) */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->redir_err;
-		prev = &stats_prev->redir_err;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "redirect_err", i, pps, drop);
+		if (bpf_program__is_xdp(pos)) {
+			if (!strncmp(bpf_program__name(pos), "xdp_prognum",
+				     sizeof("xdp_prognum") - 1))
+				printf(" %s\n", bpf_program__name(pos));
 		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "redirect_err", "total", pps, drop);
 	}
-
-	/* XDP general exception tracepoints */
-	{
-		char *fmt_err = "%-15s %-7d %'-14.0f %'-11.0f\n";
-		char *fm2_err = "%-15s %-7s %'-14.0f %'-11.0f\n";
-
-		rec  = &stats_rec->exception;
-		prev = &stats_prev->exception;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop_pps(r, p, t);
-			if (pps > 0)
-				printf(fmt_err, "xdp_exception", i, pps, drop);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop_pps(&rec->total, &prev->total, t);
-		printf(fm2_err, "xdp_exception", "total", pps, drop);
-	}
-
-	/* CPUMAP attached XDP program that runs on remote/destination CPU */
-	if (mprog_enabled) {
-		char *fmt_k = "%-15s %-7d %'-14.0f %'-11.0f %'-10.0f\n";
-		char *fm2_k = "%-15s %-7s %'-14.0f %'-11.0f %'-10.0f\n";
-		double xdp_pass, xdp_drop, xdp_redirect;
-
-		printf("\n2nd remote XDP/eBPF prog_name: %s\n", mprog_name);
-		printf("%-15s %-7s %-14s %-11s %-9s\n",
-		       "XDP-cpumap", "CPU:to", "xdp-pass", "xdp-drop", "xdp-redir");
-
-		rec  = &stats_rec->kthread;
-		prev = &stats_prev->kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			calc_xdp_pps(r, p, &xdp_pass, &xdp_drop,
-				     &xdp_redirect, t);
-			if (xdp_pass > 0 || xdp_drop > 0 || xdp_redirect > 0)
-				printf(fmt_k, "xdp-in-kthread", i, xdp_pass, xdp_drop,
-				       xdp_redirect);
-		}
-		calc_xdp_pps(&rec->total, &prev->total, &xdp_pass, &xdp_drop,
-			     &xdp_redirect, t);
-		printf(fm2_k, "xdp-in-kthread", "total", xdp_pass, xdp_drop, xdp_redirect);
-	}
-
-	printf("\n");
-	fflush(stdout);
-}
-
-static void stats_collect(struct stats_record *rec)
-{
-	int fd, i;
-
-	fd = map_fds[RX_CNT];
-	map_collect_percpu(fd, 0, &rec->rx_cnt);
-
-	fd = map_fds[REDIRECT_ERR_CNT];
-	map_collect_percpu(fd, 1, &rec->redir_err);
-
-	fd = map_fds[CPUMAP_ENQUEUE_CNT];
-	for (i = 0; i < n_cpus; i++)
-		map_collect_percpu(fd, i, &rec->enq[i]);
-
-	fd = map_fds[CPUMAP_KTHREAD_CNT];
-	map_collect_percpu(fd, 0, &rec->kthread);
-
-	fd = map_fds[EXCEPTION_CNT];
-	map_collect_percpu(fd, 0, &rec->exception);
 }
 
-
-/* Pointer swap trick */
-static inline void swap(struct stats_record **a, struct stats_record **b)
+static void usage(char *argv[], const struct option *long_options,
+		  const char *doc, int mask, bool error, struct bpf_object *obj)
 {
-	struct stats_record *tmp;
-
-	tmp = *a;
-	*a = *b;
-	*b = tmp;
+	sample_usage(argv, long_options, doc, mask, error);
+	print_avail_progs(obj);
 }
 
 static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
@@ -582,39 +84,41 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 	/* Add a CPU entry to cpumap, as this allocate a cpu entry in
 	 * the kernel for the cpu.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPU_MAP], &cpu, value, 0);
-	if (ret) {
-		fprintf(stderr, "Create CPU entry failed (err:%d)\n", ret);
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_update_elem(map_fd, &cpu, value, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Create CPU entry failed: %s\n", strerror(errno));
+		return ret;
 	}
 
 	/* Inform bpf_prog's that a new CPU is available to select
 	 * from via some control maps.
 	 */
-	ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &avail_idx, &cpu, 0);
-	if (ret) {
-		fprintf(stderr, "Add to avail CPUs failed\n");
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_update_elem(avail_fd, &avail_idx, &cpu, 0);
+	if (ret < 0) {
+		fprintf(stderr, "Add to avail CPUs failed: %s\n", strerror(errno));
+		return ret;
 	}
 
 	/* When not replacing/updating existing entry, bump the count */
-	ret = bpf_map_lookup_elem(map_fds[CPUS_COUNT], &key, &curr_cpus_count);
-	if (ret) {
-		fprintf(stderr, "Failed reading curr cpus_count\n");
-		exit(EXIT_FAIL_BPF);
+	ret = bpf_map_lookup_elem(count_fd, &key, &curr_cpus_count);
+	if (ret < 0) {
+		fprintf(stderr, "Failed reading curr cpus_count: %s\n",
+			strerror(errno));
+		return ret;
 	}
 	if (new) {
 		curr_cpus_count++;
-		ret = bpf_map_update_elem(map_fds[CPUS_COUNT], &key,
+		ret = bpf_map_update_elem(count_fd, &key,
 					  &curr_cpus_count, 0);
-		if (ret) {
-			fprintf(stderr, "Failed write curr cpus_count\n");
-			exit(EXIT_FAIL_BPF);
+		if (ret < 0) {
+			fprintf(stderr, "Failed write curr cpus_count: %s\n",
+				strerror(errno));
+			return ret;
 		}
 	}
-	/* map_fd[7] = cpus_iterator */
-	printf("%s CPU:%u as idx:%u qsize:%d prog_fd: %d (cpus_count:%u)\n",
-	       new ? "Add-new":"Replace", cpu, avail_idx,
+
+	printf("%s CPU: %u as idx: %u qsize: %d cpumap_prog_fd: %d (cpus_count: %u)\n",
+	       new ? "Add new" : "Replace", cpu, avail_idx,
 	       value->qsize, value->bpf_prog.fd, curr_cpus_count);
 
 	return 0;
@@ -623,24 +127,29 @@ static int create_cpu_entry(__u32 cpu, struct bpf_cpumap_val *value,
 /* CPUs are zero-indexed. Thus, add a special sentinel default value
  * in map cpus_available to mark CPU index'es not configured
  */
-static void mark_cpus_unavailable(void)
+static int mark_cpus_unavailable(void)
 {
-	__u32 invalid_cpu = n_cpus;
-	int ret, i;
+	int ret, i, n_cpus = sample_get_cpus();
+	__u32 invalid_cpu;
 
 	for (i = 0; i < n_cpus; i++) {
-		ret = bpf_map_update_elem(map_fds[CPUS_AVAILABLE], &i,
+		ret = bpf_map_update_elem(avail_fd, &i,
 					  &invalid_cpu, 0);
-		if (ret) {
-			fprintf(stderr, "Failed marking CPU unavailable\n");
-			exit(EXIT_FAIL_BPF);
+		if (ret < 0) {
+			fprintf(stderr, "Failed marking CPU unavailable: %s\n",
+				strerror(errno));
+			return ret;
 		}
 	}
+
+	return 0;
 }
 
 /* Stress cpumap management code by concurrently changing underlying cpumap */
-static void stress_cpumap(struct bpf_cpumap_val *value)
+static void stress_cpumap(void *ctx)
 {
+	struct bpf_cpumap_val *value = ctx;
+
 	/* Changing qsize will cause kernel to free and alloc a new
 	 * bpf_cpu_map_entry, with an associated/complicated tear-down
 	 * procedure.
@@ -653,144 +162,60 @@ static void stress_cpumap(struct bpf_cpumap_val *value)
 	create_cpu_entry(1, value, 0, false);
 }
 
-static void stats_poll(int interval, bool use_separators, char *prog_name,
-		       char *mprog_name, struct bpf_cpumap_val *value,
-		       bool stress_mode)
-{
-	struct stats_record *record, *prev;
-	int mprog_fd;
-
-	record = alloc_stats_record();
-	prev   = alloc_stats_record();
-	stats_collect(record);
-
-	/* Trick to pretty printf with thousands separators use %' */
-	if (use_separators)
-		setlocale(LC_NUMERIC, "en_US");
-
-	while (1) {
-		swap(&prev, &record);
-		mprog_fd = value->bpf_prog.fd;
-		stats_collect(record);
-		stats_print(record, prev, prog_name, mprog_name, mprog_fd);
-		sleep(interval);
-		if (stress_mode)
-			stress_cpumap(value);
-	}
-
-	free_stats_record(record);
-	free_stats_record(prev);
-}
-
-static int init_tracepoints(struct bpf_object *obj)
-{
-	struct bpf_program *prog;
-
-	bpf_object__for_each_program(prog, obj) {
-		if (bpf_program__is_tracepoint(prog) != true)
-			continue;
-
-		tp_links[tp_cnt] = bpf_program__attach(prog);
-		if (libbpf_get_error(tp_links[tp_cnt])) {
-			tp_links[tp_cnt] = NULL;
-			return -EINVAL;
-		}
-		tp_cnt++;
-	}
-
-	return 0;
-}
-
-static int init_map_fds(struct bpf_object *obj)
+static int set_cpumap_prog(struct xdp_redirect_cpu *skel, char *redir_interface)
 {
-	enum map_type type;
-
-	for (type = 0; type < NUM_MAP; type++) {
-		map_fds[type] =
-			bpf_object__find_map_fd_by_name(obj,
-							map_type_strings[type]);
-
-		if (map_fds[type] < 0)
-			return -ENOENT;
-	}
-
-	return 0;
-}
-
-static int load_cpumap_prog(char *file_name, char *prog_name,
-			    char *redir_interface, char *redir_map)
-{
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type		= BPF_PROG_TYPE_XDP,
-		.expected_attach_type	= BPF_XDP_CPUMAP,
-		.file = file_name,
-	};
-	struct bpf_program *prog;
-	struct bpf_object *obj;
-	int fd;
-
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &fd))
-		return -1;
-
-	if (fd < 0) {
-		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
-			strerror(errno));
-		return fd;
-	}
-
-	if (redir_interface && redir_map) {
-		int err, map_fd, ifindex_out, key = 0;
+	struct bpf_devmap_val val = {};
+	int ifindex_out, err;
+	__u32 key = 0;
 
-		map_fd = bpf_object__find_map_fd_by_name(obj, redir_map);
-		if (map_fd < 0)
-			return map_fd;
+	if (!redir_interface)
+		return 0;
 
-		ifindex_out = if_nametoindex(redir_interface);
-		if (!ifindex_out)
-			return -1;
+	ifindex_out = if_nametoindex(redir_interface);
+	if (!ifindex_out)
+		return -EINVAL;
 
-		err = bpf_map_update_elem(map_fd, &key, &ifindex_out, 0);
-		if (err < 0)
-			return err;
+	if (get_mac_addr(ifindex_out, skel->bss->tx_mac_addr) < 0) {
+		printf("get interface %d mac failed\n", ifindex_out);
+		return -EINVAL;
 	}
 
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (!prog) {
-		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		return EXIT_FAIL;
-	}
+	val.ifindex = ifindex_out;
+	val.bpf_prog.fd = bpf_program__fd(skel->progs.xdp_redirect_egress_prog);
+	err = bpf_map_update_elem(bpf_map__fd(skel->maps.tx_port), &key, &val, 0);
+	if (err < 0)
+		return -errno;
 
-	return bpf_program__fd(prog);
+	/* Filter redirect tracepoint for cpumap, not devmap redirections */
+	return bpf_program__fd(skel->progs.xdp_redirect_cpu_devmap);
 }
 
 int main(int argc, char **argv)
 {
-	char *prog_name = "xdp_cpu_map5_lb_hash_ip_pairs";
-	char *mprog_filename = "xdp_redirect_kern.o";
-	char *redir_interface = NULL, *redir_map = NULL;
-	char *mprog_name = "xdp_redirect_dummy";
-	bool mprog_disable = false;
-	struct bpf_prog_load_attr prog_load_attr = {
-		.prog_type	= BPF_PROG_TYPE_UNSPEC,
-	};
-	struct bpf_prog_info info = {};
-	__u32 info_len = sizeof(info);
+	struct xdp_redirect_cpu *skel;
+	struct bpf_map_info info = {};
+	char *redir_interface = NULL;
+	char ifname_buf[IF_NAMESIZE];
 	struct bpf_cpumap_val value;
-	bool use_separators = true;
+	__u32 infosz = sizeof(info);
+	int ret = EXIT_FAIL_OPTION;
+	unsigned long interval = 2;
 	bool stress_mode = false;
 	struct bpf_program *prog;
-	struct bpf_object *obj;
-	int err = EXIT_FAIL;
-	char filename[256];
+	const char *prog_name;
+	bool generic = false;
+	bool force = false;
 	int added_cpus = 0;
+	bool error = true;
 	int longindex = 0;
-	int interval = 2;
 	int add_cpu = -1;
-	int opt, prog_fd;
-	int *cpu, i;
+	int ifindex = -1;
+	int *cpu, i, opt;
+	char *ifname;
 	__u32 qsize;
+	int n_cpus;
 
-	n_cpus = get_nprocs_conf();
+	n_cpus = sample_get_cpus();
 
 	/* Notice: Choosing the queue size is very important when CPU is
 	 * configured with power-saving states.
@@ -810,85 +235,70 @@ int main(int argc, char **argv)
 	 */
 	qsize = 2048;
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-	prog_load_attr.file = filename;
-
-	if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
-		return err;
-
-	if (prog_fd < 0) {
-		fprintf(stderr, "ERR: bpf_prog_load_xattr: %s\n",
+	skel = xdp_redirect_cpu__open();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_redirect_cpu__open: %s\n",
 			strerror(errno));
-		return err;
-	}
-
-	if (init_tracepoints(obj) < 0) {
-		fprintf(stderr, "ERR: bpf_program__attach failed\n");
-		return err;
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	if (init_map_fds(obj) < 0) {
-		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
-		return err;
-	}
-	mark_cpus_unavailable();
-
-	cpu = malloc(n_cpus * sizeof(int));
+	cpu = calloc(n_cpus, sizeof(int));
 	if (!cpu) {
-		fprintf(stderr, "failed to allocate cpu array\n");
-		return err;
+		fprintf(stderr, "Failed to allocate cpu array\n");
+		goto end_destroy;
 	}
-	memset(cpu, 0, n_cpus * sizeof(int));
 
-	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hSd:s:p:q:c:xzFf:e:r:m:",
+	prog = skel->progs.xdp_prognum5_lb_hash_ip_pairs;
+	while ((opt = getopt_long(argc, argv, "d:si:Sxp:r:c:q:Fvh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
 		case 'd':
 			if (strlen(optarg) >= IF_NAMESIZE) {
-				fprintf(stderr, "ERR: --dev name too long\n");
-				goto error;
+				fprintf(stderr, "-d/--dev name too long\n");
+				goto end_cpu;
 			}
 			ifname = (char *)&ifname_buf;
-			strncpy(ifname, optarg, IF_NAMESIZE);
+			safe_strncpy(ifname, optarg, sizeof(ifname));
 			ifindex = if_nametoindex(ifname);
-			if (ifindex == 0) {
-				fprintf(stderr,
-					"ERR: --dev name unknown err(%d):%s\n",
+			if (!ifindex)
+				ifindex = strtoul(optarg, NULL, 0);
+			if (!ifindex) {
+				fprintf(stderr, "Bad interface index or name (%d): %s\n",
 					errno, strerror(errno));
-				goto error;
+				usage(argv, long_options, __doc__, mask, true, skel->obj);
+				goto end_cpu;
 			}
 			break;
 		case 's':
-			interval = atoi(optarg);
+			mask |= SAMPLE_REDIRECT_MAP_CNT;
+			break;
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
 			break;
 		case 'S':
-			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			generic = true;
 			break;
 		case 'x':
 			stress_mode = true;
 			break;
-		case 'z':
-			use_separators = false;
-			break;
 		case 'p':
 			/* Selecting eBPF prog to load */
 			prog_name = optarg;
-			break;
-		case 'n':
-			mprog_disable = true;
-			break;
-		case 'f':
-			mprog_filename = optarg;
-			break;
-		case 'e':
-			mprog_name = optarg;
+			prog = bpf_object__find_program_by_name(skel->obj,
+								prog_name);
+			if (!prog) {
+				fprintf(stderr,
+					"Failed to find program %s specified by"
+					" option -p/--progname\n",
+					prog_name);
+				print_avail_progs(skel->obj);
+				goto end_cpu;
+			}
 			break;
 		case 'r':
 			redir_interface = optarg;
-			break;
-		case 'm':
-			redir_map = optarg;
+			mask |= SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 			break;
 		case 'c':
 			/* Add multiple CPUs */
@@ -897,91 +307,105 @@ int main(int argc, char **argv)
 				fprintf(stderr,
 				"--cpu nr too large for cpumap err(%d):%s\n",
 					errno, strerror(errno));
-				goto error;
+				goto end_cpu;
 			}
 			cpu[added_cpus++] = add_cpu;
 			break;
 		case 'q':
-			qsize = atoi(optarg);
+			qsize = strtoul(optarg, NULL, 0);
 			break;
 		case 'F':
-			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			force = true;
+			break;
+		case 'v':
+			sample_switch_mode();
 			break;
 		case 'h':
-		error:
+			error = false;
 		default:
-			free(cpu);
-			usage(argv, obj);
-			return EXIT_FAIL_OPTION;
+			usage(argv, long_options, __doc__, mask, error, skel->obj);
+			goto end_cpu;
 		}
 	}
 
-	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
-		xdp_flags |= XDP_FLAGS_DRV_MODE;
-
-	/* Required option */
+	ret = EXIT_FAIL_OPTION;
 	if (ifindex == -1) {
-		fprintf(stderr, "ERR: required option --dev missing\n");
-		usage(argv, obj);
-		err = EXIT_FAIL_OPTION;
-		goto out;
+		fprintf(stderr, "Required option --dev missing\n");
+		usage(argv, long_options, __doc__, mask, true, skel->obj);
+		goto end_cpu;
 	}
-	/* Required option */
+
 	if (add_cpu == -1) {
-		fprintf(stderr, "ERR: required option --cpu missing\n");
-		fprintf(stderr, " Specify multiple --cpu option to add more\n");
-		usage(argv, obj);
-		err = EXIT_FAIL_OPTION;
-		goto out;
+		fprintf(stderr, "ERR: required option --cpu missing\n"
+				"Specify multiple --cpu option to add more\n");
+		usage(argv, long_options, __doc__, mask, true, skel->obj);
+		goto end_cpu;
 	}
 
-	value.bpf_prog.fd = 0;
-	if (!mprog_disable)
-		value.bpf_prog.fd = load_cpumap_prog(mprog_filename, mprog_name,
-						     redir_interface, redir_map);
-	if (value.bpf_prog.fd < 0) {
-		err = value.bpf_prog.fd;
-		goto out;
+	skel->rodata->from_match[0] = ifindex;
+	if (redir_interface)
+		skel->rodata->to_match[0] = if_nametoindex(redir_interface);
+
+	ret = xdp_redirect_cpu__load(skel);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to xdp_redirect_cpu__load: %s\n",
+			strerror(errno));
+		goto end_cpu;
 	}
-	value.qsize = qsize;
 
-	for (i = 0; i < added_cpus; i++)
-		create_cpu_entry(cpu[i], &value, i, true);
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(skel->maps.cpu_map), &info, &infosz);
+	if (ret < 0) {
+		fprintf(stderr, "Failed bpf_obj_get_info_by_fd for cpumap: %s\n",
+			strerror(errno));
+		goto end_cpu;
+	}
 
-	/* Remove XDP program when program is interrupted or killed */
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
+	skel->bss->cpumap_map_id = info.id;
 
-	prog = bpf_object__find_program_by_title(obj, prog_name);
-	if (!prog) {
-		fprintf(stderr, "bpf_object__find_program_by_title failed\n");
-		goto out;
-	}
+	map_fd = bpf_map__fd(skel->maps.cpu_map);
+	avail_fd = bpf_map__fd(skel->maps.cpus_available);
+	count_fd = bpf_map__fd(skel->maps.cpus_count);
 
-	prog_fd = bpf_program__fd(prog);
-	if (prog_fd < 0) {
-		fprintf(stderr, "bpf_program__fd failed\n");
-		goto out;
+	ret = mark_cpus_unavailable();
+	if (ret < 0) {
+		fprintf(stderr, "Unable to mark CPUs as unavailable\n");
+		goto end_cpu;
 	}
 
-	if (bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags) < 0) {
-		fprintf(stderr, "link set xdp fd failed\n");
-		err = EXIT_FAIL_XDP;
-		goto out;
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_cpu;
 	}
 
-	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
-	if (err) {
-		printf("can't get prog info - %s\n", strerror(errno));
-		goto out;
+	value.bpf_prog.fd = set_cpumap_prog(skel, redir_interface);
+	if (value.bpf_prog.fd < 0) {
+		fprintf(stderr, "Failed to set cpumap prog to redirect to interface %s: %s\n",
+			redir_interface, strerror(-value.bpf_prog.fd));
+		ret = EXIT_FAIL_BPF;
+		goto end_cpu;
 	}
-	prog_id = info.id;
+	value.qsize = qsize;
 
-	stats_poll(interval, use_separators, prog_name, mprog_name,
-		   &value, stress_mode);
+	for (i = 0; i < added_cpus; i++)
+		create_cpu_entry(cpu[i], &value, i, true);
 
-	err = EXIT_OK;
-out:
+	ret = EXIT_FAIL_XDP;
+	if (sample_install_xdp(prog, ifindex, generic, force) < 0)
+		goto end_cpu;
+
+	ret = sample_run(interval, stress_mode ? stress_cpumap : NULL, &value);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_cpu;
+	}
+	ret = EXIT_OK;
+end_cpu:
 	free(cpu);
-	return err;
+end_destroy:
+	xdp_redirect_cpu__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0


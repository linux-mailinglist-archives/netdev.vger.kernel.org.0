Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1073F37AA
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241207AbhHUAWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:22:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbhHUAVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F02C061575;
        Fri, 20 Aug 2021 17:21:05 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id k24so10812505pgh.8;
        Fri, 20 Aug 2021 17:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k1kczFxUOT5iKO+CrTf2jZEpAHSQATeNRTa5sZwT6/w=;
        b=aPC0flfGPE9lmUU/sNirYUsJSHgrV0GlNYTon024cv6nBSv48gtfXZ8Ffh+ntxS72C
         1qb6w2BK67nkTHCgbwUNN/zuV/dy/nf0bk7g/SQfdP6JHRsCwqz8s8/EajDFzoFwX9Qt
         217eoRNg4P3Fr6jdUsXwAh3wB44/SRoKNNq6GZ1qc8NukbK3EpTIuH4100Bb/b9J9+TN
         37gWJ1Dzb0Vv7vArylbIqfhIiwAWmKMHgl+mvhz2VUUF+sJ2gVt5KyZHdJBodt3QEecU
         fkW5LwssbFBGjjn2iptP3K2xTzr5HFsuMSJOWXbog0sN0sZhOnZtqHuehRD6QOe5Vbp3
         QzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k1kczFxUOT5iKO+CrTf2jZEpAHSQATeNRTa5sZwT6/w=;
        b=GmLP95gYpcmCmTX0bzx8ziNZjFW++hb/wo4NVrHxGcs+N/bmnwGbJNCfpxRY/82H0s
         /VaR/awTwQWuAoj0ieC+5MZeFcunmvyk8KQX6E39KYKQ0b8S+IBFgk+rgLJXwTFc75xt
         gZqeOhbIJ8dBkbDFe7vFfv9CW+9t/GcPZaSECkcENwrWkgoWvz+LwbCoeU+BQgiBCJJA
         /TQ6lXdFiU+OAshE+xOfb+ZiryTHpqiLHaDCvjuf9PXrFlsC/BxtRZZ9879y5OMfUFMu
         R3RWRfIj8tdjfkVuJ+mLZDo7bUkZwJHFxk5vrYb9JHsrpJi9olKWvhrKg+QfNPnziH+n
         Csew==
X-Gm-Message-State: AOAM5300I7HcqHkcp+OkSDIJsiJ/x49Lbv29BVX1UmlOl/9zbejnsNKw
        fBc2zu6gGHeOjYuMG/gLNbySq9Yxg0s=
X-Google-Smtp-Source: ABdhPJzJ4OvGeQl6qvUy+PUDHr0UqLtp7kjKCeGyWvJmk6+6guljd3suOtV63FZ9B02w002a+g2+gQ==
X-Received: by 2002:a63:2f04:: with SMTP id v4mr20804236pgv.380.1629505265100;
        Fri, 20 Aug 2021 17:21:05 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id gj24sm10638102pjb.34.2021.08.20.17.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:21:04 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 17/22] samples: bpf: Convert xdp_redirect_cpu_kern.o to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:05 +0530
Message-Id: <20210821002010.845777-18-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to xdp_monitor_kern, a lot of these BPF programs have been
reimplemented properly consolidating missing features from other XDP
samples. Hence, drop the unneeded code and rename to .bpf.c suffix.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |   5 +-
 ...rect_cpu_kern.c => xdp_redirect_cpu.bpf.c} | 393 +++++-------------
 2 files changed, 105 insertions(+), 293 deletions(-)
 rename samples/bpf/{xdp_redirect_cpu_kern.c => xdp_redirect_cpu.bpf.c} (52%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index d05105227ec5..231cdbc773a7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -165,7 +165,6 @@ always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
 always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
-always-y += xdp_redirect_cpu_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -356,6 +355,7 @@ endef
 
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
+$(obj)/xdp_redirect_cpu.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
 
@@ -367,9 +367,10 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
+xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
 
diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu.bpf.c
similarity index 52%
rename from samples/bpf/xdp_redirect_cpu_kern.c
rename to samples/bpf/xdp_redirect_cpu.bpf.c
index 8255025dea97..f10fe3cf25f6 100644
--- a/samples/bpf/xdp_redirect_cpu_kern.c
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -2,74 +2,18 @@
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
 	__uint(key_size, sizeof(u32));
 	__uint(value_size, sizeof(struct bpf_cpumap_val));
-	__uint(max_entries, MAX_CPUS);
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
@@ -77,14 +21,15 @@ struct {
 	__uint(type, BPF_MAP_TYPE_ARRAY);
 	__type(key, u32);
 	__type(value, u32);
-	__uint(max_entries, MAX_CPUS);
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
@@ -92,24 +37,16 @@ struct {
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
@@ -125,11 +62,12 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
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
@@ -139,7 +77,8 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
 	}
 	/* Handle double VLAN tagged packet */
-	if (eth_type == htons(ETH_P_8021Q) || eth_type == htons(ETH_P_8021AD)) {
+	if (eth_type == bpf_htons(ETH_P_8021Q) ||
+	    eth_type == bpf_htons(ETH_P_8021AD)) {
 		struct vlan_hdr *vlan_hdr;
 
 		vlan_hdr = (void *)eth + offset;
@@ -149,7 +88,7 @@ bool parse_eth(struct ethhdr *eth, void *data_end,
 		eth_type = vlan_hdr->h_vlan_encapsulated_proto;
 	}
 
-	*eth_proto = ntohs(eth_type);
+	*eth_proto = bpf_ntohs(eth_type);
 	*l3_offset = offset;
 	return true;
 }
@@ -172,7 +111,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	if (udph + 1 > data_end)
 		return 0;
 
-	dport = ntohs(udph->dest);
+	dport = bpf_ntohs(udph->dest);
 	return dport;
 }
 
@@ -200,50 +139,48 @@ int get_proto_ipv6(struct xdp_md *ctx, u64 nh_off)
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
 	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
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
@@ -252,36 +189,33 @@ int  xdp_prognum1_touch_data(struct xdp_md *ctx)
 	if (eth + 1 > data_end)
 		return XDP_ABORTED;
 
-	/* Count RX packet in map */
 	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
 	/* Read packet data, and use it (drop non 802.3 Ethertypes) */
 	eth_type = eth->h_proto;
-	if (ntohs(eth_type) < ETH_P_802_3_MIN) {
-		rec->dropped++;
+	if (bpf_ntohs(eth_type) < ETH_P_802_3_MIN) {
+		NO_TEAR_INC(rec->dropped);
 		return XDP_DROP;
 	}
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
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
@@ -307,40 +241,37 @@ int  xdp_prognum2_round_robin(struct xdp_md *ctx)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_selected;
 
-	/* Count RX packet in map */
-	rec = bpf_map_lookup_elem(&rx_cnt, &key0);
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
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
 	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
 	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
 		return XDP_PASS; /* Just skip */
@@ -381,35 +312,33 @@ int  xdp_prognum3_proto_separate(struct xdp_md *ctx)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_lookup;
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
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
 	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
 	if (!(parse_eth(eth, data_end, &eth_proto, &l3_offset)))
 		return XDP_PASS; /* Just skip */
@@ -443,8 +372,7 @@ int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 		/* DDoS filter UDP port 9 (pktgen) */
 		dest_port = get_dest_port_ipv4_udp(ctx, l3_offset);
 		if (dest_port == 9) {
-			if (rec)
-				rec->dropped++;
+			NO_TEAR_INC(rec->dropped);
 			return XDP_DROP;
 		}
 		break;
@@ -457,11 +385,10 @@ int  xdp_prognum4_ddos_filter_pktgen(struct xdp_md *ctx)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_lookup;
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
+		NO_TEAR_INC(rec->issue);
 		return XDP_ABORTED;
 	}
-
 	return bpf_redirect_map(&cpu_map, cpu_dest, 0);
 }
 
@@ -496,10 +423,10 @@ u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
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
@@ -509,30 +436,29 @@ u32 get_ipv6_hash_ip_pair(struct xdp_md *ctx, u64 nh_off)
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
 	rec = bpf_map_lookup_elem(&rx_cnt, &key);
 	if (!rec)
-		return XDP_ABORTED;
-	rec->processed++;
+		return XDP_PASS;
+	NO_TEAR_INC(rec->processed);
 
-	cpu_max = bpf_map_lookup_elem(&cpus_count, &key);
+	cpu_max = bpf_map_lookup_elem(&cpus_count, &key0);
 	if (!cpu_max)
 		return XDP_ABORTED;
 
@@ -560,171 +486,56 @@ int  xdp_prognum5_lb_hash_ip_pairs(struct xdp_md *ctx)
 		return XDP_ABORTED;
 	cpu_dest = *cpu_lookup;
 
-	if (cpu_dest >= MAX_CPUS) {
-		rec->issue++;
+	if (cpu_dest >= nr_cpus) {
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
+SEC("xdp_cpumap/redirect")
+int xdp_redirect_cpu_devmap(struct xdp_md *ctx)
 {
-	u32 key = XDP_REDIRECT_ERROR;
-	struct datarec *rec;
-	int err = ctx->err;
+	void *data_end = (void *)(long)ctx->data_end;
+	void *data = (void *)(long)ctx->data;
+	struct ethhdr *eth = data;
+	u64 nh_off;
 
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
+	nh_off = sizeof(*eth);
+	if (data + nh_off > data_end)
+		return XDP_DROP;
 
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
+	swap_src_dst_mac(data);
+	return bpf_redirect_map(&tx_port, 0, 0);
 }
 
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
+SEC("xdp_cpumap/pass")
+int xdp_redirect_cpu_pass(struct xdp_md *ctx)
 {
-	return xdp_redirect_collect_stat(ctx);
+	return XDP_PASS;
 }
 
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
+SEC("xdp_cpumap/drop")
+int xdp_redirect_cpu_drop(struct xdp_md *ctx)
 {
-	return xdp_redirect_collect_stat(ctx);
+	return XDP_DROP;
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
-- 
2.33.0


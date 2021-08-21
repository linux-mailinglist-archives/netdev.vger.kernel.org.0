Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1286B3F37AB
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241217AbhHUAWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240968AbhHUAVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:51 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051B3C061764;
        Fri, 20 Aug 2021 17:21:13 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id e15so6880665plh.8;
        Fri, 20 Aug 2021 17:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bbj3hMWqVFxHWHurPDx/HXFQmItgMiISOwmdaCBwlh4=;
        b=UO1s5BstOKigWQrvWOk9k648KRbDRBHniF6UTL/HDWe36JQTbFImYxRvHyVk6hP904
         KzwDfyk9Oayb/yOK5zPHMBYmMpKyNLaVtUFzYZuBJpQyQYiNubSUJOMWVxdq8vMTwG5K
         99uR9ZFYOCsfqVwwBZ/AbmuZnMI5QFXMM+krXXFkNO20HouUAyikfWppCFFi/Mkgppq2
         F8yVkZKDIxMwZ2oxiaoyyJ4V9MphXx7Paza3wfq8j5PVIJKP8YC1HGKoJYM6OU/9R6gR
         FJeGbszPFq8DAtSC1Xgh02AkrSARi82DV9pRCBR4saTrzG8SfKq/qi43GTHETWJH23sG
         uajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bbj3hMWqVFxHWHurPDx/HXFQmItgMiISOwmdaCBwlh4=;
        b=eC4HwKkSDP1nqFOke/4Ae+7+mjYmwEMEpSFCYrZbzd8mT7r2gg7mqUzaE1qdUr+HGa
         ammyghjF+qiQ1263jQI4UWcLIJBOJjQVPrqiDBbBO288x72hAD0InT93kaj+St0+qkrq
         xQeDV4HkNBylQKCDj6Fx001WMD58QvVHdPrISN3z1tYpmd9/f+XOxeN4BP6adq6N/3QG
         wKoxzBAvPc1Ugv+Dz+xnF8TJPoanC+5YY12hqNvelFAN+hWtQJHuQutJXViEks5hvm4F
         AbRIgIrwhQ6WYTz0AYagQQkNBjymEmn1lVAAkgS+RoWOAl+B1ROE80FG05Q/qzqAGhto
         xrZA==
X-Gm-Message-State: AOAM533Af2h54Ie/eXCNkCAP1cDVihtUth8+c7+PsbLBEJUSeObZTaGQ
        Z3fIdsaCy5pkyPpQP97F8EFnnlmWWpc=
X-Google-Smtp-Source: ABdhPJzDJZcnXwl+7tQE16i3KUnlYA2tP5HwPdUqkq9vUcsiKGBzYyXp9GQOzxn7AL8DwDraFJ38Sw==
X-Received: by 2002:a17:90a:d686:: with SMTP id x6mr7268503pju.8.1629505272356;
        Fri, 20 Aug 2021 17:21:12 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id fh2sm7298915pjb.12.2021.08.20.17.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:21:12 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 19/22] samples: bpf: Convert xdp_redirect_map_kern.o to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:07 +0530
Message-Id: <20210821002010.845777-20-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also update it to use consistent SEC("xdp") and SEC("xdp_devmap")
naming, and use global variable instead of BPF map for copying the mac
address.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile                          |  6 +-
 ...rect_map_kern.c => xdp_redirect_map.bpf.c} | 89 +++++--------------
 2 files changed, 25 insertions(+), 70 deletions(-)
 rename samples/bpf/{xdp_redirect_map_kern.c => xdp_redirect_map.bpf.c} (57%)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 43d3e52a8659..8faef4bcead4 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -163,7 +163,6 @@ always-y += tcp_clamp_kern.o
 always-y += tcp_basertt_kern.o
 always-y += tcp_tos_reflect_kern.o
 always-y += tcp_dumpstats_kern.o
-always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
@@ -357,6 +356,7 @@ endef
 CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
 
 $(obj)/xdp_redirect_cpu.bpf.o: $(obj)/xdp_sample.bpf.o
+$(obj)/xdp_redirect_map.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_redirect.bpf.o: $(obj)/xdp_sample.bpf.o
 $(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
 
@@ -368,10 +368,12 @@ $(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/x
 		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
 		-c $(filter %.bpf.c,$^) -o $@
 
-LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect.skel.h xdp_monitor.skel.h
+LINKED_SKELS := xdp_redirect_cpu.skel.h xdp_redirect_map.skel.h \
+		 xdp_redirect.skel.h xdp_monitor.skel.h
 clean-files += $(LINKED_SKELS)
 
 xdp_redirect_cpu.skel.h-deps := xdp_redirect_cpu.bpf.o xdp_sample.bpf.o
+xdp_redirect_map.skel.h-deps := xdp_redirect_map.bpf.o xdp_sample.bpf.o
 xdp_redirect.skel.h-deps := xdp_redirect.bpf.o xdp_sample.bpf.o
 xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
 
diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map.bpf.c
similarity index 57%
rename from samples/bpf/xdp_redirect_map_kern.c
rename to samples/bpf/xdp_redirect_map.bpf.c
index a92b8e567bdd..59efd656e1b2 100644
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
@@ -26,114 +22,71 @@ struct {
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
-	__uint(max_entries, 1);
-} rxcnt SEC(".maps");
-
-/* map to store egress interface mac address */
-struct {
-	__uint(type, BPF_MAP_TYPE_ARRAY);
-	__type(key, u32);
-	__type(value, __be64);
 	__uint(max_entries, 1);
-} tx_mac SEC(".maps");
-
-static void swap_src_dst_mac(void *data)
-{
-	unsigned short *p = data;
-	unsigned short dst[3];
+} tx_port_native SEC(".maps");
 
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
-
-	/* constant virtual port */
-	vport = 0;
-
-	/* count packet in global counter */
-	value = bpf_map_lookup_elem(&rxcnt, &key);
-	if (value)
-		*value += 1;
+		return XDP_DROP;
 
+	rec = bpf_map_lookup_elem(&rx_cnt, &key);
+	if (!rec)
+		return XDP_PASS;
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
-- 
2.33.0


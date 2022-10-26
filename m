Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B05A60DC86
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbiJZHvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbiJZHvZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:51:25 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CF919F769
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090a6b0d00b0021332e5388fso1425342pjj.1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuZCI5rm8dc1oWyYiTggf/OvLlqDlw76m69EATS+oUE=;
        b=0RZN1IwfVZk22lJYY0LWKEq6BZo2dfoEnk8g9QBGXzF1QW65nXwDH35Mhnm053Mgkb
         jxikm9Q7YK91TFuGqmLm9xWSxzcTs+jXHQel2/MwsMAxE/s2BcsefvVVJ7FfZfMFA5+4
         igoVsanSv0VAUtOLJTAPC8LM5nRC+mchmC1OZqVZCsjDDuE6TY0hlls2/fE/xfotHvYl
         Auf1hK2qb97GiG9wTECIS+1q+tujwYELk+IJChfB2rPNeBDOifLb30tEWDKTzLA3xVEk
         HmHoEVzEUaxRnN/TBICYhoa+Wr9m6AgHGpkAxeXNCU7Iog2TJFviXZ1Xa2/r7v9pVnBQ
         YBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JuZCI5rm8dc1oWyYiTggf/OvLlqDlw76m69EATS+oUE=;
        b=DpagNyrwaktIcWrVya2VIZihDNH6d4l04LckZh4YPU/rjHCA3u8sCNFNa1pHweKjR6
         gXtmTM308V8Gyz0P3hV8Pdp/NZYYIrMvx5/iz3u83jI4EsMr6H4vYvf24eZY1lrQCYLX
         kDH+5Ei0CWitTN/Vk6c57rQbw4iwieqLF7IF2DMR7YsNcQ1sPY1uEnFyhgEyRZj+0uLL
         eC1kvRe7EsEZyrkRIgDK9PqAoYOWOBlHsJElcGa3ZkW6DSKrQ22qhCXJxWm06J1zndiq
         R/qDssKwaKND50CsKaRrTj6KvULYHMVbXKuh2XsYWqmaNa/+8DhcYVYyj9w+bsyX1vu+
         BXng==
X-Gm-Message-State: ACrzQf2PwprZVKctL8utfNYUMhuIpZ5hxsvfjj9QPGlQ5KnDmfCno73G
        YOyq6oSkdmj3gR8opJbJDhdswhOWzrRk4g==
X-Google-Smtp-Source: AMsMyM7srAyrlmHma4SxMDTA74ZMLMf5cLHrHi0e/Chm/AWyEYC9weEnW9kr+bnf0uDAyigeAJV6HQ==
X-Received: by 2002:a17:902:8212:b0:186:a260:50a0 with SMTP id x18-20020a170902821200b00186a26050a0mr15692190pln.157.1666770681568;
        Wed, 26 Oct 2022 00:51:21 -0700 (PDT)
Received: from linkdev2.localdomain ([49.37.37.214])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b001714e7608fdsm2310913pld.256.2022.10.26.00.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 00:51:21 -0700 (PDT)
From:   Pratyush Kumar Khan <pratyush@sipanda.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     tom@sipanda.io, abuduri@ventanamicro.com, chethan@sipanda.io,
        Aravind Kumar Buduri <aravind.buduri@gmail.com>
Subject: [RFC PATCH 4/4] xdp: Support for flow_dissector as bpf helper function
Date:   Wed, 26 Oct 2022 13:20:54 +0530
Message-Id: <20221026075054.119069-5-pratyush@sipanda.io>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026075054.119069-1-pratyush@sipanda.io>
References: <20221026075054.119069-1-pratyush@sipanda.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aravind Kumar Buduri <aravind.buduri@gmail.com>

        xdp program which is loaded into the xdp hook
	calls the xdp helper function to get the metadata.

        bpf helper function prototype for flow dissector:
        long bpf_xdp_flow_dissector(struct xdp_buff *xdp_md,
                                    u32 flowd_sel,
				    void *buf, u32 len);
        xdp_md          - xdp buffer pointer
        flowd_sel       - key selection (either basic
			  keys(0) or big parser keys(1))
	buf             - received metadata buffer
        len             - size of the metadata buffer

        This helper parses a packet using the Flow dissector
	API.
        The metadata produced by the Flow dissecor is returned
	in the buf pointer whose size is len. The parameter
	flowd_sel will specify which type of keys(either basic
	keys or big parser keys) used for parsing.
   
        Below are the steps implemented,
        bpf xdp helper function is defined for the flow
	dissector.xdp frame is passed on to Flow dissector
	call and with keys(either basic keys or big parser
	keys).bpf helper function calls __skb_flow_dissector()
	with xdp buffer,keys and user specified buffer
	for metadata.
        xdp frame is passed via xdp helper function and metadata
	is populated in the user specified buffer.
       
        xdp user space component, which loads xdp kernel
	component into xdp hook and displays number of packets
	transmitted/received per second.

Signed-off-by: Aravind Kumar Buduri <aravind.buduri@gmail.com>
---
 include/uapi/linux/bpf.h              |  10 ++
 net/core/filter.c                     | 147 ++++++++++++++++++++++
 samples/bpf/Makefile                  |   3 +
 samples/bpf/xdp_flow_dissector_kern.c |  91 ++++++++++++++
 samples/bpf/xdp_flow_dissector_user.c | 170 ++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h        |  10 ++
 6 files changed, 431 insertions(+)
 create mode 100644 samples/bpf/xdp_flow_dissector_kern.c
 create mode 100644 samples/bpf/xdp_flow_dissector_user.c

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b88d0aa689a9..24f48268268c 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5444,6 +5444,15 @@ union bpf_attr {
  *              in *buf* of *len* bytes.
  *      Return
  *              0 on success, or a negative error in case of failure.
+ *
+ * long bpf_xdp_flow_dissector(struct xdp_buff *xdp_md, u32 flowd_sel, void *buf, u32 len)
+ *      Description
+ *              This helper is provided as an easy way to parse the metadata
+ *              and test the functionality. The frame associated to *xdp_md*,
+ *              choosing flowd *flowd_sel* and metadata is stored in *buf* of
+ *              *len* bytes.
+ *      Return
+ *              0 on success, or a negative error in case of failure.
  */
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5657,6 +5666,7 @@ union bpf_attr {
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(xdp_kparser, 210, ##ctx)			\
+	FN(xdp_flow_dissector, 211, ##ctx)		\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
diff --git a/net/core/filter.c b/net/core/filter.c
index 98b884123814..ffd290914de8 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3984,6 +3984,149 @@ static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
+#if IS_ENABLED(CONFIG_KPARSER)
+static int xdp_flow_dissector(struct xdp_buff *xdp, u32 flowd_sel, void *buf, u32 len)
+{
+	void *data = xdp->data;
+	struct ethhdr *eth = (struct ethhdr *)data;
+	ktime_t start_time, stop_time, elapsed_time;
+	struct iphdr *ip = data + sizeof(*eth);
+	struct flow_keys_basic keys;
+	struct vlan_hdr *vlan_hdr;
+	unsigned short  proto;
+	struct flow_keys flow;
+	struct flow_keys *flowptr = &flow;
+	struct ipv6hdr *ip6h;
+	struct arphdr  *arph;
+	int nh_off;
+	int hlen;
+	bool ret;
+
+	proto =  eth->h_proto;
+
+	if (!buf || flowd_sel > 0xffff || len > 0xffff) {
+		pr_err("\n%s %d len =\n ", __func__, __LINE__);
+		return -EINVAL;
+	}
+	if (flowd_sel == 0) {
+		if (len < sizeof(struct flow_keys_basic)) {
+			pr_err("\n%s %d len = %d size flow_keys_basic= %d len error\n",
+			       __func__, __LINE__, sizeof(struct flow_keys_basic));
+			return -EINVAL;
+		}
+	} else if (flowd_sel == 1) {
+		if (len < sizeof(struct flow_keys)) {
+			pr_err("\n%s %d len = %d size flow_keys= %d len error\n",
+			       __func__, __LINE__, sizeof(struct flow_keys));
+			return -EINVAL;
+		}
+	}
+	nh_off = sizeof(*eth);
+#if KPARSER_DEBUG
+	pr_debug("\n%s nh_off = %d hlen= %d\n",	__func__, nh_off, hlen);
+	pr_debug("%s proto = %d htons(ETH_P_IP)= %d\n",
+		 __func__, proto, htons(ETH_P_IP));
+	pr_debug("%s eth->h_proto = %d ETH_P_IP= %d\n",
+		 __func__, eth->h_proto, ETH_P_IP);
+#endif
+	/* Extract L3 protocol */
+	switch (proto) {
+	case htons(ETH_P_8021Q):
+		hlen = sizeof(*eth) + sizeof(*vlan_hdr);
+		break;
+	case htons(ETH_P_IP):
+		hlen = sizeof(*eth) + sizeof(*ip);
+		break;
+	case htons(ETH_P_IPV6):
+		hlen = sizeof(*eth) + sizeof(*ip6h);
+		break;
+	case htons(ETH_P_ARP):
+		hlen = sizeof(*eth) + sizeof(*arph);
+		break;
+	default:
+		break;
+	}
+
+	if (flowd_sel == 0) {
+		memset(&keys, 0, sizeof(keys));
+		start_time = ktime_get();
+		ret = __skb_flow_dissect(NULL, NULL, &flow_keys_basic_dissector,
+					 &keys, data, proto, nh_off, hlen, 0);
+		stop_time = ktime_get();
+		elapsed_time = ktime_sub(stop_time, start_time);
+		pr_err("elapsed Time : %lld\n",  ktime_to_ns(elapsed_time));
+		if (ret == true) {
+#if KPARSER_DEBUG
+			pr_debug("\n%d %s keys.control.thoff= %d\n",
+				 __LINE__, __func__, keys.control.thoff);
+			pr_debug("%d %s keys.control.addr_type= %d\n",
+				 __LINE__, __func__, keys.control.addr_type);
+			pr_debug("%d %s keys.control.flags= %d\n",
+				 __LINE__, __func__, keys.control.flags);
+			pr_debug("%d %s keys.basic.n_proto= 0x0x\n",
+				 __LINE__, __func__, ntohs(keys.basic.n_proto));
+			pr_debug("%d %s keys.basic.ip_proto= %d\n",
+				 __LINE__, __func__, keys.basic.ip_proto);
+#endif
+		}
+		memcpy((char *)buf, &keys, sizeof(keys));
+		return 0;
+	} else if (flowd_sel == 1) {
+		memset(&flow, 0, sizeof(flow));
+#if KPARSER_DEBUG
+		start_time = ktime_get();
+#endif
+		ret = __skb_flow_dissect(NULL, NULL, &flow_keys_dissector,
+					 &flow, data, proto, nh_off, hlen, 0);
+#if KPARSER_DEBUG
+		stop_time = ktime_get();
+		elapsed_time = ktime_sub(stop_time, start_time);
+		pr_debug("elapsed Time : %lld\n",  ktime_to_ns(elapsed_time));
+#endif
+		if (ret == true) {
+#if KPARSER_DEBUG
+			pr_debug("%d %s control.thoff= %d\n",
+				 __LINE__, __func__, flowptr->control.thoff);
+			pr_debug("%d %s keys.control.addr_type= %d\n",
+				 __LINE__, __func__, flowptr->control.addr_type);
+			pr_debug("%d %s keys.control.flags= %d\n",
+				 __LINE__, __func__, flowptr->control.flags);
+			pr_debug("%d %s flowptr->basic.n_proto= 0x0%x\n",
+				 __LINE__, __func__, ntohs(flowptr->basic.n_proto));
+			pr_debug("%d %s flowptr->basic.ip_proto= %d\n",
+				 __LINE__, __func__, flowptr->basic.ip_proto);
+			pr_debug("%d %s flowptr->addrs.v4addrs.src = %pI4\n",
+				 __LINE__, __func__, &flowptr->addrs.v4addrs.src);
+			pr_debug("%d %s flowptr->addrs.v4addrs.dst = %pI4\n",
+				 __LINE__, __func__, &flowptr->addrs.v4addrs.dst);
+#endif
+		}
+		memcpy((char *)buf, &flow, sizeof(flow));
+		return 0;
+	}
+	return 0;
+}
+
+BPF_CALL_4(bpf_xdp_flow_dissector, struct xdp_buff *, xdp, u32, flowd_sel,
+	   void *, buf, u32, len)
+{
+	int ret;
+
+	ret = xdp_flow_dissector(xdp, flowd_sel, buf, len);
+	return ret;
+}
+
+const struct bpf_func_proto bpf_xdp_flow_dissector_proto = {
+	.func           = bpf_xdp_flow_dissector,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_ANYTHING,
+	.arg3_type      = ARG_PTR_TO_UNINIT_MEM,
+	.arg4_type      = ARG_CONST_SIZE,
+};
+#endif
+
 #if IS_ENABLED(CONFIG_KPARSER)
 struct get_kparser_funchooks kparser_funchooks = {
 	.kparser_get_parser_hook = NULL,
@@ -8076,6 +8219,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 #if IS_ENABLED(CONFIG_KPARSER)
 	case BPF_FUNC_xdp_kparser:
 		return &bpf_xdp_kparser_proto;
+#endif
+#if IS_ENABLED(CONFIG_KPARSER)
+	case BPF_FUNC_xdp_flow_dissector:
+		return &bpf_xdp_flow_dissector_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 0777447b7c88..108e29d097dc 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -47,6 +47,7 @@ tprogs-y += cpustat
 tprogs-y += xdp_adjust_tail
 tprogs-y += xdp_fwd
 tprogs-y += xdp_kparser
+tprogs-y += xdp_flow_dissector
 tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
@@ -108,6 +109,7 @@ syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
 xdp_adjust_tail-objs := xdp_adjust_tail_user.o
 xdp_kparser-objs := xdp_kparser_user.o
+xdp_flow_dissector-objs := xdp_flow_dissector_user.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o
@@ -171,6 +173,7 @@ always-y += cpustat_kern.o
 always-y += xdp_adjust_tail_kern.o
 always-y += xdp_fwd_kern.o
 always-y += xdp_kparser_kern.o
+always-y += xdp_flow_dissector_kern.o
 always-y += task_fd_query_kern.o
 always-y += xdp_sample_pkts_kern.o
 always-y += ibumad_kern.o
diff --git a/samples/bpf/xdp_flow_dissector_kern.c b/samples/bpf/xdp_flow_dissector_kern.c
new file mode 100644
index 000000000000..778e65c3b039
--- /dev/null
+++ b/samples/bpf/xdp_flow_dissector_kern.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022-23 Aravind Kumar Buduri <aravind.buduri@gmail.com>
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
+#include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <bpf/bpf_helpers.h>
+#include <net/flow_dissector.h>
+
+#define FLOWD_DEBUG 0
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, __u64);
+	__uint(max_entries, 1);
+} counter_map SEC(".maps");
+
+u64 *counter;
+u64 pkts;
+
+void count_pkts(void)
+{
+	u32 key = 0;
+
+	counter = bpf_map_lookup_elem(&counter_map, &key);
+	if (counter) {
+		*counter += 1;
+		pkts = *counter;
+	}
+}
+
+void dump_flowd_user_buf(void *buf, int len)
+{
+	struct flow_keys *flowptr = (struct flow_keys *)buf;
+
+	if (!buf || len < sizeof(*flowptr)) {
+		bpf_printk(" Insufficient buffer\n");
+		return;
+	}
+#if FLOWD_DEBUG
+	bpf_printk("pkts received = %lu\n ", pkts);
+	bpf_printk("control.thoff= %d\n ",
+			flowptr->control.thoff);
+	bpf_printk("keys.control.addr_type= %d\n ",
+			flowptr->control.addr_type);
+	bpf_printk("keys.control.flags= %d\n ",
+			flowptr->control.flags);
+	bpf_printk("flowptr->basic.n_proto= 0x0%x\n ",
+			ntohs(flowptr->basic.n_proto));
+	bpf_printk("flowptr->basic.ip_proto= %d\n ",
+			flowptr->basic.ip_proto);
+	bpf_printk("flowptr->addrs.v4addrs.src = %pi4\n ",
+			&flowptr->addrs.v4addrs.src);
+	bpf_printk("flowptr->addrs.v4addrs.dst = %pi4\n ",
+			&flowptr->addrs.v4addrs.dst);
+#endif
+
+}
+
+char arr1[512] = {0};
+
+SEC("prog")
+int xdp_flowd_prog(struct xdp_md *ctx)
+{
+	/*
+	 * code for flow dissector
+	 * 2nd parameter differenciate flow dissector selection
+	 * 0 - basic key flow dissector
+	 * 1 - big key flow dissector
+	 */
+	bpf_xdp_flow_dissector(ctx, 1, arr1, 512);
+	count_pkts();
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_flow_dissector_user.c b/samples/bpf/xdp_flow_dissector_user.c
new file mode 100644
index 000000000000..7fc1be3f6f14
--- /dev/null
+++ b/samples/bpf/xdp_flow_dissector_user.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2022-23 Aravind Kumar Buduri <aravind.buduri@gmail.com>
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
+#include <net/if.h>
+#include <locale.h>
+#include "bpf_util.h"
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+
+static int ifindex;
+static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static __u32 prog_id;
+
+static void poll_stats(int map_fd, int interval)
+{
+	unsigned int nr_cpus = bpf_num_possible_cpus();
+	__u64 values[nr_cpus], prev[UINT8_MAX] = { 0 };
+	int i;
+	__u32 key = UINT32_MAX;
+
+	while (1) {
+		sleep(interval);
+		if (bpf_map_get_next_key(map_fd, &key, &key) != -1) {
+			__u64 sum = 0;
+
+			assert(bpf_map_lookup_elem(map_fd, &key, values) == 0);
+			for (i = 0; i < nr_cpus; i++)
+				sum += values[i];
+			if (sum > prev[key])
+				printf(" packet rate =%10llu pkt/s\n",
+						(sum - prev[key]) / interval);
+			prev[key] = sum;
+		}
+	}
+}
+
+static void int_exit(int sig)
+{
+	__u32 curr_prog_id = 0;
+
+	if (bpf_xdp_query_id(ifindex, xdp_flags, &curr_prog_id)) {
+		printf("bpf_xdp_query_id failed\n");
+		exit(1);
+	}
+	if (prog_id == curr_prog_id)
+		bpf_xdp_detach(ifindex, xdp_flags, NULL);
+	else if (!curr_prog_id)
+		printf("couldn't find a prog id on a given interface\n");
+	else
+		printf("program on interface changed, not removing\n");
+	exit(0);
+}
+
+static void usage(const char *prog)
+{
+	fprintf(stderr,
+		"usage: %s [OPTS] IFACE\n\n"
+		"OPTS:\n"
+		"    -S    use skb-mode\n"
+		"    -N    enforce native mode\n"
+		"    -F    force loading prog\n",
+		prog);
+}
+
+int main(int argc, char **argv)
+{
+	struct bpf_prog_info info = {};
+	__u32 info_len = sizeof(info);
+	const char *optstr = "FSN";
+	int prog_fd, map_fd, opt;
+	struct bpf_program *prog;
+	struct bpf_object *obj;
+	struct bpf_map *map;
+	char filename[256];
+	int err;
+
+	while ((opt = getopt(argc, argv, optstr)) != -1) {
+		switch (opt) {
+		case 'S':
+			xdp_flags |= XDP_FLAGS_SKB_MODE;
+			break;
+		case 'N':
+			/* default, set below */
+			break;
+		case 'F':
+			xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;
+			break;
+		default:
+			usage(basename(argv[0]));
+			return 1;
+		}
+	}
+
+	if (!(xdp_flags & XDP_FLAGS_SKB_MODE))
+		xdp_flags |= XDP_FLAGS_DRV_MODE;
+
+	if (optind == argc) {
+		usage(basename(argv[0]));
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
+	obj = bpf_object__open_file(filename, NULL);
+	if (libbpf_get_error(obj))
+		return 1;
+
+	prog = bpf_object__next_program(obj, NULL);
+	bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
+
+	err = bpf_object__load(obj);
+	if (err)
+		return 1;
+
+	prog_fd = bpf_program__fd(prog);
+
+	map = bpf_object__next_map(obj, NULL);
+	if (!map) {
+		printf("finding a map in obj file failed\n");
+		return 1;
+	}
+	map_fd = bpf_map__fd(map);
+
+	if (!prog_fd) {
+		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
+		return 1;
+	}
+
+	signal(SIGINT, int_exit);
+	signal(SIGTERM, int_exit);
+
+	if (bpf_xdp_attach(ifindex, prog_fd, xdp_flags, NULL) < 0) {
+		printf("link set xdp fd failed\n");
+		return 1;
+	}
+
+	err = bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
+	if (err) {
+		printf("can't get prog info - %s\n", strerror(errno));
+		return err;
+	}
+	prog_id = info.id;
+	poll_stats(map_fd, 1);
+
+	return 0;
+}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b88d0aa689a9..24f48268268c 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5444,6 +5444,15 @@ union bpf_attr {
  *              in *buf* of *len* bytes.
  *      Return
  *              0 on success, or a negative error in case of failure.
+ *
+ * long bpf_xdp_flow_dissector(struct xdp_buff *xdp_md, u32 flowd_sel, void *buf, u32 len)
+ *      Description
+ *              This helper is provided as an easy way to parse the metadata
+ *              and test the functionality. The frame associated to *xdp_md*,
+ *              choosing flowd *flowd_sel* and metadata is stored in *buf* of
+ *              *len* bytes.
+ *      Return
+ *              0 on success, or a negative error in case of failure.
  */
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5657,6 +5666,7 @@ union bpf_attr {
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
 	FN(xdp_kparser, 210, ##ctx)			\
+	FN(xdp_flow_dissector, 211, ##ctx)		\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
-- 
2.34.1


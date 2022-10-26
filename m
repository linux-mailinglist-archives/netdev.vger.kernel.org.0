Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710CD60DC84
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiJZHv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbiJZHvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:51:23 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B07697D42
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id b29so10088540pfp.13
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sipanda-io.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZHMbWA1YIfQyBW74SEpUanplgfNuRf18Rn1cev4gkyw=;
        b=CfyQ8P2RCT0Quypw1rYTtBQxRw/wC+gSSWT5A67FbCG8GnB5qxH5txGdZsgJp5xeY5
         qd8yLiUsOhEBTwjhDxLygQHdptun9Bdp93fI8kzCq8VLVVpDMFlZSet32WaSskrkijwB
         rEbvWXZlTrWHIq6WZkyIvfAp5ye63HSBCRI3XAhmsSpT1Y4l0T3i5Bx5ZNEnAT64uLcq
         KnNvUcVTVwABVSAZDGgJkwCq1i53m2qGpNDJEXWhMes/MkWHgq7A0iCdhIDOowbJZBnq
         Jp1OAlzUX3jdgYEj97o1YpmaghiZeE/vttb6Jiu3lMqGxuzepfIKH9+7ppWFeZ8CI+4G
         FrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZHMbWA1YIfQyBW74SEpUanplgfNuRf18Rn1cev4gkyw=;
        b=pjcpkLGfye+D1egGylTVQdSozyIw5aNY7P2W4L422slv+vZd2dQfQIqOUHcPk8bS41
         GoZsus2hXSx8F0g27DROL31Z3WcaQYx85zksg9AHWPh0NzHa2AsiXdc5/GzLsJ24u2L5
         9dVGUtcwI8JqPn1Z1C/Hg0Kk7IpeFCHRx5DRQl8pg0TX8lx+2q3foL6hBDdSqugFUSkO
         a9uCesgxJIvmJvhqLifbn3fznZ2HvFxJCzteWtIYDkXwgzW0vqo56nBX9wg5q2lKz2Vo
         nxyjtpy0x4gec/SlElI/bq6X79Fqyg6rRtXkf7uI9XoI5sdQ68U1QpkS8IZbmJsqY9lI
         w/tg==
X-Gm-Message-State: ACrzQf2ugxq5DEEgApbJtqfW/B7GDtoXJNr1YbL7ec3rVHG73IPjkk7n
        jpl86NS4Xv7aQaHw7I6nuYAeXBALWNcZaw==
X-Google-Smtp-Source: AMsMyM7tghnDDSABEjzdcsfz+ABuYWs83mRJauhX+mwaipQw40RNQfFVk4W2p/Lku2/qO5BQVYgiwA==
X-Received: by 2002:a05:6a00:1912:b0:564:f6be:11fd with SMTP id y18-20020a056a00191200b00564f6be11fdmr41954871pfi.32.1666770677539;
        Wed, 26 Oct 2022 00:51:17 -0700 (PDT)
Received: from linkdev2.localdomain ([49.37.37.214])
        by smtp.gmail.com with ESMTPSA id w20-20020a170902ca1400b001714e7608fdsm2310913pld.256.2022.10.26.00.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 00:51:17 -0700 (PDT)
From:   Pratyush Kumar Khan <pratyush@sipanda.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     tom@sipanda.io, abuduri@ventanamicro.com, chethan@sipanda.io,
        Aravind Kumar Buduri <aravind.buduri@gmail.com>
Subject: [RFC PATCH 3/4] xdp: Support for kParser as bpf helper function
Date:   Wed, 26 Oct 2022 13:20:53 +0530
Message-Id: <20221026075054.119069-4-pratyush@sipanda.io>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221026075054.119069-1-pratyush@sipanda.io>
References: <20221026075054.119069-1-pratyush@sipanda.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aravind Kumar Buduri <aravind.buduri@gmail.com>

	This patch adds an XDP helper to parse packets
	using the kParser. The metadata produced by the
	kParser is returned in the buf pointer whose
	size is len. conf provides a key that
	identifies the kParser to invoke and conf_len
	is the length of the key.
	The sample xdp program is loaded into xdp hook
	calls xdp helper function to get the metadata.

	bpf helper function prototype for kParser.
	long bpf_xdp_kparser(struct xdp_buff *xdp_md,
			     void *conf, u32 conf_len,
			     void *buf, u32 len);
            xdp_md          - xdp buffer pointer
            conf            - kParser parser identifier
			      (hash key,name)
            conf_len        - size of conf in bytes
            buf             - metadata buffer to pass
			      to kparser
            len             - metadata size in bytes

	This helper parses a packet using the kParser.
	The metadata produced by the parser is returned
	in the buf pointer whose size is len. conf provides
	a key that identifies the parser to invoke and
	conf_len is the length of the key

	metadata is mapped to bpf map.So that user space bpf
        program or bpftool can read the map(metadata is
        displayed in BTF format).

        funchooks are callbacks for packet parsing functions
	of the kParser module and will be populated after
	the kParser module is loaded.

        bpf xdp helper function is defined for kernel
	parser(kParser).
        kParser is configured via userspace ip command.
        kParser data path API's as mentioned in kparser.h are
	invoked using registered callback hooks.
        xdp frame is passed on to kParser via the xdp helper function
        and metadata is populated in the user specified buffer.

        xdp user space component, which loads xdp kernel component
        into xdp hook and displays number of packets
        transmitted/received per second.

Signed-off-by: Aravind Kumar Buduri <aravind.buduri@gmail.com>
---
 include/uapi/linux/bpf.h       |  10 ++
 net/core/filter.c              |  97 +++++++++++++++++++
 samples/bpf/Makefile           |   3 +
 samples/bpf/metadata_def.h     |  21 ++++
 samples/bpf/xdp_kparser_kern.c |  94 ++++++++++++++++++
 samples/bpf/xdp_kparser_user.c | 171 +++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/bpf.h |  10 ++
 7 files changed, 406 insertions(+)
 create mode 100644 samples/bpf/metadata_def.h
 create mode 100644 samples/bpf/xdp_kparser_kern.c
 create mode 100644 samples/bpf/xdp_kparser_user.c

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 17f61338f8f8..b88d0aa689a9 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5435,6 +5435,15 @@ union bpf_attr {
  *		**-E2BIG** if user-space has tried to publish a sample which is
  *		larger than the size of the ring buffer, or which cannot fit
  *		within a struct bpf_dynptr.
+ *
+ * long bpf_xdp_kparser(struct xdp_buff *xdp_md, void *conf, u32 conf_len, void *buf, u32 len)
+ *      Description
+ *              This helper is provided as an easy way to parse the metadata in
+ *              xdp buffer .The frame associated to *xdp_md*,configuration *conf*
+ *              config len of *conf_len* and metadata is stored
+ *              in *buf* of *len* bytes.
+ *      Return
+ *              0 on success, or a negative error in case of failure.
  */
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5647,6 +5656,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6, 207, ##ctx)	\
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
+	FN(xdp_kparser, 210, ##ctx)			\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
diff --git a/net/core/filter.c b/net/core/filter.c
index bb0136e7a8e4..98b884123814 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -81,6 +81,13 @@
 #include <net/xdp.h>
 #include <net/mptcp.h>
 
+#if IS_ENABLED(CONFIG_KPARSER)
+#include <linux/kparser.h>
+#include <net/kparser.h>
+#include <linux/rhashtable.h>
+#include <linux/ktime.h>
+#define KPARSER_DEBUG 1
+#endif
 static const struct bpf_func_proto *
 bpf_sk_base_func_proto(enum bpf_func_id func_id);
 
@@ -3977,6 +3984,92 @@ static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
+#if IS_ENABLED(CONFIG_KPARSER)
+struct get_kparser_funchooks kparser_funchooks = {
+	.kparser_get_parser_hook = NULL,
+	.__kparser_parse_hook = NULL,
+	.kparser_put_parser_hook = NULL,
+};
+EXPORT_SYMBOL_GPL(kparser_funchooks);
+
+int kparser_xdp_parse(struct xdp_buff *xdp, void *conf, size_t conf_len,
+		      void *_metadata, size_t metadata_len)
+{
+	struct kparser_hkey *keyptr = (struct kparser_hkey *)conf;
+	ktime_t start_time, stop_time, elapsed_time;
+	struct kparser_hkey key;
+	const void *parser;
+	void *data;
+	int pktlen;
+	int rc = 0;
+
+	key.id = keyptr->id;
+	strcpy(key.name, keyptr->name);
+	pktlen = xdp_get_buff_len(xdp);
+	data = (void *)(long)xdp->data;
+	if (!kparser_funchooks.kparser_get_parser_hook) {
+		pr_err("\n kparser module not loaded\n");
+		return -EINVAL;
+	} else {
+		parser = kparser_funchooks.kparser_get_parser_hook(&key);
+		if (!parser) {
+			pr_err("kparser_get_parser() failed, key:{%s:%u}\n",
+			       key.name, key.id);
+			return -EINVAL;
+		}
+	}
+
+	if (!kparser_funchooks.__kparser_parse_hook) {
+		pr_err("\n kparser module not loaded\n");
+		return -EINVAL;
+	} else {
+#if KPARSER_DEBUG
+		start_time = ktime_get();
+#endif
+		rc = kparser_funchooks.__kparser_parse_hook(parser, data, pktlen,
+							    _metadata, metadata_len);
+#if KPARSER_DEBUG
+		stop_time = ktime_get();
+		elapsed_time = ktime_sub(stop_time, start_time);
+		pr_err("elapsedTime : %lld\n",  ktime_to_ns(elapsed_time));
+#endif
+		if (!kparser_funchooks.kparser_put_parser_hook) {
+			pr_err("\n kparser module not loaded\n");
+			return -EINVAL;
+		} else {
+			if (kparser_funchooks.kparser_put_parser_hook(parser) != true)
+				pr_err("kparser_put_parser() failed\n");
+		}
+#if KPARSER_DEBUG
+		pr_debug("%s:rc:{%d:%s}\n", __func__, rc, kparser_code_to_text(rc));
+#endif
+	}
+	return rc;
+}
+
+BPF_CALL_5(bpf_xdp_kparser, struct xdp_buff *, xdp, void *, conf,
+	   u32, conf_len, void *, buf, u32, len)
+{
+	int len1;
+	int err;
+
+	len1 = xdp_get_buff_len(xdp);
+	err = kparser_xdp_parse(xdp, conf, conf_len, buf, len);
+	return 0;
+}
+
+const struct bpf_func_proto bpf_xdp_kparser_proto = {
+	.func           = bpf_xdp_kparser,
+	.gpl_only       = false,
+	.ret_type       = RET_INTEGER,
+	.arg1_type      = ARG_PTR_TO_CTX,
+	.arg2_type      = ARG_PTR_TO_MEM | MEM_RDONLY,
+	.arg3_type      = ARG_CONST_SIZE,
+	.arg4_type      = ARG_PTR_TO_UNINIT_MEM,
+	.arg5_type      = ARG_CONST_SIZE,
+};
+#endif
+
 static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 {
 	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
@@ -7979,6 +8072,10 @@ xdp_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
 	case BPF_FUNC_tcp_raw_check_syncookie_ipv6:
 		return &bpf_tcp_raw_check_syncookie_ipv6_proto;
 #endif
+#endif
+#if IS_ENABLED(CONFIG_KPARSER)
+	case BPF_FUNC_xdp_kparser:
+		return &bpf_xdp_kparser_proto;
 #endif
 	default:
 		return bpf_sk_base_func_proto(func_id);
diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 727da3c5879b..0777447b7c88 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -46,6 +46,7 @@ tprogs-y += syscall_tp
 tprogs-y += cpustat
 tprogs-y += xdp_adjust_tail
 tprogs-y += xdp_fwd
+tprogs-y += xdp_kparser
 tprogs-y += task_fd_query
 tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
@@ -106,6 +107,7 @@ xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
 xdp_adjust_tail-objs := xdp_adjust_tail_user.o
+xdp_kparser-objs := xdp_kparser_user.o
 xdp_fwd-objs := xdp_fwd_user.o
 task_fd_query-objs := task_fd_query_user.o $(TRACE_HELPERS)
 xdp_sample_pkts-objs := xdp_sample_pkts_user.o
@@ -168,6 +170,7 @@ always-y += syscall_tp_kern.o
 always-y += cpustat_kern.o
 always-y += xdp_adjust_tail_kern.o
 always-y += xdp_fwd_kern.o
+always-y += xdp_kparser_kern.o
 always-y += task_fd_query_kern.o
 always-y += xdp_sample_pkts_kern.o
 always-y += ibumad_kern.o
diff --git a/samples/bpf/metadata_def.h b/samples/bpf/metadata_def.h
new file mode 100644
index 000000000000..114849d04e12
--- /dev/null
+++ b/samples/bpf/metadata_def.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause) */
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
+struct user_frame {
+	unsigned short ip_offset;
+	unsigned short l4_offset;
+	unsigned int ipv4_addrs[2];
+	unsigned short ports[2];
+} __packed;
+
+struct user_metadata {
+	struct user_frame frames;
+} __packed;
diff --git a/samples/bpf/xdp_kparser_kern.c b/samples/bpf/xdp_kparser_kern.c
new file mode 100644
index 000000000000..bc4146bc3a94
--- /dev/null
+++ b/samples/bpf/xdp_kparser_kern.c
@@ -0,0 +1,94 @@
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
+
+#define KBUILD_MODNAME "foo"
+#include <uapi/linux/bpf.h>
+#include <linux/in.h>
+#include <linux/if_ether.h>
+#include <linux/if_packet.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/kparser.h>
+#include <bpf/bpf_helpers.h>
+#include "metadata_def.h"
+#define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
+#define DEBUG 0
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
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 2);
+	__type(key, __u32);
+	__type(value, struct user_metadata);
+} ctx_map SEC(".maps");
+
+static __always_inline void xdp_update_ctx(const void *buffer, size_t len)
+{
+	const struct user_metadata *buf = buffer;
+	__u32 key = 1;
+
+	if (!buf || len < sizeof(*buf)) {
+		bpf_printk("Insufficient buffer error\n");
+		return;
+	}
+	bpf_map_update_elem(&ctx_map, &key, buf, BPF_ANY);
+}
+
+static struct user_metadata user_metadata_buffer;
+static struct kparser_hkey key;
+
+SEC("prog")
+int xdp_parser_prog(struct xdp_md *ctx)
+{
+	/* prepare a parser key which is already created and configured via the ip cli */
+	key.id = 0xffff;
+	strcpy(key.name, "tuple_parser");
+
+	/* set all bits to 1 in user metadata buffer to easily determine later which
+	 * fields were set/updated by kParser KMOD
+	 */
+	memset(&user_metadata_buffer, 0xff, sizeof(user_metadata_buffer));
+
+	bpf_xdp_kparser(ctx, &key, sizeof(key), &user_metadata_buffer,
+			sizeof(user_metadata_buffer));
+
+	/* now dump the metadata to be displayed by bpftool */
+	xdp_update_ctx(&user_metadata_buffer, sizeof(user_metadata_buffer));
+
+	/* count how many packets were processed in this interval */
+	count_pkts();
+
+	return XDP_PASS;
+}
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_kparser_user.c b/samples/bpf/xdp_kparser_user.c
new file mode 100644
index 000000000000..0ebcadce0431
--- /dev/null
+++ b/samples/bpf/xdp_kparser_user.c
@@ -0,0 +1,171 @@
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
+
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 17f61338f8f8..b88d0aa689a9 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -5435,6 +5435,15 @@ union bpf_attr {
  *		**-E2BIG** if user-space has tried to publish a sample which is
  *		larger than the size of the ring buffer, or which cannot fit
  *		within a struct bpf_dynptr.
+ *
+ * long bpf_xdp_kparser(struct xdp_buff *xdp_md, void *conf, u32 conf_len, void *buf, u32 len)
+ *      Description
+ *              This helper is provided as an easy way to parse the metadata in
+ *              xdp buffer .The frame associated to *xdp_md*,configuration *conf*
+ *              config len of *conf_len* and metadata is stored
+ *              in *buf* of *len* bytes.
+ *      Return
+ *              0 on success, or a negative error in case of failure.
  */
 #define ___BPF_FUNC_MAPPER(FN, ctx...)			\
 	FN(unspec, 0, ##ctx)				\
@@ -5647,6 +5656,7 @@ union bpf_attr {
 	FN(tcp_raw_check_syncookie_ipv6, 207, ##ctx)	\
 	FN(ktime_get_tai_ns, 208, ##ctx)		\
 	FN(user_ringbuf_drain, 209, ##ctx)		\
+	FN(xdp_kparser, 210, ##ctx)			\
 	/* */
 
 /* backwards-compatibility macros for users of __BPF_FUNC_MAPPER that don't
-- 
2.34.1


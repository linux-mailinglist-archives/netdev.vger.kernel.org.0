Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83BA3F378E
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhHUAVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbhHUAVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:05 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32ACC06175F;
        Fri, 20 Aug 2021 17:20:26 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id m26so10014557pff.3;
        Fri, 20 Aug 2021 17:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aIdOzPOyt5RWS2jcpOyOOwqGZSP27eRqXGJRYx8ozC0=;
        b=kPh2noo7u8xW1KhmPGVdFH+w3ryckLvKKYa9cn94tnSO46Y/mklLLKylEbTSEe3wCp
         tayOj9/y96XMqZxFxa1leXxyTw2Bg+ixo+Gw4StTDsnPTcyHKepLhxaPsaWjaQjLcAmj
         YW4kg0uyTwWR/dFe7ZBQ1KUM5t/LCxedo9DDLxDB+9urJAzYe3PDnOG98oXtVbaymBDA
         Kz6+lNm20Guw/wayPHCMUIR27FfgQi66sE3x4OdF0C6uzM38isyXLX+RSZaxZUEPdjGK
         ek0cNYMtFvwRYKHEagK9kw7R9Q5LSpqoB8wlrKSXebw98DZlWgRr2JVvY0Q53TzfGt4K
         fS7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aIdOzPOyt5RWS2jcpOyOOwqGZSP27eRqXGJRYx8ozC0=;
        b=cm35XHqUHUAxye/u3FdKRNJohRGIbL6up1U7mXuZVDmlrgw2XZQr0Q8wJcM6X+ftrr
         BSPUuB3rf660Hmd6wMBckB3xs6cJqYxJJLZGaarDTCrA/AOgEWzBR+2i46rdMqT1FmWm
         3KQtfcJoplaEmUWSfKALhnWLPjw8A3wqtRLS3FGGFrw2GhX0xn7ooYIyxN5y9Ib6p6mB
         GCzajNJ4jDx1SNhfG+ZvuA23EXoee8G2JzKKUTXrNWNl7THlOMEYfi87YZ4/pN5bMTll
         qDI92hWRtaIms7xZLDhhmcUspmXYDP27+em+gG3TDpGyomMIpAfYiSXUarr4kal1liNT
         nYXw==
X-Gm-Message-State: AOAM533ZC29f4Wj0veYZsLGKYqx1BasyVqg3THjf1W6CKgyTS7Gk4sDC
        mUbZxmkS7tLrhaczlErzvxIYaSuKgnM=
X-Google-Smtp-Source: ABdhPJwrrl628l3vbR3gtxT3DIpAjwWUr5/12vPJl4SG78iz/2A3KfrA40eokVx6LZ+3YXfauA/tAA==
X-Received: by 2002:a63:ee03:: with SMTP id e3mr21002423pgi.386.1629505226115;
        Fri, 20 Aug 2021 17:20:26 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id f9sm12979258pjq.36.2021.08.20.17.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:25 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 04/22] samples: bpf: Add BPF support for redirect tracepoint
Date:   Sat, 21 Aug 2021 05:49:52 +0530
Message-Id: <20210821002010.845777-5-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the shared BPF file that will be used going forward for
sharing tracepoint programs among XDP redirect samples.

Since vmlinux.h conflicts with tools/include for READ_ONCE/WRITE_ONCE
and ARRAY_SIZE, they are copied in to xdp_sample.bpf.h along with other
helpers that will be required.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_sample.bpf.c | 112 ++++++++++++++++++++++++++++
 samples/bpf/xdp_sample.bpf.h | 141 +++++++++++++++++++++++++++++++++++
 2 files changed, 253 insertions(+)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h

diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
new file mode 100644
index 000000000000..e22f2a97a988
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
+#include "xdp_sample.bpf.h"
+
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+array_map rx_cnt SEC(".maps");
+array_map redir_err_cnt SEC(".maps");
+
+const volatile int nr_cpus = 0;
+
+/* These can be set before loading so that redundant comparisons can be DCE'd by
+ * the verifier, and only actual matches are tried after loading tp_btf program.
+ * This allows sample to filter tracepoint stats based on net_device.
+ */
+const volatile int from_match[32] = {};
+const volatile int to_match[32] = {};
+
+/* Find if b is part of set a, but if a is empty set then evaluate to true */
+#define IN_SET(a, b)                                                 \
+	({                                                           \
+		bool __res = !(a)[0];                                \
+		for (int i = 0; i < ARRAY_SIZE(a) && (a)[i]; i++) { \
+			__res = (a)[i] == (b);                       \
+			if (__res)                                   \
+				break;                               \
+		}                                                    \
+		__res;                                               \
+	})
+
+static __always_inline __u32 xdp_get_err_key(int err)
+{
+	switch (err) {
+	case 0:
+		return 0;
+	case -EINVAL:
+		return 2;
+	case -ENETDOWN:
+		return 3;
+	case -EMSGSIZE:
+		return 4;
+	case -EOPNOTSUPP:
+		return 5;
+	case -ENOSPC:
+		return 6;
+	default:
+		return 1;
+	}
+}
+
+static __always_inline int xdp_redirect_collect_stat(int from, int err)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 key = XDP_REDIRECT_ERROR;
+	struct datarec *rec;
+	u32 idx;
+
+	if (!IN_SET(from_match, from))
+		return 0;
+
+	key = xdp_get_err_key(err);
+
+	idx = key * nr_cpus + cpu;
+	rec = bpf_map_lookup_elem(&redir_err_cnt, &idx);
+	if (!rec)
+		return 0;
+	if (key)
+		NO_TEAR_INC(rec->dropped);
+	else
+		NO_TEAR_INC(rec->processed);
+	return 0; /* Indicate event was filtered (no further processing)*/
+	/*
+	 * Returning 1 here would allow e.g. a perf-record tracepoint
+	 * to see and record these events, but it doesn't work well
+	 * in-practice as stopping perf-record also unload this
+	 * bpf_prog.  Plus, there is additional overhead of doing so.
+	 */
+}
+
+SEC("tp_btf/xdp_redirect_err")
+int BPF_PROG(tp_xdp_redirect_err, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect_map_err")
+int BPF_PROG(tp_xdp_redirect_map_err, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect")
+int BPF_PROG(tp_xdp_redirect, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
+
+SEC("tp_btf/xdp_redirect_map")
+int BPF_PROG(tp_xdp_redirect_map, const struct net_device *dev,
+	     const struct bpf_prog *xdp, const void *tgt, int err,
+	     const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(dev->ifindex, err);
+}
diff --git a/samples/bpf/xdp_sample.bpf.h b/samples/bpf/xdp_sample.bpf.h
new file mode 100644
index 000000000000..25b1dbe9b37b
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.h
@@ -0,0 +1,141 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef _XDP_SAMPLE_BPF_H
+#define _XDP_SAMPLE_BPF_H
+
+#include "vmlinux.h"
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+#include "xdp_sample_shared.h"
+
+#define ETH_ALEN 6
+#define ETH_P_802_3_MIN 0x0600
+#define ETH_P_8021Q 0x8100
+#define ETH_P_8021AD 0x88A8
+#define ETH_P_IP 0x0800
+#define ETH_P_IPV6 0x86DD
+#define ETH_P_ARP 0x0806
+#define IPPROTO_ICMPV6 58
+
+#define EINVAL 22
+#define ENETDOWN 100
+#define EMSGSIZE 90
+#define EOPNOTSUPP 95
+#define ENOSPC 28
+
+typedef struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(map_flags, BPF_F_MMAPABLE);
+	__type(key, unsigned int);
+	__type(value, struct datarec);
+} array_map;
+
+extern array_map rx_cnt;
+extern const volatile int nr_cpus;
+
+enum {
+	XDP_REDIRECT_SUCCESS = 0,
+	XDP_REDIRECT_ERROR = 1
+};
+
+static __always_inline void swap_src_dst_mac(void *data)
+{
+	unsigned short *p = data;
+	unsigned short dst[3];
+
+	dst[0] = p[0];
+	dst[1] = p[1];
+	dst[2] = p[2];
+	p[0] = p[3];
+	p[1] = p[4];
+	p[2] = p[5];
+	p[3] = dst[0];
+	p[4] = dst[1];
+	p[5] = dst[2];
+}
+
+#if defined(__BYTE_ORDER__) && defined(__ORDER_LITTLE_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
+#define bpf_ntohs(x)		__builtin_bswap16(x)
+#define bpf_htons(x)		__builtin_bswap16(x)
+#elif defined(__BYTE_ORDER__) && defined(__ORDER_BIG_ENDIAN__) && \
+	__BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
+#define bpf_ntohs(x)		(x)
+#define bpf_htons(x)		(x)
+#else
+# error "Endianness detection needs to be set up for your compiler?!"
+#endif
+
+/*
+ * Note: including linux/compiler.h or linux/kernel.h for the macros below
+ * conflicts with vmlinux.h include in BPF files, so we define them here.
+ *
+ * Following functions are taken from kernel sources and
+ * break aliasing rules in their original form.
+ *
+ * While kernel is compiled with -fno-strict-aliasing,
+ * perf uses -Wstrict-aliasing=3 which makes build fail
+ * under gcc 4.4.
+ *
+ * Using extra __may_alias__ type to allow aliasing
+ * in this case.
+ */
+typedef __u8  __attribute__((__may_alias__))  __u8_alias_t;
+typedef __u16 __attribute__((__may_alias__)) __u16_alias_t;
+typedef __u32 __attribute__((__may_alias__)) __u32_alias_t;
+typedef __u64 __attribute__((__may_alias__)) __u64_alias_t;
+
+static __always_inline void __read_once_size(const volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(__u8_alias_t  *) res = *(volatile __u8_alias_t  *) p; break;
+	case 2: *(__u16_alias_t *) res = *(volatile __u16_alias_t *) p; break;
+	case 4: *(__u32_alias_t *) res = *(volatile __u32_alias_t *) p; break;
+	case 8: *(__u64_alias_t *) res = *(volatile __u64_alias_t *) p; break;
+	default:
+		asm volatile ("" : : : "memory");
+		__builtin_memcpy((void *)res, (const void *)p, size);
+		asm volatile ("" : : : "memory");
+	}
+}
+
+static __always_inline void __write_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(volatile  __u8_alias_t *) p = *(__u8_alias_t  *) res; break;
+	case 2: *(volatile __u16_alias_t *) p = *(__u16_alias_t *) res; break;
+	case 4: *(volatile __u32_alias_t *) p = *(__u32_alias_t *) res; break;
+	case 8: *(volatile __u64_alias_t *) p = *(__u64_alias_t *) res; break;
+	default:
+		asm volatile ("" : : : "memory");
+		__builtin_memcpy((void *)p, (const void *)res, size);
+		asm volatile ("" : : : "memory");
+	}
+}
+
+#define READ_ONCE(x)					\
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =	\
+		{ .__c = { 0 } };			\
+	__read_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+#define WRITE_ONCE(x, val)				\
+({							\
+	union { typeof(x) __val; char __c[1]; } __u =	\
+		{ .__val = (val) }; 			\
+	__write_once_size(&(x), __u.__c, sizeof(x));	\
+	__u.__val;					\
+})
+
+/* Add a value using relaxed read and relaxed write. Less expensive than
+ * fetch_add when there is no write concurrency.
+ */
+#define NO_TEAR_ADD(x, val) WRITE_ONCE((x), READ_ONCE(x) + (val))
+#define NO_TEAR_INC(x) NO_TEAR_ADD((x), 1)
+
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+#endif
-- 
2.33.0


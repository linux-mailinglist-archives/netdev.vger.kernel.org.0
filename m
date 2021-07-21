Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9ED93D1910
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbhGUUsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbhGUUsN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 16:48:13 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C63C0613D3;
        Wed, 21 Jul 2021 14:28:49 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k4-20020a17090a5144b02901731c776526so1179994pjm.4;
        Wed, 21 Jul 2021 14:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OOhR5AMX8RfXZC1KUEZgLZRVbLDpQr1d3ZP+g6mM52o=;
        b=f7I8PSYGSFwh0UMH4Rhb9th1KzMoxCRwihGokO/oSzSYWOk0FwZjnckyyLYuy9s1Xr
         x4lkDi4IjLgpfNv6/EMZBW6AnbX3iWZaWNQ/EY6bidb5EYBbwnciseVB6VAineL0INsq
         gv8jdpZ1QpsPvHzkiHa7Ouu42LhNC1sDbXS+w6JC7tvjS7/7H6jHuKvJK6KYHf2LE3ew
         f8LhrNNa07TqM9kxu08syfOXfIaMCqKZLfYigact000ct8YDJJtweT6TL40XOoiqIkRC
         4Ljb1LH73YGUhandUwAo+g44eQkpjEBJoZLSdyK06Vf9xNP5LCSQeyPGDCLa0T/QohTt
         IFlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OOhR5AMX8RfXZC1KUEZgLZRVbLDpQr1d3ZP+g6mM52o=;
        b=D9OmNH1yOjl+ryB/2KYOPW/dGNYfqzEj/bwMr567jhpspCQZ3FJvH95/S5v3rs0lN2
         mryE+zFqzHaaCkHLH2waFWmrlOlRnS6OK0heEASIX+dtw+ljJfzGFeZoVCTZ8GE6M2hA
         HmX3QMggWoZ5Ar5iPqSG/nJSypqfGhJYAwl/p31743s1jhyij3V7Xm7ZU8OQ3efZKsTb
         YPOkAhM87V0Sb5R8DO+RydWD5q2lHmaIJbBKZ/bLv/X6ASoBSsnizl4LrmG8wbVn1hDB
         xHpGbwS4dIgjYL2fAa/fIkTnzccRm+EhSDwOHsRVElMI002NJNvn0+KKbzc+xHA4XspY
         gzJA==
X-Gm-Message-State: AOAM530txG2AVHHsBMMdSjPQvm22gbLBBpaaiMG+MMyoqhMRjE/nfOwz
        9HcKDR1n+uDujQ4QtSi0PFI8tb1j6QN/4A==
X-Google-Smtp-Source: ABdhPJyadMfFAIwnXKozqdBkOxwqP6kDKsqJqGzoGfTlWaWQGipbSAXFygDMyPpCDgXePBZdbrUfBQ==
X-Received: by 2002:a65:568c:: with SMTP id v12mr38874281pgs.88.1626902929305;
        Wed, 21 Jul 2021 14:28:49 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id r10sm31119125pga.48.2021.07.21.14.28.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 14:28:49 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v2 3/8] samples: bpf: Add BPF support for XDP samples helper
Date:   Thu, 22 Jul 2021 02:58:28 +0530
Message-Id: <20210721212833.701342-4-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210721212833.701342-1-memxor@gmail.com>
References: <20210721212833.701342-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These eBPF tracepoint programs export data that is consumed by the
helpers added in the previous commit.

Also add support int the Makefile to generate a vmlinux.h header that
would be used by other bpf.c files in later commits.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile         |  25 ++++
 samples/bpf/xdp_sample.bpf.c | 215 +++++++++++++++++++++++++++++++++++
 samples/bpf/xdp_sample.bpf.h |  57 ++++++++++
 3 files changed, 297 insertions(+)
 create mode 100644 samples/bpf/xdp_sample.bpf.c
 create mode 100644 samples/bpf/xdp_sample.bpf.h

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 57ccff5ccac4..52ac1c6b56e2 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -280,6 +280,11 @@ $(LIBBPF): FORCE
 	$(MAKE) -C $(dir $@) RM='rm -rf' EXTRA_CFLAGS="$(TPROGS_CFLAGS)" \
 		LDFLAGS=$(TPROGS_LDFLAGS) srctree=$(BPF_SAMPLES_PATH)/../../ O=
 
+BPFTOOLDIR := $(TOOLS_PATH)/bpf/bpftool
+BPFTOOL := $(BPFTOOLDIR)/bpftool
+$(BPFTOOL): $(wildcard $(BPFTOOLDIR)/*.[ch] $(BPFTOOLDIR)/Makefile)
+	    $(MAKE) -C $(BPFTOOLDIR) srctree=$(BPF_SAMPLES_PATH)/../../
+
 $(obj)/syscall_nrs.h:	$(obj)/syscall_nrs.s FORCE
 	$(call filechk,offsets,__SYSCALL_NRS_H__)
 
@@ -317,6 +322,26 @@ $(obj)/hbm_edt_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 
 -include $(BPF_SAMPLES_PATH)/Makefile.target
 
+VMLINUX_BTF_PATHS ?= $(if $(O),$(O)/vmlinux)				\
+		     $(if $(KBUILD_OUTPUT),$(KBUILD_OUTPUT)/vmlinux)	\
+		     ../../../../vmlinux				\
+		     /sys/kernel/btf/vmlinux				\
+		     /boot/vmlinux-$(shell uname -r)
+VMLINUX_BTF ?= $(abspath $(firstword $(wildcard $(VMLINUX_BTF_PATHS))))
+
+ifeq ($(VMLINUX_BTF),)
+$(error Cannot find a vmlinux for VMLINUX_BTF at any of "$(VMLINUX_BTF_PATHS)")
+endif
+
+$(obj)/vmlinux.h: $(VMLINUX_BTF) $(BPFTOOL)
+ifeq ($(VMLINUX_H),)
+	$(Q)$(BPFTOOL) btf dump file $(VMLINUX_BTF) format c > $@
+else
+	$(Q)cp "$(VMLINUX_H)" $@
+endif
+
+clean-files += vmlinux.h
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
diff --git a/samples/bpf/xdp_sample.bpf.c b/samples/bpf/xdp_sample.bpf.c
new file mode 100644
index 000000000000..3359b4791ca4
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.c
@@ -0,0 +1,215 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  GPLv2, Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
+#include "xdp_sample.bpf.h"
+
+#include <bpf/bpf_tracing.h>
+#include <bpf/bpf_core_read.h>
+#include <bpf/bpf_helpers.h>
+
+struct sample_data sample_data;
+devmap_xmit_cnt_multi_t devmap_xmit_cnt_multi SEC(".maps");
+
+static __always_inline
+__u32 xdp_get_err_key(int err)
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
+static __always_inline
+int xdp_redirect_collect_stat(int err)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	u32 key = XDP_REDIRECT_ERROR;
+	struct datarec *rec;
+	u32 idx;
+
+	key = xdp_get_err_key(err);
+	idx = key * MAX_CPUS + cpu;
+
+	if (idx < 7 * MAX_CPUS) {
+		rec = &sample_data.redirect_err_cnt[idx];
+		if (key)
+			ATOMIC_INC_NORMW(rec->dropped);
+		else
+			ATOMIC_INC_NORMW(rec->processed);
+	}
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
+		 const struct bpf_prog *xdp,
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(err);
+}
+
+SEC("tp_btf/xdp_redirect_map_err")
+int BPF_PROG(tp_xdp_redirect_map_err, const struct net_device *dev,
+		 const struct bpf_prog *xdp,
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(err);
+}
+
+SEC("tp_btf/xdp_redirect")
+int BPF_PROG(tp_xdp_redirect, const struct net_device *dev,
+		 const struct bpf_prog *xdp,
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(err);
+}
+
+SEC("tp_btf/xdp_redirect_map")
+int BPF_PROG(tp_xdp_redirect_map, const struct net_device *dev,
+		 const struct bpf_prog *xdp,
+		 const void *tgt, int err,
+		 const struct bpf_map *map, u32 index)
+{
+	return xdp_redirect_collect_stat(err);
+}
+
+SEC("tp_btf/xdp_exception")
+int BPF_PROG(tp_xdp_exception, const struct net_device *dev,
+	     const struct bpf_prog *xdp, u32 act)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 key = act, idx;
+
+	if (key > XDP_REDIRECT)
+		key = XDP_REDIRECT + 1;
+	idx = key * MAX_CPUS + cpu;
+
+	if (idx < 6 * MAX_CPUS) {
+		rec = &sample_data.exception_cnt[idx];
+		ATOMIC_INC_NORMW(rec->dropped);
+	}
+
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_enqueue")
+int BPF_PROG(tp_xdp_cpumap_enqueue, int map_id, unsigned int processed,
+	     unsigned int drops, int to_cpu)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+	u32 idx;
+
+	idx = to_cpu * MAX_CPUS + cpu;
+
+	if (idx < MAX_CPUS * MAX_CPUS) {
+		rec = &sample_data.cpumap_enqueue_cnt[idx];
+
+		ATOMIC_ADD_NORMW(rec->processed, processed);
+		ATOMIC_ADD_NORMW(rec->dropped, drops);
+		/* Record bulk events, then userspace can calc average bulk size */
+		if (processed > 0)
+			ATOMIC_INC_NORMW(rec->issue);
+	}
+	/* Inception: It's possible to detect overload situations, via
+	 * this tracepoint.  This can be used for creating a feedback
+	 * loop to XDP, which can take appropriate actions to mitigate
+	 * this overload situation.
+	 */
+	return 0;
+}
+
+SEC("tp_btf/xdp_cpumap_kthread")
+int BPF_PROG(tp_xdp_cpumap_kthread, int map_id, unsigned int processed,
+	     unsigned int drops, int sched, struct xdp_cpumap_stats *xdp_stats)
+{
+	// Using xdp_stats directly fails verification
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+
+	if (cpu < MAX_CPUS) {
+		rec = &sample_data.cpumap_kthread_cnt[cpu];
+
+		ATOMIC_ADD_NORMW(rec->processed, processed);
+		ATOMIC_ADD_NORMW(rec->dropped, drops);
+		ATOMIC_ADD_NORMW(rec->xdp_pass, xdp_stats->pass);
+		ATOMIC_ADD_NORMW(rec->xdp_drop, xdp_stats->drop);
+		ATOMIC_ADD_NORMW(rec->xdp_redirect, xdp_stats->redirect);
+		/* Count times kthread yielded CPU via schedule call */
+		if (sched)
+			ATOMIC_INC_NORMW(rec->issue);
+	}
+	return 0;
+}
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	u32 cpu = bpf_get_smp_processor_id();
+	struct datarec *rec;
+
+	if (cpu < MAX_CPUS) {
+		rec = &sample_data.devmap_xmit_cnt[cpu];
+
+		ATOMIC_ADD_NORMW(rec->processed, sent);
+		ATOMIC_ADD_NORMW(rec->dropped, drops);
+		/* Record bulk events, then userspace can calc average bulk size */
+		ATOMIC_INC_NORMW(rec->info);
+		/* Record error cases, where no frame were sent */
+		/* Catch API error of drv ndo_xdp_xmit sent more than count */
+		if (err || drops < 0)
+			ATOMIC_INC_NORMW(rec->issue);
+	}
+	return 0;
+}
+
+SEC("tp_btf/xdp_devmap_xmit")
+int BPF_PROG(tp_xdp_devmap_xmit_multi, const struct net_device *from_dev,
+	     const struct net_device *to_dev, int sent, int drops, int err)
+{
+	struct datarec empty = {};
+	struct datarec *rec;
+	int idx_in, idx_out;
+	u64 idx;
+
+	idx_in = from_dev->ifindex;
+	idx_out = to_dev->ifindex;
+	idx = idx_in;
+	idx = idx << 32 | idx_out;
+
+	bpf_map_update_elem(&devmap_xmit_cnt_multi, &idx, &empty, BPF_NOEXIST);
+	rec = bpf_map_lookup_elem(&devmap_xmit_cnt_multi, &idx);
+	if (!rec)
+		return 0;
+
+	ATOMIC_ADD_NORMW(rec->processed, sent);
+	ATOMIC_ADD_NORMW(rec->dropped, drops);
+	ATOMIC_INC_NORMW(rec->info);
+
+	if (err || drops < 0)
+		ATOMIC_INC_NORMW(rec->issue);
+
+	return 0;
+}
diff --git a/samples/bpf/xdp_sample.bpf.h b/samples/bpf/xdp_sample.bpf.h
new file mode 100644
index 000000000000..20fbafe28be5
--- /dev/null
+++ b/samples/bpf/xdp_sample.bpf.h
@@ -0,0 +1,57 @@
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
+extern struct sample_data sample_data;
+
+typedef struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_HASH);
+	__uint(max_entries, 32);
+	__type(key, u64);
+	__type(value, struct datarec);
+} devmap_xmit_cnt_multi_t;
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
+#endif
-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 463443D93AF
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhG1Q5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhG1Q47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:56:59 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C29C061757;
        Wed, 28 Jul 2021 09:56:57 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id t3so1325705plg.9;
        Wed, 28 Jul 2021 09:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WmTiSRs5LuqsEaNI5OzvIj+waWhN9ColKzwkE1PrbbM=;
        b=SeoSPW5Cgs7zZ86aQBrJdZI0Ku11s3qw87LIMYqtCQjnp1OLV6cldlQuI29vL9ZMpL
         7EDxQGjcAB44mTGk5lSNyzbXCx5u0FdijJlc+pMs5JHwFNN3Y45r3mgqtMNdSF/Qg8wi
         rKyONHntdvAkL2WKZ6TY4C2tG7MEVLH8whUkIdTEjC9kcXyKm3ivKnzxqajyWOm+wUlp
         YA5rEfuNQopk0FgLxW8f9RwkhdzWLa7LrhVwLoW6N9cBm/jEsdQlE72uOt7KXRCXUIg2
         yk46vDg9x0+ipzDenWgP0tCJdY4qKpzuf64kiry/I+ALTgvOCVcOKvCAEVGpVdcRfQ7G
         0O4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WmTiSRs5LuqsEaNI5OzvIj+waWhN9ColKzwkE1PrbbM=;
        b=FPIdiOeW6MGTVrczPqM/pYNIOqAwfBpn6VjPesUqSIF/tBvlsuVCB5jKGFJaSo8SYc
         t6ITEBhyP2ETKpd3EOcJdHdrS46UW9yk20dAT/P+V1knW3mQCNAWjfsbMV0cPTK78vIQ
         A5CcKWilQYxd0Wmpj051EUfUvezMZtpvrJkuoTLiBbZ5+6F8EkCKldUR6aCFR9+tlJoY
         kNDbH05Z1OV4GEPIAFVXR6kw4ROwTzTMjtTWr/YPutGOVMRZP29n8mZR1b2CxuoZWK4i
         9M4/ddYwzyCPpjVz0dcZ1LrDdEGXRp8TuCv4xczyVfOL/X1KPFZWZsNdEWKxEtt4JJtw
         tbHg==
X-Gm-Message-State: AOAM5300TU8bVqvJGlCglC51wHk+ZkR3Odc0rHEP/5expRD2ACIHhuZy
        g4GEcHdfQoNhzthWEG9xnqkwNryYwDZVrg==
X-Google-Smtp-Source: ABdhPJwVxmKbgCQRiF7m2+cYEL2I87Hvpd27UKalOOu///7j4/5y0UUZRRSOkyGS/fNghfo9mFn0TQ==
X-Received: by 2002:a63:d849:: with SMTP id k9mr731389pgj.67.1627491416764;
        Wed, 28 Jul 2021 09:56:56 -0700 (PDT)
Received: from localhost ([2405:201:6014:d0bb:dc30:f309:2f53:5818])
        by smtp.gmail.com with ESMTPSA id q17sm324702pgd.39.2021.07.28.09.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 09:56:56 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 4/8] samples: bpf: Convert xdp_monitor to use XDP samples helper
Date:   Wed, 28 Jul 2021 22:25:48 +0530
Message-Id: <20210728165552.435050-5-memxor@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210728165552.435050-1-memxor@gmail.com>
References: <20210728165552.435050-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change converts XDP monitor tool to use the XDP samples support
introduced in previous changes.

Makefile support is added to produce the BPF skeleton and link
xdp_monitor bpf object with xdp_sample bpf object. This is then used to
open and load the bpf object and attach the needed tracepoints only.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile           |  50 ++-
 samples/bpf/xdp_monitor.bpf.c  |   8 +
 samples/bpf/xdp_monitor_kern.c | 257 -----------
 samples/bpf/xdp_monitor_user.c | 792 +++------------------------------
 4 files changed, 110 insertions(+), 997 deletions(-)
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 4a3151fa163f..1c7e1d5830c7 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -43,7 +43,6 @@ tprogs-y += xdp_redirect
 tprogs-y += xdp_redirect_map
 tprogs-y += xdp_redirect_map_multi
 tprogs-y += xdp_redirect_cpu
-tprogs-y += xdp_monitor
 tprogs-y += xdp_rxq_info
 tprogs-y += syscall_tp
 tprogs-y += cpustat
@@ -57,6 +56,8 @@ tprogs-y += xdp_sample_pkts
 tprogs-y += ibumad
 tprogs-y += hbm
 
+tprogs-y += xdp_monitor
+
 # Libbpf dependencies
 LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a
 
@@ -103,7 +104,6 @@ xdp_redirect-objs := xdp_redirect_user.o
 xdp_redirect_map-objs := xdp_redirect_map_user.o
 xdp_redirect_map_multi-objs := xdp_redirect_map_multi_user.o
 xdp_redirect_cpu-objs := xdp_redirect_cpu_user.o
-xdp_monitor-objs := xdp_monitor_user.o
 xdp_rxq_info-objs := xdp_rxq_info_user.o
 syscall_tp-objs := syscall_tp_user.o
 cpustat-objs := cpustat_user.o
@@ -117,6 +117,8 @@ xdp_sample_pkts-objs := xdp_sample_pkts_user.o
 ibumad-objs := ibumad_user.o
 hbm-objs := hbm.o $(CGROUP_HELPERS)
 
+xdp_monitor-objs := xdp_monitor_user.o $(XDP_SAMPLE)
+
 # Tell kbuild to always build the programs
 always-y := $(tprogs-y)
 always-y += sockex1_kern.o
@@ -165,7 +167,6 @@ always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
-always-y += xdp_monitor_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -312,6 +313,8 @@ verify_target_bpf: verify_cmds
 $(BPF_SAMPLES_PATH)/*.c: verify_target_bpf $(LIBBPF)
 $(src)/*.c: verify_target_bpf $(LIBBPF)
 
+$(obj)/xdp_monitor_user.o: $(obj)/xdp_monitor.skel.h
+
 $(obj)/tracex5_kern.o: $(obj)/syscall_nrs.h
 $(obj)/hbm_out_kern.o: $(src)/hbm.h $(src)/hbm_kern.h
 $(obj)/hbm.o: $(src)/hbm.h
@@ -339,6 +342,47 @@ endif
 
 clean-files += vmlinux.h
 
+# Get Clang's default includes on this system, as opposed to those seen by
+# '-target bpf'. This fixes "missing" files on some architectures/distros,
+# such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
+#
+# Use '-idirafter': Don't interfere with include mechanics except where the
+# build would have failed anyways.
+define get_sys_includes
+$(shell $(1) -v -E - </dev/null 2>&1 \
+        | sed -n '/<...> search starts here:/,/End of search list./{ s| \(/.*\)|-idirafter \1|p }') \
+$(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen ' | sed 's/#define /-D/' | sed 's/ /=/')
+endef
+
+CLANG_SYS_INCLUDES = $(call get_sys_includes,$(CLANG))
+
+$(obj)/xdp_monitor.bpf.o: $(obj)/xdp_sample.bpf.o
+
+$(obj)/%.bpf.o: $(src)/%.bpf.c $(obj)/vmlinux.h $(src)/xdp_sample.bpf.h $(src)/xdp_sample_shared.h
+	@echo "  CLANG-BPF " $@
+	$(Q)$(CLANG) -g -O2 -target bpf -D__TARGET_ARCH_$(SRCARCH) \
+		-Wno-compare-distinct-pointer-types \
+		-I$(srctree)/samples/bpf -I$(srctree)/tools/include \
+		-I$(srctree)/tools/lib $(CLANG_SYS_INCLUDES) \
+		-c $(filter %.bpf.c,$^) -o $@
+
+LINKED_SKELS := xdp_monitor.skel.h
+clean-files += $(LINKED_SKELS)
+
+xdp_monitor.skel.h-deps := xdp_monitor.bpf.o xdp_sample.bpf.o
+
+LINKED_BPF_SRCS := $(patsubst %.bpf.o,%.bpf.c,$(foreach skel,$(LINKED_SKELS),$($(skel)-deps)))
+
+BPF_SRCS_LINKED := $(notdir $(wildcard $(src)/*.bpf.c))
+BPF_OBJS_LINKED := $(patsubst %.bpf.c,$(obj)/%.bpf.o, $(BPF_SRCS_LINKED))
+BPF_SKELS_LINKED := $(addprefix $(obj)/,$(LINKED_SKELS))
+
+$(BPF_SKELS_LINKED): $(BPF_OBJS_LINKED) $(BPFTOOL)
+	@echo "  BPF GEN-OBJ " $(@:.skel.h=)
+	$(Q)$(BPFTOOL) gen object $(@:.skel.h=.lbpf.o) $(addprefix $(obj)/,$($(@F)-deps))
+	@echo "  BPF GEN-SKEL" $(@:.skel.h=)
+	$(Q)$(BPFTOOL) gen skeleton $(@:.skel.h=.lbpf.o) name $(notdir $(@:.skel.h=)) > $@
+
 # asm/sysreg.h - inline assembly used by it is incompatible with llvm.
 # But, there is no easy way to fix it, so just exclude it since it is
 # useless for BPF samples.
diff --git a/samples/bpf/xdp_monitor.bpf.c b/samples/bpf/xdp_monitor.bpf.c
new file mode 100644
index 000000000000..cfb41e2205f4
--- /dev/null
+++ b/samples/bpf/xdp_monitor.bpf.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+/*  Copyright(c) 2017-2018 Jesper Dangaard Brouer, Red Hat Inc.
+ *
+ * XDP monitor tool, based on tracepoints
+ */
+#include "xdp_sample.bpf.h"
+
+char _license[] SEC("license") = "GPL";
diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
deleted file mode 100644
index 5c955b812c47..000000000000
--- a/samples/bpf/xdp_monitor_kern.c
+++ /dev/null
@@ -1,257 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0
- *  Copyright(c) 2017-2018 Jesper Dangaard Brouer, Red Hat Inc.
- *
- * XDP monitor tool, based on tracepoints
- */
-#include <uapi/linux/bpf.h>
-#include <bpf/bpf_helpers.h>
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, u64);
-	__uint(max_entries, 2);
-	/* TODO: have entries for all possible errno's */
-} redirect_err_cnt SEC(".maps");
-
-#define XDP_UNKNOWN	XDP_REDIRECT + 1
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, u64);
-	__uint(max_entries, XDP_UNKNOWN + 1);
-} exception_cnt SEC(".maps");
-
-/* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
- * Code in:                kernel/include/trace/events/xdp.h
- */
-struct xdp_redirect_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int prog_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12  size:4; signed:0;
-	int ifindex;		//	offset:16  size:4; signed:1;
-	int err;		//	offset:20  size:4; signed:1;
-	int to_ifindex;		//	offset:24  size:4; signed:1;
-	u32 map_id;		//	offset:28  size:4; signed:0;
-	int map_index;		//	offset:32  size:4; signed:1;
-};				//	offset:36
-
-enum {
-	XDP_REDIRECT_SUCCESS = 0,
-	XDP_REDIRECT_ERROR = 1
-};
-
-static __always_inline
-int xdp_redirect_collect_stat(struct xdp_redirect_ctx *ctx)
-{
-	u32 key = XDP_REDIRECT_ERROR;
-	int err = ctx->err;
-	u64 *cnt;
-
-	if (!err)
-		key = XDP_REDIRECT_SUCCESS;
-
-	cnt  = bpf_map_lookup_elem(&redirect_err_cnt, &key);
-	if (!cnt)
-		return 1;
-	*cnt += 1;
-
-	return 0; /* Indicate event was filtered (no further processing)*/
-	/*
-	 * Returning 1 here would allow e.g. a perf-record tracepoint
-	 * to see and record these events, but it doesn't work well
-	 * in-practice as stopping perf-record also unload this
-	 * bpf_prog.  Plus, there is additional overhead of doing so.
-	 */
-}
-
-SEC("tracepoint/xdp/xdp_redirect_err")
-int trace_xdp_redirect_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-
-SEC("tracepoint/xdp/xdp_redirect_map_err")
-int trace_xdp_redirect_map_err(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect")
-int trace_xdp_redirect(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
-/* Likely unloaded when prog starts */
-SEC("tracepoint/xdp/xdp_redirect_map")
-int trace_xdp_redirect_map(struct xdp_redirect_ctx *ctx)
-{
-	return xdp_redirect_collect_stat(ctx);
-}
-
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
-{
-	u64 *cnt;
-	u32 key;
-
-	key = ctx->act;
-	if (key > XDP_REDIRECT)
-		key = XDP_UNKNOWN;
-
-	cnt = bpf_map_lookup_elem(&exception_cnt, &key);
-	if (!cnt)
-		return 1;
-	*cnt += 1;
-
-	return 0;
-}
-
-/* Common stats data record shared with _user.c */
-struct datarec {
-	u64 processed;
-	u64 dropped;
-	u64 info;
-	u64 err;
-};
-#define MAX_CPUS 64
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, MAX_CPUS);
-} cpumap_enqueue_cnt SEC(".maps");
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} cpumap_kthread_cnt SEC(".maps");
-
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
-
-	if (to_cpu >= MAX_CPUS)
-		return 1;
-
-	rec = bpf_map_lookup_elem(&cpumap_enqueue_cnt, &to_cpu);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->processed;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	if (ctx->processed > 0)
-		rec->info += 1;
-
-	return 0;
-}
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_kthread/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct cpumap_kthread_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int map_id;		//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int cpu;		//	offset:16; size:4; signed:1;
-	unsigned int drops;	//	offset:20; size:4; signed:0;
-	unsigned int processed;	//	offset:24; size:4; signed:0;
-	int sched;		//	offset:28; size:4; signed:1;
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
-
-	/* Count times kthread yielded CPU via schedule call */
-	if (ctx->sched)
-		rec->info++;
-
-	return 0;
-}
-
-struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__type(key, u32);
-	__type(value, struct datarec);
-	__uint(max_entries, 1);
-} devmap_xmit_cnt SEC(".maps");
-
-/* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
- * Code in:         kernel/include/trace/events/xdp.h
- */
-struct devmap_xmit_ctx {
-	u64 __pad;		// First 8 bytes are not accessible by bpf code
-	int from_ifindex;	//	offset:8;  size:4; signed:1;
-	u32 act;		//	offset:12; size:4; signed:0;
-	int to_ifindex; 	//	offset:16; size:4; signed:1;
-	int drops;		//	offset:20; size:4; signed:1;
-	int sent;		//	offset:24; size:4; signed:1;
-	int err;		//	offset:28; size:4; signed:1;
-};
-
-SEC("tracepoint/xdp/xdp_devmap_xmit")
-int trace_xdp_devmap_xmit(struct devmap_xmit_ctx *ctx)
-{
-	struct datarec *rec;
-	u32 key = 0;
-
-	rec = bpf_map_lookup_elem(&devmap_xmit_cnt, &key);
-	if (!rec)
-		return 0;
-	rec->processed += ctx->sent;
-	rec->dropped   += ctx->drops;
-
-	/* Record bulk events, then userspace can calc average bulk size */
-	rec->info += 1;
-
-	/* Record error cases, where no frame were sent */
-	if (ctx->err)
-		rec->err++;
-
-	/* Catch API error of drv ndo_xdp_xmit sent more than count */
-	if (ctx->drops < 0)
-		rec->err++;
-
-	return 1;
-}
diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index 49ebc49aefc3..4c06eb816172 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -1,15 +1,12 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.
- */
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc. */
 static const char *__doc__=
- "XDP monitor tool, based on tracepoints\n"
-;
+"XDP monitor tool, based on tracepoints\n";
 
 static const char *__doc_err_only__=
- " NOTICE: Only tracking XDP redirect errors\n"
- "         Enable TX success stats via '--stats'\n"
- "         (which comes with a per packet processing overhead)\n"
-;
+" NOTICE: Only tracking XDP redirect errors\n"
+"         Enable redirect success stats via '-s/--stats'\n"
+"         (which comes with a per packet processing overhead)\n";
 
 #include <errno.h>
 #include <stdio.h>
@@ -20,768 +17,89 @@ static const char *__doc_err_only__=
 #include <ctype.h>
 #include <unistd.h>
 #include <locale.h>
-
 #include <sys/resource.h>
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
-
 #include <signal.h>
 #include <bpf/bpf.h>
 #include <bpf/libbpf.h>
 #include "bpf_util.h"
+#include "xdp_sample_user.h"
+#include "xdp_monitor.skel.h"
 
-enum map_type {
-	REDIRECT_ERR_CNT,
-	EXCEPTION_CNT,
-	CPUMAP_ENQUEUE_CNT,
-	CPUMAP_KTHREAD_CNT,
-	DEVMAP_XMIT_CNT,
-};
+static int mask = SAMPLE_REDIRECT_ERR_CNT | SAMPLE_CPUMAP_ENQUEUE_CNT |
+		  SAMPLE_CPUMAP_KTHREAD_CNT | SAMPLE_EXCEPTION_CNT |
+		  SAMPLE_DEVMAP_XMIT_CNT | SAMPLE_DEVMAP_XMIT_CNT_MULTI;
 
-static const char *const map_type_strings[] = {
-	[REDIRECT_ERR_CNT] = "redirect_err_cnt",
-	[EXCEPTION_CNT] = "exception_cnt",
-	[CPUMAP_ENQUEUE_CNT] = "cpumap_enqueue_cnt",
-	[CPUMAP_KTHREAD_CNT] = "cpumap_kthread_cnt",
-	[DEVMAP_XMIT_CNT] = "devmap_xmit_cnt",
-};
-
-#define NUM_MAP 5
-#define NUM_TP 8
-
-static int tp_cnt;
-static int map_cnt;
-static int verbose = 1;
-static bool debug = false;
-struct bpf_map *map_data[NUM_MAP] = {};
-struct bpf_link *tp_links[NUM_TP] = {};
-struct bpf_object *obj;
+DEFINE_SAMPLE_INIT(xdp_monitor);
 
 static const struct option long_options[] = {
-	{"help",	no_argument,		NULL, 'h' },
-	{"debug",	no_argument,		NULL, 'D' },
-	{"stats",	no_argument,		NULL, 'S' },
-	{"sec", 	required_argument,	NULL, 's' },
-	{0, 0, NULL,  0 }
-};
-
-static void int_exit(int sig)
-{
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
-	bpf_object__close(obj);
-	exit(0);
-}
-
-/* C standard specifies two constants, EXIT_SUCCESS(0) and EXIT_FAILURE(1) */
-#define EXIT_FAIL_MEM	5
-
-static void usage(char *argv[])
-{
-	int i;
-	printf("\nDOCUMENTATION:\n%s\n", __doc__);
-	printf("\n");
-	printf(" Usage: %s (options-see-below)\n",
-	       argv[0]);
-	printf(" Listing options:\n");
-	for (i = 0; long_options[i].name != 0; i++) {
-		printf(" --%-15s", long_options[i].name);
-		if (long_options[i].flag != NULL)
-			printf(" flag (internal value:%d)",
-			       *long_options[i].flag);
-		else
-			printf("short-option: -%c",
-			       long_options[i].val);
-		printf("\n");
-	}
-	printf("\n");
-}
-
-#define NANOSEC_PER_SEC 1000000000 /* 10^9 */
-static __u64 gettime(void)
-{
-	struct timespec t;
-	int res;
-
-	res = clock_gettime(CLOCK_MONOTONIC, &t);
-	if (res < 0) {
-		fprintf(stderr, "Error with gettimeofday! (%i)\n", res);
-		exit(EXIT_FAILURE);
-	}
-	return (__u64) t.tv_sec * NANOSEC_PER_SEC + t.tv_nsec;
-}
-
-enum {
-	REDIR_SUCCESS = 0,
-	REDIR_ERROR = 1,
-};
-#define REDIR_RES_MAX 2
-static const char *redir_names[REDIR_RES_MAX] = {
-	[REDIR_SUCCESS]	= "Success",
-	[REDIR_ERROR]	= "Error",
-};
-static const char *err2str(int err)
-{
-	if (err < REDIR_RES_MAX)
-		return redir_names[err];
-	return NULL;
-}
-/* enum xdp_action */
-#define XDP_UNKNOWN	XDP_REDIRECT + 1
-#define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
-static const char *xdp_action_names[XDP_ACTION_MAX] = {
-	[XDP_ABORTED]	= "XDP_ABORTED",
-	[XDP_DROP]	= "XDP_DROP",
-	[XDP_PASS]	= "XDP_PASS",
-	[XDP_TX]	= "XDP_TX",
-	[XDP_REDIRECT]	= "XDP_REDIRECT",
-	[XDP_UNKNOWN]	= "XDP_UNKNOWN",
+	{ "help", no_argument, NULL, 'h' },
+	{ "stats", no_argument, NULL, 's' },
+	{ "interval", required_argument, NULL, 'i' },
+	{ "verbose", no_argument, NULL, 'v' },
+	{}
 };
-static const char *action2str(int action)
-{
-	if (action < XDP_ACTION_MAX)
-		return xdp_action_names[action];
-	return NULL;
-}
-
-/* Common stats data record shared with _kern.c */
-struct datarec {
-	__u64 processed;
-	__u64 dropped;
-	__u64 info;
-	__u64 err;
-};
-#define MAX_CPUS 64
-
-/* Userspace structs for collection of stats from maps */
-struct record {
-	__u64 timestamp;
-	struct datarec total;
-	struct datarec *cpu;
-};
-struct u64rec {
-	__u64 processed;
-};
-struct record_u64 {
-	/* record for _kern side __u64 values */
-	__u64 timestamp;
-	struct u64rec total;
-	struct u64rec *cpu;
-};
-
-struct stats_record {
-	struct record_u64 xdp_redirect[REDIR_RES_MAX];
-	struct record_u64 xdp_exception[XDP_ACTION_MAX];
-	struct record xdp_cpumap_kthread;
-	struct record xdp_cpumap_enqueue[MAX_CPUS];
-	struct record xdp_devmap_xmit;
-};
-
-static bool map_collect_record(int fd, __u32 key, struct record *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct datarec values[nr_cpus];
-	__u64 sum_processed = 0;
-	__u64 sum_dropped = 0;
-	__u64 sum_info = 0;
-	__u64 sum_err = 0;
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
-		rec->cpu[i].info = values[i].info;
-		sum_info        += values[i].info;
-		rec->cpu[i].err = values[i].err;
-		sum_err        += values[i].err;
-	}
-	rec->total.processed = sum_processed;
-	rec->total.dropped   = sum_dropped;
-	rec->total.info      = sum_info;
-	rec->total.err       = sum_err;
-	return true;
-}
-
-static bool map_collect_record_u64(int fd, __u32 key, struct record_u64 *rec)
-{
-	/* For percpu maps, userspace gets a value per possible CPU */
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	struct u64rec values[nr_cpus];
-	__u64 sum_total = 0;
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
-		sum_total            += values[i].processed;
-	}
-	rec->total.processed = sum_total;
-	return true;
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
-static double calc_period_u64(struct record_u64 *r, struct record_u64 *p)
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
-static double calc_pps(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_pps_u64(struct u64rec *r, struct u64rec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->processed - p->processed;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_drop(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->dropped - p->dropped;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_info(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->info - p->info;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static double calc_err(struct datarec *r, struct datarec *p, double period)
-{
-	__u64 packets = 0;
-	double pps = 0;
-
-	if (period > 0) {
-		packets = r->err - p->err;
-		pps = packets / period;
-	}
-	return pps;
-}
-
-static void stats_print(struct stats_record *stats_rec,
-			struct stats_record *stats_prev,
-			bool err_only)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	int rec_i = 0, i, to_cpu;
-	double t = 0, pps = 0;
-
-	/* Header */
-	printf("%-15s %-7s %-12s %-12s %-9s\n",
-	       "XDP-event", "CPU:to", "pps", "drop-pps", "extra-info");
-
-	/* tracepoint: xdp:xdp_redirect_* */
-	if (err_only)
-		rec_i = REDIR_ERROR;
-
-	for (; rec_i < REDIR_RES_MAX; rec_i++) {
-		struct record_u64 *rec, *prev;
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
-
-		rec  =  &stats_rec->xdp_redirect[rec_i];
-		prev = &stats_prev->xdp_redirect[rec_i];
-		t = calc_period_u64(rec, prev);
-
-		for (i = 0; i < nr_cpus; i++) {
-			struct u64rec *r = &rec->cpu[i];
-			struct u64rec *p = &prev->cpu[i];
-
-			pps = calc_pps_u64(r, p, t);
-			if (pps > 0)
-				printf(fmt1, "XDP_REDIRECT", i,
-				       rec_i ? 0.0: pps, rec_i ? pps : 0.0,
-				       err2str(rec_i));
-		}
-		pps = calc_pps_u64(&rec->total, &prev->total, t);
-		printf(fmt2, "XDP_REDIRECT", "total",
-		       rec_i ? 0.0: pps, rec_i ? pps : 0.0, err2str(rec_i));
-	}
-
-	/* tracepoint: xdp:xdp_exception */
-	for (rec_i = 0; rec_i < XDP_ACTION_MAX; rec_i++) {
-		struct record_u64 *rec, *prev;
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %s\n";
-
-		rec  =  &stats_rec->xdp_exception[rec_i];
-		prev = &stats_prev->xdp_exception[rec_i];
-		t = calc_period_u64(rec, prev);
-
-		for (i = 0; i < nr_cpus; i++) {
-			struct u64rec *r = &rec->cpu[i];
-			struct u64rec *p = &prev->cpu[i];
-
-			pps = calc_pps_u64(r, p, t);
-			if (pps > 0)
-				printf(fmt1, "Exception", i,
-				       0.0, pps, action2str(rec_i));
-		}
-		pps = calc_pps_u64(&rec->total, &prev->total, t);
-		if (pps > 0)
-			printf(fmt2, "Exception", "total",
-			       0.0, pps, action2str(rec_i));
-	}
-
-	/* cpumap enqueue stats */
-	for (to_cpu = 0; to_cpu < MAX_CPUS; to_cpu++) {
-		char *fmt1 = "%-15s %3d:%-3d %'-12.0f %'-12.0f %'-10.2f %s\n";
-		char *fmt2 = "%-15s %3s:%-3d %'-12.0f %'-12.0f %'-10.2f %s\n";
-		struct record *rec, *prev;
-		char *info_str = "";
-		double drop, info;
-
-		rec  =  &stats_rec->xdp_cpumap_enqueue[to_cpu];
-		prev = &stats_prev->xdp_cpumap_enqueue[to_cpu];
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			if (info > 0) {
-				info_str = "bulk-average";
-				info = pps / info; /* calc average bulk size */
-			}
-			if (pps > 0)
-				printf(fmt1, "cpumap-enqueue",
-				       i, to_cpu, pps, drop, info, info_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		if (pps > 0) {
-			drop = calc_drop(&rec->total, &prev->total, t);
-			info = calc_info(&rec->total, &prev->total, t);
-			if (info > 0) {
-				info_str = "bulk-average";
-				info = pps / info; /* calc average bulk size */
-			}
-			printf(fmt2, "cpumap-enqueue",
-			       "sum", to_cpu, pps, drop, info, info_str);
-		}
-	}
-
-	/* cpumap kthread stats */
-	{
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %'-10.0f %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %'-10.0f %s\n";
-		struct record *rec, *prev;
-		double drop, info;
-		char *i_str = "";
-
-		rec  =  &stats_rec->xdp_cpumap_kthread;
-		prev = &stats_prev->xdp_cpumap_kthread;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			if (info > 0)
-				i_str = "sched";
-			if (pps > 0 || drop > 0)
-				printf(fmt1, "cpumap-kthread",
-				       i, pps, drop, info, i_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop(&rec->total, &prev->total, t);
-		info = calc_info(&rec->total, &prev->total, t);
-		if (info > 0)
-			i_str = "sched-sum";
-		printf(fmt2, "cpumap-kthread", "total", pps, drop, info, i_str);
-	}
-
-	/* devmap ndo_xdp_xmit stats */
-	{
-		char *fmt1 = "%-15s %-7d %'-12.0f %'-12.0f %'-10.2f %s %s\n";
-		char *fmt2 = "%-15s %-7s %'-12.0f %'-12.0f %'-10.2f %s %s\n";
-		struct record *rec, *prev;
-		double drop, info, err;
-		char *i_str = "";
-		char *err_str = "";
-
-		rec  =  &stats_rec->xdp_devmap_xmit;
-		prev = &stats_prev->xdp_devmap_xmit;
-		t = calc_period(rec, prev);
-		for (i = 0; i < nr_cpus; i++) {
-			struct datarec *r = &rec->cpu[i];
-			struct datarec *p = &prev->cpu[i];
-
-			pps  = calc_pps(r, p, t);
-			drop = calc_drop(r, p, t);
-			info = calc_info(r, p, t);
-			err  = calc_err(r, p, t);
-			if (info > 0) {
-				i_str = "bulk-average";
-				info = (pps+drop) / info; /* calc avg bulk */
-			}
-			if (err > 0)
-				err_str = "drv-err";
-			if (pps > 0 || drop > 0)
-				printf(fmt1, "devmap-xmit",
-				       i, pps, drop, info, i_str, err_str);
-		}
-		pps = calc_pps(&rec->total, &prev->total, t);
-		drop = calc_drop(&rec->total, &prev->total, t);
-		info = calc_info(&rec->total, &prev->total, t);
-		err  = calc_err(&rec->total, &prev->total, t);
-		if (info > 0) {
-			i_str = "bulk-average";
-			info = (pps+drop) / info; /* calc avg bulk */
-		}
-		if (err > 0)
-			err_str = "drv-err";
-		printf(fmt2, "devmap-xmit", "total", pps, drop,
-		       info, i_str, err_str);
-	}
-
-	printf("\n");
-}
-
-static bool stats_collect(struct stats_record *rec)
-{
-	int fd;
-	int i;
-
-	/* TODO: Detect if someone unloaded the perf event_fd's, as
-	 * this can happen by someone running perf-record -e
-	 */
-
-	fd = bpf_map__fd(map_data[REDIRECT_ERR_CNT]);
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		map_collect_record_u64(fd, i, &rec->xdp_redirect[i]);
-
-	fd = bpf_map__fd(map_data[EXCEPTION_CNT]);
-	for (i = 0; i < XDP_ACTION_MAX; i++) {
-		map_collect_record_u64(fd, i, &rec->xdp_exception[i]);
-	}
-
-	fd = bpf_map__fd(map_data[CPUMAP_ENQUEUE_CNT]);
-	for (i = 0; i < MAX_CPUS; i++)
-		map_collect_record(fd, i, &rec->xdp_cpumap_enqueue[i]);
-
-	fd = bpf_map__fd(map_data[CPUMAP_KTHREAD_CNT]);
-	map_collect_record(fd, 0, &rec->xdp_cpumap_kthread);
-
-	fd = bpf_map__fd(map_data[DEVMAP_XMIT_CNT]);
-	map_collect_record(fd, 0, &rec->xdp_devmap_xmit);
-
-	return true;
-}
-
-static void *alloc_rec_per_cpu(int record_size)
-{
-	unsigned int nr_cpus = bpf_num_possible_cpus();
-	void *array;
-
-	array = calloc(nr_cpus, record_size);
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
-	int rec_sz;
-	int i;
-
-	/* Alloc main stats_record structure */
-	rec = calloc(1, sizeof(*rec));
-	if (!rec) {
-		fprintf(stderr, "Mem alloc error\n");
-		exit(EXIT_FAIL_MEM);
-	}
-
-	/* Alloc stats stored per CPU for each record */
-	rec_sz = sizeof(struct u64rec);
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		rec->xdp_redirect[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	for (i = 0; i < XDP_ACTION_MAX; i++)
-		rec->xdp_exception[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	rec_sz = sizeof(struct datarec);
-	rec->xdp_cpumap_kthread.cpu = alloc_rec_per_cpu(rec_sz);
-	rec->xdp_devmap_xmit.cpu    = alloc_rec_per_cpu(rec_sz);
-
-	for (i = 0; i < MAX_CPUS; i++)
-		rec->xdp_cpumap_enqueue[i].cpu = alloc_rec_per_cpu(rec_sz);
-
-	return rec;
-}
-
-static void free_stats_record(struct stats_record *r)
-{
-	int i;
-
-	for (i = 0; i < REDIR_RES_MAX; i++)
-		free(r->xdp_redirect[i].cpu);
-
-	for (i = 0; i < XDP_ACTION_MAX; i++)
-		free(r->xdp_exception[i].cpu);
-
-	free(r->xdp_cpumap_kthread.cpu);
-	free(r->xdp_devmap_xmit.cpu);
-
-	for (i = 0; i < MAX_CPUS; i++)
-		free(r->xdp_cpumap_enqueue[i].cpu);
-
-	free(r);
-}
-
-/* Pointer swap trick */
-static inline void swap(struct stats_record **a, struct stats_record **b)
-{
-	struct stats_record *tmp;
-
-	tmp = *a;
-	*a = *b;
-	*b = tmp;
-}
-
-static void stats_poll(int interval, bool err_only)
-{
-	struct stats_record *rec, *prev;
-
-	rec  = alloc_stats_record();
-	prev = alloc_stats_record();
-	stats_collect(rec);
-
-	if (err_only)
-		printf("\n%s\n", __doc_err_only__);
-
-	/* Trick to pretty printf with thousands separators use %' */
-	setlocale(LC_NUMERIC, "en_US");
-
-	/* Header */
-	if (verbose)
-		printf("\n%s", __doc__);
-
-	/* TODO Need more advanced stats on error types */
-	if (verbose) {
-		printf(" - Stats map0: %s\n", bpf_map__name(map_data[0]));
-		printf(" - Stats map1: %s\n", bpf_map__name(map_data[1]));
-		printf("\n");
-	}
-	fflush(stdout);
-
-	while (1) {
-		swap(&prev, &rec);
-		stats_collect(rec);
-		stats_print(rec, prev, err_only);
-		fflush(stdout);
-		sleep(interval);
-	}
-
-	free_stats_record(rec);
-	free_stats_record(prev);
-}
-
-static void print_bpf_prog_info(void)
-{
-	struct bpf_program *prog;
-	struct bpf_map *map;
-	int i = 0;
-
-	/* Prog info */
-	printf("Loaded BPF prog have %d bpf program(s)\n", tp_cnt);
-	bpf_object__for_each_program(prog, obj) {
-		printf(" - prog_fd[%d] = fd(%d)\n", i, bpf_program__fd(prog));
-		i++;
-	}
-
-	i = 0;
-	/* Maps info */
-	printf("Loaded BPF prog have %d map(s)\n", map_cnt);
-	bpf_object__for_each_map(map, obj) {
-		const char *name = bpf_map__name(map);
-		int fd		 = bpf_map__fd(map);
-
-		printf(" - map_data[%d] = fd(%d) name:%s\n", i, fd, name);
-		i++;
-	}
-
-	/* Event info */
-	printf("Searching for (max:%d) event file descriptor(s)\n", tp_cnt);
-	for (i = 0; i < tp_cnt; i++) {
-		int fd = bpf_link__fd(tp_links[i]);
-
-		if (fd != -1)
-			printf(" - event_fd[%d] = fd(%d)\n", i, fd);
-	}
-}
 
 int main(int argc, char **argv)
 {
-	struct bpf_program *prog;
-	int longindex = 0, opt;
-	int ret = EXIT_FAILURE;
-	enum map_type type;
-	char filename[256];
-
-	/* Default settings: */
+	unsigned long interval = 2;
+	int ret = EXIT_FAIL_OPTION;
+	struct xdp_monitor *skel;
 	bool errors_only = true;
-	int interval = 2;
+	int longindex = 0, opt;
+	bool error = true;
 
 	/* Parse commands line args */
-	while ((opt = getopt_long(argc, argv, "hDSs:",
+	while ((opt = getopt_long(argc, argv, "si:vh",
 				  long_options, &longindex)) != -1) {
 		switch (opt) {
-		case 'D':
-			debug = true;
-			break;
-		case 'S':
+		case 's':
 			errors_only = false;
+			mask |= SAMPLE_REDIRECT_CNT;
 			break;
-		case 's':
-			interval = atoi(optarg);
+		case 'i':
+			interval = strtoul(optarg, NULL, 0);
+			break;
+		case 'v':
+			sample_switch_mode();
 			break;
 		case 'h':
+			error = false;
 		default:
-			usage(argv);
+			sample_usage(argv, long_options, __doc__, mask, error);
 			return ret;
 		}
 	}
 
-	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
-
-	/* Remove tracepoint program when program is interrupted or killed */
-	signal(SIGINT, int_exit);
-	signal(SIGTERM, int_exit);
-
-	obj = bpf_object__open_file(filename, NULL);
-	if (libbpf_get_error(obj)) {
-		printf("ERROR: opening BPF object file failed\n");
-		obj = NULL;
-		goto cleanup;
+	skel = xdp_monitor__open_and_load();
+	if (!skel) {
+		fprintf(stderr, "Failed to xdp_monitor__open_and_load: %s\n",
+			strerror(errno));
+		ret = EXIT_FAIL_BPF;
+		goto end;
 	}
 
-	/* load BPF program */
-	if (bpf_object__load(obj)) {
-		printf("ERROR: loading BPF object file failed\n");
-		goto cleanup;
+	ret = sample_init(skel, mask);
+	if (ret < 0) {
+		fprintf(stderr, "Failed to initialize sample: %s\n", strerror(-ret));
+		ret = EXIT_FAIL_BPF;
+		goto end_destroy;
 	}
 
-	for (type = 0; type < NUM_MAP; type++) {
-		map_data[type] =
-			bpf_object__find_map_by_name(obj, map_type_strings[type]);
+	if (errors_only)
+		printf("%s", __doc_err_only__);
 
-		if (libbpf_get_error(map_data[type])) {
-			printf("ERROR: finding a map in obj file failed\n");
-			goto cleanup;
-		}
-		map_cnt++;
+	ret = sample_run(interval, NULL, NULL);
+	if (ret < 0) {
+		fprintf(stderr, "Failed during sample run: %s\n", strerror(-ret));
+		ret = EXIT_FAIL;
+		goto end_destroy;
 	}
-
-	bpf_object__for_each_program(prog, obj) {
-		tp_links[tp_cnt] = bpf_program__attach(prog);
-		if (libbpf_get_error(tp_links[tp_cnt])) {
-			printf("ERROR: bpf_program__attach failed\n");
-			tp_links[tp_cnt] = NULL;
-			goto cleanup;
-		}
-		tp_cnt++;
-	}
-
-	if (debug) {
-		print_bpf_prog_info();
-	}
-
-	/* Unload/stop tracepoint event by closing bpf_link's */
-	if (errors_only) {
-		/* The bpf_link[i] depend on the order of
-		 * the functions was defined in _kern.c
-		 */
-		bpf_link__destroy(tp_links[2]);	/* tracepoint/xdp/xdp_redirect */
-		tp_links[2] = NULL;
-
-		bpf_link__destroy(tp_links[3]);	/* tracepoint/xdp/xdp_redirect_map */
-		tp_links[3] = NULL;
-	}
-
-	stats_poll(interval, errors_only);
-
-	ret = EXIT_SUCCESS;
-
-cleanup:
-	/* Detach tracepoints */
-	while (tp_cnt)
-		bpf_link__destroy(tp_links[--tp_cnt]);
-
-	bpf_object__close(obj);
-	return ret;
+	ret = EXIT_OK;
+end_destroy:
+	xdp_monitor__destroy(skel);
+end:
+	sample_exit(ret);
 }
-- 
2.32.0


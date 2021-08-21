Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFF283F37A1
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 02:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240864AbhHUAVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 20:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241107AbhHUAVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 20:21:42 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E54CC06179A;
        Fri, 20 Aug 2021 17:20:53 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id om1-20020a17090b3a8100b0017941c44ce4so14953340pjb.3;
        Fri, 20 Aug 2021 17:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oxmm8wFoiP/y+fQ/i5+9s2NXPzWRaSKdF7iXiapIL8g=;
        b=tl0Le6p5rGvktr1h6q9ZNJuZT7U+003sH5tsFGovTKv5CSNhMdYBybyKKeVcxFTLWz
         yPYGGGWTQdFLYYunu62voqpCejq1Gn/GhjfluTIA+BpAJMqmj0NtcX/H3oWMVNdi8JdR
         FSI3VGNbpxRiXjAUVlPIPItE5IIq0YjujDlrTMqMYHraHtNY9+R6frqOElKwJecuxgER
         SuMOYruj2RAt7uj0396l3qhbobx3qfpuTcZ9k2iZsx4QWWsZ9PgBPHKD5tjYfHEg9IUo
         0RGSkeap7kisIfidELlJA/OM7zzNyZL2hvZRvr6meBJcn9kyqk4XyfLRR3ybQjEjox93
         G1Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oxmm8wFoiP/y+fQ/i5+9s2NXPzWRaSKdF7iXiapIL8g=;
        b=UI+NFHao68abtdPStWO1Pq+06XrP/Jv4gt0ZYSCrEUJStxD7mj6nw0lHvk7L/fBnqW
         ef4XQDRyXN3e8J9NI1QZtcOpfUWufHlnn+2SEwn5TqSoAq013+KspiDwJvulaBzDQ0ii
         hPVM8EEg4ktbu8ZtUjJYD1nslrHQ/OCBG4VM+q2QjzkfdNUaX6lY3LUWtJT2AbpvF8Vk
         PhZ+N5mTcRKWwJCaAFzFDE7qcZJI5rq++7jegeHGumzX2YoDYHnh1LMvZsIghWA8LjQE
         pF4ah41LOXCxcnBnS0756a57JzUh8picaniDe7qv7dPmY0R1Bde+aUe6n7a0GadV+mNb
         sQbw==
X-Gm-Message-State: AOAM531/7u8udNHt3VZSGn2B+/N0x2I5cdbHNDZeWQRADmWDPOZ0nwuJ
        KYd31w65QtbIF8fcJfkLu88YqPAOuvA=
X-Google-Smtp-Source: ABdhPJww00Q4H76Kb7oqN1zKsDqCLLt2wZT3h0ehyt781xX6gRdQiu97JlL26uKHt2F1WYiHa9fphg==
X-Received: by 2002:a17:90b:11c2:: with SMTP id gv2mr7366336pjb.227.1629505252998;
        Fri, 20 Aug 2021 17:20:52 -0700 (PDT)
Received: from localhost ([2405:201:6014:d820:9cc6:d37f:c2fd:dc6])
        by smtp.gmail.com with ESMTPSA id fh2sm7298556pjb.12.2021.08.20.17.20.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 17:20:52 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 13/22] samples: bpf: Convert xdp_monitor_kern.o to XDP samples helper
Date:   Sat, 21 Aug 2021 05:50:01 +0530
Message-Id: <20210821002010.845777-14-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210821002010.845777-1-memxor@gmail.com>
References: <20210821002010.845777-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already moved all the functionality it provided in XDP samples helper
userspace and kernel BPF object, so just delete the unneeded code.

We also add generation of BPF skeleton and compilation using clang
-target bpf for files ending with .bpf.c suffix (to denote that they use
vmlinux.h).

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/Makefile           |  42 +++++-
 samples/bpf/xdp_monitor.bpf.c  |   8 +
 samples/bpf/xdp_monitor_kern.c | 257 ---------------------------------
 3 files changed, 49 insertions(+), 258 deletions(-)
 create mode 100644 samples/bpf/xdp_monitor.bpf.c
 delete mode 100644 samples/bpf/xdp_monitor_kern.c

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index ff1932e16bc5..0d7086a2a393 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -164,7 +164,6 @@ always-y += xdp_redirect_kern.o
 always-y += xdp_redirect_map_kern.o
 always-y += xdp_redirect_map_multi_kern.o
 always-y += xdp_redirect_cpu_kern.o
-always-y += xdp_monitor_kern.o
 always-y += xdp_rxq_info_kern.o
 always-y += xdp2skb_meta_kern.o
 always-y += syscall_tp_kern.o
@@ -338,6 +337,47 @@ endif
 
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
+		-Wno-compare-distinct-pointer-types -I$(srctree)/include \
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
-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 393FF28A3CD
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389964AbgJJWzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731156AbgJJTxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADADEC0613E9;
        Sat, 10 Oct 2020 03:44:35 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so9445586pgb.10;
        Sat, 10 Oct 2020 03:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OW/gvTkGu86YgUxpgjSRkvij/4SXXCYc66hmNhRMo9c=;
        b=M9pS6rTM1X7ZbozVAyUbVptpUuFZja+wxg1FAAFiNGIPOgYiJ2oAxXZnt2IkdFDNJ7
         jroi/IdoVe/D7PnxhxDFfxYFZ4EEDqRd5/znbKJBziBGG7oIVHg61tPmASDKa9Bj76DO
         c2V8q1edLGoe7D6q+XwMNtdb3RqBuIWaRpliAl9BVfbWs3cLF2GKx6CXXh2edoe9z7nq
         p/DQY+YjI7MRRy/ZyyBbu2V84T15iGEx8fLTlQjiwqr5WJnuA1Rsls8GxfcCVxgEqwgC
         xNcLpjUI38WKDxrUK5cCLsM4PSBz6Giq+2isLuP1X7gVc2GDi4xZxUJfYcgBDFKoexVr
         4Ofg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OW/gvTkGu86YgUxpgjSRkvij/4SXXCYc66hmNhRMo9c=;
        b=HUkChbTYxeETOvF/MYhoio/L2Ifo5LmDd4zfXu6qjZRqGmjsTpgf/D89l1Y50SPLAG
         j3dfy8vlcd8S8OwPwoPk/bygnVbF0eiDgSH+fhdv5Wdo7tJ5HlfCtxGIQGRdIqHhpXMC
         1ol/51VrOHM+VM6eLfFoH5vajXuTHk6gdFCCPRkeRD4+fXLvGw9zT70f6NhfJcgjr4+K
         FiPcPID+deTLFVUGNFG6mzQy4Qo3b5bff/0yvCtZznMclt4UYmo/PWtBInNeyxdAm+gb
         TOJcKx7iEKY0QQ+SFzPpP/0BLuhD1L6S6RdvOo2Iufx/U5e87eirwKmh8maLi8vyrGxt
         dr9Q==
X-Gm-Message-State: AOAM532p1lE76QmgkSGzSqJo4KfrRSXUcsphrR5q5aQuKjkaURKuR4RD
        0zs6BH1kzKBO1ISiG166+g==
X-Google-Smtp-Source: ABdhPJz5PouSMzjUmLdPt/A9VyQIZcy2uxlPkVOAqVFDrmdP0lfAaW2x/EjDVn1y72EApuQGCpYhyA==
X-Received: by 2002:a17:90a:448a:: with SMTP id t10mr9889016pjg.19.1602326675251;
        Sat, 10 Oct 2020 03:44:35 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id n127sm13307286pfn.155.2020.10.10.03.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 03:44:34 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 3/3] samples: bpf: refactor XDP kern program maps with BTF-defined map
Date:   Sat, 10 Oct 2020 19:44:16 +0900
Message-Id: <20201010104416.1421-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010104416.1421-1-danieltimlee@gmail.com>
References: <20201010104416.1421-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most of the samples were converted to use the new BTF-defined MAP as
they moved to libbpf, but some of the samples were missing.

Instead of using the previous BPF MAP definition, this commit refactors
xdp_monitor and xdp_sample_pkts_kern MAP definition with the new
BTF-defined MAP format.

Also, this commit removes the max_entries attribute at PERF_EVENT_ARRAY
map type. The libbpf's bpf_object__create_map() will automatically
set max_entries to the maximum configured number of CPUs on the host.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>

---
Changes in v2:
 - revert BTF key/val type to default of BPF_MAP_TYPE_PERF_EVENT_ARRAY

 samples/bpf/xdp_monitor_kern.c     | 60 +++++++++++++++---------------
 samples/bpf/xdp_sample_pkts_kern.c | 14 +++----
 samples/bpf/xdp_sample_pkts_user.c |  1 -
 3 files changed, 36 insertions(+), 39 deletions(-)

diff --git a/samples/bpf/xdp_monitor_kern.c b/samples/bpf/xdp_monitor_kern.c
index 3d33cca2d48a..5c955b812c47 100644
--- a/samples/bpf/xdp_monitor_kern.c
+++ b/samples/bpf/xdp_monitor_kern.c
@@ -6,21 +6,21 @@
 #include <uapi/linux/bpf.h>
 #include <bpf/bpf_helpers.h>
 
-struct bpf_map_def SEC("maps") redirect_err_cnt = {
-	.type = BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size = sizeof(u32),
-	.value_size = sizeof(u64),
-	.max_entries = 2,
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, 2);
 	/* TODO: have entries for all possible errno's */
-};
+} redirect_err_cnt SEC(".maps");
 
 #define XDP_UNKNOWN	XDP_REDIRECT + 1
-struct bpf_map_def SEC("maps") exception_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(u64),
-	.max_entries	= XDP_UNKNOWN + 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, u64);
+	__uint(max_entries, XDP_UNKNOWN + 1);
+} exception_cnt SEC(".maps");
 
 /* Tracepoint format: /sys/kernel/debug/tracing/events/xdp/xdp_redirect/format
  * Code in:                kernel/include/trace/events/xdp.h
@@ -129,19 +129,19 @@ struct datarec {
 };
 #define MAX_CPUS 64
 
-struct bpf_map_def SEC("maps") cpumap_enqueue_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= MAX_CPUS,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, MAX_CPUS);
+} cpumap_enqueue_cnt SEC(".maps");
 
-struct bpf_map_def SEC("maps") cpumap_kthread_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} cpumap_kthread_cnt SEC(".maps");
 
 /* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_cpumap_enqueue/format
  * Code in:         kernel/include/trace/events/xdp.h
@@ -210,12 +210,12 @@ int trace_xdp_cpumap_kthread(struct cpumap_kthread_ctx *ctx)
 	return 0;
 }
 
-struct bpf_map_def SEC("maps") devmap_xmit_cnt = {
-	.type		= BPF_MAP_TYPE_PERCPU_ARRAY,
-	.key_size	= sizeof(u32),
-	.value_size	= sizeof(struct datarec),
-	.max_entries	= 1,
-};
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__type(key, u32);
+	__type(value, struct datarec);
+	__uint(max_entries, 1);
+} devmap_xmit_cnt SEC(".maps");
 
 /* Tracepoint: /sys/kernel/debug/tracing/events/xdp/xdp_devmap_xmit/format
  * Code in:         kernel/include/trace/events/xdp.h
diff --git a/samples/bpf/xdp_sample_pkts_kern.c b/samples/bpf/xdp_sample_pkts_kern.c
index 33377289e2a8..9cf76b340dd7 100644
--- a/samples/bpf/xdp_sample_pkts_kern.c
+++ b/samples/bpf/xdp_sample_pkts_kern.c
@@ -5,14 +5,12 @@
 #include <bpf/bpf_helpers.h>
 
 #define SAMPLE_SIZE 64ul
-#define MAX_CPUS 128
-
-struct bpf_map_def SEC("maps") my_map = {
-	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
-	.key_size = sizeof(int),
-	.value_size = sizeof(u32),
-	.max_entries = MAX_CPUS,
-};
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
+	__uint(key_size, sizeof(int));
+	__uint(value_size, sizeof(u32));
+} my_map SEC(".maps");
 
 SEC("xdp_sample")
 int xdp_sample_prog(struct xdp_md *ctx)
diff --git a/samples/bpf/xdp_sample_pkts_user.c b/samples/bpf/xdp_sample_pkts_user.c
index 991ef6f0880b..4b2a300c750c 100644
--- a/samples/bpf/xdp_sample_pkts_user.c
+++ b/samples/bpf/xdp_sample_pkts_user.c
@@ -18,7 +18,6 @@
 
 #include "perf-sys.h"
 
-#define MAX_CPUS 128
 static int if_idx;
 static char *if_name;
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
-- 
2.25.1


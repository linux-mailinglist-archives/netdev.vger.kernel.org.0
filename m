Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A31228A448
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388101AbgJJWxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728919AbgJJSo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 14:44:27 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0561C08EC68;
        Sat, 10 Oct 2020 11:17:52 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so9744871pff.6;
        Sat, 10 Oct 2020 11:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OW/gvTkGu86YgUxpgjSRkvij/4SXXCYc66hmNhRMo9c=;
        b=RP9Lr0dwyZrTys8jBoQ9I0zvpSSbuymiY1u0AVevyxRC9RcycEfPU1qogzQIlGLn5F
         bnzf29bXersmue4wdam21u2v8bnvKumcx48SimZTQHgY/0I/J6ljJ5HZagxEpc+XotcQ
         I3hpZDoD8a2ujP2AYkAoLG15I5gNVjTZrSqWsUyvJNHIKlWT3Y5ggaQ46BivmN5DG0hR
         9KXC/IBWD+1XZld+iSEDbfoE7RKQH3dGYxAtZLtgjTT8+z4eyXFDzlc1umSnqobPPVT4
         0Ra0EZOfp32uTwsIdjKttEpdIzSIGa4pCO8koolM5YRKLeGQyIle+bvHpqGlcn+5MAkr
         aqxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OW/gvTkGu86YgUxpgjSRkvij/4SXXCYc66hmNhRMo9c=;
        b=jkqZ6wOOqCz9MsBtTFlb0hL7KheY42c8jvO3BlRzpfOtybg1fSrxXVB4PRbEVTRdFN
         FXeGhRCL7UNZHcxE4RBM8eqbroeR5tkD4Z2FRAr/XY8TS9RiPHWhB1QHUVHir6z7zmVc
         MSK+ECUGf4SV8rwT9aEnHnIb1sW2tEQQzRdaOx+W7pmkta8af+laLwWhKLwCsEYPlOVz
         Qd8QdFZgzV7OCu2xFsXXmN/SWnboK9Kahp/3cyljuOEvS1AY+F2PUrY4Bf25/NlEB964
         S1BZFNjk3rNh56CZ4c6zZCktSJY3t5J+5wztXqYABlH/a4xiffFSGDTrCcB05ah0Cse4
         MESg==
X-Gm-Message-State: AOAM533VRYyndYgfmS2NI/4KWKDxvCu/yUPRAqfsQCfASFSIyf6Nq0qg
        kwvWooa2mtpPDI/0SbFE0g==
X-Google-Smtp-Source: ABdhPJz3z9tzziFA8Y4tikPOGrztipNfWRECVbGGGWQUD3ZzPw+iH0RspWjfzcpT1xXSQModH4AOAQ==
X-Received: by 2002:a17:90a:71cb:: with SMTP id m11mr10999364pjs.14.1602353872462;
        Sat, 10 Oct 2020 11:17:52 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id q65sm14974615pfq.219.2020.10.10.11.17.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 11:17:51 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next v2 3/3] samples: bpf: refactor XDP kern program maps with BTF-defined map
Date:   Sun, 11 Oct 2020 03:17:34 +0900
Message-Id: <20201010181734.1109-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201010181734.1109-1-danieltimlee@gmail.com>
References: <20201010181734.1109-1-danieltimlee@gmail.com>
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


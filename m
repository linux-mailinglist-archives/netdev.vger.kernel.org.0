Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916B4288DAB
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389582AbgJIQER (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388882AbgJIQEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:04:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEC2AC0613D2;
        Fri,  9 Oct 2020 09:04:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f19so7222359pfj.11;
        Fri, 09 Oct 2020 09:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXVs26+o7OprmQfFUNtOyzpup7sKo/CN6TNAkv399Vs=;
        b=mV2j2FdyVdgZ0U9rqzrbQ8wUmVYmXKN1nFbewMjSNj/+BrUpD12Tz7kr02WE66bUJ/
         CfSG04SbQ9/kghySp2ofcqdas9s4mw7u42sXFPXQDIMxluIzP5Naer+ajeghVFDfe9/e
         Tk1ykhERUf0Rmd7nCt32blcdnmYS8RTPKwvTqPkmBA5rASDFjQoyXG3SBvpy628azDcx
         FnQAnsN1+LR5diaFQFl3GmD8xDdrH1CwEDhvDI9QDOSdeBeM+4wHnsUHlaoS5rGlCrYG
         lUIwpEIGzKOsppldacoJY4R78uS0RnOrzQ9Fk3dYqHClenB/Egt1GDrEp5OdTUVqblgH
         ReWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXVs26+o7OprmQfFUNtOyzpup7sKo/CN6TNAkv399Vs=;
        b=I7sYhClA3Z3eQH2qR2a9bKyop8ZDtRAh97sH4V2heDf3hELTuLdPb6O+ujFmNhzGQl
         0i0Dw220S1//4E3Bhps9e1dTr4Onx2BfEEbTj/x91zrpAMLwdHVD3qu2K2+ZLKsKYJve
         ahTfUFLtCawiEBuGewZB/T83M5R5MMmG4D6BLDPiyKp/DESi6z1C4YzHLeGB3EkpkTfv
         qai9PQXCfVAWCrFXgnvwuFkXgDv+nQtEQjEdtEmrqr7+OA1X90n1n2L3f/nJCwNm/eMh
         lt1Cn/nZMMXfj64sLvQqzd4ZZ3VhxxMovFJ/55LlfX347aPJOeAgK8LVjl+XjtTPpswu
         n9sw==
X-Gm-Message-State: AOAM530ScWRpNSO1yl0hOcjjeu3nJMjBSbwEuEzAn/bZTxQg2utg4QwH
        B0ZjE17qpGTP+v67IMeyjw==
X-Google-Smtp-Source: ABdhPJxt6jLY8nctc/I+B0E4qGjZcmndbrd2XrPvBrBe7okR8yI3PZszfAVeWW0FX03sUMJtwqmBRA==
X-Received: by 2002:a17:90a:3b48:: with SMTP id t8mr5467395pjf.32.1602259456091;
        Fri, 09 Oct 2020 09:04:16 -0700 (PDT)
Received: from localhost.localdomain ([182.209.58.45])
        by smtp.gmail.com with ESMTPSA id y19sm11287435pfp.52.2020.10.09.09.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2020 09:04:15 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Xdp <xdp-newbies@vger.kernel.org>
Subject: [PATCH bpf-next 3/3] samples: bpf: refactor XDP kern program maps with BTF-defined map
Date:   Sat, 10 Oct 2020 01:03:53 +0900
Message-Id: <20201009160353.1529-4-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201009160353.1529-1-danieltimlee@gmail.com>
References: <20201009160353.1529-1-danieltimlee@gmail.com>
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
index 33377289e2a8..2fc3ecc9d9aa 100644
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
+	__type(key, int);
+	__type(value, u32);
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


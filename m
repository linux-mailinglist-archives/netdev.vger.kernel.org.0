Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85461C8DB8
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgEGOIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727915AbgEGOId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:33 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F182C05BD0F
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:30 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id i2so5915732qkl.5
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=T1oY202fZuRBk7edtCBgt9wERwBLTlqKZ66WoSf5lZY=;
        b=f2yVzmCHXRdeuATp6UNXLsr9j3vzi+Fv2Pc89/g7pt6XFIZ6WPUU4+XdZMsW7DVnF4
         n2yZWIQNIU5uqr+QnGNi+54MDJHMCWmbz2aEHJzBHDHNSpzBjA+CBfwG7Z59S/rpdkPG
         LRP5O+hDySUXieGDfzzT//qs6ihTwulTSUtefd8x5FObJPRVzJXVd4QcN330/hjd5ClY
         NhpLete2Rc2Yo/B6a+rGhWPckBE91Xb8xmV8Mire4qGR+afiBQH4cNzelPKX1KAbaf4j
         NTdOMBmo0exMGpP1rC3C3K3g3ZQSEcEPqXl443gJphFVGOQ9u1D//QClKbOKVbY7+eLV
         JByQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=T1oY202fZuRBk7edtCBgt9wERwBLTlqKZ66WoSf5lZY=;
        b=cm/LBeruOxEJCM6nt2lUR4aw2DkI23RCM7/I7Lw2dFeyiH47ggH5OnP0LAYIzVbO0O
         XWKrzBhGksMi1V24SR0KnT1drSNbXXtxHIbn4NhgA5zMqope/5LXFjLMVRvtzistgZHM
         mZWZgUoo3x9w+tL6tJmeabuUmoN9+EiG22CdBKKtTmNThihUnQi9IDOIrNGG01gqqLZI
         6p3kA0HX8ynikAfeVoONDlqKIRMv1HghQCx+yJ/LwJajm2VoRk/yHTItX9Vuis9TkLBe
         XZ1PYL9wH+//ZWYT9YJWjCLEXA/oWxl7Aer5IczaJSldNNC6qb3l93fpHiRmwf4d4DZ3
         MPPg==
X-Gm-Message-State: AGi0PuZPj6Nun9BU5l6mFU3DcewZ0n1OkBAVIeakGyej9KKWWvxHiV3J
        gR94G16AAlIJjuxKDr1xMIEwjMvSG7xF
X-Google-Smtp-Source: APiQypKv4Wz5aiAH7yNT+t1Ra+WCZoSjlEFRIBMgUe/3Qo7oXj9ACmTXXXNfvkVwVq5B54XWjvc0IQzGw+4b
X-Received: by 2002:a05:6214:1262:: with SMTP id r2mr13718869qvv.126.1588860509690;
 Thu, 07 May 2020 07:08:29 -0700 (PDT)
Date:   Thu,  7 May 2020 07:07:59 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-4-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 03/23] perf metrics: fix parse errors in skylake metrics
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        linux-kernel@vger.kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-perf-users@vger.kernel.org,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove over escaping with \\.

Fixes: fd5500989c8f (perf vendor events intel: Update metrics from TMAM 3.5)
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json b/tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json
index b4f91137f40c..390bdab1be9d 100644
--- a/tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json
+++ b/tools/perf/pmu-events/arch/x86/skylakex/skx-metrics.json
@@ -328,13 +328,13 @@
     },
     {
         "BriefDescription": "Average latency of data read request to external memory (in nanoseconds). Accounts for demand loads and L1/L2 prefetches",
-        "MetricExpr": "1000000000 * ( cha@event\\=0x36\\\\\\,umask\\=0x21@ / cha@event\\=0x35\\\\\\,umask\\=0x21@ ) / ( cha_0@event\\=0x0@ / duration_time )",
+        "MetricExpr": "1000000000 * ( cha@event\\=0x36\\,umask\\=0x21@ / cha@event\\=0x35\\,umask\\=0x21@ ) / ( cha_0@event\\=0x0@ / duration_time )",
         "MetricGroup": "Memory_Lat",
         "MetricName": "DRAM_Read_Latency"
     },
     {
         "BriefDescription": "Average number of parallel data read requests to external memory. Accounts for demand loads and L1/L2 prefetches",
-        "MetricExpr": "cha@event\\=0x36\\\\\\,umask\\=0x21@ / cha@event\\=0x36\\\\\\,umask\\=0x21\\\\\\,thresh\\=1@",
+        "MetricExpr": "cha@event\\=0x36\\,umask\\=0x21@ / cha@event\\=0x36\\,umask\\=0x21\\,thresh\\=1@",
         "MetricGroup": "Memory_BW",
         "MetricName": "DRAM_Parallel_Reads"
     },
-- 
2.26.2.526.g744177e7f7-goog


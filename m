Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232871CA2D4
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 07:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgEHFhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 01:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbgEHFgv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 01:36:51 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F98C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 22:36:51 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id b13so699712qvk.5
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 22:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m8WpKXu2V+9NqkR5jp5ATN8K2H0ocf3aE3is59DK73Y=;
        b=UREL49hiJMKQT0MfwJtSsvtarRZXQbdKzRdUjiKYFOqK7IONhA54ZD431jAbuWZnuj
         bTxCoCvWB40r0f5ojl0fRYliOvM6RphcZmnSoIHbfnL8zezBl4aJvDjWS79UevNBv8ev
         InnXkRF5ev8kUrvYha/fAOTirjp3erYPPtYa9HyVruMrCUzxEthOLzOPwg4hGkn8GfW6
         ekC6metTeJMu3DZFzzeKioxEV7B34JMUjv6fJEh6KvHd628pj2rGeozGz5aRUfKWbCGe
         +4PlDnF1T4SZgKryW634bC3pJHSZLLCBYz5hOJaOFOB8lq5c9nJsVNteevqL7dKgtz7u
         GmZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m8WpKXu2V+9NqkR5jp5ATN8K2H0ocf3aE3is59DK73Y=;
        b=ZPbKQP0AXINUy0WL+I6lNLtcTTYHrRKdo3m7MAoajKc+kO40fOfDeKIj9H4dCE1AfE
         BoJCjzuyNavJ2Wvk59q29bPRIAeTnJcgb3amlBnG189Eye/3w52nqUqSke/awM3CCOxc
         6KpSVIsQkZwHahPQLpTcdPIPAcyNpe+I3h2LlKJz//DjjZjqe6VjdUWn7O/WMZ2rwoCZ
         Nh/CdO4yMXtppvggs76tyEDz9WsB3bQGSIutGcuZD4VT9q/zrn0JZ8+s0Vl4URaoe1uY
         MDlClFl1tLBPOXTKF720iVdF4BLhA6lRClVd74S8Ud9EjnHL4V5YiuLd61FSen5kH3Yd
         Pkwg==
X-Gm-Message-State: AGi0PuYC1La+LpM0DOwNe9Df3baLBd+7+wV5/L+JbWY7k+gRCel1ql9p
        eELmvapw13WO/ykmyG0nfzzuB0/ofq6A
X-Google-Smtp-Source: APiQypLXi+z6aNv3DyfZ1Xp8rnplzKqQni8RsrK+fRZA16AKXiBN3+ipqABu5Yc2rtiixylA+Pysjl+dowaU
X-Received: by 2002:a0c:f70c:: with SMTP id w12mr1112683qvn.28.1588916210193;
 Thu, 07 May 2020 22:36:50 -0700 (PDT)
Date:   Thu,  7 May 2020 22:36:24 -0700
In-Reply-To: <20200508053629.210324-1-irogers@google.com>
Message-Id: <20200508053629.210324-10-irogers@google.com>
Mime-Version: 1.0
References: <20200508053629.210324-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [RFC PATCH v3 09/14] perf metricgroup: free metric_events on error
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
        Vince Weaver <vincent.weaver@maine.edu>,
        Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a simple memory leak.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index 4f7e36bc49d9..7e1725d61c39 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -186,6 +186,7 @@ static int metricgroup__setup_events(struct list_head *groups,
 		if (!evsel) {
 			pr_debug("Cannot resolve %s: %s\n",
 					eg->metric_name, eg->metric_expr);
+			free(metric_events);
 			continue;
 		}
 		for (i = 0; metric_events[i]; i++)
@@ -193,11 +194,13 @@ static int metricgroup__setup_events(struct list_head *groups,
 		me = metricgroup__lookup(metric_events_list, evsel, true);
 		if (!me) {
 			ret = -ENOMEM;
+			free(metric_events);
 			break;
 		}
 		expr = malloc(sizeof(struct metric_expr));
 		if (!expr) {
 			ret = -ENOMEM;
+			free(metric_events);
 			break;
 		}
 		expr->metric_expr = eg->metric_expr;
-- 
2.26.2.645.ge9eca65c58-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 366311C8E14
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEGOLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:11:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727804AbgEGOI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A746AC05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:26 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o196so4040249ybg.8
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=agpNpPb9ABPgrcjzE8UbvUM5oHf8Sq5TEvUJcEJ/6IE=;
        b=HhhT+08K3dom3gSLbiMkAIr7jNEs49Fw2OajOhbnL5wIg5CUFHIYBQ9EtWdbUNEDG6
         R0zI6+Jrakz3Qpp9wkCrm8q3A5+C+RtcOZaD0fvTcsL03G6O3B58p50n1Gxi4JkhPWZJ
         mkEyf8DOSTA7lyGsbVcG6T2jv7m1JhdqrwuWygpbowcTaSVvPjeExQK7r0pKMdDmupcM
         mg0QYgFfTEkih4qS7g/sTAG/KpeOTLKAO+d/doYvjC/7wOIowP9Gw52bDgBdJ0SGNPxK
         Nx8z7l67LaHUwTNB3IQax3Aom5B6VouckVz50bQUK1b5SbJ1y7UKTgFAA3q6d6z7leO3
         l8jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=agpNpPb9ABPgrcjzE8UbvUM5oHf8Sq5TEvUJcEJ/6IE=;
        b=fO2gQKH/Q5NXMpabhK1veKbrIoFlORJlHokmYKcXp25DHHnQp62TPSbSVYyeGqMnvG
         gWhOfb0VckjJxKP5b4WEPrNh5ESxlD+EarmjVfxlsRSTt+52EftiJ6E4rh1gDJjJw+kM
         Cq/gm/Aj3Abp/WfI78WwoJ5F7xg2pm6yXo6om6bZwFL+VdKxVqKJhNNkuzd9f8Z/bTWM
         7J2coaYfdNRh5By4ohHV10OrEUFWQCdM2G7Yt7i1PHpylgZD1fq2pbGToZa14Jxc5q36
         7PMzCQCCK3W2/3r/3XIcQOvpP4DKAPAf2gN0QgoJd5HGbwq5hw08Dfb62oxg3SIzRuPz
         mP7Q==
X-Gm-Message-State: AGi0PubpXw4iRE6UkMgJGXswO0cet6nFAv3YVGrhW7f6Zm8iEwou5gdK
        tonF1+nHBQ6E4E035d3WjKYjWllG2xOf
X-Google-Smtp-Source: APiQypLjOQdMt93cGSI2VfMH/6fdTqBneltg7x63mwDbaxdlMbnq6lIa4ij95nm/4y6+WbNHSut8TMssroOr
X-Received: by 2002:a25:be81:: with SMTP id i1mr22413804ybk.184.1588860505757;
 Thu, 07 May 2020 07:08:25 -0700 (PDT)
Date:   Thu,  7 May 2020 07:07:57 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-2-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 01/23] perf expr: unlimited escaped characters in a symbol
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

Current expression allows 2 escaped '-,=' characters. However, some
metrics require more, for example Haswell DRAM_BW_Use.

Fixes: 26226a97724d (perf expr: Move expr lexer to flex)
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/expr.l | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/expr.l b/tools/perf/util/expr.l
index 74b9b59b1aa5..73db6a9ef97e 100644
--- a/tools/perf/util/expr.l
+++ b/tools/perf/util/expr.l
@@ -86,7 +86,7 @@ number		[0-9]+
 sch		[-,=]
 spec		\\{sch}
 sym		[0-9a-zA-Z_\.:@?]+
-symbol		{spec}*{sym}*{spec}*{sym}*{spec}*{sym}
+symbol		({spec}|{sym})+
 
 %%
 	struct expr_scanner_ctx *sctx = expr_get_extra(yyscanner);
-- 
2.26.2.526.g744177e7f7-goog


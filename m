Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B13D81C8DC9
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728301AbgEGOI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgEGOIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:55 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5023CC05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:54 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d187so5855029qkc.18
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O3s1th6kwHV7OYn1BOC0SkexVvWRfaB4W2WMHJ3+QAE=;
        b=CK1m+ecJfjS+4WckyJ+MIAJmu9NSdTFzbnEvuTlhNhN2suAzSw1T5RCN8pFKx7qCp4
         n8nnqkhcZQAmfewVBnzZ6SAJQ+TjfCy93ePBEh5Frx6f707haJ1ZrHUlcr7n6906D2DN
         ojqiStE90Xd10Qio2tmn6XzaetPKq7lCzsFLSnIsfHSjm5vbOBl9vWzRWTiiM+ZvHAFN
         hC1/0b5t+keN9XBkOOOUKcIjiW4lsqVd0R1fMzlrlrGhAN0EIoQW7WWxeueiYqiI5D9N
         wAc4DchPEq05tJn/O4RH4yGj03qsYJkUcITNMNLGCEhgB8FQeT8TYfOhk24A/N4h+t8x
         7k8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O3s1th6kwHV7OYn1BOC0SkexVvWRfaB4W2WMHJ3+QAE=;
        b=qE0ioJoFYvokPgjEnXXTxK7zvaSgHYPha5NL0uLaEDwna4lQqJeBEcrHJbj92o7mQy
         FIpmEUlZwdJdQXy0mTwGrj4Hyhwh05AIonv14/500Hg5K543dVVX1TmEhlqdq6p3v2ow
         5rN54WVnHcB7b38UlLmiYxAD22xlyJva1kkujMLp34NYDQXuuvBOx7qYJTjo0w/nOg2k
         hQPfpinpFMakx7gO00uRF5BKzTmRKbJ333Mj0O3HhVdFk9Z8tzHVK9GCYwxx5VVFLK7F
         FTzRIAKJz6jAIRnk+vA1CIKfyKHjbxk59ihkuiF061AN7px73Dx4py2oDFvjRle5QmkW
         2lNA==
X-Gm-Message-State: AGi0PuZVADzICdfe8OtwC2zDHhfT0dtoXUNK0Lu1g3mGbvftkfLDjfq1
        JrHdis8yfr8Eljqa1Rd5iW7ZHIvdclPe
X-Google-Smtp-Source: APiQypIHBeiQoZpM97RY/NesSn20dHYkSwzLM+BOs1oCir4+ihIeJWG35Y9jkK+FwGLI1ItCDPmH/CkTnit7
X-Received: by 2002:ad4:5a48:: with SMTP id ej8mr14045295qvb.122.1588860533355;
 Thu, 07 May 2020 07:08:53 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:11 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-16-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 15/23] perf expr: fix memory leaks in bison
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

Add a destructor for strings to reclaim memory in the event of errors.
Free the ID given for a lookup.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/expr.y | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/expr.y b/tools/perf/util/expr.y
index 21e82a1e11a2..3b49b230b111 100644
--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -27,6 +27,7 @@
 %token EXPR_PARSE EXPR_OTHER EXPR_ERROR
 %token <num> NUMBER
 %token <str> ID
+%destructor { free ($$); } <str>
 %token MIN MAX IF ELSE SMT_ON
 %left MIN MAX IF
 %left '|'
@@ -94,8 +95,10 @@ if_expr:
 expr:	  NUMBER
 	| ID			{ if (lookup_id(ctx, $1, &$$) < 0) {
 					pr_debug("%s not found\n", $1);
+					free($1);
 					YYABORT;
 				  }
+				  free($1);
 				}
 	| expr '|' expr		{ $$ = (long)$1 | (long)$3; }
 	| expr '&' expr		{ $$ = (long)$1 & (long)$3; }
-- 
2.26.2.526.g744177e7f7-goog


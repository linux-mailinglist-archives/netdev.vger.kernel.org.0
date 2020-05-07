Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5531C8DF5
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgEGOKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728198AbgEGOIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:44 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39553C05BD0A
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:44 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id n205so7153113ybf.14
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YFMRcn6rc8qdrbrVjoj3zlWs4rTfREC3MZdtnI5wP3I=;
        b=E11AoE+EBc31Gkgbd+qxgXilstKsTekedzy4/tyPSO4LZXDsYn+X89AaKAg3I26MTE
         iMSLTAfqjUSMtjKb0ROL1QXNambANnCxEhkE9SFcvIjWWHgp3dGMyWQC4UL8OI7lX4M/
         4aHhA47cwihaveXRHVJAT1J+Ny6YNozo2rDIVUxrq+t6fFv9EwCWzOxMeFzKThJLq1gN
         a8yVgBwgKkO/cgjgj1z+R+uMEM6/1wPhwZa7B9OtUsS++6FETmdYGq5CwvgoAAozcTtR
         lL7FW96KQlN9sXH9qPfays50jhkUrzqO0iUf4cY4pQ5YXvo//Oggc9oVDz7PdGGBTjRS
         LVrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YFMRcn6rc8qdrbrVjoj3zlWs4rTfREC3MZdtnI5wP3I=;
        b=rKSeQNIzakTavYDwERPXpqBDDkJweZQ3EgVhOMLfqRZSg8ljC537g15je0s/Zs8ZkQ
         +7JSkBChZ8/ZJMYa6NGitsi3FOAhpNiPcY/k7cz5tJNeMzbbyFXIY6ltwEvaTr7QKaAA
         wgih6k4u4HZuH277q0eVCwfCwrCGt3YAZQDaWmR5A0f1YLgZMiCFCEqnqFGNxVobyBT7
         EknyzaQ3Z8x5r7OZBBrO1AWXyZLwvMX68O52LeSHkmJ/8QKc6vp1mCB6vpVSlil4bJhR
         Na+8OzDK/pj2d7uLEHNIcipyZh1XUoaJkXpBE5ctqYxZnz6xAaVD8y8mbNkhVrqkVIL5
         rjcQ==
X-Gm-Message-State: AGi0PuZRb0EX0d7YStwIDqbNS+/E/Lj4TGUWaqFRFTDy6zk13voLa/gY
        aDqBRmxdTyal8TfwjV5iA2+CfDLNRgyC
X-Google-Smtp-Source: APiQypL2IF6po1tkfUIviVmVSO9IXkOUXBpFY9r+N9WQBNOwpzIxGf1hgyOybK74FwdhA8C4u5u8ZMf3FOcy
X-Received: by 2002:a25:73ca:: with SMTP id o193mr546697ybc.149.1588860523392;
 Thu, 07 May 2020 07:08:43 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:06 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-11-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 10/23] perf expr: print a debug message for division by zero
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

If an expression yields 0 and is then divided-by/modulus-by then the
parsing aborts. Add a debug error message to better enable debugging
when this happens.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/expr.y | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/expr.y b/tools/perf/util/expr.y
index 54260094b947..21e82a1e11a2 100644
--- a/tools/perf/util/expr.y
+++ b/tools/perf/util/expr.y
@@ -103,8 +103,18 @@ expr:	  NUMBER
 	| expr '+' expr		{ $$ = $1 + $3; }
 	| expr '-' expr		{ $$ = $1 - $3; }
 	| expr '*' expr		{ $$ = $1 * $3; }
-	| expr '/' expr		{ if ($3 == 0) YYABORT; $$ = $1 / $3; }
-	| expr '%' expr		{ if ((long)$3 == 0) YYABORT; $$ = (long)$1 % (long)$3; }
+	| expr '/' expr		{ if ($3 == 0) {
+					pr_debug("division by zero\n");
+					YYABORT;
+				  }
+				  $$ = $1 / $3;
+	                        }
+	| expr '%' expr		{ if ((long)$3 == 0) {
+					pr_debug("division by zero\n");
+					YYABORT;
+				  }
+				  $$ = (long)$1 % (long)$3;
+	                        }
 	| '-' expr %prec NEG	{ $$ = -$2; }
 	| '(' if_expr ')'	{ $$ = $2; }
 	| MIN '(' expr ',' expr ')' { $$ = $3 < $5 ? $3 : $5; }
-- 
2.26.2.526.g744177e7f7-goog


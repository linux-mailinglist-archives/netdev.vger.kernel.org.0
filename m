Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E51681C8DF1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgEGOKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 10:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgEGOIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:08:49 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A547C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:08:49 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id m20so5995765qvy.13
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 07:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+ot4xu8P2SexJM6MGXYbzzq/GQaqN2BkLb72ro0O34w=;
        b=lVaXZ0mh6FK8Prt7mNxTyIcNt6EFgoSCMlglY8lrSqIasj9pRYsWpcCEztWEsHYepH
         g5HwSqM4GKiXBK4Lil2OEElO+27ehGfV9SxtHiBWHZYCYHtRjfVben1h3D4ESq2wKWs7
         4lCLPZxDH1N31XcmOoo7qSvDFcDJ/AHBCqGKKg6ouvjs3TYuasNXfE324sZNnpQMT9VC
         Ak9hWT/Qxd5dWoPkTB1Gs8JOTJ6LkOMyQiQLHqmHHROwUrqgvBMof3ObRgQyJIPaEpJj
         OCQi6OIPQCLcX8q3h6YpuqQ44j+eISJeXbhrIZZBzRtl218CVoO87VlFmsfoGbX/9IQV
         ayTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+ot4xu8P2SexJM6MGXYbzzq/GQaqN2BkLb72ro0O34w=;
        b=kLckdjMUpOkuCZO/C8j2F/C/YxB/tHEc62lHGYaNiNJj9J1NZEWkEKhdE8HxuYinTd
         RNGV87q0Z74mzLIdZrMY60aV9KHT9lrL1lauNidJInGQfQ9QfQW4rCllLoOMSjcvSJ53
         aDG0Z+wPgGGd60pk2lpDw70geEJTtN921wDZLw52Y++noK0y3iNJKPfvWzXi27VH53e4
         HCfHj99k08WCV4OKW121v38Cnjugb4o1guYlSilw7X4zQq1QRX8IMOl3m2Lvsxm9MCxU
         bU/+ooh+p5TTnl8rMFPMhWout4g2lECWXz/7CMaIUGGQy7gH+62yxMthzEEEhVqOHglg
         VIsw==
X-Gm-Message-State: AGi0PubdPfHjC/LJijhAaiy80dEhP0ZdxftIjF4nFJIpiSILwntqC+xg
        P9Jo67dvUqQwk/Jooa49GCFhuLyFtX4T
X-Google-Smtp-Source: APiQypLSwGFaeQ3jLZNr0eoQmZByLc8kamDR6qEDf34qocQyZvZ+qRw+9vkmNyoQZakPK3lBCHhQ4zRh0Iaq
X-Received: by 2002:ad4:55e7:: with SMTP id bu7mr13866483qvb.88.1588860515414;
 Thu, 07 May 2020 07:08:35 -0700 (PDT)
Date:   Thu,  7 May 2020 07:08:02 -0700
In-Reply-To: <20200507140819.126960-1-irogers@google.com>
Message-Id: <20200507140819.126960-7-irogers@google.com>
Mime-Version: 1.0
References: <20200507140819.126960-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [RFC PATCH v2 06/23] perf expr: parse numbers as doubles
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

This is expected in expr.y and metrics use floating point values such as
x86 broadwell IFetch_Line_Utilization.

Fixes: 26226a97724d (perf expr: Move expr lexer to flex)
Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/expr.l | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/expr.l b/tools/perf/util/expr.l
index 73db6a9ef97e..ceab11bea6f9 100644
--- a/tools/perf/util/expr.l
+++ b/tools/perf/util/expr.l
@@ -10,12 +10,12 @@
 char *expr_get_text(yyscan_t yyscanner);
 YYSTYPE *expr_get_lval(yyscan_t yyscanner);
 
-static int __value(YYSTYPE *yylval, char *str, int base, int token)
+static double __value(YYSTYPE *yylval, char *str, int token)
 {
-	u64 num;
+	double num;
 
 	errno = 0;
-	num = strtoull(str, NULL, base);
+	num = strtod(str, NULL);
 	if (errno)
 		return EXPR_ERROR;
 
@@ -23,12 +23,12 @@ static int __value(YYSTYPE *yylval, char *str, int base, int token)
 	return token;
 }
 
-static int value(yyscan_t scanner, int base)
+static int value(yyscan_t scanner)
 {
 	YYSTYPE *yylval = expr_get_lval(scanner);
 	char *text = expr_get_text(scanner);
 
-	return __value(yylval, text, base, NUMBER);
+	return __value(yylval, text, NUMBER);
 }
 
 /*
@@ -81,7 +81,7 @@ static int str(yyscan_t scanner, int token, int runtime)
 }
 %}
 
-number		[0-9]+
+number		[0-9]*\.?[0-9]+
 
 sch		[-,=]
 spec		\\{sch}
@@ -105,7 +105,7 @@ min		{ return MIN; }
 if		{ return IF; }
 else		{ return ELSE; }
 #smt_on		{ return SMT_ON; }
-{number}	{ return value(yyscanner, 10); }
+{number}	{ return value(yyscanner); }
 {symbol}	{ return str(yyscanner, ID, sctx->runtime); }
 "|"		{ return '|'; }
 "^"		{ return '^'; }
-- 
2.26.2.526.g744177e7f7-goog


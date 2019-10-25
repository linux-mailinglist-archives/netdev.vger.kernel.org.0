Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9B8E536F
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbfJYSJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:09:58 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:35375 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733156AbfJYSIo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 14:08:44 -0400
Received: by mail-pl1-f202.google.com with SMTP id p14so2011611plq.2
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 11:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=2S2DsvKndhCCCwXhy7APxIUiBul3NbHlVg5iB3GS6wI=;
        b=S1GOx2chJq005n3l26PE/OxzhX5C+hRjXWDeFhCkywyuslxoRAeqypOqIuChfSPfUu
         NA1KhxahOriQwx+Z0BGci3W2BvxgOZ4rdrGOZxI1SKIQSknC8epGu4qXsv/k893YtYdg
         WpOhSw/4+Afdl6vLLCjgFzadtYVTPJe27sil2puX6SEQfWnaOqwv913miQpe9jhpgNVP
         IwZ+wOOqqRJZaO2uGGzu2DukYz3QSOj4FjyMPSnCsMFkongN9d6l+UzyX9w+4bZESB6O
         tq6e2DSiaqb5XaJ+mIvS6WrlxxKexhmJKDP+A/AIzZiyYL3a3f8E1zVVOEwkFpBnODLK
         Q0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2S2DsvKndhCCCwXhy7APxIUiBul3NbHlVg5iB3GS6wI=;
        b=izpLUscHJv7Po/0dFJMB6lBi7w8TWJ4stzEqRhTRS+6G/06BEAAVazeuZfvvRNrFiW
         g85q99ESsdflh+i5798D4CwU6GXXLAzT9q0B/ju6Uvq7ttNipk7pxaon2NAcyTWzkexa
         LLaG1cKoa56t2QJerS0dcboRbATy6EMs4Fhyd5hvi875skwVRHGdg/APYIAu569+NXQR
         ZMi0Qy4vSi7kywm7EFQIFK4fup2JAxAiY8r/YbznMuksBZ9XEgsbSkm4goAiljsKKM0O
         QJfTpPjnGpazrEXPmfvBOcrfvTXbcoOZ57ZI0hnJUOTJ7Q7Iyj4TuvpsG5NL3vwRqE4j
         2owQ==
X-Gm-Message-State: APjAAAXAQ9mxhSW2121LyioduiVPT9FoxzPsHz393uJpjDX64LfmTBGd
        1A8zdmd/4KkLDdkjIbcGU3S29FzGa7cI
X-Google-Smtp-Source: APXvYqwCiOCxWKogyeiMwYvwOtugEYW5dgD9xy0gca9fx0LItS/FqQFuYGbkyTwUtw9zrUcH6p/Wu4erFpVv
X-Received: by 2002:a63:e60b:: with SMTP id g11mr3770780pgh.119.1572026923546;
 Fri, 25 Oct 2019 11:08:43 -0700 (PDT)
Date:   Fri, 25 Oct 2019 11:08:21 -0700
In-Reply-To: <20191025180827.191916-1-irogers@google.com>
Message-Id: <20191025180827.191916-4-irogers@google.com>
Mime-Version: 1.0
References: <20191024190202.109403-1-irogers@google.com> <20191025180827.191916-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v4 3/9] perf tools: avoid a malloc for array events
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
        Andi Kleen <ak@linux.intel.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com
Cc:     Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use realloc rather than malloc+memcpy to possibly avoid a memory
allocation when appending array elements.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.y | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 5863acb34780..ffa1a1b63796 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -689,14 +689,12 @@ array_terms ',' array_term
 	struct parse_events_array new_array;
 
 	new_array.nr_ranges = $1.nr_ranges + $3.nr_ranges;
-	new_array.ranges = malloc(sizeof(new_array.ranges[0]) *
-				  new_array.nr_ranges);
+	new_array.ranges = realloc($1.ranges,
+				sizeof(new_array.ranges[0]) *
+				new_array.nr_ranges);
 	ABORT_ON(!new_array.ranges);
-	memcpy(&new_array.ranges[0], $1.ranges,
-	       $1.nr_ranges * sizeof(new_array.ranges[0]));
 	memcpy(&new_array.ranges[$1.nr_ranges], $3.ranges,
 	       $3.nr_ranges * sizeof(new_array.ranges[0]));
-	free($1.ranges);
 	free($3.ranges);
 	$$ = new_array;
 }
-- 
2.24.0.rc0.303.g954a862665-goog


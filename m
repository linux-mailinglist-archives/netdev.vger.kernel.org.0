Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A17A4EA642
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727412AbfJ3WfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:35:03 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:37527 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfJ3WfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:35:02 -0400
Received: by mail-pl1-f202.google.com with SMTP id r13so2535364pls.4
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NBXoMPDHJVu6DlppqIY2kjj0WH1XM9PlNXSL9vxvGXc=;
        b=to6RZPB9HFoQbqmKAJUjZ3WJ1y220f1xnCCYFZnT8AHAyKvmI8iWBbzxYGOL4HqHKy
         1PmW2Bk89kqcN/6509Ht4gbojZ5Fh0aN5BFvIX8S68OJJTJ6Mff6wholdeCtt3kTjz3U
         w3vdMLOcc7/CbI89RYUlJHak4evKhlgVd+Rl/3BbdoruqPitAijXNWl5sHkS4nBHdEab
         ZSgXoFbdZZJmfYz/5M/8PUltrW61Xa7L/5ZyDlkdvZ+7Ga6yzrmZFGykRxZ7ShYVNaNP
         NJf+XleoCHdf0X22IRjQJPcYBshJ+diy+lRANqX0xK7jRsmAUBhOKu7lRtlqL9tBWAGB
         84HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NBXoMPDHJVu6DlppqIY2kjj0WH1XM9PlNXSL9vxvGXc=;
        b=LK2UYTEPDbel3nuz2OrgwsRqS8PO7fIOyo4//kL4YfM7px3h/mhk3qvGsc8jfg8L1v
         wvV6zfiuDaOfv5IJuV3jVcKODYN792yVZGcq8/7pPfS7BjNuLpW4HOX+R4AjeOHnvt2G
         dIMVOKOeWFPOGoKGc+XCb3QsCfITl+DRtJPQajus19ObBuE9B+71jXlsMGNG+n4SlKlF
         +v3ELWACjVzj5gD6BGLjGJZOOtiOSNm4wt6PQh8x221RriM9wLanzEJVt841vVXFBAaz
         BVcLt1u3HWK7bTbQucRfXMRRQk68xXmHGm6onCIuqXzWgWXLah7IilBCOMDbMOzA2RN3
         xfYQ==
X-Gm-Message-State: APjAAAXH/p3eSXBTeQQKSlZmYEGOPzgZzB3PoGWNuQJGlnC1grkv8NH5
        exqZ6Pm0Scnhmmr9nAtNMr0wtelo5vZ4
X-Google-Smtp-Source: APXvYqwFABu3kNyEZzoXKOLqzFswnHr6Oczw+2eZi3gXz92ar/LQWg0327BtdqSuK5s1slzmYFKaoRLbH4A8
X-Received: by 2002:a63:e145:: with SMTP id h5mr1976435pgk.447.1572474900839;
 Wed, 30 Oct 2019 15:35:00 -0700 (PDT)
Date:   Wed, 30 Oct 2019 15:34:41 -0700
In-Reply-To: <20191030223448.12930-1-irogers@google.com>
Message-Id: <20191030223448.12930-4-irogers@google.com>
Mime-Version: 1.0
References: <20191025180827.191916-1-irogers@google.com> <20191030223448.12930-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 03/10] perf tools: avoid a malloc for array events
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
2.24.0.rc1.363.gb1bccd3e3d-goog


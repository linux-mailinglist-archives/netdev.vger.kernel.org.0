Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D71F3B25
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbfKGWOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:14:52 -0500
Received: from mail-vk1-f201.google.com ([209.85.221.201]:42100 "EHLO
        mail-vk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbfKGWOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:14:51 -0500
Received: by mail-vk1-f201.google.com with SMTP id t128so1782419vkb.9
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 14:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Rdpklo87Cbnc0oQfbWbjnhJvVaMXzhYZMl0FgWRkGnU=;
        b=bgQrPYHrhKXSpGUFfX1LxbonrqWUext52v0flekqJvgvBguDLpbp7reGofJVCdC7L2
         sM9MVXS9NETEurVbRr9UwLAfRlvw1WbnPDrdUhAcu6LJGt9HjxXnfprHm0rQZJjcAvMN
         OwHpTc6tGw5jyc4qsD2ealU5qtUpgLNpsbA5jfyHez4U0BbtI22f9ClSfu0kpcpAK+V0
         Urq2Icc2Aa7LcZHTUzxVLQKaL2ZCZlA5DRTK8E9k9ucVLhyzEIfdICSTaj3QT9+j15ci
         0s8eBcbDUjjXXt2x++C66Irs9zA8jOHuNYxE/raWoL68J7lx+t5+Fk9jxWZJliCStVjU
         ueIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Rdpklo87Cbnc0oQfbWbjnhJvVaMXzhYZMl0FgWRkGnU=;
        b=Wqrtjps1EfNbtGKVpnCRqzo+YXK2srdZtZIS2wCPLsvcHeEk7LECdape4j41WSxowp
         TlrAP7NRcmutpCtU7YBa+TVKTIdVGIIuPxxOdCPgrlhi98bJTEa6NRta1iJH2pyPgpnB
         9k88nJamWgUy+Uy2xYbyfB5c86prAwY1pLXfrch6oz5EHnNxvMkBAY6OPO+aFvtAv9Cn
         N75z7HW54YwByYGJqHlZb8W9AjwLHmjdmKm82Ei165qqfUkxK78a4J4DLxUWqblddK/8
         kb9i0tCy3Tw+9TPICJIc0o0OC8/aDAeRU/VrQrPb4hDzavXo3ijSaHLJLW+oVJAaxm9B
         qqhg==
X-Gm-Message-State: APjAAAWXn40rMHIRmh7YRzrhh/qzi3lyhWlfJmUxifew46yzazJz/HNw
        fqurhykfOACzSgjvruTquNfkd8Y29o5p
X-Google-Smtp-Source: APXvYqz5bNeOCzhT6Gi4ljfOAEEIKtiXk1Y/E29tiX0hIVNxqvj2G3LdSuVpD0YdwTVjUVgXfD7RJRp4RMQ2
X-Received: by 2002:ab0:63:: with SMTP id 90mr4121250uai.91.1573164889634;
 Thu, 07 Nov 2019 14:14:49 -0800 (PST)
Date:   Thu,  7 Nov 2019 14:14:21 -0800
In-Reply-To: <20191107221428.168286-1-irogers@google.com>
Message-Id: <20191107221428.168286-4-irogers@google.com>
Mime-Version: 1.0
References: <20191030223448.12930-1-irogers@google.com> <20191107221428.168286-1-irogers@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH v6 03/10] perf tools: avoid a malloc for array events
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
2.24.0.432.g9d3f5f5b63-goog


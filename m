Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7171FE3B9B
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504301AbfJXTCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:02:23 -0400
Received: from mail-yb1-f201.google.com ([209.85.219.201]:35302 "EHLO
        mail-yb1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406642AbfJXTCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:02:21 -0400
Received: by mail-yb1-f201.google.com with SMTP id o123so19434198ybc.2
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=98x/ZBLRTnMz91JDf+r9eCkgM4R/aoJz7oABA29poQw=;
        b=ZDhWZ5D7Wad+xuhdcDWVOwjHsUewHijXR4y/lysN14gT4QR+/zxGLfhiRxlGwAByFJ
         wvV2FnISzVdGITQXf0PO2HsO/HkwjZV7v2BE0VRLy04+b4hbSO4FKoY7WN4sz/JBP1ZV
         o3uEIPfSt625AEJBsANTLrgdPcGYLg6rMD08yGPhw2CvVkaj5YJyGZa4ERxFIT7hZQQx
         HeODyGP/Z5W+sz6bzgLTdAN+HCfRn7izfeYB2gAdWXzraeS/rDA+lGdfOdKktC7MJl0b
         YSufsmH3+5ztriU/uDRYbI53ZDXG2wUof1NI+EYLa+Zt3raRx1eQYkWBjgz3t8EjKwgQ
         YxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=98x/ZBLRTnMz91JDf+r9eCkgM4R/aoJz7oABA29poQw=;
        b=KnUuI0NGNwFtfxqlsfyWiPyjNzQb9dosVgMdbc2hR+DDTZqDxFrP6OD1kVfTZBR1oK
         VOGGR/s6ZZ90E5mD6iBC76prh3GrHf3av6W40GHeYc73H5KlugXGX2YlKnL7gnm4+e6o
         wY2LJWzDueuvf1bwonLNor39f7jzCjUQ9pnyuG8GLQnK1KjjNEPijdZC4nRjsP80IcIY
         Q0ooBYRvnW3AUA1MvTBYrfRiKgwBVBvNJH4erMFsABzBKuiMk7p//eP92E9sZd105TgQ
         uVsdT6NuAiBkQhsvYxb4lP5SU6PKnM8+wOWkJySs3d1IAmm5pPK2vaMx2U/R2NTkBOvR
         DhkQ==
X-Gm-Message-State: APjAAAWAFyADBBhJof2zjiIOBSWJvvsogch9Hr6PODzQn4BnJl+r95C0
        vmFVt+JJSRBeFCRG2KDgO39k1lH2KOYd
X-Google-Smtp-Source: APXvYqy0z0w7HaNQVrFGbWenHVtVo7T0wRW7iIgngW02X25slgtdxq4MgrTgKqZ5Bo3fCcCgjigLNvemKmy6
X-Received: by 2002:a81:58d6:: with SMTP id m205mr8304346ywb.293.1571943740635;
 Thu, 24 Oct 2019 12:02:20 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:01:58 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191024190202.109403-6-irogers@google.com>
Mime-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 5/9] perf tools: avoid a malloc for array events
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
index 26cb65798522..545ab7cefc20 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -691,14 +691,12 @@ array_terms ',' array_term
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
2.23.0.866.gb869b98d4c-goog


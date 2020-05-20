Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99261DAC06
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 09:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgETH2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 03:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgETH2c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 03:28:32 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3F8C08C5C0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:31 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i190so1006656ybg.6
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 00:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LKKy4EOgcjxJnFjWUFUBMKy8IeFiRStXwAEvj/pKQVw=;
        b=CEYhJcwg0f4hgHy2KLu81eyGz7ACAd9la5BDRLXj9Lvo+9VU0bpSkYhmftvVnSkJXa
         Z6xsHILnqtSr1rxriSmbEBdrTHp1WBRBQkbupoV+zq7OWb+2kqcgXkHEeQ8bNv+5VrvN
         /RyrbVpaFiVYvIYl/BBnzpupmA9j+ADQLD8ggT1EJHRF/1DCJk9axgJN/oMS2laBy/cZ
         wjeFpNcv4tf5YCwIRCLAtNbNP1UXdqsa3LlDjI4CDOXp/zjXXmBD+jWQTta/WtNzR+Zs
         eLlxtYkZna6h6KeDoC+jsO7PPZLGTbNtgELVQi+f9OhW+wVnBg8iftO8HcquGuMPjyQF
         MsPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LKKy4EOgcjxJnFjWUFUBMKy8IeFiRStXwAEvj/pKQVw=;
        b=iwiOC5TigWbw3P4YZKUjvNU6nz7eFRzu39nu4kkKSsMSUHmTnUmhhLyzlMf4w6OwJ8
         NufGgnTcWOoJNREm428fL+rDAF59qh1XQ/SCQfvwT/g2stqP1rUSCFk60uEVU9YAbYyZ
         B2RL5CJo+AKsziktpDW7fjHbb2k1CgRwqECdU5tQONRdS1f9HSdWgizcdLkJw0TYYpuM
         vAKszdlk7gcmL0GU8r3tPx435q3PBcq412bMl/4Y6o6P1SMK0aExzZ6IY1LM6x7zyugA
         vSFp5dRXmmHmQc2MdEU/2i2qUq8Gsuvnfvu9RTe0k2dx3vKcUcq4Y+168Uf5gFdX7svt
         GB4w==
X-Gm-Message-State: AOAM531gnG7xCSmStptRVz1ItO5/Ps1QFji2DrYfTeppyFOSNyt+MCTT
        ci4KCsDUin5TTbLsY+6C099Gt0arZrBd
X-Google-Smtp-Source: ABdhPJwQ50lnRVO0QJ4LMsurz9oD9nYh8VxhBcPlPXBME3O2v0MTpRxh/x4lo31Qvxr+4ILJYejvme4sdhkO
X-Received: by 2002:a5b:14a:: with SMTP id c10mr4688572ybp.369.1589959710270;
 Wed, 20 May 2020 00:28:30 -0700 (PDT)
Date:   Wed, 20 May 2020 00:28:11 -0700
In-Reply-To: <20200520072814.128267-1-irogers@google.com>
Message-Id: <20200520072814.128267-5-irogers@google.com>
Mime-Version: 1.0
References: <20200520072814.128267-1-irogers@google.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be-goog
Subject: [PATCH 4/7] perf metricgroup: Order event groups by size
From:   Ian Rogers <irogers@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Andi Kleen <ak@linux.intel.com>,
        John Garry <john.garry@huawei.com>,
        Jin Yao <yao.jin@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Paul Clarke <pc@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
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

When adding event groups to the group list, insert them in size order.
This performs an insertion sort on the group list. By placing the
largest groups at the front of the group list it is possible to see if a
larger group contains the same events as a later group. This can make
the later group redundant - it can reuse the events from the large group.
A later patch will add this sharing.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/metricgroup.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/metricgroup.c b/tools/perf/util/metricgroup.c
index afd960d03a77..52e4c3e4748a 100644
--- a/tools/perf/util/metricgroup.c
+++ b/tools/perf/util/metricgroup.c
@@ -508,7 +508,21 @@ static int __metricgroup__add_metric(struct list_head *group_list,
 		return -EINVAL;
 	}
 
-	list_add_tail(&eg->nd, group_list);
+	if (list_empty(group_list))
+		list_add(&eg->nd, group_list);
+	else {
+		struct list_head *pos;
+
+		/* Place the largest groups at the front. */
+		list_for_each_prev(pos, group_list) {
+			struct egroup *old = list_entry(pos, struct egroup, nd);
+
+			if (hashmap__size(&eg->pctx.ids) <=
+			    hashmap__size(&old->pctx.ids))
+				break;
+		}
+		list_add(&eg->nd, pos);
+	}
 
 	return 0;
 }
-- 
2.26.2.761.g0e0b3e54be-goog


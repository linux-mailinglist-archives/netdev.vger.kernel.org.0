Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3B55E0F69
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732582AbfJWAyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:09 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:34562 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732491AbfJWAyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:08 -0400
Received: by mail-pg1-f201.google.com with SMTP id l11so6264519pgg.1
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FMgQDO+Dnj5IilbdBYKNu48aqofIvdKnV+5Czp2NCJk=;
        b=aD+ecd8qy5XtTCWk57ZL9YxyPdxh61JhJmiWz5tbPXcunacXfmH4RlJVWnFs275uEc
         3ToWc6yaeXXrZGHeJutdTeyWtSRvNshxMGBD8C1ep5Yp1WJzgqgYjc5x0A7GLMbrwzjG
         YRuXjQP1DxkSygys3+x+DZ2TZvQzbnwEx00bO6NMOXB9NNvuEudMkhjV8WnhtRPOIGNW
         baLqIgipOvh3Jpc5gQJdQui3X9GBWZhdrzF/GtXueJoQ0gw5tDNKQ4P0HC3mG+rYbBgB
         20riwU0+CTB4jy1DCXT6Lfw7kdt0QmRsc1WuL/Y0mKh8anrr4OXReXj5244zTaHOtACQ
         8jCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FMgQDO+Dnj5IilbdBYKNu48aqofIvdKnV+5Czp2NCJk=;
        b=Z1SJ1za/ja4I2YMg/tmj1kP3NBVCCXity4DKWb7oAZAevSJ/SrgH205ld0FDq+oSxU
         IRVDHx92EC/egeIVOHNr5lXBwKQgTTmiwyqjitXHnk2r1E+GCjf5iVlHTC+EVAC4p7Y+
         uCnOFS7rt30Sxr5cuI3DnE89cvXvliSjhoYmSMibiaAg9ConTPXrlGQ4Jbuj/W2gEHE8
         CDJLQiq2ih+4sH7YsoOgHIcXElN0fOGtUisaPGeTOidGIlL6ZMbqoOi5HQ27JE2vqnBH
         ZXI/JU2f2BVamHppNEnYk1zyZ8nQDIK35qY2GcYYfJLpAvsZBMTcoHKhemPruH/mAmXi
         ZVsw==
X-Gm-Message-State: APjAAAVsnOhI0oP+MK9EjqRevsesSKQclJtcvINpA8/krKqWFJZTIEae
        +pXqRvvbk1nu0pDGO8yWZtvv0ubvwur7
X-Google-Smtp-Source: APXvYqyREqZX+QnAAEVJzMEdYSL+vkbj69zfIuRXQ7/lc6aXG4ZLFgqIA3xEwdGAgjqe9gGRsmIemsZ/K483
X-Received: by 2002:a63:ce0d:: with SMTP id y13mr842966pgf.430.1571792046163;
 Tue, 22 Oct 2019 17:54:06 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:31 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-4-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 3/9] perf tools: ensure config and str in terms are unique
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

Make it easier to release memory associated with parse event terms by
duplicating the string for the config name and ensuring the val string
is a duplicate.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 33 ++++++++++++++++++++++++---------
 tools/perf/util/parse-events.y |  4 +++-
 2 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a8f8801bd127..f7c8d0853d71 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1424,7 +1424,6 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 			       char *str, struct list_head **listp)
 {
-	struct list_head *head;
 	struct parse_events_term *term;
 	struct list_head *list;
 	struct perf_pmu *pmu = NULL;
@@ -1441,19 +1440,30 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 
 		list_for_each_entry(alias, &pmu->aliases, list) {
 			if (!strcasecmp(alias->name, str)) {
+				struct list_head *head;
+				char *config;
+
 				head = malloc(sizeof(struct list_head));
 				if (!head)
 					return -1;
 				INIT_LIST_HEAD(head);
-				if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
-							   str, 1, false, &str, NULL) < 0)
+				config = strdup(str);
+				if (!config)
+					return -1;
+				if (parse_events_term__num(&term,
+						   PARSE_EVENTS__TERM_TYPE_USER,
+						   config, 1, false, &config,
+						   NULL) < 0) {
+					free(list);
+					free(config);
 					return -1;
+				}
 				list_add_tail(&term->list, head);
 
 				if (!parse_events_add_pmu(parse_state, list,
 							  pmu->name, head,
 							  true, true)) {
-					pr_debug("%s -> %s/%s/\n", str,
+					pr_debug("%s -> %s/%s/\n", config,
 						 pmu->name, alias->str);
 					ok++;
 				}
@@ -1462,8 +1472,10 @@ int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
 			}
 		}
 	}
-	if (!ok)
+	if (!ok) {
+		free(list);
 		return -1;
+	}
 	*listp = list;
 	return 0;
 }
@@ -2761,13 +2773,13 @@ int parse_events_term__sym_hw(struct parse_events_term **term,
 	struct parse_events_term temp = {
 		.type_val  = PARSE_EVENTS__TERM_TYPE_STR,
 		.type_term = PARSE_EVENTS__TERM_TYPE_USER,
-		.config    = config ?: (char *) "event",
+		.config    = config ?: strdup("event"),
 	};
 
 	BUG_ON(idx >= PERF_COUNT_HW_MAX);
 	sym = &event_symbols_hw[idx];
 
-	return new_term(term, &temp, (char *) sym->symbol, 0);
+	return new_term(term, &temp, strdup(sym->symbol), 0);
 }
 
 int parse_events_term__clone(struct parse_events_term **new,
@@ -2776,12 +2788,15 @@ int parse_events_term__clone(struct parse_events_term **new,
 	struct parse_events_term temp = {
 		.type_val  = term->type_val,
 		.type_term = term->type_term,
-		.config    = term->config,
+		.config    = term->config ? strdup(term->config) : NULL,
 		.err_term  = term->err_term,
 		.err_val   = term->err_val,
 	};
 
-	return new_term(new, &temp, term->val.str, term->val.num);
+	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM)
+		return new_term(new, &temp, NULL, term->val.num);
+	else
+		return new_term(new, &temp, strdup(term->val.str), 0);
 }
 
 int parse_events_copy_term_list(struct list_head *old,
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 48126ae4cd13..27d6b187c9b1 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -644,9 +644,11 @@ PE_NAME array '=' PE_VALUE
 PE_DRV_CFG_TERM
 {
 	struct parse_events_term *term;
+	char *config = strdup($1);
 
+	ABORT_ON(!config);
 	ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CFG,
-					$1, $1, &@1, NULL));
+					config, $1, &@1, NULL));
 	$$ = term;
 }
 
-- 
2.23.0.866.gb869b98d4c-goog


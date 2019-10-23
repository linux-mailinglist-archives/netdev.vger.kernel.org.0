Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C02E0F7D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733269AbfJWAyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:54:51 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:56740 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732229AbfJWAyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:54:04 -0400
Received: by mail-pl1-f202.google.com with SMTP id y2so145240plp.23
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:54:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Hvl11X8G79qfzptKicQV7uupBd7BKCDNwU1VoFozVWw=;
        b=IG1MQEnulSwyMGomBYhK5FRCkgOvrHQfxf10IfN7ozmVN/PZ0Ccj4DEM33CXCR6z+a
         xaxWjAXq/MZ2tLzP+iAprwB7QqsvCjql+4B1TDDr4n6bEI1Rzk5FIxISav+IkXFL+7Oj
         W1GV6G/V2zmkcawEfG4pxSvopsVcmKQNneNV2NIYSsSY2K9usQlj+EogKnpZad8OkiFs
         Vq9+nNsDs2zLElWeqFHCLVJLgOOBV2X5EmGGp6ZCeuE3y92QaKRrIM31/PuaHWdGyKFM
         Mh0iH+cQSTvyFZr/85m+/9zuyF3RMAGiNdN1qRz7fs2VW9V2+G6BhSxsVq+l68STf5G2
         OyvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Hvl11X8G79qfzptKicQV7uupBd7BKCDNwU1VoFozVWw=;
        b=iJP6rGUHP9iNZx6GK9IaZo2lMdzkIENIBe9J3NimY/rNGOX2a0gNBA60vZHjUgppWQ
         h2YhofyobahkFNFmdqrLw8S7pjXl7JeAVtFfiOhS3e3x4MdI8Gttq9dpDC/O/llu5iyq
         4VOpHBSgZn7EJ0Xm01rLhQjiRLCL0hjjM7XDqbuowwHumr8rDzMViNxNirQoU5XFfigt
         x4N8CWoqlvuhM2Meq6zIOJBKJzMsmju1pSI8NzL1cY/wMBvcno48ToRxv0I/tINR35S6
         aOkt+W9awYcjbJLIiQYIAvpK63t/oTm5qaDIK+vsL+QkAOtgp6cFiyZd6dOxO55e1NPO
         1RIw==
X-Gm-Message-State: APjAAAVTtYkK9kYXG5lG81RaoqD44zuNR3ozwSOIQ+9OG6m9yHaNWYIJ
        yi3qcdQzs86CKgl9ENMlVR0ZWcDGNZo6
X-Google-Smtp-Source: APXvYqwI0k7iK6s8rsvO6IQH5HK4CMeRWp6dILPLypvDaNIOn1n4FTVz5DmyeTjDJqc4bRIWbzkmljCwZQ3V
X-Received: by 2002:a63:1511:: with SMTP id v17mr6824541pgl.34.1571792041077;
 Tue, 22 Oct 2019 17:54:01 -0700 (PDT)
Date:   Tue, 22 Oct 2019 17:53:29 -0700
In-Reply-To: <20191023005337.196160-1-irogers@google.com>
Message-Id: <20191023005337.196160-2-irogers@google.com>
Mime-Version: 1.0
References: <20191017170531.171244-1-irogers@google.com> <20191023005337.196160-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v2 1/9] perf tools: add parse events append error
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

Parse event error handling may overwrite one error string with another
creating memory leaks and masking errors. Introduce a helper routine
that appends error messages and avoids the memory leak.

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 102 ++++++++++++++++++++++-----------
 tools/perf/util/parse-events.h |   2 +
 tools/perf/util/pmu.c          |  36 ++++++------
 3 files changed, 89 insertions(+), 51 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index db882f630f7e..4d42344698b8 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -182,6 +182,34 @@ static int tp_event_has_id(const char *dir_path, struct dirent *evt_dir)
 
 #define MAX_EVENT_LENGTH 512
 
+void parse_events__append_error(struct parse_events_error *err, int idx,
+				char *str, char *help)
+{
+	char *new_str = NULL;
+
+	WARN(!str, "WARNING: failed to provide error string");
+	if (err->str) {
+		int ret;
+
+		if (err->help)
+			ret = asprintf(&new_str,
+				"%s (previous error: %s(help: %s))",
+				str, err->str, err->help);
+		else
+			ret = asprintf(&new_str,
+				"%s (previous error: %s)",
+				str, err->str);
+		if (ret < 0)
+			new_str = NULL;
+		else
+			zfree(&str);
+	}
+	err->idx = idx;
+	free(err->str);
+	err->str = new_str ?: str;
+	free(err->help);
+	err->help = help;
+}
 
 struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
@@ -931,13 +959,12 @@ static int check_type_val(struct parse_events_term *term,
 	if (type == term->type_val)
 		return 0;
 
-	if (err) {
-		err->idx = term->err_val;
-		if (type == PARSE_EVENTS__TERM_TYPE_NUM)
-			err->str = strdup("expected numeric value");
-		else
-			err->str = strdup("expected string value");
-	}
+	if (err)
+		parse_events__append_error(err, term->err_val,
+					type == PARSE_EVENTS__TERM_TYPE_NUM
+					? strdup("expected numeric value")
+					: strdup("expected string value"),
+					NULL);
 	return -EINVAL;
 }
 
@@ -972,8 +999,11 @@ static bool config_term_shrinked;
 static bool
 config_term_avail(int term_type, struct parse_events_error *err)
 {
+	char *err_str;
+
 	if (term_type < 0 || term_type >= __PARSE_EVENTS__TERM_TYPE_NR) {
-		err->str = strdup("Invalid term_type");
+		parse_events__append_error(err, -1,
+					strdup("Invalid term_type"), NULL);
 		return false;
 	}
 	if (!config_term_shrinked)
@@ -992,9 +1022,9 @@ config_term_avail(int term_type, struct parse_events_error *err)
 			return false;
 
 		/* term_type is validated so indexing is safe */
-		if (asprintf(&err->str, "'%s' is not usable in 'perf stat'",
-			     config_term_names[term_type]) < 0)
-			err->str = NULL;
+		if (asprintf(&err_str, "'%s' is not usable in 'perf stat'",
+				config_term_names[term_type]) >= 0)
+			parse_events__append_error(err, -1, err_str, NULL);
 		return false;
 	}
 }
@@ -1036,17 +1066,20 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
 		CHECK_TYPE_VAL(STR);
 		if (strcmp(term->val.str, "no") &&
-		    parse_branch_str(term->val.str, &attr->branch_sample_type)) {
-			err->str = strdup("invalid branch sample type");
-			err->idx = term->err_val;
+		    parse_branch_str(term->val.str,
+				    &attr->branch_sample_type)) {
+			parse_events__append_error(err, term->err_val,
+					strdup("invalid branch sample type"),
+					NULL);
 			return -EINVAL;
 		}
 		break;
 	case PARSE_EVENTS__TERM_TYPE_TIME:
 		CHECK_TYPE_VAL(NUM);
 		if (term->val.num > 1) {
-			err->str = strdup("expected 0 or 1");
-			err->idx = term->err_val;
+			parse_events__append_error(err, term->err_val,
+						strdup("expected 0 or 1"),
+						NULL);
 			return -EINVAL;
 		}
 		break;
@@ -1080,8 +1113,9 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_PERCORE:
 		CHECK_TYPE_VAL(NUM);
 		if ((unsigned int)term->val.num > 1) {
-			err->str = strdup("expected 0 or 1");
-			err->idx = term->err_val;
+			parse_events__append_error(err, term->err_val,
+						strdup("expected 0 or 1"),
+						NULL);
 			return -EINVAL;
 		}
 		break;
@@ -1089,9 +1123,9 @@ do {									   \
 		CHECK_TYPE_VAL(NUM);
 		break;
 	default:
-		err->str = strdup("unknown term");
-		err->idx = term->err_term;
-		err->help = parse_events_formats_error_string(NULL);
+		parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				parse_events_formats_error_string(NULL));
 		return -EINVAL;
 	}
 
@@ -1141,11 +1175,10 @@ static int config_term_tracepoint(struct perf_event_attr *attr,
 	case PARSE_EVENTS__TERM_TYPE_AUX_OUTPUT:
 		return config_term_common(attr, term, err);
 	default:
-		if (err) {
-			err->idx = term->err_term;
-			err->str = strdup("unknown term");
-			err->help = strdup("valid terms: call-graph,stack-size\n");
-		}
+		if (err)
+			parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				strdup("valid terms: call-graph,stack-size\n"));
 		return -EINVAL;
 	}
 
@@ -1323,10 +1356,12 @@ int parse_events_add_pmu(struct parse_events_state *parse_state,
 
 	pmu = perf_pmu__find(name);
 	if (!pmu) {
-		if (asprintf(&err->str,
+		char *err_str;
+
+		if (asprintf(&err_str,
 				"Cannot find PMU `%s'. Missing kernel support?",
-				name) < 0)
-			err->str = NULL;
+				name) >= 0)
+			parse_events__append_error(err, -1, err_str, NULL);
 		return -EINVAL;
 	}
 
@@ -2797,13 +2832,10 @@ void parse_events__clear_array(struct parse_events_array *a)
 void parse_events_evlist_error(struct parse_events_state *parse_state,
 			       int idx, const char *str)
 {
-	struct parse_events_error *err = parse_state->error;
-
-	if (!err)
+	if (!parse_state->error)
 		return;
-	err->idx = idx;
-	err->str = strdup(str);
-	WARN_ONCE(!err->str, "WARNING: failed to allocate error string");
+
+	parse_events__append_error(parse_state->error, idx, strdup(str), NULL);
 }
 
 static void config_terms_list(char *buf, size_t buf_sz)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 769e07cddaa2..a7d42faeab0c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -124,6 +124,8 @@ struct parse_events_state {
 	struct list_head	  *terms;
 };
 
+void parse_events__append_error(struct parse_events_error *err, int idx,
+				char *str, char *help);
 void parse_events__shrink_config_terms(void);
 int parse_events__is_hardcoded_term(struct parse_events_term *term);
 int parse_events_term__num(struct parse_events_term **term,
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index adbe97e941dd..0fc2a51bb953 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1050,9 +1050,9 @@ static int pmu_config_term(struct list_head *formats,
 		if (err) {
 			char *pmu_term = pmu_formats_string(formats);
 
-			err->idx  = term->err_term;
-			err->str  = strdup("unknown term");
-			err->help = parse_events_formats_error_string(pmu_term);
+			parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				parse_events_formats_error_string(pmu_term));
 			free(pmu_term);
 		}
 		return -EINVAL;
@@ -1079,10 +1079,10 @@ static int pmu_config_term(struct list_head *formats,
 	if (term->type_val == PARSE_EVENTS__TERM_TYPE_NUM) {
 		if (term->no_value &&
 		    bitmap_weight(format->bits, PERF_PMU_FORMAT_BITS) > 1) {
-			if (err) {
-				err->idx = term->err_val;
-				err->str = strdup("no value assigned for term");
-			}
+			if (err)
+				parse_events__append_error(err, term->err_val,
+					   strdup("no value assigned for term"),
+					   NULL);
 			return -EINVAL;
 		}
 
@@ -1093,10 +1093,10 @@ static int pmu_config_term(struct list_head *formats,
 				pr_info("Invalid sysfs entry %s=%s\n",
 						term->config, term->val.str);
 			}
-			if (err) {
-				err->idx = term->err_val;
-				err->str = strdup("expected numeric value");
-			}
+			if (err)
+				parse_events__append_error(err, term->err_val,
+					strdup("expected numeric value"),
+					NULL);
 			return -EINVAL;
 		}
 
@@ -1108,11 +1108,15 @@ static int pmu_config_term(struct list_head *formats,
 	max_val = pmu_format_max_value(format->bits);
 	if (val > max_val) {
 		if (err) {
-			err->idx = term->err_val;
-			if (asprintf(&err->str,
-				     "value too big for format, maximum is %llu",
-				     (unsigned long long)max_val) < 0)
-				err->str = strdup("value too big for format");
+			char *err_str;
+
+			parse_events__append_error(err, term->err_val,
+				asprintf(&err_str,
+				    "value too big for format, maximum is %llu",
+				    (unsigned long long)max_val) < 0
+				    ? strdup("value too big for format")
+				    : err_str,
+				    NULL);
 			return -EINVAL;
 		}
 		/*
-- 
2.23.0.866.gb869b98d4c-goog


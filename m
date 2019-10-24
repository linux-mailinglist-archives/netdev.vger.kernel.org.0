Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEE8E3B92
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504249AbfJXTCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:02:13 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:37623 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504239AbfJXTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 15:02:11 -0400
Received: by mail-pf1-f201.google.com with SMTP id p2so19760116pff.4
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 12:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc:content-transfer-encoding;
        bh=LatC+wbpvgZY15QWxZ6yx67BUGWlegtQyyvDTHYnuYc=;
        b=Ken2R02urqeEoMlzX0yqZLTfdINHC0BDtLNlTdu39stau9C4ovbhYo9mPq+geZq0/J
         WYJ6ok8cPh7Dz8kB2V71vN0ZMhkBxokrTUe4lC+jWQbopaMsaZKi5iDIvkUPfHqiSNe1
         ARsTFZtiB+e5gVE03XDQaLtXrKeFZcm2rKnluxXlbWEQ0UizpXJ3WooqwiFlKAuJeUd2
         XzSKe2VF8ApA/OnyGm+B2RqIzmlq0JyT7OHySBkDMuYNM+htOn3jr89Tflt24CFwrM8X
         0OK47ChwO8WzC3u+wLmaDQ3cevjC5AnT8sUTEjQQV5DKKeR1x8oSlT1OZK0hn5xJW+8a
         n08Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc:content-transfer-encoding;
        bh=LatC+wbpvgZY15QWxZ6yx67BUGWlegtQyyvDTHYnuYc=;
        b=dh7UC65kyLek/We5yuY63d4GhU1JQMQijB5Mn1MopkAVWPG5fq8q+O/MJngXaO1Q8D
         bx1n16H7iax9tFapom67VmmUoiTdE2N20mwRyFlcZAz3dst0IBGA7yP1PDEJcU/1ezPl
         4YeU0+o7eKdWL2m+rSMdd85BjsZFpRyXel16gdlYEBcvrxwoZa6+g1SJNe0AVa87etSd
         CJsW2Wzf615+rxdeH4BvVSQYedNIpkUS2orO7AvQD0MW5SGEOW5s3UmyKXapQ2bjpVkB
         Ozs006ZdS19x8hsocnIqJytnEDdBW3fywVe1zubJdcxsap7TBrRwGDhLE+gviWM8CHp2
         6vmQ==
X-Gm-Message-State: APjAAAVBVxLa1VuBziWtb3ZUyFuBPF8QJPEBMsmnMVSZjMybWjHVv+N/
        zQnBx0BGpu0AE6sckEGr15e684+iuhG/
X-Google-Smtp-Source: APXvYqxpFajHdTKYdBV3wrVXxlleTV2qG6rZ0qAgAGxO8Xa5lBQa2Wj5+r6Ff3a02+Zl0JnL1mS/QNHCc/mT
X-Received: by 2002:a63:cf4a:: with SMTP id b10mr17497860pgj.86.1571943729980;
 Thu, 24 Oct 2019 12:02:09 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:01:54 -0700
In-Reply-To: <20191024190202.109403-1-irogers@google.com>
Message-Id: <20191024190202.109403-2-irogers@google.com>
Mime-Version: 1.0
References: <20191023005337.196160-1-irogers@google.com> <20191024190202.109403-1-irogers@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH v3 1/9] perf tools: add parse events append error
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
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Parse event error handling may overwrite one error string with another
creating memory leaks and masking errors. Introduce a helper routine
that appends error messages and avoids the memory leak.

A reproduction of this problem can be seen with:
  perf stat -e c/c/
After this change this produces:
event syntax error: 'c/c/'
                       \___ unknown term (previous error: unknown term (pre=
vious error: unknown term (previous error: unknown term (previous error: un=
known term (previous error: unknown term (previous error: unknown term (pre=
vious error: unknown term (previous error: unknown term (previous error: un=
known term (previous error: unknown term (previous error: unknown term (pre=
vious error: unknown term (previous error: unknown term (previous error: un=
known term (previous error: unknown term (previous error: unknown term (pre=
vious error: unknown term (previous error: unknown term (previous error: un=
known term (previous error: unknown term (previous error: Cannot find PMU `=
c'. Missing kernel support?)(help: valid terms: event,filter_rem,filter_opc=
0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_opc1,ti=
d_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config,confi=
g1,config2,name,period,percore))(help: valid terms: event,filter_rem,filter=
_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_opc=
1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config,c=
onfig1,config2,name,period,percore))(help: valid terms: event,filter_rem,fi=
lter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter=
_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,conf=
ig,config1,config2,name,period,percore))(help: valid terms: event,filter_re=
m,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,fi=
lter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,=
config,config1,config2,name,period,percore))(help: valid terms: event,filte=
r_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umas=
k,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter=
_nm,config,config1,config2,name,period,percore))(help: valid terms: event,f=
ilter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,=
umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fi=
lter_nm,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,frontend,cmask,co=
nfig,config1,config2,name,period,percore))(help: valid terms: event,filter_=
rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,=
filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_n=
m,config,config1,config2,name,period,percore))(help: valid terms: event,fil=
ter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,um=
ask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filt=
er_nm,config,config1,config2,name,period,percore))(help: valid terms: event=
,config,config1,config2,name,period,percore))(help: valid terms: event,filt=
er_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,uma=
sk,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filte=
r_nm,config,config1,config2,name,period,percore))(help: valid terms: event,=
filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv=
,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,f=
ilter_nm,config,config1,config2,name,period,percore))(help: valid terms: ev=
ent,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc=
,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_sta=
te,filter_nm,config,config1,config2,name,period,percore))(help: valid terms=
: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filte=
r_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter=
_state,filter_nm,config,config1,config2,name,period,percore))(help: valid t=
erms: event,config,config1,config2,name,period,percore))(help: valid terms:=
 event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter=
_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_=
state,filter_nm,config,config1,config2,name,period,percore))(help: valid te=
rms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fi=
lter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,fil=
ter_state,filter_nm,config,config1,config2,name,period,percore))(help: vali=
d terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_lo=
c,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm=
,filter_state,filter_nm,config,config1,config2,name,period,percore))(help: =
valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filte=
r_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_no=
t_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(he=
lp: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,f=
ilter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filte=
r_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore)=
)

valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filte=
r_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_no=
t_nm,filter_state,filter_nm,config,config1,config2,name,period,percore
Run 'perf list' for a list of valid events

 Usage: perf stat [<options>] [<command>]

    -e, --event <event>   event selector. use 'perf list' to list available=
 events

Signed-off-by: Ian Rogers <irogers@google.com>
---
 tools/perf/util/parse-events.c | 100 +++++++++++++++++++++++----------
 tools/perf/util/parse-events.h |   2 +
 tools/perf/util/pmu.c          |  30 ++++++----
 3 files changed, 89 insertions(+), 43 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.=
c
index db882f630f7e..edb3ae76777d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -182,6 +182,38 @@ static int tp_event_has_id(const char *dir_path, struc=
t dirent *evt_dir)
=20
 #define MAX_EVENT_LENGTH 512
=20
+void parse_events__append_error(struct parse_events_error *err, int idx,
+				char *str, char *help)
+{
+	char *new_str =3D NULL;
+
+	if (WARN(!str, "WARNING: failed to provide error string")) {
+		free(help);
+		return;
+	}
+	if (err->str) {
+		int ret;
+
+		if (err->help) {
+			ret =3D asprintf(&new_str,
+				"%s (previous error: %s(help: %s))",
+				str, err->str, err->help);
+		} else {
+			ret =3D asprintf(&new_str,
+				"%s (previous error: %s)",
+				str, err->str);
+		}
+		if (ret < 0)
+			new_str =3D NULL;
+		else
+			zfree(&str);
+	}
+	err->idx =3D idx;
+	free(err->str);
+	err->str =3D new_str ?: str;
+	free(err->help);
+	err->help =3D help;
+}
=20
 struct tracepoint_path *tracepoint_id_to_path(u64 config)
 {
@@ -932,11 +964,11 @@ static int check_type_val(struct parse_events_term *t=
erm,
 		return 0;
=20
 	if (err) {
-		err->idx =3D term->err_val;
-		if (type =3D=3D PARSE_EVENTS__TERM_TYPE_NUM)
-			err->str =3D strdup("expected numeric value");
-		else
-			err->str =3D strdup("expected string value");
+		parse_events__append_error(err, term->err_val,
+					type =3D=3D PARSE_EVENTS__TERM_TYPE_NUM
+					? strdup("expected numeric value")
+					: strdup("expected string value"),
+					NULL);
 	}
 	return -EINVAL;
 }
@@ -972,8 +1004,11 @@ static bool config_term_shrinked;
 static bool
 config_term_avail(int term_type, struct parse_events_error *err)
 {
+	char *err_str;
+
 	if (term_type < 0 || term_type >=3D __PARSE_EVENTS__TERM_TYPE_NR) {
-		err->str =3D strdup("Invalid term_type");
+		parse_events__append_error(err, -1,
+					strdup("Invalid term_type"), NULL);
 		return false;
 	}
 	if (!config_term_shrinked)
@@ -992,9 +1027,9 @@ config_term_avail(int term_type, struct parse_events_e=
rror *err)
 			return false;
=20
 		/* term_type is validated so indexing is safe */
-		if (asprintf(&err->str, "'%s' is not usable in 'perf stat'",
-			     config_term_names[term_type]) < 0)
-			err->str =3D NULL;
+		if (asprintf(&err_str, "'%s' is not usable in 'perf stat'",
+				config_term_names[term_type]) >=3D 0)
+			parse_events__append_error(err, -1, err_str, NULL);
 		return false;
 	}
 }
@@ -1036,17 +1071,20 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
 		CHECK_TYPE_VAL(STR);
 		if (strcmp(term->val.str, "no") &&
-		    parse_branch_str(term->val.str, &attr->branch_sample_type)) {
-			err->str =3D strdup("invalid branch sample type");
-			err->idx =3D term->err_val;
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
-			err->str =3D strdup("expected 0 or 1");
-			err->idx =3D term->err_val;
+			parse_events__append_error(err, term->err_val,
+						strdup("expected 0 or 1"),
+						NULL);
 			return -EINVAL;
 		}
 		break;
@@ -1080,8 +1118,9 @@ do {									   \
 	case PARSE_EVENTS__TERM_TYPE_PERCORE:
 		CHECK_TYPE_VAL(NUM);
 		if ((unsigned int)term->val.num > 1) {
-			err->str =3D strdup("expected 0 or 1");
-			err->idx =3D term->err_val;
+			parse_events__append_error(err, term->err_val,
+						strdup("expected 0 or 1"),
+						NULL);
 			return -EINVAL;
 		}
 		break;
@@ -1089,9 +1128,9 @@ do {									   \
 		CHECK_TYPE_VAL(NUM);
 		break;
 	default:
-		err->str =3D strdup("unknown term");
-		err->idx =3D term->err_term;
-		err->help =3D parse_events_formats_error_string(NULL);
+		parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				parse_events_formats_error_string(NULL));
 		return -EINVAL;
 	}
=20
@@ -1142,9 +1181,9 @@ static int config_term_tracepoint(struct perf_event_a=
ttr *attr,
 		return config_term_common(attr, term, err);
 	default:
 		if (err) {
-			err->idx =3D term->err_term;
-			err->str =3D strdup("unknown term");
-			err->help =3D strdup("valid terms: call-graph,stack-size\n");
+			parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				strdup("valid terms: call-graph,stack-size\n"));
 		}
 		return -EINVAL;
 	}
@@ -1323,10 +1362,12 @@ int parse_events_add_pmu(struct parse_events_state =
*parse_state,
=20
 	pmu =3D perf_pmu__find(name);
 	if (!pmu) {
-		if (asprintf(&err->str,
+		char *err_str;
+
+		if (asprintf(&err_str,
 				"Cannot find PMU `%s'. Missing kernel support?",
-				name) < 0)
-			err->str =3D NULL;
+				name) >=3D 0)
+			parse_events__append_error(err, -1, err_str, NULL);
 		return -EINVAL;
 	}
=20
@@ -2797,13 +2838,10 @@ void parse_events__clear_array(struct parse_events_=
array *a)
 void parse_events_evlist_error(struct parse_events_state *parse_state,
 			       int idx, const char *str)
 {
-	struct parse_events_error *err =3D parse_state->error;
-
-	if (!err)
+	if (!parse_state->error)
 		return;
-	err->idx =3D idx;
-	err->str =3D strdup(str);
-	WARN_ONCE(!err->str, "WARNING: failed to allocate error string");
+
+	parse_events__append_error(parse_state->error, idx, strdup(str), NULL);
 }
=20
 static void config_terms_list(char *buf, size_t buf_sz)
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.=
h
index 769e07cddaa2..a7d42faeab0c 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -124,6 +124,8 @@ struct parse_events_state {
 	struct list_head	  *terms;
 };
=20
+void parse_events__append_error(struct parse_events_error *err, int idx,
+				char *str, char *help);
 void parse_events__shrink_config_terms(void);
 int parse_events__is_hardcoded_term(struct parse_events_term *term);
 int parse_events_term__num(struct parse_events_term **term,
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index adbe97e941dd..4015ec11944a 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -1050,9 +1050,9 @@ static int pmu_config_term(struct list_head *formats,
 		if (err) {
 			char *pmu_term =3D pmu_formats_string(formats);
=20
-			err->idx  =3D term->err_term;
-			err->str  =3D strdup("unknown term");
-			err->help =3D parse_events_formats_error_string(pmu_term);
+			parse_events__append_error(err, term->err_term,
+				strdup("unknown term"),
+				parse_events_formats_error_string(pmu_term));
 			free(pmu_term);
 		}
 		return -EINVAL;
@@ -1080,8 +1080,9 @@ static int pmu_config_term(struct list_head *formats,
 		if (term->no_value &&
 		    bitmap_weight(format->bits, PERF_PMU_FORMAT_BITS) > 1) {
 			if (err) {
-				err->idx =3D term->err_val;
-				err->str =3D strdup("no value assigned for term");
+				parse_events__append_error(err, term->err_val,
+					   strdup("no value assigned for term"),
+					   NULL);
 			}
 			return -EINVAL;
 		}
@@ -1094,8 +1095,9 @@ static int pmu_config_term(struct list_head *formats,
 						term->config, term->val.str);
 			}
 			if (err) {
-				err->idx =3D term->err_val;
-				err->str =3D strdup("expected numeric value");
+				parse_events__append_error(err, term->err_val,
+					strdup("expected numeric value"),
+					NULL);
 			}
 			return -EINVAL;
 		}
@@ -1108,11 +1110,15 @@ static int pmu_config_term(struct list_head *format=
s,
 	max_val =3D pmu_format_max_value(format->bits);
 	if (val > max_val) {
 		if (err) {
-			err->idx =3D term->err_val;
-			if (asprintf(&err->str,
-				     "value too big for format, maximum is %llu",
-				     (unsigned long long)max_val) < 0)
-				err->str =3D strdup("value too big for format");
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
--=20
2.23.0.866.gb869b98d4c-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C072FE44FE
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437476AbfJYH6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:58:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437468AbfJYH6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571990310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U0ko/BVEzCYj93aODTSwA86Zu6VChd3QffxuWil40Js=;
        b=bDCx05gaUwzJ3B8BXoFOmrkZhZ58N5RA1vBkTlBXnp1geB/WaYtC6WCPDfu+0JhSLAInJc
        zXLlYMTvnMEhAEP/lxSLinE/k9ZBHBCvFXNhlPENMQz6bKegK5Erx9yzGoOu8U5O4f4894
        +LDx/PxxlrqFsXlI2pQmlEn+VKloI/c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-84-PuZYC8xtP8CRRMLZwwmWYA-1; Fri, 25 Oct 2019 03:58:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0A79D801E5C;
        Fri, 25 Oct 2019 07:58:25 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id C2E8A1001B20;
        Fri, 25 Oct 2019 07:58:20 +0000 (UTC)
Date:   Fri, 25 Oct 2019 09:58:20 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Ian Rogers <irogers@google.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
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
        bpf@vger.kernel.org, clang-built-linux@googlegroups.com,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 1/9] perf tools: add parse events append error
Message-ID: <20191025075820.GE31679@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-2-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191024190202.109403-2-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: PuZYC8xtP8CRRMLZwwmWYA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:01:54PM -0700, Ian Rogers wrote:
> Parse event error handling may overwrite one error string with another
> creating memory leaks and masking errors. Introduce a helper routine
> that appends error messages and avoids the memory leak.
>=20
> A reproduction of this problem can be seen with:
>   perf stat -e c/c/
> After this change this produces:
> event syntax error: 'c/c/'
>                        \___ unknown term (previous error: unknown term (p=
revious error: unknown term (previous error: unknown term (previous error: =
unknown term (previous error: unknown term (previous error: unknown term (p=
revious error: unknown term (previous error: unknown term (previous error: =
unknown term (previous error: unknown term (previous error: unknown term (p=
revious error: unknown term (previous error: unknown term (previous error: =
unknown term (previous error: unknown term (previous error: unknown term (p=
revious error: unknown term (previous error: unknown term (previous error: =
unknown term (previous error: unknown term (previous error: Cannot find PMU=
 `c'. Missing kernel support?)(help: valid terms: event,filter_rem,filter_o=
pc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_opc1,=
tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config,con=
fig1,config2,name,period,percore))(help: valid terms: event,filter_rem,filt=
er_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filter_o=
pc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,config=
,config1,config2,name,period,percore))(help: valid terms: event,filter_rem,=
filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,filt=
er_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_nm,co=
nfig,config1,config2,name,period,percore))(help: valid terms: event,filter_=
rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umask,=
filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter_n=
m,config,config1,config2,name,period,percore))(help: valid terms: event,fil=
ter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,um=
ask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filt=
er_nm,config,config1,config2,name,period,percore))(help: valid terms: event=
,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,in=
v,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,=
filter_nm,config,config1,config2,name,period,percore))(help: valid terms: e=
vent,pc,in_tx,edge,any,offcore_rsp,in_tx_cp,ldlat,inv,umask,frontend,cmask,=
config,config1,config2,name,period,percore))(help: valid terms: event,filte=
r_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,umas=
k,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,filter=
_nm,config,config1,config2,name,period,percore))(help: valid terms: event,f=
ilter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,=
umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fi=
lter_nm,config,config1,config2,name,period,percore))(help: valid terms: eve=
nt,config,config1,config2,name,period,percore))(help: valid terms: event,fi=
lter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,inv,u=
mask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state,fil=
ter_nm,config,config1,config2,name,period,percore))(help: valid terms: even=
t,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_nc,i=
nv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_state=
,filter_nm,config,config1,config2,name,period,percore))(help: valid terms: =
event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filter_=
nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filter_s=
tate,filter_nm,config,config1,config2,name,period,percore))(help: valid ter=
ms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,fil=
ter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filt=
er_state,filter_nm,config,config1,config2,name,period,percore))(help: valid=
 terms: event,config,config1,config2,name,period,percore))(help: valid term=
s: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,filt=
er_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,filte=
r_state,filter_nm,config,config1,config2,name,period,percore))(help: valid =
terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_loc,=
filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_nm,f=
ilter_state,filter_nm,config,config1,config2,name,period,percore))(help: va=
lid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,filter_=
loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_not_=
nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(help=
: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,fil=
ter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_=
not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore))(=
help: valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid=
,filter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,fil=
ter_not_nm,filter_state,filter_nm,config,config1,config2,name,period,percor=
e))


hum... I'd argue that the previous state was better:

[jolsa@krava perf]$ ./perf stat -e c/c/
event syntax error: 'c/c/'
                       \___ unknown term


jirka

>=20
> valid terms: event,filter_rem,filter_opc0,edge,filter_isoc,filter_tid,fil=
ter_loc,filter_nc,inv,umask,filter_opc1,tid_en,thresh,filter_all_op,filter_=
not_nm,filter_state,filter_nm,config,config1,config2,name,period,percore
> Run 'perf list' for a list of valid events
>=20
>  Usage: perf stat [<options>] [<command>]
>=20
>     -e, --event <event>   event selector. use 'perf list' to list availab=
le events
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.c | 100 +++++++++++++++++++++++----------
>  tools/perf/util/parse-events.h |   2 +
>  tools/perf/util/pmu.c          |  30 ++++++----
>  3 files changed, 89 insertions(+), 43 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index db882f630f7e..edb3ae76777d 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -182,6 +182,38 @@ static int tp_event_has_id(const char *dir_path, str=
uct dirent *evt_dir)
> =20
>  #define MAX_EVENT_LENGTH 512
> =20
> +void parse_events__append_error(struct parse_events_error *err, int idx,
> +=09=09=09=09char *str, char *help)
> +{
> +=09char *new_str =3D NULL;
> +
> +=09if (WARN(!str, "WARNING: failed to provide error string")) {
> +=09=09free(help);
> +=09=09return;
> +=09}
> +=09if (err->str) {
> +=09=09int ret;
> +
> +=09=09if (err->help) {
> +=09=09=09ret =3D asprintf(&new_str,
> +=09=09=09=09"%s (previous error: %s(help: %s))",
> +=09=09=09=09str, err->str, err->help);
> +=09=09} else {
> +=09=09=09ret =3D asprintf(&new_str,
> +=09=09=09=09"%s (previous error: %s)",
> +=09=09=09=09str, err->str);
> +=09=09}
> +=09=09if (ret < 0)
> +=09=09=09new_str =3D NULL;
> +=09=09else
> +=09=09=09zfree(&str);
> +=09}
> +=09err->idx =3D idx;
> +=09free(err->str);
> +=09err->str =3D new_str ?: str;
> +=09free(err->help);
> +=09err->help =3D help;
> +}
> =20
>  struct tracepoint_path *tracepoint_id_to_path(u64 config)
>  {
> @@ -932,11 +964,11 @@ static int check_type_val(struct parse_events_term =
*term,
>  =09=09return 0;
> =20
>  =09if (err) {
> -=09=09err->idx =3D term->err_val;
> -=09=09if (type =3D=3D PARSE_EVENTS__TERM_TYPE_NUM)
> -=09=09=09err->str =3D strdup("expected numeric value");
> -=09=09else
> -=09=09=09err->str =3D strdup("expected string value");
> +=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09type =3D=3D PARSE_EVENTS__TERM_TYPE_NUM
> +=09=09=09=09=09? strdup("expected numeric value")
> +=09=09=09=09=09: strdup("expected string value"),
> +=09=09=09=09=09NULL);
>  =09}
>  =09return -EINVAL;
>  }
> @@ -972,8 +1004,11 @@ static bool config_term_shrinked;
>  static bool
>  config_term_avail(int term_type, struct parse_events_error *err)
>  {
> +=09char *err_str;
> +
>  =09if (term_type < 0 || term_type >=3D __PARSE_EVENTS__TERM_TYPE_NR) {
> -=09=09err->str =3D strdup("Invalid term_type");
> +=09=09parse_events__append_error(err, -1,
> +=09=09=09=09=09strdup("Invalid term_type"), NULL);
>  =09=09return false;
>  =09}
>  =09if (!config_term_shrinked)
> @@ -992,9 +1027,9 @@ config_term_avail(int term_type, struct parse_events=
_error *err)
>  =09=09=09return false;
> =20
>  =09=09/* term_type is validated so indexing is safe */
> -=09=09if (asprintf(&err->str, "'%s' is not usable in 'perf stat'",
> -=09=09=09     config_term_names[term_type]) < 0)
> -=09=09=09err->str =3D NULL;
> +=09=09if (asprintf(&err_str, "'%s' is not usable in 'perf stat'",
> +=09=09=09=09config_term_names[term_type]) >=3D 0)
> +=09=09=09parse_events__append_error(err, -1, err_str, NULL);
>  =09=09return false;
>  =09}
>  }
> @@ -1036,17 +1071,20 @@ do {=09=09=09=09=09=09=09=09=09   \
>  =09case PARSE_EVENTS__TERM_TYPE_BRANCH_SAMPLE_TYPE:
>  =09=09CHECK_TYPE_VAL(STR);
>  =09=09if (strcmp(term->val.str, "no") &&
> -=09=09    parse_branch_str(term->val.str, &attr->branch_sample_type)) {
> -=09=09=09err->str =3D strdup("invalid branch sample type");
> -=09=09=09err->idx =3D term->err_val;
> +=09=09    parse_branch_str(term->val.str,
> +=09=09=09=09    &attr->branch_sample_type)) {
> +=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09strdup("invalid branch sample type"),
> +=09=09=09=09=09NULL);
>  =09=09=09return -EINVAL;
>  =09=09}
>  =09=09break;
>  =09case PARSE_EVENTS__TERM_TYPE_TIME:
>  =09=09CHECK_TYPE_VAL(NUM);
>  =09=09if (term->val.num > 1) {
> -=09=09=09err->str =3D strdup("expected 0 or 1");
> -=09=09=09err->idx =3D term->err_val;
> +=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09=09strdup("expected 0 or 1"),
> +=09=09=09=09=09=09NULL);
>  =09=09=09return -EINVAL;
>  =09=09}
>  =09=09break;
> @@ -1080,8 +1118,9 @@ do {=09=09=09=09=09=09=09=09=09   \
>  =09case PARSE_EVENTS__TERM_TYPE_PERCORE:
>  =09=09CHECK_TYPE_VAL(NUM);
>  =09=09if ((unsigned int)term->val.num > 1) {
> -=09=09=09err->str =3D strdup("expected 0 or 1");
> -=09=09=09err->idx =3D term->err_val;
> +=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09=09strdup("expected 0 or 1"),
> +=09=09=09=09=09=09NULL);
>  =09=09=09return -EINVAL;
>  =09=09}
>  =09=09break;
> @@ -1089,9 +1128,9 @@ do {=09=09=09=09=09=09=09=09=09   \
>  =09=09CHECK_TYPE_VAL(NUM);
>  =09=09break;
>  =09default:
> -=09=09err->str =3D strdup("unknown term");
> -=09=09err->idx =3D term->err_term;
> -=09=09err->help =3D parse_events_formats_error_string(NULL);
> +=09=09parse_events__append_error(err, term->err_term,
> +=09=09=09=09strdup("unknown term"),
> +=09=09=09=09parse_events_formats_error_string(NULL));
>  =09=09return -EINVAL;
>  =09}
> =20
> @@ -1142,9 +1181,9 @@ static int config_term_tracepoint(struct perf_event=
_attr *attr,
>  =09=09return config_term_common(attr, term, err);
>  =09default:
>  =09=09if (err) {
> -=09=09=09err->idx =3D term->err_term;
> -=09=09=09err->str =3D strdup("unknown term");
> -=09=09=09err->help =3D strdup("valid terms: call-graph,stack-size\n");
> +=09=09=09parse_events__append_error(err, term->err_term,
> +=09=09=09=09strdup("unknown term"),
> +=09=09=09=09strdup("valid terms: call-graph,stack-size\n"));
>  =09=09}
>  =09=09return -EINVAL;
>  =09}
> @@ -1323,10 +1362,12 @@ int parse_events_add_pmu(struct parse_events_stat=
e *parse_state,
> =20
>  =09pmu =3D perf_pmu__find(name);
>  =09if (!pmu) {
> -=09=09if (asprintf(&err->str,
> +=09=09char *err_str;
> +
> +=09=09if (asprintf(&err_str,
>  =09=09=09=09"Cannot find PMU `%s'. Missing kernel support?",
> -=09=09=09=09name) < 0)
> -=09=09=09err->str =3D NULL;
> +=09=09=09=09name) >=3D 0)
> +=09=09=09parse_events__append_error(err, -1, err_str, NULL);
>  =09=09return -EINVAL;
>  =09}
> =20
> @@ -2797,13 +2838,10 @@ void parse_events__clear_array(struct parse_event=
s_array *a)
>  void parse_events_evlist_error(struct parse_events_state *parse_state,
>  =09=09=09       int idx, const char *str)
>  {
> -=09struct parse_events_error *err =3D parse_state->error;
> -
> -=09if (!err)
> +=09if (!parse_state->error)
>  =09=09return;
> -=09err->idx =3D idx;
> -=09err->str =3D strdup(str);
> -=09WARN_ONCE(!err->str, "WARNING: failed to allocate error string");
> +
> +=09parse_events__append_error(parse_state->error, idx, strdup(str), NULL=
);
>  }
> =20
>  static void config_terms_list(char *buf, size_t buf_sz)
> diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-event=
s.h
> index 769e07cddaa2..a7d42faeab0c 100644
> --- a/tools/perf/util/parse-events.h
> +++ b/tools/perf/util/parse-events.h
> @@ -124,6 +124,8 @@ struct parse_events_state {
>  =09struct list_head=09  *terms;
>  };
> =20
> +void parse_events__append_error(struct parse_events_error *err, int idx,
> +=09=09=09=09char *str, char *help);
>  void parse_events__shrink_config_terms(void);
>  int parse_events__is_hardcoded_term(struct parse_events_term *term);
>  int parse_events_term__num(struct parse_events_term **term,
> diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
> index adbe97e941dd..4015ec11944a 100644
> --- a/tools/perf/util/pmu.c
> +++ b/tools/perf/util/pmu.c
> @@ -1050,9 +1050,9 @@ static int pmu_config_term(struct list_head *format=
s,
>  =09=09if (err) {
>  =09=09=09char *pmu_term =3D pmu_formats_string(formats);
> =20
> -=09=09=09err->idx  =3D term->err_term;
> -=09=09=09err->str  =3D strdup("unknown term");
> -=09=09=09err->help =3D parse_events_formats_error_string(pmu_term);
> +=09=09=09parse_events__append_error(err, term->err_term,
> +=09=09=09=09strdup("unknown term"),
> +=09=09=09=09parse_events_formats_error_string(pmu_term));
>  =09=09=09free(pmu_term);
>  =09=09}
>  =09=09return -EINVAL;
> @@ -1080,8 +1080,9 @@ static int pmu_config_term(struct list_head *format=
s,
>  =09=09if (term->no_value &&
>  =09=09    bitmap_weight(format->bits, PERF_PMU_FORMAT_BITS) > 1) {
>  =09=09=09if (err) {
> -=09=09=09=09err->idx =3D term->err_val;
> -=09=09=09=09err->str =3D strdup("no value assigned for term");
> +=09=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09   strdup("no value assigned for term"),
> +=09=09=09=09=09   NULL);
>  =09=09=09}
>  =09=09=09return -EINVAL;
>  =09=09}
> @@ -1094,8 +1095,9 @@ static int pmu_config_term(struct list_head *format=
s,
>  =09=09=09=09=09=09term->config, term->val.str);
>  =09=09=09}
>  =09=09=09if (err) {
> -=09=09=09=09err->idx =3D term->err_val;
> -=09=09=09=09err->str =3D strdup("expected numeric value");
> +=09=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09=09strdup("expected numeric value"),
> +=09=09=09=09=09NULL);
>  =09=09=09}
>  =09=09=09return -EINVAL;
>  =09=09}
> @@ -1108,11 +1110,15 @@ static int pmu_config_term(struct list_head *form=
ats,
>  =09max_val =3D pmu_format_max_value(format->bits);
>  =09if (val > max_val) {
>  =09=09if (err) {
> -=09=09=09err->idx =3D term->err_val;
> -=09=09=09if (asprintf(&err->str,
> -=09=09=09=09     "value too big for format, maximum is %llu",
> -=09=09=09=09     (unsigned long long)max_val) < 0)
> -=09=09=09=09err->str =3D strdup("value too big for format");
> +=09=09=09char *err_str;
> +
> +=09=09=09parse_events__append_error(err, term->err_val,
> +=09=09=09=09asprintf(&err_str,
> +=09=09=09=09    "value too big for format, maximum is %llu",
> +=09=09=09=09    (unsigned long long)max_val) < 0
> +=09=09=09=09    ? strdup("value too big for format")
> +=09=09=09=09    : err_str,
> +=09=09=09=09    NULL);
>  =09=09=09return -EINVAL;
>  =09=09}
>  =09=09/*
> --=20
> 2.23.0.866.gb869b98d4c-goog
>=20


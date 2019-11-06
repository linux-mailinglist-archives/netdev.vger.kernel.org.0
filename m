Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADF18F1886
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731972AbfKFOZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:25:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22998 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731952AbfKFOZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573050305;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=THCNNAU8gRrT/xl1j5Vg1FRnKMnJZ0K3FA07OJ+QdjY=;
        b=Jd/m9MvQ1NTehSRfX4735XmjScRNInHx2tdjCehNsTwNYTXMhRYHhW1jORSVpk1J+sI+x0
        C/NIM4lE/TpRoAwTFcy2F0ok1qi1RaWN/GOkFhZEdSgV+vQTh2BrMS8+r6OiwU6y1NQaxW
        TJR5qBaukxtMHKrmxNqEuC7U+e33QmY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-raBciwtxODqln0VbGDGgvw-1; Wed, 06 Nov 2019 09:25:01 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52D55800C72;
        Wed,  6 Nov 2019 14:24:59 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 60E6C5D713;
        Wed,  6 Nov 2019 14:24:55 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:24:54 +0100
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
Subject: Re: [PATCH v5 07/10] perf tools: before yyabort-ing free components
Message-ID: <20191106142454.GJ30214@krava>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-8-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191030223448.12930-8-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: raBciwtxODqln0VbGDGgvw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:34:45PM -0700, Ian Rogers wrote:
> Yyabort doesn't destruct inputs and so this must be done manually before
> using yyabort.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/perf/util/parse-events.y | 252 ++++++++++++++++++++++++++-------
>  1 file changed, 197 insertions(+), 55 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-event=
s.y
> index 035edfa8d42e..376b19855470 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -152,6 +152,7 @@ start_events: groups
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
> =20
> +=09/* frees $1 */
>  =09parse_events_update_lists($1, &parse_state->list);
>  }
> =20
> @@ -161,6 +162,7 @@ groups ',' group
>  =09struct list_head *list  =3D $1;
>  =09struct list_head *group =3D $3;
> =20
> +=09/* frees $3 */
>  =09parse_events_update_lists(group, list);
>  =09$$ =3D list;
>  }
> @@ -170,6 +172,7 @@ groups ',' event
>  =09struct list_head *list  =3D $1;
>  =09struct list_head *event =3D $3;
> =20
> +=09/* frees $3 */
>  =09parse_events_update_lists(event, list);
>  =09$$ =3D list;
>  }
> @@ -182,8 +185,14 @@ group:
>  group_def ':' PE_MODIFIER_EVENT
>  {
>  =09struct list_head *list =3D $1;
> +=09int err;
> =20
> -=09ABORT_ON(parse_events__modifier_group(list, $3));
> +=09err =3D parse_events__modifier_group(list, $3);
> +=09free($3);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -196,6 +205,7 @@ PE_NAME '{' events '}'
> =20
>  =09inc_group_count(list, _parse_state);
>  =09parse_events__set_leader($1, list, _parse_state);
> +=09free($1);
>  =09$$ =3D list;
>  }
>  |
> @@ -214,6 +224,7 @@ events ',' event
>  =09struct list_head *event =3D $3;
>  =09struct list_head *list  =3D $1;
> =20
> +=09/* frees $3 */
>  =09parse_events_update_lists(event, list);
>  =09$$ =3D list;
>  }
> @@ -226,13 +237,19 @@ event_mod:
>  event_name PE_MODIFIER_EVENT
>  {
>  =09struct list_head *list =3D $1;
> +=09int err;
> =20
>  =09/*
>  =09 * Apply modifier on all events added by single event definition
>  =09 * (there could be more events added for multiple tracepoint
>  =09 * definitions via '*?'.
>  =09 */
> -=09ABORT_ON(parse_events__modifier_event(list, $2, false));
> +=09err =3D parse_events__modifier_event(list, $2, false);
> +=09free($2);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -241,8 +258,14 @@ event_name
>  event_name:
>  PE_EVENT_NAME event_def
>  {
> -=09ABORT_ON(parse_events_name($2, $1));
> +=09int err;
> +
> +=09err =3D parse_events_name($2, $1);
>  =09free($1);
> +=09if (err) {
> +=09=09free_list_evsel($2);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D $2;
>  }
>  |
> @@ -262,23 +285,33 @@ PE_NAME opt_pmu_config
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct parse_events_error *error =3D parse_state->error;
> -=09struct list_head *list, *orig_terms, *terms;
> +=09struct list_head *list =3D NULL, *orig_terms =3D NULL, *terms=3D NULL=
;
> +=09char *pattern =3D NULL;
> +
> +#define CLEANUP_YYABORT=09=09=09=09=09\
> +=09do {=09=09=09=09=09=09\
> +=09=09parse_events_terms__delete($2);=09=09\
> +=09=09parse_events_terms__delete(orig_terms);=09\
> +=09=09free($1);=09=09=09=09\
> +=09=09free(pattern);=09=09=09=09\
> +=09=09YYABORT;=09=09=09=09\
> +=09} while(0)
> =20
>  =09if (parse_events_copy_term_list($2, &orig_terms))
> -=09=09YYABORT;
> +=09=09CLEANUP_YYABORT;
> =20
>  =09if (error)
>  =09=09error->idx =3D @1.first_column;
> =20
>  =09list =3D alloc_list();
> -=09ABORT_ON(!list);
> +=09if (!list)
> +=09=09CLEANUP_YYABORT;
>  =09if (parse_events_add_pmu(_parse_state, list, $1, $2, false, false)) {
>  =09=09struct perf_pmu *pmu =3D NULL;
>  =09=09int ok =3D 0;
> -=09=09char *pattern;
> =20
>  =09=09if (asprintf(&pattern, "%s*", $1) < 0)
> -=09=09=09YYABORT;
> +=09=09=09CLEANUP_YYABORT;
> =20
>  =09=09while ((pmu =3D perf_pmu__scan(pmu)) !=3D NULL) {
>  =09=09=09char *name =3D pmu->name;
> @@ -287,31 +320,32 @@ PE_NAME opt_pmu_config
>  =09=09=09    strncmp($1, "uncore_", 7))
>  =09=09=09=09name +=3D 7;
>  =09=09=09if (!fnmatch(pattern, name, 0)) {
> -=09=09=09=09if (parse_events_copy_term_list(orig_terms, &terms)) {
> -=09=09=09=09=09free(pattern);
> -=09=09=09=09=09YYABORT;
> -=09=09=09=09}
> +=09=09=09=09if (parse_events_copy_term_list(orig_terms, &terms))
> +=09=09=09=09=09CLEANUP_YYABORT;
>  =09=09=09=09if (!parse_events_add_pmu(_parse_state, list, pmu->name, ter=
ms, true, false))
>  =09=09=09=09=09ok++;
>  =09=09=09=09parse_events_terms__delete(terms);
>  =09=09=09}
>  =09=09}
> =20
> -=09=09free(pattern);
> -
>  =09=09if (!ok)
> -=09=09=09YYABORT;
> +=09=09=09CLEANUP_YYABORT;
>  =09}
>  =09parse_events_terms__delete($2);
>  =09parse_events_terms__delete(orig_terms);
> +=09free($1);
>  =09$$ =3D list;
> +#undef CLEANUP_YYABORT
>  }
>  |
>  PE_KERNEL_PMU_EVENT sep_dc
>  {
>  =09struct list_head *list;
> +=09int err;
> =20
> -=09if (parse_events_multi_pmu_add(_parse_state, $1, &list) < 0)
> +=09err =3D parse_events_multi_pmu_add(_parse_state, $1, &list);
> +=09free($1);
> +=09if (err < 0)
>  =09=09YYABORT;
>  =09$$ =3D list;
>  }
> @@ -322,6 +356,8 @@ PE_PMU_EVENT_PRE '-' PE_PMU_EVENT_SUF sep_dc
>  =09char pmu_name[128];
> =20
>  =09snprintf(&pmu_name, 128, "%s-%s", $1, $3);
> +=09free($1);
> +=09free($3);
>  =09if (parse_events_multi_pmu_add(_parse_state, pmu_name, &list) < 0)
>  =09=09YYABORT;
>  =09$$ =3D list;
> @@ -338,11 +374,16 @@ value_sym '/' event_config '/'
>  =09struct list_head *list;
>  =09int type =3D $1 >> 16;
>  =09int config =3D $1 & 255;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, $=
3));
> +=09err =3D parse_events_add_numeric(_parse_state, list, type, config, $3=
);
>  =09parse_events_terms__delete($3);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -374,11 +415,19 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' =
PE_NAME_CACHE_OP_RESULT opt_e
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, =
error, $6));
> +=09err =3D parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, e=
rror, $6);
>  =09parse_events_terms__delete($6);
> +=09free($1);
> +=09free($3);
> +=09free($5);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -387,11 +436,18 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT opt_=
event_config
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL=
, error, $4));
> +=09err =3D parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL,=
 error, $4);
>  =09parse_events_terms__delete($4);
> +=09free($1);
> +=09free($3);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -400,11 +456,17 @@ PE_NAME_CACHE_TYPE opt_event_config
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, NULL, NU=
LL, error, $2));
> +=09err =3D parse_events_add_cache(list, &parse_state->idx, $1, NULL, NUL=
L, error, $2);
>  =09parse_events_terms__delete($2);
> +=09free($1);
> +=09if (err) {
> +=09=09free_list_evsel(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
> =20
> @@ -413,11 +475,17 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER=
_BP sep_dc
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
> -=09=09=09=09=09     (void *) $2, $6, $4));
> +=09err =3D parse_events_add_breakpoint(list, &parse_state->idx,
> +=09=09=09=09=09(void *) $2, $6, $4);
> +=09free($6);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -428,8 +496,11 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
> -=09=09=09=09=09     (void *) $2, NULL, $4));
> +=09if (parse_events_add_breakpoint(list, &parse_state->idx,
> +=09=09=09=09=09=09(void *) $2, NULL, $4)) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -437,11 +508,17 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
> -=09=09=09=09=09     (void *) $2, $4, 0));
> +=09err =3D parse_events_add_breakpoint(list, &parse_state->idx,
> +=09=09=09=09=09(void *) $2, $4, 0);
> +=09free($4);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
> @@ -452,8 +529,11 @@ PE_PREFIX_MEM PE_VALUE sep_dc
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
> -=09=09=09=09=09     (void *) $2, NULL, 0));
> +=09if (parse_events_add_breakpoint(list, &parse_state->idx,
> +=09=09=09=09=09=09(void *) $2, NULL, 0)) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
> =20
> @@ -463,29 +543,35 @@ tracepoint_name opt_event_config
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
>  =09if (error)
>  =09=09error->idx =3D @1.first_column;
> =20
> -=09if (parse_events_add_tracepoint(list, &parse_state->idx, $1.sys, $1.e=
vent,
> -=09=09=09=09=09error, $2))
> -=09=09return -1;
> +=09err =3D parse_events_add_tracepoint(list, &parse_state->idx, $1.sys, =
$1.event,
> +=09=09=09=09=09error, $2);
> =20
> +=09parse_events_terms__delete($2);
> +=09free($1.sys);
> +=09free($1.event);
> +=09if (err) {
> +=09=09free(list);
> +=09=09return -1;
> +=09}
>  =09$$ =3D list;
>  }
> =20
>  tracepoint_name:
>  PE_NAME '-' PE_NAME ':' PE_NAME
>  {
> -=09char sys_name[128];
>  =09struct tracepoint_name tracepoint;
> =20
> -=09snprintf(&sys_name, 128, "%s-%s", $1, $3);
> -=09tracepoint.sys =3D &sys_name;
> +=09ABORT_ON(asprintf(&tracepoint.sys, "%s-%s", $1, $3) < 0);
>  =09tracepoint.event =3D $5;
> -
> +=09free($1);
> +=09free($3);
>  =09$$ =3D tracepoint;
>  }
>  |
> @@ -500,11 +586,16 @@ event_legacy_numeric:
>  PE_VALUE ':' PE_VALUE opt_event_config
>  {
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4=
));
> +=09err =3D parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4)=
;
>  =09parse_events_terms__delete($4);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
> =20
> @@ -512,11 +603,16 @@ event_legacy_raw:
>  PE_RAW opt_event_config
>  {
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, =
$1, $2));
> +=09err =3D parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, $=
1, $2);
>  =09parse_events_terms__delete($2);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
> =20
> @@ -525,22 +621,33 @@ PE_BPF_OBJECT opt_event_config
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_load_bpf(parse_state, list, $1, false, $2));
> +=09err =3D parse_events_load_bpf(parse_state, list, $1, false, $2);
>  =09parse_events_terms__delete($2);
> +=09free($1);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
>  |
>  PE_BPF_SOURCE opt_event_config
>  {
>  =09struct list_head *list;
> +=09int err;
> =20
>  =09list =3D alloc_list();
>  =09ABORT_ON(!list);
> -=09ABORT_ON(parse_events_load_bpf(_parse_state, list, $1, true, $2));
> +=09err =3D parse_events_load_bpf(_parse_state, list, $1, true, $2);
>  =09parse_events_terms__delete($2);
> +=09if (err) {
> +=09=09free(list);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D list;
>  }
> =20
> @@ -573,6 +680,10 @@ opt_pmu_config:
>  start_terms: event_config
>  {
>  =09struct parse_events_state *parse_state =3D _parse_state;
> +=09if (parse_state->terms) {
> +=09=09parse_events_terms__delete ($1);
> +=09=09YYABORT;
> +=09}
>  =09parse_state->terms =3D $1;
>  }
> =20
> @@ -582,7 +693,10 @@ event_config ',' event_term
>  =09struct list_head *head =3D $1;
>  =09struct parse_events_term *term =3D $3;
> =20
> -=09ABORT_ON(!head);
> +=09if (!head) {
> +=09=09free_term(term);
> +=09=09YYABORT;
> +=09}
>  =09list_add_tail(&term->list, head);
>  =09$$ =3D $1;
>  }
> @@ -603,8 +717,12 @@ PE_NAME '=3D' PE_NAME
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09=09=09=09$1, $3, &@1, &@3));
> +=09if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09$1, $3, &@1, &@3)) {
> +=09=09free($1);
> +=09=09free($3);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
>  |
> @@ -612,8 +730,11 @@ PE_NAME '=3D' PE_VALUE
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09=09=09=09$1, $3, false, &@1, &@3));
> +=09if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09$1, $3, false, &@1, &@3)) {
> +=09=09free($1);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
>  |
> @@ -622,7 +743,10 @@ PE_NAME '=3D' PE_VALUE_SYM_HW
>  =09struct parse_events_term *term;
>  =09int config =3D $3 & 255;
> =20
> -=09ABORT_ON(parse_events_term__sym_hw(&term, $1, config));
> +=09if (parse_events_term__sym_hw(&term, $1, config)) {
> +=09=09free($1);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
>  |
> @@ -630,8 +754,11 @@ PE_NAME
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09=09=09=09$1, 1, true, &@1, NULL));
> +=09if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09$1, 1, true, &@1, NULL)) {
> +=09=09free($1);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
>  |
> @@ -648,7 +775,10 @@ PE_TERM '=3D' PE_NAME
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__str(&term, (int)$1, NULL, $3, &@1, &@3));
> +=09if (parse_events_term__str(&term, (int)$1, NULL, $3, &@1, &@3)) {
> +=09=09free($3);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
>  |
> @@ -672,9 +802,13 @@ PE_NAME array '=3D' PE_NAME
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09=09=09=09$1, $4, &@1, &@4));
> -
> +=09if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09$1, $4, &@1, &@4)) {
> +=09=09free($1);
> +=09=09free($4);
> +=09=09free($2.ranges);
> +=09=09YYABORT;
> +=09}
>  =09term->array =3D $2;
>  =09$$ =3D term;
>  }
> @@ -683,8 +817,12 @@ PE_NAME array '=3D' PE_VALUE
>  {
>  =09struct parse_events_term *term;
> =20
> -=09ABORT_ON(parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09=09=09=09$1, $4, false, &@1, &@4));
> +=09if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09$1, $4, false, &@1, &@4)) {
> +=09=09free($1);
> +=09=09free($2.ranges);
> +=09=09YYABORT;
> +=09}
>  =09term->array =3D $2;
>  =09$$ =3D term;
>  }
> @@ -695,8 +833,12 @@ PE_DRV_CFG_TERM
>  =09char *config =3D strdup($1);
> =20
>  =09ABORT_ON(!config);
> -=09ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CF=
G,
> -=09=09=09=09=09config, $1, &@1, NULL));
> +=09if (parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CFG,
> +=09=09=09=09=09config, $1, &@1, NULL)) {
> +=09=09free($1);
> +=09=09free(config);
> +=09=09YYABORT;
> +=09}
>  =09$$ =3D term;
>  }
> =20
> --=20
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20


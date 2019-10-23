Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC523E14D0
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390527AbfJWI4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:56:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59494 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390034AbfJWI4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:56:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571820970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EvCbYNTh8y91QToWpilpaNg9PeqSBs8+413OMwilG5k=;
        b=NfnvSqXNAVAneC5ZHSlLKLq5eQRY4BLDqiYbIsSP00kTGvXMZEGv4MCzdyK+QeSxDJ6Jle
        sUtss1xWqmaYSmupceYsSAZD0aNvOEEjCpwbZk3fDqDs5JGa8/0r5EIDhMK3Sydtn/7vD5
        Riv5TkuH6Qk8SFiCQ4OWBMPxDvupMkk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-ql5HWQknOC-Kj9qZDxUaIA-1; Wed, 23 Oct 2019 04:56:06 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 462DC1800DBE;
        Wed, 23 Oct 2019 08:56:04 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 495EE60BE1;
        Wed, 23 Oct 2019 08:56:00 +0000 (UTC)
Date:   Wed, 23 Oct 2019 10:55:59 +0200
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
Subject: Re: [PATCH v2 4/9] perf tools: move ALLOC_LIST into a function
Message-ID: <20191023085559.GF22919@krava>
References: <20191017170531.171244-1-irogers@google.com>
 <20191023005337.196160-1-irogers@google.com>
 <20191023005337.196160-5-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191023005337.196160-5-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: ql5HWQknOC-Kj9qZDxUaIA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:53:32PM -0700, Ian Rogers wrote:
> Having a YYABORT in a macro makes it hard to free memory for components
> of a rule. Separate the logic out.

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.y | 65 ++++++++++++++++++++++------------
>  1 file changed, 43 insertions(+), 22 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-event=
s.y
> index 27d6b187c9b1..26cb65798522 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -25,12 +25,17 @@ do { \
>  =09=09YYABORT; \
>  } while (0)
> =20
> -#define ALLOC_LIST(list) \
> -do { \
> -=09list =3D malloc(sizeof(*list)); \
> -=09ABORT_ON(!list);              \
> -=09INIT_LIST_HEAD(list);         \
> -} while (0)
> +static struct list_head* alloc_list()
> +{
> +=09struct list_head *list;
> +
> +=09list =3D malloc(sizeof(*list));
> +=09if (!list)
> +=09=09return NULL;
> +
> +=09INIT_LIST_HEAD(list);
> +=09return list;
> +}
> =20
>  static void inc_group_count(struct list_head *list,
>  =09=09       struct parse_events_state *parse_state)
> @@ -238,7 +243,8 @@ PE_NAME opt_pmu_config
>  =09if (error)
>  =09=09error->idx =3D @1.first_column;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09if (parse_events_add_pmu(_parse_state, list, $1, $2, false, false)) {
>  =09=09struct perf_pmu *pmu =3D NULL;
>  =09=09int ok =3D 0;
> @@ -306,7 +312,8 @@ value_sym '/' event_config '/'
>  =09int type =3D $1 >> 16;
>  =09int config =3D $1 & 255;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, $=
3));
>  =09parse_events_terms__delete($3);
>  =09$$ =3D list;
> @@ -318,7 +325,8 @@ value_sym sep_slash_slash_dc
>  =09int type =3D $1 >> 16;
>  =09int config =3D $1 & 255;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_numeric(_parse_state, list, type, config, N=
ULL));
>  =09$$ =3D list;
>  }
> @@ -327,7 +335,8 @@ PE_VALUE_SYM_TOOL sep_slash_slash_dc
>  {
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_tool(_parse_state, list, $1));
>  =09$$ =3D list;
>  }
> @@ -339,7 +348,8 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT '-' PE=
_NAME_CACHE_OP_RESULT opt_e
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, $5, =
error, $6));
>  =09parse_events_terms__delete($6);
>  =09$$ =3D list;
> @@ -351,7 +361,8 @@ PE_NAME_CACHE_TYPE '-' PE_NAME_CACHE_OP_RESULT opt_ev=
ent_config
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, $3, NULL=
, error, $4));
>  =09parse_events_terms__delete($4);
>  =09$$ =3D list;
> @@ -363,7 +374,8 @@ PE_NAME_CACHE_TYPE opt_event_config
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_cache(list, &parse_state->idx, $1, NULL, NU=
LL, error, $2));
>  =09parse_events_terms__delete($2);
>  =09$$ =3D list;
> @@ -375,7 +387,8 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_B=
P sep_dc
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
>  =09=09=09=09=09     (void *) $2, $6, $4));
>  =09$$ =3D list;
> @@ -386,7 +399,8 @@ PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
>  =09=09=09=09=09     (void *) $2, NULL, $4));
>  =09$$ =3D list;
> @@ -397,7 +411,8 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
>  =09=09=09=09=09     (void *) $2, $4, 0));
>  =09$$ =3D list;
> @@ -408,7 +423,8 @@ PE_PREFIX_MEM PE_VALUE sep_dc
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_breakpoint(list, &parse_state->idx,
>  =09=09=09=09=09     (void *) $2, NULL, 0));
>  =09$$ =3D list;
> @@ -421,7 +437,8 @@ tracepoint_name opt_event_config
>  =09struct parse_events_error *error =3D parse_state->error;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09if (error)
>  =09=09error->idx =3D @1.first_column;
> =20
> @@ -457,7 +474,8 @@ PE_VALUE ':' PE_VALUE opt_event_config
>  {
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_numeric(_parse_state, list, (u32)$1, $3, $4=
));
>  =09parse_events_terms__delete($4);
>  =09$$ =3D list;
> @@ -468,7 +486,8 @@ PE_RAW opt_event_config
>  {
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_add_numeric(_parse_state, list, PERF_TYPE_RAW, =
$1, $2));
>  =09parse_events_terms__delete($2);
>  =09$$ =3D list;
> @@ -480,7 +499,8 @@ PE_BPF_OBJECT opt_event_config
>  =09struct parse_events_state *parse_state =3D _parse_state;
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_load_bpf(parse_state, list, $1, false, $2));
>  =09parse_events_terms__delete($2);
>  =09$$ =3D list;
> @@ -490,7 +510,8 @@ PE_BPF_SOURCE opt_event_config
>  {
>  =09struct list_head *list;
> =20
> -=09ALLOC_LIST(list);
> +=09list =3D alloc_list();
> +=09ABORT_ON(!list);
>  =09ABORT_ON(parse_events_load_bpf(_parse_state, list, $1, true, $2));
>  =09parse_events_terms__delete($2);
>  =09$$ =3D list;
> --=20
> 2.23.0.866.gb869b98d4c-goog
>=20


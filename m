Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0796BE4544
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437827AbfJYIK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:10:59 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:37321 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2437821AbfJYIK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:10:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571991056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2GGf2kVG8CsLtd6hgKY+4sDM4eKzor9fLrdBz5qU+cg=;
        b=JGylnpl8YAlteK0FbtRDiGWp9goyfrVY6zMlnq0xumhVByStYPFkrdgRGTlE+g/CC8SmVU
        hciHoyCXUvX0UEU9M6h1BYBePoccBoatahJA0Ee07fCzcsUx4RPt9vm7gZZq0IXhQxFujr
        MpLerq+p21GKne/Uh3z4PC1akchI31Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-SakRCyxTNi2Z0gepaWe5QA-1; Fri, 25 Oct 2019 04:10:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 104BD1005500;
        Fri, 25 Oct 2019 08:10:51 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0F03B5D712;
        Fri, 25 Oct 2019 08:10:46 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:10:46 +0200
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
Subject: Re: [PATCH v3 3/9] perf tools: ensure config and str in terms are
 unique
Message-ID: <20191025081046.GG31679@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-4-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191024190202.109403-4-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: SakRCyxTNi2Z0gepaWe5QA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:01:56PM -0700, Ian Rogers wrote:
> Make it easier to release memory associated with parse event terms by
> duplicating the string for the config name and ensuring the val string
> is a duplicate.
>=20
> Currently the parser may memory leak terms and this is addressed in a
> later patch.

please move that patch before this one=20

thanks,
jirka

>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.c | 51 ++++++++++++++++++++++++++++------
>  tools/perf/util/parse-events.y |  4 ++-
>  2 files changed, 45 insertions(+), 10 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index f0d50f079d2f..dc5862a663b5 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1430,7 +1430,6 @@ int parse_events_add_pmu(struct parse_events_state =
*parse_state,
>  int parse_events_multi_pmu_add(struct parse_events_state *parse_state,
>  =09=09=09       char *str, struct list_head **listp)
>  {
> -=09struct list_head *head;
>  =09struct parse_events_term *term;
>  =09struct list_head *list;
>  =09struct perf_pmu *pmu =3D NULL;
> @@ -1447,19 +1446,30 @@ int parse_events_multi_pmu_add(struct parse_event=
s_state *parse_state,
> =20
>  =09=09list_for_each_entry(alias, &pmu->aliases, list) {
>  =09=09=09if (!strcasecmp(alias->name, str)) {
> +=09=09=09=09struct list_head *head;
> +=09=09=09=09char *config;
> +
>  =09=09=09=09head =3D malloc(sizeof(struct list_head));
>  =09=09=09=09if (!head)
>  =09=09=09=09=09return -1;
>  =09=09=09=09INIT_LIST_HEAD(head);
> -=09=09=09=09if (parse_events_term__num(&term, PARSE_EVENTS__TERM_TYPE_US=
ER,
> -=09=09=09=09=09=09=09   str, 1, false, &str, NULL) < 0)
> +=09=09=09=09config =3D strdup(str);
> +=09=09=09=09if (!config)
> +=09=09=09=09=09return -1;
> +=09=09=09=09if (parse_events_term__num(&term,
> +=09=09=09=09=09=09   PARSE_EVENTS__TERM_TYPE_USER,
> +=09=09=09=09=09=09   config, 1, false, &config,
> +=09=09=09=09=09=09   NULL) < 0) {
> +=09=09=09=09=09free(list);
> +=09=09=09=09=09free(config);
>  =09=09=09=09=09return -1;
> +=09=09=09=09}
>  =09=09=09=09list_add_tail(&term->list, head);
> =20
>  =09=09=09=09if (!parse_events_add_pmu(parse_state, list,
>  =09=09=09=09=09=09=09  pmu->name, head,
>  =09=09=09=09=09=09=09  true, true)) {
> -=09=09=09=09=09pr_debug("%s -> %s/%s/\n", str,
> +=09=09=09=09=09pr_debug("%s -> %s/%s/\n", config,
>  =09=09=09=09=09=09 pmu->name, alias->str);
>  =09=09=09=09=09ok++;
>  =09=09=09=09}
> @@ -1468,8 +1478,10 @@ int parse_events_multi_pmu_add(struct parse_events=
_state *parse_state,
>  =09=09=09}
>  =09=09}
>  =09}
> -=09if (!ok)
> +=09if (!ok) {
> +=09=09free(list);
>  =09=09return -1;
> +=09}
>  =09*listp =3D list;
>  =09return 0;
>  }
> @@ -2764,30 +2776,51 @@ int parse_events_term__sym_hw(struct parse_events=
_term **term,
>  =09=09=09      char *config, unsigned idx)
>  {
>  =09struct event_symbol *sym;
> +=09char *str;
>  =09struct parse_events_term temp =3D {
>  =09=09.type_val  =3D PARSE_EVENTS__TERM_TYPE_STR,
>  =09=09.type_term =3D PARSE_EVENTS__TERM_TYPE_USER,
> -=09=09.config    =3D config ?: (char *) "event",
> +=09=09.config    =3D config,
>  =09};
> =20
> +=09if (!temp.config) {
> +=09=09temp.config =3D strdup("event");
> +=09=09if (!temp.config)
> +=09=09=09return -ENOMEM;
> +=09}
>  =09BUG_ON(idx >=3D PERF_COUNT_HW_MAX);
>  =09sym =3D &event_symbols_hw[idx];
> =20
> -=09return new_term(term, &temp, (char *) sym->symbol, 0);
> +=09str =3D strdup(sym->symbol);
> +=09if (!str)
> +=09=09return -ENOMEM;
> +=09return new_term(term, &temp, str, 0);
>  }
> =20
>  int parse_events_term__clone(struct parse_events_term **new,
>  =09=09=09     struct parse_events_term *term)
>  {
> +=09char *str;
>  =09struct parse_events_term temp =3D {
>  =09=09.type_val  =3D term->type_val,
>  =09=09.type_term =3D term->type_term,
> -=09=09.config    =3D term->config,
> +=09=09.config    =3D NULL,
>  =09=09.err_term  =3D term->err_term,
>  =09=09.err_val   =3D term->err_val,
>  =09};
> =20
> -=09return new_term(new, &temp, term->val.str, term->val.num);
> +=09if (term->config) {
> +=09=09temp.config =3D strdup(term->config);
> +=09=09if (!temp.config)
> +=09=09=09return -ENOMEM;
> +=09}
> +=09if (term->type_val =3D=3D PARSE_EVENTS__TERM_TYPE_NUM)
> +=09=09return new_term(new, &temp, NULL, term->val.num);
> +
> +=09str =3D strdup(term->val.str);
> +=09if (!str)
> +=09=09return -ENOMEM;
> +=09return new_term(new, &temp, str, 0);
>  }
> =20
>  int parse_events_copy_term_list(struct list_head *old,
> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-event=
s.y
> index 48126ae4cd13..27d6b187c9b1 100644
> --- a/tools/perf/util/parse-events.y
> +++ b/tools/perf/util/parse-events.y
> @@ -644,9 +644,11 @@ PE_NAME array '=3D' PE_VALUE
>  PE_DRV_CFG_TERM
>  {
>  =09struct parse_events_term *term;
> +=09char *config =3D strdup($1);
> =20
> +=09ABORT_ON(!config);
>  =09ABORT_ON(parse_events_term__str(&term, PARSE_EVENTS__TERM_TYPE_DRV_CF=
G,
> -=09=09=09=09=09$1, $1, &@1, NULL));
> +=09=09=09=09=09config, $1, &@1, NULL));
>  =09$$ =3D term;
>  }
> =20
> --=20
> 2.23.0.866.gb869b98d4c-goog
>=20


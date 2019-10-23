Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D60E147F
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390412AbfJWIkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:40:52 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52524 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390298AbfJWIkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:40:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571820050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Leo1i+YgTzOAxyY1K0L+NX63hVj5HiYTBpizOFvje2U=;
        b=C8i4c9owWLo9ELGFMx0EgsC5LvJTAmpyeUaS34sSBa41veIUd7TE1CiY+lujUsQazKtoMr
        /5vCjW72xS8UELAKiJvXqzvq+qohN8bEf7rvy5MoJWW2pXttCSH6oy+5Lhb9cpBSL5vOXO
        UjfheVFNaVEZDVgMG+iEv2byU4pE2Ys=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-apkC9BGkO-e0K5zNBfDeLA-1; Wed, 23 Oct 2019 04:40:46 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44F761800D6B;
        Wed, 23 Oct 2019 08:40:44 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1FEE360BE1;
        Wed, 23 Oct 2019 08:40:39 +0000 (UTC)
Date:   Wed, 23 Oct 2019 10:40:39 +0200
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
Subject: Re: [PATCH v2 2/9] perf tools: splice events onto evlist even on
 error
Message-ID: <20191023084039.GD22919@krava>
References: <20191017170531.171244-1-irogers@google.com>
 <20191023005337.196160-1-irogers@google.com>
 <20191023005337.196160-3-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191023005337.196160-3-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: apkC9BGkO-e0K5zNBfDeLA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 05:53:30PM -0700, Ian Rogers wrote:
> If event parsing fails the event list is leaked, instead splice the list
> onto the out result and let the caller cleanup.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index 4d42344698b8..a8f8801bd127 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1962,15 +1962,20 @@ int parse_events(struct evlist *evlist, const cha=
r *str,
> =20
>  =09ret =3D parse_events__scanner(str, &parse_state, PE_START_EVENTS);
>  =09perf_pmu__parse_cleanup();
> +

I dont understand.. is there something on the list in case we fail?

> +=09if (list_empty(&parse_state.list)) {
> +=09=09WARN_ONCE(true, "WARNING: event parser found nothing\n");
> +=09=09return -1;
> +=09}

this will display extra warning message for fail case:

[jolsa@krava perf]$ ./perf record -e krava ls
WARNING: event parser found nothing
event syntax error: 'krava'
                     \___ parser error

we don't want that

jirka

> +
> +=09/*
> +=09 * Add list to the evlist even with errors to allow callers to clean =
up.
> +=09 */
> +=09perf_evlist__splice_list_tail(evlist, &parse_state.list);
> +
>  =09if (!ret) {
>  =09=09struct evsel *last;
> =20
> -=09=09if (list_empty(&parse_state.list)) {
> -=09=09=09WARN_ONCE(true, "WARNING: event parser found nothing\n");
> -=09=09=09return -1;
> -=09=09}
> -
> -=09=09perf_evlist__splice_list_tail(evlist, &parse_state.list);
>  =09=09evlist->nr_groups +=3D parse_state.nr_groups;
>  =09=09last =3D evlist__last(evlist);
>  =09=09last->cmdline_group_boundary =3D true;
> --=20
> 2.23.0.866.gb869b98d4c-goog
>=20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982AFF1866
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 15:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731665AbfKFOYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 09:24:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727958AbfKFOYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 09:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573050260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Flm1vJLqrcBnxQjlITmfF1YMq+3fPfsxFYeiifRPFwo=;
        b=PHprarRWKUnc/W3o9iGx3c4VyKYFuY7bdn/VZBDyNHiv2+p9Xi9H0v6+aDUBmYzPm+rjRB
        w/OJhBbFlAvYagLF9BLHUe9ZaYWD+OKpzvHaa8wlZrmOx4lAmK9WRMh/O1GzFnL6wMyXMg
        9eLye1QqjwFr817aVcK7T08hFQjD5wk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-366-2UVS68OJOFikukoLMDiSDA-1; Wed, 06 Nov 2019 09:24:17 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8202A800C72;
        Wed,  6 Nov 2019 14:24:14 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9C7B060BF4;
        Wed,  6 Nov 2019 14:24:09 +0000 (UTC)
Date:   Wed, 6 Nov 2019 15:24:08 +0100
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
Subject: Re: [PATCH v5 08/10] perf tools: if pmu configuration fails free
 terms
Message-ID: <20191106142408.GF30214@krava>
References: <20191025180827.191916-1-irogers@google.com>
 <20191030223448.12930-1-irogers@google.com>
 <20191030223448.12930-9-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191030223448.12930-9-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: 2UVS68OJOFikukoLMDiSDA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 03:34:46PM -0700, Ian Rogers wrote:
> Avoid a memory leak when the configuration fails.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/perf/util/parse-events.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index 578288c94d2a..a0a80f4e7038 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1388,8 +1388,15 @@ int parse_events_add_pmu(struct parse_events_state=
 *parse_state,
>  =09if (get_config_terms(head_config, &config_terms))
>  =09=09return -ENOMEM;
> =20
> -=09if (perf_pmu__config(pmu, &attr, head_config, parse_state->error))
> +=09if (perf_pmu__config(pmu, &attr, head_config, parse_state->error)) {
> +=09=09struct perf_evsel_config_term *pos, *tmp;
> +
> +=09=09list_for_each_entry_safe(pos, tmp, &config_terms, list) {
> +=09=09=09list_del_init(&pos->list);
> +=09=09=09free(pos);
> +=09=09}
>  =09=09return -EINVAL;
> +=09}
> =20
>  =09evsel =3D __add_event(list, &parse_state->idx, &attr,
>  =09=09=09    get_config_name(head_config), pmu,
> --=20
> 2.24.0.rc1.363.gb1bccd3e3d-goog
>=20


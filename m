Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A648CE4516
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 10:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437589AbfJYIBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 04:01:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37775 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2437583AbfJYIBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 04:01:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571990513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=otCDV1QKx3d7IK+sWoEGFb/N0+D+qi80epo1tUZLYdM=;
        b=AtqC8MCWMDWZTD854HIWbUeizBluIKajJr6IDeSl/XUgGggungQbTnwwBlO8qrn6Z+fWPd
        WYyfz4al1ixvxUOc2l2WfEF2gEVtVAAbS1ha5aOIJ8GlOTSP5da8w1CSatndfIGcFjg3BT
        bcCfojpcxswdE7uUo2tH+1WUWjiHrwI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-ETcj03UuP5WCRQnyylt_tg-1; Fri, 25 Oct 2019 04:01:50 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2DE76107AD31;
        Fri, 25 Oct 2019 08:01:47 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1BCBF60852;
        Fri, 25 Oct 2019 08:01:42 +0000 (UTC)
Date:   Fri, 25 Oct 2019 10:01:42 +0200
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
Subject: Re: [PATCH v3 2/9] perf tools: splice events onto evlist even on
 error
Message-ID: <20191025080142.GF31679@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-3-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191024190202.109403-3-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: ETcj03UuP5WCRQnyylt_tg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 12:01:55PM -0700, Ian Rogers wrote:
> If event parsing fails the event list is leaked, instead splice the list
> onto the out result and let the caller cleanup.
>=20
> An example input for parse_events found by libFuzzer that reproduces
> this memory leak is 'm{'.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>
> ---
>  tools/perf/util/parse-events.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index edb3ae76777d..f0d50f079d2f 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1968,15 +1968,20 @@ int parse_events(struct evlist *evlist, const cha=
r *str,
> =20
>  =09ret =3D parse_events__scanner(str, &parse_state, PE_START_EVENTS);
>  =09perf_pmu__parse_cleanup();
> +
> +=09if (!ret && list_empty(&parse_state.list)) {
> +=09=09WARN_ONCE(true, "WARNING: event parser found nothing\n");
> +=09=09return -1;
> +=09}
> +
> +=09/*
> +=09 * Add list to the evlist even with errors to allow callers to clean =
up.
> +=09 */
> +=09perf_evlist__splice_list_tail(evlist, &parse_state.list);

I still dont understand this one.. if there was an error, the list
should be empty, right? also if there's an error and there's something
on the list, what is it? how it gets deleted?

thanks,
jirka

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


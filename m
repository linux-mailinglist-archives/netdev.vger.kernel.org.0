Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 661FDE7AFD
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbfJ1VH1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:07:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27823 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391195AbfJ1VHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:07:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572296843;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vaN691EUnxF95m8CQyGbqME6xNGoyr91KYIIBfK7uXs=;
        b=NsYY3RCcrSSRK7N43bEJtZ75r4ut492io9M3kXqnv1Vnd2QxLuOUk2tRBmrI0f7Xc6siyu
        PLyC2rwit7/d19vH3a4fMivKPMHLVxqCFihwoi7g76UrbDkdmmdWqwNKP0/Ke/hF7eILQP
        5sycfsZPQXb9TKA2RCgr4zZ9MT7NfHY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-pWsCm5gWORa93cR4oE7e_g-1; Mon, 28 Oct 2019 17:07:20 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 851AF1804971;
        Mon, 28 Oct 2019 21:07:17 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4928926359;
        Mon, 28 Oct 2019 21:07:13 +0000 (UTC)
Date:   Mon, 28 Oct 2019 22:07:12 +0100
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
Subject: Re: [PATCH v4 4/9] perf tools: splice events onto evlist even on
 error
Message-ID: <20191028210712.GB6158@krava>
References: <20191024190202.109403-1-irogers@google.com>
 <20191025180827.191916-1-irogers@google.com>
 <20191025180827.191916-5-irogers@google.com>
MIME-Version: 1.0
In-Reply-To: <20191025180827.191916-5-irogers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: pWsCm5gWORa93cR4oE7e_g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 11:08:22AM -0700, Ian Rogers wrote:
> If event parsing fails the event list is leaked, instead splice the list
> onto the out result and let the caller cleanup.
>=20
> An example input for parse_events found by libFuzzer that reproduces
> this memory leak is 'm{'.
>=20
> Signed-off-by: Ian Rogers <irogers@google.com>

Acked-by: Jiri Olsa <jolsa@kernel.org>

thanks,
jirka

> ---
>  tools/perf/util/parse-events.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-event=
s.c
> index c516d0cce946..4c4c6f3e866a 100644
> --- a/tools/perf/util/parse-events.c
> +++ b/tools/perf/util/parse-events.c
> @@ -1952,15 +1952,20 @@ int parse_events(struct evlist *evlist, const cha=
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
> 2.24.0.rc0.303.g954a862665-goog
>=20


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D78E7AED
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 22:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391137AbfJ1VGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 17:06:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25167 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389764AbfJ1VGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 17:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572296812;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qs80qKEjJqjb3JocGFXcxF2DSxYMQR2JCI+aYDkOum0=;
        b=eBxtcNlhYBB+C/yB9WeaGBDJvAVy8Y8BkH+ls9LmuGNH05oIS5/dAUZmx8OaA3hrjDmTIk
        JaVQB7Ehb/AZfJD3xvXKKzfUHnOAFNmbco8Pzo0iWvfzv1jsRMU1gutbW45mGYyz86jnJ8
        MgoOZKvEdDKwpRzNhadl6+RtevQL3XQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-CHxv1kvuMsm_hdpji176SQ-1; Mon, 28 Oct 2019 17:06:46 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5C8185B6EE;
        Mon, 28 Oct 2019 21:06:43 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id A5D621C92C;
        Mon, 28 Oct 2019 21:06:38 +0000 (UTC)
Date:   Mon, 28 Oct 2019 22:06:37 +0100
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
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v3 2/9] perf tools: splice events onto evlist even on
 error
Message-ID: <20191028210637.GA6158@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-3-irogers@google.com>
 <20191025080142.GF31679@krava>
 <CAP-5=fWoHN9wqWasZyyu8mB99-1SOP3NhTT9XX6d99aTG6-AOA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAP-5=fWoHN9wqWasZyyu8mB99-1SOP3NhTT9XX6d99aTG6-AOA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: CHxv1kvuMsm_hdpji176SQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 08:47:12AM -0700, Ian Rogers wrote:

SNIP

> event_pmu: PE_NAME opt_event_config
> {
> ...
> ALLOC_LIST(list);  // <--- where list gets allocated
> ...
> https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-event=
s.y#L229
>=20
> opt_event_config:
> https://github.com/torvalds/linux/blob/master/tools/perf/util/parse-event=
s.y#L510
>=20
> So the parse_state is ending up with a list, however, parsing is
> failing. If the list isn't adding to the evlist then it becomes a
> leak. Splicing it onto the evlist allows the caller to clean this up
> and avoids the leak. An alternate approach is to free the failed list
> and not get the caller to clean up. A way to do this is to create an
> evlist, splice the failed list onto it and then free it - which winds
> up being fairly identical to this approach, and this approach is a
> smaller change.

agreed, thanks for the all the details

jirka


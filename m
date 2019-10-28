Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5049CE7948
	for <lists+netdev@lfdr.de>; Mon, 28 Oct 2019 20:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731200AbfJ1TdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 15:33:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26418 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731158AbfJ1TdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 15:33:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572291203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2YZ7F3vF7jMcA3PDwa/7MxLquCpsOuFuGZy7i0YeAWQ=;
        b=KWbq6AFyKsGBcIdkq156H6A3VQ8Mte/hTLDQSGJLANzAvaFIUkSsrO1F8DXZlXLhTqf6XR
        H33368XyFckcf5dcROkExhDfjbR7he5BbqfCz709Y1ttjdNQ+OxO5qRk92Lk+iGajdPS1w
        BjqhO47WbftoNT0wWHmOKNhCrR5ubak=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-X62VVYcVMR-ZX8x6VVJrsg-1; Mon, 28 Oct 2019 15:33:17 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9B7C85B6EE;
        Mon, 28 Oct 2019 19:33:14 +0000 (UTC)
Received: from krava (ovpn-204-45.brq.redhat.com [10.40.204.45])
        by smtp.corp.redhat.com (Postfix) with SMTP id DD96A1001B32;
        Mon, 28 Oct 2019 19:33:09 +0000 (UTC)
Date:   Mon, 28 Oct 2019 20:33:08 +0100
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
Subject: Re: [PATCH v3 6/9] perf tools: add destructors for parse event terms
Message-ID: <20191028193308.GC28772@krava>
References: <20191023005337.196160-1-irogers@google.com>
 <20191024190202.109403-1-irogers@google.com>
 <20191024190202.109403-7-irogers@google.com>
 <20191025082714.GH31679@krava>
 <CAP-5=fU6quu74JwZSd70UMTSS2wf_29hBgvdXfJZedOfrE7ohw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAP-5=fU6quu74JwZSd70UMTSS2wf_29hBgvdXfJZedOfrE7ohw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: X62VVYcVMR-ZX8x6VVJrsg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 09:08:34AM -0700, Ian Rogers wrote:
> On Fri, Oct 25, 2019 at 1:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 24, 2019 at 12:01:59PM -0700, Ian Rogers wrote:
> > > If parsing fails then destructors are ran to clean the up the stack.
> > > Rename the head union member to make the term and evlist use cases mo=
re
> > > distinct, this simplifies matching the correct destructor.
> >
> > nice did not know about this.. looks like it's been in bison for some t=
ime, right?
>=20
> Looks like it wasn't in Bison 1 but in Bison 2, we're at Bison 3 and
> Bison 2 is > 14 years old:
> https://web.archive.org/web/20050924004158/http://www.gnu.org/software/bi=
son/manual/html_mono/bison.html#Destructor-Decl

sounds safe ;-)

thanks,
jirka


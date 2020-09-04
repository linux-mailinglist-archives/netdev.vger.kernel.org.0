Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD0F25E196
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 20:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbgIDSsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 14:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgIDSsG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 14:48:06 -0400
Received: from quaco.ghostprotocols.net (unknown [179.97.37.151])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62BBC20665;
        Fri,  4 Sep 2020 18:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599245285;
        bh=PDE0If3Xa0BCychsFfVBP73AEAJpWKm1Y9RfRQZSBGs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ypnm1k438oFJq+i9TwHQtBFnd/r8W+r5fRXsR3gjcjbh7+AYmIVtCdsVnJ5SO4grv
         ZaS1tpVK3cSZgoY+JRhzAVJMh6OSmRL9o+gLg0FTWjNIfqw0eLW03A7Bovj5qQUX8p
         7Uoh2ObZp+g8Z768N5NlcPOEHm3eShMOwBXFT+MQ=
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4039B40D3D; Fri,  4 Sep 2020 15:48:03 -0300 (-03)
Date:   Fri, 4 Sep 2020 15:48:03 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Jiri Olsa <jolsa@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v2 2/5] perf record: Prevent override of
 attr->sample_period for libpfm4 events
Message-ID: <20200904184803.GA3749996@kernel.org>
References: <20200728085734.609930-1-irogers@google.com>
 <20200728085734.609930-3-irogers@google.com>
 <20200728155940.GC1319041@krava>
 <20200728160954.GD1319041@krava>
 <CAP-5=fVqto0LrwgW6dHQupp7jFA3wToRBonBaXXQW4wwYcTreg@mail.gmail.com>
 <CAP-5=fWNniZuYfYhz_Cz7URQ+2E4T4Kg3DJqGPtDg70i38Er_A@mail.gmail.com>
 <20200904160303.GD939481@krava>
 <CAP-5=fWOSi4B3g1DARkh6Di-gU4FgmjnhbPYRBdvSdLSy_KC5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fWOSi4B3g1DARkh6Di-gU4FgmjnhbPYRBdvSdLSy_KC5Q@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Sep 04, 2020 at 09:22:10AM -0700, Ian Rogers escreveu:
> On Fri, Sep 4, 2020 at 9:03 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > On Thu, Sep 03, 2020 at 10:41:14PM -0700, Ian Rogers wrote:
> > > On Wed, Jul 29, 2020 at 4:24 PM Ian Rogers <irogers@google.com> wrote:
> > > > On Tue, Jul 28, 2020 at 9:10 AM Jiri Olsa <jolsa@redhat.com> wrote:
> > > > > On Tue, Jul 28, 2020 at 05:59:46PM +0200, Jiri Olsa wrote:
> > > > > > On Tue, Jul 28, 2020 at 01:57:31AM -0700, Ian Rogers wrote:
> > > > > [jolsa@krava perf]$ sudo ./perf test 17 -v
> > > > > 17: Setup struct perf_event_attr                          :

> > > > > running './tests/attr/test-record-C0'
> > > > > expected sample_period=4000, got 3000
> > > > > FAILED './tests/attr/test-record-C0' - match failure

> > > > I'm not able to reproduce this. Do you have a build configuration or
> > > > something else to look at? The test doesn't seem obviously connected
> > > > with this patch.

> > > Jiri, any update? Thanks,

> > sorry, I rebased and ran it again and it passes for me now,
> > so it got fixed along the way

> No worries, thanks for the update! It'd be nice to land this and the
> other libpfm fixes.

I applied it and it generated this regression:

FAILED '/home/acme/libexec/perf-core/tests/attr/test-record-pfm-period' - match failure

I'll look at the other patches that are pending in this regard to see
what needs to be squashed so that we don't break bisect.

- Arnaldo

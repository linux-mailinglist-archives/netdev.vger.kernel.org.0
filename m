Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607E9496DF9
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 21:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiAVUTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 15:19:43 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43978 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbiAVUTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 15:19:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFAA360F58;
        Sat, 22 Jan 2022 20:19:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DB8FC004E1;
        Sat, 22 Jan 2022 20:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642882781;
        bh=kX+aJj/Ez7j/vGpPEOXOs3QVeKathCgDdsMowcP72ek=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GpS+AGrD/Yl+Gw9+O9UCzo/+EfJJHUeH4MOgVMMbmRNf0ldRSK0UqEIpx82OM+vlv
         rA8K4wgWuyUAfmTc6i0a0rwyO8Ec9XA/p2kztjH02F+RKL+PZRAbbKHGoCCi3AiWPv
         ZkcVKs9P/Pr+VgnlHfTWO0VY8mNw+I4suK4/sZE1iPMeHu3LtzHIxT8b5EyTvuLl+k
         JuvaBvxBvWY+YPJblogxtvD5o8TJJ5qgMT1+z+e3oCfl4imrpbfpTuTSHupDBsCMQH
         NJIFJj6FyfQBuE31nsAE/TkyrZNMfoOZqhCylT2QMSw3N3qggjdx6Ss/FQLCqLjHM/
         WjLH3sYWdbbZQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 6933D40C99; Sat, 22 Jan 2022 17:17:39 -0300 (-03)
Date:   Sat, 22 Jan 2022 17:17:39 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ian Rogers <irogers@google.com>
Cc:     German Gomez <german.gomez@arm.com>,
        James Clark <james.clark@arm.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Chase Conklin <chase.conklin@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] perf record/arm-spe: Override attr->sample_period for
 non-libpfm4 events
Message-ID: <YexmY89WKpz0TwNK@kernel.org>
References: <20220114212102.179209-1-german.gomez@arm.com>
 <c2b960eb-a25e-7ce7-ee4b-2be557d8a213@arm.com>
 <35a4f70f-d7ef-6e3c-dc79-aa09d87f0271@arm.com>
 <CAP-5=fUHT29Z8Y5pMdTWK4mLKAXrNTtC5RBpet6UsAy4TLDfDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP-5=fUHT29Z8Y5pMdTWK4mLKAXrNTtC5RBpet6UsAy4TLDfDw@mail.gmail.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, Jan 17, 2022 at 08:28:07AM -0800, Ian Rogers escreveu:
> On Mon, Jan 17, 2022 at 2:27 AM German Gomez <german.gomez@arm.com> wrote:
> >
> > Hi James,
> >
> > On 17/01/2022 09:59, James Clark wrote:
> > >
> > > On 14/01/2022 21:21, German Gomez wrote:
> > >> A previous commit preventing attr->sample_period values from being
> > >> overridden in pfm events changed a related behaviour in arm_spe.
> > >>
> > >> Before this patch:
> > >> perf record -c 10000 -e arm_spe_0// -- sleep 1
> > >>
> > >> Would not yield an SPE event with period=10000, because the arm-spe code
> > > Just to clarify, this seems like it should say "Would yield", not "Would not yield",
> > > as in it was previously working?
> >
> > "this patch" refers to the patch I'm sending, not the one it's fixing.
> > I might have to rewrite this to make it more clear. How about:
> >
> > ===
> > A previous patch preventing "attr->sample_period" values from being
> > overridden in pfm events changed a related behaviour in arm-spe.
> >
> > Before said patch:
> > perf record -c 10000 -e arm_spe_0// -- sleep 1
> >
> > Would yield an SPE event with period=10000. After the patch, the period
> > in "-c 10000" was being ignored because the arm-spe code initializes
> > sample_period to a non-zero value.
> >
> > This patch restores the previous behaviour for non-libpfm4 events.
> > ===
> 
> Thanks for fixing this, I can add an acked-by for the v2 patch. Could

Ian,

	He posted a v2, can I add your Acked-by?

- Arnaldo

> we add a test for this to avoid future regressions? There are similar
> tests for frequency like:
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr/test-record-freq
> based on the attr.py test:
> https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr.py
> The test specifies a base type of event attribute and then what is
> modified by the test. It takes a little to get your head around but
> having a test for this would be a welcome addition.
> 
> Thanks!
> Ian
> 
> > Thanks for the review,
> > German

-- 

- Arnaldo

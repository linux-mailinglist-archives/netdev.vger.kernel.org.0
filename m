Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEBB9496DF1
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 21:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiAVURF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 15:17:05 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42818 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiAVURE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 15:17:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38EE060F54;
        Sat, 22 Jan 2022 20:17:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7977CC004E1;
        Sat, 22 Jan 2022 20:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642882623;
        bh=tVg2I+OYNYnmRW0hHAxIzXL1Bh86fTDdBEB8uHh50xU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=snCUP0Joj9DvmkjsEKMpcvLb/S20VUmJbOQFnDtT0y8UZFnzTps/m9i0afmyre5Q3
         vyKk7zK7+Y6mA6qCcvFxzLIfR6djclcTRgy4DtgMAYtvNtI5VNrLgYMeTYb6H0xojv
         ebXy8RDsS8kA1PZ1bJHigR8nleb5Xx9G8tTXW0+T/Rp3wKdw3I538r56mBaxFi+g0e
         eFuC9EMVXN8JKPHJFOyQwWlebRqqtuC9MyL073cWMtX5Z6dv47hWy7lKarmraaJGTd
         LLii1yigMdfqWYFJU8QgdA/SN+hJ+AcS8/AfV5oWaHGEaVwCPOHrB3dFqaieTbNri2
         kKZaWxQ9ppQVA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 78B3340D0E; Sat, 22 Jan 2022 17:15:01 -0300 (-03)
Date:   Sat, 22 Jan 2022 17:15:01 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     German Gomez <german.gomez@arm.com>
Cc:     Ian Rogers <irogers@google.com>, James Clark <james.clark@arm.com>,
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
Message-ID: <Yexlxe0JHgj4ndSQ@kernel.org>
References: <20220114212102.179209-1-german.gomez@arm.com>
 <c2b960eb-a25e-7ce7-ee4b-2be557d8a213@arm.com>
 <35a4f70f-d7ef-6e3c-dc79-aa09d87f0271@arm.com>
 <CAP-5=fUHT29Z8Y5pMdTWK4mLKAXrNTtC5RBpet6UsAy4TLDfDw@mail.gmail.com>
 <10cc73f1-53fd-9c5a-7fe2-8cd3786fbe37@arm.com>
 <YeazXmnjkET7h5LW@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeazXmnjkET7h5LW@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jan 18, 2022 at 09:32:30AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Jan 17, 2022 at 09:32:55PM +0000, German Gomez escreveu:
> > Hi Ian,
> > 
> > On 17/01/2022 16:28, Ian Rogers wrote:
> > > [...]
> > > Thanks for fixing this, I can add an acked-by for the v2 patch. Could
> > > we add a test for this to avoid future regressions? There are similar
> > > tests for frequency like:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr/test-record-freq
> > > based on the attr.py test:
> > > https://git.kernel.org/pub/scm/linux/kernel/git/acme/linux.git/tree/tools/perf/tests/attr.py
> > > The test specifies a base type of event attribute and then what is
> > > modified by the test. It takes a little to get your head around but
> > > having a test for this would be a welcome addition.
> > 
> > I agree I should have included a test for this fix. I'll look into this for the v2.
> 
> A test is always good to have, we need more, yeah.
> 
> But since this is a fix and what is needed for v2 is just to improve the
> wording, please don't let the test to prevent you from sending the
> updated fix.
> 
> Then you can go on and work on the test.
> 
> I say this because the merge window may close before the test gets ready
> and its better for us to have fixes merged as soon as possible so that
> we have more time to figure out if it has unintended consequences as it
> gets in place for longer.

So, any news about this?

- ARnaldo
  
> > Other events such as "-p 10000 -e cycles//" worked fine. Only the ones with aux area tracing (arm_spe, cs_etm, intel_pt) were ignoring the global config flags.
> > 
> > Thank you for the pointers, and the review,
> > German

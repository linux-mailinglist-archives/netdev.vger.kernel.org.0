Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3728039121E
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 10:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231924AbhEZIQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 04:16:50 -0400
Received: from outbound-smtp08.blacknight.com ([46.22.139.13]:38375 "EHLO
        outbound-smtp08.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231410AbhEZIQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 04:16:49 -0400
Received: from mail.blacknight.com (pemlinmail01.blacknight.ie [81.17.254.10])
        by outbound-smtp08.blacknight.com (Postfix) with ESMTPS id 1C1961C3FEC
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 09:15:14 +0100 (IST)
Received: (qmail 25045 invoked from network); 26 May 2021 08:15:13 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 26 May 2021 08:15:13 -0000
Date:   Wed, 26 May 2021 09:15:11 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Michal Such?nek <msuchanek@suse.de>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>
Subject: Re: BPF: failed module verification on linux-next
Message-ID: <20210526081511.GX30378@techsingularity.net>
References: <20210519141936.GV8544@kitsune.suse.cz>
 <CAEf4BzZuU2TYMapSy7s3=D8iYtVw_N+=hh2ZMGG9w6N0G1HvbA@mail.gmail.com>
 <CAEf4BzZ0-sihSL-UAm21JcaCCY92CqfNxycHRZYXcoj8OYb=wA@mail.gmail.com>
 <20210525135101.GT30378@techsingularity.net>
 <CAEf4BzYwuMVkiUa+iGpVWKvAdwLbrzY_qzhD9N0DYu1pGOEcJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEf4BzYwuMVkiUa+iGpVWKvAdwLbrzY_qzhD9N0DYu1pGOEcJA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Tue, May 25, 2021 at 6:51 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> >
> > On Mon, May 24, 2021 at 03:58:29PM -0700, Andrii Nakryiko wrote:
> > > > It took me a while to reliably bisect this, but it clearly points to
> > > > this commit:
> > > >
> > > > e481fac7d80b ("mm/page_alloc: convert per-cpu list protection to local_lock")
> > > > <SNIP>
> > >
> > > Ok, so nothing weird about them. local_lock_t is designed to be
> > > zero-sized unless CONFIG_DEBUG_LOCK_ALLOC is defined.
> > >
> > > But such zero-sized per-CPU variables are confusing pahole during BTF
> > > generation, as now two different variables "occupy" the same address.
> > >
> > > Given this seems to be the first zero-sized per-CPU variable, I wonder
> > > if it would be ok to make sure it's never zero-sized, while pahole
> > > gets fixed and it's latest version gets widely packaged and
> > > distributed.
> > >
> > > Mel, what do you think about something like below? Or maybe you can
> > > advise some better solution?
> > >
> >
> > Ouch, something like that may never go away. How about just this?
> 
> Yeah, that would work just fine, thanks! Would you like me to send a
> formal patch or you'd like to do it?
> 

Thanks Andrii for bisecting and debugging this, I used your analysis in
the changelog which I hope is ok. For future mailing list searches based
on the same bug, I sent a formal patch

https://lore.kernel.org/r/20210526080741.GW30378@techsingularity.net

> > diff --git a/scripts/rust-version.sh b/scripts/rust-version.sh
> > old mode 100644
> > new mode 100755
> 
> Probably didn't intend to include this?
> 

That was an oversight when applying Andrew's mmotm tree which missed
setting the permissions on rust-version.sh and broke build.

-- 
Mel Gorman
SUSE Labs

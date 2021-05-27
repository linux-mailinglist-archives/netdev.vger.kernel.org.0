Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35BDD3934BD
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 19:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236952AbhE0R2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 13:28:38 -0400
Received: from outbound-smtp11.blacknight.com ([46.22.139.106]:54749 "EHLO
        outbound-smtp11.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235231AbhE0R2g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 13:28:36 -0400
Received: from mail.blacknight.com (pemlinmail05.blacknight.ie [81.17.254.26])
        by outbound-smtp11.blacknight.com (Postfix) with ESMTPS id 471BE1C4772
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 18:27:02 +0100 (IST)
Received: (qmail 27096 invoked from network); 27 May 2021 17:27:01 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 May 2021 17:27:01 -0000
Date:   Thu, 27 May 2021 18:27:00 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH v2] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <20210527172700.GH30378@techsingularity.net>
References: <20210527120251.GC30378@techsingularity.net>
 <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
 <20210527145441.GE30378@techsingularity.net>
 <CAEf4BzbW2i4Y-i3TXW7x42PqEpw5_nNeReSXS77m4GC3uqD3wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAEf4BzbW2i4Y-i3TXW7x42PqEpw5_nNeReSXS77m4GC3uqD3wg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 09:36:35AM -0700, Andrii Nakryiko wrote:
> On Thu, May 27, 2021 at 7:54 AM Mel Gorman <mgorman@techsingularity.net> wrote:
> >
> > On Thu, May 27, 2021 at 07:37:05AM -0700, Andrii Nakryiko wrote:
> > > > This patch checks for older versions of pahole and only allows
> > > > DEBUG_INFO_BTF_MODULES if pahole supports zero-sized per-cpu structures.
> > > > DEBUG_INFO_BTF is still allowed as a KVM boot test passed with pahole
> > >
> > > Unfortunately this won't work. The problem is that vmlinux BTF is
> > > corrupted, which results in module BTFs to be rejected as well, as
> > > they depend on it.
> > >
> > > But vmlinux BTF corruption makes BPF subsystem completely unusable. So
> > > even though kernel boots, nothing BPF-related works. So we'd need to
> > > add dependency for DEBUG_INFO_BTF on pahole 1.22+.
> > >
> >
> > While bpf usage would be broken, the kernel will boot and the effect
> > should be transparent to any kernel build based on "make oldconfig".
> 
> I think if DEBUG_INFO_BTF=y has no chance of generating valid vmlinux
> BTF it has to be forced out. So if we are doing this at all, we should
> do it for CONFIG_DEBUG_INFO_BTF, not CONFIG_DEBUG_INFO_BTF_MODULES.
> CONFIG_DEBUG_INFO_BTF_MODULES will follow automatically.
> 

Ok, I sent a version that prevents DEBUG_INFO_BTF being set unless
pahole is at least 1.22.

> > CONFIG_DEBUG_INFO_BTF defaults N so if that is forced out, it will be
> > easily missed by a distribution kernel maintainer.
> 
> We actually had previous discussions on forcing build failure in cases
> when CONFIG_DEBUG_INFO_BTF=y can't be satisfied, but no one followed
> up.

It is weird how it is handled. DEBUG_INFO_BTF can be set and then fail to
build vmlinux because pahole is too old. With DEBUG_INFO_BTF now requiring
at least 1.22, the other version checks for 1.16 and 1.19 are redundant
and could be cleaned up.

> I'll look into this and will try to change the behavior. It's
> caused too much confusion previously and now with changes like this we
> are going to waste even more people's time.
> 

Thanks.

-- 
Mel Gorman
SUSE Labs

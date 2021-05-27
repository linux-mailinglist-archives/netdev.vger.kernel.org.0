Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAC9392A38
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 11:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235648AbhE0JGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 05:06:00 -0400
Received: from outbound-smtp53.blacknight.com ([46.22.136.237]:48987 "EHLO
        outbound-smtp53.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235588AbhE0JF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 05:05:58 -0400
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp53.blacknight.com (Postfix) with ESMTPS id 91C96FB01E
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 10:04:24 +0100 (IST)
Received: (qmail 2356 invoked from network); 27 May 2021 09:04:24 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.23.168])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 27 May 2021 09:04:24 -0000
Date:   Thu, 27 May 2021 10:04:22 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <20210527090422.GA30378@techsingularity.net>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <YK9SiLX1E1KAZORb@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 09:04:24AM +0100, Christoph Hellwig wrote:
> On Wed, May 26, 2021 at 09:07:41AM +0100, Mel Gorman wrote:
> > +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
> > +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> > +	/*
> > +	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> > +	 * variables and produces invalid BTF. Ensure that
> > +	 * sizeof(struct pagesets) != 0 for older versions of pahole.
> > +	 */
> > +	char __pahole_hack;
> > +	#warning "pahole too old to support zero-sized struct pagesets"
> > +#endif
> 
> Err, hell no.  We should not mess up the kernel for broken tools that
> are not relevant to the kernel build itself ever.

What do you suggest as an alternative?

I added Arnaldo to the cc as he tagged the last released version of
pahole (1.21) and may be able to tag a 1.22 with Andrii's fix for pahole
included.

The most obvious alternative fix for this issue is to require pahole
1.22 to set CONFIG_DEBUG_INFO_BTF but obviously a version 1.22 that works
needs to exist first and right now it does not. I'd be ok with this but
users of DEBUG_INFO_BTF may object given that it'll be impossible to set
the option until there is a release.

The second alternative fix is to embed the local_lock
within struct per_cpu_pages. It was shown this was possible in
https://lore.kernel.org/linux-rt-users/20210419141341.26047-1-mgorman@techsingularity.net/T/#md1001d7af52ac0d6d214b95e98fe051f9399de64
but I dropped it because it makes the locking protocol complex e.g.
config-specific lock-switchin in free_unref_page_list.

The last one is wrapping local_lock behind #defines and only defining the
per-cpu structures when local_lock_t is a non-zero size. That is simply
too ugly for words, the locking patterns should always be the same.


-- 
Mel Gorman
SUSE Labs

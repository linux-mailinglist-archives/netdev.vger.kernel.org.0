Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0679365AA0
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhDTN5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:57:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:49844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232253AbhDTN5l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 09:57:41 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1618927028; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lvmyWLVNyKpzZxwVe1+/Riv3KeBC0cRALAmWFhQu6O4=;
        b=Ybue4AT2OizHnD22Drd25oWnK7r4f4A/RlWeUbitxckHG/CS+Z6n08YglYyTcCvDl/qWMk
        GVCHakE16znkWrab0ao5hsiWgilzl99Tz/P1eqYLRoeiWSq8CiUeix6tEB3NyQP6X1kzAT
        6PwkuRBVUTCEp+xqOO3xw8LY6k0S7Lg=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 414FBB061;
        Tue, 20 Apr 2021 13:57:08 +0000 (UTC)
Date:   Tue, 20 Apr 2021 15:57:07 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Mike Rapoport <rppt@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH7ds1YOAOQt8Mpf@dhcp22.suse.cz>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <20210420132430.GB3596236@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420132430.GB3596236@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 20-04-21 14:24:30, Matthew Wilcox wrote:
> On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> > Add a paragraph that explains that it may happen that the counters in
> > /proc/meminfo do not add up to the overall memory usage.
> 
> ... that is, the sum may be lower because memory is allocated for other
> purposes that is not reported here, right?

yes. Many direct page allocator users are not accounted in any of the
existing counters.

> Is it ever possible for it to be higher?  Maybe due to a race when
> sampling the counters?

Yes likely possible. You will never get an atomic snapshot of all
counters.

> >  Provides information about distribution and utilization of memory.  This
> > -varies by architecture and compile options.  The following is from a
> > -16GB PIII, which has highmem enabled.  You may not have all of these fields.
> > +varies by architecture and compile options. Please note that it may happen
> > +that the memory accounted here does not add up to the overall memory usage
> > +and the difference for some workloads can be substantial. In many cases there
> > +are other means to find out additional memory using subsystem specific
> > +interfaces, for instance /proc/net/sockstat for TCP memory allocations.
> 
> How about just:
> 
> +varies by architecture and compile options.  The memory reported here
> +may not add up to the overall memory usage and the difference for some
> +workloads can be substantial. [...]
> 
> But I'd like to be a bit more explicit about the reason, hence my question
> above to be sure I understand.
> 
> 
> It's also not entirely clear which of the fields in meminfo can be
> usefully summed.  VmallocTotal is larger than MemTotal, for example.

Yes. Many/Most counters cannot be simply sumed up. A trivial example would be
Active/Inactive is a sum of both anona and file. Mlocked will be
accounted in LRU pages and Unevictable. MemAvailable is not really a
counter... 

Usual memory consumption is usually something like LRU pages + Slab
memory + kernel stack + vmalloc used + pcp.

> But I know that KernelStack is allocated through vmalloc these days,
> and I don't know whether VmallocUsed includes KernelStack or whether I
> can sum them.  Similarly, is Mlocked a subset of Unevictable?
> 
> There is some attempt at explaining how these numbers fit together, but
> it's outdated, and doesn't include Mlocked, Unevictable or KernelStack

Agreed there is a lot of tribal knowledge or even misconceptions flying
around and it will take much more work to put everything into shape.
This is only one tiny step forward.
-- 
Michal Hocko
SUSE Labs

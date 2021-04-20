Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64E8365B7C
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 16:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232764AbhDTOwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 10:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhDTOwb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 10:52:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3F6613C9;
        Tue, 20 Apr 2021 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618930319;
        bh=JpMF49XQzCztEq9qBMVVUAhpIKrxlZMr9gtph/RDnns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DFmiGYcWMxauOWy6nBp2DbEzQ4/Xd2/5MxCZjp7sIXR8Jy8f/RuJuQIEcZUjdnBy5
         cDcWJizyqC0jjXKNVsGTb7Mrxm0DoRe/ADAdMPTwOOfOeWUUhZvp/DX5Mwup7+I9zT
         LVn6zAFbBX+s4dCDXHAn2uRg0r6gx5zZYrsRkseFAeMVqeYd775KFeLnYGUELNtooA
         DVGWt6hWJSLO4/2adeHw2m4ibJQ7BcEvtGY4Bb0zqU6Xp0JZwndJvbYM70qvAEr6kb
         qHiYsPq0vGLpoRO/OzM1zKg8EpbKOCU8r501caYB5funvMAHPHuAeewYToxShXs20D
         L4woI7RPg/MzQ==
Date:   Tue, 20 Apr 2021 17:51:51 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] docs: proc.rst: meminfo: briefly describe gaps in
 memory accounting
Message-ID: <YH7qhwhbLt0yT3Zy@kernel.org>
References: <20210420121354.1160437-1-rppt@kernel.org>
 <20210420132430.GB3596236@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420132430.GB3596236@casper.infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 02:24:30PM +0100, Matthew Wilcox wrote:
> On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> > Add a paragraph that explains that it may happen that the counters in
> > /proc/meminfo do not add up to the overall memory usage.
> 
> ... that is, the sum may be lower because memory is allocated for other
> purposes that is not reported here, right?
> 
> Is it ever possible for it to be higher?  Maybe due to a race when
> sampling the counters?
> 
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

I like this. I also for adding a sentence about overlap in the counters:

+varies by architecture and compile options.  Some of the counters reported
+here overlap.  The memory reported by the non overlapping counters may not
+add up to the overall memory usage and the difference for some workloads
can be substantial. [...]
 
> But I'd like to be a bit more explicit about the reason, hence my question
> above to be sure I understand.
> 
> It's also not entirely clear which of the fields in meminfo can be
> usefully summed.  VmallocTotal is larger than MemTotal, for example.
> But I know that KernelStack is allocated through vmalloc these days,
> and I don't know whether VmallocUsed includes KernelStack or whether I
> can sum them.  Similarly, is Mlocked a subset of Unevictable?
> 
> There is some attempt at explaining how these numbers fit together, but
> it's outdated, and doesn't include Mlocked, Unevictable or KernelStack

Fixing the outdated docs and adding more detailed explanation is obviously
welcome, but it's beyond the scope of the current patch.

-- 
Sincerely yours,
Mike.

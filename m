Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 306F03659FC
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 15:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbhDTN1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 09:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232427AbhDTN1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 09:27:02 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6F1AC06174A;
        Tue, 20 Apr 2021 06:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VMqaJi7cREgHvXbfYZgCh1yWGauQvsEM/bV4hsp9kpI=; b=oYIjeBNLDU0bKUDPhFNTmvYkZK
        g53/qZBWtJ4qmFYmHlqWepJ0FmGFsoXKciINNRiOUsXrKlFjZxMU+5w86z4jSxEqdVbPnmwLQJ0I4
        QblDiYLB0ZwNnoShTB7pzUIEqXQYgkP6X4VfyjOkT4iwAeZJ9TWj8wO0hT8FfHroUCas+dMT2M2kk
        BJWxhpuqViQNbWdBRh3SdfIw1+tKOj6jQvkPldSdiuK85EtimYx4m7BGUuQKErPN7+RwkxAlIkcl7
        X9j4UCHiBwcgWOXAuuLZ9tNy0AZfLZtuNUpnfVfa/yHcmS7mmP/2grQ86rdMiimTFItKK9SLzpvDe
        sL0DA9ZA==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYqMg-00FCb5-Gr; Tue, 20 Apr 2021 13:25:08 +0000
Date:   Tue, 20 Apr 2021 14:24:30 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Mike Rapoport <rppt@kernel.org>
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
Message-ID: <20210420132430.GB3596236@casper.infradead.org>
References: <20210420121354.1160437-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420121354.1160437-1-rppt@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 03:13:54PM +0300, Mike Rapoport wrote:
> Add a paragraph that explains that it may happen that the counters in
> /proc/meminfo do not add up to the overall memory usage.

... that is, the sum may be lower because memory is allocated for other
purposes that is not reported here, right?

Is it ever possible for it to be higher?  Maybe due to a race when
sampling the counters?

>  Provides information about distribution and utilization of memory.  This
> -varies by architecture and compile options.  The following is from a
> -16GB PIII, which has highmem enabled.  You may not have all of these fields.
> +varies by architecture and compile options. Please note that it may happen
> +that the memory accounted here does not add up to the overall memory usage
> +and the difference for some workloads can be substantial. In many cases there
> +are other means to find out additional memory using subsystem specific
> +interfaces, for instance /proc/net/sockstat for TCP memory allocations.

How about just:

+varies by architecture and compile options.  The memory reported here
+may not add up to the overall memory usage and the difference for some
+workloads can be substantial. [...]

But I'd like to be a bit more explicit about the reason, hence my question
above to be sure I understand.


It's also not entirely clear which of the fields in meminfo can be
usefully summed.  VmallocTotal is larger than MemTotal, for example.
But I know that KernelStack is allocated through vmalloc these days,
and I don't know whether VmallocUsed includes KernelStack or whether I
can sum them.  Similarly, is Mlocked a subset of Unevictable?

There is some attempt at explaining how these numbers fit together, but
it's outdated, and doesn't include Mlocked, Unevictable or KernelStack

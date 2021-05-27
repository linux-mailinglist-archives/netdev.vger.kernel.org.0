Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15475392932
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 10:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhE0IGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbhE0IGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 04:06:43 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65B55C061574;
        Thu, 27 May 2021 01:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=HZTJtPak0qESqpxtknOeWjbW9dY9rji7MIUgVM4VTb0=; b=mhlRpKNsUp7fwJVYOWwOqzxNZe
        wX3ay94qV385dgr6it9qVXZErZFu+PTxCzihyL9Y0RsXOt7W+TwzeC+XHMxGZswJjheaTlCxf1pfB
        ofWnnBj1FsjpHp99A2GTRg6t+f1POAMoUMqhYJrNkYGSgcTHJTwgrWP/ClzVQX1H5FsETL2NZWeZq
        yJZd1xRRMJyWLSLpY+2q2x+i+3J28B/8PxX+7TMrItNzB9Uvm1d1dz7PukjGMqCppxZ4u021764xH
        NKtgUbU1RwcIrwbBQUJM+6vZhDryX/edNK342WMHb5OV9lG7R5II65p7XXBl5pVCCeVw7hKBXSaN2
        /MtDG6Og==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmB0C-005JUT-22; Thu, 27 May 2021 08:04:28 +0000
Date:   Thu, 27 May 2021 09:04:24 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Message-ID: <YK9SiLX1E1KAZORb@infradead.org>
References: <20210526080741.GW30378@techsingularity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526080741.GW30378@techsingularity.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 09:07:41AM +0100, Mel Gorman wrote:
> +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&		\
> +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> +	/*
> +	 * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> +	 * variables and produces invalid BTF. Ensure that
> +	 * sizeof(struct pagesets) != 0 for older versions of pahole.
> +	 */
> +	char __pahole_hack;
> +	#warning "pahole too old to support zero-sized struct pagesets"
> +#endif

Err, hell no.  We should not mess up the kernel for broken tools that
are not relevant to the kernel build itself ever.

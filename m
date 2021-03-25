Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A3B34923C
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbhCYMk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:40:58 -0400
Received: from outbound-smtp22.blacknight.com ([81.17.249.190]:38671 "EHLO
        outbound-smtp22.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231210AbhCYMkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 08:40:35 -0400
Received: from mail.blacknight.com (pemlinmail06.blacknight.ie [81.17.255.152])
        by outbound-smtp22.blacknight.com (Postfix) with ESMTPS id DF4BEBAA77
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 12:40:33 +0000 (GMT)
Received: (qmail 19824 invoked from network); 25 Mar 2021 12:40:33 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.22.4])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 25 Mar 2021 12:40:33 -0000
Date:   Thu, 25 Mar 2021 12:40:32 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-NFS <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH 4/9] mm/page_alloc: optimize code layout for
 __alloc_pages_bulk
Message-ID: <20210325124032.GR3697@techsingularity.net>
References: <20210325114228.27719-1-mgorman@techsingularity.net>
 <20210325114228.27719-5-mgorman@techsingularity.net>
 <20210325121217.GV1719932@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20210325121217.GV1719932@casper.infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:12:17PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 25, 2021 at 11:42:23AM +0000, Mel Gorman wrote:
> >  
> > -	if (WARN_ON_ONCE(nr_pages <= 0))
> > +	if (unlikely(nr_pages <= 0))
> >  		return 0;
> 
> If we made nr_pages unsigned, we wouldn't need this check at all (ok,
> we'd still need to figure out what to do with 0).  But then, if a user
> inadvertently passes in -ENOMEM, we'll try to allocate 4 billion pages.

This is exactly why nr_pages is signed. An error in accounting by the
caller potentially puts the system under severe memory pressure. This
*should* only be a problem when a new caller of the API is being
implemented. The warning goes away in a later patch for reasons explained
in the changelog.

> So maybe we should check it.  Gah, API design is hard.

Yep.

-- 
Mel Gorman
SUSE Labs

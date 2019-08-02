Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89D4A802BF
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 00:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392442AbfHBWcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 18:32:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729919AbfHBWci (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 18:32:38 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58F57206A3;
        Fri,  2 Aug 2019 22:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564785158;
        bh=z6ytUlp+CIECyVYgzsmKAgNAlD3y+8CHq71PuCQ0D+c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cpjIBy8JqGDmfo2YvJ1zHX2H3F5SzV7XyBEUvKOoDGfZiHGtVeJHlsiNF8f/o/lw/
         1IriX/50tm1jxxFU6BHxnU7AmYr31cK1qfEIW7FiUI67JvLd42gEz50jymZEZTSESa
         2e28o/zwwAXm5Iq/SkAmipJbFc8z+f7/iU9PnXtA=
Message-ID: <2f0d5993e9731808b73b0018f5fc4b3335fc6373.camel@kernel.org>
Subject: Re: [PATCH 03/34] net/ceph: convert put_page() to put_user_page*()
From:   Jeff Layton <jlayton@kernel.org>
To:     john.hubbard@gmail.com, Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?ISO-8859-1?Q?J=E9r=F4me?= Glisse <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Date:   Fri, 02 Aug 2019 18:32:33 -0400
In-Reply-To: <20190802022005.5117-4-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
         <20190802022005.5117-4-jhubbard@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-01 at 19:19 -0700, john.hubbard@gmail.com wrote:
> From: John Hubbard <jhubbard@nvidia.com>
> 
> For pages that were retained via get_user_pages*(), release those pages
> via the new put_user_page*() routines, instead of via put_page() or
> release_pages().
> 
> This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
> ("mm: introduce put_user_page*(), placeholder versions").
> 
> Cc: Ilya Dryomov <idryomov@gmail.com>
> Cc: Sage Weil <sage@redhat.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: ceph-devel@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> ---
>  net/ceph/pagevec.c | 8 +-------
>  1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
> index 64305e7056a1..c88fff2ab9bd 100644
> --- a/net/ceph/pagevec.c
> +++ b/net/ceph/pagevec.c
> @@ -12,13 +12,7 @@
>  
>  void ceph_put_page_vector(struct page **pages, int num_pages, bool dirty)
>  {
> -	int i;
> -
> -	for (i = 0; i < num_pages; i++) {
> -		if (dirty)
> -			set_page_dirty_lock(pages[i]);
> -		put_page(pages[i]);
> -	}
> +	put_user_pages_dirty_lock(pages, num_pages, dirty);
>  	kvfree(pages);
>  }
>  EXPORT_SYMBOL(ceph_put_page_vector);

This patch looks sane enough. Assuming that the earlier patches are OK:

Acked-by: Jeff Layton <jlayton@kernel.org>


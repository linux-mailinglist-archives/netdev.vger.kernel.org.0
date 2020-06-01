Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B03A1EA2BA
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 13:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgFALe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 07:34:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:56316 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbgFALe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jun 2020 07:34:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54BD1AECB;
        Mon,  1 Jun 2020 11:34:26 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 1217B1E0948; Mon,  1 Jun 2020 13:34:24 +0200 (CEST)
Date:   Mon, 1 Jun 2020 13:34:24 +0200
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] docs: mm/gup: pin_user_pages.rst: add a "case 5"
Message-ID: <20200601113424.GF3960@quack2.suse.cz>
References: <20200601052633.853874-1-jhubbard@nvidia.com>
 <20200601052633.853874-2-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200601052633.853874-2-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun 31-05-20 22:26:32, John Hubbard wrote:
> There are four cases listed in pin_user_pages.rst. These are
> intended to help developers figure out whether to use
> get_user_pages*(), or pin_user_pages*(). However, the four cases
> do not cover all the situations. For example, drivers/vhost/vhost.c
> has a "pin, write to page, set page dirty, unpin" case.
> 
> Add a fifth case, to help explain that there is a general pattern
> that requires pin_user_pages*() API calls.
> 
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Jérôme Glisse <jglisse@redhat.com>
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: linux-doc@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  Documentation/core-api/pin_user_pages.rst | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
> index 4675b04e8829..6068266dd303 100644
> --- a/Documentation/core-api/pin_user_pages.rst
> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -171,6 +171,24 @@ If only struct page data (as opposed to the actual memory contents that a page
>  is tracking) is affected, then normal GUP calls are sufficient, and neither flag
>  needs to be set.
>  
> +CASE 5: Pinning in order to write to the data within the page
> +-------------------------------------------------------------
> +Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
> +write to a page's data, unpin" can cause a problem. Case 5 may be considered a
> +superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
> +other words, if the code is neither Case 1 nor Case 2, it may still require
> +FOLL_PIN, for patterns like this:
> +
> +Correct (uses FOLL_PIN calls):
> +    pin_user_pages()
> +    write to the data within the pages
> +    unpin_user_pages()
> +
> +INCORRECT (uses FOLL_GET calls):
> +    get_user_pages()
> +    write to the data within the pages
> +    put_page()
> +
>  page_maybe_dma_pinned(): the whole point of pinning
>  ===================================================
>  
> -- 
> 2.26.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

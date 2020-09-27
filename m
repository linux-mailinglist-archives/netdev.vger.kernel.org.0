Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009AA27A0D9
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 14:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgI0MVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 08:21:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726185AbgI0MVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 27 Sep 2020 08:21:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74316208FE;
        Sun, 27 Sep 2020 12:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601209265;
        bh=FdSjEiIOfosty1A1hNpYjx+LCe0c93peV/xVsFD6r/o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FtJG2gRJohbsXmjTGZLvssQG1XF1/EDPa+Sxt7uDN386HN/YFfrvpzrv4+5S2OGee
         WwgbRJn5W6gVfWdvXi4OwSNypTgoQvpwd2ypZNN7rw+jr66jN5W1yoJ984HbBn313O
         5EwO+4+ECjBUiIjNR1+7fPf+BlbKDjiL9nYij4XI=
Date:   Sun, 27 Sep 2020 14:21:15 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Coly Li <colyli@suse.de>
Cc:     linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        netdev@vger.kernel.org, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v8 1/7] net: introduce helper sendpage_ok() in
 include/linux/net.h
Message-ID: <20200927122115.GA178781@kroah.com>
References: <20200925150119.112016-1-colyli@suse.de>
 <20200925150119.112016-2-colyli@suse.de>
 <20200925151812.GA3182427@kroah.com>
 <7b0d4f63-2fe5-9032-3b88-97619d8c5081@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7b0d4f63-2fe5-9032-3b88-97619d8c5081@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 26, 2020 at 09:28:03PM +0800, Coly Li wrote:
> On 2020/9/25 23:18, Greg KH wrote:
> > On Fri, Sep 25, 2020 at 11:01:13PM +0800, Coly Li wrote:
> >> The original problem was from nvme-over-tcp code, who mistakenly uses
> >> kernel_sendpage() to send pages allocated by __get_free_pages() without
> >> __GFP_COMP flag. Such pages don't have refcount (page_count is 0) on
> >> tail pages, sending them by kernel_sendpage() may trigger a kernel panic
> >> from a corrupted kernel heap, because these pages are incorrectly freed
> >> in network stack as page_count 0 pages.
> >>
> >> This patch introduces a helper sendpage_ok(), it returns true if the
> >> checking page,
> >> - is not slab page: PageSlab(page) is false.
> >> - has page refcount: page_count(page) is not zero
> >>
> >> All drivers who want to send page to remote end by kernel_sendpage()
> >> may use this helper to check whether the page is OK. If the helper does
> >> not return true, the driver should try other non sendpage method (e.g.
> >> sock_no_sendpage()) to handle the page.
> >>
> >> Signed-off-by: Coly Li <colyli@suse.de>
> >> Cc: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
> >> Cc: Christoph Hellwig <hch@lst.de>
> >> Cc: Hannes Reinecke <hare@suse.de>
> >> Cc: Jan Kara <jack@suse.com>
> >> Cc: Jens Axboe <axboe@kernel.dk>
> >> Cc: Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>
> >> Cc: Philipp Reisner <philipp.reisner@linbit.com>
> >> Cc: Sagi Grimberg <sagi@grimberg.me>
> >> Cc: Vlastimil Babka <vbabka@suse.com>
> >> Cc: stable@vger.kernel.org
> >> ---
> >>  include/linux/net.h | 16 ++++++++++++++++
> >>  1 file changed, 16 insertions(+)
> >>
> >> diff --git a/include/linux/net.h b/include/linux/net.h
> >> index d48ff1180879..05db8690f67e 100644
> >> --- a/include/linux/net.h
> >> +++ b/include/linux/net.h
> >> @@ -21,6 +21,7 @@
> >>  #include <linux/rcupdate.h>
> >>  #include <linux/once.h>
> >>  #include <linux/fs.h>
> >> +#include <linux/mm.h>
> >>  #include <linux/sockptr.h>
> >>  
> >>  #include <uapi/linux/net.h>
> >> @@ -286,6 +287,21 @@ do {									\
> >>  #define net_get_random_once_wait(buf, nbytes)			\
> >>  	get_random_once_wait((buf), (nbytes))
> >>  
> >> +/*
> >> + * E.g. XFS meta- & log-data is in slab pages, or bcache meta
> >> + * data pages, or other high order pages allocated by
> >> + * __get_free_pages() without __GFP_COMP, which have a page_count
> >> + * of 0 and/or have PageSlab() set. We cannot use send_page for
> >> + * those, as that does get_page(); put_page(); and would cause
> >> + * either a VM_BUG directly, or __page_cache_release a page that
> >> + * would actually still be referenced by someone, leading to some
> >> + * obscure delayed Oops somewhere else.
> >> + */
> >> +static inline bool sendpage_ok(struct page *page)
> >> +{
> >> +	return  !PageSlab(page) && page_count(page) >= 1;
> > 
> > Do you have one extra ' ' after "return" there?
> 
> It should be fixed in next version.
> 
> > 
> > And this feels like a mm thing, why put it in net.h and not mm.h?
> 
> This check is specific for kernel_sendpage(), so I want to place it
> closer to where kernel_sendpage() is declared.
> 
> And indeed there was similar discussion about why this helper is not in
> mm code in v5 series. Christoph supported to place sendpage_ok() in
> net.h, an uncompleted piece of his opinion was "It is not a mm bug, it
> is a networking quirk."

Ah, nevermind then, sorry for the noise :)

greg k-h

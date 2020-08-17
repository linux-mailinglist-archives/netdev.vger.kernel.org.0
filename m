Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56680245C12
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 07:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgHQFpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 01:45:42 -0400
Received: from verein.lst.de ([213.95.11.211]:55031 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726303AbgHQFpm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 01:45:42 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 69E1767357; Mon, 17 Aug 2020 07:45:38 +0200 (CEST)
Date:   Mon, 17 Aug 2020 07:45:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Coly Li <colyli@suse.de>, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Jan Kara <jack@suse.com>, Jens Axboe <axboe@kernel.dk>,
        Mikhail Skorzhinskii <mskorzhinskiy@solarflare.com>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Vlastimil Babka <vbabka@suse.com>
Subject: Re: [PATCH v5 1/3] net: introduce helper sendpage_ok() in
 include/linux/net.h
Message-ID: <20200817054538.GA11705@lst.de>
References: <20200816071518.6964-1-colyli@suse.de> <CAM_iQpUFtZdrhfUbuYYODNeSVqPOqx8mio6Znp6v3Q5iDZeyqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUFtZdrhfUbuYYODNeSVqPOqx8mio6Znp6v3Q5iDZeyqg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 10:55:09AM -0700, Cong Wang wrote:
> On Sun, Aug 16, 2020 at 1:36 AM Coly Li <colyli@suse.de> wrote:
> >
> > The original problem was from nvme-over-tcp code, who mistakenly uses
> > kernel_sendpage() to send pages allocated by __get_free_pages() without
> > __GFP_COMP flag. Such pages don't have refcount (page_count is 0) on
> > tail pages, sending them by kernel_sendpage() may trigger a kernel panic
> > from a corrupted kernel heap, because these pages are incorrectly freed
> > in network stack as page_count 0 pages.
> >
> > This patch introduces a helper sendpage_ok(), it returns true if the
> > checking page,
> > - is not slab page: PageSlab(page) is false.
> > - has page refcount: page_count(page) is not zero
> >
> > All drivers who want to send page to remote end by kernel_sendpage()
> > may use this helper to check whether the page is OK. If the helper does
> > not return true, the driver should try other non sendpage method (e.g.
> > sock_no_sendpage()) to handle the page.
> 
> Can we leave this helper to mm subsystem?
> 
> I know it is for sendpage, but its implementation is all about some
> mm details and its two callers do not belong to net subsystem either.
> 
> Think this in another way: who would fix it if it is buggy? I bet mm people
> should. ;)

No.  This is all about a really unusual imitation in sendpage, which
is pretty much unexpected.  In fact the best thing would be to make
sock_sendpage do the right thing and call sock_no_sendpage based
on this condition, so that driver writers don't have to worry at all.

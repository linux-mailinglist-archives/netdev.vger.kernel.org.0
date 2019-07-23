Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99B93711F3
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 08:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbfGWGfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 02:35:01 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11875 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730554AbfGWGfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 02:35:01 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d36aa920000>; Mon, 22 Jul 2019 23:34:58 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 23:35:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 22 Jul 2019 23:35:00 -0700
Received: from [10.2.160.36] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 06:35:00 +0000
Subject: Re: [PATCH 1/3] mm/gup: introduce __put_user_pages()
To:     Christoph Hellwig <hch@lst.de>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
 <20190722223415.13269-2-jhubbard@nvidia.com> <20190723055359.GC17148@lst.de>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <8ab4899c-ec12-a713-cac2-d951fff2a347@nvidia.com>
Date:   Mon, 22 Jul 2019 23:33:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723055359.GC17148@lst.de>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563863698; bh=MYQG8fRNI4z6ZFJij9qzWoyJeD7sXuD24txEZDtHeVo=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=rtKKKX6s7ujNQbvClnxWqMxjAQN+orwb0XG6bE7MY9CBmVMoLos6YZJhDRHzOwcu7
         MgcwjgXGmxu08uFN3j7xmVuYQfp+YxGQWwPqbSk2XS0jFo6zkI7t0qFXNXXmSLtY3s
         DGCNjuilmS9RDcCRCHUhnaNFu0w5UNnZE0mpdDsgv5muKWSHcc/MN7abz3aSfjB2u5
         qlQsi1M3emKcIzuJhFxTyC574Iqg5IsJdZeBsu4z0jgKJGZ42JrJbgbbwRMmTsSxBC
         Tyyk+jkxxDt8HzFfD/xTR3nVTUPGoNCjGukvHrN0rnk9ywKCisRW6Y45T378RNPzwb
         ZYjYbcdp2Tx7w==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/19 10:53 PM, Christoph Hellwig wrote:
> On Mon, Jul 22, 2019 at 03:34:13PM -0700, john.hubbard@gmail.com wrote:
>> +enum pup_flags_t {
>> +	PUP_FLAGS_CLEAN		= 0,
>> +	PUP_FLAGS_DIRTY		= 1,
>> +	PUP_FLAGS_LOCK		= 2,
>> +	PUP_FLAGS_DIRTY_LOCK	= 3,
>> +};
> 
> Well, the enum defeats the ease of just being able to pass a boolean
> expression to the function, which would simplify a lot of the caller,
> so if we need to support the !locked version I'd rather see that as
> a separate helper.
> 
> But do we actually have callers where not using the _lock version is
> not a bug?  set_page_dirty makes sense in the context of a file systems
> that have a reference to the inode the page hangs off, but that is
> (almost?) never the case for get_user_pages.
> 

I'm seeing about 18 places where set_page_dirty() is used, in the call site
conversions so far, and about 20 places where set_page_dirty_lock() is
used. So without knowing how many of the former (if any) represent bugs,
you can see why the proposal here supports both DIRTY and DIRTY_LOCK.

Anyway, yes, I could change it, based on your estimation that most of the 
set_page_dirty() calls really should be set_page_dirty_lock().
In that case, we would end up with approximately the following:

/* Here, "dirty" really means, "call set_page_dirty_lock()": */
void __put_user_pages(struct page **pages, unsigned long npages,
		      bool dirty);

/* Here, "dirty" really means, "call set_page_dirty()": */
void __put_user_pages_unlocked(struct page **pages, unsigned long npages,
			       bool dirty);

?


thanks,
-- 
John Hubbard
NVIDIA

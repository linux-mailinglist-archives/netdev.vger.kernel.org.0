Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CEB7095B
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbfGVTLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:11:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2390 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfGVTLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 15:11:03 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d360a4c0000>; Mon, 22 Jul 2019 12:11:08 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 22 Jul 2019 12:11:00 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 22 Jul 2019 12:11:00 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 22 Jul
 2019 19:11:00 +0000
Subject: Re: [PATCH 1/3] drivers/gpu/drm/via: convert put_page() to
 put_user_page*()
To:     Matthew Wilcox <willy@infradead.org>
CC:     Christoph Hellwig <hch@lst.de>, <john.hubbard@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, <netdev@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190722043012.22945-1-jhubbard@nvidia.com>
 <20190722043012.22945-2-jhubbard@nvidia.com> <20190722093355.GB29538@lst.de>
 <397ff3e4-e857-037a-1aee-ff6242e024b2@nvidia.com>
 <20190722190722.GF363@bombadil.infradead.org>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <14ac5f41-c27e-c5a7-e16a-4bd3cec0d31f@nvidia.com>
Date:   Mon, 22 Jul 2019 12:10:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190722190722.GF363@bombadil.infradead.org>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563822668; bh=83PVez7k7U0Zqxj86oJddwWoO6j61lIp1H42K6LCjdM=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=D7LBjEJY+k3NOupyUsz3QkjUUcPJWsBWTBbYyETUfk0uHH7d3QLbvQ+9RZH/28ZUE
         sJfBT4O7QJ8wM9JX4nHRXKapNOpAYRi9LOgtrRHvxKHk2NLSGEB1ERlJVKKI3k/JJy
         7S/lE/NB7MHjzQXMBBvvHctHDvo+mZLnO7Aio3aCrObQZB+awPaHKMVSROauRYPr3X
         BJA/hGGdnsjgC4xdOAmvtDqjNiZJqnIwrrWggp9zNKGaVihgNE1edJSfqnrDSygNyO
         Yzm74sohYm7Fi77+N0T5ApyjJHRiN3SgO4JJxNpSypLaSrrE54eHRmL/LyJAWG2MRa
         b+Oe1FCWdve2g==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/19 12:07 PM, Matthew Wilcox wrote:
> On Mon, Jul 22, 2019 at 11:53:54AM -0700, John Hubbard wrote:
>> On 7/22/19 2:33 AM, Christoph Hellwig wrote:
>>> On Sun, Jul 21, 2019 at 09:30:10PM -0700, john.hubbard@gmail.com wrote:
>>>>  		for (i = 0; i < vsg->num_pages; ++i) {
>>>>  			if (NULL != (page = vsg->pages[i])) {
>>>>  				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
>>>> -					SetPageDirty(page);
>>>> -				put_page(page);
>>>> +					put_user_pages_dirty(&page, 1);
>>>> +				else
>>>> +					put_user_page(page);
>>>>  			}
>>>
>>> Can't just pass a dirty argument to put_user_pages?  Also do we really
>>
>> Yes, and in fact that would help a lot more than the single page case,
>> which is really just cosmetic after all.
>>
>>> need a separate put_user_page for the single page case?
>>> put_user_pages_dirty?
>>
>> Not really. I'm still zeroing in on the ideal API for all these call sites,
>> and I agree that the approach below is cleaner.
> 
> so enum { CLEAN = 0, DIRTY = 1, LOCK = 2, DIRTY_LOCK = 3 };
> ?
> 

Sure. In fact, I just applied something similar to bio_release_pages()
locally, in order to reconcile Christoph's and Jerome's approaches 
(they each needed to add a bool arg), so I'm all about the enums in the
arg lists. :)

I'm going to post that one shortly, let's see how it goes over. heh.

thanks,
-- 
John Hubbard
NVIDIA

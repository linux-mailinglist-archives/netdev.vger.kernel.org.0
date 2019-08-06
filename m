Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62B8A83A88
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 22:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfHFUnq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 16:43:46 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:12036 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbfHFUnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 16:43:45 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d49e6890000>; Tue, 06 Aug 2019 13:43:53 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 06 Aug 2019 13:43:43 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 06 Aug 2019 13:43:43 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 6 Aug
 2019 20:43:43 +0000
Subject: Re: [PATCH v6 1/3] mm/gup: add make_dirty arg to
 put_user_pages_dirty_lock()
To:     Ira Weiny <ira.weiny@intel.com>, <john.hubbard@gmail.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
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
References: <20190804214042.4564-1-jhubbard@nvidia.com>
 <20190804214042.4564-2-jhubbard@nvidia.com>
 <20190806174017.GB4748@iweiny-DESK2.sc.intel.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <662e3f1e-b63e-ce80-274b-cb407bce6f78@nvidia.com>
Date:   Tue, 6 Aug 2019 13:43:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190806174017.GB4748@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL104.nvidia.com (172.18.146.11) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1565124233; bh=69F2w6W//D6RGOmiznV0xApH922IMQ0bjLWukK3Y3fM=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=ap4Gh4eAjhabzOCGXg03MlGS3E39LbT2CXYDFUwj2rPlbF7hC6RWG9GhsJ2iB7VW/
         iYlQoSLezyw7mHlxXl/fKIiZ8rXughCfKjTKN4/Z6IMCoXcHiVjqfWI1NEleGSaZ1D
         nb/98DcL6LZnWfzY2lODnRbMeV4rL6NENctX00s/9WgBVnL9OMB/MDykHOE9G7K2wL
         YOLJ7T/SYKJKGHtGsae2JANuXCcr7t7WsPen/yG+U/cLlENdGZ/NhUeRG2cxaPNVG0
         iSR9G6EBnJbeu0s0AK9qSs5J/PxhKEARuOdUaS2rM7tLFwOLC4PrmECrXiOHXA9ve3
         yBfnp2wxB5hBA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/6/19 10:40 AM, Ira Weiny wrote:
> On Sun, Aug 04, 2019 at 02:40:40PM -0700, john.hubbard@gmail.com wrote:
>> From: John Hubbard <jhubbard@nvidia.com>
>>
>> Provide a more capable variation of put_user_pages_dirty_lock(),
>> and delete put_user_pages_dirty(). This is based on the
>> following:
>>
>> 1. Lots of call sites become simpler if a bool is passed
>> into put_user_page*(), instead of making the call site
>> choose which put_user_page*() variant to call.
>>
>> 2. Christoph Hellwig's observation that set_page_dirty_lock()
>> is usually correct, and set_page_dirty() is usually a
>> bug, or at least questionable, within a put_user_page*()
>> calling chain.
>>
>> This leads to the following API choices:
>>
>>     * put_user_pages_dirty_lock(page, npages, make_dirty)
>>
>>     * There is no put_user_pages_dirty(). You have to
>>       hand code that, in the rare case that it's
>>       required.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Cc: Matthew Wilcox <willy@infradead.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Ira Weiny <ira.weiny@intel.com>
>> Cc: Jason Gunthorpe <jgg@ziepe.ca>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> 
> I assume this is superseded by the patch in the large series?
> 

Actually, it's the other way around (there is a note that that effect
in the admittedly wall-of-text cover letter [1] in the 34-patch series.

However, I'm trying hard to ensure that it doesn't actually matter:

* Patch 1 in the latest of each patch series, is identical

* I'm reposting the two series together.

...and yes, it might have been better to merge the two patchsets, but
the smaller one is more reviewable. And as a result, Andrew has already
merged it into the akpm tree.


[1] https://lore.kernel.org/r/20190804224915.28669-1-jhubbard@nvidia.com

thanks,
-- 
John Hubbard
NVIDIA

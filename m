Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA5A1722F2
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 01:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbfGWXY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 19:24:26 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19509 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbfGWXYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 19:24:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5d3797290000>; Tue, 23 Jul 2019 16:24:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 23 Jul 2019 16:24:24 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 23 Jul 2019 16:24:24 -0700
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 23 Jul
 2019 23:24:24 +0000
Subject: Re: [PATCH 3/3] net/xdp: convert put_page() to put_user_page*()
To:     Ira Weiny <ira.weiny@intel.com>
CC:     <john.hubbard@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
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
References: <20190722223415.13269-1-jhubbard@nvidia.com>
 <20190722223415.13269-4-jhubbard@nvidia.com>
 <20190723002534.GA10284@iweiny-DESK2.sc.intel.com>
 <a4e9b293-11f8-6b3c-cf4d-308e3b32df34@nvidia.com>
 <20190723180612.GB29729@iweiny-DESK2.sc.intel.com>
X-Nvconfidentiality: public
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <69540e85-b527-0252-7b29-8932660af72d@nvidia.com>
Date:   Tue, 23 Jul 2019 16:24:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723180612.GB29729@iweiny-DESK2.sc.intel.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1563924265; bh=Dc+54X4TKuVoIQ6IGOnhUFUhE0Dy4dW4jkSZ2LHVHns=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FMl+YlnDhGCsZKKh1L0ErV+31siNAXGqpbM4Ti099eQ263WNqONoZoDhA6w28dloW
         DANKq7E2Y7kdWPUACeMGcsz7IGCwEWqiwPgDnX3E9DHqqaxxYj9TrmIKWYGcLWA8z9
         HaYbTpYicIHv06kxhQ58/gdGYse2x3h25DFKRTKYtQq+80JPY4IzGMpBTYSaFvHkoA
         7F9/p/2HEcQ7syxo9toMK0sf5uUtUlNauO/KxNX+D2TkcJKNWZP3//+ZXgl5mcNywg
         K1EWHc3E5G7xnnEUtcQBaKfZD5VJFBdwU+bLpLJtcvUt/rKIgSGElbmpHYwBZFPLKu
         YnW6V/fpJl4Ag==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 11:06 AM, Ira Weiny wrote:
> On Mon, Jul 22, 2019 at 09:41:34PM -0700, John Hubbard wrote:
>> On 7/22/19 5:25 PM, Ira Weiny wrote:
>>> On Mon, Jul 22, 2019 at 03:34:15PM -0700, john.hubbard@gmail.com wrote:
...
>> Obviously, this stuff is all subject to a certain amount of opinion, but I
>> think I'm on really solid ground as far as precedent goes. So I'm pushing
>> back on the NAK... :)
> 
> Fair enough...  However, we have discussed in the past how GUP can be a
> confusing interface to use.
> 
> So I'd like to see it be more directed.  Only using the __put_user_pages()
> version allows us to ID callers easier through a grep of PUP_FLAGS_DIRTY_LOCK
> in addition to directing users to use that interface rather than having to read
> the GUP code to figure out that the 2 calls above are equal.  It is not a huge
> deal but...
> 

OK, combining all the feedback to date, which is:

* the leading double underscore is unloved,

* set_page_dirty() is under investigation, but likely guilty of incitement
  to cause bugs,


...we end up with this:

void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
			       bool make_dirty)

...which I have a v2 patchset for, ready to send out. It makes IB all pretty 
too. :)


thanks,
-- 
John Hubbard
NVIDIA

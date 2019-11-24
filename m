Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B492108255
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:15:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKXGPH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:15:07 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6579 "EHLO
        hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbfKXGPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:15:06 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate16.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dda1fe40000>; Sat, 23 Nov 2019 22:15:00 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Sat, 23 Nov 2019 22:14:59 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Sat, 23 Nov 2019 22:14:59 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sun, 24 Nov
 2019 06:14:58 +0000
Subject: Re: [PATCH v7 07/24] IB/umem: use get_user_pages_fast() to pin DMA
 pages
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Christoph Hellwig <hch@infradead.org>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-8-jhubbard@nvidia.com>
 <20191121080746.GC30991@infradead.org> <20191121143643.GC7448@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <17835638-d584-f981-faa3-34d57e0990de@nvidia.com>
Date:   Sat, 23 Nov 2019 22:14:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121143643.GC7448@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574576100; bh=+mbCPa34GHo19rkSZ8X28MZHFxfKXj0JDCmoAoUgPhA=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=Lxyt3fX3SLobwlYOgojx5q/tcPHCRvrfdyk3qwBay6+crwzq9cmBDOL2v1A93d2/F
         znbsTdahsKcfBLC3ExDVRiR4xyNb8wuF+IY4tVg2BRT+CWxuHL+tde5mqs3Sjaqc2H
         pQhchVsKtIHXazVW0nKuBUtZ85yMnPL1fDCuL8YyEbTuF/FrqtWCNE9nir7lTMKyjf
         tlQWOABZBTB1lSxY5uwVrlwTat+xx62yAomSXn+CUgkL0jIrOlvTsDh31691ux/R3U
         ne8BFF7YaXlkXhz8ZhdLSUDwwh/yLz0H7gzsTDkDINVi3pBPVt9mKwVrX7BgK6Om2D
         P0YwnWGSjqBhw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 6:36 AM, Jason Gunthorpe wrote:
> On Thu, Nov 21, 2019 at 12:07:46AM -0800, Christoph Hellwig wrote:
>> On Wed, Nov 20, 2019 at 11:13:37PM -0800, John Hubbard wrote:
>>> And get rid of the mmap_sem calls, as part of that. Note
>>> that get_user_pages_fast() will, if necessary, fall back to
>>> __gup_longterm_unlocked(), which takes the mmap_sem as needed.
>>>
>>> Reviewed-by: Jan Kara <jack@suse.cz>
>>> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
>>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>>
>> Looks fine,
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>
>> Jason, can you queue this up for 5.5 to reduce this patch stack a bit?
> 
> Yes, I said I'd do this in an earlier revision. Now that it is clear this
> won't go through Andrew's tree, applied to rdma for-next
> 

Great, I'll plan on it going up through that tree. To be clear, is it headed 
for:

    git://git.kernel.org/pub/scm/linux/kernel/git/rdma/rdma.git for-next

?


thanks,
-- 
John Hubbard
NVIDIA

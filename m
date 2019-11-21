Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB350105C53
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfKUVwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:52:32 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12745 "EHLO
        hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbfKUVwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:52:31 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate14.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dd707210000>; Thu, 21 Nov 2019 13:52:33 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 21 Nov 2019 13:52:30 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 21 Nov 2019 13:52:30 -0800
Received: from [10.2.168.213] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 21 Nov
 2019 21:52:28 +0000
Subject: Re: [PATCH v7 09/24] vfio, mm: fix get_user_pages_remote() and
 FOLL_LONGTERM
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgg@mellanox.com>
References: <20191121071354.456618-1-jhubbard@nvidia.com>
 <20191121071354.456618-10-jhubbard@nvidia.com>
 <20191121143525.50deb72f@x1.home>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <b5ae788a-58a9-de93-f65e-e4d9c0632dc9@nvidia.com>
Date:   Thu, 21 Nov 2019 13:49:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191121143525.50deb72f@x1.home>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574373153; bh=oGhbv3cXo8o4GZ8PnxP5Ux4y8AE3jGJR4EeVDVjoVEc=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=KYGZRjKvtxip9P6ifb3Te8PpgvFSTRruWhwxOgXb0S114oVSZskeO+iOWdCneQvB4
         NA5CKwViDqqMCzmcEtuXOzx5kWlGm/CdhdbD7x7k9Kx6Vh5kQFWAggEn8hm5nSetjo
         GsuEs2bguAasb3kn7+569g/s+OYwxg2N/laFgRqUcYIkUaXO+dKZ1vX7QBvKE7iuhN
         xdX8E7mSGSvk8taZzTl3l1tHACe5K5QgYBxfNvJAXLPet5p3Tx/OKYiHGukBzXFPA8
         pg/kE+aDZRuWuc8KSGeIQ8zVRFi/6q/Cd2RICjjhHLzCf4ZbZMZG9XJoZELTlTOned
         7+K+fSUD3HTWw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/19 1:35 PM, Alex Williamson wrote:
> On Wed, 20 Nov 2019 23:13:39 -0800
> John Hubbard <jhubbard@nvidia.com> wrote:
> 
>> As it says in the updated comment in gup.c: current FOLL_LONGTERM
>> behavior is incompatible with FAULT_FLAG_ALLOW_RETRY because of the
>> FS DAX check requirement on vmas.
>>
>> However, the corresponding restriction in get_user_pages_remote() was
>> slightly stricter than is actually required: it forbade all
>> FOLL_LONGTERM callers, but we can actually allow FOLL_LONGTERM callers
>> that do not set the "locked" arg.
>>
>> Update the code and comments accordingly, and update the VFIO caller
>> to take advantage of this, fixing a bug as a result: the VFIO caller
>> is logically a FOLL_LONGTERM user.
>>
>> Also, remove an unnessary pair of calls that were releasing and
>> reacquiring the mmap_sem. There is no need to avoid holding mmap_sem
>> just in order to call page_to_pfn().
>>
>> Also, move the DAX check ("if a VMA is DAX, don't allow long term
>> pinning") from the VFIO call site, all the way into the internals
>> of get_user_pages_remote() and __gup_longterm_locked(). That is:
>> get_user_pages_remote() calls __gup_longterm_locked(), which in turn
>> calls check_dax_vmas(). It's lightly explained in the comments as well.
>>
>> Thanks to Jason Gunthorpe for pointing out a clean way to fix this,
>> and to Dan Williams for helping clarify the DAX refactoring.
>>
>> Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
>> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
>> Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Jerome Glisse <jglisse@redhat.com>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
>> ---
>>   drivers/vfio/vfio_iommu_type1.c | 30 +++++-------------------------
>>   mm/gup.c                        | 27 ++++++++++++++++++++++-----
>>   2 files changed, 27 insertions(+), 30 deletions(-)
> 
> Tested with device assignment and Intel mdev vGPU assignment with QEMU
> userspace:
> 
> Tested-by: Alex Williamson <alex.williamson@redhat.com>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> Feel free to include for 19/24 as well.  Thanks,
> 
> Alex


Great! Thanks for the testing and ack on those. I'm about to repackage
(and split up as CH requested) for 5.5, and will keep you on CC, of course.

thanks,
-- 
John Hubbard
NVIDIA

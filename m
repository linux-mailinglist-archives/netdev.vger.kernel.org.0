Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D058EEAA1
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 21:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729629AbfKDU6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 15:58:07 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:8498 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbfKDU6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 15:58:06 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc090dd0000>; Mon, 04 Nov 2019 12:58:05 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Mon, 04 Nov 2019 12:58:00 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Mon, 04 Nov 2019 12:58:00 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 4 Nov
 2019 20:57:59 +0000
Subject: Re: [PATCH v2 05/18] mm/gup: introduce pin_user_pages*() and FOLL_PIN
To:     Jason Gunthorpe <jgg@ziepe.ca>, Jerome Glisse <jglisse@redhat.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
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
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-6-jhubbard@nvidia.com>
 <20191104173325.GD5134@redhat.com>
 <be9de35c-57e9-75c3-2e86-eae50904bbdf@nvidia.com>
 <20191104191811.GI5134@redhat.com>
 <e9656d47-b4a1-da8a-e8cc-ebcfb8cc06d6@nvidia.com>
 <20191104195248.GA7731@redhat.com>
 <25ec4bc0-caaa-2a01-2ae7-2d79663a40e1@nvidia.com>
 <20191104203153.GB7731@redhat.com> <20191104203702.GG30938@ziepe.ca>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <d0890a8b-c349-0515-2570-10e83979836b@nvidia.com>
Date:   Mon, 4 Nov 2019 12:57:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191104203702.GG30938@ziepe.ca>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1572901085; bh=EeK8bqsNfSA5i7MZV/85JI1lVmfCUv+TJ9yPJIg8GiI=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=lpq+hNDuPjPGBUnT+FF2AdBK4cieUl5iRoSXMbtLj+P8mC+Low0gZFUsCOCxgU9/5
         DdN9/T6chOJfP5oOBc8usBmdwuRtBNEQH4F7VlCn14TGG0/SlwreoVfvdvj6xqa7/3
         xeHneHSfMu5jFDq4HQuon77rSHBRD8GfWw0oGJaIFrobzmVoV/9zRJnxBAubrZjXN1
         WRTqAeLXVE2rRthei7hHQyxBdSu2WAGq/7R/BGkZOAo7GutRRc+/9GEeCURW6eoDae
         GFMlg2H2OK77XEEdt9PJrYvhIFYSBbOCAEQEdwBZOgkHGbaoMuenGmkX8oXc5haoCl
         DibI+5WsHAIGw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/19 12:37 PM, Jason Gunthorpe wrote:
> On Mon, Nov 04, 2019 at 03:31:53PM -0500, Jerome Glisse wrote:
>>> Note for Jason: the (a) or (b) items are talking about the vfio case, which is
>>> one of the two call sites that now use pin_longterm_pages_remote(), and the
>>> other one is infiniband:
>>>
>>> drivers/infiniband/core/umem_odp.c:646:         npages = pin_longterm_pages_remote(owning_process, owning_mm,
>>> drivers/vfio/vfio_iommu_type1.c:353:            ret = pin_longterm_pages_remote(NULL, mm, vaddr, 1,
>>
>> vfio should be reverted until it can be properly implemented.
>> The issue is that when you fix the implementation you might
>> break vfio existing user and thus regress the kernel from user
>> point of view. So i rather have the change to vfio reverted,
>> i believe it was not well understood when it got upstream,
>> between in my 5.4 tree it is still gup_remote not longterm.
> 
> It is clearly a bug, vfio must use LONGTERM, and does right above this
> remote call:
> 
>         if (mm == current->mm) {
>                 ret = get_user_pages(vaddr, 1, flags | FOLL_LONGTERM, page,
>                                      vmas);
>         } else {
>                 ret = get_user_pages_remote(NULL, mm, vaddr, 1, flags, page,
>                                             vmas, NULL);
> 
> 
> I'm not even sure that it really makes any sense to build a 'if' like
> that, surely just always call remote??
> 


Right, and I thought about this when converting, and realized that the above 
code is working around the current gup.c limitations, which are "cannot support
gup remote with FOLL_LONGTERM".

Given that observation, the code is getting itself some FOLL_LONGTERM support
for the non-remote case, and only hitting the limitation if the mm really is
non-current.

And if you look at my patch, it keeps the same behavior, while adding in the
new wrapper calls.

So...thoughts, preferences?


thanks,

John Hubbard
NVIDIA

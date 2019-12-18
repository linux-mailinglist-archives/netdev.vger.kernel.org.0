Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D671125673
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfLRWSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:18:37 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:8890 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfLRWSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:18:36 -0500
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dfaa5ad0000>; Wed, 18 Dec 2019 14:18:21 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Wed, 18 Dec 2019 14:18:31 -0800
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Wed, 18 Dec 2019 14:18:31 -0800
Received: from [10.2.165.11] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 18 Dec
 2019 22:18:30 +0000
Subject: Re: [PATCH v11 06/25] mm: fix get_user_pages_remote()'s handling of
 FOLL_LONGTERM
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
References: <20191216222537.491123-1-jhubbard@nvidia.com>
 <20191216222537.491123-7-jhubbard@nvidia.com>
 <20191218161907.yczbijr3ngm7wwnj@box>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <c8d746ff-f544-6c9f-110b-215514fb4b5c@nvidia.com>
Date:   Wed, 18 Dec 2019 14:15:40 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218161907.yczbijr3ngm7wwnj@box>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1576707501; bh=sxjwJVdMWX10qxIPxn4THVxS9SYzoQiX2+nIJ9/LG7I=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UZ8jBMwY32NgWwiJjZwTAPW3ja6CuPOAfe4SpG+9/CDwknPqX5qccd7q+WCVa0kre
         Av1FM/rgDWBJQowSF6blVYewBi40/EoGKov0KLTmsD25hxZXVoFAuUTjqD9AjunTuW
         zOw8acZ6PbPZg9ggfzbvjmuiESVGaX+/zsYCSMAQZrWJGMuf5ikxNna4ygsE1Jk8cJ
         dHbTfbTsY5cfH+d0VRIX71N/Dllb+k91MxmporXWGxV5JQ3DVwfnyQEVBsHmZwuyup
         I9epWsR1kc8VLnGg3SRALlsRj1gICz0/x78ascTmPUjlda17XHeoBT+12qtVoXpcGN
         AwPIbnNqxY2bw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/18/19 8:19 AM, Kirill A. Shutemov wrote:
...
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 3ecce297a47f..c0c56888e7cc 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -29,6 +29,13 @@ struct follow_page_context {
>>   	unsigned int page_mask;
>>   };
>>   
>> +static __always_inline long __gup_longterm_locked(struct task_struct *tsk,
>> +						  struct mm_struct *mm,
>> +						  unsigned long start,
>> +						  unsigned long nr_pages,
>> +						  struct page **pages,
>> +						  struct vm_area_struct **vmas,
>> +						  unsigned int flags);
> 
> Any particular reason for the forward declaration? Maybe move
> get_user_pages_remote() down?
> 

Yes, that's exactly why: I was thinking it would be cleaner to put in the
forward declaration, rather than moving code blocks, but either way seems
reasonable. I'll go ahead and move the code blocks and delete the forward
declaration, now that someone has weighed in in favor of that.

thanks,
-- 
John Hubbard
NVIDIA

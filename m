Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF9F8277
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 22:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfKKVqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 16:46:22 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:9442 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727121AbfKKVqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 16:46:20 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5dc9d66d0000>; Mon, 11 Nov 2019 13:45:17 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 11 Nov 2019 13:46:18 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 11 Nov 2019 13:46:18 -0800
Received: from [10.110.48.28] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 11 Nov
 2019 21:46:18 +0000
Subject: Re: [PATCH v2 04/18] media/v4l2-core: set pages dirty upon releasing
 DMA buffers
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
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
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
References: <20191103211813.213227-1-jhubbard@nvidia.com>
 <20191103211813.213227-5-jhubbard@nvidia.com>
 <4b2337f6-102d-ae9d-e690-4331d77660c4@xs4all.nl>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <5846f15d-f03b-cd1a-051c-42b1519c4c48@nvidia.com>
Date:   Mon, 11 Nov 2019 13:46:18 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4b2337f6-102d-ae9d-e690-4331d77660c4@xs4all.nl>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1573508717; bh=JgFNDA0v0XtnqpGBZO9zS12edBVCSHH4nhh2s8SsfW8=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=KJdHonRoY4lGZsGGXFA+s6C9dAs+F+pw/0M4pYcPJTv8UjN4AOAtOKwCMIML32E4J
         r1oa+qdIiwIStrqpxJM1Ivl0+B4WzoS3hMuEMwbOHFQnWENnyAiOG7rxglRiMPOsG2
         P1hEnkWRlMLt+KFRHY1ADSR7l9DzNOzOUd8zjn8ytb8H6XjFU3HR0TMaYulAaIN8Ej
         W15iUuEbFCS+gYNQ7bbS2hBGFlr0gEiNZEHH94kd699lxQXaw52Pbe2bTEp8/kn2Gi
         RR0P48w8xGu3BkU/HHy5EhGqoz+wSP++cOtfAjoHUddj6CK5tYXuhTndLB24+KM9Al
         oii/NsVBT+BQA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/19 2:10 AM, Hans Verkuil wrote:
> On 11/3/19 10:17 PM, John Hubbard wrote:
>> After DMA is complete, and the device and CPU caches are synchronized,
>> it's still required to mark the CPU pages as dirty, if the data was
>> coming from the device. However, this driver was just issuing a
>> bare put_page() call, without any set_page_dirty*() call.
>>
>> Fix the problem, by calling set_page_dirty_lock() if the CPU pages
>> were potentially receiving data from the device.
>>
>> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
>> Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> 
> Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> 
> Looks good, thanks!
> 

Hi Hans, it's great that you could take a look at this and the other v4l2 
patch, much appreciated.


thanks,
-- 
John Hubbard
NVIDIA
>> ---
>>  drivers/media/v4l2-core/videobuf-dma-sg.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
>> index 66a6c6c236a7..28262190c3ab 100644
>> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
>> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
>> @@ -349,8 +349,11 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>>  	BUG_ON(dma->sglen);
>>  
>>  	if (dma->pages) {
>> -		for (i = 0; i < dma->nr_pages; i++)
>> +		for (i = 0; i < dma->nr_pages; i++) {
>> +			if (dma->direction == DMA_FROM_DEVICE)
>> +				set_page_dirty_lock(dma->pages[i]);
>>  			put_page(dma->pages[i]);
>> +		}
>>  		kfree(dma->pages);
>>  		dma->pages = NULL;
>>  	}
>>
> 

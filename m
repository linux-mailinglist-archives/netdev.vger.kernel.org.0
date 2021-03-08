Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB50330649
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 04:18:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhCHDSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 22:18:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233716AbhCHDRb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 22:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615173450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lncFpbesf3+Cf0X7NC13aXAoRjJq1HSTiKB3om5hTS8=;
        b=Xt81nN/sfq0ceLpPB6nZcNLvKPJf12djR7VbPt/Bjm8q+yXatEg3bsjTSIPgNRyD9D6RgZ
        9uGBBK4sikHNhNXO6hT9673gDUKj+Rs8gS6L08oPVMUMfRpHZTwkML+4BqiND5Mi6aaEMM
        23HrFsMyRaU0d3gmTi27B+m1n+yDK8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-LK-aPUdXMEO8cZ6cb1sLtg-1; Sun, 07 Mar 2021 22:17:26 -0500
X-MC-Unique: LK-aPUdXMEO8cZ6cb1sLtg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5B80857;
        Mon,  8 Mar 2021 03:17:24 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-193.pek2.redhat.com [10.72.13.193])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 719CA5C5FC;
        Mon,  8 Mar 2021 03:17:10 +0000 (UTC)
Subject: Re: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com>
 <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com>
 <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
 <4db35f8c-ee3a-90fb-8d14-5d6014b4f6fa@redhat.com>
 <CACycT3sUJNmi2BdLsi3W72+qTKQaCo_nQYu-fdxg9y4pAvBMow@mail.gmail.com>
 <2652f696-faf7-26eb-a8b2-c4cfe3aaed15@redhat.com>
 <CACycT3uMV9wg5yVKmEJpbZrs3x0b4+b9eNcUTh3+CjxsG7x2LA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d4681614-bd1e-8fe7-3b03-72eb2011c3c2@redhat.com>
Date:   Mon, 8 Mar 2021 11:17:08 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3uMV9wg5yVKmEJpbZrs3x0b4+b9eNcUTh3+CjxsG7x2LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 3:59 下午, Yongji Xie wrote:
> On Fri, Mar 5, 2021 at 3:27 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/3/5 3:13 下午, Yongji Xie wrote:
>>> On Fri, Mar 5, 2021 at 2:52 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/3/5 2:15 下午, Yongji Xie wrote:
>>>>
>>>> Sorry if I've asked this before.
>>>>
>>>> But what's the reason for maintaing a dedicated IOTLB here? I think we
>>>> could reuse vduse_dev->iommu since the device can not be used by both
>>>> virtio and vhost in the same time or use vduse_iova_domain->iotlb for
>>>> set_map().
>>>>
>>>> The main difference between domain->iotlb and dev->iotlb is the way to
>>>> deal with bounce buffer. In the domain->iotlb case, bounce buffer
>>>> needs to be mapped each DMA transfer because we need to get the bounce
>>>> pages by an IOVA during DMA unmapping. In the dev->iotlb case, bounce
>>>> buffer only needs to be mapped once during initialization, which will
>>>> be used to tell userspace how to do mmap().
>>>>
>>>> Also, since vhost IOTLB support per mapping token (opauqe), can we use
>>>> that instead of the bounce_pages *?
>>>>
>>>> Sorry, I didn't get you here. Which value do you mean to store in the
>>>> opaque pointer？
>>>>
>>>> So I would like to have a way to use a single IOTLB for manage all kinds
>>>> of mappings. Two possible ideas:
>>>>
>>>> 1) map bounce page one by one in vduse_dev_map_page(), in
>>>> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd. Then
>>>> for bounce pages, userspace still only need to map it once and we can
>>>> maintain the actual mapping by storing the page or pa in the opaque
>>>> field of IOTLB entry.
>>>>
>>>> Looks like userspace still needs to unmap the old region and map a new
>>>> region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD ioctl.
>>>>
>>>>
>>>> I don't get here. Can you give an example?
>>>>
>>> For example, userspace needs to process two I/O requests (one page per
>>> request). To process the first request, userspace uses
>>> VDUSE_IOTLB_GET_FD ioctl to query the iova region (0 ~ 4096) and mmap
>>> it.
>>
>> I think in this case we should let VDUSE_IOTLB_GET_FD return the maximum
>> range as far as they are backed by the same fd.
>>
> But now the bounce page is mapped one by one. The second page (4096 ~
> 8192) might not be mapped when userspace is processing the first
> request. So the maximum range is 0 ~ 4096 at that time.
>
> Thanks,
> Yongji


A question, if I read the code correctly, VDUSE_IOTLB_GET_FD will return 
the whole bounce map range which is setup in vduse_dev_map_page()? So my 
understanding is that usersapce may choose to map all its range via mmap().

So if we 'map' bounce page one by one in vduse_dev_map_page(). (Here 
'map' means using multiple itree entries instead of a single one). Then 
in the VDUSE_IOTLB_GET_FD we can keep traversing itree (dev->iommu) 
until the range is backed by a different file.

With this, there's no userspace visible changes and there's no need for 
the domain->iotlb?

Thanks


>


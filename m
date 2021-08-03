Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A543E3DEB50
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 12:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbhHCKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 06:54:39 -0400
Received: from foss.arm.com ([217.140.110.172]:47244 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234904AbhHCKyh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 06:54:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 237041396;
        Tue,  3 Aug 2021 03:54:26 -0700 (PDT)
Received: from [10.57.36.146] (unknown [10.57.36.146])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 805143F40C;
        Tue,  3 Aug 2021 03:54:22 -0700 (PDT)
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Yongji Xie <xieyongji@bytedance.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, Joe Perches <joe@perches.com>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
References: <20210729073503.187-1-xieyongji@bytedance.com>
 <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com>
 <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com>
Date:   Tue, 3 Aug 2021 11:53:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-03 09:54, Yongji Xie wrote:
> On Tue, Aug 3, 2021 at 3:41 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>>
>> 在 2021/7/29 下午3:34, Xie Yongji 写道:
>>> Export alloc_iova_fast() and free_iova_fast() so that
>>> some modules can use it to improve iova allocation efficiency.
>>
>>
>> It's better to explain why alloc_iova() is not sufficient here.
>>
> 
> Fine.

What I fail to understand from the later patches is what the IOVA domain 
actually represents. If the "device" is a userspace process then 
logically the "IOVA" would be the userspace address, so presumably 
somewhere you're having to translate between this arbitrary address 
space and actual usable addresses - if you're worried about efficiency 
surely it would be even better to not do that?

Presumably userspace doesn't have any concern about alignment and the 
things we have to worry about for the DMA API in general, so it's pretty 
much just allocating slots in a buffer, and there are far more effective 
ways to do that than a full-blown address space manager. If you're going 
to reuse any infrastructure I'd have expected it to be SWIOTLB rather 
than the IOVA allocator. Because, y'know, you're *literally implementing 
a software I/O TLB* ;)

Robin.

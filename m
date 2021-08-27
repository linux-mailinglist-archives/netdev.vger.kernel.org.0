Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5D03F9693
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 10:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244692AbhH0JAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 05:00:07 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3694 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbhH0JAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 05:00:06 -0400
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GwtsC5YsXz67RyC;
        Fri, 27 Aug 2021 16:57:51 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 27 Aug 2021 10:59:16 +0200
Received: from [10.47.92.37] (10.47.92.37) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.8; Fri, 27 Aug
 2021 09:59:14 +0100
Subject: Re: [PATCH v11 01/12] iova: Export alloc_iova_fast() and
 free_iova_fast()
To:     Yongji Xie <xieyongji@bytedance.com>
CC:     Will Deacon <will@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm <kvm@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Matthew Wilcox" <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        <linux-fsdevel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "Stefan Hajnoczi" <stefanha@redhat.com>,
        <songmuchun@bytedance.com>, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <iommu@lists.linux-foundation.org>, <bcrl@kvack.org>,
        <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        =?UTF-8?Q?Mika_Penttil=c3=a4?= <mika.penttila@nextfour.com>
References: <20210818120642.165-1-xieyongji@bytedance.com>
 <20210818120642.165-2-xieyongji@bytedance.com>
 <20210824140758-mutt-send-email-mst@kernel.org>
 <20210825095540.GA24546@willie-the-truck>
 <5f4eadda-5500-9bac-4368-48cfca6d0a4d@huawei.com>
 <CACycT3uWyhNNK_YbfEAEhTk-V9CoxFg1tzVjJnXeKBFpkndnfg@mail.gmail.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <d7b5967f-0a43-785a-82b0-74cce5993ba0@huawei.com>
Date:   Fri, 27 Aug 2021 10:03:03 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CACycT3uWyhNNK_YbfEAEhTk-V9CoxFg1tzVjJnXeKBFpkndnfg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.92.37]
X-ClientProxiedBy: lhreml706-chm.china.huawei.com (10.201.108.55) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/08/2021 13:17, Yongji Xie wrote:
>> JFYI, There was a preliminary discussion to move the iova rcache code
>> (which the iova fast alloc and free functions are based on) out of the
>> iova code and maybe into dma-iommu (being the only user). There was
>> other motivation.
>>
> Would it be better to move the code into ./lib as a general library?

For a start we/I think that the rcache could be removed from the IOVA 
code, but prob should stay in drivers/iommu. I had another IOVA issue to 
solve, which complicates things. No solid plans. Need to talk to Robin more.

> 
>> https://lore.kernel.org/linux-iommu/83de3911-145d-77c8-17c1-981e4ff825d3@arm.com/
>>
>> Having more users complicates that...
>>
> Do we have some plan for this work? From our test [1],
> iova_alloc_fast() is much better than iova_alloc(). So I'd like to use
> it as much as possible
> 
> [1]https://lore.kernel.org/kvm/CACycT3steXFeg7NRbWpo2J59dpYcumzcvM2zcPJAVe40-EvvEg@mail.gmail.com/

Well if you're alloc'ing and free'ing IOVAs a lot then I can imagine it is.

Thanks,
John

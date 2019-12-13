Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 387FF11DE58
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 07:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725890AbfLMGxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 01:53:43 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:37208 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfLMGxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 01:53:43 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 72DC6644FC45965F575A;
        Fri, 13 Dec 2019 14:53:40 +0800 (CST)
Received: from [127.0.0.1] (10.74.191.121) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 13 Dec 2019
 14:53:37 +0800
Subject: =?UTF-8?Q?Re:_=e7=ad=94=e5=a4=8d:_[PATCH][v2]_page=5fpool:_handle_p?=
 =?UTF-8?Q?age_recycle_for_NUMA=5fNO=5fNODE_condition?=
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
References: <1575624767-3343-1-git-send-email-lirongqing@baidu.com>
 <9fecbff3518d311ec7c3aee9ae0315a73682a4af.camel@mellanox.com>
 <20191211194933.15b53c11@carbon>
 <831ed886842c894f7b2ffe83fe34705180a86b3b.camel@mellanox.com>
 <0a252066-fdc3-a81d-7a36-8f49d2babc01@huawei.com>
 <20191212111831.2a9f05d3@carbon>
 <7c555cb1-6beb-240d-08f8-7044b9087fe4@huawei.com>
 <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <079a0315-efea-9221-8538-47decf263684@huawei.com>
Date:   Fri, 13 Dec 2019 14:53:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1d4f10f4c0f1433bae658df8972a904f@baidu.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/13 14:27, Li,Rongqing wrote:
>>
>> It is good to allocate the rx page close to both cpu and device, but if
>> both goal can not be reached, maybe we choose to allocate page that close
>> to cpu?
>>
> I think it is true
> 
> If it is true, , we can remove pool->p.nid, and replace alloc_pages_node with
> alloc_pages in __page_pool_alloc_pages_slow, and change pool_page_reusable as
> that page_to_nid(page) is checked with numa_mem_id()  
> 
> since alloc_pages hint to use the current node page, and __page_pool_alloc_pages_slow 
> will be called in NAPI polling often if recycle failed, after some cycle, the page will be from
> local memory node.

Yes if allocation and recycling are in the same NAPI polling context.

As pointed out by Saeed and Ilias, the allocation and recycling seems to
may not be happening in the same NAPI polling context, see:

"In the current code base if they are only called under NAPI this might be true.
On the page_pool skb recycling patches though (yes we'll eventually send those
:)) this is called from kfree_skb()."

So there may need some additionl attention.


> 
> -Li
> 


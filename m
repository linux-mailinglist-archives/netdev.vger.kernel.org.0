Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1264E3CB0CC
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 04:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhGPCdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 22:33:35 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6941 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233114AbhGPCde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 22:33:34 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQw9b2HJ9z7vNh;
        Fri, 16 Jul 2021 10:26:59 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 16 Jul 2021 10:30:34 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Fri, 16 Jul
 2021 10:30:33 +0800
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Matteo Croce" <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
 <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
 <YPBKFXWdDytvPmoN@Iliass-MBP>
 <CAKgT0UfOr7U-8T+Hr9NVPL7EMYaTzbx7w1-hUthjD9bXUFsqMw@mail.gmail.com>
 <YPBOHcx/sCEz/+wn@Iliass-MBP>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <57b08af5-8be2-56c7-981c-27ab7187fbdf@huawei.com>
Date:   Fri, 16 Jul 2021 10:30:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <YPBOHcx/sCEz/+wn@Iliass-MBP>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme718-chm.china.huawei.com (10.1.199.114) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/15 23:02, Ilias Apalodimas wrote:
> On Thu, Jul 15, 2021 at 07:57:57AM -0700, Alexander Duyck wrote:
>> On Thu, Jul 15, 2021 at 7:45 AM Ilias Apalodimas
>> <ilias.apalodimas@linaro.org> wrote:
>>>
>>>>>>           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>>>
>>> [...]
>>>
>>>>>>                             &shinfo->dataref))
>>>>>> -             return;
>>>>>> +             goto exit;
>>>>>
>>>>> Is it possible this patch may break the head frag page for the original skb,
>>>>> supposing it's head frag page is from the page pool and below change clears
>>>>> the pp_recycle for original skb, causing a page leaking for the page pool?
>>>>
>>>> I don't see how. The assumption here is that when atomic_sub_return
>>>> gets down to 0 we will still have an skb with skb->pp_recycle set and
>>>> it will flow down and encounter skb_free_head below. All we are doing
>>>> is skipping those steps and clearing skb->pp_recycle for all but the
>>>> last buffer and the last one to free it will trigger the recycling.
>>>
>>> I think the assumption here is that
>>> 1. We clone an skb
>>> 2. The original skb goes into pskb_expand_head()
>>> 3. skb_release_data() will be called for the original skb
>>>
>>> But with the dataref bumped, we'll skip the recycling for it but we'll also
>>> skip recycling or unmapping the current head (which is a page_pool mapped
>>> buffer)
>>
>> Right, but in that case it is the clone that is left holding the
>> original head and the skb->pp_recycle flag is set on the clone as it
>> was copied from the original when we cloned it. 
> 
> Ah yes, that's what I missed
> 
>> What we have
>> essentially done is transferred the responsibility for freeing it from
>> the original to the clone.
>>
>> If you think about it the result is the same as if step 2 was to go
>> into kfree_skb. We would still be calling skb_release_data and the
>> dataref would be decremented without the original freeing the page. We
>> have to wait until all the clones are freed and dataref reaches 0
>> before the head can be recycled.
> 
> Yep sounds correct

Ok, I suppose the fraglist skb is handled similar as the regular skb, right?

Also, this patch might need respinning as the state of this patch is "Changes
Requested" in patchwork.

> 
> Thanks
> /Ilias
> .
> 

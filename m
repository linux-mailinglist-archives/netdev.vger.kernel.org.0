Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48DAE3C9D37
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 12:48:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240188AbhGOKuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 06:50:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:11423 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbhGOKuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 06:50:54 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GQWGJ3wr1zcdHc;
        Thu, 15 Jul 2021 18:44:40 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 15 Jul 2021 18:47:55 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 15 Jul
 2021 18:47:55 +0800
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
CC:     Networking <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        "Jonathan Lemon" <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        "Cong Wang" <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
 <CAC_iWjLypqTGMxw_1ng1H8r5Yiv83G3yxUW8T1863XzFM-ShpA@mail.gmail.com>
 <CAC_iWjLfsvr_Z2te=ABfEAecAOkQBiu22QZ8GhorA4MYnt4Uxg@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <401f10b2-3b92-a3f9-f01e-df2e190c8ff3@huawei.com>
Date:   Thu, 15 Jul 2021 18:47:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAC_iWjLfsvr_Z2te=ABfEAecAOkQBiu22QZ8GhorA4MYnt4Uxg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/15 18:38, Ilias Apalodimas wrote:
> On Thu, 15 Jul 2021 at 13:00, Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
>>
>> On Thu, 15 Jul 2021 at 07:01, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>
>>> On 2021/7/9 14:29, Ilias Apalodimas wrote:
>>>> As Alexander points out, when we are trying to recycle a cloned/expanded
>>>> SKB we might trigger a race.  The recycling code relies on the
>>>> pp_recycle bit to trigger,  which we carry over to cloned SKBs.
>>>> If that cloned SKB gets expanded or if we get references to the frags,
>>>> call skbb_release_data() and overwrite skb->head, we are creating separate
>>>> instances accessing the same page frags.  Since the skb_release_data()
>>>> will first try to recycle the frags,  there's a potential race between
>>>> the original and cloned SKB, since both will have the pp_recycle bit set.
>>>>
>>>> Fix this by explicitly those SKBs not recyclable.
>>>> The atomic_sub_return effectively limits us to a single release case,
>>>> and when we are calling skb_release_data we are also releasing the
>>>> option to perform the recycling, or releasing the pages from the page pool.
>>>>
>>>> Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
>>>> Reported-by: Alexander Duyck <alexanderduyck@fb.com>
>>>> Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
>>>> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>>>> ---
>>>> Changes since v1:
>>>> - Set the recycle bit to 0 during skb_release_data instead of the
>>>>   individual fucntions triggering the issue, in order to catch all
>>>>   cases
>>>>  net/core/skbuff.c | 4 +++-
>>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>>> index 12aabcda6db2..f91f09a824be 100644
>>>> --- a/net/core/skbuff.c
>>>> +++ b/net/core/skbuff.c
>>>> @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
>>>>       if (skb->cloned &&
>>>>           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
>>>>                             &shinfo->dataref))
>>>> -             return;
>>>> +             goto exit;
>>>
>>> Is it possible this patch may break the head frag page for the original skb,
>>> supposing it's head frag page is from the page pool and below change clears
>>> the pp_recycle for original skb, causing a page leaking for the page pool?
>>>
>>
>> So this would leak eventually dma mapping if the skb is cloned (and
>> the dataref is now +1) and we are freeing the original skb first?
>>
> 
> Apologies for the noise, my description was not complete.
> The case you are thinking is clone an SKB and then expand the original?

Yes.
It seems we might need different pp_recycle bit for head frag and data frag.

> 
> thanks
> /Ilias
> 
> 
>>>>
>>>>       skb_zcopy_clear(skb, true);
>>>>
>>>> @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
>>>>               kfree_skb_list(shinfo->frag_list);
>>>>
>>>>       skb_free_head(skb);
>>>> +exit:
>>>> +     skb->pp_recycle = 0;
>>>>  }
>>>>
>>>>  /*
>>>>
> .
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D2372A776C
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 07:23:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgKEGXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 01:23:14 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7460 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730127AbgKEGXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 01:23:14 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CRYNn0K7PzhgV9;
        Thu,  5 Nov 2020 14:23:05 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 5 Nov 2020 14:22:56 +0800
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <1f8ebcde-f5ff-43df-960e-3661706e8d04@huawei.com>
 <CAM_iQpUm91x8Q0G=CXE7S43DKryABkyMTa4mz_oEfEOTFS7BgQ@mail.gmail.com>
 <db770012-f22c-dff4-5311-bf4d17cd08e3@huawei.com>
 <CAM_iQpUBytX3qim3rXLkwjdX3DSKeF8YhyX6o=Jwr-R9Onb-HA@mail.gmail.com>
 <5472023c-b50b-0cb3-4cb6-7bbea42d3612@huawei.com>
 <CAM_iQpVGm_Mz-yYUhhvn+p8H7mXHWHAuBNfyNj-251eY3Vr9iA@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <ae6993be-3af2-793c-1621-9f211e52e446@huawei.com>
Date:   Thu, 5 Nov 2020 14:22:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVGm_Mz-yYUhhvn+p8H7mXHWHAuBNfyNj-251eY3Vr9iA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/5 14:04, Cong Wang wrote:
> On Mon, Nov 2, 2020 at 11:24 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>>>> From my understanding, we can do anything about the old qdisc (including
>>>> destorying the old qdisc) after some_qdisc_is_busy() return false.
>>>
>>> But the current code does the reset _before_ some_qdisc_is_busy(). ;)
>>
>> If lock is taken when doing reset, it does not matter if the reset is
>> before some_qdisc_is_busy(), right?
> 
> Why not? How about the following scenario?
> 
> CPU0:                   CPU1:
> dev_reset_queue()

There is no skb in the dqisc now.

>                         net_tx_action()
>                          -> sch_direct_xmit()

So when CPU1 calls net_tx_action(), there is no skb to send and
no skb to be requeued too.

>                            -> dev_requeue_skb()
> some_qdisc_is_busy()
> // waiting for TX action on CPU1
> // now some packets are requeued
> 

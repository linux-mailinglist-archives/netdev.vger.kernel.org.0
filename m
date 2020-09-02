Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9957625A788
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 10:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgIBIPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 04:15:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:10791 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726140AbgIBIO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 04:14:57 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BB12553EDAF1BEFC43D5;
        Wed,  2 Sep 2020 16:14:54 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS401-HUB.china.huawei.com (10.3.19.201) with Microsoft SMTP Server id
 14.3.487.0; Wed, 2 Sep 2020 16:14:47 +0800
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
 <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
 <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <6984825d-1ef7-bf58-75fe-cee1bafe3c1a@huawei.com>
Date:   Wed, 2 Sep 2020 16:14:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/9/2 15:32, Eric Dumazet wrote:
> 
> 
> On 9/1/20 11:34 PM, Yunsheng Lin wrote:
> 
>>
>> I am not familiar with TCQ_F_CAN_BYPASS.
>> From my understanding, the problem is that there is no order between
>> qdisc enqueuing and qdisc reset.
> 
> Thw qdisc_reset() should be done after rcu grace period, when there is guarantee no enqueue is in progress.
> 
> qdisc_destroy() already has a qdisc_reset() call, I am not sure why qdisc_deactivate() is also calling qdisc_reset()

That is a good point.
Do we allow skb left in qdisc when the qdisc is deactivated state?
And qdisc_destroy() is not always called after qdisc_deactivate() is called.
If we allow skb left in qdisc when the qdisc is deactivated state, then it is
huge change of semantics for qdisc_deactivate(), and I am not sure how many
cases will affected by this change.


> 
> 
> 

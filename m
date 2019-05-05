Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46DFB13E90
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 11:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727454AbfEEJJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 05:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46790 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfEEJJx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 May 2019 05:09:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C4FF81DF6;
        Sun,  5 May 2019 09:09:52 +0000 (UTC)
Received: from [10.72.12.197] (ovpn-12-197.pek2.redhat.com [10.72.12.197])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF54A60851;
        Sun,  5 May 2019 09:09:38 +0000 (UTC)
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>, wangli39@baidu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
 <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com>
 <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com>
 <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
 <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <d32f77c0-ce75-b96f-f158-1891966dc83c@redhat.com>
Date:   Sun, 5 May 2019 17:09:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sun, 05 May 2019 09:09:53 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/4/30 上午12:38, Cong Wang wrote:
> On Sun, Apr 28, 2019 at 7:23 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2019/4/29 上午1:59, Cong Wang wrote:
>>> On Sun, Apr 28, 2019 at 12:51 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>> tun_net_xmit() doesn't have the chance to
>>>>> access the change because it holding the rcu_read_lock().
>>>>
>>>> The problem is the following codes:
>>>>
>>>>
>>>>           --tun->numqueues;
>>>>
>>>>           ...
>>>>
>>>>           synchronize_net();
>>>>
>>>> We need make sure the decrement of tun->numqueues be visible to readers
>>>> after synchronize_net(). And in tun_net_xmit():
>>> It doesn't matter at all. Readers are okay to read it even they still use the
>>> stale tun->numqueues, as long as the tfile is not freed readers can read
>>> whatever they want...
>> This is only true if we set SOCK_RCU_FREE, isn't it?
>
> Sure, this is how RCU is supposed to work.
>
>>> The decrement of tun->numqueues is just how we unpublish the old
>>> tfile, it is still valid for readers to read it _after_ unpublish, we only need
>>> to worry about free, not about unpublish. This is the whole spirit of RCU.
>>>
>> The point is we don't convert tun->numqueues to RCU but use
>> synchronize_net().
> Why tun->numqueues needs RCU? It is an integer, and reading a stale
> value is _perfectly_ fine.


I meant we don't want e.g tun_net_xmit() to see the stale value after 
synchronize_net() in __tun_detach(), since it has various other steps 
with the assumption that no tfile dereference from data path. E.g one 
example is XDP rxq information un-registering which looks racy in the 
case of XDP_TX.


>
> If you actually meant to say tun->tfiles[] itself, no, it is a fixed-size array,
> it doesn't shrink or grow, so we don't need RCU for it. This is also why
> a stale tun->numqueues is fine, as long as it never goes out-of-bound.


We do kind of shrinking or growing through tun->numqueues. That's why we 
check against it in various places. But, of course this is buggy.


>
>
>>> You need to rethink about my SOCK_RCU_FREE patch.
>> The code is wrote before SOCK_RCU_FREE is introduced and assume no
>> de-reference from device after synchronize_net(). It doesn't harm to
>> figure out the root cause which may give us more confidence to the fix
>> (e.g like SOCK_RCU_FREE).
> I believe SOCK_RCU_FREE is the fix for the root cause, not just a
> cover-up.
>
>
>> I don't object to fix with SOCK_RCU_FREE, but then we should remove
>> the redundant synchronize_net(). But I still prefer to synchronize
>> everything explicitly like (completely untested):
> I agree that synchronize_net() can be removed. However I don't
> understand your untested patch at all, it looks like to fix a completely
> different problem rather than this use-after-free.


As has been mentioned, the problem of current code is that we still 
leave pointers  to freed tfile in tfiles[] array in __tun_detach() and 
the check with tun->numqueues seems racy. So the patch just NULL out the 
detached tfile pointers and make sure no it can not be dereferenced from 
tfile after synchronize_net() by dereferencing tfile instead of checking 
tun->numqueues .


Thanks

>
> Thanks.

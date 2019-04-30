Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7BAEED1
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 04:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbfD3Coi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 22:44:38 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:7144 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729803AbfD3Coi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 22:44:38 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3CE534D3676DD916A242;
        Tue, 30 Apr 2019 10:44:36 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 10:44:27 +0800
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jason Wang <jasowang@redhat.com>
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com>
 <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com>
 <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com>
 <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
 <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>, <wangli39@baidu.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <89f38a2b-c416-f838-ee85-356bffed5bdb@huawei.com>
Date:   Tue, 30 Apr 2019 10:44:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019/4/30 0:38, Cong Wang wrote:
> On Sun, Apr 28, 2019 at 7:23 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>>
>> On 2019/4/29 上午1:59, Cong Wang wrote:
>>> On Sun, Apr 28, 2019 at 12:51 AM Jason Wang <jasowang@redhat.com> wrote:
>>>>> tun_net_xmit() doesn't have the chance to
>>>>> access the change because it holding the rcu_read_lock().
>>>>
>>>>
>>>> The problem is the following codes:
>>>>
>>>>
>>>>          --tun->numqueues;
>>>>
>>>>          ...
>>>>
>>>>          synchronize_net();
>>>>
>>>> We need make sure the decrement of tun->numqueues be visible to readers
>>>> after synchronize_net(). And in tun_net_xmit():
>>>
>>> It doesn't matter at all. Readers are okay to read it even they still use the
>>> stale tun->numqueues, as long as the tfile is not freed readers can read
>>> whatever they want...
>>
>> This is only true if we set SOCK_RCU_FREE, isn't it?
> 
> 
> Sure, this is how RCU is supposed to work.
> 
>>
>>>
>>> The decrement of tun->numqueues is just how we unpublish the old
>>> tfile, it is still valid for readers to read it _after_ unpublish, we only need
>>> to worry about free, not about unpublish. This is the whole spirit of RCU.
>>>
>>
>> The point is we don't convert tun->numqueues to RCU but use
>> synchronize_net().
> 
> Why tun->numqueues needs RCU? It is an integer, and reading a stale
> value is _perfectly_ fine.
> 
> If you actually meant to say tun->tfiles[] itself, no, it is a fixed-size array,
> it doesn't shrink or grow, so we don't need RCU for it. This is also why
> a stale tun->numqueues is fine, as long as it never goes out-of-bound.
> 
> 
>>
>>> You need to rethink about my SOCK_RCU_FREE patch.
>>
>> The code is wrote before SOCK_RCU_FREE is introduced and assume no
>> de-reference from device after synchronize_net(). It doesn't harm to
>> figure out the root cause which may give us more confidence to the fix
>> (e.g like SOCK_RCU_FREE).
> 
> I believe SOCK_RCU_FREE is the fix for the root cause, not just a
> cover-up.

With SOCK_RCU_FREE tfile is ok ,

but tfile->sk is freed by sock_put in __tun_detach, it will trgger

use-after-free in tun_net_xmit if tun->numqueues check passed.

> 
> 
>>
>> I don't object to fix with SOCK_RCU_FREE, but then we should remove
>> the redundant synchronize_net(). But I still prefer to synchronize
>> everything explicitly like (completely untested):
> 
> I agree that synchronize_net() can be removed. However I don't
> understand your untested patch at all, it looks like to fix a completely
> different problem rather than this use-after-free.
> 
> Thanks.
> 
> .
> 


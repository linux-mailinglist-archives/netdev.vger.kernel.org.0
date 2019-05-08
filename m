Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C816F42
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 04:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbfEHCyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 22:54:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfEHCyZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 22:54:25 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0E3418AE40;
        Wed,  8 May 2019 02:54:25 +0000 (UTC)
Received: from [10.72.12.176] (ovpn-12-176.pek2.redhat.com [10.72.12.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27A095C269;
        Wed,  8 May 2019 02:54:19 +0000 (UTC)
Subject: Re: [PATCH net V2] tuntap: synchronize through tfiles array instead
 of tun->numqueues
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        YueHaibing <yuehaibing@huawei.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1557201816-19945-1-git-send-email-jasowang@redhat.com>
 <CAM_iQpURdiJv9GqkEyk=MPokacvtJVfHUpBb3=6EWA0e1yiTZQ@mail.gmail.com>
 <a1ef0c0d-d67c-8888-91e6-2819e8c45489@redhat.com>
 <CAM_iQpVGdduQGdkBn2a+8=VTuZcoTxBdve6+uDHACcDrdtL=Og@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e2c79625-7541-cf58-5729-a5519f36b248@redhat.com>
Date:   Wed, 8 May 2019 10:54:18 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVGdduQGdkBn2a+8=VTuZcoTxBdve6+uDHACcDrdtL=Og@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Wed, 08 May 2019 02:54:25 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/5/7 下午10:41, Cong Wang wrote:
> On Mon, May 6, 2019 at 11:19 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2019/5/7 下午12:54, Cong Wang wrote:
>>> On Mon, May 6, 2019 at 9:03 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>>>> index e9ca1c0..32a0b23 100644
>>>> --- a/drivers/net/tun.c
>>>> +++ b/drivers/net/tun.c
>>>> @@ -700,6 +700,8 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
>>>>                                      tun->tfiles[tun->numqueues - 1]);
>>>>                   ntfile = rtnl_dereference(tun->tfiles[index]);
>>>>                   ntfile->queue_index = index;
>>>> +               rcu_assign_pointer(tun->tfiles[tun->numqueues - 1],
>>>> +                                  NULL);
>>>>
>>> How does this work? Existing readers could still read this
>>> tun->tfiles[tun->numqueues - 1] before you NULL it. And,
>>> _if_ the following sock_put() is the one frees it, you still miss
>>> a RCU grace period.
>>>
>>>                   if (clean) {
>>>                           RCU_INIT_POINTER(tfile->tun, NULL);
>>>                           sock_put(&tfile->sk);
>>>
>>>
>>> Thanks.
>>
>> My understanding is the socket will never be freed for this sock_put().
>> We just drop an extra reference count we held when the socket was
>> attached to the netdevice (there's a sock_hold() in tun_attach()). The
>> real free should happen at another sock_put() in the end of this function.
> So you are saying readers will never read this sock after free, then
> what are you fixing with this patch? Nothing, right?


It's the issue of the second sock_put() in tun_detach() not the first 
one. Without proper synchronization for tun->numqueues, tun_net_xmit() 
can actually dereference a tfile which has been freed by second 
sock_put(). The synchornize_net() doesn't help since we're trying to 
synchronize through tun->numqueues.


>
> As I said, reading a stale tun->numqueues is fine, you just keep
> believing it is a problem.


This is only true if you can make sure tfile[tun->numqueues] is not 
freed. Either my patch or SOCK_RCU_FREE can solve this, but for 
SOCK_RCU_FREE we need do extra careful audit to make sure it doesn't 
break someting. So synchronize through pointers in tfiles[] which is 
already protected by RCU is much more easier. It can make sure no 
dereference from xmit path after synchornize_net(). And this matches the 
assumptions of the codes after synchronize_net().

Thanks


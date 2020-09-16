Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC69426BA82
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 05:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726172AbgIPDH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 23:07:56 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:56287 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726023AbgIPDHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 23:07:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=wenyang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0U94yIkx_1600225667;
Received: from IT-C02W23QPG8WN.local(mailfrom:wenyang@linux.alibaba.com fp:SMTPD_---0U94yIkx_1600225667)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Sep 2020 11:07:48 +0800
From:   Wen Yang <wenyang@linux.alibaba.com>
Subject: Re: [PATCH] net: core: explicitly call linkwatch_fire_event to speed
 up the startup of network services
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, andrew@lunn.ch, edumazet@google.com,
        jiri@mellanox.com, leon@kernel.org, jwi@linux.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200801085845.20153-1-wenyang@linux.alibaba.com>
 <20200804.155831.644663742975051162.davem@davemloft.net>
 <41107812-01ba-169e-2f18-69cecec94d8d@linux.alibaba.com>
Message-ID: <21bd2d87-c784-06dd-6e1e-25569ebef040@linux.alibaba.com>
Date:   Wed, 16 Sep 2020 11:07:47 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.0
MIME-Version: 1.0
In-Reply-To: <41107812-01ba-169e-2f18-69cecec94d8d@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


on 2020/8/6 PM5:09, Wen Yang wrote:
>
>
> 在 2020/8/5 上午6:58, David Miller 写道:
>> From: Wen Yang <wenyang@linux.alibaba.com>
>> Date: Sat,  1 Aug 2020 16:58:45 +0800
>>
>>> diff --git a/net/core/link_watch.c b/net/core/link_watch.c
>>> index 75431ca..6b9d44b 100644
>>> --- a/net/core/link_watch.c
>>> +++ b/net/core/link_watch.c
>>> @@ -98,6 +98,9 @@ static bool linkwatch_urgent_event(struct 
>>> net_device *dev)
>>>       if (netif_is_lag_port(dev) || netif_is_lag_master(dev))
>>>           return true;
>>>   +    if ((dev->flags & IFF_UP) && dev->operstate == IF_OPER_DOWN)
>>> +        return true;
>>> +
>>>       return netif_carrier_ok(dev) && qdisc_tx_changing(dev);
>>>   }
>>
>> You're bypassing explicitly the logic here:
>>
>>     /*
>>      * Limit the number of linkwatch events to one
>>      * per second so that a runaway driver does not
>>      * cause a storm of messages on the netlink
>>      * socket.  This limit does not apply to up events
>>      * while the device qdisc is down.
>>      */
>>     if (!urgent_only)
>>         linkwatch_nextevent = jiffies + HZ;
>>     /* Limit wrap-around effect on delay. */
>>     else if (time_after(linkwatch_nextevent, jiffies + HZ))
>>         linkwatch_nextevent = jiffies;
>>
>> Something about this isn't right.  We need to analyze what you are 
>> seeing,
>> what device you are using, and what systemd is doing to figure out what
>> the right place for the fix.
>>
>> Thank you.
>>
>
> Thank you very much for your comments.
> We are using virtio_net and the environment is a microvm similar to 
> firecracker.
>
> Let's briefly explain.
> net_device->operstate is assigned through linkwatch_event, and the 
> call stack is as follows:
> process_one_work
> -> linkwatch_event
>  -> __linkwatch_run_queue
>   -> linkwatch_do_dev
>    -> rfc2863_policy
>     -> default_operstate
>
> During the machine startup process, net_device->operstate has the 
> following two-step state changes:
>
> STEP A: virtnet_probe detects the network card and triggers the 
> execution of linkwatch_fire_event.
> Since linkwatch_nextevent is initialized to 0, linkwatch_work will run.
> And since net_device->state is 6 (__LINK_STATE_PRESENT | 
> __LINK_STATE_NOCARRIER), net_device->operstate will be changed from 
> IF_OPER_UNKNOWN to IF_OPER_DOWN:
> eth0 operstate:0 (IF_OPER_UNKNOWN) -> operstate:2 (IF_OPER_DOWN)
>
> virtnet_probe then executes netif_carrier_on to update 
> net_device->state, it will be changed from ‘__LINK_STATE_PRESENT | 
> __LINK_STATE_NOCARRIER’ to __LINK_STATE_PRESENT:
> eth0 state: 6 (__LINK_STATE_PRESENT | __LINK_STATE_NOCARRIER) -> 2 
> (__LINK_STATE_PRESENT)
>
> STEP B: One second later (because linkwatch_nextevent = jiffies + HZ), 
> linkwatch_work is executed again.
> At this time, since net_device->state is __LINK_STATE_PRESENT, so the 
> net_device->operstate will be changed from IF_OPER_DOWN to IF_OPER_UP:
> eth0 operstate:2 (IF_OPER_DOWN) -> operstate:6 (IF_OPER_UP)
>
>
> The above state change can be completed within 2 seconds.
> Generally, the machine will load the initramfs first, and do some 
> initialization in the initramfs, which takes some time; then 
> switch_root to the system disk and continue the initialization, which 
> will also take some time, and finally start the systemd-networkd 
> service, bringing link, etc.,
> In this way, the linkwatch_work work queue has enough time to run 
> twice, and the state of net_device->operstate is already IF_OPER_UP,
> So bringing link up quickly returns the following information:
> Aug 06 16:35:55.966121 iZuf6h1kfgutxc3el68z2lZ systemd-networkd[580]: 
> eth0: bringing link up
> ...
> Aug 06 16:35:55.990461 iZuf6h1kfgutxc3el68z2lZ systemd-networkd[580]: 
> eth0: flags change: +UP +LOWER_UP +RUNNING
>
> But we are now using MicroVM, which requires extreme speed to start, 
> bypassing the initramfs and directly booting the trimmed system on the 
> disk.
> systemd-networkd starts in less than 1 second after booting. the STEP 
> B has not been run yet, so it will wait for several hundred 
> milliseconds here, as follows:
> Jul 20 22:00:47.432552 systemd-networkd[210]: eth0: bringing link up
> ...
> Jul 20 22:00:47.446108 systemd-networkd[210]: eth0: flags change: +UP 
> +LOWER_UP
> ...
> Jul 20 22:00:47.781463 systemd-networkd[210]: eth0: flags change: 
> +RUNNING
>
>
> Note: dhcp pays attention to IFF_RUNNING status, we may refer to:
> https://www.kernel.org/doc/Documentation/networking/operstates.txt
>
> A routing daemon or dhcp client just needs to care for IFF_RUNNING or
> waiting for operstate to go IF_OPER_UP/IF_OPER_UNKNOWN before
> considering the interface / querying a DHCP address.
>
> Finally, the STEP B above only updates the value of operstate based on 
> the known state (operstate/state) on the net_device, without any 
> hardware interaction involved, so it is not very reasonable to wait 
> for 1 second there.
>
> By adding:
> +    if ((dev->flags & IFF_UP) && dev->operstate == IF_OPER_DOWN)
> +        return true;
> +
> We hope to improve the linkwatch_urgent_event function a bit.
>
> Hope to get more of your advice and guidance.
>
> Best wishes,
> Wen

hi, this issue is worth continuing discussion.
In the microVM scenario, it is valuable to increase the startup speed by 
a few hundred milliseconds.

Best wishes,
Wen




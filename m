Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB4529FAA6
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 02:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725800AbgJ3Bgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 21:36:41 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:6989 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725771AbgJ3Bgl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 21:36:41 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CMlK56tCBzhcfn;
        Fri, 30 Oct 2020 09:36:41 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Fri, 30 Oct 2020 09:36:33 +0800
Subject: Re: arping stuck with ENOBUFS in 4.19.150
To:     David Ahern <dsahern@gmail.com>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
 <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
 <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
 <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
 <bf33dfc1-8e37-8ac0-7dcb-09002faadc7a@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <4641f25f-7e7f-5d06-7e00-e1716cbdeddc@huawei.com>
Date:   Fri, 30 Oct 2020 09:36:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <bf33dfc1-8e37-8ac0-7dcb-09002faadc7a@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/29 23:18, David Ahern wrote:
> On 10/29/20 8:10 AM, Joakim Tjernlund wrote:
>> OK, bisecting (was a bit of a bother since we merge upstream releases into our tree, is there a way to just bisect that?)
>>
>> Result was commit "net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc"  (749cc0b0c7f3dcdfe5842f998c0274e54987384f)
>>
>> Reverting that commit on top of our tree made it work again. How to fix?
> 
> Adding the author of that patch (linyunsheng@huawei.com) to take a look.
> 
> 
>>
>>  Jocke
>>  
>> On Mon, 2020-10-26 at 12:31 -0600, David Ahern wrote:
>>>
>>> On 10/26/20 6:58 AM, Joakim Tjernlund wrote:
>>>> Ping  (maybe it should read "arping" instead :)
>>>>
>>>>  Jocke
>>>>
>>>> On Thu, 2020-10-22 at 17:19 +0200, Joakim Tjernlund wrote:
>>>>> strace arping -q -c 1 -b -U  -I eth1 0.0.0.0
>>>>> ...
>>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\v\6 \v\v\v\v\377\377\377\377\377\377\0\0\0\0", 28, 0, {sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={1, ffffffffffff},
>>>>> 20) = -1 ENOBUFS (No buffer space available)
>>>>> ....
>>>>> and then arping loops.
>>>>>
>>>>> in 4.19.127 it was:
>>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\5\271\362\n\322\212E\377\377\377\377\377\377\0\0\0\0", 28, 0, {​sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={​1,
>>>>> ffffffffffff}​, 20) = 28
>>>>>
>>>>> Seems like something has changed the IP behaviour between now and then ?
>>>>> eth1 is UP but not RUNNING and has an IP address.

"eth1 is UP but not RUNNING" usually mean user has configure the netdev as up,
but the hardware has not detected a linkup yet.

Also What is the output of "ethtool eth1"?

It would be good to see the status of netdev before and after executing arping cmd
too.

Thanks.

>>>>>
>>>>>  Jocke
>>>>
>>>
>>> do a git bisect between the releases to find out which commit is causing
>>> the change in behavior.

unfortunately, I did not reproduce the above problem in 4.19.150 too.

root@(none)$ arping -q -c 1 -b -U  -I eth0 0.0.0.0
root@(none)$ arping -v
ARPing 2.21, by Thomas Habets <thomas@habets.se>
usage: arping [ -0aAbdDeFpPqrRuUv ] [ -w <sec> ] [ -W <sec> ] [ -S <host/ip> ]
              [ -T <host/ip ] [ -s <MAC> ] [ -t <MAC> ] [ -c <count> ]
              [ -C <count> ] [ -i <interface> ] [ -m <type> ] [ -g <group> ]
              [ -V <vlan> ] [ -Q <priority> ] <host/ip/MAC | -B>
For complete usage info, use --help or check the manpage.
root@(none)$ cat /proc/version
Linux version 4.19.150 (linyunsheng@ubuntu) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.12)) #4 SMP PREEMPT Fri Oct 30 09:22:06 CST 2020



>>
> 
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5222A12BF
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 02:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgJaBsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 21:48:16 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6710 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgJaBsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 21:48:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CNMWt5WF2zkcGt;
        Sat, 31 Oct 2020 09:48:10 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.487.0; Sat, 31 Oct 2020 09:48:09 +0800
Subject: Re: arping stuck with ENOBUFS in 4.19.150
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
References: <9bede0ef7e66729034988f2d01681ca88a5c52d6.camel@infinera.com>
 <e09b367a58a0499f3bb0394596a9f87cc20eb5de.camel@infinera.com>
 <777947a9-1a05-c51b-81fc-4338aca3af26@gmail.com>
 <97730e024e7279d67f3eca7e0ef24395e9e08bff.camel@infinera.com>
 <bf33dfc1-8e37-8ac0-7dcb-09002faadc7a@gmail.com>
 <4641f25f-7e7f-5d06-7e00-e1716cbdeddc@huawei.com>
 <0c9f0deeb50d7caef0013125353b3bf1260c03c4.camel@infinera.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <0e69e590-ad4e-ade4-4ed3-f28e39e3d9c7@huawei.com>
Date:   Sat, 31 Oct 2020 09:48:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <0c9f0deeb50d7caef0013125353b3bf1260c03c4.camel@infinera.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/30 19:50, Joakim Tjernlund wrote:
> On Fri, 2020-10-30 at 09:36 +0800, Yunsheng Lin wrote:
>> CAUTION: This email originated from outside of the organization. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>>
>>
>> On 2020/10/29 23:18, David Ahern wrote:
>>> On 10/29/20 8:10 AM, Joakim Tjernlund wrote:
>>>> OK, bisecting (was a bit of a bother since we merge upstream releases into our tree, is there a way to just bisect that?)
>>>>
>>>> Result was commit "net: sch_generic: aviod concurrent reset and enqueue op for lockless qdisc"  (749cc0b0c7f3dcdfe5842f998c0274e54987384f)
>>>>
>>>> Reverting that commit on top of our tree made it work again. How to fix?
>>>
>>> Adding the author of that patch (linyunsheng@huawei.com) to take a look.
>>>
>>>
>>>>
>>>>  Jocke
>>>>
>>>> On Mon, 2020-10-26 at 12:31 -0600, David Ahern wrote:
>>>>>
>>>>> On 10/26/20 6:58 AM, Joakim Tjernlund wrote:
>>>>>> Ping  (maybe it should read "arping" instead :)
>>>>>>
>>>>>>  Jocke
>>>>>>
>>>>>> On Thu, 2020-10-22 at 17:19 +0200, Joakim Tjernlund wrote:
>>>>>>> strace arping -q -c 1 -b -U  -I eth1 0.0.0.0
>>>>>>> ...
>>>>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\v\6 \v\v\v\v\377\377\377\377\377\377\0\0\0\0", 28, 0, {sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={1, ffffffffffff},
>>>>>>> 20) = -1 ENOBUFS (No buffer space available)
>>>>>>> ....
>>>>>>> and then arping loops.
>>>>>>>
>>>>>>> in 4.19.127 it was:
>>>>>>> sendto(3, "\0\1\10\0\6\4\0\1\0\6\234\5\271\362\n\322\212E\377\377\377\377\377\377\0\0\0\0", 28, 0, {​sa_family=AF_PACKET, proto=0x806, if4, pkttype=PACKET_HOST, addr(6)={​1,
>>>>>>> ffffffffffff}​, 20) = 28
>>>>>>>
>>>>>>> Seems like something has changed the IP behaviour between now and then ?
>>>>>>> eth1 is UP but not RUNNING and has an IP address.
>>
>> "eth1 is UP but not RUNNING" usually mean user has configure the netdev as up,
>> but the hardware has not detected a linkup yet.
>>
>> Also What is the output of "ethtool eth1"?
> 
> echo 1 >  /sys/class/net/eth1/carrier
> cu3-jocke ~ # arping -q -c 1 -b -U  -I eth1 0.0.0.0
> cu3-jocke ~ # echo 0 >  /sys/class/net/eth1/carrier
> cu3-jocke ~ # arping -q -c 1 -b -U  -I eth1 0.0.0.0
> ^Ccu3-jocke ~ # ethtool eth1
> Settings for eth1:
> 	Supported ports: [ MII ]
> 	Supported link modes:   1000baseT/Full 
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: Yes
> 	Advertised link modes:  1000baseT/Full 
> 	Advertised pause frame use: Symmetric Receive-only
> 	Advertised auto-negotiation: Yes
> 	Speed: 10Mb/s
> 	Duplex: Half
> 	Port: MII
> 	PHYAD: 1
> 	Transceiver: external
> 	Auto-negotiation: on
> 	Current message level: 0x00000037 (55)
> 			       drv probe link ifdown ifup
> 	Link detected: no
> 
> We have a writeable carrier since eth device is PHY less. Maybe that path is different ?
> Check drivers/net/ethernet/freescale/dpaa/dpa_eth.c

The above difference does not seems to matter.

> 
>>
>> It would be good to see the status of netdev before and after executing arping cmd
>> too.
> 
> hmm, how do you mean?

I was trying to find out when the netdev' state became "eth1 is UP but not RUNNING".

Anyway, when I looked at the backported patch, I did find new qdisc assignment is
missing from the upstream patch.

Please see if the below patch fix your problem, thanks:

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index bd96fd2..4e15913 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1116,10 +1116,13 @@ static void dev_deactivate_queue(struct net_device *dev,
                                 void *_qdisc_default)
 {
        struct Qdisc *qdisc = rtnl_dereference(dev_queue->qdisc);
+       struct Qdisc *qdisc_default = _qdisc_default;

        if (qdisc) {
                if (!(qdisc->flags & TCQ_F_BUILTIN))
                        set_bit(__QDISC_STATE_DEACTIVATED, &qdisc->state);
+
+               rcu_assign_pointer(dev_queue->qdisc, qdisc_default);
        }
 }




> 
>>
>> Thanks.
>>
>>>>>>>
>>>>>>>  Jocke
>>>>>>
>>>>>
>>>>> do a git bisect between the releases to find out which commit is causing
>>>>> the change in behavior.
>>
>> unfortunately, I did not reproduce the above problem in 4.19.150 too.
>>
>> root@(none)$ arping -q -c 1 -b -U  -I eth0 0.0.0.0
>> root@(none)$ arping -v
>> ARPing 2.21, by Thomas Habets <thomas@habets.se>
>> usage: arping [ -0aAbdDeFpPqrRuUv ] [ -w <sec> ] [ -W <sec> ] [ -S <host/ip> ]
>>               [ -T <host/ip ] [ -s <MAC> ] [ -t <MAC> ] [ -c <count> ]
>>               [ -C <count> ] [ -i <interface> ] [ -m <type> ] [ -g <group> ]
>>               [ -V <vlan> ] [ -Q <priority> ] <host/ip/MAC | -B>
>> For complete usage info, use --help or check the manpage.
>> root@(none)$ cat /proc/version
>> Linux version 4.19.150 (linyunsheng@ubuntu) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.12)) #4 SMP PREEMPT Fri Oct 30 09:22:06 CST 2020
>>
>>
>>
>>>>
>>>
>>>
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC34829E8EB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgJ2KZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:25:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:6926 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgJ2KZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:25:12 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CMM5J2hT5z6y6h;
        Thu, 29 Oct 2020 18:25:08 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS409-HUB.china.huawei.com (10.3.19.209) with Microsoft SMTP Server id
 14.3.487.0; Thu, 29 Oct 2020 18:24:57 +0800
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Vishwanath Pai <vpai@akamai.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
CC:     "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <1599562954-87257-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpX0_mz+McZdzZ7HFTjBihOKz5E6i4qJQSoFbZ=SZkVh=Q@mail.gmail.com>
 <830f85b5-ef29-c68e-c982-de20ac880bd9@huawei.com>
 <CAM_iQpU_tbRNO=Lznz_d6YjXmenYhowEfBoOiJgEmo9x8bEevw@mail.gmail.com>
 <CAP12E-+3DY-dgzVercKc-NYGPExWO1NjTOr1Gf3tPLKvp6O6+g@mail.gmail.com>
 <AE096F70-4419-4A67-937A-7741FBDA6668@akamai.com>
 <CAM_iQpX0XzNDCzc2U5=g6aU-HGYs3oryHx=rmM3ue9sH=Jd4Gw@mail.gmail.com>
 <19f888c2-8bc1-ea56-6e19-4cb4841c4da0@akamai.com>
 <93ab7f0f-7b5a-74c3-398d-a572274a4790@huawei.com>
 <248e5a32-a102-0ced-1462-aa2bc5244252@akamai.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <de690c67-6e9f-8885-10c1-f47313de7b62@huawei.com>
Date:   Thu, 29 Oct 2020 18:24:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <248e5a32-a102-0ced-1462-aa2bc5244252@akamai.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/10/29 12:50, Vishwanath Pai wrote:
> On 10/28/20 10:37 PM, Yunsheng Lin wrote:
>> On 2020/10/29 4:04, Vishwanath Pai wrote:
>>> On 10/28/20 1:47 PM, Cong Wang wrote:
>>>> On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath <vpai@akamai.com> wrote:
>>>>> Hi,
>>>>>
>>>>> We noticed some problems when testing the latest 5.4 LTS kernel and traced it
>>>>> back to this commit using git bisect. When running our tests the machine stops
>>>>> responding to all traffic and the only way to recover is a reboot. I do not see
>>>>> a stack trace on the console.
>>>>
>>>> Do you mean the machine is still running fine just the network is down?
>>>>
>>>> If so, can you dump your tc config with stats when the problem is happening?
>>>> (You can use `tc -s -d qd show ...`.)
>>>>
>>>>>
>>>>> This can be reproduced using the packetdrill test below, it should be run a
>>>>> few times or in a loop. You should hit this issue within a few tries but
>>>>> sometimes might take up to 15-20 tries.
>>>> ...
>>>>> I can reproduce the issue easily on v5.4.68, and after reverting this commit it
>>>>> does not happen anymore.
>>>>
>>>> This is odd. The patch in this thread touches netdev reset path, if packetdrill
>>>> is the only thing you use to trigger the bug (that is netdev is always active),
>>>> I can not connect them.
>>>>
>>>> Thanks.
>>>
>>> Hi Cong,
>>>
>>>> Do you mean the machine is still running fine just the network is down?
>>>
>>> I was able to access the machine via serial console, it looks like it is
>>> up and running, just that networking is down.
>>>
>>>> If so, can you dump your tc config with stats when the problem is happening?
>>>> (You can use `tc -s -d qd show ...`.)
>>>
>>> If I try running tc when the machine is in this state the command never
>>> returns. It doesn't print anything but doesn't exit either.
>>>
>>>> This is odd. The patch in this thread touches netdev reset path, if packetdrill
>>>> is the only thing you use to trigger the bug (that is netdev is always active),
>>>> I can not connect them.
>>>
>>> I think packetdrill creates a tun0 interface when it starts the
>>> test and tears it down at the end, so it might be hitting this code path
>>> during teardown.
>>
>> Hi, Is there any preparation setup before running the above packetdrill test
>> case, I run the above test case in 5.9-rc4 with this patch applied without any
>> preparation setup, did not reproduce it.
>>
>> By the way, I am newbie to packetdrill:), it would be good to provide the
>> detail setup to reproduce it,thanks.
>>
>>>
>>> P.S: My mail server is having connectivity issues with vger.kernel.org
>>> so messages aren't getting delivered to netdev. It'll hopefully get
>>> resolved soon.
>>>
>>> Thanks,
>>> Vishwanath
>>>
>>>
>>> .
>>>
> 
> I can't reproduce it on v5.9-rc4 either, it is probably an issue only on
> 5.4 then (and maybe older LTS versions). Can you give it a try on
> 5.4.68?
> 
> For running packetdrill, download the latest version from their github
> repo, then run it in a loop without any special arguments. This is what
> I do to reproduce it:
> 
> while true; do ./packetdrill <test-file>; done
> 
> I don't think any other setup is necessary.

Hi, run the above test for above an hour using 5.4.68, still did not
reproduce it, as below:


root@(none)$ cd /home/root/
root@(none)$ ls
creat_vlan.sh  packetdrill    test.pd
root@(none)$ cat test.pd
0 `echo 4 > /proc/sys/net/ipv4/tcp_min_tso_segs`

0.400 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
0.400 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0

// set maxseg to 1000 to work with both ipv4 and ipv6
0.500 setsockopt(3, SOL_TCP, TCP_MAXSEG, [1000], 4) = 0
0.500 bind(3, ..., ...) = 0
0.500 listen(3, 1) = 0

// Establish connection
0.600 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 5>
0.600 > S. 0:0(0) ack 1 <...>

0.800 < . 1:1(0) ack 1 win 320
0.800 accept(3, ..., ...) = 4

// Send 4 data segments.
+0 write(4, ..., 4000) = 4000
+0 > P. 1:4001(4000) ack 1

// Receive a SACK
+.1 < . 1:1(0) ack 1 win 320 <sack 1001:2001,nop,nop>

+.3 %{ print "TCP CA state: ",tcpi_ca_state  }%
root@(none)$ cat creat_vlan.sh
#!/bin/sh

for((i=0; i<10000; i++))
do
	./packetdrill test.pd
done
root@(none)$ ./creat_vlan.sh
TCP CA state:  3
^C
root@(none)$ ifconfig
eth0      Link encap:Ethernet  HWaddr 5c:e8:83:0d:f7:ed
          inet addr:192.168.1.93  Bcast:192.168.1.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:3570 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3190 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:1076349 (1.0 MiB)  TX bytes:414874 (405.1 KiB)

eth2      Link encap:Ethernet  HWaddr 5c:e8:83:0d:f7:ec
          inet addr:192.168.100.1  Bcast:192.168.100.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:81848576 errors:0 dropped:0 overruns:0 frame:78
          TX packets:72497816 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:2044282289568 (1.8 TiB)  TX bytes:2457441698852 (2.2 TiB)

lo        Link encap:Local Loopback
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:1 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000
          RX bytes:68 (68.0 B)  TX bytes:68 (68.0 B)

root@(none)$ ./creat_vlan.sh
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
TCP CA state:  3
^C
root@(none)$ cat /proc/cmdline
BOOT_IMAGE=/linyunsheng/Image.5.0 rdinit=/init console=ttyAMA0,115200 earlycon=pl011,mmio32,0x94080000 iommu.strict=1
root@(none)$ cat /proc/version
Linux version 5.4.68 (linyunsheng@ubuntu) (gcc version 5.4.0 20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.12)) #1 SMP PREEMPT Thu Oct 29 16:59:37 CST 2020
root@(none)$



> 
> -Vishwanath
> 
> .
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D322A32E5
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 19:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbgKBSYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 13:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgKBSYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 13:24:15 -0500
Received: from mx0b-00190b01.pphosted.com (mx0b-00190b01.pphosted.com [IPv6:2620:100:9005:57f::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613F7C0617A6;
        Mon,  2 Nov 2020 10:24:15 -0800 (PST)
Received: from pps.filterd (m0050102.ppops.net [127.0.0.1])
        by m0050102.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id 0A2IH1mr012441;
        Mon, 2 Nov 2020 18:23:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=pfmyzxTDrWW6Q3hhmxuQKjs4FYdNBTjwWf8Qk7bwHD8=;
 b=H+zT0cQWiFkWjvu/m5GZrUEEzqKhvhHT3EeTRadgMzBRpg6VO1tfHZcLEcgWDEZbtBES
 Nut+SELS7vbAXglnyNEsJ3m6V4xMgw4t6YdY32GI7zun5xTtoOX8+0nTJTm6Vl26D6vQ
 6rFEa5VQGv1UBVguH4+Gz9+85fHXGNy4gvGLlMv9cps5g1fXM5POkOEjsiKlN69HBCc/
 OCSlthX3z8MO65lZoIGAXm1fWApBKt71rtBNviEwfx/5f1fLc7/+nC5v0a/79bB14wDM
 nTn66zbSWI5ygxqJdeghiYZytyK70rrWMJAX/NoafwGa2P9HqXfXZnjdwJDHJC4UeBn0 sw== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050102.ppops.net-00190b01. with ESMTP id 34jhwwck3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 02 Nov 2020 18:23:57 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.42/8.16.0.42) with SMTP id 0A2IJatj015476;
        Mon, 2 Nov 2020 10:23:56 -0800
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint5.akamai.com with ESMTP id 34h5wane9e-1;
        Mon, 02 Nov 2020 10:23:56 -0800
Received: from [0.0.0.0] (prod-ssh-gw01.bos01.corp.akamai.com [172.27.119.138])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id CC45F3DB5B;
        Mon,  2 Nov 2020 18:23:55 +0000 (GMT)
Subject: Re: [PATCH v2 net] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "Hunt, Joshua" <johunt@akamai.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
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
 <de690c67-6e9f-8885-10c1-f47313de7b62@huawei.com>
 <cd4b2482-c3dc-fba6-6287-1218dc4bed6e@akamai.com>
 <ab88bf4e-e022-dafe-4150-7314bf70c817@huawei.com>
From:   Vishwanath Pai <vpai@akamai.com>
Message-ID: <36fb2ca8-493d-fabc-5220-abe7f5d5389f@akamai.com>
Date:   Mon, 2 Nov 2020 13:23:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <ab88bf4e-e022-dafe-4150-7314bf70c817@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_12:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020140
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-02_12:2020-11-02,2020-11-02 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 spamscore=0 clxscore=1011 impostorscore=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011020140
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=vpai@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 4:08 AM, Yunsheng Lin wrote:
 > On 2020/10/30 1:20, Vishwanath Pai wrote:
 >> On 10/29/20 6:24 AM, Yunsheng Lin wrote:
 >>> On 2020/10/29 12:50, Vishwanath Pai wrote:
 >>>> On 10/28/20 10:37 PM, Yunsheng Lin wrote:
 >>>>> On 2020/10/29 4:04, Vishwanath Pai wrote:
 >>>>>> On 10/28/20 1:47 PM, Cong Wang wrote:
 >>>>>>> On Wed, Oct 28, 2020 at 8:37 AM Pai, Vishwanath 
<vpai@akamai.com> wrote:
 >>>>>>>> Hi,
 >>>>>>>>
 >>>>>>>> We noticed some problems when testing the latest 5.4 LTS 
kernel and traced it
 >>>>>>>> back to this commit using git bisect. When running our tests 
the machine stops
 >>>>>>>> responding to all traffic and the only way to recover is a 
reboot. I do not see
 >>>>>>>> a stack trace on the console.
 >>>>>>>
 >>>>>>> Do you mean the machine is still running fine just the network 
is down?
 >>>>>>>
 >>>>>>> If so, can you dump your tc config with stats when the problem 
is happening?
 >>>>>>> (You can use `tc -s -d qd show ...`.)
 >>>>>>>
 >>>>>>>>
 >>>>>>>> This can be reproduced using the packetdrill test below, it 
should be run a
 >>>>>>>> few times or in a loop. You should hit this issue within a few 
tries but
 >>>>>>>> sometimes might take up to 15-20 tries.
 >>>>>>> ...
 >>>>>>>> I can reproduce the issue easily on v5.4.68, and after 
reverting this commit it
 >>>>>>>> does not happen anymore.
 >>>>>>>
 >>>>>>> This is odd. The patch in this thread touches netdev reset 
path, if packetdrill
 >>>>>>> is the only thing you use to trigger the bug (that is netdev is 
always active),
 >>>>>>> I can not connect them.
 >>>>>>>
 >>>>>>> Thanks.
 >>>>>>
 >>>>>> Hi Cong,
 >>>>>>
 >>>>>>> Do you mean the machine is still running fine just the network 
is down?
 >>>>>>
 >>>>>> I was able to access the machine via serial console, it looks 
like it is
 >>>>>> up and running, just that networking is down.
 >>>>>>
 >>>>>>> If so, can you dump your tc config with stats when the problem 
is happening?
 >>>>>>> (You can use `tc -s -d qd show ...`.)
 >>>>>>
 >>>>>> If I try running tc when the machine is in this state the 
command never
 >>>>>> returns. It doesn't print anything but doesn't exit either.
 >>>>>>
 >>>>>>> This is odd. The patch in this thread touches netdev reset 
path, if packetdrill
 >>>>>>> is the only thing you use to trigger the bug (that is netdev is 
always active),
 >>>>>>> I can not connect them.
 >>>>>>
 >>>>>> I think packetdrill creates a tun0 interface when it starts the
 >>>>>> test and tears it down at the end, so it might be hitting this 
code path
 >>>>>> during teardown.
 >>>>>
 >>>>> Hi, Is there any preparation setup before running the above 
packetdrill test
 >>>>> case, I run the above test case in 5.9-rc4 with this patch 
applied without any
 >>>>> preparation setup, did not reproduce it.
 >>>>>
 >>>>> By the way, I am newbie to packetdrill:), it would be good to 
provide the
 >>>>> detail setup to reproduce it,thanks.
 >>>>>
 >>>>>>
 >>>>>> P.S: My mail server is having connectivity issues with 
vger.kernel.org
 >>>>>> so messages aren't getting delivered to netdev. It'll hopefully get
 >>>>>> resolved soon.
 >>>>>>
 >>>>>> Thanks,
 >>>>>> Vishwanath
 >>>>>>
 >>>>>>
 >>>>>> .
 >>>>>>
 >>>>
 >>>> I can't reproduce it on v5.9-rc4 either, it is probably an issue 
only on
 >>>> 5.4 then (and maybe older LTS versions). Can you give it a try on
 >>>> 5.4.68?
 >>>>
 >>>> For running packetdrill, download the latest version from their github
 >>>> repo, then run it in a loop without any special arguments. This is 
what
 >>>> I do to reproduce it:
 >>>>
 >>>> while true; do ./packetdrill <test-file>; done
 >>>>
 >>>> I don't think any other setup is necessary.
 >>>
 >>> Hi, run the above test for above an hour using 5.4.68, still did not
 >>> reproduce it, as below:
 >>>
 >>>
 >>> root@(none)$ cd /home/root/
 >>> root@(none)$ ls
 >>> creat_vlan.sh  packetdrill    test.pd
 >>> root@(none)$ cat test.pd
 >>> 0 `echo 4 > /proc/sys/net/ipv4/tcp_min_tso_segs`
 >>>
 >>> 0.400 socket(..., SOCK_STREAM, IPPROTO_TCP) = 3
 >>> 0.400 setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
 >>>
 >>> // set maxseg to 1000 to work with both ipv4 and ipv6
 >>> 0.500 setsockopt(3, SOL_TCP, TCP_MAXSEG, [1000], 4) = 0
 >>> 0.500 bind(3, ..., ...) = 0
 >>> 0.500 listen(3, 1) = 0
 >>>
 >>> // Establish connection
 >>> 0.600 < S 0:0(0) win 32792 <mss 1000,sackOK,nop,nop,nop,wscale 5>
 >>> 0.600 > S. 0:0(0) ack 1 <...>
 >>>
 >>> 0.800 < . 1:1(0) ack 1 win 320
 >>> 0.800 accept(3, ..., ...) = 4
 >>>
 >>> // Send 4 data segments.
 >>> +0 write(4, ..., 4000) = 4000
 >>> +0 > P. 1:4001(4000) ack 1
 >>>
 >>> // Receive a SACK
 >>> +.1 < . 1:1(0) ack 1 win 320 <sack 1001:2001,nop,nop>
 >>>
 >>> +.3 %{ print "TCP CA state: ",tcpi_ca_state  }%
 >>> root@(none)$ cat creat_vlan.sh
 >>> #!/bin/sh
 >>>
 >>> for((i=0; i<10000; i++))
 >>> do
 >>>     ./packetdrill test.pd
 >>> done
 >>> root@(none)$ ./creat_vlan.sh
 >>> TCP CA state:  3
 >>> ^C
 >>> root@(none)$ ifconfig
 >>> eth0      Link encap:Ethernet  HWaddr 5c:e8:83:0d:f7:ed
 >>>           inet addr:192.168.1.93  Bcast:192.168.1.255 
Mask:255.255.255.0
 >>>           UP BROADCAST RUNNING MULTICAST  MTU:1500 Metric:1
 >>>           RX packets:3570 errors:0 dropped:0 overruns:0 frame:0
 >>>           TX packets:3190 errors:0 dropped:0 overruns:0 carrier:0
 >>>           collisions:0 txqueuelen:1000
 >>>           RX bytes:1076349 (1.0 MiB)  TX bytes:414874 (405.1 KiB)
 >>>
 >>> eth2      Link encap:Ethernet  HWaddr 5c:e8:83:0d:f7:ec
 >>>           inet addr:192.168.100.1 Bcast:192.168.100.255 
Mask:255.255.255.0
 >>>           UP BROADCAST RUNNING MULTICAST  MTU:1500 Metric:1
 >>>           RX packets:81848576 errors:0 dropped:0 overruns:0 frame:78
 >>>           TX packets:72497816 errors:0 dropped:0 overruns:0 carrier:0
 >>>           collisions:0 txqueuelen:1000
 >>>           RX bytes:2044282289568 (1.8 TiB)  TX bytes:2457441698852 
(2.2 TiB)
 >>>
 >>> lo        Link encap:Local Loopback
 >>>           inet addr:127.0.0.1  Mask:255.0.0.0
 >>>           UP LOOPBACK RUNNING  MTU:65536  Metric:1
 >>>           RX packets:1 errors:0 dropped:0 overruns:0 frame:0
 >>>           TX packets:1 errors:0 dropped:0 overruns:0 carrier:0
 >>>           collisions:0 txqueuelen:1000
 >>>           RX bytes:68 (68.0 B)  TX bytes:68 (68.0 B)
 >>>
 >>> root@(none)$ ./creat_vlan.sh
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> TCP CA state:  3
 >>> ^C
 >>> root@(none)$ cat /proc/cmdline
 >>> BOOT_IMAGE=/linyunsheng/Image.5.0 rdinit=/init 
console=ttyAMA0,115200 earlycon=pl011,mmio32,0x94080000 iommu.strict=1
 >>> root@(none)$ cat /proc/version
 >>> Linux version 5.4.68 (linyunsheng@ubuntu) (gcc version 5.4.0 
20160609 (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.12)) #1 SMP PREEMPT Thu Oct 
29 16:59:37 CST 2020
 >>> root@(none)$
 >>>
 >>>
 >>>
 >>>>
 >>>> -Vishwanath
 >>>>
 >>>> .
 >>>>
 >> I couldn't get it to reproduce on a ubuntu VM, maybe something is
 >> different with the way we setup our machines. We do have some scripts in
 >> /etc/network/{if-up.d,if-post-down.d} etc, or probably something else.
 >> I'll let you know when I can reliably reproduce it on the VM.
 >
 > Hi, Vishwanath
 >     Please see if the patch in the below link fix your problem, thanks.
 > 
https://urldefense.com/v3/__https://www.spinics.net/lists/netdev/msg695908.html__;!!GjvTz_vk!Gc1MbfkLP7lWuWFxK2Bauofrqq53Tt79VJaozx08T8cmH0dRxAXuilS7xFt0$ 

 >
 >>
 >> .
 >>

I tried out the patch on top of 5.4.71 and it fixes the issue for me
too. Thanks for the quick fix.

- Vishwanath


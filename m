Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67621737A
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbgGGQOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:14:25 -0400
Received: from foss.arm.com ([217.140.110.172]:60594 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727789AbgGGQOZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Jul 2020 12:14:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3BF9D1FB;
        Tue,  7 Jul 2020 09:14:23 -0700 (PDT)
Received: from [10.57.21.32] (unknown [10.57.21.32])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D424E3F68F;
        Tue,  7 Jul 2020 09:14:21 -0700 (PDT)
Subject: Re: [EXT] net: ethernet: freescale: fec: copybreak handling
 throughput, dma_sync_* optimisations allowed?
To:     Andy Duan <fugang.duan@nxp.com>, Kegl Rohit <keglrohit@gmail.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        'Christoph Hellwig' <hch@lst.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
References: <CAMeyCbjiVXFkzA5ZyJ5b3N4fotWkzKHVp3J=nT1yWs1v8dmRXA@mail.gmail.com>
 <AM6PR0402MB3607E9BD414FF850D577F76EFF6D0@AM6PR0402MB3607.eurprd04.prod.outlook.com>
 <CAMeyCbicX_8Kc_E5sanUMNtToLpj9BkcV+RR6h2FoNoxxcKJog@mail.gmail.com>
 <AM0PR0402MB36037EF37780AFFB14C0C5CEFF6D0@AM0PR0402MB3603.eurprd04.prod.outlook.com>
 <CAMeyCbjpaqMmPqY54UNeWMYf-OjYQq4MqOGpjMqvQvtJbhWjSA@mail.gmail.com>
 <AM6PR0402MB3607F2ED9FE22888EF3F3143FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
From:   Robin Murphy <robin.murphy@arm.com>
Message-ID: <01ed65bf-0d0e-86d7-a411-8903390a6b62@arm.com>
Date:   Tue, 7 Jul 2020 17:14:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR0402MB3607F2ED9FE22888EF3F3143FF660@AM6PR0402MB3607.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-07 04:44, Andy Duan wrote:
> Hi mm experts,
> 
> From: Kegl Rohit <keglrohit@gmail.com> Sent: Monday, July 6, 2020 10:18 PM
>> So you would also say a single dma_sync_single_for_cpu is enough.
>> You are right it would be great if some mm expert could have a look at it. If
>> any corruption could happen.
> 
> Kegl want to remove dma_sync_single_for_device(), who thinks the cost is
> not necessary, and only dma_sync_single_for_cpu() is enough,  do you have
> any comments ?

Although you could get away with it on modern Arm CPUs if you can 
absolutely guarantee that no cache lines could ever possibly be dirtied, 
other architectures may not have the exact same cache behaviour. Without 
an exceptionally good justification for non-standard API usage and 
rock-solid reasoning that it cannot possibly go wrong anywhere, it's 
better for everyone if you just stick with normal balanced calls. I see 
mention of i.MX6 below, which presumably means you've got a PL310 system 
cache in the mix too, and that is not something I would like to reason 
about even if you paid me to ;)

Now, if you're recycling a mapped buffer by syncing it back and forth to 
read new data between multiple updates, then performing partial syncs on 
only the region you want to access each time is something the API does 
explicitly support, so the patch originally proposed in this thread to 
do that looks superficially reasonable to me.

Robin.

> 
> Thanks!
>>
>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>> b/drivers/net/ethernet/freescale/fec_main.c
>> index 2d0d313ee..acc04726f 100644
>> --- a/drivers/net/ethernet/freescale/fec_main.c
>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> @@ -1387,9 +1387,9 @@ static bool fec_enet_copybreak(struct net_device
>> *ndev, struct sk_buff **skb,
>>                  return false;
>>
>>          dma_sync_single_for_cpu(&fep->pdev->dev,
>>                                  fec32_to_cpu(bdp->cbd_bufaddr),
>> -                               FEC_ENET_RX_FRSIZE - fep->rx_align,
>> +                               length,
>>                                  DMA_FROM_DEVICE);
>>          if (!swap)
>>                  memcpy(new_skb->data, (*skb)->data, length);
>>          else
>> @@ -1551,14 +1551,9 @@ fec_enet_rx_queue(struct net_device *ndev, int
>> budget, u16 queue_id)
>>                                                 vlan_tag);
>>
>>                  napi_gro_receive(&fep->napi, skb);
>>
>> -               if (is_copybreak) {
>> -                       dma_sync_single_for_device(&fep->pdev->dev,
>> -
>> fec32_to_cpu(bdp->cbd_bufaddr),
>> -
>> FEC_ENET_RX_FRSIZE
>> - fep->rx_align,
>> -
>> DMA_FROM_DEVICE);
>> -               } else {
>> +               if (!is_copybreak) {
>>                          rxq->rx_skbuff[index] = skb_new;
>>                          fec_enet_new_rxbdp(ndev, bdp, skb_new);
>>                  }
>>
>> Testing is pretty complex because of multiple different contexts.
>> To test the whole rx chain throughput i decided to use UDP with 200 bytes
>> payload.
>> Wireshark reports 242 bytes on wire, so copybreak is active (< 256 bytes).
>> I choose larger packets to reduce CPU load caused by the network stack /
>> iperf3.
>> Smaller packets will benefit even more, but for this test the network stack /
>> iperf3 could become the bottleneck not the driver itself (e.g.
>> to test call skb_free instead of napi_gro_receive).
>> iperf missbehaved sometimes and caused a lot more CPU load, so using
>> iperf3.
>> Kernelversion is Linux falcon 5.4.8-rt11-yocto-standard #59 SMP PREEMPT
>> Normaly our system has PREEMPT RT enabled. But I think to test throughput
>> PREEMPT is a better way to compare results.
>> NAPI and PREEMPT RT has even more contexts with the additional threaded
>> irq handler and therefore PREEMPT RT throughput is another story.
>> stress -m 1 --vm-bytes 100M was used to simulate additional memory load.
>> Only one core to keep ressources free for iperf3.
>>
>>
>> ###############################
>> # NOT PATCHED
>> ###############################
>> -------------------------------
>> - NOT STRESSED
>> -------------------------------
>> user@ws:~/$ iperf3 -c 192.168.1.2 -u -l 200 -b 100M -t 10 Connecting to host
>> 192.168.1.2, port 5201 [  4] local 192.168.1.1 port 52032 connected to
>> 192.168.1.2 port 5201
>> [ ID] Interval           Transfer     Bandwidth       Total Datagrams
>> [  4]   0.00-1.00   sec  8.06 MBytes  67.6 Mbits/sec  42279
>> [  4]   1.00-2.00   sec  8.93 MBytes  74.9 Mbits/sec  46800
>> [  4]   2.00-3.00   sec  8.92 MBytes  74.8 Mbits/sec  46771
>> [  4]   3.00-4.00   sec  8.91 MBytes  74.7 Mbits/sec  46701
>> [  4]   4.00-5.00   sec  8.92 MBytes  74.9 Mbits/sec  46792
>> [  4]   5.00-6.00   sec  8.93 MBytes  74.9 Mbits/sec  46840
>> [  4]   6.00-7.00   sec  8.90 MBytes  74.6 Mbits/sec  46636
>> [  4]   7.00-8.00   sec  8.95 MBytes  75.1 Mbits/sec  46924
>> [  4]   8.00-9.00   sec  8.91 MBytes  74.7 Mbits/sec  46716
>> [  4]   9.00-10.00  sec  8.89 MBytes  74.5 Mbits/sec  46592
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bandwidth       Jitter
>> Lost/Total Datagrams
>> [  4]   0.00-10.00  sec  88.3 MBytes  74.1 Mbits/sec  0.056 ms
>> 123112/463051 (27%)
>> [  4] Sent 463051 datagrams
>>
>> [root@imx6q ~]# iperf3 -s
>> Server listening on 5201
>> Accepted connection from 192.168.1.1, port 53394 [  5] local 192.168.1.2
>> port 5201 connected to 192.168.1.1 port 43224
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-1.00   sec  5.56 MBytes  46.6 Mbits/sec  0.046 ms
>> 5520/34650 (16%)
>> [  5]   1.00-2.00   sec  6.40 MBytes  53.7 Mbits/sec  0.050 ms
>> 13035/46576 (28%)
>> [  5]   2.00-3.00   sec  6.40 MBytes  53.7 Mbits/sec  0.044 ms
>> 13295/46854 (28%)
>> [  5]   3.00-4.00   sec  6.26 MBytes  52.5 Mbits/sec  0.056 ms
>> 13849/46692 (30%)
>> [  5]   4.00-5.00   sec  6.31 MBytes  53.0 Mbits/sec  0.052 ms
>> 13735/46833 (29%)
>> [  5]   5.00-6.00   sec  6.32 MBytes  53.0 Mbits/sec  0.054 ms
>> 13610/46761 (29%)
>> [  5]   6.00-7.00   sec  6.32 MBytes  53.0 Mbits/sec  0.043 ms
>> 13780/46931 (29%)
>> [  5]   7.00-8.00   sec  6.33 MBytes  53.1 Mbits/sec  0.051 ms
>> 13679/46848 (29%)
>> [  5]   8.00-9.00   sec  6.33 MBytes  53.1 Mbits/sec  0.050 ms
>> 13746/46912 (29%)
>> [  5]   9.00-10.00  sec  6.33 MBytes  53.1 Mbits/sec  0.043 ms
>> 13437/46626 (29%)
>> [  5]  10.00-10.17  sec  1.04 MBytes  52.5 Mbits/sec  0.044 ms
>> 2233/7684 (29%)
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-10.17  sec  63.6 MBytes  52.5 Mbits/sec  0.044 ms
>> 129919/463367 (28%)  receiver
>>
>> [root@imx6q ~]# mpstat -P ALL 4 1
>> Linux 5.4.8-rt11 03/17/00 _armv7l_ (4 CPU)
>> 23:38:51     CPU    %usr   %nice    %sys %iowait    %irq   %soft
>> %steal  %guest   %idle
>> 23:38:55     all    2.49    0.00   19.96    0.00    0.00   25.45
>> 0.00    0.00   52.10
>> 23:38:55       0    0.00    0.00    0.25    0.00    0.00   99.75
>> 0.00    0.00    0.00
>> 23:38:55       1    1.54    0.00   11.54    0.00    0.00    0.00
>> 0.00    0.00   86.92
>> 23:38:55       2    1.27    0.00    5.85    0.00    0.00    0.00
>> 0.00    0.00   92.88
>> 23:38:55       3    7.24    0.00   63.31    0.00    0.00    0.00
>> 0.00    0.00   29.46
>> => ksoftirqd/0 @ 100%; iperf @ 94%
>>
>> [root@imx6q ~]# sar -I 60 1
>> 00:13:32         INTR    intr/s
>> 00:13:33           60      0.00
>> 00:13:34           60      0.00
>> 00:13:35           60      0.00
>> 00:13:36           60      0.00
>> => 100% napi poll
>>
>>
>> -------------------------------
>> - STRESSED
>> - stress -m 1 --vm-bytes 100M &
>> -------------------------------
>> user@ws:~/$ iperf3 -c 192.168.1.2 -u -l 200 -b 100M -t 10 Connecting to host
>> 192.168.1.2, port 5201 [  4] local 192.168.1.1 port 52129 connected to
>> 192.168.1.2 port 5201
>> [ ID] Interval           Transfer     Bandwidth       Total Datagrams
>> [  4]   0.00-1.00   sec  8.09 MBytes  67.8 Mbits/sec  42399
>> [  4]   1.00-2.00   sec  8.88 MBytes  74.5 Mbits/sec  46552
>> [  4]   2.00-3.00   sec  8.92 MBytes  74.8 Mbits/sec  46780
>> [  4]   3.00-4.00   sec  8.91 MBytes  74.7 Mbits/sec  46688
>> [  4]   4.00-5.00   sec  8.91 MBytes  74.7 Mbits/sec  46712
>> [  4]   5.00-6.00   sec  8.91 MBytes  74.8 Mbits/sec  46724
>> [  4]   6.00-7.00   sec  8.95 MBytes  75.0 Mbits/sec  46900
>> [  4]   7.00-8.00   sec  8.95 MBytes  75.1 Mbits/sec  46928
>> [  4]   8.00-9.00   sec  8.93 MBytes  74.9 Mbits/sec  46796
>> [  4]   9.00-10.00  sec  8.91 MBytes  74.8 Mbits/sec  46732
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bandwidth       Jitter
>> Lost/Total Datagrams
>> [  4]   0.00-10.00  sec  88.4 MBytes  74.1 Mbits/sec  0.067 ms
>> 233989/463134 (51%)
>> [  4] Sent 463134 datagrams
>>
>> [root@imx6q ~]# iperf3 -s
>> Server listening on 5201
>> Accepted connection from 192.168.1.1, port 57892 [  5] local 192.168.1.2
>> port 5201 connected to 192.168.1.1 port 43729
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-1.00   sec  3.59 MBytes  30.1 Mbits/sec  0.071 ms
>> 13027/31836 (41%)
>> [  5]   1.00-2.00   sec  4.32 MBytes  36.2 Mbits/sec  0.075 ms
>> 23690/46345 (51%)
>> [  5]   2.00-3.00   sec  4.28 MBytes  35.9 Mbits/sec  0.040 ms
>> 24879/47293 (53%)
>> [  5]   3.00-4.00   sec  4.05 MBytes  34.0 Mbits/sec  0.055 ms
>> 24430/45651 (54%)
>> [  5]   4.00-5.00   sec  4.01 MBytes  33.6 Mbits/sec  0.130 ms
>> 25200/46209 (55%)
>> [  5]   5.00-6.00   sec  4.22 MBytes  35.4 Mbits/sec  0.052 ms
>> 24777/46902 (53%)
>> [  5]   6.00-7.00   sec  4.04 MBytes  33.9 Mbits/sec  0.057 ms
>> 24452/45635 (54%)
>> [  5]   7.00-8.00   sec  4.26 MBytes  35.7 Mbits/sec  0.063 ms
>> 26530/48871 (54%)
>> [  5]   8.00-9.00   sec  4.06 MBytes  34.1 Mbits/sec  0.061 ms
>> 24293/45583 (53%)
>> [  5]   9.00-10.00  sec  4.15 MBytes  34.8 Mbits/sec  0.155 ms
>> 24752/46499 (53%)
>> [  5]  10.00-10.25  sec   985 KBytes  32.5 Mbits/sec  0.069 ms
>> 6246/11291 (55%)
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-10.25  sec  41.9 MBytes  34.3 Mbits/sec  0.069 ms
>> 242276/462115 (52%)  receiver
>>
>> [root@imx6q ~]# mpstat -P ALL 4 1
>> Linux 5.4.8-rt11 03/17/00 _armv7l_ (4 CPU)
>> 23:43:12     CPU    %usr   %nice    %sys %iowait    %irq   %soft
>> %steal  %guest   %idle
>> 23:43:16     all    2.51    0.00   42.42    0.00    0.00   25.47
>> 0.00    0.00   29.59
>> 23:43:16       0    0.00    0.00    1.25    0.00    0.00   98.75
>> 0.00    0.00    0.00
>> 23:43:16       1    2.25    0.00   97.75    0.00    0.00    0.00
>> 0.00    0.00    0.00
>> 23:43:16       2    0.25    0.00    2.29    0.00    0.00    0.00
>> 0.00    0.00   97.46
>> 23:43:16       3    8.08    0.00   70.75    0.00    0.00    0.00
>> 0.00    0.00   21.17
>> => ksoftirqd/0 @ 100%; stress @ 100%; iperf3 @ 84%
>>
>> [root@imx6q ~]# sar -I 60 1
>> 00:14:41         INTR    intr/s
>> 00:14:42           60      0.00
>> 00:14:43           60      0.00
>> 00:14:44           60      0.00
>> => 100% napi poll
>>
>>
>> ###############################
>> # PATCHED
>> ###############################
>> -------------------------------
>> -NOT STRESSED
>> -------------------------------
>> user@ws:~/$ iperf3 -c 192.168.1.2 -u -l 200 -b 100M -t 10 Connecting to host
>> 192.168.1.2, port 5201 [  4] local 192.168.1.1 port 50177 connected to
>> 192.168.1.2 port 5201
>> [ ID] Interval           Transfer     Bandwidth       Total Datagrams
>> [  4]   0.00-1.00   sec  8.08 MBytes  67.8 Mbits/sec  42373
>> [  4]   1.00-2.00   sec  8.91 MBytes  74.7 Mbits/sec  46693
>> [  4]   2.00-3.00   sec  8.93 MBytes  74.9 Mbits/sec  46803
>> [  4]   3.00-4.00   sec  8.93 MBytes  74.9 Mbits/sec  46804
>> [  4]   4.00-5.00   sec  8.93 MBytes  74.9 Mbits/sec  46804
>> [  4]   5.00-6.00   sec  8.92 MBytes  74.8 Mbits/sec  46764
>> [  4]   6.00-7.00   sec  8.95 MBytes  75.1 Mbits/sec  46944
>> [  4]   7.00-8.00   sec  8.90 MBytes  74.7 Mbits/sec  46672
>> [  4]   8.00-9.00   sec  8.91 MBytes  74.8 Mbits/sec  46732
>> [  4]   9.00-10.00  sec  8.90 MBytes  74.7 Mbits/sec  46660
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bandwidth       Jitter
>> Lost/Total Datagrams
>> [  4]   0.00-10.00  sec  88.4 MBytes  74.1 Mbits/sec  0.032 ms
>> 16561/463165 (3.6%)
>> [  4] Sent 463165 datagrams
>>
>> [root@imx6q ~]# iperf3 -s
>> Server listening on 5201
>> Accepted connection from 192.168.1.1, port 45012 [  5] local 192.168.1.2
>> port 5201 connected to 192.168.1.1 port 50177
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-1.00   sec  7.36 MBytes  61.8 Mbits/sec  0.030 ms
>> 1430/40038 (3.6%)
>> [  5]   1.00-2.00   sec  8.60 MBytes  72.1 Mbits/sec  0.030 ms
>> 1757/46850 (3.8%)
>> [  5]   2.00-3.00   sec  8.61 MBytes  72.2 Mbits/sec  0.039 ms
>> 1690/46809 (3.6%)
>> [  5]   3.00-4.00   sec  8.61 MBytes  72.3 Mbits/sec  0.037 ms
>> 1650/46812 (3.5%)
>> [  5]   4.00-5.00   sec  8.59 MBytes  72.1 Mbits/sec  0.033 ms
>> 1589/46651 (3.4%)
>> [  5]   5.00-6.00   sec  8.60 MBytes  72.1 Mbits/sec  0.036 ms
>> 1904/46967 (4.1%)
>> [  5]   6.00-7.00   sec  8.61 MBytes  72.2 Mbits/sec  0.046 ms
>> 1633/46766 (3.5%)
>> [  5]   7.00-8.00   sec  8.60 MBytes  72.1 Mbits/sec  0.030 ms
>> 1748/46818 (3.7%)
>> [  5]   8.00-9.00   sec  8.61 MBytes  72.2 Mbits/sec  0.036 ms
>> 1572/46707 (3.4%)
>> [  5]   9.00-10.00  sec  8.61 MBytes  72.3 Mbits/sec  0.031 ms
>> 1538/46703 (3.3%)
>> [  5]  10.00-10.04  sec   389 KBytes  72.1 Mbits/sec  0.032 ms
>> 50/2044 (2.4%)
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-10.04  sec  85.2 MBytes  71.1 Mbits/sec  0.032 ms
>> 16561/463165 (3.6%)  receiver
>>
>> [root@imx6q ~]# mpstat -P ALL 4 1
>> Linux 5.4.8-rt11-yocto-standard  03/17/00 _armv7l_ (4 CPU)
>> 23:15:50     CPU    %usr   %nice    %sys %iowait    %irq   %soft
>> %steal  %guest   %idle
>> 23:15:54     all    3.06    0.00   26.11    0.00    0.00   11.09
>> 0.00    0.00   59.74
>> 23:15:54       0    0.00    0.00    0.00    0.00    0.00   86.44
>> 0.00    0.00   13.56
>> 23:15:54       1   10.25    0.00   89.50    0.00    0.00    0.25
>> 0.00    0.00    0.00
>> 23:15:54       2    0.00    0.00    0.00    0.00    0.00    0.00
>> 0.00    0.00  100.00
>> 23:15:54       3    0.00    0.00    0.00    0.00    0.00    0.00
>> 0.00    0.00  100.00
>> => ksoftirqd/* @ 0% CPU; iperf3 @ 100%
>>
>> [root@imx6q ~]# sar -I 60 1
>> 23:56:10         INTR    intr/s
>> 23:56:11           60  12339.00
>> 23:56:12           60  11476.00
>> => irq load high
>>
>>
>> -------------------------------
>> - STRESSED
>> - stress -m 1 --vm-bytes 100M &
>> -------------------------------
>> user@ws:~/$ iperf3 -c 192.168.1.2 -u -l 200 -b 100M -t 10 Connecting to host
>> 192.168.1.2, port 5201 [  4] local 192.168.1.1 port 59042 connected to
>> 192.168.1.2 port 5201
>> [ ID] Interval           Transfer     Bandwidth       Total Datagrams
>> [  4]   0.00-1.00   sec  7.92 MBytes  66.2 Mbits/sec  41527
>> [  4]   1.00-2.00   sec  8.95 MBytes  75.4 Mbits/sec  46931
>> [  4]   2.00-3.00   sec  8.95 MBytes  75.1 Mbits/sec  46923
>> [  4]   3.00-4.00   sec  8.96 MBytes  75.2 Mbits/sec  46983
>> [  4]   4.00-5.00   sec  8.96 MBytes  75.2 Mbits/sec  46999
>> [  4]   5.00-6.00   sec  8.91 MBytes  74.5 Mbits/sec  46688
>> [  4]   6.00-7.00   sec  8.93 MBytes  75.1 Mbits/sec  46824
>> [  4]   7.00-8.00   sec  8.94 MBytes  75.0 Mbits/sec  46872
>> [  4]   8.00-9.00   sec  8.91 MBytes  74.7 Mbits/sec  46700
>> [  4]   9.00-10.00  sec  8.91 MBytes  74.8 Mbits/sec  46720
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bandwidth       Jitter
>> Lost/Total Datagrams
>> [  4]   0.00-10.00  sec  88.3 MBytes  74.1 Mbits/sec  0.042 ms
>> 70360/462955 (15%)
>> [  4] Sent 462955 datagrams
>>
>>
>> [root@imx6q ~]# iperf3 -s
>> Server listening on 5201
>> Accepted connection from 192.168.1.1, port 46306 [  5] local 192.168.1.2
>> port 5201 connected to 192.168.1.1 port 59042
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-1.00   sec  6.54 MBytes  54.8 Mbits/sec  0.038 ms
>> 5602/39871 (14%)
>> [  5]   1.00-2.00   sec  7.51 MBytes  63.0 Mbits/sec  0.037 ms
>> 6973/46362 (15%)
>> [  5]   2.00-3.00   sec  7.54 MBytes  63.3 Mbits/sec  0.037 ms
>> 7414/46966 (16%)
>> [  5]   3.00-4.00   sec  7.56 MBytes  63.4 Mbits/sec  0.038 ms
>> 7354/46984 (16%)
>> [  5]   4.00-5.00   sec  7.60 MBytes  63.7 Mbits/sec  0.031 ms
>> 7241/47069 (15%)
>> [  5]   5.00-6.00   sec  7.58 MBytes  63.6 Mbits/sec  0.033 ms
>> 7134/46865 (15%)
>> [  5]   6.00-7.00   sec  7.56 MBytes  63.5 Mbits/sec  0.058 ms
>> 6991/46649 (15%)
>> [  5]   7.00-8.00   sec  7.57 MBytes  63.5 Mbits/sec  0.043 ms
>> 7259/46933 (15%)
>> [  5]   8.00-9.00   sec  7.56 MBytes  63.4 Mbits/sec  0.038 ms
>> 7065/46721 (15%)
>> [  5]   9.00-10.00  sec  7.55 MBytes  63.3 Mbits/sec  0.042 ms
>> 7002/46588 (15%)
>> [  5]  10.00-10.04  sec   317 KBytes  61.8 Mbits/sec  0.042 ms
>> 325/1947 (17%)
>> - - - - - - - - - - - - - - - - - - - - - - - - -
>> [ ID] Interval           Transfer     Bitrate         Jitter
>> Lost/Total Datagrams
>> [  5]   0.00-10.04  sec  74.9 MBytes  62.6 Mbits/sec  0.042 ms
>> 70360/462955 (15%)  receiver
>>
>>
>> [root@imx6q ~]# mpstat -P ALL 4 1
>> Linux 5.4.8-rt11-yocto-standard 03/17/00 _armv7l_ (4 CPU)
>> 23:49:59     CPU    %usr   %nice    %sys %iowait    %irq   %soft
>> %steal  %guest   %idle
>> 23:50:03     all    3.21    0.00   47.27    0.00    0.00   25.02
>> 0.00    0.00   24.51
>> 23:50:03       0    0.00    0.00    0.50    0.00    0.00   99.50
>> 0.00    0.00    0.00
>> 23:50:03       1    0.00    0.00    0.26    0.00    0.00    0.00
>> 0.00    0.00   99.74
>> 23:50:03       2    9.50    0.00   90.50    0.00    0.00    0.00
>> 0.00    0.00    0.00
>> 23:50:03       3    3.01    0.00   96.99    0.00    0.00    0.00
>> 0.00    0.00    0.00
>> => ksoftirqd/0 @ 92%; stress @ 100%; iperf3 @ 100%
>>
>> [root@imx6q ~]# sar -I 60 1
>> 23:57:08           60    505.00
>> 23:57:09           60    748.00
>> 23:57:10           60    416.00
>> => irq load low => napi active but not all the time
>>
>> ==============================================================
>> =
>>
>> As a result the patched system stressed with memory load has a higher
>> throughput than the unpatched system without memory stress.
>> The system could nearly keep up with the desktop sending @ 75MBit/s
>> (100MBit/s link) with i210 / igb.
>> I think IRQ/s could reach a new peak because of the faster napi_poll /
>> rx_queue execution times.
>> iperf, iperf3 is mainly to test throughput. Is there any tool which checks for
>> connection reliability (packet content, sequence, ...)?
>>
>> On Thu, Jul 2, 2020 at 11:14 AM Andy Duan <fugang.duan@nxp.com> wrote:
>>>
>>> From: Kegl Rohit <keglrohit@gmail.com> Sent: Thursday, July 2, 2020
>>> 3:39 PM
>>>> On Thu, Jul 2, 2020 at 6:18 AM Andy Duan <fugang.duan@nxp.com>
>> wrote:
>>>>> That should ensure the whole area is not dirty.
>>>>
>>>> dma_sync_single_for_cpu() and dma_sync_single_for_device() can or
>>>> must be used in pairs?
>>>> So in this case it is really necessary to sync back the skb data
>>>> buffer via dma_sync_single_for_device? Even when the CPU does not
>>>> change any bytes in the skb data buffer / readonly like in this case.
>>>
>>> No, if the buffer is not modified, dma_sync_single_for_device() is not
>> necessary.
>>>
>>> For some arm64 core, the dcache invalidate on A53 is flush +
>>> invalidate, once the buffer is modified, it will cause read back wrong data
>> without dma_sync_single_for_device().
>>> And the driver also support Coldfire platforms, I am not family with the arch.
>>>
>>>  From current analyze for arm/arm64,  I also think
>>> dma_sync_single_for_device() is not necessary due to the buffer is not
>> modified.
>>>
>>> Anyway, it still need to get other experts comment, and it need to do many
>> test and stress test.
>>>
>>>> And there is no DMA_BIDIRECTIONAL mapping.
>>>>
>>>> I thought copybreak it is not about the next frame size. It is about
>>>> the current frame. And the actual length is known via the size field
>>>> in the finished DMA descriptor.
>>>> Or do you mean that the next received frame could be no copybreak
>> frame.
>>>> 1. Rx copybreakable frame with sizeX < copybreak 2. copybreak
>>>> dma_sync_single_for_cpu(dmabuffer, sizeX) 3. copybreak alloc
>>>> new_skb, memcpy(new_skb, dmabuffer, sizeX) 4. copybreak
>>>> dma_sync_single_for_device(dmabuffer, sizeX) 5. Rx non copybreakable
>>>> frame with sizeY >= copybreak 4. dma_unmap_single(dmabuffer,
>>>> FEC_ENET_RX_FRSIZE - fep->rx_align) is called and can cause data
>>>> corruption because not all bytes were marked dirty even if nobody
>>>> DMA & CPU touched them?
>>>
>>> No CPU touch, it should be clean.
>>>>
>>>>>> I am new to the DMA API on ARM. Are these changes regarding
>>>>>> cache flushing,... allowed? These would increase the copybreak
>>>>>> throughput by reducing CPU load.
>>>>>
>>>>> To avoid FIFO overrun, it requires to ensure PHY pause frame is enabled.
>>>>
>>>> As the errata states this is also not always true, because the first
>>>> xoff could arrive too late. Pause frames/flow control is not really
>>>> common and could cause troubles with other random network
>> components
>>>> acting different or not supporting pause frames correctly. For
>>>> example the driver itself does enable pause frames for Gigabit by
>>>> default. But we have no Gigabit Phy so no FEC_QUIRK_HAS_GBIT and
>>>> therefore pause frames are not supported by the driver as of now.
>>>>
>>>>
>>>> It looks like copybreak is implemented similar to e1000_main.c
>>>> e1000_copybreak().
>>>> There is only the real/needed packet length (length =
>>>> le16_to_cpu(rx_desc->length)) is synced via dma_sync_single_for_cpu
>>>> and no dma_sync_single_for_device.
>>>>
>>>> Here is a diff with the previous changes assuming that
>>>> dma_sync_single_for_device must be used to avoid any cache flush
>>>> backs even when no data was changed.
>>>
>>> Below change seems fine, can you collect some data before you send out
>>> the patch for review.
>>> - run iperf stress test to ensure the stability
>>> - collect the performance improvement data
>>>
>>> Thanks.
>>>>
>>>> diff --git a/drivers/net/ethernet/freescale/fec_main.c
>>>> b/drivers/net/ethernet/freescale/fec_main.c
>>>> index 2d0d313ee..464783c15 100644
>>>> --- a/drivers/net/ethernet/freescale/fec_main.c
>>>> +++ b/drivers/net/ethernet/freescale/fec_main.c
>>>> @@ -1387,9 +1387,9 @@ static bool fec_enet_copybreak(struct
>>>> net_device *ndev, struct sk_buff **skb,
>>>>                  return false;
>>>>
>>>>          dma_sync_single_for_cpu(&fep->pdev->dev,
>>>>
>> fec32_to_cpu(bdp->cbd_bufaddr),
>>>> -                               FEC_ENET_RX_FRSIZE -
>> fep->rx_align,
>>>> +                               length,
>>>>                                  DMA_FROM_DEVICE);
>>>>          if (!swap)
>>>>                  memcpy(new_skb->data, (*skb)->data, length);
>>>>          else
>>>> @@ -1413,8 +1413,9 @@ fec_enet_rx_queue(struct net_device *ndev,
>> int
>>>> budget, u16 queue_id)
>>>>          unsigned short status;
>>>>          struct  sk_buff *skb_new = NULL;
>>>>          struct  sk_buff *skb;
>>>>          ushort  pkt_len;
>>>> +       ushort  pkt_len_nofcs;
>>>>          __u8 *data;
>>>>          int     pkt_received = 0;
>>>>          struct  bufdesc_ex *ebdp = NULL;
>>>>          bool    vlan_packet_rcvd = false;
>>>> @@ -1479,9 +1480,10 @@ fec_enet_rx_queue(struct net_device *ndev,
>>>> int budget, u16 queue_id)
>>>>                  /* The packet length includes FCS, but we don't want
>> to
>>>>                   * include that when passing upstream as it messes
>> up
>>>>                   * bridging applications.
>>>>                   */
>>>> -               is_copybreak = fec_enet_copybreak(ndev, &skb, bdp,
>>>> pkt_len - 4,
>>>> +               pkt_len_nofcs = pkt_len - 4;
>>>> +               is_copybreak = fec_enet_copybreak(ndev, &skb, bdp,
>>>> pkt_len_nofcs,
>>>>
>> need_swap);
>>>>                  if (!is_copybreak) {
>>>>                          skb_new = netdev_alloc_skb(ndev,
>>>> FEC_ENET_RX_FRSIZE);
>>>>                          if (unlikely(!skb_new)) { @@ -1554,9
>> +1556,9
>>>> @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16
>>>> queue_id)
>>>>
>>>>                  if (is_copybreak) {
>>>>
>> dma_sync_single_for_device(&fep->pdev->dev,
>>>>
>>>> fec32_to_cpu(bdp->cbd_bufaddr),
>>>> -
>>>> FEC_ENET_RX_FRSIZE
>>>> - fep->rx_align,
>>>> +
>>>> pkt_len_nofcs,
>>>>
>>>> DMA_FROM_DEVICE);
>>>>                  } else {
>>>>                          rxq->rx_skbuff[index] = skb_new;
>>>>                          fec_enet_new_rxbdp(ndev, bdp, skb_new);

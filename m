Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A40910ED11
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 17:24:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727539AbfLBQYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 11:24:15 -0500
Received: from smtp11.iq.pl ([86.111.242.220]:56537 "EHLO smtp11.iq.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727484AbfLBQYP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Dec 2019 11:24:15 -0500
Received: from [192.168.2.111] (unknown [185.78.72.18])
        (Authenticated sender: pstaszewski@itcare.pl)
        by smtp.iq.pl (Postfix) with ESMTPSA id 47RVmq2m8hz3xDN;
        Mon,  2 Dec 2019 17:24:11 +0100 (CET)
Subject: Re: Linux kernel - 5.4.0+ (net-next from 27.11.2019) routing/network
 performance
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@gmail.com>,
        netdev@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>
References: <81ad4acf-c9b4-b2e8-d6b1-7e1245bce8a5@itcare.pl>
 <589d2715-80ae-0478-7e31-342060519320@gmail.com>
 <8e17a844-e98b-59b1-5a0e-669562b3178c@itcare.pl>
 <9c5c6dc9b7eb78c257d67c85ed2a6e0998ec8907.camel@redhat.com>
From:   =?UTF-8?Q?Pawe=c5=82_Staszewski?= <pstaszewski@itcare.pl>
Message-ID: <38f3e518-f41d-8e03-a6b9-7337566b8e04@itcare.pl>
Date:   Mon, 2 Dec 2019 17:23:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <9c5c6dc9b7eb78c257d67c85ed2a6e0998ec8907.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 02.12.2019 o 11:53, Paolo Abeni pisze:
> On Mon, 2019-12-02 at 11:09 +0100, Paweł Staszewski wrote:
>> W dniu 01.12.2019 o 17:05, David Ahern pisze:
>>> On 11/29/19 4:00 PM, Paweł Staszewski wrote:
>>>> As always - each year i need to summarize network performance for
>>>> routing applications like linux router on native Linux kernel (without
>>>> xdp/dpdk/vpp etc) :)
>>>>
>>> Do you keep past profiles? How does this profile (and traffic rates)
>>> compare to older kernels - e.g., 5.0 or 4.19?
>>>
>>>
>> Yes - so for 4.19:
>>
>> Max bandwidth was about 40-42Gbit/s RX / 40-42Gbit/s TX of
>> forwarded(routed) traffic
>>
>> And after "order-0 pages" patches - max was 50Gbit/s RX + 50Gbit/s TX
>> (forwarding - bandwidth max)
>>
>> (current kernel almost doubled this)
> Looks like we are on the good track ;)
>
> [...]
>> After "order-0 pages" patch
>>
>>      PerfTop:  104692 irqs/sec  kernel:99.5%  exact:  0.0% [4000Hz
>> cycles],  (all, 56 CPUs)
>> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>>
>>        9.06%  [kernel]       [k] mlx5e_skb_from_cqe_mpwrq_linear
>>        6.43%  [kernel]       [k] tasklet_action_common.isra.21
>>        5.68%  [kernel]       [k] fib_table_lookup
>>        4.89%  [kernel]       [k] irq_entries_start
>>        4.53%  [kernel]       [k] mlx5_eq_int
>>        4.10%  [kernel]       [k] build_skb
>>        3.39%  [kernel]       [k] mlx5e_poll_tx_cq
>>        3.38%  [kernel]       [k] mlx5e_sq_xmit
>>        2.73%  [kernel]       [k] mlx5e_poll_rx_cq
> Compared to the current kernel perf figures, it looks like most of the
> gains come from driver changes.
>
> [... current perf figures follow ...]
>> ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>>
>>
>>        7.56%  [kernel]       [k] __dev_queue_xmit
> This is a bit surprising to me. I guess this is due
> '__dev_queue_xmit()' being calling twice per packet (team, NIC) and due
> to the retpoline overhead.
>
>>        1.74%  [kernel]       [k] tcp_gro_receive
> If the reference use-case is with a quite large number of cuncurrent
> flows, I guess you can try disabling GRO

Disabling GRO with teamed interfaces is not good cause after disabling 
GRO on physical interfaces cpu load is about 10% higher on all cores.

And observation:

Enabled GRO on interfaces vs team0 packets per second:

   iface                   Rx                   Tx Total
==============================================================================
             team0:     5952483.50 KB/s      6028436.50 KB/s 11980919.00 
KB/s
----------------------------------------------------------------------------

And softnetstats:

CPU          total/sec     dropped/sec    squeezed/sec 
collision/sec      rx_rps/sec  flow_limit/sec
CPU:00         1014977               0 35               0               
0               0
CPU:01         1074461               0 30               0               
0               0
CPU:02         1020460               0 34               0               
0               0
CPU:03         1077624               0 34               0               
0               0
CPU:04         1005102               0 32               0               
0               0
CPU:05         1097107               0 46               0               
0               0
CPU:06          997877               0 24               0               
0               0
CPU:07         1056216               0 34               0               
0               0
CPU:08          856567               0 34               0               
0               0
CPU:09          862527               0 23               0               
0               0
CPU:10          876107               0 34               0               
0               0
CPU:11          759275               0 27               0               
0               0
CPU:12          817307               0 27               0               
0               0
CPU:13          868073               0 21               0               
0               0
CPU:14          837783               0 34               0               
0               0
CPU:15          817946               0 27               0               
0               0
CPU:16          785500               0 25               0               
0               0
CPU:17          851276               0 28               0               
0               0
CPU:18          843888               0 29               0               
0               0
CPU:19          924840               0 34               0               
0               0
CPU:20          884879               0 37               0               
0               0
CPU:21          841461               0 28               0               
0               0
CPU:22          819436               0 32               0               
0               0
CPU:23          872843               0 32               0               
0               0

Summed:       21863531               0 740               0               
0               0


Disabled GRO on interfaces vs team0 packets per second:

   iface                   Rx                   Tx Total
==============================================================================
             team0:     5952483.50 KB/s      6028436.50 KB/s 11980919.00 
KB/s
----------------------------------------------------------------------------

And softnet stat:

CPU          total/sec     dropped/sec    squeezed/sec 
collision/sec      rx_rps/sec  flow_limit/sec
CPU:00          625288               0 23               0               
0               0
CPU:01          605239               0 24               0               
0               0
CPU:02          644965               0 26               0               
0               0
CPU:03          620264               0 30               0               
0               0
CPU:04          603416               0 25               0               
0               0
CPU:05          597838               0 23               0               
0               0
CPU:06          580028               0 22               0               
0               0
CPU:07          604274               0 23               0               
0               0
CPU:08          556119               0 26               0               
0               0
CPU:09          494997               0 23               0               
0               0
CPU:10          514759               0 23               0               
0               0
CPU:11          500333               0 22               0               
0               0
CPU:12          497956               0 23               0               
0               0
CPU:13          535194               0 14               0               
0               0
CPU:14          504304               0 24               0               
0               0
CPU:15          489015               0 18               0               
0               0
CPU:16          487249               0 24               0               
0               0
CPU:17          472023               0 23               0               
0               0
CPU:18          539454               0 24               0               
0               0
CPU:19          499901               0 19               0               
0               0
CPU:20          479945               0 26               0               
0               0
CPU:21          486800               0 29               0               
0               0
CPU:22          466916               0 26               0               
0               0
CPU:23          559730               0 34               0               
0               0

Summed:       12966008               0 573               0               
0               0

Maybee without team it will be better.

>
> Cheers,
>
> Paolo
>
-- 
Paweł Staszewski


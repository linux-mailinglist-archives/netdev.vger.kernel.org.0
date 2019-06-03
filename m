Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96E9233183
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 15:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbfFCNvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 09:51:00 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:38336 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbfFCNu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 09:50:59 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x53DokHU081801;
        Mon, 3 Jun 2019 08:50:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1559569846;
        bh=NdovAWZTPscVD4sa6lqUt3AjBE008dxgbM7KZYjTAQ4=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=hb4bNjmPBde10Nq+b2N7lJjFt3f19MAAsxWeNw8vgPAGV/zKxncfKcW38yw/AKxF3
         zHHQjdBaIevyu1/M3zhRWtI1R4wi7lIBj53MwGSit5+vIowvD3Rm+WKrludOrZ3Txt
         DMA08Gi7mQpnulmHqlrW9lW2mLt/4cUHa4Xok1hg=
Received: from DFLE105.ent.ti.com (dfle105.ent.ti.com [10.64.6.26])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x53DokXu095906
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 3 Jun 2019 08:50:46 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 3 Jun
 2019 08:50:45 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Mon, 3 Jun 2019 08:50:45 -0500
Received: from [158.218.117.39] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x53DojxA009754;
        Mon, 3 Jun 2019 08:50:45 -0500
Subject: Re: [PATCH net-next v1 0/7] net/sched: Add txtime assist support for
 taprio
To:     Vedang Patel <vedang.patel@intel.com>, <netdev@vger.kernel.org>
CC:     <jeffrey.t.kirsher@intel.com>, <davem@davemloft.net>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <intel-wired-lan@lists.osuosl.org>, <vinicius.gomes@intel.com>,
        <l@dorileo.org>
References: <1559065608-27888-1-git-send-email-vedang.patel@intel.com>
 <007b6a78-48e7-e667-d84b-dec745f84603@ti.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <4c4ec746-4282-ad3a-351c-1c7a355d093d@ti.com>
Date:   Mon, 3 Jun 2019 09:54:56 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <007b6a78-48e7-e667-d84b-dec745f84603@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/03/2019 09:50 AM, Murali Karicheri wrote:
> Hi Vedang,
> 
> On 05/28/2019 01:46 PM, Vedang Patel wrote:
>> Currently, we are seeing packets being transmitted outside their 
>> timeslices. We
>> can confirm that the packets are being dequeued at the right time. So, 
>> the
>> delay is induced after the packet is dequeued, because taprio, without 
>> any
>> offloading, has no control of when a packet is actually transmitted.
>>
>> In order to solve this, we are making use of the txtime feature 
>> provided by ETF
>> qdisc. Hardware offloading needs to be supported by the ETF qdisc in 
>> order to
>> take advantage of this feature. The taprio qdisc will assign txtime (in
>> skb->tstamp) for all the packets which do not have the txtime 
>> allocated via the
>> SO_TXTIME socket option. For the packets which already have SO_TXTIME 
>> set,
>> taprio will validate whether the packet will be transmitted in the 
>> correct
>> interval.
>>
>> In order to support this, the following parameters have been added:
>> - offload (taprio): This is added in order to support different 
>> offloading
>>    modes which will be added in the future.
>> - txtime-delay (taprio): this is the time the packet takes to traverse 
>> through
>>    the kernel to adapter card.
> 
> I am very new to this TC and QoS handling of Linux kernel and TSN. So 
> sorry some of the  questions below are very basic in nature. I would 
> soon would be working to add this support in our platform based on this.
> So please answer.
> 
> Is txtime-delay from the instance qdisc de-queue the packet to the time
> packets get onto the wire? I am wondering if this time is deterministic
> or we have some way to ensure this can be tuned to meet a max value?
> Also how would one calculate this value or have to measure it?
> 
>> - skip_sock_check (etf): etf qdisc currently drops any packet which 
>> does not
>>    have the SO_TXTIME socket option set. This check can be skipped by 
>> specifying
>>    this option.
>>
>> Following is an example configuration:
>>
>> $ tc qdisc replace dev $IFACE parent root handle 100 taprio \\
>>        num_tc 3 \\
>>        map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \\
>>        queues 1@0 1@0 1@0 \\
>>        base-time $BASE_TIME \\
>>        sched-entry S 01 300000 \\
>>        sched-entry S 02 300000 \\
>>        sched-entry S 04 400000 \\
>>        offload 2 \\
>>        txtime-delay 40000 \\
>>        clockid CLOCK_TAI
>>
> 
> Could you tell me what is CLOCK_TAI?? I see below in the source code for
> the definition in include/uapi/linux/time.h
> 
> /*
>   * The driver implementing this got removed. The clock ID is kept as a
>   * place holder. Do not reuse!
>   */
> #define CLOCK_SGI_CYCLE            10
> #define CLOCK_TAI            11
> 
> So why do I see such defines being used in the example that is being
> removed?
> 
> AFAIK, From the usage point of view, TSN requires the network being
> synchronized through linux PTP. For synchronization phc2sys is used to
> synchronize system time to the PHC. So why don't one use system time for
> this?
> 
> So application will use clock_gettime() to know current time and
> schedule the packet for transmission as well as user would use scripts
> or such to check current system time and issue tc command above. So the
> command should use CLOCK_REALTIME in that case. So all h/w and software
> are aligned to the same time source. Or Have I understood it wrong? I am
> assuming that for the offloaded case, h/w schedule Gate open, send
> packet etc are synchronized to the PHC or use a translated time w.r.t 
> the common time (network time. Assuming PHC tracks this).
> 
> Thanks in advance for clarifying this.
> 
>> $ tc qdisc replace dev $IFACE parent 100:1 etf \\
>>        offload delta 200000 clockid CLOCK_TAI skip_sock_check
>>
>> Here, the "offload" parameter is indicating that the TXTIME_OFFLOAD 
>> mode is
>> enabled. Also, that all the traffic classes have been assigned the 
>> same queue.

Actually the tc class is mapped to the same queue in the previous
command, not this one, right?

Murali
>> This is to prevent the traffic classes in the lower priority queues from
>> getting starved. Note that this configuration is specific to the i210 
>> ethernet
>> card. Other network cards where the hardware queues are given the same
>> priority, might be able to utilize more than one queue.
>>
>> Following are some of the other highlights of the series:
>> - Fix a bug where hardware timestamping and SO_TXTIME options cannot 
>> be used
>>    together. (Patch 1)
>> - Introduce hardware offloading. This patch introduces offload 
>> parameter which
>>    can be used to enable the txtime offload mode. It will also support 
>> enabling
>>    full offload when the support is available in drivers. (Patch 3)
>> - Make TxTime assist mode work with TCP packets. (Patch 6 & 7)
>>
>>
>> The following changes are recommended to be done in order to get the best
>> performance from taprio in this mode:
>> # ip link set dev enp1s0 mtu 1514
> 
> May I know why MTU is changed to 1514 to include the Ethernet header?
> 
>> # ethtool -K eth0 gso off
>> # ethtool -K eth0 tso off
>> # ethtool --set-eee eth0 eee off
> 
> Could you please explain why these are needed?
> 
> Thanks
> 
> Murali
>>
>> Thanks,
>> Vedang Patel
>>
>> Vedang Patel (6):
>>    igb: clear out tstamp after sending the packet.
>>    etf: Add skip_sock_check
>>    taprio: calculate cycle_time when schedule is installed
>>    taprio: Add support for txtime offload mode.
>>    taprio: make clock reference conversions easier
>>    taprio: Adjust timestamps for TCP packets.
>>
>> Vinicius Costa Gomes (1):
>>    taprio: Add the skeleton to enable hardware offloading
>>
>>   drivers/net/ethernet/intel/igb/igb_main.c |   1 +
>>   include/uapi/linux/pkt_sched.h            |   6 +
>>   net/sched/sch_etf.c                       |  10 +
>>   net/sched/sch_taprio.c                    | 548 ++++++++++++++++++++--
>>   4 files changed, 532 insertions(+), 33 deletions(-)
>>
> 
> 


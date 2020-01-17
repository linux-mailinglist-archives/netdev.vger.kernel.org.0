Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3971413EE
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 23:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729861AbgAQWKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 17:10:50 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:37122 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbgAQWKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 17:10:50 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00HMAkm6039475;
        Fri, 17 Jan 2020 16:10:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1579299046;
        bh=EcpPZ2UecspU2qUjha7C/rkf5esfC0LniQqhBi1UlHU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=RpQIQw4GyHpr6PGqRIPMr/VfX8bWeUKqZQXyVIz7je/p7aVGI4uTtxvJ4CMneuxFB
         +w0fUZVqlNyLp+MSi6pCEUxcEoSnvtqBnvWFHtG4yw6xZD6vvWmMaPrHhtJJmS3bIS
         wuz1X6piy0iGqK8/i2BatsrGvsvCm4AiuVHe+dCE=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00HMAk0Q023306;
        Fri, 17 Jan 2020 16:10:46 -0600
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 17
 Jan 2020 16:10:46 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 17 Jan 2020 16:10:46 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00HMAjd2051824;
        Fri, 17 Jan 2020 16:10:45 -0600
Subject: Re: [PATCH iproute2-next] taprio: Add support for the SetAndHold and
 SetAndRelease commands
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Joao Pinto <Joao.Pinto@synopsys.com>,
        David Ahern <dsahern@gmail.com>
References: <060ba6e2de48763aec25df3ed87b64f86022f8b1.1576591746.git.Jose.Abreu@synopsys.com>
 <874kxxck0m.fsf@linux.intel.com>
 <BN8PR12MB3266C894D60449BD86E7CE69D3530@BN8PR12MB3266.namprd12.prod.outlook.com>
 <a911e7b4-bb62-8dfb-43cb-ee6ff78c9415@ti.com>
 <BN8PR12MB3266149B178B38583E35D18AD33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <076a012b-a699-abac-ca04-56201036fb1d@ti.com>
Date:   Fri, 17 Jan 2020 17:18:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <BN8PR12MB3266149B178B38583E35D18AD33F0@BN8PR12MB3266.namprd12.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jose,

On 01/07/2020 04:27 AM, Jose Abreu wrote:
> From: Murali Karicheri <m-karicheri2@ti.com>
> Date: Jan/03/2020, 22:24:14
> (UTC+00:00)
> 
>> So you have one sched entry that specify SetAndHold for all remaining
>> queues. So this means, queue 0 will never get sent. I guess you also
>> support SetAndRelease so that a mix of SetAndHold followed by
>> SetAndRelease can be sent to enable sending from Queue 0. Is that
>> correct?
>>
>> Something like
>>                 sched-entry H 02 300000 \ <=== 300 usec tx from Q1
>>                 sched-entry R 01 200000   <=== 300 usec tx from Q0
>>
>> Just trying to understand how this is being used for real world
>> application.
> 
> This is the command I use:
> 
> # tc qdisc add dev $intf handle 100: parent root taprio \
> 	num_tc 4 \
> 	map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
> 	base-time $base \
> 	cycle-time 1000000 \
> 	sched-entry R 00 100000 \
> 	sched-entry H 02 200000 \
> 	sched-entry H 04 300000 \
> 	sched-entry H 08 400000 \
> 	flags 0x2
> # sleep 2
> # iperf3 -c <ip> -u -b 0 -t 15 &
> # sleep 5
> # echo "Queue 3: Expected=40%, Queue 0 will now be preempted"
> # tperf -i <ethX> -p 3
> 
> This will basically preempt Queue 0 and flood Queue 3 with express
> traffic.
I see you don't include Q0 in your schedule. Why is that the case?

Why is the entry with zero mask introduced (first entry)? Typo?
I thought it should be like below. No?

 > # tc qdisc add dev $intf handle 100: parent root taprio \
 > 	num_tc 4 \
 > 	map 0 1 2 3 3 3 3 3 3 3 3 3 3 3 3 3 \
 > 	base-time $base \
 > 	cycle-time 1000000 \
 > 	sched-entry R 01 100000 \
 > 	sched-entry H 02 200000 \
 > 	sched-entry H 04 300000 \
 > 	sched-entry H 08 400000 \
 > 	flags 0x2

Based on my understanding, if holdAdvance is t1 and releaseAdvance is
t2, hold is asserted t1 nano second before Q1 slot (during first
entry) begins and release is asserted t2 nano second before the start of
Q0 slot (during fourth entry) so that pre-emptable frame start 
transmission during first entry.

I thought R/H entries are a replacement for zero mask entry that
are introduced in the schedule as a guard band before express queue
slot when frame pre-emption not supported. Is my understanding correct?

So the above make sense?

Regards,

Murali
> 
> You can find tperf utility here: https://github.com/joabreu/tperf
> 
> ---
> Thanks,
> Jose Miguel Abreu
> 

-- 
Murali Karicheri
Texas Instruments

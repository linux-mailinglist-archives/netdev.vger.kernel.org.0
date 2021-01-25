Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55EA304B3B
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbhAZEsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:48:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3116 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbhAYJRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 04:17:21 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B600e8c500000>; Mon, 25 Jan 2021 01:16:01 -0800
Received: from [172.27.12.21] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Jan
 2021 09:15:58 +0000
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
CC:     Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
 <20210114130238.GA2676@horizon.localdomain>
 <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
 <20210114215052.GB2676@horizon.localdomain>
 <009bd8cf-df39-5346-b892-4e68a042c4b4@nvidia.com>
 <20210122011834.GA25356@salvia> <20210122021618.GH3863@horizon.localdomain>
From:   Oz Shlomo <ozsh@nvidia.com>
Message-ID: <ce10c528-e431-7b54-bcb5-5d7633cdf268@nvidia.com>
Date:   Mon, 25 Jan 2021 11:15:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210122021618.GH3863@horizon.localdomain>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611566161; bh=gS4gnp3oDpqSjhOQXpEh1mLd+0H6VCvPvkhBkSSJOmQ=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=N6f3fsJHaGX61Z/QsqlYDGLZtANWdAU0bgT74ptd4fhqXEknz/A73j4Zp0B46ViNe
         h+tXtk+jarzupABBXnXf3Z2MohKRzTALtwsn8L39GQGW5Hh+c5XdZ1JindGK3ecCf5
         ErCowWiGmZPHd1Ksu+f6T3h0zZgVKIu62zeT+u03VbR00dljidyPfR779doSwGYluM
         4Eo0DE2EMbUZCvcvqZWWFc7Bvp44DQhEGhfKPhGy9S9KJ1z4sUuQdfrLQf62yT52rl
         Mwn9WWohkFdCFZ4gEKMEV4Dw22+CrAfw9JUs/W470TQmKNQOjREZfEkZF/X+PfNI2x
         AOscnrf7F/tfA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 4:16 AM, Marcelo Ricardo Leitner wrote:
> On Fri, Jan 22, 2021 at 02:18:34AM +0100, Pablo Neira Ayuso wrote:
>> Hi Oz,
>>
>> On Wed, Jan 20, 2021 at 06:09:48PM +0200, Oz Shlomo wrote:
>>> On 1/14/2021 11:50 PM, Marcelo Ricardo Leitner wrote:
>>>>
>>>> Thoughts?
>>>>
>>>
>>> I wonder if we should develop a generic mechanism to optimize CT software
>>> for a use case that is faulty by design.
>>> This has limited value for software as it would only reduce the conntrack
>>> table size (packet classification is still required).
>>> However, this feature may have a big impact on hardware offload.
>>> Normally hardware offload relies on software to handle new connections.
>>> Causing all new connections to be processed by software.
>>> With this patch the hardware may autonomously set the +new connection state
>>> for the relevant connections.
>>
>> Could you fix this issue with unidirectional flows by checking for
>> IPS_CONFIRMED status bit? The idea is to hardware offload the entry
>> after the first packet goes through software successfully. Then, there
>> is no need to wait for the established state that requires to see
>> traffic in both directions.
> 
> That's an interesting idea. This way, basically all that needs to be
> changed is tcf_ct_flow_table_process_conn() to handle this new
> condition for UDP packets and on tcf_ct_act().

Will act_ct need to maintain a port list and classify the packet to realize whether the udp packet 
is part of a unidirection or biderectional udp connection?


> 
> It has a small performance penaulty if compared to the original
> solution, as now the first packet(s) goes to sw, but looks like a good
> compromise between supporting a (from what I could understand)
> somewhat lazy flow design (as I still think these didn't need to go
> through conntrack), an uniform system behavior (with and without
> offload, with mlx5 or another driver) and a more generic approach.
> Other situations that rely on unidirectional UDP flows will benefit
> from it as well.

The hardware offload perspective is a bit different.
With this approach the system will offload a rule per connection instead of offloading one mega-flow 
rule on dst udp port.
This will increase the hardware scale requirements in terms of number of offloaded rules.
In addition, a counter will need to be instantiated per rule and the software will need to manage 
the aging of these connections.

We hoped that the hardware can fully offload this scenario, avoiding the need for sw processing at all.


> 
> This way I even think it doesn't need to be configurable right now.
> It will be easier to add a knob to switch back to the old behavior if
> needed later on, if anything.
> 
>    Marcelo
> 

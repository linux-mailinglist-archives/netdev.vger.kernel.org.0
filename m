Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD44479D36
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 02:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbfG3AKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 20:10:22 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:64760 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbfG3AKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 20:10:22 -0400
Received: from [192.168.0.105] (unknown [116.234.7.199])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id CED1441126;
        Tue, 30 Jul 2019 08:10:16 +0800 (CST)
Subject: Re: [PATCH net-next v4 2/3] flow_offload: Support get default block
 from tc immediately
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1564296769-32294-1-git-send-email-wenxu@ucloud.cn>
 <1564296769-32294-3-git-send-email-wenxu@ucloud.cn>
 <20190728131653.6af72a87@cakuba.netronome.com>
 <5eed91c1-20ed-c08c-4700-979392bc5f33@ucloud.cn>
 <20190728214237.2c0687db@cakuba.netronome.com>
 <449a5603-80e9-ad7d-5c02-bf57558f9603@ucloud.cn>
 <20190729095526.17214c4d@cakuba.netronome.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <72794dd4-da6b-5b2c-9050-e9867c84c223@ucloud.cn>
Date:   Tue, 30 Jul 2019 08:10:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190729095526.17214c4d@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTENKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NzY6Vgw*Ojg0MklJPUo9MRMt
        OU8aCh9VSlVKTk1PT09OT0pMSktNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpKTVVJ
        SE9VTFVKQkJZV1kIAVlBSENPTjcG
X-HM-Tid: 0a6c40369e572086kuqyced1441126
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/30 0:55, Jakub Kicinski 写道:
> On Mon, 29 Jul 2019 15:18:03 +0800, wenxu wrote:
>> On 7/29/2019 12:42 PM, Jakub Kicinski wrote:
>>> On Mon, 29 Jul 2019 10:43:56 +0800, wenxu wrote:  
>>>> On 7/29/2019 4:16 AM, Jakub Kicinski wrote:  
>>>>> I don't know the nft code, but it seems unlikely it wouldn't have the
>>>>> same problem/need..    
>>>> nft don't have the same problem.  The offload rule can only attached
>>>> to offload base chain.
>>>>
>>>> Th  offload base chain is created after the device driver loaded (the
>>>> device exist).  
>>> For indirect blocks the block is on the tunnel device and the offload
>>> target is another device. E.g. you offload rules from a VXLAN device
>>> onto the ASIC. The ASICs driver does not have to be loaded when VXLAN
>>> device is created.
>>>
>>> So I feel like either the chain somehow directly references the offload
>>> target (in which case the indirect infrastructure with hash lookup etc
>>> is not needed for nft), or indirect infra is needed, and we need to take
>>> care of replays.  
>> I think the nft is different with tc. 
>>
>> In tc case we can create vxlan device add a ingress qdisc with a block success
>>
>> Then the ASIC driver loaded,  then register the vxlan indr-dev and get the block
>> adn replay it to hardware
>>
>> But in the nft case,  The base chain flags with offload. Create an offload netdev
>> base chain on vxlan device will fail if there is no indr-device to offload.
> Can you show us the offload chain spec? Does it specify offload to the
> vxlan device or the ASIC device?

nft add chain netdev firewall aclout { type filter hook ingress offload device vxlan0 priority - 300 \; }

>
> Indir-devs can come and go, how do you handle a situation where offload
> chain was installed with indir listener present, but then the ASIC
> driver got removed?

yes, I think nft is also need to get the default block in the indr-regster-cb

for the go aways and reload again case

>

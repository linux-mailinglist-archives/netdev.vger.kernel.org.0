Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE3B21AC8D
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 03:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGJBnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 21:43:03 -0400
Received: from out0-134.mail.aliyun.com ([140.205.0.134]:35098 "EHLO
        out0-134.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGJBnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 21:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594345380; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=tL6uZ5Ff/zIGdf7sORij0YGiVfkWqtJcPtB7965aQ3o=;
        b=dUDBhYmBsj9z0xUhKeo0YcDYivEBMiE73KPZeCePoyoqbhtnkW3gcSNQD2/3zM2wVqB99nVC8Swj3iih6UOlRnT4dLqkFgWF4YhBmimsBZofbpWXneLTGU18LVjqUL3JQmT9fuivW77+tVildfYQoxPipjrf6wbBRyyDffWCo14=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03279;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I.Gq5In_1594345378;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I.Gq5In_1594345378)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Jul 2020 09:42:59 +0800
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
 <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
 <d1716bc1-a975-54a3-8b7e-a3d3bcac69c5@alibaba-inc.com>
 <91fc642f-6447-4863-a182-388591cc1cc0@gmail.com>
 <387fe086-9596-c71e-d1d9-998749ae093c@alibaba-inc.com>
 <c4796548-5c3b-f3db-a060-1e46fb42970a@gmail.com>
 <7ea368d0-d12c-2f04-17a7-1e31a61bbe2b@alibaba-inc.com>
 <825c8af6-66b5-eaf4-2c46-76d018489ebd@gmail.com>
 <345bf201-f7cf-c821-1dba-50d0f2b76101@alibaba-inc.com>
 <ad26a7a3-38b1-5cbc-b4ed-ea5626a74bd8@gmail.com>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <419dbdae-19f9-2bb3-2ca5-eaffd58f1266@alibaba-inc.com>
Date:   Fri, 10 Jul 2020 09:42:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <ad26a7a3-38b1-5cbc-b4ed-ea5626a74bd8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/9/20 3:22 PM, Eric Dumazet wrote:
> 
> 
> On 7/9/20 11:20 AM, YU, Xiangning wrote:
>>
>>
>> On 7/9/20 10:15 AM, Eric Dumazet wrote:
>>>
>>> Well, at Google we no longer have this issue.
>>>
>>> We adopted EDT model, so that rate limiting can be done in eBPF, by simply adjusting skb->tstamp.
>>>
>>> The qdisc is MQ + FQ.
>>>
>>> Stanislas Fomichev will present this use case at netdev conference 
>>>
>>> https://netdevconf.info/0x14/session.html?talk-replacing-HTB-with-EDT-and-BPF
>>>
>> This is cool, I would love to learn more about this!
>>
>> Still please correct me if I'm wrong. This looks more like pacing on a per-flow basis, how do you support an overall rate limiting of multiple flows? Each individual flow won't have a global rate usage about others.
>>
> 
> 
> No, this is really per-aggregate rate limiting, multiple TCP/UDP flows can share the same class.
> 
> Before that, we would have between 10 and 3000 HTB classes on a host.
> We had internal code to bypass the HTB (on bond0 device) for non throttled packets,
> since HTB could hardly cope with more than 1Mpps.
> 
> Now, an eBPF program (from sch_handle_egress()) using maps to perform classification
> and (optional) rate-limiting based on various rules.
> 
> MQ+FQ is already doing the per-flow pacing (we have been using this for 8 years now)
> 
> The added eBPF code extended this pacing to be per aggregate as well.
> 
That's very interesting! Thank you for sharing. 

We have been deploying ltb for several years too. It's far better than htb but still have degradation compared with the baseline. Usng EDT across flows should be able to yield an even better result.

Thanks
- Xiangning

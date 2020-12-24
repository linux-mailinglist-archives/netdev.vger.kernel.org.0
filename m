Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F962E2870
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 18:51:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbgLXRti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 12:49:38 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:43310 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgLXRti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 12:49:38 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id B8A6C13C2B0;
        Thu, 24 Dec 2020 09:48:55 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com B8A6C13C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608832136;
        bh=/GAFNsR+zmqSQgXL54miJl8Wz8mDBF3xYc6Hz82P0WY=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=H8JvODb9F6ATRd1ohFHdzK30Tgt0HBh34/958qkjuBrnQZsadJpDbp/1LjfYGYb7d
         1Ntd3nq3fRmHXMYRYuQsnIl7LswRI+ZRWqv+jryYFJSPBsQKXMEuBUPvTHrsGnV/Ow
         BQQq9bJWZEg9ZLbixyv1lb2/A+kNaO6u1PcfT51w=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
To:     Rainer Suhm <automat@posteo.de>, Eric Dumazet <edumazet@google.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Luca Coelho <luciano.coelho@intel.com>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
 <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
 <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
 <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
 <CANn89i++Kgkj57ms70a5GDOQ-Cpewx3NQkzP3EmZmLYQ4eHzww@mail.gmail.com>
 <5d89fd24-f00a-7e70-00ce-83529f13b05e@candelatech.com>
 <20201218121627.603329b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <9003ea3720a03b4bd1b8abf3d8f645563a58f953.camel@sipsolutions.net>
 <43a5b45c-955a-22d4-2bf9-dbab852dbb5f@candelatech.com>
 <CANn89iJBO13s9fOVRnDyfj5HXt9wjnRpbh2_f5SuyNkNAfjzJQ@mail.gmail.com>
 <CANn89iJTCDof6ypxCkiGaPo+y0Bngg0NX5cLPWisTEZaFo1BQw@mail.gmail.com>
 <CANn89iJWG2n1s3j7EdpwkQQv-9dOY02V+FGYHAWguO4JiqWuJA@mail.gmail.com>
 <ea6013e9-424f-1a3a-0d70-1ca5041bc3a1@posteo.de>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <661ea039-52c3-0f89-0f32-59d3f107bee5@candelatech.com>
Date:   Thu, 24 Dec 2020 09:48:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <ea6013e9-424f-1a3a-0d70-1ca5041bc3a1@posteo.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/21/20 12:01 PM, Rainer Suhm wrote:
> Am 21.12.20 um 20:14 schrieb Eric Dumazet:
>> On Mon, Dec 21, 2020 at 8:04 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>> On Mon, Dec 21, 2020 at 7:46 PM Eric Dumazet <edumazet@google.com> wrote:
>>>>
>>>> On Sat, Dec 19, 2020 at 5:55 PM Ben Greear <greearb@candelatech.com> wrote:
>>>>>
>>>>> On 12/19/20 7:18 AM, Johannes Berg wrote:
>>>>>> On Fri, 2020-12-18 at 12:16 -0800, Jakub Kicinski wrote:
>>>>>>> On Thu, 17 Dec 2020 12:40:26 -0800 Ben Greear wrote:
>>>>>>>> On 12/17/20 10:20 AM, Eric Dumazet wrote:
>>>>>>>>> On Thu, Dec 17, 2020 at 7:13 PM Ben Greear <greearb@candelatech.com> wrote:
>>>>>>>>>> It is the iwlwifi/mvm logic that supports ax200.
>>>>>>>>>
>>>>>>>>> Let me ask again :
>>>>>>>>>
>>>>>>>>> I see two different potential call points :
>>>>>>>>>
>>>>>>>>> drivers/net/wireless/intel/iwlwifi/pcie/tx.c:1529:
>>>>>>>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
>>>>>>>>> drivers/net/wireless/intel/iwlwifi/queue/tx.c:427:
>>>>>>>>> tso_build_hdr(skb, hdr_page->pos, &tso, data_left, !total_len);
>>>>>>>>>
>>>>>>>>> To the best of your knowledge, which one would be used in your case ?
>>>>>>>>>
>>>>>>>>> Both are horribly complex, I do not want to spend time studying two
>>>>>>>>> implementations.
>>>>>>>>
>>>>>>>> It is the queue/tx.c code that executes on my system, verified with
>>>>>>>> printk.
>>>>>>>
>>>>>>> Not sure why Intel's not on CC here.
>>>>>>
>>>>>> Heh :)
>>>>>>
>>>>>> Let's also add linux-wireless.
>>>>>>
>>>>>>> Luca, is the ax200 TSO performance regression with recent kernel on your
>>>>>>> radar?
>>>>>>
>>>>>> It wasn't on mine for sure, so far. But it's supposed to be Christmas
>>>>>> vacation, so haven't checked our bug tracker etc. I see Emmanuel was at
>>>>>> least looking at the bug report, but not sure what else happened yet.
>>>>>
>>>>> Not to bitch and moan too much, but even the most basic of testing would
>>>>> have shown this, how can testing be so poor on the ax200 driver?
>>>>>
>>>>> It even shows up with the out-of-tree ax200 driver.
>>>>>
>>>>>> Off the top of my head, I don't really see the issue. Does anyone have
>>>>>> the ability to capture the frames over the air (e.g. with another AX200
>>>>>> in monitor mode, load the driver with amsdu_size=3 module parameter to
>>>>>> properly capture A-MSDUs)?
>>>>>
>>>>> I can do that at some point, and likely it could be reproduced with an /n or /ac
>>>>> AP and those are a lot easier to sniff.
>>>>>
>>>>> Thanks,
>>>>> Ben
>>>>>
>>>>>
>>>>> -- 
>>>>> Ben Greear <greearb@candelatech.com>
>>>>> Candela Technologies Inc  http://www.candelatech.com
>>>>
>>>> It seems the problem comes from some skbs reaching the driver with
>>>> gso_type == 0,
>>>> meaning skb_is_gso_tcp() is fuzzy. (net/core/tso.c is only one of the
>>>> skb_is_gso_tcp() users)
>>>>
>>>> Local TCP stack should provide either SKB_GSO_TCPV4 or SKB_GSO_TCPV6
>>>> for GSO packets.
>>>>
>>>> So maybe the issue is coming from traffic coming from a VM through a
>>>> tun device or something,
>>>> and our handling of GSO_ROBUST / DODGY never cared about setting
>>>> SKB_GSO_TCPV4 or SKB_GSO_TCPV6 if not already given by user space ?
>>>>
>>>> Or a plain bug somewhere, possibly overwriting  gso_type with 0 or garbage...
>>>
>>> Oh well, iwl_mvm_tx_tso_segment() 'builds' a fake gso packet.
>>>
>>> I suspect this will fix the issue :
>>>
>>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>>> b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>>> index a983c215df310776ffe67f3b3ffa203eab609bfc..e7ad6367c88de4aff700c630d850760d1d3bf011
>>> 100644
>>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>>> @@ -773,6 +773,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb,
>>> unsigned int num_subframes,
>>>
>>>          next = skb_gso_segment(skb, netdev_flags);
>>>          skb_shinfo(skb)->gso_size = mss;
>>> +       skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>>>          if (WARN_ON_ONCE(IS_ERR(next)))
>>>                  return -EINVAL;
>>>          else if (next)
>>
>>
>> Or more precisely :
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> index a983c215df310776ffe67f3b3ffa203eab609bfc..11145bf29f3cbeefcce1a05cc81fd90978f2cbfe
>> 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
>> @@ -773,6 +773,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb,
>> unsigned int num_subframes,
>>
>>          next = skb_gso_segment(skb, netdev_flags);
>>          skb_shinfo(skb)->gso_size = mss;
>> +       skb_shinfo(skb)->gso_type = ipv4 ? SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>>          if (WARN_ON_ONCE(IS_ERR(next)))
>>                  return -EINVAL;
>>          else if (next)
>> @@ -795,6 +796,7 @@ iwl_mvm_tx_tso_segment(struct sk_buff *skb,
>> unsigned int num_subframes,
>>
>>                  if (tcp_payload_len > mss) {
>>                          skb_shinfo(tmp)->gso_size = mss;
>> +                       skb_shinfo(tmp)->gso_type = ipv4 ?
>> SKB_GSO_TCPV4 : SKB_GSO_TCPV6;
>>                  } else {
>>                          if (qos) {
>>                                  u8 *qc;
>>
> 
> 
> This looks good to me.
> Transmission rate is in the expected range. iperf3 shows no retries anymore.
> 
> Here is my kernel log with the above changes applied, and the debug patches from Eric.

I tested this successfully as well.

Eric:  Thanks for the patch!

--Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

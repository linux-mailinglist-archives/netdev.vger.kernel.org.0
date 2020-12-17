Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790A32DD800
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:15:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbgLQSOH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:14:07 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:35096 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729976AbgLQSOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:14:06 -0500
Received: from [192.168.3.20] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id 150E513C2B0;
        Thu, 17 Dec 2020 10:13:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 150E513C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608228805;
        bh=uNDMeyMSVSZKT4yBVrKC64LFpkkYstQ9YyO4H6b1XOI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=WaQMOQJGUhFX4XOhGJTc1rnV41P63GLAfq+n1ikRqALYKD60Ua0l1NlhJhj/OFAJ3
         aMFOImXYqg9TFmJhxCPCw0EizlNRZO7UO+DqNFdkSoGFLFkD5/3/tk8gvLwYCs+xLH
         x+qdDGhx98BFmKdDtt+6lM1l1jxyOIp7lKvmTSo4=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
 <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
 <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
 <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Message-ID: <c4bcee7d-b2eb-759c-c659-d65f3e7daec9@candelatech.com>
Date:   Thu, 17 Dec 2020 10:13:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CANn89iJQnSVZFp2XDgREN1QMtU4exOsnJq=5VzJ6tqTCJ7MH-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 12/17/2020 10:07 AM, Eric Dumazet wrote:
> On Thu, Dec 17, 2020 at 6:56 PM Ben Greear <greearb@candelatech.com> wrote:
>> On 12/17/20 2:11 AM, Eric Dumazet wrote:
>>> On Thu, Dec 17, 2020 at 12:59 AM Ben Greear <greearb@candelatech.com> wrote:
>>>> On 12/16/20 3:09 PM, Ben Greear wrote:
>>>>> Hello Eric,
>>>>>
>>>>> The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
>>>>> when using ax200 to upload tcp traffic.
>>>>>
>>>>> When I disable TSO, performance goes back up to around 700Mbps.
>>>> As a followup, when I revert the patch, upload speed goes to ~900Mbps,
>>>> so even better than just disabling TSO (I left TSO enabled after reverting the patch).
>>>>
>>>> Thanks,
>>>> Ben
>>>>
>>> Thanks for the report !
>>>
>>> It seems drivers/net/wireless/intel/iwlwifi/pcie/tx.c:iwl_fill_data_tbs_amsdu()
>>> calls tso_build_hdr() with extra bytes (SNAP header),
>>> it is not yet clear to me what is broken :/
>> Your patch is guessing tcp vs udp by looking at header length
>> from what I could tell.  So if something uses a different size,
>> it probably gets confused?
> I do not think so, my patch selects TCP vs UDP by using standard GSO
> helper skb_is_gso_tcp(skb)
>
> tso->tlen is initialized from tso_start() :
>
> int tlen = skb_is_gso_tcp(skb) ? tcp_hdrlen(skb) : sizeof(struct udphdr);
>
> tso->tlen = tlen;
>
> Maybe for some reason skb_is_gso_tcp(skb) returns false in your case,
> some debugging would help.
>
>>> Can you confirm which driver is used for ax200 ?
>>>
>>> I see tso_build_hdr() also being used from
>>> drivers/net/wireless/intel/iwlwifi/queue/tx.c
>> I tested against the un-modified ax200 5.10.0 kernel driver, and it has the issue.
>>
>> The ax200 backports release/core56 driver acts a bit different (poorer performance over all than
>> in-kernel driver), but has similar upstream issues that are mitigated by
>> disabling TSO.
> Sorry, I can not find ax200 driver.

It is the iwlwifi/mvm logic that supports ax200.

Thanks,

Ben



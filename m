Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8FF2DD6A5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:57:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgLQR5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:57:15 -0500
Received: from mail2.candelatech.com ([208.74.158.173]:34424 "EHLO
        mail3.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgLQR5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:57:14 -0500
Received: from [192.168.254.6] (unknown [50.46.158.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id A6DCD13C2B3;
        Thu, 17 Dec 2020 09:56:33 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com A6DCD13C2B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1608227793;
        bh=Yb6clpUNehTgrSt4Z0khqCfulHBxDx2TKWifRk3QBIk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=h+vdZszyJLHISoDgHs8jj4zu1jlyk8xWj6FfUkHiZJH+8MosuD3B5IpnnO8NACCrq
         drvtdbXYhxRaRgjJ563vl1mSCVaL/KRszNmVlv+K4s7CtVqBKs9uvuUQOiZkhgOFS8
         salFh38HbjuvVnEfw0Te2kNJDXRW8FNXl8pVuFi8=
Subject: Re: net: tso: add UDP segmentation support: adds regression for ax200
 upload
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <5664fa0f-aef2-c336-651a-093c9eed23ab@candelatech.com>
 <765f370d-ce2d-b75a-2dde-87f69ae7c185@candelatech.com>
 <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <adbee2ec-c6ba-7a17-eb98-1c53365fa911@candelatech.com>
Date:   Thu, 17 Dec 2020 09:56:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CANn89iKpa1y2SKJuR9kRi=AZs94sj+-tzRs+2D0vmxh+ahEcGA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 2:11 AM, Eric Dumazet wrote:
> On Thu, Dec 17, 2020 at 12:59 AM Ben Greear <greearb@candelatech.com> wrote:
>>
>> On 12/16/20 3:09 PM, Ben Greear wrote:
>>> Hello Eric,
>>>
>>> The patch below evidently causes TCP throughput to be about 50Mbps instead of 700Mbps
>>> when using ax200 to upload tcp traffic.
>>>
>>> When I disable TSO, performance goes back up to around 700Mbps.
>>
>> As a followup, when I revert the patch, upload speed goes to ~900Mbps,
>> so even better than just disabling TSO (I left TSO enabled after reverting the patch).
>>
>> Thanks,
>> Ben
>>
> 
> Thanks for the report !
> 
> It seems drivers/net/wireless/intel/iwlwifi/pcie/tx.c:iwl_fill_data_tbs_amsdu()
> calls tso_build_hdr() with extra bytes (SNAP header),
> it is not yet clear to me what is broken :/

Your patch is guessing tcp vs udp by looking at header length
from what I could tell.  So if something uses a different size,
it probably gets confused?

> 
> Can you confirm which driver is used for ax200 ?
> 
> I see tso_build_hdr() also being used from
> drivers/net/wireless/intel/iwlwifi/queue/tx.c

I tested against the un-modified ax200 5.10.0 kernel driver, and it has the issue.

The ax200 backports release/core56 driver acts a bit different (poorer performance over all than
in-kernel driver), but has similar upstream issues that are mitigated by
disabling TSO.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

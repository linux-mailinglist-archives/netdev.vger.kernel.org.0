Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC46C48BB9A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346883AbiALAFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:05:19 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.183]:41158 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233810AbiALAFT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 19:05:19 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.51.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1E9F7A006D;
        Wed, 12 Jan 2022 00:05:18 +0000 (UTC)
Received: from mail3.candelatech.com (mail2.candelatech.com [208.74.158.173])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 03C5D3C0083;
        Wed, 12 Jan 2022 00:05:16 +0000 (UTC)
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id C6F4913C2B0;
        Tue, 11 Jan 2022 16:05:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com C6F4913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1641945916;
        bh=18d4yGMhNtN5WeLUyvt5HzRC/PKOBY/gWEW9JAYjrdg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=gsPX6T7F3K6YMGR/JVr1bq7c+0mqLLBmjaXA0XQdokSY0RT8yL6NQ/kHAP7IbUglZ
         F6duLuXS3F6PlHvUSTdH5EqcONzyuXFOj/TDCZZhoSmVppVw9kRy+dsFnL8tZkZgQV
         18Nyw+3RsepMEXqzaD2b/4sssp+Y8HAU8HQPm46E=
Subject: Re: [Bug] mt7921e driver in 5.16 causes kernel panic
To:     khalid@gonehiking.org, nbd@nbd.name, lorenzo.bianconi83@gmail.com,
        ryder.lee@mediatek.com, shayne.chen@mediatek.com,
        sean.wang@mediatek.com, kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <5cee9a36-b094-37a0-e961-d7404b3dafe2@gonehiking.org>
 <7b15fa7c-9130-db8c-875e-8c0eb1dcc530@candelatech.com>
 <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <8a34d1bc-3095-2d5d-236a-ef271775ca47@candelatech.com>
Date:   Tue, 11 Jan 2022 16:05:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MDID: 1641945918-pXFd2S6286Gh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 3:58 PM, Khalid Aziz wrote:
> On 1/11/22 16:31, Ben Greear wrote:
>> On 1/11/22 3:17 PM, Khalid Aziz wrote:
>>> I am seeing an intermittent bug in mt7921e driver. When the driver module is loaded
>>> and is being initialized, almost every other time it seems to write to some wild
>>> memory location. This results in driver failing to initialize with message
>>> "Timeout for driver own" and at the same time I start to see "Bad page state" messages
>>> for random processes. Here is the relevant part of dmesg:
>>
>> Please see if this helps?
>>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> If the nic fails to start, it is possible that the
>> reset_work has already been scheduled.  Ensure the
>> work item is canceled so we do not have use-after-free
>> crash in case cleanup is called before the work item
>> is executed.
>>
>> This fixes crash on my x86_64 apu2 when mt7921k radio
>> fails to work.  Radio still fails, but OS does not
>> crash.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> index 6073bedaa1c08..9b33002dcba4a 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> @@ -272,6 +272,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
>>
>>       cancel_delayed_work_sync(&dev->pm.ps_work);
>>       cancel_work_sync(&dev->pm.wake_work);
>> +    cancel_work_sync(&dev->reset_work);
>>       mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
>>
>>       mt7921_mutex_acquire(dev);
> 
> Hi Ben,
> 
> Unfortunately that did not help. I still saw the same messages and a kernel panic. I do not see this bug if I power down the laptop before booting it up, so 
> mt7921_stop() would make sense as the reasonable place to fix it.

I think there are bugs around soft power cycle in these radios.  (And today someone reported
to me same type of problem in some 7915 radio, though my 7915 radios work in that regard for me.)  The patch above
fixes a crash I saw on a system with 7921k radio when the radio fails to boot properly for some reason
or another.  I guess there must be more bugs in the radio bringup logic and you are hitting something
different from what I hit.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com


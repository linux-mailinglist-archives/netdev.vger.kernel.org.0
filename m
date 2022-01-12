Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F6E48BD03
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 03:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236972AbiALCQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 21:16:30 -0500
Received: from mailout.easymail.ca ([64.68.200.34]:36484 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236083AbiALCQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 21:16:29 -0500
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id B311DC81BD;
        Wed, 12 Jan 2022 02:16:28 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo01-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo01-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id qn6YbSJUGugb; Wed, 12 Jan 2022 02:16:27 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 5EE66C8193;
        Wed, 12 Jan 2022 02:16:27 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 755513EE4B;
        Tue, 11 Jan 2022 19:16:26 -0700 (MST)
Message-ID: <fed8a57f-8003-5759-a74a-3ddbf867152b@gonehiking.org>
Date:   Tue, 11 Jan 2022 19:16:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Reply-To: khalid@gonehiking.org
Subject: Re: [Bug] mt7921e driver in 5.16 causes kernel panic
Content-Language: en-US
To:     sean.wang@mediatek.com
Cc:     greearb@candelatech.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, Ryder.Lee@mediatek.com,
        Shayne.Chen@mediatek.com, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org--annotate>
 <1641948556-23414-1-git-send-email-sean.wang@mediatek.com>
From:   Khalid Aziz <khalid@gonehiking.org>
In-Reply-To: <1641948556-23414-1-git-send-email-sean.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 17:49, sean.wang@mediatek.com wrote:
> From: Sean Wang <sean.wang@mediatek.com>
> 
>> On 1/11/22 16:31, Ben Greear wrote:
>>> On 1/11/22 3:17 PM, Khalid Aziz wrote:
>>>> I am seeing an intermittent bug in mt7921e driver. When the driver
>>>> module is loaded and is being initialized, almost every other time it
>>>> seems to write to some wild memory location. This results in driver
>>>> failing to initialize with message "Timeout for driver own" and at
>>>> the same time I start to see "Bad page state" messages for random
>>>> processes. Here is the relevant part of dmesg:
>>>
>>> Please see if this helps?
>>>
>>> From: Ben Greear <greearb@candelatech.com>
>>>
>>> If the nic fails to start, it is possible that the reset_work has
>>> already been scheduled.  Ensure the work item is canceled so we do not
>>> have use-after-free crash in case cleanup is called before the work
>>> item is executed.
>>>
>>> This fixes crash on my x86_64 apu2 when mt7921k radio fails to work.
>>> Radio still fails, but OS does not crash.
>>>
>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>> ---
>>>    drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
>>>    1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>>> b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>>> index 6073bedaa1c08..9b33002dcba4a 100644
>>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>>> @@ -272,6 +272,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
>>>
>>>        cancel_delayed_work_sync(&dev->pm.ps_work);
>>>        cancel_work_sync(&dev->pm.wake_work);
>>> +    cancel_work_sync(&dev->reset_work);
>>>        mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
>>>
>>>        mt7921_mutex_acquire(dev);
>>
>> Hi Ben,
>>
>> Unfortunately that did not help. I still saw the same messages and a kernel panic. I do not see this bug if I power down the laptop before booting it up, so mt7921_stop() would make sense as the reasonable place to fix it.
> 
> Hi, Khalid
> 
> Could you try the patch below? It should be helpful to your issue
> 
> https://patchwork.kernel.org/project/linux-wireless/patch/70e27cbc652cbdb78277b9c691a3a5ba02653afb.1641540175.git.objelf@gmail.com/

Hi Sean,

That worked! I tried 5 reboots back-to-back after applying your patch 
without powering down my laptop. There were no error messages, kernel 
came up every time and wifi worked.

Thanks,
Khalid


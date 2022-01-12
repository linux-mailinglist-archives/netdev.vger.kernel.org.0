Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AE48BC03
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 01:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiALAtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 19:49:24 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:60912 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1343866AbiALAtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 19:49:23 -0500
X-UUID: 987cdb94642a43c8a121c4b2a526f3e3-20220112
X-UUID: 987cdb94642a43c8a121c4b2a526f3e3-20220112
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 733936014; Wed, 12 Jan 2022 08:49:18 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 12 Jan 2022 08:49:17 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 12 Jan 2022 08:49:16 +0800
From:   <sean.wang@mediatek.com>
To:     <khalid@gonehiking.org>
CC:     <greearb@candelatech.com>, <nbd@nbd.name>,
        <lorenzo.bianconi83@gmail.com>, <Ryder.Lee@mediatek.com>,
        <Shayne.Chen@mediatek.com>, <Sean.Wang@mediatek.com>,
        <kvalo@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <matthias.bgg@gmail.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [Bug] mt7921e driver in 5.16 causes kernel panic
Date:   Wed, 12 Jan 2022 08:49:16 +0800
Message-ID: <1641948556-23414-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org--annotate>
References: <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org--annotate>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

>On 1/11/22 16:31, Ben Greear wrote:
>> On 1/11/22 3:17 PM, Khalid Aziz wrote:
>>> I am seeing an intermittent bug in mt7921e driver. When the driver
>>> module is loaded and is being initialized, almost every other time it
>>> seems to write to some wild memory location. This results in driver
>>> failing to initialize with message "Timeout for driver own" and at
>>> the same time I start to see "Bad page state" messages for random
>>> processes. Here is the relevant part of dmesg:
>>
>> Please see if this helps?
>>
>> From: Ben Greear <greearb@candelatech.com>
>>
>> If the nic fails to start, it is possible that the reset_work has
>> already been scheduled.  Ensure the work item is canceled so we do not
>> have use-after-free crash in case cleanup is called before the work
>> item is executed.
>>
>> This fixes crash on my x86_64 apu2 when mt7921k radio fails to work.
>> Radio still fails, but OS does not crash.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>> ---
>>   drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> index 6073bedaa1c08..9b33002dcba4a 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
>> @@ -272,6 +272,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
>>
>>       cancel_delayed_work_sync(&dev->pm.ps_work);
>>       cancel_work_sync(&dev->pm.wake_work);
>> +    cancel_work_sync(&dev->reset_work);
>>       mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
>>
>>       mt7921_mutex_acquire(dev);
>
>Hi Ben,
>
>Unfortunately that did not help. I still saw the same messages and a kernel panic. I do not see this bug if I power down the laptop before booting it up, so mt7921_stop() would make sense as the reasonable place to fix it.

Hi, Khalid

Could you try the patch below? It should be helpful to your issue

https://patchwork.kernel.org/project/linux-wireless/patch/70e27cbc652cbdb78277b9c691a3a5ba02653afb.1641540175.git.objelf@gmail.com/

>
>Thanks,
>Khalid
>
>

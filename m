Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A6248BB93
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 00:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346846AbiAKX7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 18:59:02 -0500
Received: from mailout.easymail.ca ([64.68.200.34]:57102 "EHLO
        mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233810AbiAKX7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 18:59:01 -0500
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 907B12D635;
        Tue, 11 Jan 2022 23:59:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo02-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo02-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oRvSMt4fC-7F; Tue, 11 Jan 2022 23:59:00 +0000 (UTC)
Received: from mail.gonehiking.org (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        by mailout.easymail.ca (Postfix) with ESMTPA id 497FA2D526;
        Tue, 11 Jan 2022 23:59:00 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id 45FEE3EE43;
        Tue, 11 Jan 2022 16:58:59 -0700 (MST)
Message-ID: <c3a66426-e6a0-4fd2-dc09-85181c96b755@gonehiking.org>
Date:   Tue, 11 Jan 2022 16:58:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Reply-To: khalid@gonehiking.org
Subject: Re: [Bug] mt7921e driver in 5.16 causes kernel panic
Content-Language: en-US
To:     Ben Greear <greearb@candelatech.com>, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com, kvalo@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <5cee9a36-b094-37a0-e961-d7404b3dafe2@gonehiking.org>
 <7b15fa7c-9130-db8c-875e-8c0eb1dcc530@candelatech.com>
From:   Khalid Aziz <khalid@gonehiking.org>
In-Reply-To: <7b15fa7c-9130-db8c-875e-8c0eb1dcc530@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/22 16:31, Ben Greear wrote:
> On 1/11/22 3:17 PM, Khalid Aziz wrote:
>> I am seeing an intermittent bug in mt7921e driver. When the driver 
>> module is loaded
>> and is being initialized, almost every other time it seems to write to 
>> some wild
>> memory location. This results in driver failing to initialize with 
>> message
>> "Timeout for driver own" and at the same time I start to see "Bad page 
>> state" messages
>> for random processes. Here is the relevant part of dmesg:
> 
> Please see if this helps?
> 
> From: Ben Greear <greearb@candelatech.com>
> 
> If the nic fails to start, it is possible that the
> reset_work has already been scheduled.  Ensure the
> work item is canceled so we do not have use-after-free
> crash in case cleanup is called before the work item
> is executed.
> 
> This fixes crash on my x86_64 apu2 when mt7921k radio
> fails to work.  Radio still fails, but OS does not
> crash.
> 
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>   drivers/net/wireless/mediatek/mt76/mt7921/main.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c 
> b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
> index 6073bedaa1c08..9b33002dcba4a 100644
> --- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
> +++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
> @@ -272,6 +272,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
> 
>       cancel_delayed_work_sync(&dev->pm.ps_work);
>       cancel_work_sync(&dev->pm.wake_work);
> +    cancel_work_sync(&dev->reset_work);
>       mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
> 
>       mt7921_mutex_acquire(dev);

Hi Ben,

Unfortunately that did not help. I still saw the same messages and a 
kernel panic. I do not see this bug if I power down the laptop before 
booting it up, so mt7921_stop() would make sense as the reasonable place 
to fix it.

Thanks,
Khalid

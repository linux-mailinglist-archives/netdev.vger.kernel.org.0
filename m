Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2814934EC
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 07:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351765AbiASGUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 01:20:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52980 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350102AbiASGUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 01:20:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 483B0B811CC;
        Wed, 19 Jan 2022 06:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C27C004E1;
        Wed, 19 Jan 2022 06:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642573201;
        bh=+/ZjQ3Ir+rum0nwu103J/f9YAv7hVQpz3n0F5Ixkyc4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lesLyo+yE///z73mDnJfTRwJ6cZGH7ErAxRlnv70UeFMhPuqdlsiAkp7PM7kDzrBL
         jZclQaLDF2MsX6gA0spNV88wxMl5y0actPxsZ8RPnSB/uXXvh+v+W2z9h4avud9XDA
         TzhLJZznK6ZGO7Xvi7OicUR/yvZTg9uR6lLqWgY8QVhg5eWkOarn1b0IT9GC4Ly/2A
         kddD9ozvKs0SLhrkQa0M5AhJH+vqXb6N3PT0/QdegMrx7v6HgM+KX9x8xb3/3cebl7
         mUhVKo0OQDNB14Q6v25pLBAahX/UQxe7SXcWx2jarXEoN9iRCiT5OKTF7imBopoF75
         XUQnHfoFCZXgA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma\@gmail.com" <tony0620emma@gmail.com>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: Re: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
References: <20220114234825.110502-1-martin.blumenstingl@googlemail.com>
        <20220114234825.110502-4-martin.blumenstingl@googlemail.com>
        <b2bf2bc5f04b488487797aa21c50a130@realtek.com>
Date:   Wed, 19 Jan 2022 08:19:55 +0200
In-Reply-To: <b2bf2bc5f04b488487797aa21c50a130@realtek.com> (Pkshih's message
        of "Wed, 19 Jan 2022 06:04:45 +0000")
Message-ID: <87czkogsc4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>> Sent: Saturday, January 15, 2022 7:48 AM
>> To: linux-wireless@vger.kernel.org
>> Cc: tony0620emma@gmail.com; kvalo@codeaurora.org;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
>> Neo Jou <neojou@gmail.com>; Jernej Skrabec
>> <jernej.skrabec@gmail.com>; Pkshih <pkshih@realtek.com>; Martin
>> Blumenstingl <martin.blumenstingl@googlemail.com>
>> Subject: [PATCH 3/4] rtw88: Move enum rtw_tx_queue_type mapping code to tx.{c,h}
>> 
>> This code is not specific to the PCIe bus type but can be re-used by USB
>> and SDIO bus types. Move it to tx.{c,h} to avoid code-duplication in the
>> future.
>> 
>> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
>
> [...]
>
>> diff --git a/drivers/net/wireless/realtek/rtw88/tx.c b/drivers/net/wireless/realtek/rtw88/tx.c
>> index efcc1b0371a8..ec6a3683c3f8 100644
>> --- a/drivers/net/wireless/realtek/rtw88/tx.c
>> +++ b/drivers/net/wireless/realtek/rtw88/tx.c
>> @@ -665,3 +665,38 @@ void rtw_txq_cleanup(struct rtw_dev *rtwdev, struct ieee80211_txq *txq)
>>  		list_del_init(&rtwtxq->list);
>>  	spin_unlock_bh(&rtwdev->txq_lock);
>>  }
>> +
>> +static enum rtw_tx_queue_type ac_to_hwq[] = {
>> +	[IEEE80211_AC_VO] = RTW_TX_QUEUE_VO,
>> +	[IEEE80211_AC_VI] = RTW_TX_QUEUE_VI,
>> +	[IEEE80211_AC_BE] = RTW_TX_QUEUE_BE,
>> +	[IEEE80211_AC_BK] = RTW_TX_QUEUE_BK,
>> +};
>> +
>> +static_assert(ARRAY_SIZE(ac_to_hwq) == IEEE80211_NUM_ACS);
>> +
>> +enum rtw_tx_queue_type rtw_tx_ac_to_hwq(enum ieee80211_ac_numbers ac)
>> +{
>> +	return ac_to_hwq[ac];
>> +}
>> +EXPORT_SYMBOL(rtw_tx_ac_to_hwq);
>> +
>
> Could I know why we can't just export the array ac_to_hwq[]?
> Is there a strict rule?

I was about to answer that with a helper function it's easier to catch
out of bands access, but then noticed the helper doesn't have a check
for that. Should it have one?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

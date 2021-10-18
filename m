Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0861043188B
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 14:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJRMOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 08:14:16 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:53034 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhJRMOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 08:14:15 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1634559124; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=DFB9KnvnR5g4ew0MqGsNEn5846+3YZbOjK228obcRjo=; b=VfIzthw2fvY5Z/Q862YfrdYXMlCHgKePMnSmIkTDjg8djS/hIsqduAF3z9b3ntv6KYhHnE/Y
 GhE43jPVQnuTXjuSJOfCyCZSCqAM/EtVkgTwZ+ABUTMncJ2MeHIMp7pY83hS3ZIBOp6XAcFb
 55jrvkU/XNQh1CKGPjFmMFbVSx0=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 616d648a03355859c8b7d232 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 18 Oct 2021 12:11:54
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id DB4DDC4360D; Mon, 18 Oct 2021 12:11:53 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id D7B92C4338F;
        Mon, 18 Oct 2021 12:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org D7B92C4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
References: <20211015154530.34356-1-colin.king@canonical.com>
        <9cc681c217a449519aee524b35e6b6bc@realtek.com>
Date:   Mon, 18 Oct 2021 15:11:45 +0300
In-Reply-To: <9cc681c217a449519aee524b35e6b6bc@realtek.com> (Pkshih's message
        of "Mon, 18 Oct 2021 03:35:28 +0000")
Message-ID: <87pms2ttvi.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

>> -----Original Message-----
>> From: Colin King <colin.king@canonical.com>
>> Sent: Friday, October 15, 2021 11:46 PM
>> To: Kalle Valo <kvalo@codeaurora.org>; David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Pkshih <pkshih@realtek.com>; linux-wireless@vger.kernel.org;
>> netdev@vger.kernel.org
>> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: [PATCH][next] rtw89: Fix potential dereference of the null pointer sta
>> 
>> From: Colin Ian King <colin.king@canonical.com>
>> 
>> The pointer rtwsta is dereferencing pointer sta before sta is
>> being null checked, so there is a potential null pointer deference
>> issue that may occur. Fix this by only assigning rtwsta after sta
>> has been null checked. Add in a null pointer check on rtwsta before
>> dereferencing it too.
>> 
>> Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
>> Addresses-Coverity: ("Dereference before null check")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>> ---
>>  drivers/net/wireless/realtek/rtw89/core.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtw89/core.c
>> b/drivers/net/wireless/realtek/rtw89/core.c
>> index 06fb6e5b1b37..26f52a25f545 100644
>> --- a/drivers/net/wireless/realtek/rtw89/core.c
>> +++ b/drivers/net/wireless/realtek/rtw89/core.c
>> @@ -1534,9 +1534,14 @@ static bool rtw89_core_txq_agg_wait(struct rtw89_dev *rtwdev,
>>  {
>>  	struct rtw89_txq *rtwtxq = (struct rtw89_txq *)txq->drv_priv;
>>  	struct ieee80211_sta *sta = txq->sta;
>> -	struct rtw89_sta *rtwsta = (struct rtw89_sta *)sta->drv_priv;
>
> 'sta->drv_priv' is only a pointer, we don't really dereference the
> data right here, so I think this is safe. More, compiler can optimize
> this instruction that reorder it to the place just right before using.
> So, it seems like a false alarm.
>
>> +	struct rtw89_sta *rtwsta;
>> 
>> -	if (!sta || rtwsta->max_agg_wait <= 0)
>> +	if (!sta)
>> +		return false;
>> +	rtwsta = (struct rtw89_sta *)sta->drv_priv;
>> +	if (!rtwsta)
>> +		return false;
>> +	if (rtwsta->max_agg_wait <= 0)
>>  		return false;
>> 
>>  	if (rtwdev->stats.tx_tfc_lv <= RTW89_TFC_MID)
>
> I check the size of object files before/after this patch, and
> the original one is smaller.
>
>    text    data     bss     dec     hex filename
>   16781    3392       1   20174    4ece core-0.o  // original
>   16819    3392       1   20212    4ef4 core-1.o  // after this patch
>
> Do you think it is worth to apply this patch?

I think that we should apply the patch. Even though the compiler _may_
reorder the code, it might choose not to do that.

Another question is that can txq->sta really be null? I didn't check the
code, but if it should be always set when the null check is not needed.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

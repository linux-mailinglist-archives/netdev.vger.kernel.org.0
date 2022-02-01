Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953C04A5C21
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237842AbiBAMXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:23:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:52758 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiBAMXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:23:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98BABCE180E;
        Tue,  1 Feb 2022 12:23:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1798FC340EE;
        Tue,  1 Feb 2022 12:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643718180;
        bh=Xn1NaOZeL2KYasB+5TrvzSGa5oNuP13JS2EpilRaenc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=ci04/5wV3mVvdTf9b2/rpwEh/dfHzJ4kqorC89/systczkUhKJAvupkUkRg11tucw
         p1RaA8E9kJ9ax1Rr/khzQQzP5eA4Ua1vX4EEcpqRKUHkTm9aX2UM8OCEXlgDGHHcGb
         Yu6U+DUA2pqDecDQuONHZxt+PYSZTpNuS9NellT+HAWdDDiiB/+srbwiaIdZHQIBH+
         QE9dAqGwPNNYGmaqtFHUhxkWXMhMxTEkjBXlw3A22ypLlxtlJg1NB75xBlHR0ujAal
         sf2WH+SMq8EONEl6QdwgdxI/iJMBAHDpBx7iDGb2FCulMXWcxx2WD0GCuk7NO+Gx/v
         rjnEyynO62WNQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Pkshih <pkshih@realtek.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "colin.i.king\@gmail.com" <colin.i.king@gmail.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "kuba\@kernel.org" <kuba@kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rtlwifi: remove redundant initialization of variable ul_encalgo
References: <20220130223714.6999-1-colin.i.king@gmail.com>
        <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
Date:   Tue, 01 Feb 2022 14:22:57 +0200
In-Reply-To: <55f8c7f2c75b18cd628d02a25ed96fae676eace2.camel@realtek.com>
        (Pkshih's message of "Mon, 31 Jan 2022 02:53:40 +0000")
Message-ID: <87pmo6dbdq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pkshih <pkshih@realtek.com> writes:

> On Sun, 2022-01-30 at 22:37 +0000, Colin Ian King wrote:
>> Variable ul_encalgo is initialized with a value that is never read,
>> it is being re-assigned a new value in every case in the following
>> switch statement. The initialization is redundant and can be removed.
>> 
>> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/cam.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/cam.c
>> b/drivers/net/wireless/realtek/rtlwifi/cam.c
>> index 7a0355dc6bab..32970ea4b4e7 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/cam.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/cam.c
>> @@ -208,7 +208,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
>>  
>>  	u32 ul_command;
>>  	u32 ul_content;
>> -	u32 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
>> +	u32 ul_encalgo;
>>  	u8 entry_i;
>>  
>>  	switch (rtlpriv->sec.pairwise_enc_algorithm) {
>> -- 
>
> When I check this patch, I find there is no 'break' for default case.
> Do we need one? like
>
> @@ -226,6 +226,7 @@ void rtl_cam_empty_entry(struct ieee80211_hw *hw, u8 uc_index)
>                 break;
>         default:
>                 ul_encalgo = rtlpriv->cfg->maps[SEC_CAM_AES];
> +               break;
>         }
>  
>         for (entry_i = 0; entry_i < CAM_CONTENT_COUNT; entry_i++) {

Yeah, it would be good to have break for consistency. Can someone send a
separate patch for that?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

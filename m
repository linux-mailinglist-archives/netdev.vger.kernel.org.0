Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F253DF473
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 20:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhHCSMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 14:12:49 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:41352
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238829AbhHCSMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 14:12:47 -0400
Received: from [10.172.193.212] (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id F01C73F35B;
        Tue,  3 Aug 2021 18:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1628014354;
        bh=yQXpzRt+qukZtH49AvXR+lZq2BKkun/fs7KiYXTefVQ=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=sU9leV7Hl0yx62sOaASnlhuYnbY7ubcsZiPetMuI0Rn5Sg0XRn32mrsOhqFb30bhH
         YvhvOqdvUaChbu5H0zgpz2hUFrLAQ99NpyE4IJE0adRc4Q379rfGyx3oNhMTBw4sYm
         iS0ae76svGlqGK1PxpTsoVJw/lSSeB1fM7vS1c4nEtN/gc+1vU1CZG1xYK8Gvm4/J0
         G6KKzlV719/SkELeCh2C8vUj0+yMOUBHHmf5mC+YVb+AlCuLH6Iu/j9W9UOla1qCVX
         aI3L/9EllxRTJUaBjgn74udfOIJww/V35uO6tEiDh17Y7LOcrA1cAhaVoNymdGGz9j
         7nSZHRiw1TE/w==
Subject: Re: [PATCH 3/3] rtlwifi: rtl8192de: fix array size limit in for-loop
To:     Joe Perches <joe@perches.com>, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210803144949.79433-1-colin.king@canonical.com>
 <20210803144949.79433-3-colin.king@canonical.com>
 <39b42c868d1aa01bb421733aac32f072dc85e393.camel@perches.com>
From:   Colin Ian King <colin.king@canonical.com>
Message-ID: <3ce51250-bf32-97a6-a7e1-f49b27116907@canonical.com>
Date:   Tue, 3 Aug 2021 19:12:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <39b42c868d1aa01bb421733aac32f072dc85e393.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/08/2021 19:11, Joe Perches wrote:
> On Tue, 2021-08-03 at 15:49 +0100, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Currently the size of the entire array is being used in a for-loop
>> for the element count. While this works since the elements are u8
>> sized, it is preferred to use ARRAY_SIZE to get the element count
>> of the array.
> []
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
> []
>> @@ -1366,7 +1366,7 @@ u8 rtl92d_get_rightchnlplace_for_iqk(u8 chnl)
>>  	u8 place = chnl;
>>
>>  	if (chnl > 14) {
>> -		for (place = 14; place < sizeof(channel_all); place++) {
>> +		for (place = 14; place < ARRAY_SIZE(channel_all); place++) {
>>  			if (channel_all[place] == chnl)
>>  				return place - 13;
>>  		}
> 
> Thanks.
> 
> It seems a relatively common copy/paste use in rtlwifi

Urgh. Let's drop patch 3/3 for the moment. I'll send a fix later on, I'm
kinda tied up for the next 24 hours.


> 
> $ git grep -P -n 'for\b.*<\s*sizeof\s*\(\s*\w+\w*\)\s*;' drivers/net/wireless/realtek/rtlwifi/
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:893:               for (place = 14; place < sizeof(channel5g); place++) {
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:1368:              for (place = 14; place < sizeof(channel_all); place++) {
> drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c:2430:      for (i = 0; i < sizeof(channel5g); i++)
> drivers/net/wireless/realtek/rtlwifi/rtl8192ee/phy.c:2781:              for (place = 14; place < sizeof(channel_all); place++) {
> drivers/net/wireless/realtek/rtlwifi/rtl8723be/phy.c:2170:              for (place = 14; place < sizeof(channel_all); place++) {
> drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3610:              for (place = 14; place < sizeof(channel_all); place++)
> 
> 
> 


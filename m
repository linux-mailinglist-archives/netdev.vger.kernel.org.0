Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4480310E916
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 11:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfLBKm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 05:42:59 -0500
Received: from mail2.sp2max.com.br ([138.185.4.9]:37550 "EHLO
        mail2.sp2max.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfLBKm7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 05:42:59 -0500
Received: from [172.17.0.170] (unknown [190.246.35.95])
        (Authenticated sender: pablo@fliagreco.com.ar)
        by mail2.sp2max.com.br (Postfix) with ESMTPSA id 685907B3059;
        Mon,  2 Dec 2019 07:42:50 -0300 (-03)
Subject: Re: [PATCH v1] mt76: mt7615: Fix build with older compilers
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Roy Luo <royluo@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191201181716.61892-1-pgreco@centosproject.org>
 <0101016ec5ed7d91-eac61501-1e4a-42f1-881d-cc2c02eb8372-000000@us-west-2.amazonses.com>
From:   =?UTF-8?Q?Pablo_Sebasti=c3=a1n_Greco?= <pgreco@centosproject.org>
Message-ID: <8d4a0590-e2ae-948d-83c3-0dc57fa76b8f@centosproject.org>
Date:   Mon, 2 Dec 2019 07:42:48 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <0101016ec5ed7d91-eac61501-1e4a-42f1-881d-cc2c02eb8372-000000@us-west-2.amazonses.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-SP2Max-MailScanner-Information: Please contact the ISP for more information
X-SP2Max-MailScanner-ID: 685907B3059.A16AF
X-SP2Max-MailScanner: Sem Virus encontrado
X-SP2Max-MailScanner-SpamCheck: nao spam, SpamAssassin (not cached,
        escore=-2.9, requerido 6, autolearn=not spam, ALL_TRUSTED -1.00,
        BAYES_00 -1.90)
X-SP2Max-MailScanner-From: pgreco@centosproject.org
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/12/19 06:25, Kalle Valo wrote:
> Pablo Greco <pgreco@centosproject.org> writes:
>
>> Some compilers (tested with 4.8.5 from CentOS 7) fail properly process
>> FIELD_GET inside an inline function, which ends up in a BUILD_BUG_ON.
>> Convert inline function to a macro.
>>
>> Fixes commit bf92e7685100 ("mt76: mt7615: add support for per-chain
>> signal strength reporting")
>> Reported in https://lkml.org/lkml/2019/9/21/146
>>
>> Reported-by: kbuild test robot <lkp@intel.com>
>> Signed-off-by: Pablo Greco <pgreco@centosproject.org>
>> ---
>>   drivers/net/wireless/mediatek/mt76/mt7615/mac.c | 5 +----
>>   1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
>> index c77adc5d2552..77e395ca2c6a 100644
>> --- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
>> +++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
>> @@ -13,10 +13,7 @@
>>   #include "../dma.h"
>>   #include "mac.h"
>>   
>> -static inline s8 to_rssi(u32 field, u32 rxv)
>> -{
>> -	return (FIELD_GET(field, rxv) - 220) / 2;
>> -}
>> +#define to_rssi(field, rxv)		((FIELD_GET(field, rxv) - 220) / 2)
> What about u32_get_bits() instead of FIELD_GET(), would that work? I
> guess chances for that is slim, but it's always a shame to convert a
> function to a macro so we should try other methods first.
Anything that doesn't check field at build time should work, but between 
losing a check, or turning an inline into a macro, I'd rather use the macro.
> Or even better if we could fix FIELD_GET() to work with older compilers.
>
The problem is not FIELD_GET itself, is that the compiler is trying to 
use "field" as a variable, instead as the macro expansion of GENMASK, as 
if the function wasn't inline.
In the linked page you can see this message

BUILD_BUG_ON failed: (((field) + (1ULL << (__builtin_ffsll(field) - 1))) 
& (((field) + (1ULL << (__builtin_ffsll(field) - 1))) - 1)) != 0
      _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

which is is not right, because "field" should never be used for that check.



Pablo.

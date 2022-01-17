Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DED490239
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 07:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234996AbiAQG6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 01:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiAQG6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 01:58:32 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC8BC061574;
        Sun, 16 Jan 2022 22:58:32 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3EC24425B7;
        Mon, 17 Jan 2022 06:58:22 +0000 (UTC)
Subject: Re: [PATCH v2 23/35] brcmfmac: cfg80211: Add support for scan params
 v2
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Dmitry Osipenko <digetx@gmail.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-24-marcan@marcan.st>
 <f909828f-ad8d-a7d6-0e21-7f34ee713da5@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <776c385c-84f8-4716-8561-52f60463e202@marcan.st>
Date:   Mon, 17 Jan 2022 15:58:20 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f909828f-ad8d-a7d6-0e21-7f34ee713da5@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2022 17.50, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> This new API version is required for at least the BCM4387 firmware. Add
>> support for it, with a fallback to the v1 API.
> 
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 113 ++++++++++++++----
>>   .../broadcom/brcm80211/brcmfmac/feature.c     |   1 +
>>   .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
>>   .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  49 +++++++-
>>   4 files changed, 145 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index fb727778312c..71e932a8302c 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -769,12 +769,50 @@ void brcmf_set_mpc(struct brcmf_if *ifp, int mpc)
>>   	}
>>   }
>>   
>> +static void brcmf_escan_prep(struct brcmf_cfg80211_info *cfg,
>> +			     struct brcmf_scan_params_v2_le *params_le,
>> +			     struct cfg80211_scan_request *request);
> 
> I am not a fan of function prototypes so if it can be avoided by simply 
> moving the function that would be preferred over this.

Moved the function for v3 :)

>> +	if (!brcmf_feat_is_enabled(ifp, BRCMF_FEAT_SCAN_V2)) {
> 
> Okay. So it is not really a fallback. Phew!

I meant fallback in case the feature is not present, not fallback from
trying to use it without checking. Thankfully we can use a feature test
for this :-)


-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

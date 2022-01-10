Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43D8248973A
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244593AbiAJLUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:20:18 -0500
Received: from marcansoft.com ([212.63.210.85]:51112 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244640AbiAJLUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 06:20:16 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 8CB3C41AC8;
        Mon, 10 Jan 2022 11:20:04 +0000 (UTC)
Message-ID: <fc945ba3-94b7-773d-4537-3408b10bfe92@marcan.st>
Date:   Mon, 10 Jan 2022 20:20:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 20/35] brcmfmac: pcie: Perform correct BCM4364 firmware
 selection
Content-Language: en-US
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
 <20220104072658.69756-21-marcan@marcan.st>
 <3a957aa1-07f9-dff2-563e-656fffa0db6c@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <3a957aa1-07f9-dff2-563e-656fffa0db6c@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/10 18:12, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> This chip exists in two revisions (B2=r3 and B3=r4) on different
>> platforms, and was added without regard to doing proper firmware
>> selection or differentiating between them. Fix this to have proper
>> per-revision firmwares and support Apple NVRAM selection.
>>
>> Revision B2 is present on at least these Apple T2 Macs:
>>
>> kauai:    MacBook Pro 15" (Touch/2018-2019)
>> maui:     MacBook Pro 13" (Touch/2018-2019)
>> lanai:    Mac mini (Late 2018)
>> ekans:    iMac Pro 27" (5K, Late 2017)
>>
>> And these non-T2 Macs:
>>
>> nihau:    iMac 27" (5K, 2019)
>>
>> Revision B3 is present on at least these Apple T2 Macs:
>>
>> bali:     MacBook Pro 16" (2019)
>> trinidad: MacBook Pro 13" (2020, 4 TB3)
>> borneo:   MacBook Pro 16" (2019, 5600M)
>> kahana:   Mac Pro (2019)
>> kahana:   Mac Pro (2019, Rack)
>> hanauma:  iMac 27" (5K, 2020)
>> kure:     iMac 27" (5K, 2020, 5700/XT)
>>
>> Fixes: 24f0bd136264 ("brcmfmac: add the BRCM 4364 found in MacBook Pro 15,2")
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 11 +++++++++--
>>   1 file changed, 9 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index 87daabb15cd0..e4f2aff3c0d5 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> @@ -54,7 +54,8 @@ BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
>>   BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>>   BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
>>   BRCMF_FW_DEF(4359, "brcmfmac4359-pcie");
>> -BRCMF_FW_DEF(4364, "brcmfmac4364-pcie");
>> +BRCMF_FW_CLM_DEF(4364B2, "brcmfmac4364b2-pcie");
>> +BRCMF_FW_CLM_DEF(4364B3, "brcmfmac4364b3-pcie");
> 
> would this break things for people. Maybe better to keep the old name 
> for the B2 variant.

Or the B3 variant... people have been using random copied firmwares with
the same name, I guess. Probably even the wrong NVRAMs in some cases.
And then I'd have to add a special case to the firmware extraction
script to rename one of these two to not include the revision...

Plus, newer firmwares require the random blob, so this only ever worked
with old, obsolete firmwares... which I think have security
vulnerabilities (there was an AWDL exploit recently IIRC).

Honestly though, there are probably rather few people using upstream
kernels on T2s. Certainly on the MacBooks, since the keyboard/touchpad
aren't supported upstream yet... plus given that there was never any
"official" firmware distributed under the revision-less name, none of
this would work out of the box with upstream kernels anyway.

FWIW, I've been in contact with the t2linux folks and users have been
testing this patchset (that's how I got it tested on all the chips), so
at least some people are already aware of the story and how to get the
firmware named properly :-)

>> -	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFFF, 4364),
>> +	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0x0000000F, 4364B2), /* 3 */
>> +	BRCMF_FW_ENTRY(BRCM_CC_4364_CHIP_ID, 0xFFFFFFF0, 4364B3), /* 4 */
> 
> okay. so it is the numerical chip revision. If so, please drop that comment.
> 

I figured it would be useful to document this somewhere, since the
alphanumeric code -> rev number mapping doesn't seem to be consistent
from chip to chip, and we might have to add a new revision in the future
for an existing chip (which would require knowing the rev for the old
one). Do you have any ideas?

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

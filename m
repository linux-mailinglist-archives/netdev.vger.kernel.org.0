Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC8D484062
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 12:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiADLBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 06:01:07 -0500
Received: from marcansoft.com ([212.63.210.85]:43322 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbiADLBF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Jan 2022 06:01:05 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id EED7741982;
        Tue,  4 Jan 2022 11:00:53 +0000 (UTC)
Message-ID: <58f87db9-385e-0b8c-fa83-ed730731273c@marcan.st>
Date:   Tue, 4 Jan 2022 20:00:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 16/35] brcmfmac: acpi: Add support for fetching Apple
 ACPI properties
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
 <20220104072658.69756-17-marcan@marcan.st>
 <a50d7d46-9298-3d4b-049d-4b3360c6efa7@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <a50d7d46-9298-3d4b-049d-4b3360c6efa7@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 19:21, Arend van Spriel wrote:
> On 1/4/2022 8:26 AM, Hector Martin wrote:
>> On DT platforms, the module-instance and antenna-sku-info properties
>> are passed in the DT. On ACPI platforms, module-instance is passed via
>> the analogous Apple device property mechanism, while the antenna SKU
>> info is instead obtained via an ACPI method that grabs it from
>> non-volatile storage.
>>
>> Add support for this, to allow proper firmware selection on Apple
>> platforms.
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>>   .../broadcom/brcm80211/brcmfmac/acpi.c        | 47 +++++++++++++++++++
>>   .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>>   .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>>   4 files changed, 59 insertions(+)
>>   create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> index 13c13504a6e8..19009eb9db93 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>> @@ -47,3 +47,5 @@ brcmfmac-$(CONFIG_OF) += \
>>   		of.o
>>   brcmfmac-$(CONFIG_DMI) += \
>>   		dmi.o
>> +brcmfmac-$(CONFIG_ACPI) += \
>> +		acpi.o
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>> new file mode 100644
>> index 000000000000..2b1a4448b291
>> --- /dev/null
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>> @@ -0,0 +1,47 @@
>> +// SPDX-License-Identifier: ISC
>> +/*
>> + * Copyright The Asahi Linux Contributors
>> + */
> 
> Common format for copyright statement (in this folder) seems to be:
> 
> Copyright (c) <YEAR> <COPYRIGHT_HOLDER>
> 
> Regards,
> Arend

I get this every time I submit a patch to a new subsystem :-)

This is based on this best practice:

https://www.linuxfoundation.org/blog/copyright-notices-in-open-source-software-projects/

Basically, the year format quickly becomes outdated and is rather
useless, and listing specific names also ends up missing every
subsequent contributor, so more general copyright statements work better
for this kind of use case. In the end we all know git history is the
proper record of copyright status.

I don't have a super strong opinion here, but we've been trying to
standardize on this format for contributions coming from our subproject,
and it feels more useful than a random contributor's name with a date 5
years in the past :)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

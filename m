Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFC1C4896F7
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 12:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244411AbiAJLHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 06:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244396AbiAJLHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 06:07:31 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F192C06173F;
        Mon, 10 Jan 2022 03:07:31 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 15D7C3FA5E;
        Mon, 10 Jan 2022 11:07:17 +0000 (UTC)
Message-ID: <908a6ded-08fb-647f-ffa2-1a5182d2f075@marcan.st>
Date:   Mon, 10 Jan 2022 20:07:15 +0900
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
 <d72bf3e4-1a49-d354-9439-5f52334d2698@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <d72bf3e4-1a49-d354-9439-5f52334d2698@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/10 18:11, Arend van Spriel wrote:
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
> 
> [...]
> 
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
>> +
>> +#include <linux/acpi.h>
>> +#include "debug.h"
>> +#include "core.h"
>> +#include "common.h"
>> +
>> +void brcmf_acpi_probe(struct device *dev, enum brcmf_bus_type bus_type,
>> +		      struct brcmf_mp_device *settings)
>> +{
>> +	acpi_status status;
>> +	const union acpi_object *o;
>> +	struct acpi_buffer buf = {ACPI_ALLOCATE_BUFFER, NULL};
>> +	struct acpi_device *adev = ACPI_COMPANION(dev);
>> +
>> +	if (!adev)
>> +		return;
>> +
>> +	if (!ACPI_FAILURE(acpi_dev_get_property(adev, "module-instance",
>> +						ACPI_TYPE_STRING, &o))) {
>> +		brcmf_dbg(INFO, "ACPI module-instance=%s\n", o->string.pointer);
>> +		settings->board_type = devm_kasprintf(dev, GFP_KERNEL,
>> +						      "apple,%s",
>> +						      o->string.pointer);
>> +	} else {
>> +		brcmf_dbg(INFO, "No ACPI module-instance\n");
> 
> Do you need to obtain the antenna-sku when there is no module-instance?

In principle I don't think any machines would have antenna-sku and no
module-instance, though the firmware selection will still work without
it (it'll just end up using the DMI machine name instead).

> 
>> +	}
>> +
>> +	status = acpi_evaluate_object(adev->handle, "RWCV", NULL, &buf);
> 
> Can you clarify what the above does? What does the "RWCV" mean?

No idea what it *means* :-)

What it is, though, is the ACPI method name to get the antenna-sku.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

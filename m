Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAFE489AFA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 15:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235062AbiAJOBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 09:01:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:49736 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234923AbiAJOBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 09:01:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4A94BCE138A;
        Mon, 10 Jan 2022 14:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D7AC36AE5;
        Mon, 10 Jan 2022 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641823307;
        bh=tQEWCky6yfnzJ102pc1YSKWHFh2AITt+cuSurh1ox6I=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gTPlTJV+ToRZCh/hOAlpZ8rQBIoXF62j7qjMl+kF8Fz/GWNlFi5bTeu7fFsjHDHDM
         ytayOiiIJNdTtrGNrZY3EyPtGll/Awr2W+2Oe9nyAKEfvjy8p/9Ou4TFcvw5YYklgp
         khhIToV6Ju3IxmYAbAqQA35DDbR3la4zjELa4uBb2U3QAHihvuHnj5BuT/Cy/3qVLx
         UuMbLjtnOZDv9iLYSRDDN5PWDtInsDIZIrs7Etwj/MwS4HJo5JTKHSkhwuikWAt3MT
         OvebFXU07GQF7ND03wax7kI0ecZg70G3mDcNQfmOSSXqV1MJuyxTbNka1nAO14oPsn
         tNtuVMexwAPSQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
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
        Dmitry Osipenko <digetx@gmail.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
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
Subject: Re: [PATCH v2 16/35] brcmfmac: acpi: Add support for fetching Apple ACPI properties
References: <20220104072658.69756-1-marcan@marcan.st>
        <20220104072658.69756-17-marcan@marcan.st>
        <a50d7d46-9298-3d4b-049d-4b3360c6efa7@broadcom.com>
        <58f87db9-385e-0b8c-fa83-ed730731273c@marcan.st>
Date:   Mon, 10 Jan 2022 16:01:38 +0200
In-Reply-To: <58f87db9-385e-0b8c-fa83-ed730731273c@marcan.st> (Hector Martin's
        message of "Tue, 4 Jan 2022 20:00:51 +0900")
Message-ID: <877db7lmf1.fsf@tynnyri.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hector Martin <marcan@marcan.st> writes:

> On 2022/01/04 19:21, Arend van Spriel wrote:
>> On 1/4/2022 8:26 AM, Hector Martin wrote:
>>> On DT platforms, the module-instance and antenna-sku-info properties
>>> are passed in the DT. On ACPI platforms, module-instance is passed via
>>> the analogous Apple device property mechanism, while the antenna SKU
>>> info is instead obtained via an ACPI method that grabs it from
>>> non-volatile storage.
>>>
>>> Add support for this, to allow proper firmware selection on Apple
>>> platforms.
>>>
>>> Signed-off-by: Hector Martin <marcan@marcan.st>
>>> ---
>>>   .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>>>   .../broadcom/brcm80211/brcmfmac/acpi.c        | 47 +++++++++++++++++++
>>>   .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>>>   .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>>>   4 files changed, 59 insertions(+)
>>>   create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>>> index 13c13504a6e8..19009eb9db93 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
>>> @@ -47,3 +47,5 @@ brcmfmac-$(CONFIG_OF) += \
>>>   		of.o
>>>   brcmfmac-$(CONFIG_DMI) += \
>>>   		dmi.o
>>> +brcmfmac-$(CONFIG_ACPI) += \
>>> +		acpi.o
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>> new file mode 100644
>>> index 000000000000..2b1a4448b291
>>> --- /dev/null
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c
>>> @@ -0,0 +1,47 @@
>>> +// SPDX-License-Identifier: ISC
>>> +/*
>>> + * Copyright The Asahi Linux Contributors
>>> + */
>> 
>> Common format for copyright statement (in this folder) seems to be:
>> 
>> Copyright (c) <YEAR> <COPYRIGHT_HOLDER>
>> 
>> Regards,
>> Arend
>
> I get this every time I submit a patch to a new subsystem :-)
>
> This is based on this best practice:
>
> https://www.linuxfoundation.org/blog/copyright-notices-in-open-source-software-projects/

I didn't know about this recommendation, thanks.

> Basically, the year format quickly becomes outdated and is rather
> useless, and listing specific names also ends up missing every
> subsequent contributor, so more general copyright statements work better
> for this kind of use case. In the end we all know git history is the
> proper record of copyright status.
>
> I don't have a super strong opinion here, but we've been trying to
> standardize on this format for contributions coming from our subproject,
> and it feels more useful than a random contributor's name with a date 5
> years in the past :)

If LF is fine with this approach, then it's good enough also for me. So
at least from my point of view no need to make any changes.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

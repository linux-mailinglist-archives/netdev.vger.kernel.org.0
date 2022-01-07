Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E81C487187
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 04:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbiAGDyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 22:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbiAGDyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 22:54:51 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BC0C061245;
        Thu,  6 Jan 2022 19:54:51 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 01BCF4212E;
        Fri,  7 Jan 2022 03:54:41 +0000 (UTC)
Message-ID: <dc93cd06-05c7-fc52-d1bc-3502ae131940@marcan.st>
Date:   Fri, 7 Jan 2022 12:54:39 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 08/35] brcmfmac: of: Fetch Apple properties
Content-Language: en-US
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
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
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-9-marcan@marcan.st>
 <CAHp75Ve4N7qOtMhvwGWmQ7VF9guYP6YuvFvBqDY_aXbiCsO0vA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75Ve4N7qOtMhvwGWmQ7VF9guYP6YuvFvBqDY_aXbiCsO0vA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/04 20:17, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:
>>
>> On Apple ARM64 platforms, firmware selection requires two properties
>> that come from system firmware: the module-instance (aka "island", a
>> codename representing a given hardware platform) and the antenna-sku.
>> We map Apple's module codenames to board_types in the form
>> "apple,<module-instance>".
>>
>> The mapped board_type is added to the DTS file in that form, while the
>> antenna-sku is forwarded by our bootloader from the Apple Device Tree
>> into the FDT. Grab them from the DT so firmware selection can use
>> them.
> 
>> +       /* Apple ARM64 platforms have their own idea of board type, passed in
>> +        * via the device tree. They also have an antenna SKU parameter
>> +        */
>> +       if (!of_property_read_string(np, "brcm,board-type", &prop))
>> +               settings->board_type = devm_kstrdup(dev, prop, GFP_KERNEL);
>> +
>> +       if (!of_property_read_string(np, "apple,antenna-sku", &prop))
>> +               settings->antenna_sku = devm_kstrdup(dev, prop, GFP_KERNEL);
> 
> No error checks?
> But hold on, why do you need to copy them? Are you expecting this to be in DTO?

Yeah, I was wondering about that... indeed it shouldn't be necessary to
copy them.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

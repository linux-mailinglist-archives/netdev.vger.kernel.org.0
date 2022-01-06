Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB12486504
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 14:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbiAFNNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 08:13:08 -0500
Received: from marcansoft.com ([212.63.210.85]:59596 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238990AbiAFNNH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jan 2022 08:13:07 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6B6A841F5D;
        Thu,  6 Jan 2022 13:12:58 +0000 (UTC)
Subject: Re: [PATCH v2 09/35] brcmfmac: pcie: Perform firmware selection for
 Apple platforms
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
 <20220104072658.69756-10-marcan@marcan.st>
 <CAHp75VeN=RkBHnNkQB7_WwjtKuk9OP=utZp+tMf18VF2=CogkA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <f4dfbb6b-b635-e9b3-5e5b-8527cf1e4f60@marcan.st>
Date:   Thu, 6 Jan 2022 22:12:56 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VeN=RkBHnNkQB7_WwjtKuk9OP=utZp+tMf18VF2=CogkA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2022 23.24, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:28 AM Hector Martin <marcan@marcan.st> wrote:

>> +               /* Example: apple,shikoku-RASP-m-6.11-X3 */
>> +               len = (strlen(devinfo->settings->board_type) + 1 +
>> +                      strlen(devinfo->otp.module) + 1 +
>> +                      strlen(devinfo->otp.vendor) + 1 +
>> +                      strlen(devinfo->otp.version) + 1 +
>> +                      strlen(devinfo->settings->antenna_sku) + 1);
> 
> NIH devm_kasprrintf() ?

This one builds it incrementally, but you're right, kasprintf is
probably more readable here and fewer lines even though it'll duplicate
all the previous argument references for each pattern. I'll redo it with
devm_kasprintf().

> 
>> +               /* apple,shikoku */
>> +               fwreq->board_types[5] = devinfo->settings->board_type;
>> +
>> +               buf = devm_kzalloc(&devinfo->pdev->dev, len, GFP_KERNEL);
>> +
>> +               strscpy(buf, devinfo->settings->board_type, len);
>> +               strlcat(buf, "-", len);
>> +               strlcat(buf, devinfo->settings->antenna_sku, len);
>> +               /* apple,shikoku-X3 */
>> +               fwreq->board_types[4] = devm_kstrdup(&devinfo->pdev->dev, buf,
>> +                                                    GFP_KERNEL);
>> +
>> +               strscpy(buf, devinfo->settings->board_type, len);
>> +               strlcat(buf, "-", len);
>> +               strlcat(buf, devinfo->otp.module, len);
>> +               /* apple,shikoku-RASP */
>> +               fwreq->board_types[3] = devm_kstrdup(&devinfo->pdev->dev, buf,
>> +                                                    GFP_KERNEL);
>> +
>> +               strlcat(buf, "-", len);
>> +               strlcat(buf, devinfo->otp.vendor, len);
>> +               /* apple,shikoku-RASP-m */
>> +               fwreq->board_types[2] = devm_kstrdup(&devinfo->pdev->dev, buf,
>> +                                                    GFP_KERNEL);
>> +
>> +               strlcat(buf, "-", len);
>> +               strlcat(buf, devinfo->otp.version, len);
>> +               /* apple,shikoku-RASP-m-6.11 */
>> +               fwreq->board_types[1] = devm_kstrdup(&devinfo->pdev->dev, buf,
>> +                                                    GFP_KERNEL);
>> +
>> +               strlcat(buf, "-", len);
>> +               strlcat(buf, devinfo->settings->antenna_sku, len);
>> +               /* apple,shikoku-RASP-m-6.11-X3 */
>> +               fwreq->board_types[0] = buf;
> 


-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

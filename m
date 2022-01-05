Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4670C485391
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:27:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240351AbiAEN07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:26:59 -0500
Received: from marcansoft.com ([212.63.210.85]:43092 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236846AbiAEN04 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 08:26:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id CAEB441F4A;
        Wed,  5 Jan 2022 13:26:46 +0000 (UTC)
Subject: Re: [PATCH v2 10/35] brcmfmac: firmware: Allow platform to override
 macaddr
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
 <20220104072658.69756-11-marcan@marcan.st>
 <CAHp75VcU1vVSucvegmSiMLoKBoPoGW5XLmqVUG0vXGdeafm2Jw@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <b4f50489-fa4b-2c40-31ad-1b74e916cdb4@marcan.st>
Date:   Wed, 5 Jan 2022 22:26:44 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAHp75VcU1vVSucvegmSiMLoKBoPoGW5XLmqVUG0vXGdeafm2Jw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2022 23.23, Andy Shevchenko wrote:
> On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
>>
>> On Device Tree platforms, it is customary to be able to set the MAC
>> address via the Device Tree, as it is often stored in system firmware.
>> This is particularly relevant for Apple ARM64 platforms, where this
>> information comes from system configuration and passed through by the
>> bootloader into the DT.
>>
>> Implement support for this by fetching the platform MAC address and
>> adding or replacing the macaddr= property in nvram. This becomes the
>> dongle's default MAC address.
>>
>> On platforms with an SROM MAC address, this overrides it. On platforms
>> without one, such as Apple ARM64 devices, this is required for the
>> firmware to boot (it will fail if it does not have a valid MAC at all).
> 
> ...
> 
>> +#define BRCMF_FW_MACADDR_FMT                   "macaddr=%pM"
>> +#define BRCMF_FW_MACADDR_LEN                   (7 + ETH_ALEN * 3)
> 
> ...
> 
>>                 if (strncmp(&nvp->data[nvp->entry], "boardrev", 8) == 0)
>>                         nvp->boardrev_found = true;
>> +               /* strip macaddr if platform MAC overrides */
>> +               if (nvp->strip_mac &&
>> +                   strncmp(&nvp->data[nvp->entry], "macaddr", 7) == 0)
> 
> If it has no side effects, I would rather swap the operands of && so
> you match string first (it will be in align with above code at least,
> although I haven't checked bigger context).

I usually check for trivial flags before calling more expensive
functions because it's more efficient in the common case. Obviously here
performance doesn't matter though.

> 
> ....
> 
>> +static void brcmf_fw_add_macaddr(struct nvram_parser *nvp, u8 *mac)
>> +{
>> +       snprintf(&nvp->nvram[nvp->nvram_len], BRCMF_FW_MACADDR_LEN + 1,
>> +                BRCMF_FW_MACADDR_FMT, mac);
> 
> Please, avoid using implict format string, it's dangerous from security p.o.v.

What do you mean by implicit format string? The format string is at the
top of the file and its length is right next to it, which makes it
harder for them to accidentally fall out of sync.

+#define BRCMF_FW_MACADDR_FMT			"macaddr=%pM"
+#define BRCMF_FW_MACADDR_LEN			(7 + ETH_ALEN * 3)

> 
>> +       nvp->nvram_len += BRCMF_FW_MACADDR_LEN + 1;
> 
> Also, with temporary variable the code can be better to read
> 
> size_t mac_len = ...;
> 

Sure.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

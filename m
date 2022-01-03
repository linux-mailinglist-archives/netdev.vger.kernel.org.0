Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBBE9482E3B
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 06:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231710AbiACFmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 00:42:52 -0500
Received: from marcansoft.com ([212.63.210.85]:55962 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229527AbiACFmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 00:42:51 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 9BCA4424D9;
        Mon,  3 Jan 2022 05:42:41 +0000 (UTC)
Message-ID: <f6d7bc13-06ac-b4da-bfde-c115e702b8a8@marcan.st>
Date:   Mon, 3 Jan 2022 14:42:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 10/34] brcmfmac: firmware: Allow platform to override
 macaddr
Content-Language: en-US
To:     Linus Walleij <linus.walleij@linaro.org>
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
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-11-marcan@marcan.st>
 <CACRpkdbviGvBoAOLfLPe-auabYd-iMmpxerTiB4whQ3r+QTMeg@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CACRpkdbviGvBoAOLfLPe-auabYd-iMmpxerTiB4whQ3r+QTMeg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/02 14:50, Linus Walleij wrote:
> On Sun, Dec 26, 2021 at 4:37 PM Hector Martin <marcan@marcan.st> wrote:
> 
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
>>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
> 
> This looks very helpful.
> 
>> +       /* Add space for properties we may add */
>> +       size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
>> +       size += BRCMF_FW_MACADDR_LEN + 1;
> 
> Add some note to the commit log why you also make space for
> boardrev? (Looks useful.) Is the boardrev spacing in the right
> patch?

Ah, that was a drive-by fix. While adding the MACADDR space I noticed we
weren't allocating space for BOARDREV... not sure if any platforms hit
this; it would cause an overflow if there are platforms with no
board_rev in the nvram that also don't have enough comments/junk to
otherwise make space for it.

I'll move it to another patch so it's more evident, and it should get a
Fixes: too.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

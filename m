Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 394B7490234
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 07:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbiAQG5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 01:57:37 -0500
Received: from marcansoft.com ([212.63.210.85]:56888 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231831AbiAQG5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jan 2022 01:57:36 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 05597425B7;
        Mon, 17 Jan 2022 06:57:26 +0000 (UTC)
Subject: Re: [PATCH v2 23/35] brcmfmac: cfg80211: Add support for scan params
 v2
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
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
 <17e26a0de80.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Message-ID: <773f6732-3b2d-3b73-c8e6-0aed89f6b415@marcan.st>
Date:   Mon, 17 Jan 2022 15:57:24 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <17e26a0de80.279b.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 04.46, Arend Van Spriel wrote:
> On January 4, 2022 8:30:51 AM Hector Martin <marcan@marcan.st> wrote:
> 
>> This new API version is required for at least the BCM4387 firmware. Add
>> support for it, with a fallback to the v1 API.
>>
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>> .../broadcom/brcm80211/brcmfmac/cfg80211.c    | 113 ++++++++++++++----
>> .../broadcom/brcm80211/brcmfmac/feature.c     |   1 +
>> .../broadcom/brcm80211/brcmfmac/feature.h     |   4 +-
>> .../broadcom/brcm80211/brcmfmac/fwil_types.h  |  49 +++++++-
>> 4 files changed, 145 insertions(+), 22 deletions(-)
> 
> Compiling this patch with C=2 gives following warnings:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1086:28: 
> warning: incorrect type in assignment (different base types)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1086:28: 
> expected restricted __le16 [usertype] version
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1086:28: got int
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1148:38: 
> warning: incorrect type in assignment (different base types)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1148:38: 
> expected restricted __le32 [usertype] scan_type
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:1148:38: got int
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:789:30: 
> warning: incorrect type in assignment (different base types)
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:789:30: 
> expected unsigned char [usertype] scan_type
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c:789:30: got 
> restricted __le32 [usertype] scan_type
> 
> Will check if this is a valid warning.

Those are valid bugs (it'd break on big endian platforms), thanks for
checking this. Fixed for v3 :)

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

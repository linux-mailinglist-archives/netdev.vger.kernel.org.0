Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98036482E6E
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 07:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbiACGSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 01:18:05 -0500
Received: from marcansoft.com ([212.63.210.85]:36554 "EHLO mail.marcansoft.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbiACGSE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jan 2022 01:18:04 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0800142528;
        Mon,  3 Jan 2022 06:17:53 +0000 (UTC)
Message-ID: <f08c15d8-3944-84bf-1032-76ac3b75e298@marcan.st>
Date:   Mon, 3 Jan 2022 15:17:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
Content-Language: en-US
To:     Dmitry Osipenko <digetx@gmail.com>,
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
        Wright Feng <wright.feng@infineon.com>
Cc:     Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Mark Kettenis <kettenis@openbsd.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "brian m. carlson" <sandals@crustytoothpaste.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20211226153624.162281-1-marcan@marcan.st>
 <20211226153624.162281-4-marcan@marcan.st>
 <8e99eb47-2bc1-7899-5829-96f2a515b2cb@gmail.com>
 <e9ecbd0b-8741-1e7d-ae7a-f839287cb5c9@marcan.st>
 <48f16559-6891-9401-dd8e-762c7573304c@gmail.com>
 <d96fe60e-c029-b400-9c29-0f95c3632301@marcan.st>
 <4a307f13-0bd3-5fa5-dd51-9cd1d39eaa33@gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <4a307f13-0bd3-5fa5-dd51-9cd1d39eaa33@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/03 10:26, Dmitry Osipenko wrote:
> 03.01.2022 03:41, Hector Martin пишет:
>>> There is indeed no need for the castings in such cases, it's a typical
>>> code pattern in kernel. You would need to do the casting for the other
>>> way around, i.e. if char ** was returned and **alt_paths was a const.
>> You do need to do the cast. Try it.
>>
>> $ cat test.c
>> int main() {
>>         char *foo[1];
>>         const char **bar = foo;
>>
>>         return 0;
>> }
>>
>> $ gcc test.c
>> test.c: In function ‘main’:
>> test.c:4:28: warning: initialization of ‘const char **’ from
>> incompatible pointer type ‘char **’ [-Wincompatible-pointer-types]
>>     4 |         const char **bar = foo;
>>       |
>>
>> You can implicitly cast char* to const char*, but you *cannot*
>> impliclicitly cast char** to const char** for the reason I explained. It
>> requires a cast.
> 
> Right, I read it as "char * const *". The "const char **" vs "char *
> const *" always confuses me.
> 
> Hence you should've written "const char **alt_paths;" in
> brcm_alt_fw_paths() in the first place and then casting wouldn't have
> been needed.

Sure, in this case that works since the string is just strduped and
never mutated. Either way this will change to an argument instead of a
return value, since I'll change it to be statically sized as you said
and allocated by the caller (or in the struct).

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

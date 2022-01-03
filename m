Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4BB482D55
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 01:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiACAlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 19:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbiACAlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 19:41:39 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EBE2C061761;
        Sun,  2 Jan 2022 16:41:39 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id C9A494267B;
        Mon,  3 Jan 2022 00:41:29 +0000 (UTC)
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
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH 03/34] brcmfmac: firmware: Support having multiple alt
 paths
Message-ID: <d96fe60e-c029-b400-9c29-0f95c3632301@marcan.st>
Date:   Mon, 3 Jan 2022 09:41:27 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <48f16559-6891-9401-dd8e-762c7573304c@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/01/2022 05.11, Dmitry Osipenko wrote:
> 02.01.2022 17:18, Hector Martin пишет:
>> On 2022/01/02 15:45, Dmitry Osipenko wrote:
>>> 26.12.2021 18:35, Hector Martin пишет:
>>>> -static char *brcm_alt_fw_path(const char *path, const char *board_type)
>>>> +static const char **brcm_alt_fw_paths(const char *path, const char *board_type)
>>>>  {
>>>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>>> +	char **alt_paths;
>>>>  	char suffix[5];
>>>>  
>>>>  	strscpy(alt_path, path, BRCMF_FW_NAME_LEN);
>>>> @@ -609,27 +612,46 @@ static char *brcm_alt_fw_path(const char *path, const char *board_type)
>>>>  	strlcat(alt_path, board_type, BRCMF_FW_NAME_LEN);
>>>>  	strlcat(alt_path, suffix, BRCMF_FW_NAME_LEN);
>>>>  
>>>> -	return kstrdup(alt_path, GFP_KERNEL);
>>>> +	alt_paths = kzalloc(sizeof(char *) * 2, GFP_KERNEL);
>>>
>>> array_size()?
>>
>> Of what array?
> 
> array_size(sizeof(*alt_paths), 2)

Heh, TIL. I thought you meant ARRAY_SIZE. First time I see the lowercase
macro. That's a confusing name collision...

>>>> +	alt_paths[0] = kstrdup(alt_path, GFP_KERNEL);
>>>> +
>>>> +	return (const char **)alt_paths;
>>>
>>> Why this casting is needed?
>>
>> Because implicit conversion from char ** to const char ** is not legal
>> in C, as that could cause const unsoundness if you do this:
>>
>> char *foo[1];
>> const char **bar = foo;
>>
>> bar[0] = "constant string";
>> foo[0][0] = '!'; // clobbers constant string
> 
> It's up to a programmer to decide what is right to do. C gives you
> flexibility, meanwhile it's easy to shoot yourself in the foot if you
> won't be careful.

Which is why that conversion is illegal without a cast and you need to
explicitly choose to shoot yourself in the foot :-)

>> But it's fine in this case since the non-const pointer disappears so
>> nothing can ever write through it again.
>>
> 
> There is indeed no need for the castings in such cases, it's a typical
> code pattern in kernel. You would need to do the casting for the other
> way around, i.e. if char ** was returned and **alt_paths was a const.

You do need to do the cast. Try it.

$ cat test.c
int main() {
        char *foo[1];
        const char **bar = foo;

        return 0;
}

$ gcc test.c
test.c: In function ‘main’:
test.c:4:28: warning: initialization of ‘const char **’ from
incompatible pointer type ‘char **’ [-Wincompatible-pointer-types]
    4 |         const char **bar = foo;
      |

You can implicitly cast char* to const char*, but you *cannot*
impliclicitly cast char** to const char** for the reason I explained. It
requires a cast.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85E248537F
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 14:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240275AbiAENWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 08:22:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235186AbiAENWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 08:22:33 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 139DBC061784;
        Wed,  5 Jan 2022 05:22:31 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 6DA8541F4A;
        Wed,  5 Jan 2022 13:22:22 +0000 (UTC)
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
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20220104072658.69756-1-marcan@marcan.st>
 <20220104072658.69756-5-marcan@marcan.st>
 <5ddde705-f3fa-ff78-4d43-7a02d6efaaa6@gmail.com>
 <7c8d5655-a041-e291-95c1-be200233f87f@marcan.st>
 <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2 04/35] brcmfmac: firmware: Support having multiple alt
 paths
Message-ID: <6a936aea-ada4-fe2d-7ce6-7a42788e4d63@marcan.st>
Date:   Wed, 5 Jan 2022 22:22:19 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8394dbcd-f500-b1ae-fcd8-15485d8c0888@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: es-ES
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/01/2022 07.09, Dmitry Osipenko wrote:
> 04.01.2022 11:43, Hector Martin пишет:
>>>> +static int brcm_alt_fw_paths(const char *path, const char *board_type,
>>>> +			     const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS])>  {
>>>>  	char alt_path[BRCMF_FW_NAME_LEN];
>>>>  	const char *suffix;
>>>>  
>>>> +	memset(alt_paths, 0, array_size(sizeof(*alt_paths),
>>>> +					BRCMF_FW_MAX_ALT_PATHS));
>>> You don't need to use array_size() since size of a fixed array is
>>> already known.
>>>
>>> memset(alt_paths, 0, sizeof(alt_paths));
>> It's a function argument, so that doesn't work and actually throws a
>> warning. Array function argument notation is informative only; they
>> behave strictly equivalent to pointers. Try it:
>>
>> $ cat test.c
>> #include <stdio.h>
>>
>> void foo(char x[42])
>> {
>> 	printf("%ld\n", sizeof(x));
>> }
>>
>> int main() {
>> 	char x[42];
>>
>> 	foo(x);
>> }
>> $ gcc test.c
>> test.c: In function ‘foo’:
>> test.c:5:31: warning: ‘sizeof’ on array function parameter ‘x’ will
>> return size of ‘char *’ [-Wsizeof-array-argument]
>>     5 |         printf("%ld\n", sizeof(x));
>>       |                               ^
>> test.c:3:15: note: declared here
>>     3 | void foo(char x[42])
>>       |          ~~~~~^~~~~
>> $ ./a.out
>> 8
> 
> Then please use "const char **alt_paths" for the function argument to
> make code cleaner and add another argument to pass the number of array
> elements.

So you want me to do the ARRAY_SIZE at the caller side then?

> 
> static int brcm_alt_fw_paths(const char *path, const char *board_type,
> 			     const char **alt_paths, unsigned int num_paths)
> {
> 	size_t alt_paths_size = array_size(sizeof(*alt_paths), num_paths);
> 	
> 	memset(alt_paths, 0, alt_paths_size);
> }
> 
> ...
> 
> Maybe even better create a dedicated struct for the alt_paths:
> 
> struct brcmf_fw_alt_paths {
> 	const char *alt_paths[BRCMF_FW_MAX_ALT_PATHS];
> 	unsigned int index;
> };
> 
> and then use the ".index" in the brcm_free_alt_fw_paths(). I suppose
> this will make code a bit nicer and easier to follow.
> 

I'm confused; the array size is constant. What would index contain and
why would would brcm_free_alt_fw_paths use it? Just as an iterator
variable instead of using a local variable? Or do you mean count?

Though, to be honest, at this point I'm considering rethinking the whole
patch for this mechanism because I'm not terribly happy with the current
approach and clearly you aren't either :-) Maybe it makes more sense to
stop trying to compute all the alt_paths ahead of time, and just have
the function compute a single one to be used just-in-time at firmware
request time, and just iterate over board_types.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

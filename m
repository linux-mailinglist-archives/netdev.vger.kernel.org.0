Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 413E3487095
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345495AbiAGCjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345477AbiAGCjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:39:23 -0500
Received: from mail.marcansoft.com (marcansoft.com [IPv6:2a01:298:fe:f::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB556C061245;
        Thu,  6 Jan 2022 18:39:22 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 0F82943320;
        Fri,  7 Jan 2022 02:39:11 +0000 (UTC)
Message-ID: <8febb957-9653-dac4-ea20-f2750d400d01@marcan.st>
Date:   Fri, 7 Jan 2022 11:39:09 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v2 10/35] brcmfmac: firmware: Allow platform to override
 macaddr
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
 <20220104072658.69756-11-marcan@marcan.st>
 <CAHp75VcU1vVSucvegmSiMLoKBoPoGW5XLmqVUG0vXGdeafm2Jw@mail.gmail.com>
 <b4f50489-fa4b-2c40-31ad-1b74e916cdb4@marcan.st>
 <CAHp75VdzQhkj3ovFSAG4g1tD1scBK7H0xFFot0rfz2u6i8a3FA@mail.gmail.com>
From:   Hector Martin <marcan@marcan.st>
In-Reply-To: <CAHp75VdzQhkj3ovFSAG4g1tD1scBK7H0xFFot0rfz2u6i8a3FA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/01/06 23:20, Andy Shevchenko wrote:
> On Wed, Jan 5, 2022 at 3:26 PM Hector Martin <marcan@marcan.st> wrote:
>> On 04/01/2022 23.23, Andy Shevchenko wrote:
>>> On Tue, Jan 4, 2022 at 9:29 AM Hector Martin <marcan@marcan.st> wrote:
> 
> ...
> 
>>>> +#define BRCMF_FW_MACADDR_FMT                   "macaddr=%pM"
> 
>>>> +       snprintf(&nvp->nvram[nvp->nvram_len], BRCMF_FW_MACADDR_LEN + 1,
>>>> +                BRCMF_FW_MACADDR_FMT, mac);
>>>
>>> Please, avoid using implict format string, it's dangerous from security p.o.v.
>>
>> What do you mean by implicit format string?
> 
> When I read the above code I feel uncomfortable because no-one can see
> (without additional action and more reading and checking) if it's
> correct or not. This is potential to be error prone.
> 
>> The format string is at the
>> top of the file and its length is right next to it, which makes it
>> harder for them to accidentally fall out of sync.
> 
> It is not an argument. Just you may do the same in the code directly
> and more explicitly:

The point is that BRCMF_FW_MACADDR_LEN and BRCMF_FW_MACADDR_FMT need to
be in sync, and BRCMF_FW_MACADDR_LEN is used in two different places. If
I inline the format string into the code, someone could change it
without changing the length, or changing the length inline only next to
the format string. Then we overflow the NVRAM buffer because the
allocation is not sized properly.

By having them as defines, it is obvious that they go together, and if
one changes the other one has to change too, and the nvram allocation
can't end up improperly sized as long as they are kept in sync.

> Also you don't check the return code of snprintf which means that you
> don't care about the result, which seems to me wrong approach. If you
> don't care about the result, so it means it's not very important,
> right?
> 

That snprintf can never fail as long as the format string/length are in
sync. I'll make it BUG_ON(... != size), so it complains loudly if
someone screws up the format string in the future.

-- 
Hector Martin (marcan@marcan.st)
Public Key: https://mrcn.st/pub

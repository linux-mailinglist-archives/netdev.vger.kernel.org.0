Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8084660459
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 17:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbjAFQfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 11:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbjAFQfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 11:35:44 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FEE777E7;
        Fri,  6 Jan 2023 08:35:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id EDA63425F5;
        Fri,  6 Jan 2023 16:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1673022939; bh=89y7NsFS+v4aw4niloxNfhOvjApWwxZ5Xy0E6uaeOlw=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=fERt/yltWB3jC395niUM/SwsAnPcR3pbB7XkYefi2ScEZr9CGqDROZsqYHeaXYUt3
         IRKM9kVc7ubodizHfIpUI+18RSNO8FbzOvzrNKpl/woDXmEGTkjp/bM/ayEwaZNDCi
         5Dot7L2oqAvqEvfHSxW7x3X28PJlssGpQaumvD9LvR3Xby2gWiztK8TnuKUksuiMC3
         3y0qG8T0hRNfRv2/5RhyCRaTsvilbTUk5BqQoJ9knY4h1MsaqU2QfeLA+jpy2pDv57
         b1bfZi79Vym/FhIgTJqR/ZWo+ZQnhsBnCxfJTWcUbYTlui16wECTeCJC9PNSAaVR4h
         SlFpofTsnp5/w==
Message-ID: <3cf5c1cd-1cc3-35bb-db65-e7f4a3f00527@marcan.st>
Date:   Sat, 7 Jan 2023 01:35:31 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Arend Van Spriel <aspriel@gmail.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, stefan.wahren@i2se.com,
        pbrobinson@gmail.com, jforbes@fedoraproject.org, kvalo@kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, stable@vger.kernel.org
References: <20230106131905.81854-1-iivanov@suse.de>
 <0b277149-867b-8acf-30d8-2cd68ba24c99@gmail.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v2] brcmfmac: Prefer DT board type over DMI board type
In-Reply-To: <0b277149-867b-8acf-30d8-2cd68ba24c99@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/01/2023 01.21, Arend Van Spriel wrote:
> On 1/6/2023 2:19 PM, Ivan T. Ivanov wrote:
>> The introduction of support for Apple board types inadvertently changed
>> the precedence order, causing hybrid SMBIOS+DT platforms to look up the
>> firmware using the DMI information instead of the device tree compatible
>> to generate the board type. Revert back to the old behavior,
>> as affected platforms use firmwares named after the DT compatible.
>>
>> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
>>
>> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
> 
> Looks good to me. I do have a question about the devicetree node for 
> brcmfmac. The driver does a compatible check against 
> "brcm,bcm4329-fmac". I actually expect all devicetree specifications to 
> use this. That said I noticed the check for it in brcmf_of_probe() 
> should be moved so it is the first check done.

We're talking about the machine compatible in the root OF node, not the
compatible for the device itself. That's how firmware selection for
non-Apple platforms works (and has worked since before the Apple stuff
got introduced): first try the machine type which is either derived from
DMI info or the root compatible, and fall back to generic firmware.

The device compatible is indeed always brcm,bcm4329-fmac.

- Hector

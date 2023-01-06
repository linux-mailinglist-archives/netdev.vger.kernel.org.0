Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D482D660012
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:14:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjAFMNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjAFMNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:13:43 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F553E853;
        Fri,  6 Jan 2023 04:13:41 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id D1820425C6;
        Fri,  6 Jan 2023 12:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1673007219; bh=ffTqLBgC6Oc9QYx+/49/fsiTf1EZpYb2tADAI8jUA30=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To;
        b=y7oeNNeEEuPSzkjmIRnkQmDbxuTq+bp1qa/Tizo6eqU28HCmuqvLeECXWRu1DGBNt
         /tmo2EKfezQpmGnCOmgOuzrh/uhsUs6t3rTZULUiHDcs4gJMZ8KCRg5amJhRDkStQ/
         s17ZeRXhOD/AzADNBEGr3CbJ0mzMmnCFgDmRdrSQhkaZoQmnQSUZd1CXH6WKAYzZ4x
         1nyrqICv8AhGSLhLM5P8LTf2sB08SQJdNIT4XOmOIt1o3eIJIgl8x7SF3E0IGYDE+n
         2cCzVJ3LdSpCAUzkhTMTT33nc1fnoU6wCqwCxo41JEE0o1uyjHd8Mk62KDZ+lTjYkF
         HlTccZjfrjPog==
Message-ID: <2711b084-5937-7e0f-26d8-67510da3939c@marcan.st>
Date:   Fri, 6 Jan 2023 21:13:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] brcmfmac: of: Use board compatible string for board type
Content-Language: en-US
From:   Hector Martin <marcan@marcan.st>
To:     "Ivan T. Ivanov" <iivanov@suse.de>, aspriel@gmail.com
Cc:     franky.lin@broadcom.com, hante.meuleman@broadcom.com,
        rmk+kernel@armlinux.org.uk, kvalo@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
References: <20230106072746.29516-1-iivanov@suse.de>
 <fc6d3c3b-1352-4f75-cbef-d29bd74c0e40@marcan.st>
In-Reply-To: <fc6d3c3b-1352-4f75-cbef-d29bd74c0e40@marcan.st>
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

On 2023/01/06 18:27, Hector Martin wrote:
> On 2023/01/06 16:27, Ivan T. Ivanov wrote:
>> When "brcm,board-type" is not explicitly set in devicetree
>> fallback to board compatible string for board type.
>>
>> Some of the existing devices rely on the most compatible device
>> string to find best firmware files, including Raspberry PI's[1].
>>
>> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
>>
>> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
>>
>> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
> 
> The existing code already falls back to the compatible string, *as long
> as there is no board_type set already*.
> 
> As far as I can tell, the only way the board_type can get another value
> first is if it comes from DMI. This behavior was inadvertently changed
> by commit 7682de8b3351 (since I was not expecting platforms to have
> *both* DT and DMI information).
> 
> I'm guessing the Raspberry Pi is one such platform, and
> `/sys/devices/virtual/dmi` exists? Hybrid UEFI+ACPI+DT platform I take it?
> 
> If so, your commit description should probably be something like:
> 
> ===
> brcmfmac: Prefer DT board type over DMI board type
> 
> The introduction of support for Apple board types inadvertently changed
> the precedence order, causing hybrid ACPI+DT platforms to look up the
> firmware using the DMI information instead of the device tree compatible
> to generate the board type. Revert back to the old behavior,
> as affected platforms use firmwares named after the DT compatible.
> 
> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
> ===
> 
> An also add a Cc: stable@vger.kernel.org to make sure this gets backported.
> 
> With the fixed description,
> 
> Reviewed-by: Hector Martin <marcan@marcan.st>
> 
> - Hector

Looking into this a bit more from what was mentioned in the linked bug,
the DMI data comes from the SMBIOS table. We don't have that on Apple
platforms even though we also boot via U-Boot+EFI, but I'm guessing you
build U-Boot with CONFIG_GENERATE_SMBIOS_TABLE and provide that stuff in
the DT? So s/ACPI/SMBIOS/ would be more accurate in the commit message.

- Hector

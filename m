Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BA63CC47F
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 18:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbhGQQlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 12:41:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbhGQQly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 12:41:54 -0400
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050::465:101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C708BC06175F;
        Sat, 17 Jul 2021 09:38:57 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4GRv262cbLzQjxR;
        Sat, 17 Jul 2021 18:38:54 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1626539932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=51iRsPRsaK8PFBVEti+F4/go88cBe72Pk1iRRqNdOUE=;
        b=FctGs9pLtZFrmn9PP0JjHA9dUQ8K92CKywdDeLcx4GS1Ie31QUFRwMuYvgKLeFXSrEZx2j
        ErSzKB0AquYGcZiMzC4gPj6HnxIAEVgH9BbnR4+/oLHv/5PKsuzCGmoQLIEm5uEESPPqhj
        UzhKfSzgC8XqD84GBnEV1Wrrq7JLLDxD8Z9iBQIpRJuJ2brSjVxvBYjyitzX5sSYy+nqIC
        KAP5hV9FgfSe82j3BEr17AYaYY2wEfkg+WjUK1dNQWn0k58X89imzssV5sT7upEGHV4x9c
        6cRhrlceujLlRo8dFqkKMxi0kpvvX/gbJc51cETJcb5XXfriHW+YsGubK+7v8g==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id hrDd85UIi720; Sat, 17 Jul 2021 18:38:50 +0200 (CEST)
Subject: Re: [PATCH net-next v3] net: phy: intel-xway: Add RGMII internal
 delay configuration
To:     Andrew Lunn <andrew@lunn.ch>, Martin Schiller <ms@dev.tdt.de>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210709164216.18561-1-ms@dev.tdt.de>
 <CAFBinCCw9+oCV==1DrNFU6Lu02h3OyZu9wM=78RKGMCZU6ObEA@mail.gmail.com>
 <fcb3203ea82d1180a6e471f22e39e817@dev.tdt.de> <YO2P8J4Ln+RwxkfO@lunn.ch>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Message-ID: <9fa0ce38-d3b5-a60e-cfc4-7799b832065f@hauke-m.de>
Date:   Sat, 17 Jul 2021 18:38:43 +0200
MIME-Version: 1.0
In-Reply-To: <YO2P8J4Ln+RwxkfO@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9FAB18BE
X-Rspamd-UID: 80aec0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/13/21 3:06 PM, Andrew Lunn wrote:
>>> [...]
>>>> +#if IS_ENABLED(CONFIG_OF_MDIO)
>>> is there any particular reason why we need to guard this with
>>> CONFIG_OF_MDIO?
>>> The dp83822 driver does not use this #if either (as far as I
>>> understand at least)
>>>
>>
>> It makes no sense to retrieve properties from the device tree if we are
>> compiling for a target that does not support a device tree.
>> At least that is my understanding of this condition.
> 
> There should be stubs for all these functions, so if OF is not part of
> the configured kernel, stub functions take their place. That has the
> advantage of at least compiling the code, so checking parameter types
> etc. We try to avoid #ifdef where possible, so we get better compiler
> build test coverage. The more #ifef there are, the more different
> configurations that need compiling in order to get build coverage.
> 
> 	       Andrew
> 

The phy_get_internal_delay() function does not have a stub function 
directly, but it calls phy_get_int_delay_property() which has a stub, if 
CONFIG_OF_MDIO is not set, see:
https://elixir.bootlin.com/linux/v5.14-rc1/source/drivers/net/phy/phy_device.c#L2797

The extra ifdef in the PHY driver only saves some code in the HY driver, 
but it should still work as before on systems without CONFIG_OF_MDIO.

I would also prefer to remove the ifdef from the intel-xway phy driver.

Hauke

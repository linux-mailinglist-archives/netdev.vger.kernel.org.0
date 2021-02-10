Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B05316243
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 10:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBJJcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 04:32:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbhBJJPo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 04:15:44 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D49DC061574;
        Wed, 10 Feb 2021 01:15:04 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id B7F3423E64;
        Wed, 10 Feb 2021 10:14:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612948500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wMCQt/BU0hbVrk2JBtTiMgg/ClhZDMtdMRCfZNumLsk=;
        b=If4lWRbtqOAkZqI6yCO1C82UcROTnjAr+lFa0jlmljPql8L5rp5qrrQ/gaKck2hqeKRqym
        H0wAKWNQIZE/UBBpgOQbQxReQHMaKma+XJnxTAAcyySyj8akMbo3OC2hK+nytkRZHfRUnw
        RXZF6OMN4Q9diWATQzGQDD2e9Lxes4k=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 10 Feb 2021 10:14:59 +0100
From:   Michael Walle <michael@walle.cc>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next 7/9] net: phy: icplus: select page before writing
 control register
In-Reply-To: <1656b889-12c4-b376-5cdf-38e1dcc500bc@gmail.com>
References: <20210209164051.18156-1-michael@walle.cc>
 <20210209164051.18156-8-michael@walle.cc>
 <d5672062-c619-02a4-3bbe-dad44371331d@gmail.com>
 <e9d26cd6634a8c066809aa92e1481112@walle.cc>
 <1656b889-12c4-b376-5cdf-38e1dcc500bc@gmail.com>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <f3f831f453378fe3b55e8fc5606266eb@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2021-02-10 10:03, schrieb Heiner Kallweit:
[..]
>>>> +    return phy_restore_page(phydev, oldpage, err);
>>> 
>>> If a random page was set before entering config_init, do we actually 
>>> want
>>> to restore it? Or wouldn't it be better to set the default page as 
>>> part
>>> of initialization?
>> 
>> First, I want to convert this to the match_phy_device() and while at 
>> it,
>> I noticed that there is this one "problem". Short summary: the IP101A 
>> isn't
>> paged, the IP101G has serveral and if page 16 is selected it is more 
>> or
>> less compatible with the IP101A. My problem here is now how to share 
>> the
>> functions for both PHYs without duplicating all the code. Eg. the 
>> IP101A
>> will phy_read/phy_write/phy_modify(), that is, all the locked 
>> versions.
>> For the IP101G I'd either need the _paged() versions or the __phy ones
>> which don't take the mdio_bus lock.
>> 
>> Here is what I came up with:
>> (1) provide a common function which uses the __phy ones, then the
>>     callback for the A version will take the mdio_bus lock and calls
>>     the common one. The G version will use 
>> phy_{select,restore}_page().
>> (2) the phy_driver ops for A will also provde a .read/write_page()
>>     callback which is just a no-op. So A can just use the G versions.
>> (3) What Heiner mentioned here, just set the default page in
>>     config_init().
>> 
>> (1) will still bloat the code; (3) has the disadvantage, that the
>> userspace might fiddle around with the page register and then the
>> whole PHY driver goes awry. I don't know if we have to respect that
>> use case in general. I know there is an API to read/write the PHY
>> registers and it could happen.
>> 
> 
> The potential issue you mention here we have with all PHY's using
> pages. As one example, the genphy functions rely on the PHY being
> set to the default page. In general userspace can write PHY register
> values that break processing, independent of paging.
> I'm not aware of any complaints regarding this behavior, therefore
> wouldn't be too concerned here.

I'm fine with that, that will make the driver easier.

> Regarding (2) I'd like to come back to my proposal from yesterday,
> implement match_phy_device to completely decouple the A and G versions.
> Did you consider this option?

Yes, that is what I was talking about above: "First, I want to convert
this to the match_phy_device()" ;) And then I stumbled across that 
problem
I was describing above.

It will likely go away if I just set the page to the default page.

>> That being said, I'm either fine with (2) and (3) but I'm preferring
>> (2).
>> 
>> BTW, this patch is still missing read/writes to the interrupt status
>> and control registers which is also paged.

-- 
-michael

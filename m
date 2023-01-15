Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0F5966B469
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 23:56:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbjAOW4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 17:56:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjAOW4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 17:56:38 -0500
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA42B1E9CD
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 14:56:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=7S7Q3114fxcLMvDP1hObBsSTzMGq4gxDhSezguM5qFQ=; b=LnS6bfzr3ecvlym+Fb7ppwRho/
        oS2+gB57uYJrXb6i9LPoS0WKqVvjLcz9xhDsvOHRWJpbWFvk+oAANLRLT+iBKDxb8i7vLfoZmQGVh
        aWZhUPlgFAbDxaOAWFpeQXmCNWZaOr+HSRRkSbi1/ZM4O/Chfdua/cWUeuJptcMy/o84SYKgvDBsm
        JKoG7hmcdi5YHLx5wvMIaN0z+59p9UOEEIhw3LAe8+5je4LCxpzpMQXZ5fNBmuVC4q80LOvqSXy8K
        v3AvRnj9eFN07gT4qwAw7IaQCYp5sglxZBXk5HqRg5CrTRU14URijTxYH5BC32ctuO2dfCWJSCL2Y
        d6gH+y6Q==;
Received: from sslproxy01.your-server.de ([78.46.139.224])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1pHB1b-000P34-NM; Sun, 15 Jan 2023 22:58:47 +0100
Received: from [2604:5500:c0e5:eb00:da5e:d3ff:feff:933b]
        by sslproxy01.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1pHB1b-000RAN-5X; Sun, 15 Jan 2023 22:58:47 +0100
Message-ID: <f691f339-9e50-b968-01e1-1821a2f696e7@metafoo.de>
Date:   Sun, 15 Jan 2023 13:58:43 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] net: mdio: force deassert MDIO reset signal
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>,
        Pierluigi Passaro <pierluigi.passaro@gmail.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eran.m@variscite.com, nate.d@variscite.com,
        francesco.f@variscite.com, pierluigi.p@variscite.com
References: <20230115161006.16431-1-pierluigi.p@variscite.com>
 <Y8QzI2VUY6//uBa/@lunn.ch>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <Y8QzI2VUY6//uBa/@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.7/26782/Sun Jan 15 09:20:34 2023)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/23 09:08, Andrew Lunn wrote:
> On Sun, Jan 15, 2023 at 05:10:06PM +0100, Pierluigi Passaro wrote:
>> When the reset gpio is defined within the node of the device tree
>> describing the PHY, the reset is initialized and managed only after
>> calling the fwnode_mdiobus_phy_device_register function.
>> However, before calling it, the MDIO communication is checked by the
>> get_phy_device function.
>> When this happen and the reset GPIO was somehow previously set down,
>> the get_phy_device function fails, preventing the PHY detection.
>> These changes force the deassert of the MDIO reset signal before
>> checking the MDIO channel.
>> The PHY may require a minimum deassert time before being responsive:
>> use a reasonable sleep time after forcing the deassert of the MDIO
>> reset signal.
>> Once done, free the gpio descriptor to allow managing it later.
> This has been discussed before. The problem is, it is not just a reset
> GPIO. There could also be a clock which needs turning on, a regulator,
> and/or a linux reset controller. And what order do you turn these on?
>
> The conclusions of the discussion is you assume the device cannot be
> found by enumeration, and you put the ID in the compatible. That is
> enough to get the driver to load, and the driver can then turn
> everything on in the correct order, with the correct delays, etc.

I've been running into this same problem again and again over the past 
years.

Specifying the ID as part of the compatible string works for clause 22 
PHYs, but for clause 45 PHYs it does not work. The code always wants to 
read the ID from the PHY itself. But I do not understand things well 
enough to tell whether that's a fundamental restriction of C45 or just 
our implementation and the implementation can be changed to fix it.

Do you have some thoughts on this?


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 629CA25D12D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 08:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgIDGTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 02:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgIDGT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 02:19:29 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64824C061244;
        Thu,  3 Sep 2020 23:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=abh6SdwpbRfiKw2Rr/PwbvIz6rOaeyGz0EhknyPj+oI=; b=sygc+bhTEJeFYnLbVZfhxNRm4w
        8ncYzVekHrpM45B5+DSg7BK0A4dlu1ssVwWZVza3Qjle3qNZ55eEsDN46YIFKQBD2J9N8k6QvQwTz
        X0cde95xvtbwmPxL5wN4ZAEkMVOdIPzGSArHd+Rq8m6wTVcfx03bX4790FCkMJFziRSd71WNBiI0N
        QavIrUE52uaF465mP7LW9N30c9EMfwChTzXCtfeoKcwkFz6ONRfwNym+jN/fwlSZ/8FoCelG8Xtve
        u00LHN1zS6zkhbhNRLeFfA8G1UXkxNn8VZpnl/d5DZB24tWk4BO1ICX6KAV2hr/SSIdMjAJpdQiG4
        QBMC5K9A==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kE54I-00ArwX-QS; Fri, 04 Sep 2020 08:19:27 +0200
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <307b343b-2e8d-cb20-c22f-0e80acdf1dc9@arf.net.pl>
Date:   Fri, 4 Sep 2020 08:19:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 2020-09-04 o 06:04, Florian Fainelli pisze:
>
>
> On 9/2/2020 9:39 PM, Florian Fainelli wrote:
>> Hi all,
>>
>> This patch series takes care of enabling the Ethernet PHY clocks in
>> DT-based systems (we have no way to do it for ACPI, and ACPI would
>> likely keep all of this hardware enabled anyway).
>>
>> Please test on your respective platforms, mine still seems to have
>> a race condition that I am tracking down as it looks like we are not
>> waiting long enough post clock enable.
>>
>> The check on the clock reference count is necessary to avoid an
>> artificial bump of the clock reference count and to support the unbind
>> -> bind of the PHY driver. We could solve it in different ways.
>>
>> Comments and test results welcome!
>
> Andrew, while we figure out a proper way to support this with the 
> Linux device driver model, would you be opposed in a single patch to 
> drivers/net/mdio/mdio-bcm-unimac.c which takes care of enabling the 
> PHY's clock during bus->reset just for the sake of getting those 
> systems to work, and later on we move over to the pre-probe mechanism?
>
> That would allow me to continue working with upstream kernels on these 
> systems without carrying a big pile of patches.

Just a bunch of questions.

Actually, why is it necessary to have a full MDIO bus scan already 
during probing peripherals?

If during probing the peripherals enable their resources (like clocks), 
what's wrong in having the full MDIO bus scan after probing of all 
peripherals is complete (and all peripherals are up)?

Also, what's wrong in letting the MDIO bus scan find only some PHYs in 
the first go, and then letting each driver instance (of particular 
peripheral) initiate scan only for its specific PHY, if it was not found 
yet?
(Is it thatof_mdio.h provides public function of_mdiobus_register, but 
not something similar to add only specific devices/phys without 
destroying the existing state?)
I'd say that it is not necessary to have a PHY getting found before it 
is needed to setup the complete interface.

Best regards,
Adam

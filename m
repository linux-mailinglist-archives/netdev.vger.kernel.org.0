Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8A831AD2E
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 17:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBMQmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 11:42:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBMQml (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 11:42:41 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5B1C061756
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 08:42:00 -0800 (PST)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 1E4E423E55;
        Sat, 13 Feb 2021 17:41:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1613234515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mmMP36qfDu/FzqXXUVoqxbh8s1FRBzOXAnnqTNlkH+k=;
        b=NI/kKN1yuq59PSFfrSb7KYreJxJ18vYsHTWYtlX7oD8rZmAoBnO54wtsGRJUALNG7o/vJR
        jzTeFLvOyfXaYdVeS5yQCA7x1IYzD8tuFRFdnbmARXWa6Tg2JHbHqbHJm9EyqlRtZPaZKT
        Df+sbB/25lROLaDPG43rBoIY/qilxeY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 13 Feb 2021 17:41:55 +0100
From:   Michael Walle <michael@walle.cc>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/2] net: phylink: explicitly configure in-band
 autoneg for PHYs that support it
In-Reply-To: <20210213001808.GN1463@shell.armlinux.org.uk>
References: <20210212172341.3489046-1-olteanv@gmail.com>
 <20210212172341.3489046-2-olteanv@gmail.com>
 <eb7b911f4fe008e1412058f219623ee2@walle.cc>
 <20210213001808.GN1463@shell.armlinux.org.uk>
User-Agent: Roundcube Webmail/1.4.10
Message-ID: <db9f5988d7d135b3588bf9f6a5b10b08@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2021-02-13 01:18, schrieb Russell King - ARM Linux admin:
> On Fri, Feb 12, 2021 at 11:40:59PM +0100, Michael Walle wrote:
>> Fun fact, now it may be the other way around. If the bootloader 
>> doesn't
>> configure it and the PHY isn't reset by the hardware, it won't work in
>> the bootloader after a reboot ;)
> 
> If we start messing around with the configuration of PHYs in that
> regard, we could be opening ourselves up for a world of pain...
> 
>> If you disable aneg between MAC and PHY, what would be the actual 
>> speed
>> setting/duplex mode then? I guess it have to match the external speed?
> 
> That is a function of the interface mode and the PHY capabilities.
> 
> 1) if the PHY supports rate adaption, and is programmed for that, then
>    the PHY link normally operates at a fixed speed (e.g. 1G for SGMII)
>    and the PHY converts to the appropriate speed.
> 
>    We don't actually support this per se, since the parameters we give
>    to the MAC via mac_link_up() are the media side parameters, not the
>    link parameters.
> 
> 2) if the PHY does not support rate adaption, then the MAC to PHY link
>    needs to follow the media speed and duplex. phylink will be in "PHY"
>    mode, where it passes the media side negotiation results to the MAC
>    just like phylib would, and the MAC should be programmed
>    appropriately. In the case of a SGMII link, the link needs to be
>    programmed to do the appropriate symbol repetition for 100M and 10M
>    speeds. The PHY /should/ do that automatically, but if it doesn't,
>    then the PHY also needs to be programmed to conform. (since if
>    there's no rate adaption in the PHY, the MAC side and the media side
>    must match.)

Thanks, but I'm not sure I understand the difference between "rate
adaption" and symbol repetition. The SGMII link is always 1.25Gb,
right? If the media side is 100Mbit it will repeat the symbol 10
times or 100 times in case of 10Mbit. What is "rate adaption" then?

-- 
-michael

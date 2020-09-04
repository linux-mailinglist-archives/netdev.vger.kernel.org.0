Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5D625E0A6
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 19:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgIDRVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 13:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgIDRVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 13:21:34 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77325C061244;
        Fri,  4 Sep 2020 10:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n/IY3oqw/0uQMPZxZmPsWG/3CNlj4/osbd1j5CE+lTA=; b=kN+BkP2BBBayKgPGjZBRnRjn3I
        njTZGe80CLs7QX60EmmKavc42oMoE0I5Mqpb1CTlMfIefYQB0vcJZOeOu1Hp0oeQhWoOiO9EVQfVx
        RkNbhu9DumG9WIjf8t0Z19KCL8DUPt+3TokvJZYSUmH6Fp70hI+YmZsibSVl5A93EzAxsQOaqm1wo
        1gTjLmO8XV3kR6BDQBPmcDcQv8eO0iAo1hTxsf34qt2k+7mcyUzEuMv8rm+fFcGySYObqq6JpaYd9
        lS6W2UxKV5dX2dfGKd/UV2/LYTDBMuNPQ3p/iTIs7sREKNDQsGMeAV2XeHCkXoLXsQVwDk6rY4C2j
        Ynb6zdSg==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kEFP2-0044DE-QB; Fri, 04 Sep 2020 19:21:32 +0200
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        m.felsch@pengutronix.de, hkallweit1@gmail.com,
        richard.leitner@skidata.com, zhengdejin5@gmail.com,
        devicetree@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
 <307b343b-2e8d-cb20-c22f-0e80acdf1dc9@arf.net.pl>
 <20200904134558.GL3112546@lunn.ch>
 <ed801431-2b46-5d6d-0cfd-a4b043702f9f@arf.net.pl>
 <20200904142347.GP3112546@lunn.ch>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <3f80e13f-fc62-37e7-3ee8-5626d26c32a9@arf.net.pl>
Date:   Fri, 4 Sep 2020 19:21:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200904142347.GP3112546@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

W dniu 2020-09-04 o 16:23, Andrew Lunn pisze:
> On Fri, Sep 04, 2020 at 04:00:55PM +0200, Adam Rudziński wrote:
>> W dniu 2020-09-04 o 15:45, Andrew Lunn pisze:
>>>> Just a bunch of questions.
>>>>
>>>> Actually, why is it necessary to have a full MDIO bus scan already during
>>>> probing peripherals?
>>> That is the Linux bus model. It does not matter what sort of bus it
>>> is, PCI, USB, MDIO, etc. When the bus driver is loaded, the bus is
>>> enumerated and drivers probe for each device found on the bus.
>> OK. But is it always expected to find all the devices on the bus in the
>> first run?
> Yes. Cold plug expects to find all the device while scanning the bus.
>
>> Does the bus model ever allow to just add any more devices? Kind of,
>> "hotplug". :)
> Hotplug is triggered by hardware saying a new device has been
> added/removed after cold plug.
>
> This is not a hotplug case. The hardware has not suddenly appeared, it
> has always been there.
>
>     Andrew

There still is something that I would like to have clarified. Let me ask 
a bit more.

Even if the hardware is fixed, in general it doesn't mean that there is 
only one possible way of bringing it up in software (software in 
general, not necessarily Linux). Does the Linux driver/bus model define 
the allowed options more precisely?

Or:

There is "coldplug", there is "hotplug", and let's call the intermediate 
possibility "warmplug" - the hardware is fixed, but it is discovered not 
in the same scan. Some devices are found in scans triggered by something 
later. For example, by a driver which doesn't have its attached devices 
discovered yet. Let's assume for now that it makes sense, and this can 
result in a perfectly running system.
Does the Linux driver/bus model explicitly and strictly require 
"coldplug" approach in the case of fixed hardware? Is "warmplug" 
explicitly and strictly not allowed, or it just "doesn't feel right"?

Best regards,
Adam


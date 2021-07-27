Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C83D7A39
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhG0PyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:54:01 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:43223 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbhG0PyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 11:54:00 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 092C42224D;
        Tue, 27 Jul 2021 17:53:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1627401239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UDzeKsJ6IHS1gqsAMNylBBlijfHCP0pmNgS+W/hH5+4=;
        b=dHEgVQ5SHymgK26Nl9Aou7qxKZ3iza4V4Tgu+y0N6BFT0SU/JwIM+xStMgcULdg4apr0ze
        HoKm0ZBVUZYm/BJVQremz5sn5yHb8GDDgRqqtINOZ8KGapDkJgkIA48Nh+ueBaZ6mWBJVA
        mqlOVKyCP4HxUy5Ba3lveoaQdFocoN8=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 27 Jul 2021 17:53:58 +0200
From:   Michael Walle <michael@walle.cc>
To:     =?UTF-8?Q?Marek_Beh=C3=BAn?= <kabel@kernel.org>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
In-Reply-To: <20210727172828.1529c764@thinkpad>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc> <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
 <20210727172828.1529c764@thinkpad>
User-Agent: Roundcube Webmail/1.4.11
Message-ID: <8edcc387025a6212d58fe01865725734@walle.cc>
X-Sender: michael@walle.cc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Am 2021-07-27 17:28, schrieb Marek Behún:
> On Tue, 27 Jul 2021 17:03:53 +0200
> Michael Walle <michael@walle.cc> wrote:
> 
>> I wasn't talking about ethN being same as the network interface name.
>> For clarity I'll use ethernetN now. My question was why would you
>> use ethmacN or ethphyN instead if just ethernetN for both. What is
>> the reason for having two different names? I'm not sure who is using
>> that name anyway. If it is for an user, I don't think he is interested
>> in knowing wether that LED is controlled by the PHY or by the MAC.
> 
> Suppose that the system has 2 ethernet MACs, each with an attached PHY.
> Each MAC-PHY pair has one LED, but one MAC-PHY pair has the LED
> attached to the MAC, and the second pair has the LED attached to the
> PHY:
>      +------+        +------+
>      | macA |        | macB |
>      +-+--+-+        +-+----+
>        |  |            |
>       /   +------+   +-+----+
>    ledA   | phyA |   | phyB |
>           +------+   +----+-+
>                           |
>                            \
>                             ledB
> 
> Now suppose that during system initialization the system enumerates
> MACs and PHYs in different order:
>    macA -> 0      phyA -> 1
>    macB -> 1      phyB -> 0
> 
> If we used the devicename as you are suggesting, then for the two LEDs
> the devicename part would be the same:
>   ledA -> macA -> ethernet0
>   ledB -> phyB -> ethernet0
> although they are clearly on different MACs.

Why is that the case? Why can't both the MAC and the PHY request a 
unique
name from the same namespace? As Andrew pointed out, the names in
/sys/class/leds don't really matter. Ok, it will still depend on the
probe order which might not be the case if you split it between ethmac
and ethphy.

Sorry, if I may ask stupid questions here. I don't want to cause much
trouble, here. I was just wondering why we have to make up two different
(totally unrelated names to the network interface names) instead of just
one (again totally unrelated to the interface name and index).

> We could create a simple atomically increasing index only for MACs, and
> for a LED connected to a PHY, instead of using the PHY's index, we
> would look at the attached MAC and use the MAC index.

Oh, I see. I was assuming we are talking about "just a number" not
related to anything.

> The problem is that PHYs and MACs are not always attached, and are not
> necessarily mapped 1-to-1. It is possible to have a board where one PHY
> can connect to 2 different MACs and you can switch between them, and
> also vice versa.
> 
>> > So it can for example happen that within a network namespace you
>> > have only one interface, eth0, but in /sys/class/leds you would see
>> >   eth0:green:activity
>> >   eth1:green:activity
>> > So you would know that there are at least 2 network interfaces on the
>> > system, and also with renaming it can happen that the first LED is not
>> > in fact connected to the eth0 interface in your network namespace.
>> 
>> But the first problem persists wether its named ethernetN or ethphyN,
>> no?
> 
> No. The N in the "ethphyN" for etherent PHYs is supposed to be 
> unrelated
> to the N in "ethN" for interface names. So if you have eth0 network
> interface with attached phy ethphy0, this is a coincidence. (That is
> why Andrew is proposing to start the index for PHYs at a different
> number, like 42.)

Yes, in my case ethernet0 has nothing to do with eth0, either.

But I was actually referring to your "you see the leds in /sys/ of all
the network adapters". That problem still persists, right?

-michael

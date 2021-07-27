Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337003D79CC
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236661AbhG0P32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:29:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237262AbhG0P2e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 11:28:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BEC8D61B47;
        Tue, 27 Jul 2021 15:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627399714;
        bh=/fYEj5k43KcOdaLZPGFQzYL3xPCFszsEry1J5ml0PxA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSyY6tEkO7yA3RCvaoU4EEzLQgcfAxg/JikTz53T9WHNH+SurT0UGgz36XE9YA0Pv
         PMLrl4X2WFJfuCrMqf69kKi8t3ZlXxRernFtbZZk9Zon1+PpkcFqt8ko8SRRqiUZ1d
         NgNUCBp/7ptYWj+MtzoAXm16qc9KWEv9u8EUBPNRdHEglt9gI/xQdiSdq2MfYWj54p
         8RQriqHY48ElPX/wMl95/OeObqKirpgq939WRIKpX/f9FWDd+34s2A1rZYhTJcfDBC
         FcfuWiKWpWOlaRoDYrVUfDPPru0lHp7s0IOUnA8vEcncXMWXl+OEgS5Dzvvo4gXx7Y
         PNvRTpXjOejfg==
Date:   Tue, 27 Jul 2021 17:28:28 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210727172828.1529c764@thinkpad>
In-Reply-To: <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
        <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 27 Jul 2021 17:03:53 +0200
Michael Walle <michael@walle.cc> wrote:

> I wasn't talking about ethN being same as the network interface name.
> For clarity I'll use ethernetN now. My question was why would you
> use ethmacN or ethphyN instead if just ethernetN for both. What is
> the reason for having two different names? I'm not sure who is using
> that name anyway. If it is for an user, I don't think he is interested
> in knowing wether that LED is controlled by the PHY or by the MAC.

Suppose that the system has 2 ethernet MACs, each with an attached PHY.
Each MAC-PHY pair has one LED, but one MAC-PHY pair has the LED
attached to the MAC, and the second pair has the LED attached to the
PHY:
     +------+        +------+
     | macA |        | macB |
     +-+--+-+        +-+----+
       |  |            |
      /   +------+   +-+----+
   ledA   | phyA |   | phyB |
          +------+   +----+-+
                          |
                           \
                            ledB

Now suppose that during system initialization the system enumerates
MACs and PHYs in different order:
   macA -> 0      phyA -> 1
   macB -> 1      phyB -> 0

If we used the devicename as you are suggesting, then for the two LEDs
the devicename part would be the same:
  ledA -> macA -> ethernet0
  ledB -> phyB -> ethernet0
although they are clearly on different MACs.

We could create a simple atomically increasing index only for MACs, and
for a LED connected to a PHY, instead of using the PHY's index, we
would look at the attached MAC and use the MAC index.
The problem is that PHYs and MACs are not always attached, and are not
necessarily mapped 1-to-1. It is possible to have a board where one PHY
can connect to 2 different MACs and you can switch between them, and
also vice versa.

> > So it can for example happen that within a network namespace you
> > have only one interface, eth0, but in /sys/class/leds you would see
> >   eth0:green:activity
> >   eth1:green:activity
> > So you would know that there are at least 2 network interfaces on the
> > system, and also with renaming it can happen that the first LED is not
> > in fact connected to the eth0 interface in your network namespace.  
> 
> But the first problem persists wether its named ethernetN or ethphyN,
> no?

No. The N in the "ethphyN" for etherent PHYs is supposed to be unrelated
to the N in "ethN" for interface names. So if you have eth0 network
interface with attached phy ethphy0, this is a coincidence. (That is
why Andrew is proposing to start the index for PHYs at a different
number, like 42.)

Marek

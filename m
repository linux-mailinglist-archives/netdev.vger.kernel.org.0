Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB4C3D6A95
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 02:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhGZX0A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 19:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:54728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233959AbhGZXZ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 19:25:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE7B860F6B;
        Tue, 27 Jul 2021 00:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627344387;
        bh=F5cl65jVCuDJpITppz8/trPR+wr/JskUD3W/zf1PDwc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t/XO/QJxFl0WFHduLcR75Gf6jV3zrX+U8vBSmtEH0cE7jTsqM4NoOKkBR56pc9YUs
         P6skD9Lr5cxlLqe2jhl/vhfUyFJQz38iozjR2rnztJH2Eatfg5V97nX5/a5Zp6AFvi
         UTIv8S5xye9yqxkmUG/iQ5F8iGBN5+kRimObP0kcPlfv7my+K0MQpgV8WVhD2Xncro
         pSv1XZDpxzvyZl8/5nuNL2picJtlNma5yhcYi5ISnMHh2h8Jc3xY6Kn7bSVWWj7qmX
         Z+QPnLcy5EpZTo6X2/kMFyo/XrYj2NpDQndqMv5cQqNMXAaEDNpPYj9kwlqc0QgcX8
         e1ZBjgZ8BawSw==
Date:   Tue, 27 Jul 2021 02:06:19 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Pavel Machek <pavel@ucw.cz>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210727020619.2ba78163@thinkpad>
In-Reply-To: <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
        <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
        <20210721204543.08e79fac@thinkpad>
        <YPh6b+dTZqQNX+Zk@lunn.ch>
        <20210721220716.539f780e@thinkpad>
        <4d8db4ce-0413-1f41-544d-fe665d3e104c@gmail.com>
        <6d2697b1-f0f6-aa9f-579c-48a7abb8559d@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner (and Pavel and Florian and others),

On Mon, 26 Jul 2021 22:59:05 +0200
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> The issue with this is mentioned by Andrew a few lines before. At least in
> network subsystem the kernel identifiers can be changed from userspace.
> Typical example is the interface renaming from eth0 to e.g. enp1s0.
> Then a LED eth0-led1 would have to be automagically renamed to enp1s0-led1.
> An option for this could be to make a LED renaming function subscribe to
> interface name change notifications. But this looks to me to like using a
> quite big hammer for a rather small nail.

We are not going to be renaming LEDs on inteface rename, that can
introduce a set of problems on it's own.

Yes, if network interface renaming were not possible, the best option
would be to use interface names. It is not possible.

The last time we discussed this (Andrew, Pavel and I), we've decided
that for ethernet PHY controlled LEDs we want the devicename part
should be something like
   phyN  or  ethphyN  or  ethernet-phyN
with N a number unique for every PHY (a simple atomically increased
integer for every ethernet PHY). (This is because the LED pin is
physically connected to the PHY.)

But we can't do this here, because in the case of this igc driver, the
LEDs are controlled by the MAC, not the PHY (as far as I understand).
Which means that the LED is connected to a pin on the SOC or MAC chip.

Florian's suggestion is to use dev_name(), he says:
  FWIW, dev_name() should be the "devicename" from what you described 
  above. This is foundational property for all devices that Linux 
  registers that is used for logging, name spacing within /sys/, uniqe, 
  ABI stable, etc. Anything different would be virtually impossible to 
  maintain and would lead to ABI breakage down the road, guaranteed.

I understand this point of view, since the purpose of dev_name() is
to represent devices in userspace. And for the purpose of LED devicename
part it works beautifully sometimes, for block devices for example,
where the dev_name() is be mmc0, sda1, ...

The problem is that for other kind of devices dev_name() may contain the
':' character (and often it does), which can break parsing LED names,
since the LED name format also contains colons:
  devicename:color:function
So in the case of a block device, it works:
  mmc0::
  sda:red:read
  dm-0::write
But for a PCIe network controller it may contain too many colons:
  0000:02:00.0:yellow:activity

So basically this LED device naming scheme is the reason why we are
trying to make prettier names for LED trigger sources / controllers.

The possible solutions here are the following (the list is not
exhaustive):
- allow using devicenames containing ':' characters, i.e.
    0000:02:00.0:yellow:activity
  This can break existing userspace utilities (there are no official
  ones, though). But IMO it should be a viable solution since we can
  extract the devicename part, because we know that the color and
  function parts do not contain colons.

- substitute ':' characters with a different character in the devicename
  part

- use a prettier name, like we wanted to do with ethernet PHYs.

  The question is what do we want to do for MAC (instead of PHY)
  controlled LEDs, as is the case in this igc driver. We could introduce
  a simple atomically increased integer for every MAC, the same we want
  to do in the PHY case, so the devicename could be something like
  macN (or ethmacN or ethernet-macN)

I confess that I am growing a little frustrated here, because there
seems to be no optimal solution with given constraints and no official
consensus for a suboptimal yet acceptable solution.

Marek

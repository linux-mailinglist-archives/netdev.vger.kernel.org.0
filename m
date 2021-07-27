Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C7103D7AF7
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbhG0QcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:35204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhG0QcS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 12:32:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF3F661BA4;
        Tue, 27 Jul 2021 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627403538;
        bh=CLi6EI2WI1DTnGCmAcRonIwBtNybc5mWG9HCGhUUn3Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QTHAjcnT788fxfvDrM+Dr2fRf01lquWWdxTpvuzzAaHffEX9ciWuvjtABmlwf1kLx
         v3ZBzgGJ70NAT6jzJf6ymQlPznTSh0SqjCdoPISg62OKWSQjj4R1dvfrXQch+otzOD
         19ZmrdACItwrisjpMvxjV9eQ3SFmRYtYwaTwuX+Yb5Htas9Pdx0bFRRaPqCIMIwhh4
         G6V6yG5e7oBR9bkgaRoHFVduIeb+yrZje/ngpyI5eNY3SCw+ScZsGKWN/LGw4VFiSv
         8K2H/8YtAiAdux+p35PErOWgehTm8Koz8jlWGadN8H/MdR9LqDFlaI0kJjhpKRxJtt
         M23P3XgPdGVfQ==
Date:   Tue, 27 Jul 2021 18:32:13 +0200
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
Message-ID: <20210727183213.73f34141@thinkpad>
In-Reply-To: <8edcc387025a6212d58fe01865725734@walle.cc>
References: <YP9n+VKcRDIvypes@lunn.ch>
        <20210727081528.9816-1-michael@walle.cc>
        <20210727165605.5c8ddb68@thinkpad>
        <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
        <20210727172828.1529c764@thinkpad>
        <8edcc387025a6212d58fe01865725734@walle.cc>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 27 Jul 2021 17:53:58 +0200
Michael Walle <michael@walle.cc> wrote:

> > If we used the devicename as you are suggesting, then for the two LEDs
> > the devicename part would be the same:
> >   ledA -> macA -> ethernet0
> >   ledB -> phyB -> ethernet0
> > although they are clearly on different MACs.  
> 
> Why is that the case? Why can't both the MAC and the PHY request a 
> unique name from the same namespace?

So all the network related devices should request a unique network
relate device ID? Should also wireless PHY devices do this? WWAN modems?
And all these should have the same template for devicename part withing
/sys/class/leds? What should be the template for the devicename, if
wireless PHYs and WWAN modems could also be part of this? It cannot be
"ethernet" anymore.

It seems a better idea to me to just some nice identifier for the LED
controller.

> As Andrew pointed out, the names in
> /sys/class/leds don't really matter. Ok, it will still depend on the
> probe order which might not be the case if you split it between ethmac
> and ethphy.

Yes, the LED name does not matter. But the LED subsystem requires names
in a specific format, this is already decided and documented, we are
not going to be changing this. The only reasonable thing we can do now
is to choose a sane devicename.

> Sorry, if I may ask stupid questions here. I don't want to cause much
> trouble, here. I was just wondering why we have to make up two different
> (totally unrelated names to the network interface names) instead of just
> one (again totally unrelated to the interface name and index).

It seems more logical to me from kernel's point of view.

> But I was actually referring to your "you see the leds in /sys/ of all
> the network adapters". That problem still persists, right?

Yes, this still persists. But we really do not want to start
introducing namespaces to the LED subsystem.

Marek

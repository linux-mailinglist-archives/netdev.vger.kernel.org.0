Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FE33D1781
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 22:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhGUT0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 15:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhGUT0p (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 15:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 559FB610CC;
        Wed, 21 Jul 2021 20:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626898041;
        bh=ffYfEchzU/5yNnkWXgvy1x8g6Mc0EK8A6psI53btj9o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PSpqoy+GmaETUUNIjkHRD/LyzqLrwKOhPAA72NQbQuvLlK5eLhAY0K3TW/mj6i1QM
         YDpzQN6uJOERPpe3AsoWn1CYaK+7wvctNuNKu6zlw4S60dJVwLXHpKiWHwmxEC1HcO
         ysuegjRkKL+H01vCxiXbNL0zqgMXqslxxBgRnKj2LIKY8DqWiBgluMBkWseogpbM2I
         CR0sVhenRj1ClLZ2pvDT9rAFBnHHNoZd12ateiGlZcEbgFHivc3MUaiCnCYBLslFot
         YEJrLnaaObFTTcbIrSTZG263DCBuzA7Hg71RAzx4G1qIDAb/CpJhQJJajLHeixVe2M
         GFEWSq2XoLWfQ==
Date:   Wed, 21 Jul 2021 22:07:16 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pavel Machek <pavel@ucw.cz>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <20210721220716.539f780e@thinkpad>
In-Reply-To: <YPh6b+dTZqQNX+Zk@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
        <20210716212427.821834-6-anthony.l.nguyen@intel.com>
        <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
        <YPTKB0HGEtsydf9/@lunn.ch>
        <88d23db8-d2d2-5816-6ba1-3bd80738c398@gmail.com>
        <YPbu8xOFDRZWMTBe@lunn.ch>
        <3b7ad100-643e-c173-0d43-52e65d41c8c3@gmail.com>
        <20210721204543.08e79fac@thinkpad>
        <YPh6b+dTZqQNX+Zk@lunn.ch>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Jul 2021 21:50:07 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > Hi Heiner,
> > 
> > in sysfs, all devices registered under LED class will have symlinks in
> > /sys/class/leds. This is how device classes work in Linux.
> > 
> > There is a standardized format for LED device names, please look at
> > Documentation/leds/leds-class.rst.
> > 
> > Basically the LED name is of the format
> >   devicename:color:function  
> 
> The interesting part here is, what does devicename mean, in this
> context?
> 
> We cannot use the interface name, because it is not unique, and user
> space can change it whenever it wants. So we probably need to build
> something around the bus ID, e.g. pci_id. Which is not very friendly
> :-(

Unfortunately there isn't consensus about what the devicename should
mean. There are two "schools of thought":

1. device name of the trigger source for the LED, i.e. if the LED
   blinks on activity on mmc0, the devicename should be mmc0. We have
   talked about this in the discussions about ethernet PHYs.
   In the case of the igc driver if the LEDs are controlled by the MAC,
   I guess some PCI identifier would be OK. Or maybe ethernet-mac
   identifier, if we have something like that? (Since we can't use
   interface names due to the possibility of renaming.)

   Pavel and I are supporters of this scheme.

2. device name of the LED controller. For example LEDs controlled by
   the maxim,max77650-led controller (leds-max77650.c) define device
   name as "max77650"

   Jacek supports this scheme.

The complication is that both these schemes are used already in
upstream kernel, and we have to maintain backwards compatibility of
sysfs ABI, so we can't change that.

I have been thinking for some time that maybe we should poll Linux
kernel developers about these two schemes, so that a consensus is
reached. Afterwards we can deprecate the other scheme and add a Kconfig
option (default n for backwards compatibility) to use the new scheme.

What do you think?

Marek

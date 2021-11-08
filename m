Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2604B44994E
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 17:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238138AbhKHQQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 11:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:57838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238111AbhKHQQD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 11:16:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4E1461107;
        Mon,  8 Nov 2021 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636387998;
        bh=Ijsj68+ZcgX66on4xNvcnNeiQfAyxcdQcTHC4K5SOXI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lG6VDp2Tre0jkggzgpKn9zvIrAhb/7shlfuxVMN99UOqioR2n7IB3e85NKwQI4CqE
         4P5cUQQ3Kl9Cntyyla1RG7CZpkPTFZTkq7cKd8g8K2Sn+NjmqDkTOZLdotViKTJA0M
         XxC8FX8X1cEy+Reb28kjQ/3VsEbZNzsIRS3aUl1cuPVQ2fQ6473y1oh0/WbFaqgLiO
         z29jA75XqULm50+FN4uS8rLx2xqzVmnRs7dTetXDZAa2dsJGVD/YmDZfVjPfwyRfk3
         AdV2zF03PBuqD4Eg1zKgsoP6EVcrX0vpx1FFQGa27vd1mibkfGag6kZhWyGN2TFJ1Y
         rpaKnkC28UAgQ==
Date:   Mon, 8 Nov 2021 17:13:12 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v2 1/5] leds: trigger: add API for HW offloading of
 triggers
Message-ID: <20211108171312.0318b960@thinkpad>
In-Reply-To: <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
        <20211108002500.19115-2-ansuelsmth@gmail.com>
        <YYkuZwQi66slgfTZ@lunn.ch>
        <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 16:16:13 +0100
Ansuel Smith <ansuelsmth@gmail.com> wrote:

> On Mon, Nov 08, 2021 at 03:04:23PM +0100, Andrew Lunn wrote:
> > > +static inline int led_trigger_offload(struct led_classdev *led_cdev)
> > > +{
> > > +	int ret;
> > > +
> > > +	if (!led_cdev->trigger_offload)
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	ret = led_cdev->trigger_offload(led_cdev, true);
> > > +	led_cdev->offloaded = !ret;
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +static inline void led_trigger_offload_stop(struct led_classdev *led_cdev)
> > > +{
> > > +	if (!led_cdev->trigger_offload)
> > > +		return;
> > > +
> > > +	if (led_cdev->offloaded) {
> > > +		led_cdev->trigger_offload(led_cdev, false);
> > > +		led_cdev->offloaded = false;
> > > +	}
> > > +}
> > > +#endif  
> > 
> > I think there should be two calls into the cdev driver, not this
> > true/false parameter. trigger_offload_start() and
> > trigger_offload_stop().
> >   
> 
> To not add too much function to the struct, can we introduce one
> function that both enable and disable the hw mode?

Dear Ansuel,

what is the purpose of adding trigger_offload() methods to LED, if you
are not going to add support to offload the netdev trigger? That was
the entire purpose when I wrote that patch.

If you just want to create a new trigger that will make the PHY chip do
the blinking, there is no need at all for the offloading patch.

And you will also get a NACK from me and also Pavel (LED subsystem
maintainer).

The current plan is to:
- add support for offloading existing LED triggers to HW (LED
  controllers (PHY chips, for example))
- make netdev trigger try offloading itself to HW via this new API (if
  it fails, netdev trigger will blink the LED in SW as it does now)
- create LED classdevices in a PHY driver that have the offload()
  methods implemented. The offload method looks at what trigger is
  being enabled for the LED, and it if it is a netdev trigger with such
  settings that are possible to offload, it will be offloaded.

  This whole thing makes use of the existing sysfs ABI.
  So for example if I do
    cd /sys/class/net/eth0/phydev/leds/<LED>
    echo netdev >trigger
    echo eth0 >device_name
    echo 1 >rx
    echo 1 >tx
  The netdev trigger is activated, and it calls the offload() method.
  The offload() method is implemented in the PHY driver, and it checks
  that it can offload these settings (blink on rx/tx), and will enable
  this.
- extend netdev trigger to support more settings:
  - indicate link for specific link modes only (for example 1g, 100m)
  - ...
- extend PHY drivers to support offloading of these new settings

Marek

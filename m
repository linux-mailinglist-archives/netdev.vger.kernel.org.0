Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C20449B32
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhKHR72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:36060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231793AbhKHR71 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:59:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EF06124D;
        Mon,  8 Nov 2021 17:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636394203;
        bh=ffbY6XZWZcrefoCiKBER7fEnSzLlGX7KZbC/MIl/IUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ss6sTjuYyCQj9plD3aR7WdASaMCXN5fbF08iCYDniDS9PB3OXI9wrPIAF2QRnTG6/
         whrkK/PliEpbWR6AqbQYnUPUyCfrA7f3sOWwfLYoEfXgQzsgnWfAutGZWirwy+nTYJ
         KeK/1QFEkCvZVY51+MR4mJl2NjoEu95mz/nI/SLHF0ImsVAf3e2EKtBsY8q8VeSdh6
         B/7raepAFmBkZeHVVWa4xLyToxheKbYn6mh6Z1J32KPP6iS4ojFUsPtcvQjzQOkwY/
         u7Rh9TN88WOB1m67cVHsVYjCm4TND+Wfgu48lPObntwvvNzY8nB2j36oTZ6dkT9jEZ
         OL+aWiZBswwEQ==
Date:   Mon, 8 Nov 2021 18:56:37 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
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
Message-ID: <20211108185637.21b63d40@thinkpad>
In-Reply-To: <YYliclrZuxG/laIh@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
        <20211108002500.19115-2-ansuelsmth@gmail.com>
        <YYkuZwQi66slgfTZ@lunn.ch>
        <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
        <20211108171312.0318b960@thinkpad>
        <YYliclrZuxG/laIh@lunn.ch>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 8 Nov 2021 18:46:26 +0100
Andrew Lunn <andrew@lunn.ch> wrote:

> > Dear Ansuel,
> > 
> > what is the purpose of adding trigger_offload() methods to LED, if you
> > are not going to add support to offload the netdev trigger? That was
> > the entire purpose when I wrote that patch.
> > 
> > If you just want to create a new trigger that will make the PHY chip do
> > the blinking, there is no need at all for the offloading patch.
> > 
> > And you will also get a NACK from me and also Pavel (LED subsystem
> > maintainer).
> > 
> > The current plan is to:
> > - add support for offloading existing LED triggers to HW (LED
> >   controllers (PHY chips, for example))
> > - make netdev trigger try offloading itself to HW via this new API (if
> >   it fails, netdev trigger will blink the LED in SW as it does now)
> > - create LED classdevices in a PHY driver that have the offload()
> >   methods implemented. The offload method looks at what trigger is
> >   being enabled for the LED, and it if it is a netdev trigger with such
> >   settings that are possible to offload, it will be offloaded.
> > 
> >   This whole thing makes use of the existing sysfs ABI.
> >   So for example if I do
> >     cd /sys/class/net/eth0/phydev/leds/<LED>
> >     echo netdev >trigger
> >     echo eth0 >device_name
> >     echo 1 >rx
> >     echo 1 >tx
> >   The netdev trigger is activated, and it calls the offload() method.
> >   The offload() method is implemented in the PHY driver, and it checks
> >   that it can offload these settings (blink on rx/tx), and will enable
> >   this.
> > - extend netdev trigger to support more settings:
> >   - indicate link for specific link modes only (for example 1g, 100m)
> >   - ...
> > - extend PHY drivers to support offloading of these new settings
> > 
> > Marek  
> 
> Hi Marek
> 
> The problem here is, you are not making much progress. People are
> giving up on you ever getting this done, and doing their own
> implementation. Ansuel code is not mature enough yet, it has problems,
> but he is responsive, he is dealing with comments, progress is being
> made. At some point, it is going to be good enough, and it will get
> merged, unless you actual get your code to a point it can be merged.
> 
> 	Andrew

Hello Andrew,

you are right that this has been taking too long on my side. I am sorry
for that.

I guess I will have to work on this again ASAP or we will end up with
solution that I don't like.

Nonetheless, what is your opinion about offloading netdev trigger vs
introducing another trigger?

Marek

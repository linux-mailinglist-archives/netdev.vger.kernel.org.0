Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5732B449B0C
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 18:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233943AbhKHRt2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 12:49:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51126 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239189AbhKHRtS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 12:49:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=O1qhXOH6kc7/rA2NaHAx4cfa7PFX3+bLtDAKGxMwjVE=; b=BVnA1qvy5AIx0qIjP99u6wX5sV
        XJmRpdnOtI4hv6KrPBGcpIjDWtFACCwRsCirIDaq5weSFUCD2fKkjWwPxgjj43RKsRnHdBdnKOCBj
        9+JRgcLRYCoWDGcfhGGWemXmvooyU9Fkhwq5n8DK/Gb9Kx6jFt90flGkiK3WSNoHXdFQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mk8iw-00Cv0v-MX; Mon, 08 Nov 2021 18:46:26 +0100
Date:   Mon, 8 Nov 2021 18:46:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
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
Message-ID: <YYliclrZuxG/laIh@lunn.ch>
References: <20211108002500.19115-1-ansuelsmth@gmail.com>
 <20211108002500.19115-2-ansuelsmth@gmail.com>
 <YYkuZwQi66slgfTZ@lunn.ch>
 <YYk/Pbm9ZZ/Ikckg@Ansuel-xps.localdomain>
 <20211108171312.0318b960@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211108171312.0318b960@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Dear Ansuel,
> 
> what is the purpose of adding trigger_offload() methods to LED, if you
> are not going to add support to offload the netdev trigger? That was
> the entire purpose when I wrote that patch.
> 
> If you just want to create a new trigger that will make the PHY chip do
> the blinking, there is no need at all for the offloading patch.
> 
> And you will also get a NACK from me and also Pavel (LED subsystem
> maintainer).
> 
> The current plan is to:
> - add support for offloading existing LED triggers to HW (LED
>   controllers (PHY chips, for example))
> - make netdev trigger try offloading itself to HW via this new API (if
>   it fails, netdev trigger will blink the LED in SW as it does now)
> - create LED classdevices in a PHY driver that have the offload()
>   methods implemented. The offload method looks at what trigger is
>   being enabled for the LED, and it if it is a netdev trigger with such
>   settings that are possible to offload, it will be offloaded.
> 
>   This whole thing makes use of the existing sysfs ABI.
>   So for example if I do
>     cd /sys/class/net/eth0/phydev/leds/<LED>
>     echo netdev >trigger
>     echo eth0 >device_name
>     echo 1 >rx
>     echo 1 >tx
>   The netdev trigger is activated, and it calls the offload() method.
>   The offload() method is implemented in the PHY driver, and it checks
>   that it can offload these settings (blink on rx/tx), and will enable
>   this.
> - extend netdev trigger to support more settings:
>   - indicate link for specific link modes only (for example 1g, 100m)
>   - ...
> - extend PHY drivers to support offloading of these new settings
> 
> Marek

Hi Marek

The problem here is, you are not making much progress. People are
giving up on you ever getting this done, and doing their own
implementation. Ansuel code is not mature enough yet, it has problems,
but he is responsive, he is dealing with comments, progress is being
made. At some point, it is going to be good enough, and it will get
merged, unless you actual get your code to a point it can be merged.

	Andrew
